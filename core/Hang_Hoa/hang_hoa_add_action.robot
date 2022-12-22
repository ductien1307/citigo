*** Settings ***
Library           SeleniumLibrary
Resource          hang_hoa_add_page.robot
Resource          hang_hoa_navigation.robot
Resource          ../share/create_nhomhang_lv1.robot
Resource          ../share/javascript.robot
Resource          ../share/toast_message.robot
Resource          ../share/discount.robot

*** Keywords ***
Input data in Them hang hoa form
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    [Documentation]    Input dữ liệu với Nhóm hàng đã có sẵn trên hệ thống
    Set Selenium Speed    0.6 seconds
    Wait Until Page Contains Element    ${textbox_giavon}     30s
    Sleep    2s
    Run Keyword If    '${giavon}'!='none'   Wait Until Keyword Succeeds    4x    2s     Input Text    ${textbox_giavon}    ${giavon}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Input Text    ${textbox_tonkho}    ${tonkho}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Select Nhom Hang    ${nhom_hang}

Input data without product code into Adding products form
    [Arguments]    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    [Documentation]    Input dữ liệu với Nhóm hàng đã có sẵn trên hệ thống
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Input Text    ${textbox_giavon}    ${giavon}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Input Text    ${textbox_tonkho}    ${tonkho}
    Select Nhom Hang    ${nhom_hang}

Create products with new group
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    [Documentation]    Input dữ liệu và tạo nhóm hàng mới
    Wait Until Element Is Visible    ${textbox_ma_hh}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Input Text    ${textbox_giavon}    ${giavon}
    Input Text    ${textbox_tonkho}    ${tonkho}
    Create nhomhang level1    ${nhom_hang}

Create serial imei product with new group
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}
    [Documentation]    Input dữ liệu với Nhóm hàng đã có sẵn trên hệ thống
    Set Selenium Speed    0.6s
    Focus    ${checkbox_serial_imei}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Create nhomhang level1    ${nhom_hang}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Input Text    ${textbox_giavon}    ${giavon}

Create serial imei product
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}
    [Documentation]    Input dữ liệu với Nhóm hàng đã có sẵn trên hệ thống
    Set Selenium Speed    0.6s
    Focus    ${checkbox_serial_imei}
    Click Element JS    ${checkbox_serial_imei}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Select Nhom Hang    ${nhom_hang}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Input Text    ${textbox_giavon}    ${giavon}

Input data to Thongtin
    [Arguments]    ${ma_hh}    ${ten_hh}    ${giaban}    ${nhom_hang}
    [Documentation]    Input dữ liệu với Nhóm hàng đã có sẵn trên hệ thống
    Wait Until Page Contains Element    ${textbox_ma_hh}      30s
    Sleep    5s
    Input data    ${textbox_ten_hh}    ${ten_hh}
    Input data    ${textbox_hh_giaban}    ${giaban}
    Select Nhom Hang    ${nhom_hang}
    Input Text    ${textbox_ma_hh}    ${ma_hh}

Input 2 hh thanh phan
    [Arguments]    ${product1}    ${product2}
    Click Element    ${tab_thanhphan_in_add_hh_page}
    Wait Until Element Is Visible    ${textbox_hanghoa_thanhphan}
    Input Text    ${textbox_hanghoa_thanhphan}    ${product1}
    Press Key    ${textbox_hanghoa_thanhphan}    ${ENTER_KEY}
    Sleep    2s
    Input Text    ${textbox_hanghoa_thanhphan}    ${product2}
    Press Key    ${textbox_hanghoa_thanhphan}    ${ENTER_KEY}
    Sleep    2s

Update ton kho
    [Arguments]    ${product_code}    ${change_tonkho}
    input text    ${textbox_search_maten}    ${product_code}
    Press Key    ${textbox_search_maten}    ${ENTER_KEY}
    Wait Until Element Is Visible    ${button_capnhat_in_thongtintab}
    sleep    1s
    Set Focus To Element    ${button_capnhat_in_thongtintab}
    Click Element JS    ${button_capnhat_in_thongtintab}
    Wait Until Element Is Visible    ${textbox_tonkho}
    Input Text    ${textbox_tonkho}    ${change_tonkho}
    sleep    1s
    Click Element    ${button_luu}
    Update data success validation

