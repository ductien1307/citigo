*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan Ly
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/khachhang_list_action.robot

*** Test Cases ***
Tim kiem KH theo thong tin sdt
    [Documentation]     tim kiem khach hang
    [Timeout]    3 mins
    [Tags]    KYC3
    [Template]     Tim kiem KH theo sdt
    BMKH04

Tim kiem KH theo thong tin email
    [Documentation]     tim kiem khach hang
    [Timeout]    3 mins
    [Tags]    KYC3
    [Template]     Tim kiem KH theo email
    BMKH04

Them moi khach hang tren MHQL
    [Documentation]     tim kiem khach hang
    [Timeout]    3 mins
    [Tags]    KYC3
    [Template]     Them moi khach hang o MHQL
    BMKH04

Cap nhat thong tin khach hang tren MHQL
    [Documentation]     tim kiem khach hang
    [Timeout]    3 mins
    [Tags]    KYC3
    [Template]     Update thong tin KH
    BMKH04

Xoa khach hang tren MHQL
    [Documentation]     tim kiem khach hang
    [Timeout]    3 mins
    [Tags]    KYC3
    [Template]     Xoa khach hang
    BMKH04

*** Keywords ***
Tim kiem KH theo sdt
    [Arguments]    ${customer_code}
    [Documentation]    tìm kiếm khách hàng theo số điện thoại, 3 số cuối của sdt
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    Go to Khach Hang
    Input data to textbox and press enter key    ${textbox_search_matensdt}    ${get_dienthoai_kh}
    Validate customer info search by phone number and email    ${get_dienthoai_kh}
    #tim kiem theo 3 so cuoi sdt
    Input data to textbox and press enter key    ${textbox_search_matensdt}    ${last_3_of_phonenumber}
    Sleep    3s
    ${count_sl_kh}    Get Matching Xpath Count    ${cell_soluong_kh}
    ${sl_kh}=    Sum    ${count_sl_kh}    -1
    Capture Page Screenshot
    Log     ${last_3_of_phonenumber}
    ${list_contactnumber}    ${get_list_customer_code}    ${get_list_customer_name}    Get list contact number by search text thr API    ${last_3_of_phonenumber}
    ${count}    Set Variable    0
    :FOR    ${phone_number}    ${customer_code}    ${customer_name}    IN ZIP    ${list_contactnumber}    ${get_list_customer_code}    ${get_list_customer_name}
    \    ${sdt}    Remove String    ${phone_number}    ${last_3_of_phonenumber}
    \    ${ten_kh}    Remove String    ${phone_number}    ${last_3_of_phonenumber}
    \    ${ma_kh}    Remove String    ${customer_code}    ${last_3_of_phonenumber}
    \    ${count}=    Run Keyword If    '${phone_number}'!='${sdt}' or '${customer_code}'!='${ma_kh}' or '${customer_name}'!='${ten_kh}'    Sum    ${count}    1    ELSE    ${count}
    Should Be Equal As Numbers    ${count}    ${sl_kh}
    #thay đổi sdt và tìm kiếm bằng sdt mới
    ${sdt_moi}    ${mail_address}    ${customer_address}    Update info customer    ${customer_code}    ${get_ten_kh}
    Input data to textbox and press enter key    ${textbox_search_matensdt}    ${sdt_moi}
    Validate customer info search by phone number and email    ${sdt_moi}
    Delete customer    ${get_id_kh}

Tim kiem KH theo email
    [Arguments]    ${customer_code}
    [Documentation]    tìm kiếm khách hàng theo email
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    Go to Khach Hang
    #search theo email đầy đủ
    ${get_email_kh}    Get email customer frm API    ${customer_code}
    Input data and search email customer    ${get_email_kh}
    Validate customer info search by phone number and email    ${get_email_kh}
    #search theo tên mail ko có đuôi @
    Input data and search email customer    ${name_of_gmail}
    ${count_sl_kh}    Get Matching Xpath Count    ${cell_soluong_kh}
    ${sl_kh}=    Sum    ${count_sl_kh}    -1
    Log     ${name_of_gmail}
    ${get_list_customer_email}    Get list email by search text thr API    ${name_of_gmail}
    ${count}    Set Variable    0
    :FOR    ${email}    IN ZIP    ${get_list_customer_email}
    \    ${str_email}    Remove String    ${name_of_gmail}
    \    ${count}=    Run Keyword If    '${str_email}'!='${email}'    Sum    ${count}    1    ELSE    ${count}
    Should Be Equal As Numbers    ${count}    ${sl_kh}
    Delete customer    ${get_id_kh}

Them moi khach hang o MHQL
    [Arguments]    ${customer_code}
    [Documentation]    thêm mới khách hàng ở màn hình quản lí
    ${customer_name}        Generate Random String      12       [LOWER]
    ${customer_mobile}      Generate Mobile number
    ${customer_address}      Generate Random String       5       [UPPER]
    ${mail_address}    Generate email for customer
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    Go to Khach Hang
    Go to Add new Customer
    Input data in popup add customer    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}
    Create customer message success validation
    Validate customer info thr API    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}
    Delete customer    ${get_cus_id}

Update thong tin KH
    [Arguments]    ${customer_code}
    [Documentation]    thay đổi thông tin sdt, email. địa chỉ của khách hàng và kiểm tra
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    #thay doi thong tin
    ${customer_mobile}      Generate Mobile number
    ${customer_address}      Generate Random String       5       [UPPER]
    ${mail_address}    Generate email for customer
    Go to Khach Hang
    Go to update customer    ${customer_code}
    Input data in popup add customer    ${customer_code}    ${get_ten_kh}    ${customer_mobile}    ${customer_address}    ${mail_address}
    Create customer message success validation
    #validate thong tin
    Validate customer info thr API    ${customer_code}    ${get_ten_kh}    ${customer_mobile}    ${customer_address}    ${mail_address}
    Delete customer    ${get_id_kh}

Xoa khach hang
    [Arguments]    ${customer_code}
    [Documentation]    thay đổi thông tin sdt, email. địa chỉ của khách hàng và kiểm tra
    ${get_cus_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    Set Selenium Speed    0.1
    Go to Khach Hang
    Input data to textbox and press enter key    ${textbox_search_matensdt}    ${get_dienthoai_kh}
    Delete customer using customer code on UI    ${customer_code}
    Message delete customer success    ${get_ten_kh}
    ${get_id}    Get customer id thr API    ${customer_code}
    Should Be Equal As Numbers    ${get_id}    0
