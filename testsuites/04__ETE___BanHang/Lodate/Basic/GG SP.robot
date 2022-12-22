*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/lodate.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot

*** Variables ***
&{pr_nums}        LD02=3    LD03=5
&{dict_gg}        LD02=20    LD03=20000
&{dict_soluongnhap}    LD02=3    LD03=10

*** Test Cases ***    Mã KH         Mã SP - SL    SL nhập                GGSP          GGHD     Khách TT
GGSP                  [Tags]        EBLB          EBL
                      [Template]    eteld1
                      KH028         ${pr_nums}    ${dict_soluongnhap}    ${dict_gg}    25000    50000
                      KH022         ${pr_nums}    ${dict_soluongnhap}    ${dict_gg}    30       0
                      KH023         ${pr_nums}    ${dict_soluongnhap}    ${dict_gg}    0        all

*** Keywords ***
eteld1
    [Arguments]    ${input_bh_ma_kh}    ${dict_product_nums}    ${dict_slnhap}    ${dict_discount}    ${input_invoice_discount}    ${input_bh_khachtt}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${soluongnhap}    Get Dictionary Values    ${dict_slnhap}
    ${list_discọunt}    Get Dictionary Values    ${dict_discount}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_product}    ${soluongnhap}
    #lay infor kh va tinh toan
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_ton_af_ex}    Get list of total sale - result onhand - result new price after execute    ${list_product}    ${list_nums}    ${list_discọunt}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    #
    ${listl_onhand_lo_af_ex}    Create List
    : FOR    ${item_product}    ${item_num}    ${item_lo}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${list_tenlo_all}
    \    ${tiem_tonlo}    Get Onhand Lot in tab Lo - HSD frm API    ${item_product}    ${item_lo}
    \    ${item_tonlo_af_ex}    Minus    ${tiem_tonlo}    ${item_num}
    \    Append To List    ${listl_onhand_lo_af_ex}    ${item_tonlo_af_ex}
    Log Many    ${listl_onhand_lo_af_ex}
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
    Sleep    10s
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_list_lo}    ${item_num}    ${item_discount}    ${item_newprice}    IN ZIP
    ...    ${list_product}    ${list_tenlo_all}    ${list_nums}    ${list_discọunt}    ${list_result_newprice}
    \    input products and lot name to BH form    ${item_product}    ${item_list_lo}
    \    ${lastest_num}    Input nums for multi product    ${item_product}    ${item_num}    ${lastest_num}    ${cell_lastest_number}
    \    Run Keyword If    0 < ${item_discount} <100    Wait Until Keyword Succeeds    3 times    3 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    ${item_discount} > 100    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input VND discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE    Log    Ignore discount input
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
    Assert list of Onhand after execute    ${list_product}    ${list_result_ton_af_ex}
    ${list_num_instockard}    Change negative number to positive number and vice versa in List    ${list_nums}
    #Assert onhand values in stock card
    : FOR    ${item_product}    ${item_num}    ${item_onhand}    IN ZIP    ${list_product}    ${list_num_instockard}
    ...    ${list_result_ton_af_ex}
    \    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_onhand}    ${item_num}
    #Assert onhand values in tab stock card lo
    : FOR    ${item_product}    ${item_num}    ${item_onhand_lo}    ${item_list_lo}    ${item_actual_product}    IN ZIP
    ...    ${list_product}    ${list_num_instockard}    ${listl_onhand_lo_af_ex}    ${list_tenlo_all}    ${list_product}
    \    Assert values in Stock Card in tab Lo - HSD    ${invoice_code}    ${item_actual_product}    ${item_product}    ${item_onhand_lo}    ${item_num}
    \    ...    ${item_list_lo}
    #
    : FOR    ${item_product}    ${item_onhand_lo}    ${item_list_lo}    ${item_actual_product}    IN ZIP    ${list_product}
    ...    ${listl_onhand_lo_af_ex}    ${list_tenlo_all}    ${list_product}
    \    ${result_tonkho_lo}    Get Onhand Lot in tab Lo - HSD frm API    ${item_product}    ${item_list_lo}
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
