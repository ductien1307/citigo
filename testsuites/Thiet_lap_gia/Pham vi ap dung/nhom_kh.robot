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
&{invoice_1}      TP005=1    TP006=2

*** Test Cases ***     SP-SL              Mã kh       Khách tt      Bảng giá
Tạo hóa đơn
                      [Tags]        BGPV
                      [Template]    ebgpv5
                      [Documentation]   Tạo hóa đơn với bảng giá theo Nhóm khách hàng
                      ${invoice_1}        PVKH004      50000        Bảng giá kh 1

Verify bảng giá với khách hàng khác
                      [Tags]        BGPV
                      [Template]    ebgpv6
                      [Documentation]   Tạo bảng giá theo Nhóm kh > check xem nhóm kh khác có hiển thị bảng giá không
                      Bảng giá kh 1    CTKH001

*** Keywords ***
ebgpv5
    [Arguments]      ${dict_product_num}     ${input_bh_ma_kh}    ${input_bh_khachtt}      ${input_banggia}
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    # Input data into BH form
    ${get_id_banggia}    Get price book id   ${input_banggia}
    ${result_tongtienhang}    Get total sale incase choose price book        ${input_banggia}    ${list_product}    ${list_nums}
    Input Khach Hang    ${input_bh_ma_kh}
    ${result_banggia}       Get Text        ${dropdownlist_banggia}
    Should Be Equal As Strings       ${result_banggia}      Bảng giá chung
    Select Bang gia    ${input_banggia}
    #
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}     IN ZIP    ${list_product}    ${list_nums}
    \    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_tongtienhang}    ${input_bh_khachtt}
    Input customer payment and validate    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${result_tongtienhang}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Assert values by invoice code until succeed    ${invoice_code}    ${result_tongtienhang}    ${result_tongtienhang}    ${input_bh_ma_kh}    ${actual_khachtt}    0     Hoàn thành
    Assert price book in invoice detail    ${invoice_code}    ${input_banggia}
    Delete invoice by invoice code    ${invoice_code}

ebgpv6
    [Arguments]       ${input_ten_banggia}        ${input_bh_ma_kh}
    Input Khach Hang    ${input_bh_ma_kh}
    Sleep    5s
    Wait Until Page Contains Element    ${dropdownlist_banggia}    3 mins
    Click Element JS    ${dropdownlist_banggia}
    Wait Until Page Contains Element    ${textbox_banggia}    20s
    Input Text    ${textbox_banggia}    ${input_ten_banggia}
    ${item_banggia}    Format String    ${item_banggia_in_dropdow}    ${input_ten_banggia}
    Element Should Not Be Visible    ${item_banggia}
