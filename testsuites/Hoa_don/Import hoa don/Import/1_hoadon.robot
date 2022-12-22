*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Hoa don
Test Teardown     After Test
Library           Collections
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../../core/Share/discount.robot
Resource          ../../../../core/Share/excel.robot
Resource          ../../../../core/Tra hang/tra_hang_action.robot
Resource          ../../../../core/Dat hang/dat_hang_action.robot
Resource          ../../../../core/Share/computation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
${file_imp_hd}    ${EXECDIR}${/}testsuites${/}Hoa_don${/}File_import${/}file1.xlsx
${file_imp_hd1}    ${EXECDIR}${/}testsuites${/}Hoa_don${/}File_import${/}file2.xlsx
${file_imp_hd2}    ${EXECDIR}${/}testsuites${/}Hoa_don${/}File_import${/}file3.xlsx

*** Test Cases ***
Import 1 hd thuong
    [Tags]    IMH
    [Template]    etimhd1
    ${file_imp_hd}
    ${file_imp_hd2}

Import 1 hd giao hang
    [Tags]     IMH    klk
    [Template]    etimhd2
    ${file_imp_hd1}

*** Keywords ***
etimhd1
    [Document]    Import hóa đơn với kh có sẵn
    [Arguments]    ${input_excel_file}
    Set Selenium Speed    0.1
    ${invoice_code}    Generate code automatically        HDIP
    Log    ${input_excel_file}
    ${doc_id}     Generate Random String    5    [UPPER][NUMBERS]
    Open Excel Document      ${input_excel_file}     doc_id=${doc_id}
    ${get_col_num}      Update code in file excel      Mã hóa đơn     ${invoice_code}
    Save Excel Document    ${input_excel_file}
    Reload Page
    ${list_ma_hang}     Get list value by column name in Excel       Mã hàng    ${get_col_num}
    ${list_so_luong}     Get list value by column name in Excel       Số lượng    ${get_col_num}
    ${list_don_gia}     Get list value by column name in Excel       Đơn giá    ${get_col_num}
    ${list_giamgia_%}     Get list value by column name in Excel       Giảm giá %    ${get_col_num}
    ${list_giamgia_vnd}     Get list value by column name in Excel       Giảm giá    ${get_col_num}
    ${list_giamgia_hd_%}     Get list value by column name in Excel      Giảm giá hóa đơn %    ${get_col_num}
    ${list_giamgia_hd_vnd}     Get list value by column name in Excel      Giảm giá hóa đơn    ${get_col_num}
    ${list_tienmat}     Get list value by column name in Excel       Tiền mặt    ${get_col_num}
    ${list_ma_kh}     Get list value by column name in Excel        Mã khách hàng    ${get_col_num}
    ${list_ma_thukhac}     Get list value by column name in Excel        Mã thu khác 1    ${get_col_num}
    ${list_giatri_thukhac}     Get list value by column name in Excel       Giá trị thu khác 1    ${get_col_num}
    ${list_giatri_thukhac%}     Get list value by column name in Excel        Giá trị thu khác % 1    ${get_col_num}
    #bat thu khac
    ${surcharge_vnd_value}    Get surcharge vnd value    @{list_ma_thukhac}[0]
    ${surcharge_%}    Get surcharge percentage value    @{list_ma_thukhac}[0]
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    @{list_ma_thukhac}[0]    true
    ...    ELSE    Toggle surcharge percentage    @{list_ma_thukhac}[0]    true
    #
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_ma_hang}    ${list_so_luong}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    @{list_ma_kh}[0]
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s     Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 mins
    #tat thu khac
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND     @{list_ma_thukhac}[0]    false
    ...    ELSE    Toggle surcharge percentage     @{list_ma_thukhac}[0]    false
    #
    ${tongtien}    Set Variable    0
    :FOR    ${item_so_luong}    ${item_don_gia}     ${item_giamgia_%}   ${item_giamgia}     IN ZIP      ${list_so_luong}    ${list_don_gia}   ${list_giamgia_%}   ${list_giamgia_vnd}
    \     ${result_dongia_saugiam}     Run Keyword If    ${item_giamgia_%}!=0     Price after % discount     ${item_don_gia}     ${item_giamgia_%}    ELSE    Minus    ${item_don_gia}      ${item_giamgia}
    \     ${thanhtien}      Multiplication and round    ${item_so_luong}    ${result_dongia_saugiam}
    \     ${tongtien}      Sum    ${tongtien}    ${thanhtien}
    Log    ${tongtien}
    #
    ${result_giamgia_hd}      Run Keyword If    @{list_giamgia_hd_%}[0]!=0     Convert % discount to VND and round     ${tongtien}   @{list_giamgia_hd_%}[0]   ELSE      Set Variable   @{list_giamgia_hd_vnd}[0]
    ${tongtien_af_giamgia}      Minus    ${tongtien}    ${result_giamgia_hd}
    ${result_giatri_thukhac}      Run Keyword If       @{list_giatri_thukhac%}[0]==0     Set Variable   @{list_giatri_thukhac}[0]   ELSE      Convert % discount to VND and round    ${tongtien_af_giamgia}     @{list_giatri_thukhac%}[0]
    #
    ${result_cantra}    Sum    ${tongtien_af_giamgia}    ${result_giatri_thukhac}
    ${result_no_hoadon}    Minus    ${result_cantra}    @{list_tienmat}[0]
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_cantra}    ${get_tongban_bf_execute}
    #
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}   ${result_cantra}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_cantra}
    Should Be Equal As Numbers    ${get_khach_tt}    @{list_tienmat}[0]
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    @{list_ma_kh}[0]
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_giamgia_hd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_so_luong}
    : FOR    ${item_product}      ${item_num_instockcard}    ${item_result_onhand}       IN ZIP    ${list_ma_hang}       ${list_num_instockcard}
    ...    ${list_result_ton_af_ex}
    \      Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_result_onhand}    ${item_num_instockcard}
    Log       assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '@{list_tienmat}[0]' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    @{list_ma_kh}[0]    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success     @{list_ma_kh}[0]     ${get_maphieu_soquy}    ${invoice_code}
    Log        assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    @{list_ma_kh}[0]    ${invoice_code}   @{list_tienmat}[0]
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '@{list_tienmat}[0]' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    @{list_tienmat}[0]
    Delete invoice by invoice code    ${invoice_code}

