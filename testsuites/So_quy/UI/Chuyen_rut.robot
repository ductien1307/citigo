*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test So Quy
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_add_action.robot
Resource          ../../../core/So_Quy/so_quy_add_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/soquy.robot
Resource          ../../../core/share/javascript.robot

*** Test Cases ***    Loại thu chi       Giá trị        Tài khoản nộp       Hạch toán        Cashflow cash type     Cashflow transfer type
Tien_mat             [Tags]          UCR
                      [Template]      chuyenrut_tm
                      Chuyển/Rút       500000         1900347347348       yes           Thu                    Chi
                      Chuyển/Rút       1000000         005407093473        no            Chi                    Thu


Ngan_hang             [Tags]          UCR
                      [Template]      chuyenrut_nh
                      Chuyển/Rút       350000      44509300485745      005407093473        no            Chi                    Thu
                      Chuyển/Rút       4000000      1900347347348       44509300485745      yes           Thu                    Chi


*** Keywords ***
chuyenrut_tm
    [Arguments]    ${loai_thu_chi}    ${gia_tri}    ${input_taikhoan}    ${hachtoan}    ${cashflow_cash_type}    ${cashflow_bank_type}
    Set Selenium Speed    0.5s
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat with other branch    ${BRANCH_ID}
    ...    ${gia_tri}    ${cashflow_cash_type}
    ${result_quy_dau_ky_bank}    ${result_tong_thu_bank}    ${result_tong_chi_bank}    ${result_ton_quy_bank}    Compute balance in tab Ngan hang with other branch    ${BRANCH_ID}
    ...    ${gia_tri}    ${cashflow_bank_type}
    Run Keyword If    '${cashflow_cash_type}' == 'Thu'    Click Element     ${button_lap_phieu_thu}    ELSE    Click Element     ${button_lap_phieu_chi}
    ${ma_phieu}    Run Keyword If    '${cashflow_cash_type}' == 'Thu'    Generate code automatically    TTM    ELSE    Generate code automatically    CTM
    Wait Until Page Contains Element    ${textbox_sq_nhap_ma_phieu}    1 min
    Input data    ${textbox_sq_nhap_ma_phieu}    ${ma_phieu}
    Select loai thu chi    ${loai_thu_chi}
    Input data    ${textbox_sq_gia_tri}    ${gia_tri}
    ${gia_tri_macdinh}    Set Variable If    '${cashflow_cash_type}' == 'Thu'     Chọn tài khoản nộp     Chọn tài khoản nhận
    ${cell_taikhoan}    Format String     ${cell_chon_tai_khoan_indropdown}    ${gia_tri_macdinh}
    Wait Until Page Contains Element    ${cell_taikhoan}    30s
    ${item_taikhoannop}    Format String    ${item_tai_khoan_indropdown}    ${input_taikhoan}
    Click Element JS    ${cell_taikhoan}
    Click Element JS    ${item_taikhoannop}
    Run Keyword If    '${hachtoan}'=='yes'    Click Element    ${checkbox_hach_toan}    ELSE    Log    Ignore hach toan
    Click Element    ${button_sq_luu}
    Sleep    10s
    ${get_maphieu_tudong}   Get automatic payment code frm api    ${ma_phieu}
    #validate chi tiet phieu
    ${get_gia_tri}    ${get_loai_thu_chi}    ${get_ten}    ${get_trang_thai}    ${get_doituongnop}    ${get_hachtoan}    Get cashflow info frm API    ${ma_phieu}
    ${gia_tri}    Run Keyword If    '${cashflow_cash_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    Should Be Equal As Strings    ${get_loai_thu_chi}    Chuyển rút
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop}    ${input_taikhoan}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    Log     Validate phieu chi tu dong
    ${gia_tri}    Run Keyword If    '${cashflow_cash_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    #validate chi tiet phieu tu dong
    ${get_gia_tri_bank}    ${get_loai_thu_chi_bank}    ${get_ten_bank}    ${get_trang_thai_bank}    ${get_doituongnop_bank}    ${get_hachtoan_bank}    Get cashflow info with automatic payment    ${get_maphieu_tudong}
    ${gia_tri_bank}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri_bank}    ${gia_tri_bank}
    Should Be Equal As Strings    ${get_loai_thu_chi_bank}    0
    Should Be Equal As Strings    ${get_trang_thai_bank}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop_bank}    anh.lv
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    Log     Validate ton quy tu dong
    #validate ton quy cua phieu tu dong
    ${get_quy_dau_ky_bank}    ${get_tong_thu_bank}    ${get_tong_chi_bank}    ${get_ton_quy_bank}    Get balance in So quy Ngan hang
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky_bank}    ${result_quy_dau_ky_bank}
    Should Be Equal As Numbers    ${get_tong_thu_bank}    ${result_tong_thu_bank}
    Should Be Equal As Numbers    ${get_tong_chi_bank}    ${result_tong_chi_bank}
    Should Be Equal As Numbers    ${get_ton_quy_bank}    ${result_ton_quy_bank}
    Delete payment frm API    ${ma_phieu}

