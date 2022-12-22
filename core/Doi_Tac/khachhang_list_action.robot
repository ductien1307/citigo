*** Settings ***
Library           SeleniumLibrary
Library           String
Library           StringFormat
Library           OperatingSystem
Library           Collections
Resource          doitac_navigation.robot
Resource          ../share/constants.robot
Resource          khachhang_list_page.robot
Resource          ../share/computation.robot
Resource          ../share/Javascript.robot
Resource          ../share/global.robot
Resource          ../share/excel.robot
Resource          ../share/toast_message.robot

*** Keywords ***
Go to Khach Hang and get cong no
    [Arguments]    ${input_ma_kh}
    [Timeout]    15 seconds
    Click Element    ${menu_doitac}
    Click Element    ${domain_khachhang}
    Wait Until Element Is Enabled    ${textbox_search_matensdt}
    Input Text    ${textbox_search_matensdt}    ${input_ma_kh}
    Press Key    ${textbox_search_matensdt}    ${ENTER_KEY}
    Wait Until Element Is Enabled    ${cell_no_hientai}
    ${get_no_hientai}    Get Text    ${cell_no_hientai}
    ${get_tong_ban}    Get Text    ${cell_tong_ban}
    ${get_tongban_tru_trahang}    Get Text    ${cell_tong_ban_tru_trahang}
    ${get_no_hientai}    Convert Any To Number    ${get_no_hientai}
    ${get_tong_ban}    Convert Any To Number    ${get_tong_ban}
    ${get_tongban_tru_trahang}    Convert Any To Number    ${get_tongban_tru_trahang}
    Return From Keyword    ${get_no_hientai}    ${get_tong_ban}    ${get_tongban_tru_trahang}

Get ma HD
    [Arguments]    ${input_ma_kh}
    Click Element    ${tab_lichsu_ban_tra}
    ${get_ma_hd}    Get Text    ${cell_tab_lsban_maHD}
    Return From Keyword    ${get_ma_hd}

Get ma Dat Hang
    [Arguments]    ${input_ma_kh}
    Click Element    ${tab_lichsu_dathang}
    ${get_ma_dh}    Get Text    ${cell_tab_lsdat_maDH}
    Return From Keyword    ${get_ma_dh}

Go to Add new Customer
    Wait Until Page Contains Element    ${button_add_new_customer}    2 mins
    Click Element     ${button_add_new_customer}
    Wait Until Page Contains Element    ${textbox_customercode}    2 mins

Select Customer Type
    [Arguments]    ${customer_type}
    ${xpath_radiobutton_bycus}    Format String    ${radiobutton_custumer_type}    ${customer_type}
    Click Element JS    ${xpath_radiobutton_bycus}

Select location
    [Arguments]    ${cus_location}
    Input data    ${textbox_customer_khuvuc}    ${cus_location}
    ${xpath_dropdown_location}    Format String    ${dropdown_customer_khuvuc}    ${cus_location}
    Wait Until Element Is Enabled    ${xpath_dropdown_location}
    Click Element JS    ${xpath_dropdown_location}
    Press Key    ${textbox_customer_khuvuc}    ${ESC_KEY}

Select ward
    [Arguments]    ${cus_ward}
    Input text    ${textbox_customer_phuongxa}    ${cus_ward}
    ${xpath_dropdown_ward}    Format String    ${dropdown_customer_phuongxa}    ${cus_ward}
    Wait Until Element Is Enabled    ${xpath_dropdown_ward}
    Click Element JS    ${xpath_dropdown_ward}
    Press Key    ${textbox_customer_phuongxa}    ${ESC_KEY}

Select Gender
    [Arguments]    ${customer_gender}
    ${xpath_radiobutton_gender}    Format String    ${radiobutton_customer_gender}    ${customer_gender}
    Click Element JS    ${xpath_radiobutton_gender}

Search customer
    [Arguments]    ${input_ma_kh}
    Wait Until Element Is Enabled    ${textbox_search_matensdt}
    Input Text    ${textbox_search_matensdt}    ${input_ma_kh}
    Press Key    ${textbox_search_matensdt}    ${ENTER_KEY}
    #Wait Until Element Is Enabled    ${tab_nocan_thu}

Search customer and go to tab No can thu tu khach
    [Arguments]    ${input_kh}
    Wait Until Keyword Succeeds    3 times    3s    Search customer    ${input_kh}
    Wait Until Page Contains Element    ${tab_nocan_thu}        50s
    Click Element    ${tab_nocan_thu}

