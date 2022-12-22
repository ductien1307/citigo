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

*** Test Cases ***    Mã hàng            Nguoi nhan                                        SDT             Dia chi             Khu Vuc                       Phuong Xa               Nguoi giao             Phi GH    Trong luong            Thoi gian GH        Trang thai GH
TTGH is 1_2_4_6       [Documentation]    1. Create invoice with delivery 2. Before Test
                      [Tags]             CBG
                      [Setup]            Create invoice with delivery                      CTKH012         TL004               2                             1                       DT00014                15000     2019-10-28T04:40:43    160000
                      [Template]         ctgh_update1
                      TL004              Phú Sát Dung Ân                                   0987654321      20 Phố Huế          Hà Nội - Quận Hai Bà Trưng    Phường Bạch Đằng        Shipper                25000     2.3                    25/01/2019 10:00    Đang giao hàng
                      TL004              Phú Sát Phó Hằng                                  01234567465     17 Hai Bà Trưng     Hà Nội - Quận Hoàn Kiếm       Phường Trần Hưng Đạo    Giao hàng tiết kiệm    15000     1.8                    25/01/2019 10:00    Chưa giao hàng
                      TL004              Ngụy Anh Lạc                                      0234567890      389 Trương Định     Hà Nội - Quận Hoàng Mai       Phường Tân Mai          Shipper                30000     2                      25/01/2019 10:00    Đang chuyển hoàn
                      TL004              Thu Thảo                                          016789453678    Định Công           Hà Nội - Quận Cầu Giấy        Phường Định Công        Viettel pos            15000     1                      25/01/2019 10:00    Đã hủy

TTGH la giao thanh cong
                      [Tags]             CBG
                      [Setup]            Create invoice with delivery                      CTKH013         TL005               1                             2                       DT00015                20000     2019-10-28T04:40:43    90000
                      [Template]         ctgh_update2
                      TL005              Hoàng thượng                                      0982123456      Ecohom Phúc Lợi     Hà Nội - Quận Long Biên       Phường Phúc Lợi         Shipper                20000     3                      25/01/2019 10:00    Giao thành công

TTGH la Da chuyen hoan
                      [Tags]             CBG
                      [Setup]            Create invoice with delivery                      CTKH014         TL006               3                             2                       DT00016                25000     2019-10-28T04:40:43    300000
                      [Template]         ctgh_update2
                      TL006              Chị Mai                                           01234567890     24 Dịch Vọng Hậu    Hà Nội - Quận Cầu Giấy        Phường Dịch Vọng Hậu    Shipper                10000     2                      25/01/2019 10:00    Đã chuyển hoàn

