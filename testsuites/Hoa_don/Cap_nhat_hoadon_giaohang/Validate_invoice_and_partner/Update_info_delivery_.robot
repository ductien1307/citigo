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

*** Test Cases ***    Người giao              Phí GH                          Trọng lượng    Thời gian giao hàng    Trạng thái GH       Mã SP
TTGH is 1_2_4_6       [Tags]                  CBG
                      [Setup]                 Create invoice with delivery    CTKH015        TL004                  3                   1        DT00017    35000    2019-10-28T04:40:43    155000
                      [Template]              ctgh_update5
                      Shipper                 10000                           0.5            25/01/2019 10:00       Đang giao hàng      TL004
                      Giao hàng tiết kiệm    15000                           1              25/01/2019 10:00       Chưa giao hàng      TL004
                      Giao hàng nhanh        20000                           1.5            25/01/2019 10:00       Đang chuyển hoàn    TL004
                      Viettel pos            25000                           2              25/01/2019 10:00       Đã hủy              TL004

TTGH is giao thanh cong
                      [Tags]                  CBG
                      [Setup]                 Create invoice with delivery    CTKH016        TL005                  4                   1        DT00018    35000    2019-10-28T04:40:43    200000
                      [Template]              ctgh_update6
                      Giao hàng tiết kiệm     10000                           0.5            25/01/2019 10:00       Giao thành công     TL005

TTGH is da chuyen hoan
                      [Tags]                  CBG
                      [Setup]                 Create invoice with delivery    CTKH017        TL006                  1                   2        DT00019    35000    2019-10-28T04:40:43    30000
                      [Template]              ctgh_update6
                      Giao hàng nhanh         15000                           1.5            25/01/2019 10:00       Đã chuyển hoàn      TL006

*** Keywords ***
ctgh_update5
    [Arguments]    ${update_nguoigiao}    ${update_phi_gh}    ${update_trongluong}    ${update_thoigian_gh}    ${update_trangthai_gh}    ${input_ma_sp}
    #get info invoice
    ${get_first_ma_hd_in_invoice_bf_execute}    ${get_khachcantra_in_invoice_bf_execute}    ${get_trangthai_hd_number_in_invoice_bf_execute}    Get info invoice to validate DTGH    ${input_ma_sp}
    ${get_tennguoinhan_bf_execute}    ${get_dienthoai_bf_execute}    ${get_dia_chi_bf_execute}    ${get_khuvuc_bf_execute}    ${get_phuongxa_bf_execute}    ${get_nguoi_gh_bf_execute}    ${get_ten_DTGH_bf_execute}
    ...    ${get_mavandon_bf_execute}    ${get_trongluong_bf_execute}    ${get_phigh_bf_execute}    ${get_thoigiangh_bf_execute}    ${get_trangthaigh_bf_execute}    Get delivery info frm invoice API
    ...    ${input_ma_sp}
    ${get_first_ma_hd_tab_lichsu_gh}    ${get_ma_DTGH}    ${get_id_DTGH}    Get info ĐTGH frm APi    ${update_nguoigiao}
    ${get_tong_hd_bf_execute}    ${get_no_hientai_bf_execute}    ${get_tong_phi_gh_bf_execute}    Get cong no DTGH frm API    ${get_ma_DTGH}
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    ${get_loai_tab_congno_bf_execute}    ${get_giatri_tab_congno_bf_execute}    ${get_nohientai_tab_congno_bf_execute}    Get info tab phi can tra DTGH frm API    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    #compute
    ${result_tong_hd}    Sum    ${get_tong_hd_bf_execute}    1
    ${result_tong_phi_gh_hientai}    Sum    ${get_tong_phi_gh_bf_execute}    ${update_phi_gh}
    ${resul_no_cantra_hientai}    Sum    ${get_no_hientai_bf_execute}    ${get_phigh_bf_execute}
    ${result_no_hientai_in_tab_congno}    Sum    ${get_nohientai_tab_congno_bf_execute}    ${update_phi_gh}
    #input data into invoice delivery
    Before Test Quan ly
    Go to Hoa don
    Select to hoa don    ${get_first_ma_hd_in_invoice_bf_execute}
    Update nguoi giao frm invoice delivery    ${update_nguoigiao}
    Update invoice delivery with textbox field    Trọng lượng    ${update_trongluong}
    Update invoice delivery with textbox field    Phí giao hàng    ${update_phi_gh}
    Update time giao hang frm invoice delivery    ${update_thoigian_gh}
    Update trang thai giao hang frm invoice delivery    ${update_trangthai_gh}
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
    Should Be Equal As Strings    ${get_ten_DTGH_af_execute}    ${update_nguoigiao}
    Should Be Equal As Numbers    ${get_mavandon_af_execute}    0
    Should Be Equal As Numbers    ${get_trongluong_af_execute}    ${update_trongluong}
    Should Be Equal As Numbers    ${get_phi_gh_af_execute}    ${update_phi_gh}
    ${result_thoigian_gh}    Convert Date time    ${get_thoigian_gh_af_execute}
    Should Be Equal As Strings    ${result_thoigian_gh}    ${update_thoigian_gh}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '1' or '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '6'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    3
    Run Keyword If    '${get_trangthaigh_af_execute}' == '3'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    1
    Run Keyword If    '${get_trangthaigh_af_execute}' == '5'    Should Be Equal As Numbers    ${get_trangthai_hd_number_af_execute}    5
    #assert ĐTGH
    Run Keyword If    '${update_phi_gh}' == '0'    Validate partnerdelivery if TTGH is Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${input_ma_sp}
    Run Keyword If    '${get_trangthai_gh_af_execute}' == '1' or '${get_trangthai_gh_af_execute}' == '6'    Validate partnerdelivery if TTGH is not Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${input_ma_sp}
    ...    ELSE    Validate partnerdelivery if TTGH is not Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${result_no_hientai_in_tab_congno}    ${input_ma_sp}
    #assert value partner
    Should Be Equal As Numbers    ${get_tong_hd_bf_execute}    ${get_tong_hd_bf_execute}
    Run Keyword If    '${get_phigh_bf_execute}' == '${update_phi_gh}'    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${get_tong_phi_gh_bf_execute}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${result_tong_phi_gh_hientai}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang bang 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang khac 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}    ${update_phi_gh}

