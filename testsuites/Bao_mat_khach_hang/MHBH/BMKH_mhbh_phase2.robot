*** Settings ***
Suite Setup       Init Test Environment Before Test Ban Hang Co API    ${env}    ${remote}    ${account}    ${headless_browser}
Suite Teardown    Close Browser
Test Timeout      3 minutes
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/Doi_tac/khachhang_list_action.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_mhbh_dathang.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/constants.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/global.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot

*** Test Cases ***
Tim kiem khach hang
    [Documentation]     KYC - MHBH - TÌM KIẾM KHÁCH HÀNG THEO SĐT
    [Tags]              KYC2  CTP
    [Template]          Tim kiem khach hang theo sdt
    BMKH03

Tim kiem khach hang tai form xu ly dat hang
    [Documentation]     KYC - MHBH - TÌM KIẾM KHÁCH HÀNG Ở FORM XỬ LÝ ĐẶT HÀNG
    [Tags]              KYC2  CTP
    [Template]          Tim kiem khach hang o form xu ly dat hang
    BMKH03    HHBM02    1.88    25000

Tim kiem khach hang tai form tra hang
    [Documentation]     KYC - MHBH - TÌM KIẾM KHÁCH HÀNG Ở FORM TRẢ HÀNG
    [Tags]              KYC2  CTP
    [Template]          Tim kiem khach hang o form tra hang
    BMKH03    HHBM02    1.88    25000

Tim kiem khach hang tai form lap phieu thu
    [Documentation]     KYC - MHBH - TÌM KIẾM KHÁCH HÀNG Ở FORM LẬP PHIẾU THU
    [Tags]              KYC2  CTP
    [Template]          Tim kiem khach hang o form lap phieu thu
    BMKH03

Them moi khach hang o mhbh
    [Documentation]     KYC - MHBH - THÊM MỚI KHÁCH HÀNG
    [Tags]              KYC2  CTP
    [Template]          Them moi khach hang
    BMKH03

Cap nhat khach hang o mhbh
    [Documentation]     KYC - MHBH - CẬP NHẬT KHÁCH HÀNG
    [Tags]              KYC2  CTP
    [Template]          Cap nhat khach hang
    BMKH03

*** Keywords ***
Tim kiem khach hang theo sdt
    [Arguments]    ${customer_code}
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    Input Type Flex    ${textbox_bh_search_khachhang}    ${get_dienthoai_kh}
    Click Element JS    ${cell_khachhang}
    Wait Until Element Is Visible    ${thongtin_khachhang}
    Wait Until Element Is Visible    ${button_xoa_khach_hang}
    Click Element JS    ${button_xoa_khach_hang}
    Delete customer    ${get_id_kh}

Tim kiem khach hang o form xu ly dat hang
    [Arguments]    ${customer_code}     ${ma_hang}    ${input_soluong}    ${input_khtt}
    ${get_pro_id}    Get product id thr API    ${ma_hang}
    Run Keyword If    '${get_pro_id}'!='0'    Delete product thr API    ${ma_hang}
    ${ten_hang}    ${ten_nhom}    Add product by generated info automatically    ${ma_hang}
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${order_code}    Add new order frm API    ${customer_code}    ${ma_hang}    ${input_soluong}    ${input_khtt}
    Go to any menu    ${cell_xuly_dathang}
    Wait To Loading Icon Invisible
    Input Type Flex     ${textbox_xldh_kh}    ${get_dienthoai_kh}
    ${str_ma_don_dat_hang}    Format String       ${cell_ma_don_dat_hang}    ${order_code}
    Wait Until Page Contains Element    ${str_ma_don_dat_hang}     1 mins
    Click To Close Form
    Delete product thr API    ${ma_hang}
    Delete customer    ${get_id_kh}
    Delete category thr API    ${ten_nhom}

Tim kiem khach hang o form tra hang
    [Arguments]    ${customer_code}     ${ma_hang}    ${input_soluong}    ${input_khtt}
    ${get_pro_id}    Get product id thr API    ${ma_hang}
    Run Keyword If    '${get_pro_id}'!='0'    Delete product thr API    ${ma_hang}
    ${ten_hang}    ${ten_nhom}    Add product by generated info automatically    ${ma_hang}
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${inv_code}    Add new invoice with product    ${customer_code}    ${ma_hang}    ${input_soluong}    ${input_khtt}
    Go to any menu    ${cell_return}
    Wait To Loading Icon Invisible
    Wait Until Keyword Succeeds    3x    20s   Tìm kiếm khách hàng ở form trả hàng theo sđt    ${textbox_return_kh}    ${get_dienthoai_kh}    ${cell_ma_hd}    ${inv_code}
    Click To Close Form
    Delete product thr API    ${ma_hang}
    Delete category thr API    ${ten_nhom}
    Delete customer    ${get_id_kh}

Tim kiem khach hang o form lap phieu thu
    [Arguments]    ${customer_code}
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    Go to any menu    ${cell_lapphieuthu}
    Wait To Loading Icon Invisible
    Input Type Flex    ${textbox_lpt_kh}    ${get_dienthoai_kh}
    Wait Until Page Contains Element    ${cell_khachhang}     30s
    Click Element JS    ${cell_khachhang}
    Wait Until Element Is Visible    ${thongtin_khachhang}    10s
    Wait Until Element Is Visible    ${button_xoa_khach_hang}    10s
    Wait Until Element Is Visible    ${cell_sdt_kh}    10s
    Click To Close Form
    Delete customer    ${get_id_kh}

Them moi khach hang
    [Arguments]    ${customer_code}
    ${customer_name}        Generate Random String      12       [LOWER]
    ${customer_mobile}      Generate Mobile number
    ${customer_address}      Generate Random String       5       [UPPER]
    ${mail_address}    Generate email for customer
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    Click Element JS    ${button_them_kh}
    Input data in form add customer    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}
    Click Element JS    ${button_luu_kh}
    Create customer message success validation
    Validate customer info thr API    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}

Cap nhat khach hang
    [Arguments]    ${customer_code}
    Wait Until Element Is Visible    ${button_xoa_khach_hang}    5s
    ${customer_name}        Generate Random String      12       [LOWER]
    ${customer_mobile}      Generate Mobile number
    ${customer_address}      Generate Random String       5       [UPPER]
    ${mail_address}    Generate email for customer
    Click Element JS    ${thongtin_khachhang}
    Input data in form add customer    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}
    Click Element JS    ${button_luu_kh}
    Message update customer in MHBH
    Validate customer info thr API    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}
    ${get_id_kh}    Get customer id thr API    ${customer_code}
    Delete customer    ${get_id_kh}

Tìm kiếm khách hàng ở form trả hàng theo sđt
    [Arguments]    ${textbox_return_kh}    ${get_dienthoai_kh}    ${cell_ma_hd}    ${inv_code}
    Input Type Flex    ${textbox_return_kh}    ${get_dienthoai_kh}
    ${str_ma_hd}    Format String       ${cell_ma_hd}    ${inv_code}
    Wait Until Page Contains Element    ${str_ma_hd}    5s
