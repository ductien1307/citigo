*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource          ../../../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../core/Giao_dich/hoa_don_giao_hang_action.robot
Resource          ../../../../../core/Giao_Van/giao_hang_popup_action.robot
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Giao_Van/giao_hang_nav.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/Ban_Hang_page_menu.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Library           DateTime
Resource          ../../../../../core/share/computation.robot
Resource          ../../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../../config/env_product/envi.robot

*** Test Cases ***    Ngườii nhận    SĐT                             Địa chỉ             Khu Vực                    Phường xã           Mã hàng
Info nguoi nhan       [Tags]         CBG
                      [Setup]        Create invoice with delivery    CTKH018             TL007                      1                   2          DT00020    30000    2019-10-28T04:40:43    110000
                      [Template]     ctgh_update3
                      Hoài An        0912345678                      32 Nguyễn Văn Cừ    Hà Nội - Quận Long Biên    Phường Đức Giang    TL007

*** Keywords ***
ctgh_update3
    [Arguments]    ${update_nguoinhan}    ${update_sdt}    ${update_diachi}    ${update_khuvuc}    ${update_phuongxa}    ${input_bh_ma_hang}
    #get info invoice
    ${get_first_ma_hd_in_invoice_bf_execute}    ${get_khachcantra_in_invoice_bf_execute}    ${get_trangthai_hd_number_in_invoice_bf_execute}    Get info invoice to validate DTGH    ${input_bh_ma_hang}
    ${get_tennguoinhan_bf_execute}    ${get_dienthoai_bf_execute}    ${get_dia_chi_bf_execute}    ${get_khuvuc_bf_execute}    ${get_phuongxa_bf_execute}    ${get_nguoi_gh_bf_execute}    ${get_ten_DTGH_bf_execute}
    ...    ${get_mavandon_bf_execute}    ${get_trongluong_bf_execute}    ${get_phigh_bf_execute}    ${get_thoigiangh_bf_execute}    ${get_trangthaigh_bf_execute}    Get delivery info frm invoice API
    ...    ${input_bh_ma_hang}
    ${get_tong_hd_bf_execute}    ${get_no_hientai_bf_execute}    ${get_tong_phi_gh_bf_execute}    Get cong no DTGH frm API    ${get_nguoi_gh_bf_execute}
    ${get_giatri_hd_in_tab_lichsu_bf_execute}    ${get_phi_gh_in_tab_lichsu_bf_execute}    ${get_ttgh_in_tab_lichsu_bf_execute}    Get info tab lich su giao hang    ${get_nguoi_gh_bf_execute}    ${get_first_ma_hd_in_invoice_bf_execute}
    ${get_loai_tab_congno_bf_execute}    ${get_giatri_tab_congno_bf_execute}    ${get_nohientai_tab_congno_bf_execute}    Get info tab phi can tra DTGH frm API    ${get_nguoi_gh_bf_execute}    ${get_first_ma_hd_in_invoice_bf_execute}
    ${result_thoigian_gh_bf_execute}    Convert Date time    ${get_thoigiangh_bf_execute}
    #input data into invoice delivery
    Before Test Quan ly
    Go to Hoa don
    Select to hoa don    ${get_first_ma_hd_in_invoice_bf_execute}
    Update invoice delivery with textbox field    Người nhận    ${update_nguoinhan}
    Update invoice delivery with textbox field    Điện thoại    ${update_sdt}
    Update dia chi frm invoice delivery    ${update_diachi}
    Update khu vuc frm invoice delivery    ${update_khuvuc}
    Update phuong xa frm invoice delivery    ${update_phuongxa}
    Click Element JS    ${button_luu_hd}
    Update invoice success validation    ${get_first_ma_hd_in_invoice_bf_execute}
    #get info invoice after update
    ${get_first_ma_hd_af_execute}    ${get_khachcantra_af_execute}    ${get_trangthai_hd_number_af_execute}    Get info invoice to validate DTGH    ${input_bh_ma_hang}
    ${get_tennguoinhan_af_execute}    ${get_dienthoai_af_execute}    ${get_dia_chi_af_execute}    ${get_khuvuc_af_execute}    ${get_phuongxa_af_execute}    ${get_nguoi_gh_af_execute}    ${get_ten_DTGH_af_execute}
    ...    ${get_mavandon_af_execute}    ${get_trongluong_af_execute}    ${get_phi_gh_af_execute}    ${get_thoigian_gh_af_execute}    ${get_trangthai_gh_af_execute}    Get delivery info frm invoice API
    ...    ${input_bh_ma_hang}
    ${get_tong_hd_af_execute}    ${get_no_hientai_af_execute}    ${get_tong_phi_gh_af_execute}    Get cong no DTGH frm API    ${get_nguoi_gh_af_execute}
    ${get_giatri_hd_in_tab_lichsu_af_execute}    ${get_phi_gh_in_tab_lichsu_af_execute}    ${get_ttgh_in_tab_lichsu_af_execute}    Get info tab lich su giao hang    ${get_nguoi_gh_af_execute}    ${get_first_ma_hd_af_execute}
    ${get_loai_tab_congno_af_execute}    ${get_giatri_tab_congno_af_execute}    ${get_nohientai_tab_congno_af_execute}    Get info tab phi can tra DTGH frm API    ${get_nguoi_gh_af_execute}    ${get_first_ma_hd_af_execute}
    #assert value invoice
    Should Be Equal As Strings    ${get_tennguoinhan_af_execute}    ${update_nguoinhan}
    Should Be Equal As Numbers    ${get_dienthoai_af_execute}    ${update_sdt}
    Should Be Equal As Strings    ${get_dia_chi_af_execute}    ${update_diachi}
    Should Be Equal As Strings    ${get_khuvuc_af_execute}    ${update_khuvuc}
    Should Be Equal As Strings    ${get_phuongxa_af_execute}    ${update_phuongxa}
    Should Be Equal As Strings    ${get_nguoi_gh_af_execute}    ${get_nguoi_gh_bf_execute}
    Should Be Equal As Numbers    ${get_mavandon_af_execute}    0
    Should Be Equal As Numbers    ${get_trongluong_af_execute}    ${get_trongluong_bf_execute}
    Should Be Equal As Numbers    ${get_phi_gh_af_execute}    ${get_phigh_bf_execute}
    ${result_thoigian_gh}    Convert Date time    ${get_thoigian_gh_af_execute}
    Should Be Equal As Strings    ${result_thoigian_gh}    ${result_thoigian_gh_bf_execute}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '1' or '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '6'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    3
    Run Keyword If    '${get_trangthaigh_af_execute}' == '3'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    1
    Run Keyword If    '${get_trangthaigh_af_execute}' == '5'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    5
    #assert ĐTGH
    Should Be Equal As Numbers    ${get_giatri_hd_in_tab_lichsu_af_execute}    ${get_giatri_hd_in_tab_lichsu_bf_execute}
    Should Be Equal As Numbers    ${get_phi_gh_in_tab_lichsu_af_execute}    ${get_phi_gh_in_tab_lichsu_bf_execute}
    Should Be Equal As Numbers    ${get_ttgh_in_tab_lichsu_af_execute}    ${get_ttgh_in_tab_lichsu_bf_execute}
    Should Be Equal As Numbers    ${get_loai_tab_congno_af_execute}    ${get_loai_tab_congno_bf_execute}
    Should Be Equal As Numbers    ${get_giatri_tab_congno_af_execute}    ${get_giatri_tab_congno_bf_execute}
    Should Be Equal As Numbers    ${get_nohientai_tab_congno_af_execute}    ${get_nohientai_tab_congno_bf_execute}
    #assert value partner
    Should Be Equal As Numbers    ${get_tong_hd_af_execute}    ${get_tong_hd_bf_execute}
    Should Be Equal As Numbers    ${get_no_hientai_af_execute}    ${get_no_hientai_bf_execute}
    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${get_tong_phi_gh_bf_execute}
