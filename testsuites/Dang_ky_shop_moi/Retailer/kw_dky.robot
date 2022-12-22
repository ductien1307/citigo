*** Settings ***
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Dang_ky_moi/dangkymoi_action.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../prepare/Hang_hoa/Sources/doitac.robot

*** Keyword ***
eds
    [Arguments]    ${input_nganh_hang}    ${input_ho_ten}    ${input_sdt}    ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}
    ...    ${input_diachi}    ${dict_product_num}    ${list_discount_product}    ${list_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}
    ${get_ten_cuahang}    Generate Random String    8    [NUMBERS][LOWER]
    ${get_ten_cuahang}    Set Variable    test${get_ten_cuahang}
    Wait Until Keyword Succeeds    3 times    3s    Select nganh hang    ${input_nganh_hang}
    Input informations in popup Tao tai khoan KiotViet    ${input_ho_ten}    ${input_sdt}    ${get_ten_cuahang}    ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}
    ...    ${input_diachi}
    ${xp_ten_gh}    Format String    ${cell_diachi_gh}    ${get_ten_cuahang}
    Wait Until Page Contains Element    ${xp_ten_gh}    3 mins
    Wait Until Page Contains Element    ${button_bat_dau_kd}    3 mins
    Wait Until Keyword Succeeds    3 times    10s      Click element    ${button_bat_dau_kd}
    Wait Until Keyword Succeeds    3 times    30s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login    ${input_ten_dangnhap}    ${input_matkhau}
    Wait Until Page Contains Element    ${checkbox_taodulieumau}    1 min
    Click element    ${checkbox_taodulieumau}
    Wait Until Page Contains Element    ${button_hoanthanh_taodulieumau}    1 min
    Click element    ${button_hoanthanh_taodulieumau}
    Create data message success validation
    ${URL}    Format String    https://{0}.kiotviet.vn    ${get_ten_cuahang}
    ${API_URL}    Format String    https://{0}.kiotviet.vn/api    ${get_ten_cuahang}
    ${bearertoken}    ${resp.cookies}   ${branchid}      Get BearerToken by URL and account from API    ${get_ten_cuahang}    ${URL}    ${input_ten_dangnhap}    ${input_matkhau}
    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${URL}    ${URL}
    Set Global Variable    \${bearertoken}    ${bearertoken}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Set Global Variable    \${RETAILER_NAME}    ${get_ten_cuahang}
    Set Global Variable    \${BRANCH_ID}    ${branchid}
    #
    ${get_user_id}    Get User ID by UserName    ${input_ten_dangnhap}
    ${get_retailer_id}    Get RetailerID
    ${result_lastestbranch}    Format String    LatestBranch_{0}_{1}    ${get_retailer_id}    ${get_user_id}
    #
    Set Global Variable    \${LATESTBRANCH}    ${result_lastestbranch}
    Set Global Variable    \${USER_NAME}    ${input_ten_dangnhap}
    Set Global Variable    \${PASSWORD}    ${input_matkhau}
    #
    Add customers    ${input_bh_ma_kh}    AN    0986589758    Hà nội
    Sleep    5s
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    1 min
    Wait Until Keyword Succeeds    3 times    8s    Click Element    ${button_banhang_on_quanly}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Keyword Succeeds    3 times    30 s    Deactivate print preview page
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    # Input data into BH form
    ${list_result_ton_af_ex}    Get list of result onhand incase changing product price    ${list_product}    ${list_nums}
    ${list_result_thanhtien}    ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_product}    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_discount}    ${item_discount_type}    ${item_newprice}    IN ZIP
    ...    ${list_product}    ${list_nums}    ${list_discount_product}    ${list_discount_type}    ${list_result_newprice}
    \    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input new price of product    ${item_discount}
    \    ...    ELSE    Log    ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore invoice discount
    Run Keyword If    '${input_bh_khachtt}' == 'all'    Input Khach Hang    ${input_bh_ma_kh}
    ...    ELSE    Input Invoice info    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Run Keyword If    ${input_invoice_discount} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_invoice_discount} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_nums}
    : FOR    ${item_product}    ${item_num_instockcard}    ${item_onhand}    IN ZIP    ${list_product}    ${list_num_instockcard}
    ...    ${list_result_ton_af_ex}
    \    Assert Onhand after execute    ${item_product}    ${invoice_code}    ${item_onhand}
    \    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_onhand}    ${item_num_instockcard}
    #
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    Log    assert values in Khach hang and So quy
    #
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    #assert value in tab cong no khach hang
    Get audit trail no payment info and validate    ${invoice_code}    Hóa đơn    Thêm mới
    Delete invoice by invoice code    ${invoice_code}