Input Dinh Muc Ton
    [Arguments]    ${input_ton_itnhat}    ${input_ton_nhieunhat}
    Click Element    ${tab_mota_chitiet}
    Wait Until Element Is Visible    ${textbox_ton_itnhat}
    Input Text    ${textbox_ton_itnhat}    ${input_ton_itnhat}
    Input Text    ${textbox_ton_nhieunhat}    ${input_ton_nhieunhat}

Select Nhom Hang
    [Arguments]    ${ten_nhom}
    Click Element    ${cell_luachon_nhomhang}
    ${group_name}    Format String    ${item_nhomhang}    ${ten_nhom}
    Click Element    ${group_name}

Assert ton kho
    [Arguments]    ${result_ton}    ${get_ton}
    Should Be Equal As Numbers    ${result_ton}    ${get_ton}

Input component product
    [Arguments]    ${product}    ${num}    ${total_giavon}    ${total_giaban}
    Wait Until Element Is Visible    ${textbox_hanghoa_thanhphan}
    ${cell_tp_masp}    Format String    //td[text()='{0}']    ${product}
    ${textbox_sl}    Format String    ${textbox_thanhphan_soluong}    ${product}
    Wait Until Keyword Succeeds    5 times    1s    Input data in textbox and wait until it is visible    ${textbox_hanghoa_thanhphan}    ${product}    //li[contains(@class,'ng-binding ng-scope')]
    ...    ${cell_tp_masp}
    ${ton}    ${giavon}    Get Cost and OnHand frm API    ${product}
    ${ton}    ${giaban}    Get Onhand and Baseprice frm API    ${product}
    Input Text    ${textbox_sl}    ${num}
    ${result_giavon}    Multiplication and round    ${num}    ${giavon}
    ${result_giaban}    Multiplication and round    ${num}    ${giaban}
    ${total_giavon}    Sum    ${result_giavon}    ${total_giavon}
    ${total_giaban}    Sum    ${result_giaban}    ${total_giaban}
    Return From Keyword    ${total_giavon}    ${total_giaban}

Input list component product
    [Arguments]   ${list_prs}    ${list_num}
    ${total_giavon}    Set Variable    0
    ${total_giaban}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    IN ZIP    ${list_prs}    ${list_num}
    \    ${total_giavon}    ${total_giaban}    Input component product    ${item_pr}    ${item_num}    ${total_giavon}
    \    ...    ${total_giaban}
    Return From Keyword    ${total_giavon}    ${total_giaban}

Assert total cost and sating price
    [Arguments]    ${total_giavon}    ${total_giaban}
    ${result_tong_giavon}    Get New price from UI    ${cell_tong_giavon}
    ${result_tong_giaban}    Get New price from UI    ${cell_tong_giaban}
    Should Be Equal As Numbers    ${result_tong_giavon}    ${total_giavon}
    Should Be Equal As Numbers    ${result_tong_giaban}    ${total_giaban}

Input data without cost, onhand and create new group
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}
    Wait Until Element Is Visible    ${textbox_ma_hh}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Create nhomhang level1    ${nhom_hang}

Input data in Them hang hoa form without cost
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${tonkho}
    Set Selenium Speed    0.6 seconds
    Run Keyword If    '${ma_hh}'!='none'    Input data    ${textbox_ma_hh}    ${ma_hh}    ELSE    Log    Ingore input ma hh
    Input data    ${textbox_ten_hh}    ${ten_hh}
    Run Keyword If    '${giaban}'!='none'    Input data    ${textbox_hh_giaban}    ${giaban}
    Input data    ${textbox_tonkho}    ${tonkho}
    Select Nhom Hang    ${nhom_hang}

Input data in Them dich vu form
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}
    Set Selenium Speed    0.6 seconds
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Input Text    ${textbox_giavon}    ${giavon}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Select Nhom Hang    ${nhom_hang}

Create lodate product
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}
    Set Selenium Speed    0.5s
    Focus    ${checkbox_serial_imei}
    Click Element JS    ${checkbox_lodate}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Select Nhom Hang    ${nhom_hang}
    Input Text    ${textbox_giavon}    ${giavon}
    Input Text    ${textbox_giaban}    ${giaban}

Input code, name, cost, category in Them hang hoa form
    [Arguments]    ${ma_hh}    ${ten_hh}    ${gia_von}    ${nhom_hang}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Input Text    ${textbox_giavon}    ${gia_von}
    Select Nhom Hang    ${nhom_hang}