chuyenrut_nh
    [Arguments]    ${loai_thu_chi}    ${gia_tri}    ${input_taikhoan_nop}    ${input_taikhoan_nhan}    ${hachtoan}    ${cashflow_bank_type}    ${cashflow_bank1_type}
    Set Selenium Speed    0.5s
    ${get_quy_dau_ky_bank_bf_ex}    ${get_tong_thu_bank_bf_ex}    ${get_tong_chi_bank_bf_ex}    ${get_ton_quy_bank_bf_ex}    Get balance in So quy Ngan hang
    ${result_tong_thu_bank}   Sum    ${get_tong_thu_bank_bf_ex}    ${gia_tri}
    ${result_tong_chi_bank}   Minus    ${get_tong_chi_bank_bf_ex}    ${gia_tri}
    Click Element JS    ${button_tab_ngan_hang}
    Run Keyword If    '${cashflow_bank_type}' == 'Thu'    Click Element     ${button_lap_phieu_thu}    ELSE    Click Element     ${button_lap_phieu_chi}
    ${ma_phieu}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'    Generate code automatically    TNHH    ELSE    Generate code automatically    CNH
    Wait Until Page Contains Element    ${textbox_sq_nhap_ma_phieu}    1 min
    Input data    ${textbox_sq_nhap_ma_phieu}    ${ma_phieu}
    Select loai thu chi    ${loai_thu_chi}
    Input data    ${textbox_sq_gia_tri}    ${gia_tri}
    ${gia_tri_macdinh}    Set Variable If    '${cashflow_bank_type}' == 'Thu'     Chọn tài khoản nộp     Chọn tài khoản nhận
    ${cell_taikhoan}    Format String     ${cell_chon_tai_khoan_indropdown}    ${gia_tri_macdinh}
    Wait Until Page Contains Element    ${cell_taikhoan}    30s
    ${item_taikhoan}    Format String    ${item_taikhoan_thuchi_indropdown}    ${gia_tri_macdinh}    ${input_taikhoan_nop}
    Click Element JS    ${cell_taikhoan}
    Click Element    ${item_taikhoan}
    ${gia_tri_macdinh1}    Set Variable If    '${cashflow_bank1_type}' == 'Thu'     Chọn tài khoản gửi     Chọn tài khoản nhận
    ${cell_taikhoan1}    Format String     ${cell_chon_tai_khoan_indropdown}    ${gia_tri_macdinh1}
    Wait Until Page Contains Element    ${cell_taikhoan1}    30s
    ${item_taikhoan1}    Format String    ${item_taikhoan_thuchi_indropdown}    ${gia_tri_macdinh1}    ${input_taikhoan_nhan}
    Click Element JS    ${cell_taikhoan1}
    Click Element    ${item_taikhoan1}
    Run Keyword If    '${hachtoan}'=='yes'    Click Element    ${checkbox_hach_toan}    ELSE    Log    Ignore hach toan
    Click Element    ${button_sq_luu}
    Sleep    10s
    ${get_maphieu_tudong}   Get automatic payment code frm api    ${ma_phieu}
    #validate chi tiet phieu
    ${get_gia_tri}    ${get_loai_thu_chi}    ${get_ten}    ${get_trang_thai}    ${get_doituongnop}    ${get_hachtoan}    Get cashflow info frm API    ${ma_phieu}
    ${gia_tri}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    Should Be Equal As Strings    ${get_loai_thu_chi}    Chuyển rút
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop}    ${input_taikhoan_nop}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    Log     Validate phieu chi tu dong
    ${gia_tri}    Run Keyword If    '${cashflow_bank_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    #validate chi tiet phieu tu dong
    ${get_gia_tri_bank}    ${get_loai_thu_chi_bank}    ${get_ten_bank}    ${get_trang_thai_bank}    ${get_doituongnop_bank}    ${get_hachtoan_bank}    Get cashflow info with automatic payment    ${get_maphieu_tudong}
    ${gia_tri_bank}    Run Keyword If    '${cashflow_bank1_type}' == 'Thu'   Set Variable    ${gia_tri}    ELSE    Minus     0     ${gia_tri}
    Should Be Equal As Numbers    ${get_gia_tri_bank}    ${gia_tri_bank}
    Should Be Equal As Strings    ${get_loai_thu_chi_bank}    Chuyển rút
    Should Be Equal As Strings    ${get_trang_thai_bank}    Đã thanh toán
    Should Be Equal As Strings    ${get_doituongnop_bank}    ${input_taikhoan_nhan}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Numbers    ${get_hachtoan}    1      ELSE    Should Be Equal As Numbers    ${get_hachtoan}    0
    #validate ton quy cua phieu tu dong
    ${get_quy_dau_ky_bank}    ${get_tong_thu_bank}    ${get_tong_chi_bank}    ${get_ton_quy_bank}    Get balance in So quy Ngan hang
    ${get_ton_quy_bank}    Evaluate    round(${get_ton_quy_bank}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky_bank}    ${get_quy_dau_ky_bank_bf_ex}
    Should Be Equal As Numbers    ${get_tong_thu_bank}    ${result_tong_thu_bank}
    Should Be Equal As Numbers    ${get_tong_chi_bank}    ${result_tong_chi_bank}
    Should Be Equal As Numbers    ${get_ton_quy_bank}    ${get_ton_quy_bank_bf_ex}
    #Delete payment frm API    ${ma_phieu}
