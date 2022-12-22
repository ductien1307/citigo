*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/dathang_list_action.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../core/Giao_dich/tra_hang_list_action.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/API/api_vandon.robot
Resource          ../../../core/Giao_dich/vandon_list_action.robot
Resource          ../../../core/Giao_dich/yeu_cau_sua_chua_list_action.robot
Resource          ../../../core/API/api_yeucau_suachua.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_mhbh_dathang.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/constants.robot
Resource          ../../../core/share/discount.robot


*** Variables ***
&{dic_product_num_hoadon}     PIB10002=2.5


*** Test Cases ***
Tim kiem don dat hang
    [Documentation]     tim kiem don dat hang theo ma khach hang
    [Timeout]    3 mins
    [Tags]     KYC2
    [Template]     Tim kiem don DH theo thong tin khach hang
    BMKH01    PIB10002    2    0

Tim kiem Hoa don
    [Documentation]     tim kiem hoa don theo ma khach hang
    [Timeout]    3 mins
    [Tags]     KYC2
    [Template]     Tim kiem HD theo thong tin khach hang
    BMKH01    ${dic_product_num_hoadon}   0

Tim kiem don tra hang
    [Documentation]     tim kiem don tra hang theo ma khach hang
    [Timeout]    3 mins
    [Tags]     KYC2
    [Template]     Tim kiem phieu tra hang theo thong tin khach hang
    BMKH01    ${dic_product_num_hoadon}    15000

Tim kiem van don
    [Documentation]     tim kiem van don theo thong tin KH
    [Timeout]    3 mins
    [Tags]     KYC2
    [Template]     Tim kiem van don theo thong tin khach hang
    BMKH01    DT00013    ${dic_product_num_hoadon}    11111

Tim kiem YCSC
    [Documentation]     tim kiem YCSC bang thong tin khach hang
    [Timeout]    3 mins
    [Tags]     KYC2
    [Template]     Tim kiem Yeu cau sua chua
    BMKH01    HHBM01

*** Keywords ***
Tim kiem don DH theo thong tin khach hang
    [Arguments]    ${customer_code}     ${input_ma_hang}    ${input_soluong}    ${input_khtt}
    [Documentation]    tìm kiếm đơn đặt hàng của khách hàng theo sdt
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${order_code}    Add new order frm API    ${customer_code}    ${input_ma_hang}    ${input_soluong}    ${input_khtt}
    Before Test Quan Ly
    Go to Dat hang
    Search order by customer info    ${customer_code}
    Validate order by customer infor    ${order_code}    ${customer_code}    ${get_ten_kh}
    Search order by customer info    ${get_ten_kh}
    Validate order by customer infor    ${order_code}    ${customer_code}    ${get_ten_kh}
    Search order by customer info    ${get_dienthoai_kh}
    Validate order by customer infor    ${order_code}    ${customer_code}    ${get_ten_kh}
    Delete customer    ${get_id_kh}
    Delete order frm Order code    ${order_code}

Tim kiem HD theo thong tin khach hang
    [Arguments]    ${customer_code}     ${dic_product_num}    ${input_khtt}
    [Documentation]    tìm kiếm hóa đơn của khách hàng theo sdt
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    #${inv_code}    Add new invoice with product    ${customer_code}    ${input_ma_hang}    ${input_soluong}    ${input_khtt}
    ${inv_code}    Add new invoice frm API    ${customer_code}    ${dic_product_num}    ${input_khtt}
    Before Test Quan Ly
    Go to Hoa don
    Search invoice by customer info    ${customer_code}
    Validate invoice by customer infor    ${inv_code}    ${customer_code}    ${get_ten_kh}
    Search invoice by customer info    ${get_ten_kh}
    Validate invoice by customer infor    ${inv_code}    ${customer_code}    ${get_ten_kh}
    Search invoice by customer info    ${get_dienthoai_kh}
    Validate invoice by customer infor    ${inv_code}    ${customer_code}    ${get_ten_kh}
    ${sdt_moi}    ${mail_address}    ${customer_address}    Update info customer    ${customer_code}    ${get_ten_kh}
    Search invoice by customer info    ${sdt_moi}
    Validate invoice by customer infor    ${inv_code}    ${customer_code}    ${get_ten_kh}
    Delete customer    ${get_id_kh}
    Delete invoice by invoice code    ${inv_code}

