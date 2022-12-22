*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test So Quy
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/So_Quy/so_quy_add_action.robot
Resource          ../../../core/So_Quy/so_quy_add_page.robot

*** Variables ***

*** Test Cases ***    Loại đối tác    Mã đối tác    Loại thu chi    Giá trị    Ghi chú     Hạch toán    Công nợ
Phieu thu             [Tags]          SQ
                      [Template]      sqtm_thu
                      Khách hàng      CTKH009       Thu 1           40000      thu tiền    yes          yes
                      Nhà cung cấp    NCC0002       Thu 2           900000     thu tiền    yes          no
                      Nhà cung cấp    NCC0002       Thu 3           150000     thu tiền    no           yes

Phieu chi             [Tags]          SQ
                      [Template]      sqtm_chi
                      Khách hàng      CTKH121       Chi 1           190000     chi tiền    yes          no
                      Nhà cung cấp    NCC0008       Chi 2           265400     chi tiền    yes          yes
                      Nhà cung cấp    NCC0006       Chi 3           999650     chi tiền    no           no

Golive thu            [Tags]          GOLIVE3
                      [Template]      sqtm_thu
                      Khách hàng      CTKH122       Thu 1           40000      thu tiền    yes      yes

Golive chi            [Tags]          GOLIVE3
                      [Template]      sqtm_chi
                      Nhà cung cấp    NCC0008       Chi 2           265400     chi tiền    yes      no

