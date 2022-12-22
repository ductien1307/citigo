*** Settings ***
Resource          so_quy_add_page.robot
Resource          ../API/api_khachhang.robot
Resource          ../API/api_nha_cung_cap.robot
Resource          ../API/api_doi_tac_giaohang.robot

*** Keywords ***
Input data in form Lap phieu thu chi (Tien mat)
    [Arguments]    ${ma_phieu}    ${nhom_nguoi_nop}    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}
    Wait Until Page Contains Element    ${textbox_sq_nhap_ma_phieu}    1 min
    Input data    ${textbox_sq_nhap_ma_phieu}    ${ma_phieu}
    Select Nhom nguoi nop/nhan    ${nhom_nguoi_nop}
    Wait Until Keyword Succeeds    3 times    3s    Input ten nguoi nop/nhan    ${nhom_nguoi_nop}    ${ten_nguoi_nop}
    Select loai thu chi    ${loai_thu}
    Input data    ${textbox_sq_gia_tri}    ${gia_tri}
    Run Keyword If    '${ghi_chu}'=='none'    Log    Ignore     ELSE      Input data    ${textbox_sq_ghi_chu}    ${ghi_chu}

Select Nhom nguoi nop/nhan
    [Arguments]    ${nhom_nguoi_nop}
    Wait Until Page Contains Element    ${cell_nhom_nguoi_nop/nhan}
    Click Element    ${cell_nhom_nguoi_nop/nhan}
    ${xpath_nguoi_nop}    Format String    ${item_nhomnguoinop/nhan_indropdow}    ${nhom_nguoi_nop}
    Wait Until Page Contains Element    ${xpath_nguoi_nop}    1 min
    Click Element    ${xpath_nguoi_nop}
    #Sleep    3s    Click DMHH
    #Run Keyword If    '${nhom_nguoi_nop}'=='Khách hàng' or '${nhom_nguoi_nop}'=='Nhà cung cấp' or '${nhom_nguoi_nop}'=='Đối tác giao hàng'    Click Element    ${button_dongy_chon_doi_tac}
    #...    ELSE    Log    Ignore

Select loai thu chi
    [Arguments]    ${loai_thu_chi}
    Wait Until Page Contains Element    ${cell_tim_loai_thu_chi}    30s
    Click Element    ${cell_tim_loai_thu_chi}
    Wait Until Keyword Succeeds    3 times    3s     Input loai thu chi    ${loai_thu_chi}

Input ten nguoi nop/nhan
    [Arguments]    ${nhom_nguoi}    ${ma}
    Wait Until Page Contains Element    ${textbox_ten_nguoi_nop/nhan}    30s
    ${ten}    Run Keyword If    '${nhom_nguoi}'=='Khách hàng'    Get customer name frm API    ${ma}
    ...    ELSE IF    '${nhom_nguoi}'=='Nhà cung cấp'    Get supplier name frm API    ${ma}
    ...    ELSE IF    '${nhom_nguoi}'=='Đối tác giao hàng'    Get DTGH name frm API    ${ma}
    ...    ELSE    Set Variable    ${ma}
    ${item_ten}    Format String    ${item_tennguoi_indropdow}    ${ten}
    Input Text    ${textbox_ten_nguoi_nop/nhan}    ${ma}
    Wait Until Page Contains Element    ${item_ten}    1 min
    Click Element    ${item_ten}
    #Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${cell_ten_nguoi_nop}    ${ten}

Input data in form Lap phieu thu chi (Ngan hang)
    [Arguments]    ${ma_phieu}    ${nhom_nguoi_nop}    ${ten_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${phuong_thuc}
    ...    ${tai_khoan}    ${ghi_chu}
    Wait Until Page Contains Element    ${textbox_sq_nhap_ma_phieu}    1 min
    Input data    ${textbox_sq_nhap_ma_phieu}    ${ma_phieu}
    Select Nhom nguoi nop/nhan    ${nhom_nguoi_nop}
    Wait Until Keyword Succeeds    3 times    3s    Input ten nguoi nop/nhan    ${nhom_nguoi_nop}    ${ten_nguoi_nop}
    Select loai thu chi    ${loai_thu}
    Input data    ${textbox_sq_gia_tri}    ${gia_tri}
    Select method    ${phuong_thuc}
    Select bank account    ${tai_khoan}
    Input data    ${textbox_sq_ghi_chu}    ${ghi_chu}

Select method
    [Arguments]    ${phuong_thuc}
    Wait Until Page Contains Element    ${cell_phuongthuc}    1 min
    ${item_phuong_thuc}    Format String    ${item_phuongthuc_indropdown}    ${phuong_thuc}
    Click Element    ${cell_phuongthuc}
    Wait Until Element Is Visible    ${item_phuong_thuc}    1 min
    Click Element    ${item_phuong_thuc}

Select bank account
    [Arguments]    ${tai_khoan}
    Wait Until Page Contains Element    ${cell_chon_tai_khoan}    1 min
    ${item_tai_khoan}    Format String    ${item_tai_khoan_indropdown}    ${tai_khoan}
    Click Element    ${cell_chon_tai_khoan}
    Wait Until Element Is Visible    ${item_tai_khoan}    1 min
    Click Element    ${item_tai_khoan}

Input loai thu chi
    [Arguments]    ${loai_thu_chi}
    Wait Until Page Contains Element    ${textbox_loai_thu_chi}    30s
    ${item_loai_thu}    Format String    ${item_loaithuchi_indropdown}    ${loai_thu_chi}
    Input Text    ${textbox_loai_thu_chi}    ${loai_thu_chi}
    Sleep    3s
    Click Element    ${item_loai_thu}

Select payer group
    [Arguments]   ${cell_xpath_doituong}    ${input_payer_group}
    Wait Until Page Contains Element    ${cell_xpath_doituong}    1 min
    ${item_doituong_nop}    Format String    ${item_doituong_indropdown}    ${input_payer_group}
    Click Element JS    ${cell_xpath_doituong}
    Wait Until Element Is Visible    ${item_doituong_nop}    1 min
    Click Element JS    ${item_doituong_nop}

Update value field
    [Arguments]   ${input_value_new}
    Wait Until Page Contains Element    ${textbox_sq_gia_tri}    1 min
    Input Text    ${textbox_sq_gia_tri}    ${input_value_new}
    Click Element    ${button_sq_luu}

Cancel transaction
    Wait Until Page Contains Element    ${button_huybo}    1 min
    Click Element    ${button_huybo}
    Wait Until Page Contains Element    ${button_dongy_huybo}    1 min
    Click Element    ${button_dongy_huybo}
