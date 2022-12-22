*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../core/Giao_dich/banhang_action.robot
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot

*** Variables ***
&{invoice_1}      TP007=1    TP008=2
@{discount_type_1}    dis    none
@{discount_1}     10      0


*** Test Cases ***     SP-SL          Mã kh       Khách tt      Bảng giá
Tạo hóa đơn
                      [Tags]      BGPV
                      [Documentation]   Tạo hóa đơn với bảng giá theo Chi nhánh
                      [Template]    ebgpv1
                      ${invoice_1}     PVKH002       50000        Bảng giá chi nhánh

Verify bảng giá ở CN khác
                      [Tags]      BGPV
                      [Template]    ebgpv2
                      [Documentation]   Tạo bảng giá theo chi nhánh A > check xem CN khác có hiển thị bảng giá A không
                      Bảng giá chi nhánh    Nhánh A

*** Keywords ***
ebgpv1
    [Arguments]      ${dict_product_num}    ${input_bh_ma_kh}    ${input_bh_khachtt}      ${input_banggia}
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    # Input data into BH form
    ${result_tongtienhang}    Get total sale incase choose price book        ${input_banggia}    ${list_product}    ${list_nums}
    Select Bang gia    ${input_banggia}
    #
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_product}    ${list_nums}
    \    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_tongtienhang}    ${input_bh_khachtt}
    Input Khach Hang    ${input_bh_ma_kh}
    Input customer payment and validate    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${result_tongtienhang}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Assert values by invoice code until succeed    ${invoice_code}    ${result_tongtienhang}    ${result_tongtienhang}    ${input_bh_ma_kh}    ${actual_khachtt}    0     Hoàn thành
    Assert price book in invoice detail    ${invoice_code}    ${input_banggia}
    Delete invoice by invoice code    ${invoice_code}

ebgpv2
    [Arguments]       ${input_ten_banggia}        ${input_branch}
    Switch branch in sale form    ${input_branch}
    Sleep    10s
    Wait Until Page Contains Element    ${dropdownlist_banggia}    3 mins
    Click Element JS    ${dropdownlist_banggia}
    Wait Until Page Contains Element    ${textbox_banggia}    20s
    Input Text    ${textbox_banggia}    ${input_ten_banggia}
    ${item_banggia}    Format String    ${item_banggia_in_dropdow}    ${input_ten_banggia}
    Element Should Not Be Visible    ${item_banggia}