Input data in popup Dieu chinh
    [Arguments]    ${input_giatri}    ${mo_ta}
    Wait Until Page Contains Element    ${textbox_giatri_no_dieuchinh}
    Input Text    ${textbox_giatri_no_dieuchinh}    ${input_giatri}
    Run Keyword If    '${mo_ta}'=='none'    Log    Ingnore input mota    ELSE     Input Text    ${textbox_mota}    ${mo_ta}
    Click Element    ${button_capnhat_dieuchinh}

Select payment method and bank account in popup Thanh toan
    [Arguments]     ${phuong_thuc}     ${tk_ngan_hang}
    ${xp_phuongthuc}      Format String    ${phuong_thuc_in_dropdownlist}    ${phuong_thuc}
    ${xp_taikhoan}      Format String    ${tai_khoan_in_dropdownlist}    ${tk_ngan_hang}
    Click Element    ${cell_chon_phuong_thuc}
    Wait Until Page Contains Element    ${xp_phuongthuc}    15s
    Click Element    ${xp_phuongthuc}
    Sleep    3s
    Click Element    ${textbox_thu_tu_khach_in_customer}
    Wait Until Page Contains Element    ${cell_chon_tai_khoan_nh}   15s
    Click Element    ${cell_chon_tai_khoan_nh}
    Wait Until Page Contains Element    ${xp_taikhoan}    15s
    Click Element    ${xp_taikhoan}

Go to update customer
    [Arguments]     ${input_ma_kh}
    Wait Until Page Contains Element    ${textbox_search_customer}    2 mins
    Input data    ${textbox_search_customer}    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_update_customer}    2 mins
    Click Element JS    ${button_update_customer}

Go to select import or export
    [Arguments]     ${button_import}
    Wait Until Page Contains Element    ${button_file}    2 mins
    Click Element JS    ${button_file}
    Wait Until Page Contains Element    ${button_import}    2 mins
    Click Element JS    ${button_import}

Select checkbox of customer by customer Code
    [Arguments]       ${customer_code}
    ${checkbox_customer_bycode}      Format String    ${checkbox_customercode}    ${customer_code}
    Click Element    ${checkbox_customer_bycode}

Assert info on Merge confirmation popup
    [Arguments]    ${customer1_name}     ${customer1_address}     ${customer2_name}     ${customer2_address}
    ${value_customer1_name_popup}         Get value    ${cell_cus1_name_popup}
    ${value_customer2_name_popup}         Get Value    ${cell_cus2_name_popup}
    ${value_customer1_address_popup}         Get value    ${cell_cus1_address_popup}
    ${value_customer2_address_popup}         Get Value    ${cell_cus2_address_popup}
    Should Be Equal    ${customer1_name}    ${value_customer1_name_popup}
    Should Be Equal    ${customer2_name}    ${value_customer2_name_popup}
    Should Be Equal    ${customer1_address}      ${value_customer1_address_popup}
    Should Be Equal    ${customer2_address}    ${value_customer2_address_popup}

Validate customer info thr API
    [Arguments]    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${customer_code}
    ${get_email_kh}    Get email customer frm API    ${customer_code}
    Should Be Equal As Strings    ${customer_name}    ${get_ten_kh}
    Should Be Equal As Strings    ${customer_mobile}    ${get_dienthoai_kh}
    Should Be Equal As Strings    ${customer_address}    ${get_diachi_kh}
    Should Be Equal As Strings    ${mail_address}    ${get_email_kh}

Generate email for customer
    ${mail}       Generate Random String       5       [LOWER]
    Set Test Variable    \${name_of_gmail}    ${mail}
    ${mail_address}    Format String    ${format_mail}    ${mail}
    Return From Keyword    ${mail_address}

Input data to textbox and press enter key
    [Arguments]    ${locator}   ${search_text}
    Input Type Flex    ${locator}    ${search_text}
    Press Key    ${locator}    ${ENTER_KEY}

Validate customer info search by phone number and email
    [Arguments]    ${input_text}
    ${str_validate}    Format String    ${cell_info_customer_email_and_phonenumber}    ${input_text}
    Wait Until Element Is Visible    ${str_validate}    10s
    Wait Until Element Is Visible    ${button_update_customer}    10s
    Wait Until Element Is Visible    ${button_active_customer}    10s
    Wait Until Element Is Visible    ${button_delete_customer}    10s

Input data and search email customer
    [Arguments]    ${search_text}
    Click Element    ${dropdown_timkiem}
    Wait Until Element Is Visible    ${textbox_search_emailcustomer}
    Clear Element Text    ${textbox_search_emailcustomer}
    Input Type Flex    ${textbox_search_emailcustomer}    ${search_text}
    Press Key    ${textbox_search_emailcustomer}    ${ENTER_KEY}

