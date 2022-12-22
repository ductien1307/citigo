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

*** Test Cases ***    Phí giao hàng    Mã SP
Basic                 [Tags]           CBG
                      [Setup]          Create invoice with delivery    CTKH019    TL008    3    2    DT00021    30000    2019-10-28T04:40:43    120000
                      [Template]       ctgh_update7
                      0                TL008

*** Keywords ***
ctgh_update7
    [Arguments]    ${update_phi_gh}    ${input_ma_sp}
    #get info invoice
    ${get_first_ma_hd_in_invoice_bf_execute}    ${get_khachcantra_in_invoice_bf_execute}    ${get_trangthai_hd_number_in_invoice_bf_execute}    Get info invoice to validate DTGH    ${input_ma_sp}
    ${get_tennguoinhan_bf_execute}    ${get_dienthoai_bf_execute}    ${get_dia_chi_bf_execute}    ${get_khuvuc_bf_execute}    ${get_phuongxa_bf_execute}    ${get_nguoi_gh_bf_execute}    ${get_ten_DTGH_bf_execute}
    ...    ${get_mavandon_bf_execute}    ${get_trongluong_bf_execute}    ${get_phigh_bf_execute}    ${get_thoigiangh_bf_execute}    ${get_trangthaigh_bf_execute}    Get delivery info frm invoice API
    ...    ${input_ma_sp}
    ${get_first_ma_hd_tab_lichsu_gh}    ${get_ma_DTGH}    ${get_id_DTGH}    Get info ĐTGH frm APi    ${get_ten_DTGH_bf_execute}
    ${get_tong_hd_bf_execute}    ${get_no_hientai_bf_execute}    ${get_tong_phi_gh_bf_execute}    Get cong no DTGH frm API    ${get_ma_DTGH}
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    ${get_loai_tab_congno_bf_execute}    ${get_giatri_tab_congno_bf_execute}    ${get_nohientai_tab_congno_bf_execute}    Get info tab phi can tra DTGH frm API    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    ${get_thoigiangh_bf_execute}    Convert Date time    ${get_thoigiangh_bf_execute}
    #compute
    ${result_tong_hd}    Sum    ${get_tong_hd_bf_execute}    1
    ${result_tong_phi_gh_hientai}    Minus    ${get_tong_phi_gh_bf_execute}    ${get_phigh_bf_execute}
    ${resul_no_cantra_hientai}    Sum    ${get_no_hientai_bf_execute}    ${get_phigh_bf_execute}
    ${result_no_hientai_in_tab_congno}    Sum    ${get_nohientai_tab_congno_bf_execute}    ${update_phi_gh}
    #input data into invoice delivery
    Before Test Quan ly
    Go to Hoa don
    Select to hoa don    ${get_first_ma_hd_in_invoice_bf_execute}
    Update invoice delivery with textbox field    Phí giao hàng    ${update_phi_gh}
    Click Element JS    ${button_luu_hd}
    Update invoice success validation    ${get_first_ma_hd_in_invoice_bf_execute}
    #get info invoice after update
    ${get_first_ma_hd_af_execute}    ${get_khachcantra_af_execute}    ${get_trangthai_hd_number_af_execute}    Get info invoice to validate DTGH    ${input_ma_sp}
    ${get_tennguoinhan_af_execute}    ${get_dienthoai_af_execute}    ${get_dia_chi_af_execute}    ${get_khuvuc_af_execute}    ${get_phuongxa_af_execute}    ${get_nguoi_gh_af_execute}    ${get_ten_DTGH_af_execute}
    ...    ${get_mavandon_af_execute}    ${get_trongluong_af_execute}    ${get_phi_gh_af_execute}    ${get_thoigian_gh_af_execute}    ${get_trangthai_gh_af_execute}    Get delivery info frm invoice API
    ...    ${input_ma_sp}
    ${get_tong_hd_af_execute}    ${get_no_hientai_af_execute}    ${get_tong_phi_gh_af_execute}    Get cong no DTGH frm API    ${get_nguoi_gh_af_execute}
    #assert value invoice
    Should Be Equal As Strings    ${get_tennguoinhan_af_execute}    ${get_tennguoinhan_bf_execute}
    Should Be Equal As Numbers    ${get_dienthoai_af_execute}    ${get_dienthoai_bf_execute}
    Should Be Equal As Strings    ${get_dia_chi_af_execute}    ${get_dia_chi_bf_execute}
    Should Be Equal As Strings    ${get_khuvuc_af_execute}    ${get_khuvuc_bf_execute}
    Should Be Equal As Strings    ${get_phuongxa_af_execute}    ${get_phuongxa_bf_execute}
    Should Be Equal As Strings    ${get_ten_DTGH_af_execute}    ${get_ten_DTGH_bf_execute}
    Should Be Equal As Numbers    ${get_mavandon_af_execute}    0
    Should Be Equal As Numbers    ${get_trongluong_af_execute}    ${get_trongluong_bf_execute}
    Should Be Equal As Numbers    ${get_phi_gh_af_execute}    ${update_phi_gh}
    ${result_thoigian_gh}    Convert Date time    ${get_thoigian_gh_af_execute}
    Should Be Equal As Strings    ${result_thoigian_gh}    ${get_thoigiangh_bf_execute}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '1' or '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '6'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    3
    Run Keyword If    '${get_trangthaigh_af_execute}' == '3'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    1
    Run Keyword If    '${get_trangthaigh_af_execute}' == '5'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    5
    #assert ĐTGH
    Validate partnerdelivery if Phi giao hang is set zero    ${get_nguoi_gh_af_execute}    ${input_ma_sp}
    #assert value partner
    Should Be Equal As Numbers    ${get_tong_hd_af_execute}    ${get_tong_hd_bf_execute}
    Run Keyword If    '${get_phigh_bf_execute}' == '${update_phi_gh}'    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${get_tong_phi_gh_bf_execute}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${result_tong_phi_gh_hientai}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang is set zero    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}    ${get_phigh_bf_execute}