*** Keywords ***
ctgh_update1
    [Arguments]    ${input_ma_hang}    ${update_nguoinhan}    ${update_sdt}    ${update_diachi}    ${update_khuvuc}    ${update_phuongxa}
    ...    ${update_nguoigiao}    ${update_phi_gh}    ${update_trongluong}    ${update_thoigian_gh}    ${update_trangthai_gh}
    #get info invoice
    ${get_first_ma_hd_in_hd_bf_execute}    ${get_khachcantra_in_hd_bf_execute}    ${get_trangthai_hd_number_in_hd_bf_execute}    Get info invoice to validate DTGH    ${input_ma_hang}
    ${get_first_ma_hd_in_hd_bf_execute}    ${get_phi_gh_in_hd_bf_execute}    ${get_ma_kh_in_hd_bf_execute}    ${get_kh_tt_in_hd_bf_execute}    Get phi GH khach thanh toan ma KH frm Invoice API    ${input_ma_hang}
    ${get_first_ma_hd_tab_lichsu_gh}    ${get_ma_DTGH}    ${get_id_DTGH}    Get info ĐTGH frm APi    ${update_nguoigiao}
    ${get_tong_hd_bf_execute}    ${get_no_hientai_bf_execute}    ${get_tong_phi_gh_bf_execute}    Get cong no DTGH frm API    ${get_ma_DTGH}
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    ${get_loai_tab_congno_bf_execute}    ${get_giatri_tab_congno_bf_execute}    ${get_nohientai_tab_congno_bf_execute}    Get info tab phi can tra DTGH frm API    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    #compute
    ${result_tong_hd_DTGH}    Sum    ${get_tong_hd_bf_execute}    1
    ${resul_tong_phi_gh_DTGH}    Sum    ${get_tong_phi_gh_bf_execute}    ${update_phi_gh}
    ${resul_no_cantra_hientai_DTGH}    Sum    ${get_no_hientai_bf_execute}    ${get_ma_kh_in_hd_bf_execute}
    ${result_no_hientai_in_tab_congno_DTGH}    Sum    ${get_nohientai_tab_congno_bf_execute}    ${update_phi_gh}
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
    ${get_first_ma_hd_in_hd_af_execute}    ${get_phi_gh_in_hd_af_execute}    ${get_ma_kh_in_hd_af_execute}    ${get_kh_tt_in_hd_af_execute}    Get phi GH khach thanh toan ma KH frm Invoice API    ${input_ma_hang}
    ${get_no_hientai_kh_af_execute}    ${get_tongban_kh_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${get_ma_kh_in_hd_af_execute}
    ${get_first_ma_hd_af_execute}    ${get_khachcantra_af_execute}    ${get_trangthai_hd_number_af_execute}    Get info invoice to validate DTGH    ${input_ma_hang}
    ${get_tennguoinhan_af_execute}    ${get_dienthoai_af_execute}    ${get_dia_chi_af_execute}    ${get_khuvuc_af_execute}    ${get_phuongxa_af_execute}    ${get_nguoi_gh_af_execute}    ${get_ten_DTGH_in_hd}
    ...    ${get_mavandon_af_execute}    ${get_trongluong_af_execute}    ${get_phi_gh_af_execute}    ${get_thoigian_gh_af_execute}    ${get_trangthai_gh_af_execute}    Get delivery info frm invoice API
    ...    ${input_ma_hang}
    ${get_tong_hd_af_execute}    ${get_no_hientai_af_execute}    ${get_tong_phi_gh_af_execute}    Get cong no DTGH frm API    ${get_nguoi_gh_af_execute}
    ${get_no_hientai_kh_af_execute}    ${get_tongban_kh_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${get_ma_kh_in_hd_bf_execute}
    #assert value invoice
    Should Be Equal As Strings    ${get_tennguoinhan_af_execute}    ${update_nguoinhan}
    Should Be Equal As Numbers    ${get_dienthoai_af_execute}    ${update_sdt}
    Should Be Equal As Strings    ${get_dia_chi_af_execute}    ${update_diachi}
    Should Be Equal As Strings    ${get_khuvuc_af_execute}    ${update_khuvuc}
    Should Be Equal As Strings    ${get_phuongxa_af_execute}    ${update_phuongxa}
    Should Be Equal As Strings    ${get_ten_DTGH_in_hd}    ${update_nguoigiao}
    Should Be Equal As Numbers    ${get_mavandon_af_execute}    0
    Should Be Equal As Numbers    ${get_trongluong_af_execute}    ${update_trongluong}
    Should Be Equal As Numbers    ${get_phi_gh_af_execute}    ${update_phi_gh}
    ${result_thoigian_gh}    Convert Date time    ${get_thoigian_gh_af_execute}
    Should Be Equal As Strings    ${result_thoigian_gh}    ${update_thoigian_gh}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '1' or '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '6'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    3
    Run Keyword If    '${get_trangthaigh_af_execute}' == '3'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    1
    Run Keyword If    '${get_trangthaigh_af_execute}' == '5'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    5
    #assert ĐTGH
    Run Keyword If    '${update_phi_gh}' == '0'    Validate partnerdelivery if TTGH is Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${get_first_ma_hd_af_execute}    ${update_phi_gh}    ${input_ma_hang}
    Run Keyword If    '${get_trangthai_gh_af_execute}' == '1' or '${get_trangthai_gh_af_execute}' == '6'    Validate partnerdelivery if TTGH is Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${input_ma_hang}
    ...    ELSE    Validate partnerdelivery if TTGH is not Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${result_no_hientai_in_tab_congno_DTGH}    ${input_ma_hang}
    #assert value partner
    Should Be Equal As Numbers    ${get_tong_hd_af_execute}    ${result_tong_hd_DTGH}
    Run Keyword If    '${get_phi_gh_in_hd_bf_execute}' == '${update_phi_gh}'    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${get_tong_phi_gh_bf_execute}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${resul_tong_phi_gh_DTGH}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang bang 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang khac 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}    ${update_phi_gh}

ctgh_update2
    [Arguments]    ${input_ma_hang}    ${update_nguoinhan}    ${update_sdt}    ${update_diachi}    ${update_khuvuc}    ${update_phuongxa}
    ...    ${update_nguoigiao}    ${update_phi_gh}    ${update_trongluong}    ${update_thoigian_gh}    ${update_trangthai_gh}
    #get info invoice
    ${get_first_ma_hd_in_hd_bf_execute}    ${get_khachcantra_in_hd_bf_execute}    ${get_trangthai_hd_number_in_hd_bf_execute}    Get info invoice to validate DTGH    ${input_ma_hang}
    ${get_first_ma_hd_in_hd_bf_execute}    ${get_phi_gh_in_hd_bf_execute}    ${get_ma_kh_in_hd_bf_execute}    ${get_kh_tt_in_hd_bf_execute}    Get phi GH khach thanh toan ma KH frm Invoice API    ${input_ma_hang}
    ${get_first_ma_hd_tab_lichsu_gh}    ${get_ma_DTGH}    ${get_id_DTGH}    Get info ĐTGH frm APi    ${update_nguoigiao}
    ${get_tong_hd_bf_execute}    ${get_no_hientai_bf_execute}    ${get_tong_phi_gh_bf_execute}    Get cong no DTGH frm API    ${get_ma_DTGH}
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    ${get_loai_tab_congno_bf_execute}    ${get_giatri_tab_congno_bf_execute}    ${get_nohientai_tab_congno_bf_execute}    Get info tab phi can tra DTGH frm API    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    #compute
    ${result_tong_hd_DTGH}    Sum    ${get_tong_hd_bf_execute}    1
    ${resul_tong_phi_gh_DTGH}    Sum    ${get_tong_phi_gh_bf_execute}    ${update_phi_gh}
    ${resul_no_cantra_hientai_DTGH}    Sum    ${get_no_hientai_bf_execute}    ${get_ma_kh_in_hd_bf_execute}
    ${result_no_hientai_in_tab_congno_DTGH}    Sum    ${get_nohientai_tab_congno_bf_execute}    ${update_phi_gh}
    #input data into invoice delivery
    Before Test Quan ly
    Go to Hoa don
    Select delivery status in filter
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
    ${get_ma_hd_in_hd_af_execute}    ${get_phi_gh_in_hd_af_execute}    ${get_ma_kh_in_hd_af_execute}    ${get_kh_tt_in_hd_af_execute}    Get phi GH khach thanh toan ma KH frm Invoice API    ${input_ma_hang}
    ${get_no_hientai_kh_af_execute}    ${get_tongban_kh_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${get_ma_kh_in_hd_af_execute}
    ${get_first_ma_hd_af_execute}    ${get_khachcantra_af_execute}    ${get_trangthai_hd_number_af_execute}    Get info invoice to validate DTGH    ${input_ma_hang}
    ${get_tennguoinhan_af_execute}    ${get_dienthoai_af_execute}    ${get_dia_chi_af_execute}    ${get_khuvuc_af_execute}    ${get_phuongxa_af_execute}    ${get_nguoi_gh_af_execute}    ${get_ten_DTGH_in_hd}
    ...    ${get_mavandon_af_execute}    ${get_trongluong_af_execute}    ${get_phi_gh_af_execute}    ${get_thoigian_gh_af_execute}    ${get_trangthai_gh_af_execute}    Get delivery info frm invoice API
    ...    ${input_ma_hang}
    ${get_tong_hd_af_execute}    ${get_no_hientai_af_execute}    ${get_tong_phi_gh_af_execute}    Get cong no DTGH frm API    ${get_nguoi_gh_af_execute}
    ${get_no_hientai_kh_af_execute}    ${get_tongban_kh_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${get_ma_kh_in_hd_bf_execute}
    #assert value invoice
    Should Be Equal As Strings    ${get_tennguoinhan_af_execute}    ${update_nguoinhan}
    Should Be Equal As Numbers    ${get_dienthoai_af_execute}    ${update_sdt}
    Should Be Equal As Strings    ${get_dia_chi_af_execute}    ${update_diachi}
    Should Be Equal As Strings    ${get_khuvuc_af_execute}    ${update_khuvuc}
    Should Be Equal As Strings    ${get_phuongxa_af_execute}    ${update_phuongxa}
    Should Be Equal As Strings    ${get_ten_DTGH_in_hd}    ${update_nguoigiao}
    Should Be Equal As Numbers    ${get_mavandon_af_execute}    0
    Should Be Equal As Numbers    ${get_trongluong_af_execute}    ${update_trongluong}
    Should Be Equal As Numbers    ${get_phi_gh_af_execute}    ${update_phi_gh}
    ${result_thoigian_gh}    Convert Date time    ${get_thoigian_gh_af_execute}
    Should Be Equal As Strings    ${result_thoigian_gh}    ${update_thoigian_gh}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '1' or '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '6'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    3
    Run Keyword If    '${get_trangthaigh_af_execute}' == '3'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    1
    Run Keyword If    '${get_trangthaigh_af_execute}' == '5'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    5
    #validate delivery section
    Element Should Be Enabled    ${khuvuc_giaohang}
    #assert ĐTGH
    Run Keyword If    '${update_phi_gh}' == '0'    Validate partnerdelivery if TTGH is Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${input_ma_hang}
    Run Keyword If    '${get_trangthai_gh_af_execute}' == '1' or '${get_trangthai_gh_af_execute}' == '6'    Validate partnerdelivery if TTGH is Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${input_ma_hang}
    ...    ELSE    Validate partnerdelivery if TTGH is not Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${result_no_hientai_in_tab_congno_DTGH}    ${input_ma_hang}
    #assert value partner
    Should Be Equal As Numbers    ${get_tong_hd_af_execute}    ${result_tong_hd_DTGH}
    Run Keyword If    '${get_phi_gh_in_hd_bf_execute}' == '${update_phi_gh}'    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${get_tong_phi_gh_bf_execute}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${resul_tong_phi_gh_DTGH}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang bang 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang khac 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}    ${update_phi_gh}