ctgh_update6
    [Arguments]    ${update_nguoigiao}    ${update_phi_gh}    ${update_trongluong}    ${update_thoigian_gh}    ${update_trangthai_gh}    ${input_ma_sp}
    #get info invoice
    ${get_first_ma_hd_in_invoice_bf_execute}    ${get_khachcantra_in_invoice_bf_execute}    ${get_trangthai_hd_number_in_invoice_bf_execute}    Get info invoice to validate DTGH    ${input_ma_sp}
    ${get_tennguoinhan_bf_execute}    ${get_dienthoai_bf_execute}    ${get_dia_chi_bf_execute}    ${get_khuvuc_bf_execute}    ${get_phuongxa_bf_execute}    ${get_nguoi_gh_bf_execute}    ${get_ten_DTGH_bf_execute}
    ...    ${get_mavandon_bf_execute}    ${get_trongluong_bf_execute}    ${get_phigh_bf_execute}    ${get_thoigiangh_bf_execute}    ${get_trangthaigh_bf_execute}    Get delivery info frm invoice API
    ...    ${input_ma_sp}
    ${get_first_ma_hd_tab_lichsu_gh}    ${get_ma_DTGH}    ${get_id_DTGH}    Get info ĐTGH frm APi    ${update_nguoigiao}
    ${get_tong_hd_bf_execute}    ${get_no_hientai_bf_execute}    ${get_tong_phi_gh_bf_execute}    Get cong no DTGH frm API    ${get_ma_DTGH}
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    ${get_loai_tab_congno_bf_execute}    ${get_giatri_tab_congno_bf_execute}    ${get_nohientai_tab_congno_bf_execute}    Get info tab phi can tra DTGH frm API    ${get_ma_DTGH}    ${get_first_ma_hd_tab_lichsu_gh}
    #compute
    ${result_tong_hd}    Sum    ${get_tong_hd_bf_execute}    1
    ${result_tong_phi_gh_hientai}    Sum    ${get_tong_phi_gh_bf_execute}    ${update_phi_gh}
    ${result_no_hientai_in_tab_congno}    Sum    ${get_nohientai_tab_congno_bf_execute}    ${update_phi_gh}
    #input data into invoice delivery
    Before Test Quan ly
    Go to Hoa don
    Select delivery status in filter
    Select to hoa don    ${get_first_ma_hd_in_invoice_bf_execute}
    Update nguoi giao frm invoice delivery    ${update_nguoigiao}
    Update invoice delivery with textbox field    Trọng lượng    ${update_trongluong}
    Update invoice delivery with textbox field    Phí giao hàng    ${update_phi_gh}
    Update time giao hang frm invoice delivery    ${update_thoigian_gh}
    Update trang thai giao hang frm invoice delivery    ${update_trangthai_gh}
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
    Should Be Equal As Strings    ${get_ten_DTGH_af_execute}    ${update_nguoigiao}
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
    Run Keyword If    '${update_phi_gh}' == '0'    Validate partnerdelivery if TTGH is Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${get_first_ma_hd_af_execute}    ${update_phi_gh}    ${input_ma_sp}
    Run Keyword If    '${get_trangthai_gh_af_execute}' == '1' or '${get_trangthai_gh_af_execute}' == '6'    Validate partnerdelivery if TTGH is not Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${input_ma_sp}
    ...    ELSE    Validate partnerdelivery if TTGH is not Chua giao hang or Da huy    ${get_nguoi_gh_af_execute}    ${update_phi_gh}    ${result_no_hientai_in_tab_congno}    ${input_ma_sp}
    #assert value partner
    Should Be Equal As Numbers    ${get_tong_hd_bf_execute}    ${get_tong_hd_bf_execute}
    Run Keyword If    '${get_phigh_bf_execute}' == '${update_phi_gh}'    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${get_tong_phi_gh_bf_execute}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_phi_gh_af_execute}    ${result_tong_phi_gh_hientai}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang bang 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}
    Run Keyword If    '${get_trangthaigh_af_execute}' == '2' or '${get_trangthaigh_af_execute}' == '3' or '${get_trangthaigh_af_execute}' == '4' or '${get_trangthaigh_af_execute}' == '5'    Validate no can tra hien tai if phi giao hang khac 0    ${get_no_hientai_bf_execute}    ${get_no_hientai_af_execute}    ${update_phi_gh}
