*** Settings ***
Suite Setup       Init Test Environment    NT    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/lodate.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Nha_Thuoc/don_thuoc_popup_action.robot

*** Variables ***
&{pr_nums}        T00009=3    T00010=5
@{list_gg}        20    120000
@{list_gg_type}        dis    changeup
@{list_soluongnhap}    3    10

*** Test Cases ***    Mã KH         Mã SP - SL    SL nhập                GGSP             GG Type         GGHD     Khách TT     Tên bsy           Cơ sở kb          Tên bệnh nhân     Tuổi    Giới tính     Cân nặng        CMT         Thẻ BHYT        Địa chỉ      Người giám hộ      Sdt             Chẩn đoán
Ko ban theo don                  [Tags]       EBNT
                      [Template]    ebt1
                      KH001         ${pr_nums}    ${list_soluongnhap}    ${list_gg}   ${list_gg_type}     25000    50000

Ban theo don thuoc               [Tags]       EBNT
                      [Template]    ebt2
                      KH002         ${pr_nums}    ${list_soluongnhap}    ${list_gg}   ${list_gg_type}     25000    50000      Nguyễn Văn Cương      BV Bạch Mai       Đào Thị Loan       59         Nữ         55 kg         3455345     3423432fdg      Hà Nội      Phạm Thị Ngân       09545645644       Đau dạ dày

*** Keywords ***
ebt1
    [Arguments]    ${input_bh_ma_kh}    ${dict_product_nums}    ${list_slnhap}    ${list_discount}      ${list_discount_type}    ${input_invoice_discount}    ${input_bh_khachtt}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_product}    ${list_slnhap}
    #lay infor kh va tinh toan
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    ${list_result_ton_af_ex}    Get list of result onhand incase changing product price    ${list_product}    ${list_nums}
    ${list_result_thanhtien}    ${list_result_newprice}       Get list of total sale - result new price incase changing product price     ${list_product}    ${list_nums}    ${list_discount}    ${list_discount_type}
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
    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}    ${result_tongban_KH}    ${result_tongban_tru_trahang}    Computation Cong no khach hang    ${input_bh_ma_kh}    ${result_khachcantra}    ${actual_khachtt}
    #input data into BH form
    Reload Page
    Sleep    10s
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_list_lo}    ${item_num}    ${item_discount}    ${item_newprice}    ${item_discount_type}    IN ZIP
    ...    ${list_product}    ${list_tenlo_all}    ${list_nums}    ${list_discount}    ${list_result_newprice}    ${list_discount_type}
    \    input products and lot name to BH form    ${item_product}    ${item_list_lo}
    \    ${lastest_num}    Input nums for multi product    ${item_product}    ${item_num}    ${lastest_num}    ${cell_lastest_number}
    \    Run Keyword If    '${item_discount_type}'=='dis'   Wait Until Keyword Succeeds    3 times    3 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}'=='disvnd'    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input VND discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE    Wait Until Keyword Succeeds    3 times    3s    Input new price of product
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
    Sleep    15s
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

ebt2
    [Arguments]    ${input_bh_ma_kh}    ${dict_product_nums}    ${list_slnhap}    ${list_discount}      ${list_discount_type}    ${input_invoice_discount}    ${input_bh_khachtt}     ${input_bskd}     ${input_cskb}       ${input_tenbn}      ${input_tuoibn}     ${input_gioitinh}     ${input_cannang}      ${input_cmt}      ${input_the_bhyt}     ${input_diachi}    ${input_nguoigiamho}    ${input_sdt}     ${input_chandoan}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_product}    ${list_slnhap}
    #lay infor kh va tinh toan
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    ${list_result_ton_af_ex}    Get list of result onhand incase changing product price    ${list_product}    ${list_nums}
    ${list_result_thanhtien}    ${list_result_newprice}       Get list of total sale - result new price incase changing product price     ${list_product}    ${list_nums}    ${list_discount}    ${list_discount_type}
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
    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}    ${result_tongban_KH}    ${result_tongban_tru_trahang}    Computation Cong no khach hang    ${input_bh_ma_kh}    ${result_khachcantra}    ${actual_khachtt}
    #input data into BH form
    Reload Page
    Sleep    10s
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_list_lo}    ${item_num}    ${item_discount}    ${item_newprice}    ${item_discount_type}    IN ZIP
    ...    ${list_product}    ${list_tenlo_all}    ${list_nums}    ${list_discount}    ${list_result_newprice}    ${list_discount_type}
    \    input products and lot name to BH form    ${item_product}    ${item_list_lo}
    \    ${lastest_num}    Input nums for multi product    ${item_product}    ${item_num}    ${lastest_num}    ${cell_lastest_number}
    \    Run Keyword If    '${item_discount_type}'=='dis'   Wait Until Keyword Succeeds    3 times    3 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}'=='disvnd'    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input VND discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE    Wait Until Keyword Succeeds    3 times    3s    Input new price of product
    \    ...    ${item_newprice}
    #input invoice discount
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    3 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    ignore discount
    Run Keyword If    '${input_bh_khachtt}' == 'all'    Input Khach Hang    ${input_bh_ma_kh}
    ...    ELSE    Input Invoice info    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${result_khachcantra}
    Click Ban thuoc theo don and open popup
    ${input_madonthuoc}     Generate code automatically    DT
    Input data in popup Ban thuoc theo don      ${input_madonthuoc}     ${input_bskd}     ${input_cskb}     ${input_tenbn}      ${input_tuoibn}     ${input_gioitinh}     ${input_cannang}      ${input_cmt}      ${input_the_bhyt}     ${input_diachi}    ${input_nguoigiamho}    ${input_sdt}     ${input_chandoan}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Reload Page
    Sleep    15s
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
    #asset thong tin don thuoc
    ${get_madonthuoc}    ${get_bskd}    ${get_cskb}    ${get_tenbn}    ${get_tuoibn}   ${get_gioitinh}     ${get_cannang}      ${get_cmt}      ${get_bhyt}   ${get_diachi}   ${get_nguoigiamho}    ${get_sdt}    ${get_chandoan}     Get Thong tin don thuoc from invoice code   ${invoice_code}
    Should Be Equal As Strings    ${get_madonthuoc}    ${input_madonthuoc}
    Should Be Equal As Strings    ${get_bskd}    ${input_bskd}
    Should Be Equal As Strings    ${get_cskb}    ${input_cskb}
    Should Be Equal As Strings    ${get_tenbn}    ${input_tenbn}
    Should Be Equal As Strings    ${get_tuoibn}    ${input_tuoibn}
    Run Keyword If    '${input_gioitinh}'=='Nữ'    Should Be Equal As Strings    ${get_gioitinh}    False     ELSE       Should Be Equal As Strings    ${get_gioitinh}    True
    Should Be Equal As Strings    ${get_cannang}    ${input_cannang}
    Should Be Equal As Strings    ${get_cmt}    ${input_cmt}
    Should Be Equal As Strings    ${get_bhyt}    ${input_the_bhyt}
    Should Be Equal As Strings    ${get_diachi}    ${input_diachi}
    Should Be Equal As Strings    ${get_nguoigiamho}    ${input_nguoigiamho}
    Should Be Equal As Strings    ${get_sdt}    ${input_sdt}
    Should Be Equal As Strings    ${get_chandoan}    ${input_chandoan}
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
