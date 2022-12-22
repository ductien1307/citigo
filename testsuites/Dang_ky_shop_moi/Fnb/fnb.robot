*** Settings ***
Test Setup        Before Test Dang Ky Shop Moi    ${remote}
Test Teardown     After Test
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Dang_ky_moi/dangkymoi_action.robot
Resource          ../../../config/envi.robot
Resource          ../../../core/Fnb/fnb_action.robot
Resource          ../../../core/share/computation.robot

*** Variables ***
&{invoice_1}     SP000025=5


*** Test Cases ***    Ngành hàng    Tên dky   Sdt     Tên dn    Mật khẩu    Phường xã      Địa chỉ       SP-SL           Giá mới          GGHD        Ten kh        Khách tt
Tao moi shop
    [Tags]
    [Template]    eds
    Bar - Cafe & Nhà hàng    An        0123456789      admin       123     Quận Ba Đình      Hà Nội     ${invoice_1}       ${newprice_1}    10000         Thu          50000

Tao moi shop
    [Tags]     ANF       AN
    [Template]    eds1
    Bar - Cafe & Nhà hàng    An        0123456789      admin       123     Quận Ba Đình      Hà Nội     ${invoice_1}       KH000001        25000

*** Keyword ***
eds
    [Arguments]   ${input_nganh_hang}   ${input_ho_ten}   ${input_sdt}      ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}   ${input_diachi}      ${dict_product_num}    ${dict_newprice}    ${input_invoice_discount}      ${input_bh_ten_kh}    ${input_bh_khachtt}
    ${get_ten_cuahang}    Generate Random String    10    [NUMBERS][LOWER]
    Wait Until Keyword Succeeds    3 times    3s    Select nganh hang    ${input_nganh_hang}
    Input informations in popup Tao tai khoan KiotViet    ${input_ho_ten}    ${input_sdt}    ${get_ten_cuahang}    ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}
    ...    ${input_diachi}
    ${xp_ten_gh}    Format String    ${cell_diachi_fnb}    ${get_ten_cuahang}
    Wait Until Page Contains Element    ${xp_ten_gh}    3 mins
    Wait Until Page Contains Element    ${button_bat_dau_kd}    3 mins
    Click element       ${button_bat_dau_kd}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login Fnb       ${get_ten_cuahang}      ${input_ten_dangnhap}    ${input_matkhau}
    Sleep    3s
    ${count}    Get Matching Xpath Count      //i[@class='far fa-times']
    Run Keyword If    ${count}>0           Click Element JS     //i[@class='far fa-times']       ELSE       Log      ignore
    Wait Until Page Contains Element    //div[input[@ng-model="useSampleData"]]//a    1 min
    Click element    //div[input[@ng-model="useSampleData"]]//a
    Wait Until Page Contains Element    ${button_hoanthanh_taodulieumau}    1 min
    Click element    ${button_hoanthanh_taodulieumau}
    Create data message success validation
    #
    ${URL}     Set Variable    https://fnb.kiotviet.vn
    ${API_URL}   Set Variable    https://fnb.kiotviet.vn/api
    ${bearertoken}    ${resp.cookies}     ${branchid}       Get BearerToken by URL and account from API     ${get_ten_cuahang}    ${URL}     ${input_ten_dangnhap}    ${input_matkhau}
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
    Sleep    10s
    Wait Until Page Contains Element    ${button_thu_ngan}     1 min
    Wait Until Keyword Succeeds    3 times    3s       Click Element    ${button_thu_ngan}
    Access page    //input[@placeholder='Tìm sản phẩm (F3)']    text
    Wait Until Keyword Succeeds    3 times    30 s    Deactivate print preview page
      ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${input_bh_ma_kh}     Generate code automatically    KH
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    # Input data into BH form
    ${list_result_thanhtien}    ${list_result_ton_af_ex}    Get list of total sale - result onhand in case of price change    ${list_product}    ${list_nums}    ${list_newprice}
    ${get_list_product_name}      Get list product name thr API    ${list_product}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_newprice}     ${item_pr_name}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${list_newprice}     ${get_list_product_name}
    \    Input product in form Thu ngan    ${item_pr_name}
    \    Input num in form Thu ngan    ${item_num}
    \    Input newprcie in form Thu ngan    ${item_newprice}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Add new customer in form Thu Ngan    ${input_bh_ma_kh}    ${input_bh_ten_kh}
    Sleep    3s
    Click element JS      ${button_tn_thanh_toan_F9}
    Sleep    3s
    ${result_khachcantra}     Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Input discount VND in form Thu ngan        ${input_invoice_discount}
    Input data    ${textbox_tn_khach_tt}    ${actual_khachtt}
    Click Element JS    ${button_tn_thanh_toan}
    Invoice fnb message success validation
    #get values
    Sleep    20s    wait for response to API
    ${invoice_code}     ${get_total}      Get invoice code and total payment frm API    ${input_bh_ma_kh}
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    Get invoice info by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
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
    Log        assert values in Khach hang and So quy
    #
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase   ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    #assert value in tab cong no khach hang
    Get audit trail no payment info and validate    ${invoice_code}    Hóa đơn        Thêm mới
    Delete invoice by invoice code    ${invoice_code}

