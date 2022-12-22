*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot

*** Variables ***
&{pr_nums}        LD27=6    LD28=7
&{dict_soluongnhap}    LD27=60    LD28=65
&{dict_giamoi}    LD27=63200    LD28=none
&{dict_dvt}       LD27=hộp nhỏ    LD28=chiếc

*** Test Cases ***    Mã KH         Mã SP - SL    SL nhập                Giá mới           ĐVT            GGHD     Khách TT
Thaydoigia            [Tags]        EBLU          EBL
                      [Template]    eteld2
                      KH043         ${pr_nums}    ${dict_soluongnhap}    ${dict_giamoi}    ${dict_dvt}    30000    all
                      KH044         ${pr_nums}    ${dict_soluongnhap}    ${dict_giamoi}    ${dict_dvt}    0        23000
                      KH044         ${pr_nums}    ${dict_soluongnhap}    ${dict_giamoi}    ${dict_dvt}    70       0

*** Keywords ***
eteld2
    [Arguments]    ${input_bh_ma_kh}    ${dict_product_nums}    ${dict_slnhap}    ${dict_newprice}    ${dict_unit}    ${input_invoice_discount}
    ...    ${input_bh_khachtt}
    [Tags]
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${soluongnhap}    Get Dictionary Values    ${dict_slnhap}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_product}    ${soluongnhap}
    ${list_unit}    Get Dictionary Values    ${dict_unit}
    ${list_actual_product_for_assert_onhand}    Create List
    : FOR    ${item_product}    ${item_unit}    IN ZIP    ${list_product}    ${list_unit}
    \    ${mahang_unit}    Get code unit frm API    ${item_product}    ${item_unit}
    \    ${final_product}    Set Variable If    '${item_unit}'=='cái' or '${item_unit}'=='chiếc'    ${item_product}    ${mahang_unit}
    \    Append To List    ${list_actual_product_for_assert_onhand}    ${final_product}
    \    Log Many    ${list_actual_product_for_assert_onhand}
    #lay infor kh va tinh toan
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    ${list_result_thanhtien}    ${list_result_onhand_actual_product}    ${list_result_ton_cb}    ${list_actual_num_cb}    Get list of total sale - result Onhand Actual product sale and Product Unit - actual number Unit    ${list_product}    ${list_actual_product_for_assert_onhand}
    ...    ${list_nums}    ${list_newprice}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    #
    ${list_actual_onhand_lo_af_ex}    Create List
    : FOR    ${item_actual_product}    ${item_list_lo}    ${item_product}    ${item_num}    IN ZIP    ${list_actual_product_for_assert_onhand}
    ...    ${list_tenlo_all}    ${list_product}    ${list_nums}
    \    ${tiem_tonlo}    Get Onhand Lot by unit in tab Lo - HSD frm API    ${item_actual_product}    ${item_list_lo}    ${item_product}
    \    ${item_tonlo_af_ex}    Minus    ${tiem_tonlo}    ${item_num}
    \    Append To List    ${list_actual_onhand_lo_af_ex}    ${item_tonlo_af_ex}
    Log Many    ${list_actual_onhand_lo_af_ex}
    #
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}    ${result_tongban_KH}    Computation Cong no khach hang    ${input_bh_ma_kh}    ${result_khachcantra}    ${actual_khachtt}
    #input data into BH form
    Reload Page
    Sleep    10s    #chờ đồng bộ hàng hóa
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_list_lo}    ${item_unit}    ${item_num}    ${item_newprice}    IN ZIP
    ...    ${list_product}    ${list_tenlo_all}    ${list_unit}    ${list_nums}    ${list_newprice}
    \    input products and lot name to BH form    ${item_product}    ${item_list_lo}
    \    ${lastest_num}    input unit - nums and not input prd in BH form    ${item_num}    ${item_unit}    ${lastest_num}
    \    Run Keyword If    '${item_newprice}' == 'none'    Log    ignore input new price
    \    ...    ELSE    Wait Until Keyword Succeeds    3 times    3 s    Input new price of product
    \    ...    ${item_newprice}
    #input invoice discount
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    3 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    ignore discount
    Run Keyword If    '${input_bh_khachtt}' == 'all'    Input Khach Hang    ${input_bh_ma_kh}
    ...    ELSE    Input Invoice info    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Reload Page
    Sleep    20s
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Run Keyword If    ${input_invoice_discount}==0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_invoice_discount}==0    Log    ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Assert list of Onhand after execute    ${list_actual_product_for_assert_onhand}    ${list_result_onhand_actual_product}
    ${list_num_instockard}    Change negative number to positive number and vice versa in List    ${list_actual_num_cb}
    ${list_num_instockard_lo}    Change negative number to positive number and vice versa in List    ${list_nums}
    #Assert onhand values in stock card
    : FOR    ${item_product}    ${item_num_cb}    ${item_onhand_cb}    IN ZIP    ${list_product}    ${list_num_instockard}
    ...    ${list_result_ton_cb}
    \    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_onhand_cb}    ${item_num_cb}
    #Assert onhand values in tab stock card lo
    : FOR    ${item_product}    ${item_num}    ${item_onhand_lo}    ${item_list_lo}    ${item_actual_product}    IN ZIP
    ...    ${list_product}    ${list_num_instockard_lo}    ${list_actual_onhand_lo_af_ex}    ${list_tenlo_all}    ${list_actual_product_for_assert_onhand}
    \    Assert values in Stock Card in tab Lo - HSD    ${invoice_code}    ${item_actual_product}    ${item_product}    ${item_onhand_lo}    ${item_num}
    \    ...    ${item_list_lo}
    #
    : FOR    ${item_product}    ${item_onhand_lo}    ${item_list_lo}    ${item_actual_product}    IN ZIP    ${list_product}
    ...    ${list_actual_onhand_lo_af_ex}    ${list_tenlo_all}    ${list_actual_product_for_assert_onhand}
    \    ${result_tonkho_lo}    Get Onhand Lot by unit in tab Lo - HSD frm API    ${item_actual_product}    ${item_list_lo}    ${item_product}
    \    Should Be Equal As Numbers    ${item_onhand_lo}    ${result_tonkho_lo}
    #assert khách hàng
    ${get_no_hientai_kh_af_execute}    ${get_tongban_kh_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Should Be Equal As Numbers    ${get_no_hientai_kh_af_execute}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_hientai_kh_af_execute}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_kh_af_execute}    ${result_tongban_KH}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${result_tongban_KH}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate history and debt in customer if invoice is not paid    ${input_bh_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}
    ...    ELSE    Validate history and debt in customer if invoice is paid    ${input_bh_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab in customer    ${input_bh_ma_kh}
    #assert Sổ quỹ
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    Delete invoice by invoice code    ${invoice_code}