Tim kiem phieu tra hang theo thong tin khach hang
    [Arguments]    ${customer_code}    ${dict_product_nums}    ${input_khtt}
    [Documentation]    tìm kiếm phiếu trả hàng của khách hàng theo sdt
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${return_code}    Add new return with customer    ${customer_code}    ${dict_product_nums}    ${input_khtt}
    Sleep    2s
    #Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to Tra hang
    Search return by customer info    ${customer_code}
    Validate return by customer infor    ${return_code}    ${customer_code}    ${get_ten_kh}
    Search return by customer info    ${get_ten_kh}
    Validate return by customer infor    ${return_code}    ${customer_code}    ${get_ten_kh}
    Search return by customer info    ${get_dienthoai_kh}
    Validate return by customer infor    ${return_code}    ${customer_code}    ${get_ten_kh}
    ${sdt_moi}    ${mail_address}    ${customer_address}    Update info customer    ${customer_code}    ${get_ten_kh}
    Search return by customer info    ${sdt_moi}
    Validate return by customer infor    ${return_code}    ${customer_code}    ${get_ten_kh}
    Delete customer    ${get_id_kh}
    Delete return thr API    ${return_code}

Tim kiem van don theo thong tin khach hang
    [Arguments]    ${customer_code}    ${input_ma_dtgh}    ${dict_product_nums}    ${input_khtt}
    [Documentation]    tìm kiếm vận đơn của khách hàng theo sdt
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${shipping_code}    Create new shipping with invoice have customer and carrier    ${customer_code}    ${input_ma_dtgh}    ${dict_product_nums}    ${input_khtt}
    Sleep    2s
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to Shipping
    Search shipping by customer infor    ${customer_code}
    Validate shipping by customer infor    ${shipping_code}    ${get_ten_kh}
    Search shipping by customer infor    ${get_ten_kh}
    Validate shipping by customer infor    ${shipping_code}    ${get_ten_kh}
    Search shipping by customer infor    ${get_dienthoai_kh}
    Validate shipping by customer infor    ${shipping_code}    ${get_ten_kh}
    ${sdt_moi}    ${mail_address}    ${customer_address}    Update info customer    ${customer_code}    ${get_ten_kh}
    Search shipping by customer infor    ${sdt_moi}
    Validate shipping by customer infor    ${shipping_code}    ${get_ten_kh}
    Delete customer    ${get_id_kh}

Tim kiem Yeu cau sua chua
    [Documentation]    tìm kiếm YCSC của khách hàng theo sdt
    [Arguments]    ${customer_code}    ${ma_hang}
    ${get_pro_id}    Get product id thr API    ${ma_hang}
    Run Keyword If    '${get_pro_id}'!='0'    Delete product thr API    ${ma_hang}
    ${ten_hang}    ${ten_nhom}    Add product by generated info automatically    ${ma_hang}
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    ${ma_phieu}    Add new warranty order with customer thr API    ${ma_hang}    ${customer_code}
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to Yeu Cau Sua Chua
    Search warranty by customer infor    ${get_dienthoai_kh}
    Validate warranty by customer infor    ${ma_phieu}    ${customer_code}    ${get_ten_kh}
    Search warranty by customer infor    ${get_ten_kh}
    Validate warranty by customer infor    ${ma_phieu}    ${customer_code}    ${get_ten_kh}
    Search warranty by customer infor    ${get_dienthoai_kh}
    Validate warranty by customer infor    ${ma_phieu}    ${customer_code}    ${get_ten_kh}
    ${sdt_moi}    ${mail_address}    ${customer_address}    Update info customer    ${customer_code}    ${get_ten_kh}
    Search warranty by customer infor    ${sdt_moi}
    Validate warranty by customer infor    ${ma_phieu}    ${customer_code}    ${get_ten_kh}
    #Delete warranty order thr API    ${ma_phieu}
    Delete product thr API    ${ma_hang}
    Delete category thr API    ${ten_nhom}
    Delete customer    ${get_id_kh}
