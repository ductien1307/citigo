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

*** Test Cases ***    Mã KH         Mã hàng                         Nguoi nhan      SDT           Dia chi            Khu Vuc                    Phuong Xa         Nguoi giao    Phi GH                 Trong luong    Thoi gian GH        Trang thai GH
Basic                 [Setup]       Create invoice with delivery    CTKH009         TL001         1                  1                          DT00011           15000         2019-10-28T04:40:43    100000
                      [Template]    ctgh_customer
                      CTKH009       TL001                           Ngụy Anh Lạc    0234567890    389 Trương Định    Hà Nội - Quận Hoàng Mai    Phường Tân Mai    Shipper       30000                  2              25/01/2019 10:00    Đang chuyển hoàn

*** Keywords ***
ctgh_customer
    [Arguments]    ${input_ma_hang}    ${update_nguoinhan}    ${update_sdt}    ${update_diachi}    ${update_khuvuc}    ${update_phuongxa}
    ...    ${update_nguoigiao}    ${update_phi_gh}    ${update_trongluong}    ${update_thoigian_gh}    ${update_trangthai_gh}
    #get info invoice
    ${get_first_ma_hd_in_hd_bf_execute}    ${get_phi_gh_in_hd_bf_execute}    ${get_ma_kh_in_hd_bf_execute}    ${get_kh_tt_in_hd_bf_execute}    Get phi GH khach thanh toan ma KH frm Invoice API    ${input_ma_hang}
    ${get_no_hientai_kh_bf_execute}    ${get_tongban_kh_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${get_ma_kh_in_hd_bf_execute}
    ${get_giatri_hd_bf_execute}    ${get_du_no_hd_bf_execute}    ${get_type_hd_bf_execute}    ${get_giatri_phieu_tt_bf_execute}    ${get_du_no_phieu_tt_bf_execute}    ${get_type_phieu_tt_bf_execute}    Get tab no can thu tu khach if Invoice is paid
    ...    ${get_ma_kh_in_hd_bf_execute}    ${get_first_ma_hd_in_hd_bf_execute}
    ${get_giatri_hd_bf_execute}    ${get_du_no_hd_bf_execute}    ${get_type_hd_bf_execute}    Get tab no can thu tu khach if Invoice is not paid    ${get_ma_kh_in_hd_bf_execute}    ${get_first_ma_hd_in_hd_bf_execute}
    ${get_tongcong_bf_execute}    ${get_trangthai_bf_execute}    ${get_type_bf_execute}    Get lich su ban tra hang frm API    ${get_ma_kh_in_hd_bf_execute}    ${get_first_ma_hd_in_hd_bf_execute}
    #compute
    #input data into invoice delivery
    Before Test Quan ly
    Go to Hoa don
    Select to hoa don    ${get_first_ma_hd_in_hd_bf_execute}
    Update invoice delivery with textbox field    Người nhận    ${update_nguoinhan}
    Update invoice delivery with textbox field    Điện thoại    ${update_sdt}
    Update dia chi frm invoice delivery    ${update_diachi}
    Update khu vuc frm invoice delivery    ${update_khuvuc}
    Update phuong xa frm invoice delivery    ${update_phuongxa}
    Update nguoi giao frm invoice delivery    ${update_nguoigiao}
    Update invoice delivery with textbox field    Trọng lượng    ${update_trongluong}
    Update invoice delivery with textbox field    Phí giao hàng    ${update_phi_gh}
    Update time giao hang frm invoice delivery    ${update_thoigian_gh}
    Update trang thai giao hang frm invoice delivery    ${update_trangthai_gh}
    Click Element JS    ${button_luu_hd}
    Update invoice success validation    ${get_first_ma_hd_in_hd_bf_execute}
    #get info invoice after update
    ${get_first_ma_hd_af_execute}    ${get_khachcantra_af_execute}    ${get_trangthai_hd_number_af_execute}    Get info invoice to validate DTGH    ${input_ma_hang}
    ${get_ma_hd_in_hd_af_execute}    ${get_phi_gh_in_hd_af_execute}    ${get_ma_kh_in_hd_af_execute}    ${get_kh_tt_in_hd_af_execute}    Get phi GH khach thanh toan ma KH frm Invoice API    ${input_ma_hang}
    ${get_no_hientai_kh_af_execute}    ${get_tongban_kh_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${get_ma_kh_in_hd_af_execute}
    ${get_no_hientai_kh_af_execute}    ${get_tongban_kh_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${get_ma_kh_in_hd_bf_execute}
    #assert khách hàng
    Should Be Equal As Numbers    ${get_no_hientai_kh_af_execute}    ${get_no_hientai_kh_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_kh_af_execute}    ${get_tongban_kh_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    "${get_khachcantra_af_execute}" == "0"    Validate history tab in customer with invoice's update    ${get_ma_kh_in_hd_af_execute}    ${get_ma_hd_in_hd_af_execute}    ${input_ma_hang}    ${get_tongcong_bf_execute}
    ...    ${get_trangthai_bf_execute}    ${get_type_bf_execute}
    Run Keyword If    "${get_kh_tt_in_hd_af_execute}" == "0"    Validate history and debt in customer if invoice's update is not paid    ${get_ma_kh_in_hd_af_execute}    ${get_ma_hd_in_hd_af_execute}    ${input_ma_hang}    ${get_giatri_hd_bf_execute}
    ...    ${get_du_no_hd_bf_execute}    ${get_tongcong_bf_execute}    ${get_trangthai_bf_execute}
    Run Keyword If    "${get_kh_tt_in_hd_af_execute}" != "0"    Validate history and debt in customer if invoice's update is paid    ${get_ma_kh_in_hd_af_execute}    ${get_ma_hd_in_hd_af_execute}    ${input_ma_hang}    ${get_giatri_hd_bf_execute}
    ...    ${get_du_no_hd_bf_execute}    ${get_type_hd_bf_execute}    ${get_giatri_phieu_tt_bf_execute}    ${get_du_no_phieu_tt_bf_execute}    ${get_type_phieu_tt_bf_execute}    ${get_tongcong_bf_execute}
    ...    ${get_trangthai_bf_execute}    ${get_type_bf_execute}

ctgh_customer_up
    #get info invoice
