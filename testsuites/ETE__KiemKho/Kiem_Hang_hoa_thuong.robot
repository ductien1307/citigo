*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Kiem Kho
Test Teardown     After Test
Resource          ../../core/Hang_Hoa/kiemkho_list_action.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_kiemkho.robot
Resource          ../../core/share/list_dictionary.robot

*** Variables ***
&{dict_1_kk}      PIB10024=1300.50    PIB10025=300    PIB10026=1500    PIB10027=0
&{dict_2_kk}      PIB10024=1400    PIB10025=200.50    PIB10026=150    PIB10027=0

*** Test Cases ***    Ma PK              SP kiem
Kiem n san pham_Hoanthanh
                      [Documentation]    [KK0001 tồn lớn hơn 0, kiểm nhỏ hơn], [KK0002 tồn bằng 0, kiểm lớn hơn 0], [KK0003 tồn âm, kiểm lớn hơn 0], [KKK0004 tồn lớn hơn 0, kiểm bằng 0]
                      [Tags]             EKT             EK                                                                                                                                                F
                      [Template]         etekkt_finished
                      ${dict_1_kk}

Kiem n san pham_Luutam
                      [Documentation]    [KK0001 tồn lớn hơn 0, kiểm nhỏ hơn], [KK0002 tồn bằng 0, kiểm lớn hơn 0], [KK0003 tồn âm, kiểm lớn hơn 0], [KKK0004 tồn lớn hơn 0, kiểm bằng 0]
                      [Tags]             EKT                             EK                                                                                                                           D
                      [Template]         etekkt_draft
                      ${dict_2_kk}

*** Keyword ***
etekkt_finished
    [Arguments]    ${dict_kk}
    [Documentation]    Kiểm hàng với n sản phẩm_ click Hoàn thành
    ...
    ...    - Validate UI
    ...    - Validate phiếu kiểm
    ...    - Validate thẻ kho
    [Timeout]    5 minutes
    ${ma_phieukiem}    Generate code automatically    PKK
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    ${list_prs}    Get Dictionary Keys    ${dict_kk}
    ${list_nums}    Get Dictionary Values    ${dict_kk}
    ${lastest_num}    Set Variable    0
    : FOR    ${list_pr}    ${list_num}    IN ZIP    ${list_prs}    ${list_nums}
    \    ${list_result_giavon_af_count}    ${list_result_ton_af_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${lastest_num}    Input products and nums to Inventory form then assert values    ${list_pr}    ${list_num}       ${lastest_num}
    log    ${list_prs}
    Input inventory counting code    ${ma_phieukiem}
    Sleep    2s    Wait for loading data
    ## get and assert data on UI
    ${soluong_thucte}    Set Variable    0
    ${ind}    Set Variable    -1
    : FOR    ${num}    IN    @{list_nums}
    \    ${ind}=    Evaluate    ${ind} + 1
    \    ${num_item}    Get From List    ${list_nums}    ${ind}
    \    ${soluong_thucte}    Sum    ${soluong_thucte}    ${num_item}
    ${get_total_onhand}    Get Total OnHand and convert to number
    Should Be Equal    ${get_total_onhand}    ${soluong_thucte}
    ## click submit
    #Click Element    ${button_hoanthanh_kk}
    Press Key      //body     ${F9_KEY}
    Click Agree button on inventory balancing popup
    Update data success validation
    Sleep    5s    Wait for loading data
    ### assert values thr API
    # assert giá trị trong mã phiếu kiểm
    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}    Reverse five lists    ${list_prs}
    ...    ${list_result_ton_af_count}    ${list_nums}    ${list_result_soluong_lech}    ${list_result_giatri_lech}
    ${index}    Set Variable    -1
    : FOR    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}    ${item_list_result_giatri_lech}    IN ZIP
    ...    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}
    \    ${index}=    Evaluate    ${index} + 1
    \    Get and assert info of products in inventory code    ${ma_phieukiem}    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}
    \    ...    ${item_list_result_giatri_lech}    ${index}    ${value_status_inventorycode_finished}
    # assert giá trị trong thẻ kho của hàng hóa
    : FOR    ${list_pr}    ${list_num}    ${result_so_luong_lech}    IN ZIP    ${list_prs}    ${list_nums}
    ...    ${list_result_soluong_lech}
    \    Assert values in Stock Card    ${ma_phieukiem}    ${list_pr}    ${list_num}    ${result_so_luong_lech}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}

etekkt_draft
    [Arguments]    ${dict_kk}
    [Documentation]    Kiểm hàng với n sản phẩm_ click lưu tạm
    ...
    ...    - Validate UI
    ...    - Validate phiếu kiểm
    ...    - Validate thẻ kho không tồn tại Chứng từ Mã kiểm kho
    [Timeout]    5 minutes
    ${ma_phieukiem}    Generate code automatically    PKK
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    ${list_prs}    Get Dictionary Keys    ${dict_kk}
    ${list_nums}    Get Dictionary Values    ${dict_kk}
    ${lastest_num}    Set Variable    0
    : FOR    ${list_pr}    ${list_num}    IN ZIP    ${list_prs}    ${list_nums}
    \    ${list_result_giavon_af_count}    ${list_result_ton_af_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${lastest_num}    Input products and nums to Inventory form then assert values    ${list_pr}    ${list_num}      ${lastest_num}
    log    ${list_prs}
    Input inventory counting code    ${ma_phieukiem}
    Sleep    2s    Wait for loading data
    ## get and assert data on UI
    ${soluong_thucte}    Set Variable    0
    ${ind}    Set Variable    -1
    : FOR    ${num}    IN    @{list_nums}
    \    ${ind}=    Evaluate    ${ind} + 1
    \    ${num_item}    Get From List    ${list_nums}    ${ind}
    \    ${soluong_thucte}    Sum    ${soluong_thucte}    ${num_item}
    ${get_total_onhand}    Get Total OnHand and convert to number
    Should Be Equal    ${get_total_onhand}    ${soluong_thucte}
    ## click submit
    Click Element    ${button_luutam_kk}
    Update data success validation
    Sleep    5s    Wait for loading data
    ### assert values thr API
    # assert giá trị trong mã phiếu kiểm
    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}    Reverse five lists    ${list_prs}
    ...    ${list_result_ton_af_count}    ${list_nums}    ${list_result_soluong_lech}    ${list_result_giatri_lech}
    ${index}    Set Variable    -1
    : FOR    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}    ${item_list_result_giatri_lech}    IN ZIP
    ...    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}
    \    ${index}=    Evaluate    ${index} + 1
    \    Get and assert info of products in inventory code    ${ma_phieukiem}    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}
    \    ...    ${item_list_result_giatri_lech}    ${index}    ${value_status_inventorycode_draft}
    # assert giá trị trong thẻ kho của hàng hóa
    : FOR    ${list_pr}    IN ZIP    ${list_prs}
    \    Assert values not avaiable in Stock Card    ${ma_phieukiem}    ${list_pr}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}