Input data in popup add customer
    [Arguments]    ${customer_code}    ${customer_name}    ${customer_mobile}    ${customer_address}    ${mail_address}
    Input Text    ${textbox_customercode}    ${customer_code}
    Wait Until Element Is Visible    ${textbox_customername}    30s
    Input Text    ${textbox_customername}    ${customer_name}
    Wait Until Element Is Visible    ${textbox_customermobile}    30s
    Input Text    ${textbox_customermobile}    ${customer_mobile}
    Wait Until Element Is Visible    ${textbox_customer_address}    30s
    Input Text    ${textbox_customer_address}    ${customer_address}
    Wait Until Element Is Visible    ${textbox_customer_email}    30s
    Input Text    ${textbox_customer_email}    ${mail_address}
    Click Element    ${button_customer_luu}

Delete customer using customer code on UI
    [Arguments]    ${customer_code}
    Wait Until Element Is Visible    ${button_delete_customer}    30s
    Click Element    ${button_delete_customer}
    ${button_confirm}    Format String    ${button_confirm_delete_customer}    ${customer_code}
    Wait Until Page Contains Element    ${button_confirm}     30s
    Click Element    ${button_confirm}

Go to select export customer
    Wait Until Page Contains Element    ${button_thao_tac}    1 mins
    Click Element JS    ${button_thao_tac}
    Wait Until Page Contains Element    ${cell_item_export}    1 mins
    Click Element JS    ${cell_item_export}

Search customer code and select customer
    [Arguments]       ${ma_kh}
    Search customer    ${ma_kh}
    Wait Until Page Contains Element    ${checkbox_select_customer}    50s
    Wait Until Keyword Succeeds    5 times    2s    Click Element    ${checkbox_select_customer}

Import Khach Hang
    [Arguments]   ${excelPath}  ${excelName}
    Wait Until Keyword Succeeds     3 times     1s     Go to Khach Hang
    Wait To Loading Icon Invisible
    Wait Until Keyword Succeeds     3 times     1s     Click To Import - Khach Hang
    Choose File     ${button_chon_file_du_lieu}     ${excelPath}
    ${excelNameOuput}   Get Text Global    ${text_file_name__after_import}
    Should Be Equal    ${excelNameOuput}    ${excelName}
    Click Element Global    ${button_thuc_hien}
    Wait Until Element Is Visible     //span[text()='Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.']   2 min
    Click Element Global     ${button_x_after_import_export_successful}

Click To Import - Khach Hang
    Hover Mouse To Element     ${button_file}
    Click Element Global       ${item_button_import}

Export Khach Hang After Import
    [Arguments]    ${excelOpenedImport}
    @{maKhachHang}  Get All Column Value From Speacial Row By Python   ${excelOpenedImport}    2    2
    ${length}  Get Length    ${maKhachHang}
    :FOR  ${i}  IN RANGE  ${length}
    \      Exit For Loop If    ${i}>${length}-1
    \      ${tempMKH}  Get From List    ${maKhachHang}    ${i}
    \      ${checkboxLocator}  Format String    ${DYNAMIC_CHECKBOX_KHACHHANGLIST}    ${tempMKH}
    \      Wait Until Keyword Succeeds     3 times     1s     Click Element Global        ${checkboxLocator}
    Wait Until Keyword Succeeds     3 times     1s     Click To Thao Tac - Xuat File
    Click Element Global      ${link_tai_xuong}
    Wait Until Keyword Succeeds     3 times     10s     Wait To Have Item Download In Directory   ${excelDownloadPath}
    ${nameExportFile}   Wait Until Keyword Succeeds   10 times   5s   Get Text Global  ${text_name_export_file}
    Click Element Global     ${button_x_after_import_export_successful}
    Return From Keyword    ${nameExportFile}   @{maKhachHang}

Wait To Have Item Download In Directory
    [Arguments]  ${Path}
    ${countFiles}  Count Files In Directory    ${Path}
    Should Be True    ${countFiles}>0

Click To Thao Tac - Xuat File
    Hover Mouse To Element     ${button_thao_tac}
    Click Element Global     ${cell_item_export}

Add Column Table View By Select Checkbox
    [Arguments]  ${locator}
    Click Element Global      ${button_viewinfo_open}
    Wait Until Keyword Succeeds     3 times     1s    Click Element JS     ${locator}
    Click Element Global    ${button_viewinfo_close}