eds1
    [Arguments]   ${input_nganh_hang}   ${input_ho_ten}   ${input_sdt}      ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}   ${input_diachi}      ${dict_product_num}       ${input_bh_ma_kh}    ${input_bh_khachtt}
    ${get_ten_cuahang}    Generate Random String    10    [NUMBERS][LOWER]
    ${get_ten_cuahang}    Set Variable    test${get_ten_cuahang}
    Wait Until Keyword Succeeds    3 times    3s    Select nganh hang    ${input_nganh_hang}
    Input informations in popup Tao tai khoan KiotViet    ${input_ho_ten}    ${input_sdt}    ${get_ten_cuahang}    ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}
    ...    ${input_diachi}
    ${xp_ten_gh}    Format String    ${cell_diachi_fnb}    ${get_ten_cuahang}
    Wait Until Page Contains Element    ${xp_ten_gh}    3 mins
    Wait Until Page Contains Element    ${button_bat_dau_kd}    3 mins
    Wait Until Keyword Succeeds    3 times    3s      Click element       ${button_bat_dau_kd}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login Fnb       ${get_ten_cuahang}      ${input_ten_dangnhap}    ${input_matkhau}
    Sleep    3s
    ${count}    Get Matching Xpath Count      //i[@class='far fa-times']
    Run Keyword If    ${count}>0           Click Element JS     //i[@class='far fa-times']       ELSE       Log      ignore
    Wait Until Page Contains Element    //div[input[@ng-model="useSampleData"]]//a    1 min
    Click element    //div[input[@ng-model="useSampleData"]]//a
    Wait Until Page Contains Element    ${button_hoanthanh_taodulieumau}    1 min
    Click element    ${button_hoanthanh_taodulieumau}
    Create data message success validation
    #
    ${URL}     Set Variable    https://fnb.kiotviet.vn
    ${API_URL}   Set Variable    https://fnb.kiotviet.vn/api
    ${SALE_API_URL}   Set Variable    https://fnb.kiotviet.vn/api
    ${bearertoken}    ${resp.cookies}     ${branchid}      Get BearerToken by URL and account from API     ${get_ten_cuahang}    ${URL}     ${input_ten_dangnhap}    ${input_matkhau}
    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${URL}    ${URL}
    Set Global Variable    \${SALE_API_URL}    ${SALE_API_URL}
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
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    ${list_newprice}      Get list of Baseprice by Product Code    ${list_product}
    ${list_result_thanhtien}    ${list_result_ton_af_ex}    Get list of total sale - result onhand in case of price change    ${list_product}    ${list_nums}    ${list_newprice}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_tongtienhang}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_tongtienhang}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_tongtienhang}    ${get_tongban_bf_execute}
    #
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${input_ma_hang}    Set Variable    @{list_product}[0]
    ${input_soluong}    Set Variable    @{list_nums}[0]
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
    ${get_id_kh}    Get customer id thr API    ${input_bh_ma_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sp}    Get data from response json       ${get_resp}    ${jsonpath_id_sp}
    ${get_gia_ban}    Get data from response json    ${get_resp}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_soluong}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{5},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{6},"ProductId":{7},"Quantity":{8},"ProductCode":"Combo01","ProductName":"Set nước hoa Vial 01","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":680823,"MasterProductId":15128664,"Unit":"","Uuid":"","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"{10}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":200000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${actual_khachtt}    ${Uuid_code}   ${result_thanhtien}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Post Request    kiotvietapi    /invoices    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${string}    Convert To String    ${resp.json()}
    ${dict}    Set Variable    ${resp.json()}
    ${invoice_code}    Get From Dictionary    ${dict}    Code
    #get values
    Sleep    10s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    Get invoice info by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
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
    Log        assert values in Khach hang and So quy
    #
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase   ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    #assert value in tab cong no khach hang
    Get audit trail no payment info and validate    ${invoice_code}    Hóa đơn        Thêm mới
    Delete invoice by invoice code    ${invoice_code}