*** Keywords ***
sqtm_thu
    [Arguments]    ${nhom_nguoi_nop}    ${ma_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}    ${hachtoan}     ${congno}
    Set Selenium Speed    0.1
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add receipt    ${gia_tri}
    Click Element     ${button_lap_phieu_thu}
    ${ma_phieu}    Generate code automatically    TTM
    Input data in form Lap phieu thu chi (Tien mat)    ${ma_phieu}    ${nhom_nguoi_nop}    ${ma_nguoi_nop}    ${loai_thu}    ${gia_tri}    ${ghi_chu}
    Run Keyword If    '${hachtoan}'=='yes'    Click Element    ${checkbox_hach_toan}
    ...    ELSE    Log    Ignore hach toan
    Click Element    ${button_sq_luu}
    Run Keyword If    '${congno}'=='yes'     Wait Until Keyword Succeeds    3 times    2s    Click Element    ${button_thaydoi_congno_co}      ELSE    Wait Until Keyword Succeeds    3 times    2s   Click Element    ${button_thaydoi_congno_khong}
    Sleep    5s
    #validate thong tin cb va chi tiet phieu
    ${ten_nguoi_nop}    Run Keyword If    '${nhom_nguoi_nop}'=='Khách hàng'    Get customer name frm API    ${ma_nguoi_nop}
    ...    ELSE IF    '${nhom_nguoi_nop}'=='Nhà cung cấp'    Get supplier name frm API    ${ma_nguoi_nop}
    ...    ELSE IF    '${nhom_nguoi_nop}=='Đối tác giao hàng'    Get DTGH name frm API    ${ma_nguoi_nop}
    ...    ELSE    Set Variable    ${ma_nguoi_nop}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_thu}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nop}
    Should Be Equal As Numbers    ${get_gia_tri}    ${gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    #validate tab cong no
    ${get_no}    Run Keyword If    '${nhom_nguoi_nop}'=='Khách hàng'    Get customer debt after cash flow    ${ma_nguoi_nop}    ${ma_phieu}
    ...    ELSE IF    '${nhom_nguoi_nop}'=='Nhà cung cấp'    Get supplier debt after cash flow    ${ma_nguoi_nop}    ${ma_phieu}
    ...    ELSE    Get DTGH debt after cash flow    ${ma_nguoi_nop}    ${ma_phieu}
    ${get_no}    Minus    0    ${get_no}
    Run Keyword If    '${congno}'=='yes'    Should Be Equal As Numbers    ${get_no}    ${gia_tri}   ELSE      Should Be Equal As Numbers    ${get_no}    0
    Delete payment frm API    ${ma_phieu}
    Reload Page

sqtm_chi
    [Arguments]    ${nhom_nguoi_nhan}    ${ma_nguoi_nhan}    ${loai_chi}    ${gia_tri}    ${ghi_chu}    ${hachtoan}   ${congno}
    Set Selenium Speed    0.1
    ${result_quy_dau_ky}    ${result_tong_thu}    ${result_tong_chi}    ${result_ton_quy}    Compute balance in tab Tien mat af add payment    ${gia_tri}
    Click Element     ${button_lap_phieu_chi}
    ${ma_phieu}    Generate code automatically    CTM
    Input data in form Lap phieu thu chi (Tien mat)    ${ma_phieu}    ${nhom_nguoi_nhan}    ${ma_nguoi_nhan}    ${loai_chi}    ${gia_tri}    ${ghi_chu}
    Run Keyword If    '${hachtoan}'=='yes'    Click Element    ${checkbox_hach_toan}
    ...    ELSE    Log    Ignore hach toan
    Click Element    ${button_sq_luu}
    Run Keyword If    '${congno}'=='yes'   Wait Until Keyword Succeeds    3 times    2s    Click Element    ${button_thaydoi_congno_co}      ELSE    Wait Until Keyword Succeeds    3 times    2s   Click Element    ${button_thaydoi_congno_khong}
    Sleep    5s
    #validate thong tin, chi tiet phieu
    ${ten_nguoi_nhan}    Run Keyword If    '${nhom_nguoi_nhan}'=='Khách hàng'    Get customer name frm API    ${ma_nguoi_nhan}
    ...    ELSE IF    '${nhom_nguoi_nhan}'=='Nhà cung cấp'    Get supplier name frm API    ${ma_nguoi_nhan}
    ...    ELSE IF    '${nhom_nguoi_nhan}=='Đối tác giao hàng'    Get DTGH name frm API    ${ma_nguoi_nhan}
    ...    ELSE    Set Variable    ${ma_nguoi_nhan}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    ${result_gia_tri}    Minus    0    ${gia_tri}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_loai_thu_chi}    ${loai_chi}
    Should Be Equal As Strings    ${get_ten}    ${ten_nguoi_nhan}
    Should Be Equal As Numbers    ${get_gia_tri}    ${result_gia_tri}
    ${get_phuongthuc_detail}    ${get_trang_thai_detail}    ${get_gia_tri_detail}    ${get_hach_toan}    Get payment detail frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc_detail}    Cash
    Should Be Equal As Numbers    ${get_trang_thai_detail}    0
    Should Be Equal As Numbers    ${get_gia_tri_detail}    ${get_gia_tri}
    Run Keyword If    '${hachtoan}'=='yes'    Should Be Equal As Strings    ${get_hach_toan}    True
    ...    ELSE    Should Be Equal As Numbers    ${get_hach_toan}    0
    #validate ton quy
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${get_ton_quy}    Evaluate    round(${get_ton_quy}, 0)
    Should Be Equal As Numbers    ${get_quy_dau_ky}    ${result_quy_dau_ky}
    Should Be Equal As Numbers    ${get_tong_thu}    ${result_tong_thu}
    Should Be Equal As Numbers    ${get_tong_chi}    ${result_tong_chi}
    Should Be Equal As Numbers    ${get_ton_quy}    ${result_ton_quy}
    #validate tab cong no
    ${get_no}    Run Keyword If    '${nhom_nguoi_nhan}'=='Khách hàng'    Get customer debt after cash flow    ${ma_nguoi_nhan}    ${ma_phieu}
    ...    ELSE IF    '${nhom_nguoi_nhan}'=='Nhà cung cấp'    Get supplier debt after cash flow    ${ma_nguoi_nhan}    ${ma_phieu}
    ...    ELSE    Get DTGH debt after cash flow    ${ma_nguoi_nhan}    ${ma_phieu}
    Run Keyword If    '${congno}'=='yes'    Should Be Equal As Numbers    ${get_no}    ${gia_tri}   ELSE      Should Be Equal As Numbers    ${get_no}    0
    Delete payment frm API    ${ma_phieu}
    Reload Page