Delete product
    Wait Until Page Contains Element    ${button_xoa_hh}    15s
    Click Element JS    ${button_xoa_hh}
    Wait Until Page Contains Element    ${button_dongy_xoahh}    15s
    Click Element JS    ${button_dongy_xoahh}

Input data in Them hang hoa form without cost and onhand
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}
    Set Selenium Speed    0.6 seconds
    Run Keyword If    '${ma_hh}'!='none'      Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Select Nhom Hang    ${nhom_hang}

Input amount component product
    [Arguments]    ${product}    ${num}    ${total_giavon}    ${total_giaban}
    Wait Until Element Is Visible    ${textbox_hanghoa_thanhphan}
    ${textbox_sl}    Format String    ${textbox_thanhphan_soluong}    ${product}
    ${ton}    ${giavon}    Get Cost and OnHand frm API    ${product}
    ${ton}    ${giaban}    Get Onhand and Baseprice frm API    ${product}
    Input Text    ${textbox_sl}    ${num}
    ${result_giavon}    Multiplication and round    ${num}    ${giavon}
    ${result_giaban}    Multiplication and round    ${num}    ${giaban}
    ${total_giavon}    Sum    ${result_giavon}    ${total_giavon}
    ${total_giaban}    Sum    ${result_giaban}    ${total_giaban}
    Return From Keyword    ${total_giavon}    ${total_giaban}

Input list amount component product
    [Arguments]   ${list_prs}    ${list_nums}
    ${total_giavon}    Set Variable    0
    ${total_giaban}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    IN ZIP    ${list_prs}    ${list_nums}
    \    ${total_giavon}    ${total_giaban}    Input amount component product    ${item_pr}    ${item_num}    ${total_giavon}
    \    ...    ${total_giaban}
    Return From Keyword    ${total_giavon}    ${total_giaban}

Input 2 unit in Them hang hoa form
    [Arguments]    ${ma_hh_1}    ${dvcb}    ${dv1}    ${gtqd1}    ${ma_hh_2}    ${dv2}
    ...    ${gtqd2}
    Click Element    ${tab_donvitinh}
    Wait Until Element Is Visible    ${textbox_donvi_coban}
    Input data    ${textbox_donvi_coban}    ${dvcb}
    Click Element    ${button_them_donvi}
    Input Text    ${textbox_tendonvi_0}    ${dv1}
    Input data    ${textbox_giatri_quydoi_0}    ${gtqd1}
    Input Text    ${textbox_nhap_ma_qd_1}    ${ma_hh_1}
    Click Element    ${button_them_donvi}
    Input Text    ${textbox_tendonvi_1}    ${dv2}
    Input Text    ${textbox_giatri_quydoi_1}    ${gtqd2}
    Input Text    ${textbox_nhap_ma_qd_2}    ${ma_hh_2}

Input 2 unit and barcode in Them hang hoa form
    [Arguments]    ${ma_hh_1}    ${dvcb}    ${dv1}    ${gtqd1}    ${ma_vach_1}    ${ma_hh_2}    ${dv2}
    ...    ${gtqd2}      ${ma_vach_2}
    Click Element    ${tab_donvitinh}
    Wait Until Element Is Visible    ${textbox_donvi_coban}
    Input Text    ${textbox_donvi_coban}    ${dvcb}
    Click Element    ${button_them_donvi}
    Input Text    ${textbox_tendonvi_0}    ${dv1}
    Input Text    ${textbox_giatri_quydoi_0}    ${gtqd1}
    Input Text    ${textbox_nhap_ma_qd_1}    ${ma_hh_1}
    Input Text    ${textbox_mavach_0}    ${ma_vach_1}
    Click Element    ${button_them_donvi}
    Input Text    ${textbox_tendonvi_1}    ${dv2}
    Input Text    ${textbox_giatri_quydoi_1}    ${gtqd2}
    Input Text    ${textbox_nhap_ma_qd_2}    ${ma_hh_2}
    Input Text    ${textbox_mavach_1}    ${ma_vach_2}

