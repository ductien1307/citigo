*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Kiem Kho
Test Teardown     After Test
Library           String
Resource          ../../core/Hang_Hoa/kiemkho_list_action.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_kiemkho.robot
Resource          ../../core/share/imei.robot
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/API/lodate.robot
Resource          ../../core/API/api_dathangnhap.robot

*** Variables ***
&{dict_imei_1}       KKLD01=2,3.2,5    KKLD01=3,4    KKLD03=1,2.5    KKQD04=3    KKQD05=5.5

*** Test Cases ***    dictionary
Tao DL mau
      [Tags]     LKK            ULODA
      [Template]    Add du lieu kk
      lodate_unit    KKLD01     DHC ADLAY EXTRA      trackingld    70000    5000    none    none    none    none    none    Chiếc     KKQD01    140000    Thùng    4
      lodate_unit    KKLD02     son BBIA màu 04        trackingld    75000    5000    none    none    none    none    none    Quyển     KKQD02    140000    Thùng    2
      lodate_unit    KKLD03     Son merzy màu 01      trackingld    70000    5000    none    none    none    none    none    Chiếc     KKQD03    140000    Thùng    7
      lodate_unit    KKLD04     son BBIA màu 05       trackingld    75000    5000    none    none    none    none    none    Tuýp     KKQD04    140000    Thùng    6
      lodate_unit    KKLD05     Son merzy màu 02     trackingld    70000    5000    none    none    none    none    none    Chiếc     KKQD05    140000    Thùng    5

Kiem hang hoa_Luutam
                      [Tags]        LKK            ULODA
                      [Documentation]    Kiểm kho với 1 sp nhều lô tồn tại trong hệ thống, lưu tạm
                      [Template]    kk_lodate_draft
                      ${dict_imei_1}

Kiem hang hoa_Hoanthanh
                      [Documentation]    Kiểm kho với 1 sp nhều lô tồn tại trong hệ thống, hoàn thành
                      [Tags]        LKK            ULODA
                      [Template]    kk_lodate_finished
                      ${dict_imei_1}

*** Keyword ***
Add du lieu kk
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

kk_lodate_draft
    [Arguments]    ${dict}
    [Documentation]    Kiểm hàng với n sản phẩm_ click lưu tạm
    ...
    ...    - Validate UI
    ...    - Validate phiếu kiểm
    ...    - Validate thẻ kho không tồn tại Chứng từ Mã kiểm kho
    ...    - Validate lô có tồn tại trong hệ thống
    [Timeout]
    ${ma_phieukiem}    Generate code automatically    PKK
    ${list_pr}    Get Dictionary Keys    ${dict}
    ${list_nums}    Get Dictionary Values    ${dict}
    ## Màn hình kiểm kho, input hàng hóa + lô
    Wait Until Keyword Succeeds    3 times    1s    Go to Inventory form
    ${list_result_giavon_bf_count}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_system_imei_by_product_bf_counted}    ${list_actual_nums}
    ...    Input products and lots in Inventory form then assert values      ${dict}    @{list_pr}
    ###
    Input inventory counting code    ${ma_phieukiem}
    ## get and assert data on UI
    Get and assert data on UI Inventory    ${list_actual_nums}
    ## click submit
    Click Element    ${button_luutam_kk}
    Update data success validation
    ### assert values thr API
    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}    ${list_reversed_imei_by_product_onrow}    ${list_reversed_actual_nums}    Reverse six lists
    ...    ${list_pr}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_actual_nums}
    ${index_in_list}    Set Variable    -1
    : FOR    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}    ${item_giatri_lech}    ${item_reversed_imei_by_product_onrow}
    ...    IN ZIP    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_actual_nums}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}
    ...    ${list_reversed_imei_by_product_onrow}
    \    ${index_in_list}    Evaluate    ${index_in_list} + 1
    \    Get and assert info of lots in Inventory    ${ma_phieukiem}    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}
    \    ...    ${item_giatri_lech}    ${index_in_list}    ${value_status_inventorycode_draft}    ${item_reversed_imei_by_product_onrow}
    ###
    : FOR    ${item_product}    IN    @{list_pr}
    \    Assert values not avaiable in Stock Card    ${ma_phieukiem}    ${item_product}
    ${index_list_imei}    Set Variable    -1
    : FOR    ${item_product}    ${list_imei_bf_counted}    IN ZIP    ${list_pr}    ${list_system_imei_by_product_bf_counted}
    \    ${index_list_imei}    Evaluate    ${index_list_imei} + 1
    \    ${list_imei_bf_counted}    Set Variable    @{list_system_imei_by_product_bf_counted}[${index_list_imei}]
    \    Assert lot avaiable in Lo-HSD tab    ${item_product}    ${list_imei_bf_counted}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}

kk_lodate_finished
    [Arguments]    ${dict}
    [Documentation]    Kiểm hàng click hoàn thành
    ...
    ...    - Validate UI
    ...    - Validate phiếu kiểm
    ...    - Validate thẻ kho tồn tại Chứng từ Mã kiểm kho, validate tồn kho lô
    [Timeout]
    ${ma_phieukiem}    Generate code automatically    PKK
    ${list_pr}    Get Dictionary Keys    ${dict}
    ## get data
    Wait Until Keyword Succeeds    3 times    3 s    Go to Inventory form
    ${list_result_giavon_bf_count}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_system_imei_by_product_bf_counted}    ${list_actual_nums}
    ...    Input products and lots in Inventory form then assert values      ${dict}    @{list_pr}
    ###
    Input inventory counting code    ${ma_phieukiem}
    ## get and assert data on UI
    Get and assert data on UI Inventory    ${list_actual_nums}
    ## click submit
    Press Key      //body     ${F9_KEY}
    Click Agree button on inventory balancing popup
    Update data success validation
    ### assert values thr API
    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}    ${list_reversed_imei_by_product_onrow}    ${list_reversed_actual_nums}    Reverse six lists
    ...    ${list_pr}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_actual_nums}
    ${index_in_list}    Set Variable    -1
    : FOR    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}    ${item_giatri_lech}    ${item_reversed_imei_by_product_onrow}
    ...    IN ZIP    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_actual_nums}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}
    ...    ${list_reversed_imei_by_product_onrow}
    \    ${index_in_list}    Evaluate    ${index_in_list} + 1
    \    Get and assert info of lots in Inventory    ${ma_phieukiem}    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}
    \    ...    ${item_giatri_lech}    ${index_in_list}    ${value_status_inventorycode_finished}    ${item_reversed_imei_by_product_onrow}
    ##
    : FOR    ${item_product}    ${item_actual_num}    ${item_soluong_lech}    IN ZIP    ${list_pr}    ${list_actual_nums}
    ...    ${list_result_soluong_lech}
    \    Assert values in Stock Card of unit prs    ${ma_phieukiem}    ${item_product}    ${item_actual_num}    ${item_soluong_lech}
    ### assert imei in lo tab
    : FOR    ${item_product}    ${items_counted_imei_by_product}    IN ZIP    ${list_pr}    ${list_counted_imei_by_product_onrow}
    \    ${items_counted_imei_by_product}    Convert String to List    ${items_counted_imei_by_product}
    \    Wait Until Keyword Succeeds    3x    3s    Assert lot avaiable in Lo-HSD tab    ${item_product}    ${items_counted_imei_by_product}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}
