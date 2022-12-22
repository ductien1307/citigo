*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../config/env_product/envi.robot
Library           Collections
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
@{list_product_delete}    DVT63
@{discount}    15    20000    0    80000
@{discount_type}   dis     disvnd    none    changeup
&{list_product_tk03}    HH0060=5    SI043=2    DVT63=2.8    DV067=3    Combo44=1

*** Test Cases ***    Mã KH              Mã thu khác      Khách thanh toán    Ghi chú ĐH       List sản phẩm           List giá mới        List product to create    Khách thanh toán to create
Tudong_DH_1thukhac    [Documentation]    1. Cập nhật đơn đặt hàng được tạo qua API, xóa sản phẩm và thay đổi giá cho đơn hàng \n2. Thu khác tự động cập nhật vào đơn hàng và có 1 thu khác tính theo %\n3. Validate dữ diệu hàng hóa, công nợ khách hàng, sổ quỹ
                      [Tags]             EDTKA
                      [Template]         uetedh_ud_tk1
                      CTKH106            TK001          all                 Đã thanh toán    ${list_product_delete}    ${discount}    ${discount_type}    ${list_product_tk03}    0

*** Keywords ***
uetedh_ud_tk1
    [Arguments]    ${input_ma_kh}    ${input_thukhac}    ${input_khtt}    ${input_ghichu}    ${list_product}    ${list_discount}
    ...    ${list_discount_type}    ${dict_product_nums}    ${input_khtt_create}
    #get info to validate
    ${order_code}    Add new order have surcharge    ${input_ma_kh}    ${dict_product_nums}    ${input_thukhac}    ${input_khtt_create}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #get order summary and sub total of products
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product}
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_soluong_in_dh}    ${list_tong_dh}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${get_list_hh_in_dh_bf_execute}
    ${list_result_thanhtien}    Create List
    ${list_result_giamoi}    Create List
    : FOR    ${get_soluong_in_dh}    ${item_ggsp}   ${discount_type}   ${item_baseprice}    IN ZIP    ${list_soluong_in_dh}    ${list_discount}
    ...    ${list_discount_type}    ${get_list_baseprice}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${item_ggsp}
    \    ...    ELSE     Set Variable    ${item_baseprice}
    \    ${result_thanhtien}    Multiplication with price round 2    ${get_soluong_in_dh}    ${result_giamoi}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    #create list
    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra_no_surchare}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${result_surcharge}    Convert % discount to VND and round    ${result_khachcantra_no_surchare}    ${surcharge_%}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${result_surcharge}
    ${result_khachcantra}    Sum and replace floating point    ${result_surcharge}    ${result_khachcantra_no_surchare}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    #delete product into BH form
    Delete list product into BH form    ${list_product}
    : FOR    ${item_product}    ${item_ggsp}    ${item_result_newprice}   ${item_discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_discount}    ${list_result_giamoi}
    ...    ${list_discount_type}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_result_newprice}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_result_newprice}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    ${input_khtt}!=0    Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Sleep    2s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_tong_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang_tovalidate}    S
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
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
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false
    Delete order frm Order code    ${get_ma_dh}
