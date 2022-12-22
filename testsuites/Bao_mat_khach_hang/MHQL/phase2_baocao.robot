*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/Bao_cao/bc_cuoi_ngay_list_action.robot
Resource          ../../../core/Bao_cao/bc_dat_hang_list_action.robot
Resource          ../../../core/Bao_cao/bc_hang_hoa_list_action.robot
Resource          ../../../core/Bao_cao/bc_khach_hang_list_action.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/constants.robot
Resource          ../../../core/API/api_mhbh_dathang.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot

*** Test Cases ***
So quy - phieu thu
    [Documentation]     tim kiem phieu thu trong so quy bang thong tin khach hang
    [Timeout]    5 mins
    [Tags]    KYC2
    [Template]     Tim kiem phieu thu
    BMKH02    Khác    20000    phiếu tạo từ auto

So quy - phieu chi
    [Documentation]     tim kiem hoa don trong bao cao cuoi ngay bang sdt khach hang
    [Timeout]    5 mins
    [Tags]    KYC2
    [Template]     Tim kiem phieu chi
    BMKH02    Khác    -20000    phiếu tạo từ auto

Bao cao - bao cao cuoi ngay
    [Documentation]     loc bao cao theo thong tin khach hang
    [Timeout]    5 mins
    [Tags]    KYC2
    [Template]     Tim kiem hoa don bang sdt khach hang trong bao cao cuoi ngay
    BMKH02    HHBM03    1.5    25000

Bao cao - bao cao dat hang
    [Documentation]     loc bao cao theo thong tin khach hang
    [Timeout]    5 mins
    [Tags]    KYC2
    [Template]     Tim kiem bang sdt khach hang trong bc dat hang
    BMKH02    HHBM03    1.5    25000

Bao cao - bao cao hang hoa
    [Documentation]     loc bao cao theo thong tin khach hang
    [Timeout]    5 mins
    [Tags]    KYC2
    [Template]     Tim kiem bang sdt khach hang trong bao cao hang hoa
    BMKH02    HHBM03    1.5    25000

Bao cao - bao cao khach hang
    [Documentation]     loc bao cao theo thong tin khach hang
    [Timeout]    5 mins
    [Tags]    KYC2
    [Template]     Tim kiem bang sdt trong bc theo khach hang
    BMKH02    HHBM03    1.5    25000

*** Keywords ***
Tim kiem phieu thu
    [Arguments]    ${customer_code}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${ma_phieu}    Add cash flow in tab Tien mat for customer and not used for financial reporting    ${customer_code}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to So quy
    Select Customer option on form receiver/payer and search transaction by customer info    ${textbox_ten_ma_khach_hang}    ${customer_code}
    Validate transaction by customer info    ${ma_phieu}    ${customer_code}    ${get_ten_kh}    ${get_dienthoai_kh}
    Select Customer option on form receiver/payer and search transaction by customer info    ${textbox_ten_ma_khach_hang}    ${get_ten_kh}
    Validate transaction by customer info    ${ma_phieu}    ${customer_code}    ${get_ten_kh}    ${get_dienthoai_kh}
    Select Customer option on form receiver/payer and search transaction by customer info    ${textbox_sdt_khach_hang}    ${get_dienthoai_kh}
    Validate transaction by customer info    ${ma_phieu}    ${customer_code}    ${get_ten_kh}    ${get_dienthoai_kh}
    Delete payment for cutomer not used for financial reporting thr API    ${ma_phieu}
    Delete customer    ${get_id_kh}

Tim kiem phieu chi
    [Arguments]    ${customer_code}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${ma_phieu}    Add cash flow in tab Tien mat for customer and not used for financial reporting    ${customer_code}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to So quy
    Select Customer option on form receiver/payer and search transaction by customer info    ${textbox_ten_ma_khach_hang}    ${customer_code}
    Validate transaction by customer info    ${ma_phieu}    ${customer_code}    ${get_ten_kh}    ${get_dienthoai_kh}
    Select Customer option on form receiver/payer and search transaction by customer info    ${textbox_ten_ma_khach_hang}    ${get_ten_kh}
    Validate transaction by customer info    ${ma_phieu}    ${customer_code}    ${get_ten_kh}    ${get_dienthoai_kh}
    Select Customer option on form receiver/payer and search transaction by customer info    ${textbox_sdt_khach_hang}    ${get_dienthoai_kh}
    Validate transaction by customer info    ${ma_phieu}    ${customer_code}    ${get_ten_kh}    ${get_dienthoai_kh}
    Delete payment for cutomer not used for financial reporting thr API    ${ma_phieu}
    Delete customer    ${get_id_kh}