etimhd2
    [Document]    Import 1 hóa đơn chỉ có thông tin cơ bản
    [Arguments]    ${input_excel_file}
    Set Selenium Speed    0.1
    ${invoice_code}    Generate code automatically        HDIP
    Log    ${input_excel_file}
    ${doc_id}     Generate Random String    5    [UPPER][NUMBERS]
    Open Excel Document      ${input_excel_file}     doc_id=${doc_id}
    ${get_col_num}      Update code in file excel     Mã hóa đơn    ${invoice_code}
    ${list_ma_kh}     Get list value by column name in Excel        Mã khách hàng    ${get_col_num}
    ${get_id_kh}      Get customer id thr API    @{list_ma_kh}[0]
    Run Keyword If    ${get_id_kh}!=0    Delete customer by Customer Code     @{list_ma_kh}[0]
    Save Excel Document    ${input_excel_file}
    ${list_ma_hang}     Get list value by column name in Excel       Mã hàng    ${get_col_num}
    ${list_so_luong}     Get list value by column name in Excel       Số lượng    ${get_col_num}
    ${list_don_gia}     Get list value by column name in Excel       Đơn giá    ${get_col_num}
    ${list_giamgia_%}     Get list value by column name in Excel       Giảm giá %    ${get_col_num}
    ${list_giamgia_vnd}     Get list value by column name in Excel       Giảm giá    ${get_col_num}
    ${list_giamgia_hd_%}     Get list value by column name in Excel      Giảm giá hóa đơn %    ${get_col_num}
    ${list_giamgia_hd_vnd}     Get list value by column name in Excel      Giảm giá hóa đơn    ${get_col_num}
    ${list_tienmat}     Get list value by column name in Excel       Tiền mặt    ${get_col_num}
    ${list_ten_kh}     Get list value by column name in Excel        Tên khách hàng    ${get_col_num}
    ${list_dienthoai}     Get list value by column name in Excel        Điện thoại    ${get_col_num}
    ${list_email}     Get list value by column name in Excel       Email    ${get_col_num}
    ${list_diachi}     Get list value by column name in Excel        Địa chỉ (Khách hàng)    ${get_col_num}
    ${list_khuvuc}     Get list value by column name in Excel        Khu vực (Khách hàng)    ${get_col_num}
    ${list_phuongxa}     Get list value by column name in Excel        Phường/Xã (Khách hàng)    ${get_col_num}
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Click element     //div[@id='importinvoiceform']//input[@data-label="Giao hàng"]//..//a
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s      Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 mins
    #
    ${tongtien}    Set Variable    0
    :FOR    ${item_so_luong}    ${item_don_gia}     ${item_giamgia_%}   ${item_giamgia}     IN ZIP      ${list_so_luong}    ${list_don_gia}   ${list_giamgia_%}   ${list_giamgia_vnd}
    \     ${result_dongia_saugiam}     Run Keyword If    ${item_giamgia_%}!=0     Price after % discount     ${item_don_gia}     ${item_giamgia_%}    ELSE    Minus    ${item_don_gia}      ${item_giamgia}
    \     ${thanhtien}      Multiplication and round    ${item_so_luong}    ${result_dongia_saugiam}
    \     ${tongtien}      Sum    ${tongtien}    ${thanhtien}
    Log    ${tongtien}
    ${result_giamgia_hd}      Run Keyword If    @{list_giamgia_hd_%}[0]!=0     Convert % discount to VND and round     ${tongtien}   @{list_giamgia_hd_%}[0]   ELSE      Set Variable   @{list_giamgia_hd_vnd}[0]
    ${result_cantra}    Minus    ${tongtien}    ${result_giamgia_hd}
    #
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}   ${tongtien}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_cantra}
    Should Be Equal As Numbers    ${get_khach_tt}    @{list_tienmat}[0]
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    @{list_ma_kh}[0]
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_giamgia_hd}
    Should Be Equal As Strings    ${get_trangthai}    Đang xử lý
    #
    ${customer_id}      Get Customer info and validate    Cá nhân    @{list_ma_kh}[0]    @{list_ten_kh}[0]    @{list_dienthoai}[0]    @{list_diachi}[0]   @{list_khuvuc}[0]    @{list_phuongxa}[0]      0   @{list_email}[0]      0
    #
    ${get_trangthai_gh_af_execute}    ${get_khachcantra_in_hd_af_execute}    Get delivery status frm Invoice    ${invoice_code}
    Assert delivery info not time in invoice    ${invoice_code}    @{list_ten_kh}[0]     @{list_dienthoai}[0]    @{list_diachi}[0]   @{list_khuvuc}[0]    @{list_phuongxa}[0]
    ...    0    0    0
    Delete customer    ${customer_id}
    Delete invoice by invoice code    ${invoice_code}
