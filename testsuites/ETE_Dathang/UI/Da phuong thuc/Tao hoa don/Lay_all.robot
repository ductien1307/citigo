*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../core/share/javascript.robot
Resource          ../../../../../core/share/list_dictionary.robot
Resource          ../../../../../core/share/discount.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../core/share/imei.robot
Resource          ../../../../../core/share/computation.robot
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/API/api_thietlap.robot

*** Variables ***
&{list_product}    KLCB017=4    KLT0017=8    KLQD017=5.2    KLDV017=3    KLSI0017=2
@{discount}       14    0    5000    25000    320000
@{discount_type}    dis    none    disvnd    changedown    changeup
&{dict_method}    Chuyển khoản=30000    Thẻ=20000    Tiền mặt=10000

*** Test Cases ***    Mã kh         List product&nums    Khtt to create    List GGSP      List discount type    GGDH    Phương thức
Lay all don hang      [Tags]        DHDPT
                      [Template]    edhpt03
                      DHDPT003      ${list_product}      200000            ${discount}    ${discount_type}      10      ${dict_method}

*** Keywords ***
edhpt03
    [Arguments]    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}
    ...    ${dict_phuongthuctt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${list_phuong_thuc}    Get Dictionary Keys    ${dict_phuongthuctt}
    ${list_gia_tri}    Get Dictionary Values    ${dict_phuongthuctt}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tong_dh}    ${list_result_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}    ${list_discount_type}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachcantra}    Set Variable    ${result_khachcantra_in_hd}
    #compute invoice info to Quan ly
    ${result_khtt}    Sum values in list    ${list_gia_tri}
    ${result_khtt_all}    Sum    ${result_khtt}    ${input_khtt_tocreate}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and round 2    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #create invoice frm Order
    Reload Page
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}    ${item_imei}    ${item_status_imei}    ${item_ggsp}    ${result_giamoi}    ${discount_type}
    ...    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${imei_inlist}    ${get_list_status}    ${list_ggsp}    ${list_result_giamoi}
    ...    ${list_discount_type}
    \    Run Keyword If    '${item_status_imei}' != '0'    Input imei incase multi product to any form    ${item_ma_hh}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}
    \    ...    ${cell_imei_multi_product}    @{item_imei}
    \    Run Keyword If    '${discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product
    \    ...    ${item_ma_hh}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input VND discount for multi product    ${item_ma_hh}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input newprice for multi product    ${item_ma_hh}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    0 < ${input_gghd} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount invoice    ${input_gghd}
    ...    ${result_gghd}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount invoice    ${input_gghd}
    Apply multi method    ${dict_phuongthuctt}
    Click Element JS    ${button_dh_pttt_xong}
    Click Element JS    ${button_bh_thanhtoan}
    Sleep    2s
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    #validate so quy
    ${list_phuong_thuc_valdate_dh}    Copy List    ${list_phuong_thuc}
    ${list_gia_tri_validate_dh}    Copy List    ${list_gia_tri}
    ${get_list_ma_phieu_tt}    ${get_list_phuongthuc_tt}    ${get_list_tienthu_tt}    Get receipt number - method - amount in tab Lich su thanh toan hoa don thr API    ${invoice_code}
    : FOR    ${item_phuong_thuc}    ${item_gia_tri}    ${item_ma_phieu}    ${item_result_tienthu}    ${item_result_phuongthuc}    IN ZIP
    ...    ${list_phuong_thuc}    ${list_gia_tri}    ${get_list_ma_phieu_tt}    ${get_list_tienthu_tt}    ${get_list_phuongthuc_tt}
    \    ${item_phuong_thuc}    Run Keyword If    '${item_phuong_thuc}'=='Thẻ'    Set Variable    Card
    \    ...    ELSE IF    '${item_phuong_thuc}'=='Chuyển khoản'    Set Variable    Transfer
    \    ...    ELSE    Set Variable    Cash
    \    Should Be Equal As Strings    ${item_phuong_thuc}    ${item_result_phuongthuc}
    \    Should Be Equal As Numbers    ${item_gia_tri}    ${item_result_tienthu}
    \    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_ma_kh}    ${item_ma_phieu}    ${invoice_code}
    \    Validate So quy info from Rest API if Invoice is paid until success    ${item_ma_phieu}    ${item_gia_tri}
    #validate tab LSTT dat hang
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Append To List    ${list_phuong_thuc_valdate_dh}    ${get_ma_phieutt_in_dh}
    Append To List    ${list_gia_tri_validate_dh}    ${input_khtt_tocreate}
    ${get_list_ma_phieu_tt_validate_dh}    ${get_list_phuongthuc_tt_validate_dh}    ${get_list_tienthu_tt_validate_dh}    Get receipt number - method - amount in tab Lich su thanh toan dat hang thr API    ${order_code}
    : FOR    ${item_phuong_thuc}    ${item_gia_tri}    ${item_ma_phieu}    ${item_result_tienthu}    ${item_result_phuongthuc}    IN ZIP
    ...    ${list_phuong_thuc_valdate_dh}    ${list_gia_tri_validate_dh}    ${get_list_ma_phieu_tt_validate_dh}    ${get_list_tienthu_tt_validate_dh}    ${get_list_phuongthuc_tt_validate_dh}
    \    ${item_phuong_thuc}    Run Keyword If    '${item_phuong_thuc}'=='Thẻ'    Set Variable    Card
    \    ...    ELSE IF    '${item_phuong_thuc}'=='Chuyển khoản'    Set Variable    Transfer
    \    ...    ELSE    Set Variable    Cash
    \    Should Be Equal As Strings    ${item_phuong_thuc}    ${item_result_phuongthuc}
    \    Should Be Equal As Numbers    ${item_gia_tri}    ${item_result_tienthu}
    \    Validate So quy info if Order is paid    ${item_ma_phieu}    ${item_gia_tri}
    #
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khtt_all}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khtt_all}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