Tim kiem hoa don bang sdt khach hang trong bao cao cuoi ngay
    [Arguments]    ${customer_code}     ${ma_hang}    ${input_soluong}    ${input_khtt}
    ${get_pro_id}    Get product id thr API    ${ma_hang}
    Run Keyword If    '${get_pro_id}'!='0'    Delete product thr API    ${ma_hang}
    ${ten_hang}    ${ten_nhom}    Add product by generated info automatically    ${ma_hang}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${inv_code}    Add new invoice with product    ${customer_code}    ${ma_hang}    ${input_soluong}    ${input_khtt}
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to BC cuoi ngay
    #baos cao cuoi ngay: ban hang
    Wait Until Page Contains Element    ${textbox_bccn_khachhang}    30s
    Input Text    ${textbox_bccn_khachhang}    ${get_dienthoai_kh}
    Validate Sales info by customer info    ${inv_code}
    #bao caocuoi ngya: thu chi
    Wait Until Element Is Visible    ${radio_button_thu_chi}    30s
    Click Element    ${radio_button_thu_chi}
    Validate Receipt/Payment info    ${inv_code}    ${input_khtt}
    Delete invoice by invoice code    ${inv_code}
    Delete customer    ${get_id_kh}
    Delete product thr API    ${ma_hang}
    Delete category thr API    ${ten_nhom}

Tim kiem bang sdt khach hang trong bc dat hang
    [Arguments]    ${customer_code}     ${ma_hang}    ${input_soluong}    ${input_khtt}
    ${get_pro_id}    Get product id thr API    ${ma_hang}
    Run Keyword If    '${get_pro_id}'!='0'    Delete product thr API    ${ma_hang}
    ${ten_hang}    ${ten_nhom}    Add product by generated info automatically    ${ma_hang}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${order_code}    Add new order frm API    ${customer_code}    ${ma_hang}    ${input_soluong}    ${input_khtt}
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to BC dat hang
    Wait Until Page Contains Element    ${textbox_bcdh_khachhang}    30s
    Input Text    ${textbox_bcdh_khachhang}    ${get_dienthoai_kh}
    #bao cao dat hang: giao dich
    Select report with transaction
    Validate transaction table    ${order_code}
    #bao cao dat hang: hang hoa
    Validate product table    ${order_code}
    Delete order frm Order code    ${order_code}
    Delete customer    ${get_id_kh}
    Delete product thr API    ${ma_hang}
    Delete category thr API    ${ten_nhom}

Tim kiem bang sdt khach hang trong bao cao hang hoa
    [Arguments]    ${customer_code}     ${ma_hang}    ${input_soluong}    ${input_khtt}
    ${get_pro_id}    Get product id thr API    ${ma_hang}
    Run Keyword If    '${get_pro_id}'!='0'    Delete product thr API    ${ma_hang}
    ${ten_hang}    ${ten_nhom}    Add product by generated info automatically    ${ma_hang}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${inv_code}    Add new invoice with product    ${customer_code}    ${ma_hang}    ${input_soluong}    ${input_khtt}
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to BC hang hoa
    Wait Until Element Is Visible    ${radiobutton_khach_theo_hang_ban}    5s
    Click Element    ${radiobutton_khach_theo_hang_ban}
    Wait Until Element Is Visible    ${textbox_khach_hang}    5s
    Input Text    ${textbox_khach_hang}    ${get_dienthoai_kh}
    ${str_hang_hoa}    Format String    ${hang_hoa}    ${ma_hang}
    Wait Until Element Is Visible    ${str_hang_hoa}    5s
    Delete invoice by invoice code    ${inv_code}
    Delete customer    ${get_id_kh}
    Delete product thr API    ${ma_hang}
    Delete category thr API    ${ten_nhom}

Tim kiem bang sdt trong bc theo khach hang
    [Arguments]    ${customer_code}     ${ma_hang}    ${input_soluong}    ${input_khtt}
    ${get_pro_id}    Get product id thr API    ${ma_hang}
    Run Keyword If    '${get_pro_id}'!='0'    Delete product thr API    ${ma_hang}
    ${ten_hang}    ${ten_nhom}    Add product by generated info automatically    ${ma_hang}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${inv_code}    Add new invoice with product    ${customer_code}    ${ma_hang}    ${input_soluong}    ${input_khtt}
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to BC khach hang
    Wait Until Element Is Visible    ${radio_baocao}
    Click Element    ${radio_baocao}
    Input Type Flex    ${textbox_bckh_tk_khachhang}    ${get_dienthoai_kh}
    Press Key    ${textbox_bckh_tk_khachhang}    ${ENTER_KEY}
    Sleep    5s
    ${str_ma_kh}    Format String    ${get_ten_ma_kh}    ${customer_code}
    ${str_ten_kh}    Format String    ${get_ten_ma_kh}    ${get_ten_kh}
    Wait Until Element Is Visible    ${str_ma_kh}
    Wait Until Element Is Visible    ${str_ten_kh}
    Delete invoice by invoice code    ${inv_code}
    Delete customer    ${get_id_kh}
    Delete product thr API    ${ma_hang}
    Delete category thr API    ${ten_nhom}