Input attributes in Them hang hoa form
    [Arguments]    ${attr}    ${list_attr}
    Click Element    ${tab_theo_doi_thuoc_tinh}
    Wait Until Element Is Visible    ${button_them_thuoctinh}
    Click Element    ${button_them_thuoctinh}
    Wait Until Element Is Visible    ${cell_thuoctinh}
    ${item_thuoctinh1}    Format String    ${item_thuoctinh}    ${attr}
    Click Element    ${cell_thuoctinh}
    Wait Until Element Is Visible    ${item_thuoctinh1}
    Click Element    ${item_thuoctinh1}
    : FOR    ${item_attr1}    IN ZIP    ${list_attr}
    \    Input Text    ${textbox_nhapthuoctinh}    ${item_attr1}
    \    Press Key    ${textbox_nhapthuoctinh}    ${ENTER_KEY}

Select shelve
    [Arguments]    ${list_vitri}
    : FOR    ${item}    IN ZIP    ${list_vitri}
    \    Input Text    ${textbox_vitri}    ${item}
    \    ${xp_vitri}    Format String    ${item_vitri}    ${item}
    \    Wait Until Page Contains Element    ${xp_vitri}    1 min
    \    Click Element    ${xp_vitri}

Input 2 unit have sell in store
    [Arguments]    ${ma_hh_1}    ${dvcb}    ${dv1}    ${gtqd1}    ${ma_hh_2}    ${dv2}
    ...    ${gtqd2}
    Click Element    ${tab_donvitinh}
    Wait Until Element Is Visible    ${textbox_donvi_coban}
    Input Text    ${textbox_donvi_coban}    ${dvcb}
    Click Element    ${button_them_donvi}
    Input Text    ${textbox_tendonvi_0}    ${dv1}
    Input Text    ${textbox_giatri_quydoi_0}    ${gtqd1}
    Input Text    ${textbox_nhap_ma_qd_1}    ${ma_hh_1}
    Click Element    ${button_them_donvi}
    Input Text    ${textbox_tendonvi_1}    ${dv2}
    Input Text    ${textbox_giatri_quydoi_1}    ${gtqd2}
    Input Text    ${textbox_nhap_ma_qd_2}    ${ma_hh_2}

Select thuong hieu
    [Arguments]     ${ten_thuong_hieu}
    Wait Until Page Contains Element    ${cell_chon_thuonghieu}   30s
    Click Element    ${cell_chon_thuonghieu}
    Wait Until Page Contains Element    ${textbox_chon_thuonghieu}    20s
    Input Text    ${textbox_chon_thuonghieu}    ${ten_thuong_hieu}
    Wait Until Page Contains Element    ${item_thuonghieu_indropdown}   20s
    Click Element    ${item_thuonghieu_indropdown}

Select Duong dung
    [Arguments]    ${ten_nhom}
    Click Element    ${cell_duong_dung}
    ${group_duongdung}    Format String    ${item_duongdung_indropdow}    ${ten_nhom}
    Click Element    ${group_duongdung}

Search ten thuoc
    [Arguments]     ${ten_hanghoa}
    Input Text     ${textbox_ten_thuoc}     ${ten_hanghoa}
    ${xp_tenthuoc}    Format String       ${item_thuoc_indropdown}      ${ten_hanghoa}
    Wait Until Page Contains Element    ${xp_tenthuoc}    30s
    Press Key     ${textbox_ten_thuoc}      ${ENTER_KEY}

Input data in Them thuoc form
    [Arguments]    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}   ${duong_dung}    ${giaban}    ${giavon}
    [Documentation]    Input dữ liệu với Nhóm hàng đã có sẵn trên hệ thống
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Search ten thuoc    ${ten_hanghoa}
    Input Text    ${textbox_giavon}    ${giavon}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Select Nhom Hang    ${nhom_hang}
    Select Duong dung    ${duong_dung}

Choose checkbok sell directly
    [Arguments]   ${input_tructiep_cb}    ${list_bantructiep}   ${list_thutu_hangquydoi}
    Run Keyword If    '${input_tructiep_cb}' == 'true'    Log      Ignore input      ELSE      Click Element JS      ${checkbox_bantructiep_coban}
    :FOR      ${item_bantructiep}   ${thutu_hangquydoi}   IN ZIP   ${list_bantructiep}   ${list_thutu_hangquydoi}
    \     ${checkbox_quydoi}   Format String     ${checkbox_bantructiep_quydoi}   ${thutu_hangquydoi}
    \     Run Keyword If    '${item_bantructiep}' == 'true'    Log      Ignore input      ELSE      Click Element JS     ${checkbox_quydoi}
Wait Noti Import Product Successful
    Wait Until Element Is Visible   ${text_noti_import_success}   2 minutes
