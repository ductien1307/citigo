*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test turning on display mode      ${toggle_item_themdong}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{list_product1}    HH0001=4    SI001=2    DVT01=1.5    DV001=5    Combo01=2.4
&{list_product2}    HH0002=1    SI002=2    QDKL002=3    DV002=1.5    Combo02=2.5
&{list_product3}    HH0003=1    SI003=2    DVT03=4    DV003=1.5    Combo03=1.8
@{discount}           0    4000    200000.67    50000   20
@{discount_type}      none    disvnd    changeup    changedown       dis
@{list_soluong_addrow}   5,4        2           3.5,1.8,2     3     1.5,2
@{discount_addrow}   25000,10     80000.55     8,400000,0     15000     0,100000
@{discount_type_addrow}  disvnd,dis    changedown   dis,changeup,none   disvnd  none,changedown

*** Test Cases ***    Mã KH         List product&nums    GGSP       List type discount    List nums add row             GGSP add row       List type discount add row      GGDH       Khách TT
Tao_moi_dh_golive      [Tags]       UEDM
                      [Template]    etedh_inv_multirow16
                      CTKH010       ${list_product1}     ${discount}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}      0          all

Tao_moi_dh              [Tags]       UEDM
                      [Template]    etedh_inv_multirow16
                      CTKH011       ${list_product2}     ${discount}    ${discount_type}    ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}     100000      500000
                      CTKH012       ${list_product3}     ${discount}    ${discount_type}    ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}     20         0

Tao_moi_dh_them_50_dong              [Tags]      UEDM
                      [Template]    etedh_inv_multirow17
                      CTKH013       HH0005    2     400000

*** Keywords ***
etedh_inv_multirow16
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${list_ggsp}    ${list_discount_type}   ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...       ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_result_ordersummary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${list_result_thanhtien_addrow}    ${list_result_giamoi_addrow}    ${list_result_order_summary}    Get list total sale - order summary - newprice incase add row product    ${list_product}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_ordersummary}
    ${get_list_id_product}    Get list product id thr API    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum and round     ${result_tongtienhang}    ${result_tongtienhang_addrow}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_no_hientai_kh}    Minus    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    Reload Page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${result_giamoi}    ${discount_type}       ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}
    ...   ${discount_type_addrow}   ${product_id}    IN ZIP    ${list_product}    ${list_nums}   ${list_ggsp}  ${list_result_giamoi}   ${list_discount_type}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_giamoi_addrow}   ${list_type_discount_addrow}    ${get_list_id_product}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    \     ${laster_nums}    Add row product incase multi product in MHBH    ${item_product}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}        ${laster_nums}    ${cell_tongsoluong_dh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount order    ${input_ggdh}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_tongcong}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_bh_dathang}
    Sleep   2s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Run Keyword If    ${input_ggdh} == 0    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Run Keyword If    ${input_ggdh} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${get_ma_dh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${get_ma_dh}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${get_ma_dh}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info if Order is not paid    ${get_ma_dh}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khtt}
    Delete order frm Order code    ${get_ma_dh}

etedh_inv_multirow17
    [Arguments]    ${input_ma_kh}    ${product}    ${nums}   ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_product}    ${get_baseprice}    Get product name and price frm API    ${product}
    ${get_order_summary}    Get order summary frm product API    ${product}
    ${result_tongso_dh}    Sum x 3   ${get_order_summary}    ${nums}    50
    ${result_thanhtien}    Multiplication and round    ${get_baseprice}    ${nums}
    ${result_thanhtien_addrow}    Multiplication and round    ${get_baseprice}    50
    #compute
    ${result_tongtienhang}    Sum and round     ${result_thanhtien}    ${result_thanhtien_addrow}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_no_hientai_kh}    Minus    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${lastest_nums}    Set Variable    0
    ${lastest_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${product}    ${nums}    ${lastest_nums}    ${cell_tongsoluong_dh}
    ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${product}
     : FOR    ${item}    IN RANGE    50
     \   Wait Until Element Is Visible    ${button_add_row_infirstline}
     \   Click Element JS    ${button_add_row_infirstline}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}    ELSE    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_tongtienhang}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_bh_dathang}
    Sleep   2s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${order_summary_af_execute}    Get order summary frm product API    ${product}
    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tongso_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Delete order frm Order code    ${get_ma_dh}