Check Ten Khach Hang Va SDT Va Dia Chi Sau Khi Import
    [Arguments]   ${openedExcel}
    Reload Page
    @{maKhachHang}  Get All Column Value From Speacial Row By Python   ${openedExcel}   2   2
    @{tenKhachHang}  Get All Column Value From Speacial Row By Python   ${openedExcel}   3   2
    @{dienThoai}  Get All Column Value From Speacial Row By Python   ${openedExcel}   4   2
    @{diaChi}  Get All Column Value From Speacial Row By Python   ${openedExcel}   5   2
    ${length}  Get Length    ${maKhachHang}
    :FOR  ${i}  IN RANGE  ${length}
    \      Exit For Loop If    ${i}>${length}-1
    \      ${tempMKH}  Get From List    ${maKhachHang}    ${i}
    \      ${tempTen}  Get From List    ${tenKhachHang}    ${i}
    \      ${tempDT}  Get From List    ${dienThoai}    ${i}
    \      ${tempDiaChi}  Get From List    ${diaChi}    ${i}
    \      ${locator1}  Format String    ${DYNAMIC_TEXT_TENKHACHHANG_THEOMAKH}    ${tempMKH}
    \      ${locator2}  Format String    ${DYNAMIC_TEXT_SDT_THEOMAKH}    ${tempMKH}
    \      ${locator3}  Format String    ${DYNAMIC_TEXT_DIACHI_THEOMAKH}    ${tempMKH}
    \      ${tenKhachHangOutput}    Wait Until Keyword Succeeds    3 times    1s   Get Text Global    ${locator1}
    \      ${sdtOutput}   Get Text Global    ${locator2}
    \      ${diaChiOutput}   Get Text Global    ${locator3}
    \      Should Be Equal As Strings   ${tempTen}    ${tenKhachHangOutput}
    \      Should Be Equal As Strings   ${tempDT}     ${sdtOutput}
    \      Should Be Equal As Strings   ${tempDiaChi}     ${diaChiOutput}

Check Ten Khach Hang Va SDT Va Dia Chi Sau Khi Export
    [Arguments]   ${openedExcel}
    Reload Page
    @{maKhachHang}  Get All Column Value From Speacial Row By Python   ${openedExcel}   3   2
    @{tenKhachHang}  Get All Column Value From Speacial Row By Python   ${openedExcel}   4   2
    @{dienThoai}  Get All Column Value From Speacial Row By Python   ${openedExcel}   5   2
    @{diaChi}  Get All Column Value From Speacial Row By Python   ${openedExcel}   6   2
    ${length}  Get Length    ${maKhachHang}
    :FOR  ${i}  IN RANGE  ${length}
    \      Exit For Loop If    ${i}>${length}-1
    \      ${tempMKH}  Get From List    ${maKhachHang}    ${i}
    \      ${tempTen}  Get From List    ${tenKhachHang}    ${i}
    \      ${tempDT}  Get From List    ${dienThoai}    ${i}
    \      ${tempDiaChi}  Get From List    ${diaChi}    ${i}
    \      ${locator1}  Format String    ${DYNAMIC_TEXT_TENKHACHHANG_THEOMAKH}    ${tempMKH}
    \      ${locator2}  Format String    ${DYNAMIC_TEXT_SDT_THEOMAKH}    ${tempMKH}
    \      ${locator3}  Format String    ${DYNAMIC_TEXT_DIACHI_THEOMAKH}    ${tempMKH}
    \      ${tenKhachHangOutput}    Wait Until Keyword Succeeds    3 times    1s   Get Text Global    ${locator1}
    \      ${sdtOutput}   Get Text Global    ${locator2}
    \      ${diaChiOutput}   Get Text Global    ${locator3}
    \      Should Be Equal As Strings   ${tempTen}    ${tenKhachHangOutput}
    \      Should Be Equal As Strings   ${tempDT}     ${sdtOutput}
    \      Should Be Equal As Strings   ${tempDiaChi}     ${diaChiOutput}

Delete customer selected by checkbox by customer code
    [Arguments]   @{customerCodes}
    :FOR   ${i}   IN    @{customerCodes}
    \      ${checkboxLocator}  Format String    ${DYNAMIC_CHECKBOX_KHACHHANGLIST}    ${i}
    \      Wait Until Keyword Succeeds     3 times     1s     Click Element Global        ${checkboxLocator}
    Hover Mouse To Element    ${button_thao_tac}
    Click Element Global     ${link_thao_tac_xoa}
    Click Element Global    ${button_dongy_xoa}
    Message delete customers successful
    Empty Directory     ${excelDownloadPath}
