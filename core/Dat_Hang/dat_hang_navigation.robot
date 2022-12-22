*** Settings ***
Library           SeleniumLibrary
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          ../share/imei.robot
Resource          ../share/print_preview.robot
Resource          dat_hang_page.robot
Resource          ../API/api_dathang.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../API/api_khachhang.robot

*** Variables ***
${menu_giaodich}    //li[a[text()='Giao dịch']]
${domain_dathang}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Đặt hàng']
${button_dathang_plus}    //article[contains(@class, 'headerContent')]//a[contains(text(), ' Đặt hàng')]
${button_xuly_dathang_in_mhbh}    //div[contains(@class,'header-right')]//a[@title='Xử lý đặt hàng']

*** Keywords ***
Go To Dat Hang from Menu pane
    Click Element    ${menu_giaodich}
    Click Element    ${domain_dathang}
    Click Element    ${button_dathang_plus}
    Deactivate print preview page
    Focus    ${button_close_hoadon1}
    Click Element JS    ${button_close_hoadon1}

Get list result info product - payment - debt frm order apí
    [Arguments]    ${input_customer_code}    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}    ${input_discount_order}    ${input_khtt}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_customer_code}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Run Keyword If    0 < ${input_discount_order} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_discount_order}
    ...    ELSE IF    ${input_discount_order} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_discount_order}    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_discount_order} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_order}
    ...    ELSE    Set Variable    ${input_discount_order}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_no_hientai_kh}    Minus    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    Return From Keyword        ${result_tongtienhang}    ${result_tongcong}    ${result_ggdh}    ${actual_khtt}    ${list_result_order_summary}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}
