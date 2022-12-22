*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Library           DateTime
Resource          ../share/computation.robot
Resource          api_access.robot
Resource          api_hoadon_banhang.robot
Resource          api_dathang.robot
Resource          api_trahang.robot
Resource          ../Doi_Tac/khachhang_list_action.robot

*** Variables ***
${endpoint_khachhang}    /customers
${endpoint_khachhang_allInfo}    /customers?format=json&Includes=TotalInvoiced&Includes=Location&Includes=WardName&ForManageScreen=true&ForSummaryRow=true&UsingTotalApi=true&UsingStoreProcedure=false
${endpoint_tab_nocanthu}    /customers/{0}/debt?format=json&GroupCode=true&%24inlinecount=allpages&%24top=5    # 0: khach hang id
${endpoint_tab_lichsu_bantrahang}    /customers/{0}/transactionhistory?format=json&%24inlinecount=allpages&%24top=5    #id khách hàng
${value_tab_nocanthu_hoadon_trangthai}    3
${value_tab_nocanthu_phieuthanhtoan_trangthai}    0
${endpoint_tab_lichsu_dathang}    /orders?format=json&Includes=Seller&Includes=Branch&Includes=Customer&%24inlinecount=allpages&%24top=5&%24filter=(CustomerId+eq+{0}+and+PurchaseDate+eq+%27alltime%27+and+Status+ne+0+and+Status+ne+4)    #id KH
${endpoint_delete_customer}    /customers/deleteCustomerList
${endpoint_xoa_phieu_tab_nocanthu}    /customers/{0}/debtdelete
${endpoint_tao_phieu_dieu_chinh}      /customers/{0}/debt?kvuniqueparam=2020
${endpoint_list_unpaid_invoice}       /customers/{0}/unpaidallocation?%24inlinecount=allpages&%24top=300          #customer id
${endpoint_payment_cus}        /payments
${endpoint_list_groupcustomer}    /customers/group?IsFilter=true&%24inlinecount=allpages
${endpoint_get_orders_by_customer_code}     /Orders?format=json&Includes=Branch&Includes=Customer&Includes=Payments&Includes=Seller&Includes=User&Includes=InvoiceOrderSurcharges&Includes=DeliveryInfoes&Includes=DeliveryPackages&ForSummaryRow=true&ForManageScreen=true&Includes=SaleChannel&Includes=Invoices&Includes=OrderPromotions&Includes=InvoiceWarranties&%24inlinecount=allpages&CustomerKey={0}&ExpectedDeliveryFilterType=alltime&ListStatus=%5B1%2C5%2C2%2C3%5D     #0 la ma khach hang
${endpoint_lichsu_tichdiem}     /customers/{0}/point?format=json&GroupCode=true&%24inlinecount=allpages&%24top=10
${endpoint_search_kh_theo_3_so_cuoi_sdt}    /customers?format=json&Includes=TotalInvoiced&Includes=Location&Includes=WardName&ForManageScreen=true&ForSummaryRow=true&UsingTotalApi=true&UsingStoreProcedure=false&SwitchToOrmLite=true&%24inlinecount=allpages&InvoicedLower=0&GroupId=0&DateFilterType=alltime&NewCustomerDateFilterType=alltime&NewCustomerLastTradingDateFilterType=alltime&CustomerBirthDateFilterType=alltime&FindString={0}&IsActive=true
${endpoint_search_kh_theo_email}    /customers?format=json&Includes=TotalInvoiced&Includes=Location&Includes=WardName&ForManageScreen=true&ForSummaryRow=true&UsingTotalApi=true&UsingStoreProcedure=false&SwitchToOrmLite=true&%24inlinecount=allpages&InvoicedLower=0&GroupId=0&DateFilterType=alltime&NewCustomerDateFilterType=alltime&NewCustomerLastTradingDateFilterType=alltime&CustomerBirthDateFilterType=alltime&IsActive=true&EmailKeyword={0}
${endpoint_filter_dk_them_kh_vao_nhom}        /customers/group/filter?kvuniqueparam=2020
${endpoint_tao_nhom_kh}     /customers/group?kvuniqueparam=2020
${endpoint_dieu_chinh_diem}     /customers/{0}/point?kvuniqueparam=2020

*** Keywords ***
Get Customer Debt from API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_no}    Format String    $..Data[?(@.Code=="{0}")].Debt    ${input_ma_kh}
    ${jsonpath_tongban}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_kh}
    ${jsonpath_tongban_tru_trahang}    Format String    $..Data[?(@.Code=="{0}")].TotalRevenue    ${input_ma_kh}
    ${response_khachhang}    Get Request and return body    ${endpoint_khachhang}
    ${get_no}    Get data from response json    ${response_khachhang}    ${jsonpath_no}
    ${get_tongban}    Get data from response json    ${response_khachhang}    ${jsonpath_tongban}
    ${get_tongban_tru_trahang}    Get data from response json    ${response_khachhang}    ${jsonpath_tongban_tru_trahang}
    Return From Keyword    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}

Get Customer Debt and Customer Id from API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_no}    Format String    $..Data[?(@.Code=="{0}")].Debt    ${input_ma_kh}
    ${jsonpath_tongban}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_kh}
    ${jsonpath_tongban_trutrahang}    Format String    $..Data[?(@.Code=="{0}")].TotalRevenue    ${input_ma_kh}
    ${jsonpath_customerid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_kh}
    ${response_khachhang}    Get Request and return body    ${endpoint_khachhang}
    ${get_no}    Get data from response json    ${response_khachhang}    ${jsonpath_no}
    ${get_tongban}    Get data from response json    ${response_khachhang}    ${jsonpath_tongban}
    ${get_tongban_tru_trahang}    Get data from response json    ${response_khachhang}    ${jsonpath_tongban_trutrahang}
    ${customer_id}    Get data from response json    ${response_khachhang}    ${jsonpath_customerid}
    Return From Keyword    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}    ${customer_id}

Get Du no cuoi KH from API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_no}    Format String    $..Data[?(@.Code=="{0}")].Debt    ${input_ma_kh}
    ${response_khachhang}    Get Request and return body    ${endpoint_khachhang}
    ${get_no}    Get data from response json    ${response_khachhang}    ${jsonpath_no}
    Return From Keyword    ${get_no}

Get Customer Info from API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_no}    Format String    $..Data[?(@.Code=="{0}")].Debt    ${input_ma_kh}
    ${jsonpath_tongban}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_kh}
    ${jsonpath_tongban_trutrahang}    Format String    $..Data[?(@.Code=="{0}")].TotalRevenue    ${input_ma_kh}
    ${jsonpath_customername}    Format String    $..Data[?(@.Code=="{0}")].Name    ${input_ma_kh}
    ${response_khachhang}    Get Request and return body    ${endpoint_khachhang}
    ${get_no}    Get data from response json    ${response_khachhang}    ${jsonpath_no}
    ${get_tongban}    Get data from response json    ${response_khachhang}    ${jsonpath_tongban}
    ${get_tongban_tru_trahang}    Get data from response json    ${response_khachhang}    ${jsonpath_tongban_trutrahang}
    ${get_customer_name}    Get data from response json    ${response_khachhang}    ${jsonpath_customername}
    Return From Keyword    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}    ${get_customer_name}

Get ma phieu if Invoice is paid
    [Arguments]    ${input_bh_ma_kh}    ${ma_phieu_thanhtoan}    ${ma_hoadon}
    [Timeout]    5 mins
    ${jsonpath_khachhang_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_bh_ma_kh}
    ${get_khachhang_id}    Get data from API    ${endpoint_khachhang}    ${jsonpath_khachhang_id}
    ${endpoint_tab_by_kh_id}    Format String    ${endpoint_tab_nocanthu}    ${get_khachhang_id}
    ${jsonpath_trangthai_maphieu_thanhtoan}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${ma_phieu_thanhtoan}
    ${get_trangthai_maphieu_thanhtoan}    Get data from API    ${endpoint_tab_by_kh_id}    ${jsonpath_trangthai_maphieu_thanhtoan}
    ${jsonpath_trangthai_ma_hoadon}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${ma_hoadon}
    ${get_trangthai_ma_hoadon}    Get data from API    ${endpoint_tab_by_kh_id}    ${jsonpath_trangthai_ma_hoadon}
    Return From Keyword    ${get_trangthai_maphieu_thanhtoan}    ${get_trangthai_ma_hoadon}

Validate status in Tab No can thu tu khach if Invoice is not paid
    [Arguments]    ${input_bh_ma_kh}    ${ma_hoadon}
    [Timeout]    5 mins
    ${get_trangthai_ma_hoadon}    Get ma phieu if Invoice is not paid    ${input_bh_ma_kh}    ${ma_hoadon}
    Should Be Equal As Numbers    ${get_trangthai_ma_hoadon}    ${value_tab_nocanthu_hoadon_trangthai}

Get ma phieu if Invoice is not paid
    [Arguments]    ${input_ma_kh}    ${ma_hoadon}
    [Timeout]    5 mins
    ${jsonpath_khachhang_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_kh}
    ${get_khachhang_id}    Get data from API    ${endpoint_khachhang}    ${jsonpath_khachhang_id}
    ${endpoint_tab_by_kh_id}    Format String    ${endpoint_tab_nocanthu}    ${get_khachhang_id}
    ${jsonpath_trangthai_ma_hoadon}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${ma_hoadon}
    ${get_trangthai_ma_hoadon}    Get data from API    ${endpoint_tab_by_kh_id}    ${jsonpath_trangthai_ma_hoadon}
    Return From Keyword    ${get_trangthai_ma_hoadon}

Validate status in Tab No can thu tu khach if Invoice is paid
    [Arguments]    ${input_bh_ma_kh}    ${ma_phieu_thanhtoan}    ${ma_hoadon}
    [Timeout]    5 mins
    ${get_trangthai_maphieu_thanhtoan}    ${get_trangthai_ma_hoadon}    Get ma phieu if Invoice is paid    ${input_bh_ma_kh}    ${ma_phieu_thanhtoan}    ${ma_hoadon}
    Should Be Equal As Numbers    ${get_trangthai_ma_hoadon}    ${value_tab_nocanthu_hoadon_trangthai}
    Should Be Equal As Numbers    ${get_trangthai_maphieu_thanhtoan}    ${value_tab_nocanthu_phieuthanhtoan_trangthai}

Validate status in Tab No can thu tu khach if Base price is is zero
    [Arguments]    ${input_bh_ma_kh}    ${ma_hoadon}
    [Timeout]    5 mins
    ${get_trangthai_ma_hoadon}    Get ma phieu if Invoice is not paid    ${input_bh_ma_kh}    ${ma_hoadon}
    Should Be Equal As Numbers    ${get_trangthai_ma_hoadon}    0

Get info customer frm API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_ten_kh}    Format String    $..Data[?(@.Code=="{0}")].Name    ${input_ma_kh}
    ${jsonpath_dienthoai_kh}    Format String    $..Data[?(@.Code=="{0}")].ContactNumber    ${input_ma_kh}
    ${jsonpath_email_kh}    Format String    $..Data[?(@.Code=="{0}")].Email    ${input_ma_kh}
    ${jsonpath_diachi_kh}    Format String    $..Data[?(@.Code=="{0}")].Address    ${input_ma_kh}
    ${jsonpath_khuvuc_kh}    Format String    $..Data[?(@.Code=="{0}")].LocationName    ${input_ma_kh}
    ${jsonpath_phuongxa_kh}    Format String    $..Data[?(@.Code=="{0}")].WardName    ${input_ma_kh}
    ${response_khachhang}    Get Request and return body    ${endpoint_khachhang}
    ${get_ten_kh}    Get data from response json    ${response_khachhang}    ${jsonpath_ten_kh}
    ${get_dienthoai_kh}    Get data from response json    ${response_khachhang}    ${jsonpath_dienthoai_kh}
    ${get_email_kh}    Get data from response json    ${response_khachhang}    ${jsonpath_email_kh}
    Set Test Variable    \${Email_customer}    ${get_email_kh}
    ${get_diachi_kh}    Get data from response json    ${response_khachhang}    ${jsonpath_diachi_kh}
    ${get_khuvuc_kh}    Get data from response json    ${response_khachhang}    ${jsonpath_khuvuc_kh}
    ${get_phuongxa_kh}    Get data from response json    ${response_khachhang}    ${jsonpath_phuongxa_kh}
    Return From Keyword    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}

Validate info customer on invoice delivery
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${input_ma_kh}
    ${get_tennguoinhan_gh_in_hd}    ${get_dienthoai_gh_in_hd}    ${get_nguoi_gh_in_hd}    ${get_dia_chi_gh_in_hd}    ${get_khuvuc_gh_in_hd}    ${get_phuongxa_gh_in_hd}    ${get_mavandon_gh_in_hd}
    ...    ${get_thoigian_gh_in_hd}    Get infor delivery frm API
    Should Be Equal As Strings    ${get_tennguoinhan_gh_in_hd}    ${get_ten_kh}
    Should Be Equal As Numbers    ${get_dienthoai_gh_in_hd}    ${get_dienthoai_kh}
    Should Be Equal As Strings    ${get_dia_chi_gh_in_hd}    ${get_diachi_kh}
    Should Be Equal As Strings    ${get_khuvuc_gh_in_hd}    ${get_khuvuc_kh}
    Should Be Equal As Strings    ${get_phuongxa_gh_in_hd}    ${get_phuongxa_kh}

Get lich su ban tra hang frm API
    [Arguments]    ${input_ma_kh}    ${input_ma_chungtu}
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${jsonpath_tongcong}    Format String    $..Data[?(@.Code == "{0}")].Total    ${input_ma_chungtu}
    ${jsonpath_trangthai}    Format String    $..Data[?(@.Code == "{0}")].Status    ${input_ma_chungtu}
    ${jsonpath_type}    Format String    $..Data[?(@.Code == "{0}")].DocumentType    ${input_ma_chungtu}
    ${endpoint}    Format String    ${endpoint_tab_lichsu_bantrahang}    ${get_id_khachhang}
    ${get_resp}    Get Request and return body    ${endpoint}
    ${get_tongcong}    Get data from response json    ${get_resp}    ${jsonpath_tongcong}
    ${get_trangthai}    Get data from response json    ${get_resp}    ${jsonpath_trangthai}
    ${get_type}    Get data from response json    ${get_resp}    ${jsonpath_type}
    Return From Keyword    ${get_tongcong}    ${get_trangthai}    ${get_type}

Validate history tab in customer
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}
    [Timeout]    5 mins
    ${get_trangthai_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    Should Be Equal As Numbers    ${get_tongcong}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_hd}
    Should Be Equal As Numbers    ${get_type}    1

Get tab no can thu tu khach if Invoice is paid
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}
    [Documentation]    1. Chọn 1 khách hàng 2. Click tab nợ cần thu từ khách 3. Get nợ cần thu từ khách info
    [Timeout]    5 mins
    #jsonpath hóa đơn
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${input_ma_hd}
    ${jsonpath_du_no_hd}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${input_ma_hd}
    ${jsonpath_type_hd}    Format String    $..Data[?(@.DocumentCode == '{0}')].DocumentType    ${input_ma_hd}
    # jsonpath phiếu thanh toán
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_hd}
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_phieu_tthd}    Format String    ${endpoint_phieu_thanhtoan_hd}    ${get_id_hd}
    ${get_ma_phieu_tt_hd}    Get data from API    ${endpoint_phieu_tthd}    $..Code
    ${jsonpath_giatri_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${get_ma_phieu_tt_hd}
    ${jsonpath_du_no_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${get_ma_phieu_tt_hd}
    ${jsonpath_type_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].DocumentType    ${get_ma_phieu_tt_hd}
    #get value of invoice and payment
    ${endpoint_no_canthu}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    ${get_resp}    Get Request and return body    ${endpoint_no_canthu}
    ${get_giatri_hd}    Get data from response json    ${get_resp}    ${jsonpath_giatri_hd}
    ${get_du_no_hd}    Get data from response json    ${get_resp}    ${jsonpath_du_no_hd}
    ${get_type_hd}    Get data from response json    ${get_resp}    ${jsonpath_type_hd}
    ${get_giatri_phieu_tt_bf}    Get data from response json    ${get_resp}    ${jsonpath_giatri_phieu_tt}
    ${get_giatri_phieu_tt_str}    Convert To String    ${get_giatri_phieu_tt_bf}
    ${get_giatri_phieu_tt_af}    Replace String    ${get_giatri_phieu_tt_str}    -    ${EMPTY}
    ${get_giatri_phieu_tt}    Convert To Number    ${get_giatri_phieu_tt_af}
    ${get_du_no_phieu_tt}    Get data from response json    ${get_resp}    ${jsonpath_du_no_phieu_tt}
    ${get_type_phieu_tt}    Get data from response json    ${get_resp}    ${jsonpath_type_phieu_tt}
    Return From Keyword    ${get_giatri_hd}    ${get_du_no_hd}    ${get_type_hd}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}

Get tab no can thu tu khach if Invoice is not paid
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}
    [Documentation]    1. Chọn 1 khách hàng 2. Click tab nợ cần thu từ khách 3. Get nợ cần thu từ khách info
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${input_ma_hd}
    ${jsonpath_du_no_hd}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${input_ma_hd}
    ${jsonpath_type_hd}    Format String    $..Data[?(@.DocumentCode == '{0}')].DocumentType    ${input_ma_hd}
    ${endpoint_no_canthu}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    ${get_resp}    Get Request and return body    ${endpoint_no_canthu}
    ${get_giatri_hd}    Get data from response json    ${get_resp}    ${jsonpath_giatri_hd}
    ${get_du_no_hd}    Get data from response json    ${get_resp}    ${jsonpath_du_no_hd}
    ${get_type_hd}    Get data from response json    ${get_resp}    ${jsonpath_type_hd}
    Return From Keyword    ${get_giatri_hd}    ${get_du_no_hd}    ${get_type_hd}

Validate history and debt in customer if invoice is paid
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${result_du_no_hd}    ${result_du_no_PTT}
    [Timeout]    5 mins
    ${get_trangthai_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    ${get_giatri_hd}    ${get_du_no_hd}    ${get_type_hd}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}    Get tab no can thu tu khach if Invoice is paid
    ...    ${input_ma_kh}    ${input_ma_hd}
    ${get_ma_phieu_tt}    ${get_phuongthuc_tt}    ${get_trangthai_tt}    ${get_tienthu_tt}    Get ptt invoice info    ${input_ma_hd}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_hd}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_du_no_hd}    ${result_du_no_hd}
    Should Be Equal As Numbers    ${get_type_hd}    3
    Should Be Equal As Numbers    ${get_giatri_phieu_tt}    ${get_tienthu_tt}
    Should Be Equal As Numbers    ${get_du_no_phieu_tt}    ${result_du_no_PTT}
    Should Be Equal As Numbers    ${get_type_phieu_tt}    0
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_hd}
    Should Be Equal As Numbers    ${get_type}    1

Validate history and debt in customer if invoice is not paid
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${result_du_no_hd}
    [Timeout]    5 mins
    ${get_trangthai_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    ${get_giatri_hd}    ${get_du_no_hd}    ${get_type_hd}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}    Get tab no can thu tu khach if Invoice is paid
    ...    ${input_ma_kh}    ${input_ma_hd}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_hd}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_du_no_hd}    ${result_du_no_hd}
    Should Be Equal As Numbers    ${get_type_hd}    3
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_hd}
    Should Be Equal As Numbers    ${get_type}    1

Validate history and debt in customer if invoice's update is paid
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${get_giatri_hd_bf_execute}    ${get_du_no_hd_bf_execute}    ${get_type_hd_bf_execute}    ${get_giatri_phieu_tt_bf_execute}
    ...    ${get_du_no_phieu_tt_bf_execute}    ${get_type_phieu_tt_bf_execute}    ${get_tongcong_bf_execute}    ${get_trangthai_bf_execute}    ${get_type_bf_execute}
    [Timeout]    5 mins
    ${get_giatri_hd_af_execute}    ${get_du_no_hd_af_execute}    ${get_type_hd_af_execute}    ${get_giatri_phieu_tt_af_execute}    ${get_du_no_phieu_tt_af_execute}    ${get_type_phieu_tt_af_execute}    Get tab no can thu tu khach if Invoice is paid
    ...    ${input_ma_kh}    ${input_ma_hd}
    ${get_tongcong_af_execute}    ${get_trangthai_af_execute}    ${get_type_af_execute}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_hd_af_execute}    ${get_giatri_hd_bf_execute}
    Should Be Equal As Numbers    ${get_du_no_hd_af_execute}    ${get_du_no_hd_bf_execute}
    Should Be Equal As Numbers    ${get_type_hd_af_execute}    ${get_type_hd_bf_execute}
    Should Be Equal As Numbers    ${get_giatri_phieu_tt_af_execute}    ${get_giatri_phieu_tt_bf_execute}
    Should Be Equal As Numbers    ${get_du_no_phieu_tt_af_execute}    ${get_du_no_phieu_tt_bf_execute}
    Should Be Equal As Numbers    ${get_type_phieu_tt_af_execute}    ${get_type_phieu_tt_bf_execute}
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong_af_execute}    ${get_tongcong_bf_execute}
    Should Be Equal As Numbers    ${get_trangthai_af_execute}    ${get_trangthai_bf_execute}
    Should Be Equal As Numbers    ${get_type_af_execute}    ${get_type_bf_execute}

Validate history and debt in customer if invoice's update is not paid
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${get_giatri_hd_bf_execute}    ${get_du_no_hd_bf_execute}    ${get_tongcong_bf_execute}    ${get_trangthai_bf_execute}
    [Timeout]    5 mins
    ${get_giatri_hd_af_execute}    ${get_du_no_hd_af_execute}    ${get_type_hd_af_execute}    Get tab no can thu tu khach if Invoice is not paid    ${input_ma_kh}    ${input_ma_hd}
    ${get_tongcong_af_execute}    ${get_trangthai_af_execute}    ${get_type_af_execute}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_hd_af_execute}    ${get_giatri_hd_af_execute}
    Should Be Equal As Numbers    ${get_du_no_hd_af_execute}    ${get_du_no_hd_bf_execute}
    Should Be Equal As Numbers    ${get_type_hd_af_execute}    3
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong_af_execute}    ${get_tongcong_bf_execute}
    Should Be Equal As Numbers    ${get_trangthai_af_execute}    ${get_trangthai_bf_execute}
    Should Be Equal As Numbers    ${get_type_af_execute}    1

Validate history tab in customer with invoice's update
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${get_tongcong_bf_execute}    ${get_trangthai_bf_execute}    ${get_type_bf_execute}
    [Timeout]    5 mins
    ${get_tongcong_af_execute}    ${get_trangthai_af_execute}    ${get_type_af_execute}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    Should Be Equal As Numbers    ${get_tongcong_af_execute}    ${get_tongcong_bf_execute}
    Should Be Equal As Numbers    ${get_trangthai_af_execute}    ${get_trangthai_bf_execute}
    Should Be Equal As Numbers    ${get_type_af_execute}    ${get_type_bf_execute}

Get Customer Debt from API after purchase
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${input_khach_tt}
    [Timeout]    5 mins
    ${get_resp}    Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from response json    ${get_resp}    ${jsonpath_id_kh}
    ${endpoint_history_tab_by_customer}    Format String    ${endpoint_tab_lichsu_bantrahang}    ${get_id_khachhang}
    ${endpoint_debt_tab_by_customer}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    Wait Until Keyword Succeeds    3 times    50 s    Get and validate data from API    ${endpoint_history_tab_by_customer}    ${input_ma_hd}    $..Data[0].Code
    ${jsonpath_tongban}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_kh}
    ${jsonpath_tongban_trutrahang}    Format String    $..Data[?(@.Code=="{0}")].TotalRevenue    ${input_ma_kh}
    ${document_code_if_paid}    Catenate    SEPARATOR=    TT    ${input_ma_hd}
    ${actual_code_thanhtoan}    Set Variable If    '${input_khach_tt}' == '0'    ${input_ma_hd}    ${document_code_if_paid}
    ${jsonpath_no}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${actual_code_thanhtoan}
    ${get_no}    Get data from API    ${endpoint_debt_tab_by_customer}    ${jsonpath_no}
    ${get_tongban}    Get data from response json    ${get_resp}    ${jsonpath_tongban}
    ${get_tongban_tru_trahang}    Get data from response json    ${get_resp}    ${jsonpath_tongban_trutrahang}
    Return From Keyword    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}

Get Customer Debt from API in case apply Voucher after execute
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${input_khach_tt}
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_history_tab_by_customer}    Format String    ${endpoint_tab_lichsu_bantrahang}    ${get_id_khachhang}
    ${endpoint_debt_tab_by_customer}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    Wait Until Keyword Succeeds    3 times    50 s    Get and validate data from API    ${endpoint_history_tab_by_customer}    ${input_ma_hd}    $..Data[0].Code
    ${jsonpath_tongban}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_kh}
    ${jsonpath_tongban_trutrahang}    Format String    $..Data[?(@.Code=="{0}")].TotalRevenue    ${input_ma_kh}
    ${document_code_if_paid}    Catenate    SEPARATOR=    TT    ${input_ma_hd}
    ${jsonpath_no}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${document_code_if_paid}
    ${respcustomer}    Get Request and return body    ${endpoint_khachhang}
    ${get_no}    Get data from API    ${endpoint_debt_tab_by_customer}    ${jsonpath_no}
    ${get_tongban}    Get data from response json    ${respcustomer}    ${jsonpath_tongban}
    ${get_tongban_tru_trahang}    Get data from response json    ${respcustomer}    ${jsonpath_tongban_trutrahang}
    Return From Keyword    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}

Validate history and debt in customer if order is paid
    [Arguments]    ${input_ma_kh}    ${input_ma_dh}    ${input_khtt}    ${result_du_no_kh}
    [Timeout]    5 mins
    ${get_tongcong_in_dh}    ${get_TTDH_in_dh}    Get total payment and status by order code    ${input_ma_dh}
    ${get_tongcong}    ${get_status}    Get lich su dat hang frm order API    ${input_ma_kh}    ${input_ma_dh}
    ${get_giatri_phieu_tt}    ${get_du_no_kh}    ${get_type_phieu_tt}    Get tab no can thu tu khach if order is paid    ${input_ma_dh}    ${input_ma_kh}
    #assert lich su dat hang
    Should Be Equal As Numbers    ${get_tongcong}    ${get_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_status}    ${get_TTDH_in_dh}
    #assert no can thu KH
    Should Be Equal As Numbers    ${get_giatri_phieu_tt}    ${input_khtt}
    Should Be Equal As Numbers    ${get_du_no_kh}    ${result_du_no_kh}
    Should Be Equal As Numbers    ${get_type_phieu_tt}    0

Validate history in customer if order is not paid
    [Arguments]    ${input_ma_kh}    ${input_ma_dh}
    [Timeout]    5 mins
    ${get_tongcong_in_dh}    ${get_TTDH_in_dh}    Get total payment and status by order code    ${input_ma_dh}
    ${get_tongcong}    ${get_status}    Get lich su dat hang frm order API    ${input_ma_kh}    ${input_ma_dh}
    #assert lich su dat hang
    Should Be Equal As Numbers    ${get_tongcong}    ${get_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_status}    ${get_TTDH_in_dh}

Get lich su dat hang frm order API
    [Arguments]    ${input_ma_kh}    ${input_ma_dh}
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${jsonpath_tongcong}    Format String    $..Data[?(@.Code == "{0}")].Total    ${input_ma_dh}
    ${jsonpath_status}    Format String    $..Data[?(@.Code == "{0}")].Status    ${input_ma_dh}
    ${endpoint}    Format String    ${endpoint_tab_lichsu_dathang}    ${get_id_khachhang}
    ${get_resp}    Get Request and return body    ${endpoint}
    ${get_tongcong}    Get data from response json    ${get_resp}    ${jsonpath_tongcong}
    ${get_status}    Get data from response json    ${get_resp}    ${jsonpath_status}
    Return From Keyword    ${get_tongcong}    ${get_status}

Get tab no can thu tu khach if order is paid
    [Arguments]    ${input_ma_dh}    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_phieu_ttdh}    Format String    ${endpoint_order_payment}    ${get_id_dh}
    ${get_ma_phieu_tt_hd}    Get data from API    ${endpoint_phieu_ttdh}    $..Code
    ${jsonpath_giatri_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${get_ma_phieu_tt_hd}
    ${jsonpath_du_no_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${get_ma_phieu_tt_hd}
    ${jsonpath_type_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].DocumentType    ${get_ma_phieu_tt_hd}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_tab_nocanthu}    Format String    ${endpoint_tab_nocanthu}    ${get_id_kh}
    ${get_resp}    Get Request and return body    ${endpoint_tab_nocanthu}
    ${get_giatri_phieu_tt_bf}    Get data from response json    ${get_resp}    ${jsonpath_giatri_phieu_tt}
    ${get_giatri_phieu_tt_str}    Convert To String    ${get_giatri_phieu_tt_bf}
    ${get_giatri_phieu_tt_af}    Replace String    ${get_giatri_phieu_tt_str}    -    ${EMPTY}
    ${get_giatri_phieu_tt}    Convert To Number    ${get_giatri_phieu_tt_af}
    ${get_du_no_phieu_tt}    Get data from response json    ${get_resp}    ${jsonpath_du_no_phieu_tt}
    ${get_type_phieu_tt}    Get data from response json    ${get_resp}    ${jsonpath_type_phieu_tt}
    Return From Keyword    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}

Get Customer Debt from API after purchase with order
    [Arguments]    ${input_ma_kh}    ${input_ma_dh}    ${input_khach_tt}
    [Timeout]    5 mins
    ${get_resp}    Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}''
    ${get_id_khachhang}    Get data from API    ${get_resp}    ${jsonpath_id_kh}
    ${enpoint_lichsu_dathang}    Format String    ${endpoint_tab_lichsu_dathang}    ${get_id_khachhang}
    ${endpoint_debt_tab_by_customer}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    Wait Until Keyword Succeeds    3 times    50 s    Get and validate data from API    ${enpoint_lichsu_dathang}    ${input_ma_dh}    $..Data[0].Code
    ${jsonpath_tongban}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_kh}
    ${jsonpath_tongban_trutrahang}    Format String    $..Data[?(@.Code=="{0}")].TotalRevenue    ${input_ma_kh}
    ${document_code_if_paid}    Catenate    SEPARATOR=    TT    ${input_ma_dh}
    ${actual_code_thanhtoan}    Set Variable If    '${input_khach_tt}' == '0'    ${input_ma_dh}    ${document_code_if_paid}
    ${get_no}    Get data from API    ${endpoint_debt_tab_by_customer}    $..Data[0].Balance
    ${get_tongban}    Get data from response json    ${get_resp}    ${jsonpath_tongban}
    ${get_tongban_tru_trahang}    Get data from response json    ${get_resp}    ${jsonpath_tongban_trutrahang}
    Return From Keyword    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}

Validate customer history and debt if invoice is not paid frm order
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${result_du_no_hd}
    [Timeout]    5 mins
    ${get_trangthai_gh_in_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    ${get_giatri_hd}    ${get_du_no_hd}    ${get_type_hd}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}    Get tab no can thu tu khach if Invoice is paid
    ...    ${input_ma_kh}    ${input_ma_hd}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_hd}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_du_no_hd}    ${result_du_no_hd}
    Should Be Equal As Numbers    ${get_type_hd}    3
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_gh_in_hd}
    Should Be Equal As Numbers    ${get_type}    1

Validate customer history and debt if invoice is paid frm order
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${result_du_no_hd}    ${result_du_no_PTT}
    [Timeout]    5 mins
    ${get_trangthai_gh_in_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    ${get_giatri_hd}    ${get_du_no_hd}    ${get_type_hd}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}    Get tab no can thu tu khach if Invoice is paid
    ...    ${input_ma_kh}    ${input_ma_hd}
    ${get_ma_phieu_tt}    ${get_phuongthuc_tt}    ${get_trangthai_tt}    ${get_tienthu_tt}    Get ptt invoice info    ${input_ma_hd}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_hd}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_du_no_hd}    ${result_du_no_hd}
    Should Be Equal As Numbers    ${get_type_hd}    3
    Should Be Equal As Numbers    ${get_giatri_phieu_tt}    ${get_tienthu_tt}
    Should Be Equal As Numbers    ${get_du_no_phieu_tt}    ${result_du_no_PTT}
    Should Be Equal As Numbers    ${get_type_phieu_tt}    0
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_gh_in_hd}
    Should Be Equal As Numbers    ${get_type}    1

Validate history tab of customer frm Order
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}
    [Timeout]    5 mins
    ${get_trangthai_gh_in_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    Should Be Equal As Numbers    ${get_tongcong}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_gh_in_hd}
    Should Be Equal As Numbers    ${get_type}    1

Validate status in Tab No can thu tu khach if Invoice is not paid until success
    [Arguments]    ${input_bh_ma_kh}    ${ma_hoadon}
    [Timeout]    5 mins
    Wait Until Keyword Succeeds    5 times    30 s    Validate status in Tab No can thu tu khach if Invoice is not paid    ${input_bh_ma_kh}    ${ma_hoadon}

Validate status in Tab No can thu tu khach if Invoice is paid until success
    [Arguments]    ${input_bh_ma_kh}    ${ma_phieu_thanhtoan}    ${ma_hoadon}
    [Timeout]    5 mins
    Wait Until Keyword Succeeds    5 times    30 s    Validate status in Tab No can thu tu khach if Invoice is paid    ${input_bh_ma_kh}    ${ma_phieu_thanhtoan}    ${ma_hoadon}

Computation Cong no khach hang
    [Arguments]    ${input_ma_kh}    ${result_tongtienhang}    ${input_khtt}
    [Timeout]    5 mins
    ${get_no_hientai_kh_bf_execute}    ${get_tongban_kh_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${result_du_no_hd_KH}    Sum    ${get_no_hientai_kh_bf_execute}    ${result_tongtienhang}
    ${result_PTT_hd_KH}    Minus    ${result_du_no_hd_KH}    ${input_khtt}
    ${result_tongban_KH}    Sum    ${result_tongtienhang}    ${get_tongban_kh_bf_execute}
    ${result_tongban_tru_trahang}    Sum    ${get_tongban_tru_trahang_bf_execute}    ${result_tongtienhang}
    Return From Keyword    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}    ${result_tongban_KH}    ${result_tongban_tru_trahang}

Validate customer history and debt if invoice is paid deposit refund frm order
    [Arguments]    ${input_ma_kh}    ${input_ma_hd}    ${result_du_no_hd}    ${result_du_no_PTT}
    [Timeout]    5 mins
    ${get_trangthai_gh_in_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    ${get_giatri_hd}    ${get_du_no_hd}    ${get_type_hd}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}    Get tab no can thu tu khach if Invoice is paid
    ...    ${input_ma_kh}    ${input_ma_hd}
    ${get_ma_phieu_tt}    ${get_phuongthuc_tt}    ${get_trangthai_tt}    ${get_tienthu_tt}    Get PTT to invoice have deposit refund    ${input_ma_hd}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_hd}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_hd}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_du_no_hd}    ${result_du_no_hd}
    Should Be Equal As Numbers    ${get_type_hd}    3
    Should Be Equal As Numbers    ${get_giatri_phieu_tt}    ${get_tienthu_tt}
    Should Be Equal As Numbers    ${get_du_no_phieu_tt}    ${result_du_no_PTT}
    Should Be Equal As Numbers    ${get_type_phieu_tt}    0
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong}    ${get_khach_can_tra}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_gh_in_hd}
    Should Be Equal As Numbers    ${get_type}    1

Get tab no can thu tu khach if Return is paid
    [Arguments]    ${input_ma_kh}    ${input_ma_th}
    [Timeout]    5 mins
    #jsonpath tra hang
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${jsonpath_giatri_th}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${input_ma_th}
    ${jsonpath_du_no_th}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${input_ma_th}
    ${jsonpath_type_th}    Format String    $..Data[?(@.DocumentCode == '{0}')].DocumentType    ${input_ma_th}
    #get ma phieu thanh toan tra hang
    ${jsonpath_ma_phieu_ttth}    Format String    $..Data[?(@.Code== '{0}')].PaymentCode    ${input_ma_th}
    ${endpoint_trahang}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${get_ma_phieu_ttth}    Get data from API    ${endpoint_trahang}    ${jsonpath_ma_phieu_ttth}
    ${jsonpath_giatri_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${get_ma_phieu_ttth}
    ${jsonpath_du_no_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${get_ma_phieu_ttth}
    ${jsonpath_type_phieu_tt}    Format String    $..Data[?(@.DocumentCode == '{0}')].DocumentType    ${get_ma_phieu_ttth}
    #get value of return and payment
    ${endpoint_no_canthu}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    ${get_resp}    Get Request and return body    ${endpoint_no_canthu}
    ${get_giatri_th}    Get data from response json    ${get_resp}    ${jsonpath_giatri_th}
    ${get_du_no_th}    Get data from response json    ${get_resp}    ${jsonpath_du_no_th}
    ${get_type_th}    Get data from response json    ${get_resp}    ${jsonpath_type_th}
    ${get_giatri_phieu_tt}    Get data from response json    ${get_resp}    ${jsonpath_giatri_phieu_tt}
    ${get_du_no_phieu_tt}    Get data from response json    ${get_resp}    ${jsonpath_du_no_phieu_tt}
    ${get_type_phieu_tt}    Get data from response json    ${get_resp}    ${jsonpath_type_phieu_tt}
    Return From Keyword    ${get_giatri_th}    ${get_du_no_th}    ${get_type_th}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}

Get tab no can thu tu khach if Return is not paid
    [Arguments]    ${input_ma_kh}    ${input_ma_th}
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${jsonpath_giatri_th}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${input_ma_th}
    ${jsonpath_du_no_th}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${input_ma_th}
    ${jsonpath_type_th}    Format String    $..Data[?(@.DocumentCode == '{0}')].DocumentType    ${input_ma_th}
    ${endpoint_no_canthu}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    ${get_resp}    Get Request and return body    ${endpoint_no_canthu}
    ${get_giatri_th}    Get data from response json    ${get_resp}    ${jsonpath_giatri_th}
    ${get_du_no_th}    Get data from response json    ${get_resp}    ${jsonpath_du_no_th}
    ${get_type_th}    Get data from response json    ${get_resp}    ${jsonpath_type_th}
    Return From Keyword    ${get_giatri_th}    ${get_du_no_th}    ${get_type_th}

Validate customer history and debt if return is not paid
    [Arguments]    ${input_ma_kh}    ${input_ma_th}    ${result_du_no_th}
    [Timeout]    5 mins
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_th}
    ${get_giatri_th}    ${get_du_no_th}    ${get_type_th}    Get tab no can thu tu khach if Return is not paid    ${input_ma_kh}    ${input_ma_th}
    ${get_trangthai_th}    ${get_can_tra_khach}    Get status and payment to return    ${input_ma_th}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_th}    ${get_can_tra_khach}
    Should Be Equal As Numbers    ${get_du_no_th}    ${result_du_no_th}
    Should Be Equal As Numbers    ${get_type_th}    4
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong}    ${get_can_tra_khach}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_th}
    Should Be Equal As Numbers    ${get_type}    6

Validate customer history and debt if return is paid
    [Arguments]    ${input_ma_kh}    ${input_ma_th}    ${result_du_no_th}    ${result_du_no_PTT}
    [Timeout]    5 mins
    ${get_trangthai_th}    ${get_can_tra_khach}    Get status and payment to return    ${input_ma_th}
    ${get_giatri_th}    ${get_du_no_th}    ${get_type_th}    ${get_giatri_phieu_tt}    ${get_du_no_phieu_tt}    ${get_type_phieu_tt}    Get tab no can thu tu khach if Return is paid
    ...    ${input_ma_kh}    ${input_ma_th}
    ${get_tienthu_tt}    Get PTT info to return    ${input_ma_th}
    ${get_tongcong}    ${get_trangthai}    ${get_type}    Get lich su ban tra hang frm API    ${input_ma_kh}    ${input_ma_th}
    #assert tab Công nợ
    Should Be Equal As Numbers    ${get_giatri_th}    ${get_can_tra_khach}
    Should Be Equal As Numbers    ${get_du_no_th}    ${result_du_no_th}
    Should Be Equal As Numbers    ${get_type_th}    4
    Should Be Equal As Numbers    ${get_giatri_phieu_tt}    ${get_tienthu_tt}
    Should Be Equal As Numbers    ${get_du_no_phieu_tt}    ${result_du_no_PTT}
    Should Be Equal As Numbers    ${get_type_phieu_tt}    0
    #assert tab Lịch sử
    Should Be Equal As Numbers    ${get_tongcong}    ${get_can_tra_khach}
    Should Be Equal As Numbers    ${get_trangthai}    ${get_trangthai_th}
    Should Be Equal As Numbers    ${get_type}    6

Get customer name frm API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_ten_kh}    Format String    $..Data[?(@.Code == '{0}')].Name    ${input_ma_kh}
    ${get_ten_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_ten_kh}
    Return From Keyword    ${get_ten_khachhang}

Get customer debt after cash flow
    [Arguments]    ${input_ma_kh}    ${input_ma_phieu}
    [Documentation]    Công nợ khách hàng sau khi tạo phiếu thu chi Sổ quỹ
    [Timeout]    5 mins
    ${get_resp}    Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from response json    ${get_resp}    ${jsonpath_id_kh}
    ${endpoint_debt_tab_by_customer}    Format String    ${endpoint_tab_nocanthu}    ${get_id_khachhang}
    ${jsonpath_no}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${input_ma_phieu}
    ${get_no}    Get data from API    ${endpoint_debt_tab_by_customer}    ${jsonpath_no}
    Return From Keyword    ${get_no}

Get customer id thr API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    Return From Keyword    ${get_id_kh}

Get Customer info and validate
    [Arguments]    ${cus_type}    ${customer_code}    ${cus_name}    ${cus_mobile}    ${cus_address}    ${cus_location}
    ...    ${cus_ward}    ${cus_gender}    ${cus_email}    ${cus_company}
    [Timeout]    5 mins
    ${response_khachhang_info}    Get Request and return body    ${endpoint_khachhang_allInfo}
    ${jsonpath_customername}    Format String    $..Data[?(@.Code=="{0}")].Name    ${customer_code}
    ${jsonpath_mobile}    Format String    $..Data[?(@.Code=="{0}")].ContactNumber    ${customer_code}
    ${jsonpath_location}    Format String    $..Data[?(@.Code=="{0}")].LocationName    ${customer_code}
    ${jsonpath_ward}    Format String    $..Data[?(@.Code=="{0}")].WardName    ${customer_code}
    ${jsonpath_address}    Format String    $..Data[?(@.Code=="{0}")].Address    ${customer_code}
    ${jsonpath_gender}    Format String    $..Data[?(@.Code=="{0}")].Gender    ${customer_code}
    ${jsonpath_email}    Format String    $..Data[?(@.Code=="{0}")].Email    ${customer_code}
    ${jsonpath_cus_type}    Format String    $..Data[?(@.Code=="{0}")].CustomerType    ${customer_code}
    ${jsonpath_cus_company}    Format String    $..Data[?(@.Code=="{0}")].Organization    ${customer_code}
    ${jsonpath_cus_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${customer_code}
    ${get_customer_name}    Get data from response json    ${response_khachhang_info}    ${jsonpath_customername}
    ${get_customer_mobile}    Get data from response json    ${response_khachhang_info}    ${jsonpath_mobile}
    ${get_customer_location}    Get data from response json   ${response_khachhang_info}    ${jsonpath_location}
    ${get_customer_ward}    Get data from response json    ${response_khachhang_info}    ${jsonpath_ward}
    ${get_customer_address}    Get data from response json    ${response_khachhang_info}    ${jsonpath_address}
    ${get_customer_gender}    Get data from response json and return false value    ${response_khachhang_info}    ${jsonpath_gender}
    ${get_customer_email}   Get data from response json    ${response_khachhang_info}    ${jsonpath_email}
    ${get_customer_type}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_type}
    ${get_customer_company}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_company}
    ${get_customer_id}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_id}
    ${gender}    Run Keyword If    '${get_customer_gender}'=='True'    Set Variable    Nam    ELSE IF    '${get_customer_gender}'=='False'    Set Variable    Nữ
    ...     ELSE    Set Variable    0
    Should Be Equal As Strings    ${cus_type}    ${get_customer_type}
    Should Be Equal As Strings    ${cus_name}    ${get_customer_name}
    Run Keyword If    '${cus_mobile}'=='none'    Should Be Equal As Numbers    ${get_customer_mobile}    0
    ...    ELSE    Should Be Equal As Strings    ${cus_mobile}    ${get_customer_mobile}
    Run Keyword If    '${cus_address}'=='none'    Should Be Equal As Numbers    ${get_customer_address}    0
    ...    ELSE    Should Be Equal As Strings    ${cus_address}    ${get_customer_address}
    Run Keyword If    '${cus_location}'=='none'    Should Be Equal As Numbers    ${get_customer_location}    0
    ...    ELSE    Should Be Equal As Strings    ${cus_location}    ${get_customer_location}
    Run Keyword If    '${cus_ward}'=='none'    Should Be Equal As Numbers    ${get_customer_ward}    0
    ...    ELSE    Should Be Equal As Strings    ${cus_ward}    ${get_customer_ward}
    Run Keyword If    '${cus_gender}'=='none'    Should Be Equal As Numbers    ${get_customer_gender}    0
    ...    ELSE    Should Be Equal As Strings    ${cus_gender}    ${gender}
    Run Keyword If    '${cus_email}'=='none'    Should Be Equal As Numbers    ${get_customer_email}    0
    ...    ELSE    Should Be Equal As Strings    ${cus_email}    ${get_customer_email}
    Run Keyword If    '${cus_company}'=='none'    Should Be Equal As Numbers    ${get_customer_company}    0
    ...    ELSE    Should Be Equal As Strings    ${cus_company}    ${get_customer_company}
    Return From Keyword    ${get_customer_id}

Delete customer
    [Arguments]    ${customer_id}
    [Timeout]    5 mins
    ${data_str}    Format String    {{"Ids":[{0}]}}    ${customer_id}
    log    ${data_str}
    Post request thr API    ${endpoint_delete_customer}    ${data_str}

Delete customer by Customer Code
    [Arguments]    ${customer_code}
    [Timeout]    5 mins
    ${response_khachhang_info}    Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_cus_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${customer_code}
    ${customer_id}    Get data from response json    ${endpoint_khachhang}    ${jsonpath_cus_id}
    ${data_str}    Format String    {{"Ids":[{0}]}}    ${customer_id}
    log    ${data_str}
    Post request thr API    ${endpoint_delete_customer}    ${data_str}

Get ma phieu, gia tri, du no in tab No can thu tu khach
    [Arguments]   ${input_ma_kh}
    [Timeout]   3 mins
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${endpoint_congno_kh}    Format String    ${endpoint_tab_nocanthu}    ${get_id_kh}
    ${get_resp}     Get Request and return body    ${endpoint_congno_kh}
    ${get_ma_phieu}   Get data from response json    ${get_resp}    $.Data..DocumentCode
    ${jsonpath_giatri}    Format String    $..Data[?(@.DocumentCode=="{0}")].Value    ${get_ma_phieu}
    ${jsonpath_duno}    Format String    $..Data[?(@.DocumentCode=="{0}")].Balance    ${get_ma_phieu}
    ${get_giatri}   Get data from response json    ${get_resp}    ${jsonpath_giatri}
    ${get_duno}     Get data from response json    ${get_resp}    ${jsonpath_duno}
    Return From Keyword    ${get_ma_phieu}    ${get_giatri}     ${get_duno}

Delete balance adjustment thr API
    [Arguments]   ${input_ma_kh}    ${ma_phieu}
    [Timeout]   3 mins
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${endpoint_delete_phieu}      Format String    ${endpoint_xoa_phieu_tab_nocanthu}    ${get_id_kh}
    ${endpoint_congno_kh}    Format String    ${endpoint_tab_nocanthu}    ${get_id_kh}
    ${jsonpath_id_phieu}      Format String  $..Data[?(@.DocumentCode=="{0}")].DocumentId    ${ma_phieu}
    ${get_id_phieu}   Get data from API    ${endpoint_congno_kh}      ${jsonpath_id_phieu}
    ${get_retailer_id}      Get RetailerID
    ${data_str}   Format String    {{"Adjustment":{{"Id":{0},"Code":"{1}","PartnerId":{2},"PartnerType":0,"CreatedDate":"2019-11-01T17:03:10.4330000+07:00","CreatedBy":20447,"Description":"abc","RetailerId":437336,"Balance":170000,"AdjustmentDate":"2019-11-01T17:03:01.7170000+07:00","User":{{"CompareGivenName":"admin","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","Id":20447,"Email":"","GivenName":"admin","CreatedDate":"2019-04-23T17:22:08.9100000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{3},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[]}}}},"customerId":{2},"CompareCode":"CRPKH018","CompareName":"A lâm 01689946055"}}        ${get_id_phieu}     ${ma_phieu}   ${get_id_kh}    ${get_retailer_id}
    Post request thr API    ${endpoint_delete_phieu}    ${data_str}

Create new Customer by generated info automatically
    ${customer_code}       Generate Random String       5       [LOWER]
    ${customer_name}        Generate Random String      12       [LOWER]
    ${customer_mobile}      Generate Mobile number
    ${customer_address}      Set Variable    123 ABDDD Hàng
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"","tempw":"","Code":"{1}","Name":"{2}","ContactNumber":"{3}","Address":"{4}","LocationName":"","WardName":"","CustomerGroupDetails":[],"RetailerId":{5},"Uuid":""}}}}    ${BRANCH_ID}    ${customer_code}    ${customer_name}    ${customer_mobile}   ${customer_address}    ${retailer_id}
    log    ${data_str}
    Post request thr API    /customers    ${data_str}
    Return From Keyword    ${customer_code}

Create new Customer with Mobile Number
    [Arguments]          ${mobile_number}
    ${customer_code}       Generate Random String       5       [LOWER]
    ${customer_name}        Generate Random String      12       [LOWER]
    ${customer_address}      Set Variable    123 ABDDD Hàng
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"","tempw":"","Code":"{1}","Name":"{2}","ContactNumber":"{3}","Address":"{4}","LocationName":"","WardName":"","CustomerGroupDetails":[],"RetailerId":{5},"Uuid":""}}}}    ${BRANCH_ID}    ${customer_code}    ${customer_name}    ${mobile_number}   ${customer_address}    ${retailer_id}
    log    ${data_str}
    Post request thr API    /customers    ${data_str}
    Return From Keyword    ${customer_code}     ${customer_name}     ${customer_address}

Adapt Customer Dept
    [Arguments]        ${customer_code}        ${adjusted_amount}
    ${response_khachhang_info}    Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_cus_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${customer_code}
    ${customer_id}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_id}
    ${data_str}    Format String    {{"Adjustment":{{"Balance":{0},"AdjustmentDate":"","Value":-52000}},"customerId":{1},"CompareCode":"{2}","CompareName":"abc","CompareBalance":75000}}    ${adjusted_amount}     ${customer_id}    ${customer_code}
    log    ${data_str}
    ${endpoint_adjust_debt_by_customerid}        Format String        ${endpoint_tao_phieu_dieu_chinh}        ${customer_id}
    ${resp3.json()}   Post request thr API   ${endpoint_adjust_debt_by_customerid}    ${data_str}
    ${ma_phieu}     Get data from response json    ${resp3.json()}    $..Code
    Return From Keyword    ${ma_phieu}

Put unpaid value for invoice
    [Arguments]        ${customer_code}       ${invoice_code}
    [Documentation]        Trả hóa đơn chưa được thanh toán trong danh sách các hóa đơn chưa được thanh toán ở Pop up Thanh Toán - tab Nợ cần thu của khách
    ${response_khachhang_info}    Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_cus_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${customer_code}
    ${customer_id}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_id}
    ${endpoint_list_unpaid_invoice_by_cusid}      Format String    ${endpoint_list_unpaid_invoice}    ${customer_id}
    ${respbody_list_unpaid}        Get Request and return body       ${endpoint_list_unpaid_invoice_by_cusid}
    ${jsonpath_unpaid_by_invcode}       Format String    $..Data[?(@.Code=="{0}")].UnPaid    ${invoice_code}
    ${jsonpath_invid_by_invcode}       Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_value_first_unpaid_inv}     Get data from response json    ${respbody_list_unpaid}    ${jsonpath_unpaid_by_invcode}
    ${get_first_inv_id}     Get data from response json    ${respbody_list_unpaid}    ${jsonpath_invid_by_invcode}
    ${data_str}    Format String    {{"Payments":[{{"DocumentCode":"HD000012","Amount":{3},"Method":"Cash","InvoiceId":{2},"CustomerId":{1},"CustomerName":"Nâu nâu","AccountId":0,"IsUsePriceCod":false,"CodNeedPayment":0,"IsCompleteInvoice":false,"AutoAllocation":1,"Uuid":""}}],"BranchId":{0}}}    ${BRANCH_ID}       ${customer_id}     ${get_first_inv_id}     ${get_value_first_unpaid_inv}
    log    ${data_str}
    ${resp3.json()}   Post request thr API    ${endpoint_payment_cus}    ${data_str}
    ${get_ma_phieu_tt}      Get data from response json    ${resp3.json()}   $..Code
    Return From Keyword       ${get_ma_phieu_tt}

Get payment code in customer debt
    [Arguments]        ${customer_code}
    ${response_khachhang_info}    Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_cus_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${customer_code}
    ${customer_id}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_id}
    ${endpoint_no_canthu}   Format String    ${endpoint_tab_nocanthu}    ${customer_id}
    ${get_payment_code}   Get data from API    ${endpoint_no_canthu}    $.Data.[0].DocumentCode
    Return From Keyword   ${get_payment_code}

Get Customer Group ID by Customer Name
    [Arguments]        ${customer_name}
    ${response_khachhang_info}    Get Request and return body    ${endpoint_list_groupcustomer}
    ${jsonpath_cus_group_id}    Format String    $..Data[?(@.Name=="{0}")].Id    ${customer_name}
    ${group_customer_id}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_group_id}
    Return From Keyword   ${group_customer_id}

Get customer group id thr API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Name == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_list_groupcustomer}    ${jsonpath_id_kh}
    Return From Keyword    ${get_id_kh}

Get total of orders by cutomer code
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${endpoint_orders}    Format String    ${endpoint_get_orders_by_customer_code}    ${input_ma_kh}
    ${response_orders}    Get Request and return body    ${endpoint_orders}
    ${get_soluong_dh}    Get data from response json    ${response_orders}    $.Total
    Return From Keyword    ${get_soluong_dh}

Get current point by customer thr API
    [Arguments]   ${input_ma_kh}
    [Timeout]   3 mins
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${endpoint_lichsu_tichdiem}    Format String    ${endpoint_lichsu_tichdiem}    ${get_id_kh}
    ${get_resp}     Get Request and return body    ${endpoint_lichsu_tichdiem}
    ${get_tong_diem}   Get data from response json    ${get_resp}    $..Total1Value
    Return From Keyword    ${get_tong_diem}

Assert point in tab Lich su tich diem
    [Arguments]   ${input_ma_kh}      ${input_ma_hd}      ${input_diem_hientai}     ${input_diem_hd}
    [Timeout]   3 mins
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${endpoint_lichsu_tichdiem}    Format String    ${endpoint_lichsu_tichdiem}    ${get_id_kh}
    ${get_resp}     Get Request and return body    ${endpoint_lichsu_tichdiem}
    ${get_tong_diem}   Get data from response json    ${get_resp}    $..Total1Value
    ${jsonpath_diem_hd}    Format String    $..Data[?(@.DocumentCode=="{0}")].Value    ${input_ma_hd}
    ${get_diem_hd}   Get data from response json    ${get_resp}    ${jsonpath_diem_hd}
    Should Be Equal As Numbers    ${get_tong_diem}    ${input_diem_hientai}
    Should Be Equal As Numbers    ${get_diem_hd}    ${input_diem_hd}

Create new customer and get info
    [Arguments]    ${ma_kh}
    ${get_cus_id}    Get customer id thr API    ${ma_kh}
    Run Keyword If    '${get_cus_id}'=='0'    Create new Customer with customer code    ${ma_kh}    ELSE    Run Keywords    Delete customer    ${get_cus_id}    AND
    ...    Create new Customer with customer code    ${ma_kh}
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${ma_kh}
    ${get_id_kh}    Get customer id thr API    ${ma_kh}
    Return From Keyword    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}

Update info customer
    [Documentation]    thay đổi sdt của khách hàng
    [Arguments]    ${ma_kh}    ${ten_kh}
    ${sdt}      Generate Mobile number
    ${customer_address}      Generate Random String       5       [UPPER]
    ${mail_address}    Generate email for customer
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_time}    Get Current Date
    ${date_time}    Add Time To Date    ${get_time}    2mins
    ${get_cus_id}    Get customer id thr API    ${ma_kh}
    ${data_str}    Format String    {{"Customer":{{"Id":{0},"Type":0,"Code":"{1}","Name":"{7}","ContactNumber":"{2}","Email":"{8}","Address":"{9}","RetailerId":{3},"Debt":150500,"ModifiedDate":"{4}","CreatedDate":"2020-10-14T11:34:24.3970000+07:00","CreatedBy":{5},"LocationName":"","Uuid":"","IsActive":true,"BranchId":{6},"WardName":"","LastTradingDate":"2020-10-14T11:34:32.5770000+07:00","isDeleted":false,"Revision":"AAAAAAelpuM=","SearchNumber":"0985777035","CustomerGroupDetails":[],"CustomerSocials":[],"AddressBooks":[],"PaymentAllocation":[],"IdOld":0,"CompareCode":"{1}","CompareName":"{7}","GenderName":"","MustUpdateDebt":false,"MustUpdatePoint":false,"InvoiceCount":0,"temploc":"","tempw":"","Organization":""}}}}
    ...    ${get_cus_id}    ${ma_kh}    ${sdt}    ${get_id_nguoitao}    ${date_time}    ${get_id_nguoiban}    ${BRANCH_ID}    ${ten_kh}    ${mail_address}    ${customer_address}
    log    ${data_str}
    Post request thr API    /customers?kvuniqueparam=2020    ${data_str}
    Return From Keyword    ${sdt}    ${mail_address}    ${customer_address}

Get customer id and code by number phone thr API
    [Arguments]    ${input_sdt_kh}
    [Timeout]    5 mins
    ${jsonpath_id_kh}    Format String    $..Data[?(@.SearchNumber=='{0}')].Id    ${input_sdt_kh}
    ${jsonpath_ma_kh}    Format String    $..Data[?(@.SearchNumber=='{0}')].Code    ${input_sdt_kh}
    ${get_resp}   Get Request and return body    ${endpoint_khachhang}
    ${get_id_kh}    Get data from response json    ${get_resp}   ${jsonpath_id_kh}
    ${get_ma_kh}    Get data from response json    ${get_resp}    ${jsonpath_ma_kh}
    Return From Keyword    ${get_id_kh}   ${get_ma_kh}

Get email customer frm API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_email_kh}    Format String    $..Data[?(@.Code=="{0}")].Email    ${input_ma_kh}
    ${get_customer_email}    Get data from API    ${endpoint_khachhang}    ${jsonpath_email_kh}
    Return From Keyword    ${get_customer_email}

Create new Customer with customer code
    [Arguments]    ${customer_code}
    ${customer_name}        Generate Random String      12       [LOWER]
    #sdt random 3 so cuoi
    ${prefix_code}    Set Variable    0379089
    ${hex} =    Generate Random String    3    [NUMBERS]
    Set Test Variable    \${last_3_of_phonenumber}    ${hex}
    ${customer_mobile}    Catenate    SEPARATOR=    ${prefix_code}    ${hex}
    #Email
    ${email}    Generate email for customer
    #d.chi
    ${dia_chi}        Generate Random String      15       [LOWER]
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"Hà Nội - Quận Hoàn Kiếm","tempw":"Phường Trần Hưng Đạo","Code":"{1}","Name":"{2}","Organization":"","ContactNumber":"{3}","Address":"{6}","LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","LocationId":243,"WardId":30,"Email":"{5}","CustomerGroupDetails":[],"RetailerId":{4},"Uuid":""}},"isMergedSupplier":false,"isCreateNewSupplier":false,"MergedSupplierId":0,"SkipValidateEmail":false}}
    ...    ${BRANCH_ID}    ${customer_code}    ${customer_name}    ${customer_mobile}    ${retailer_id}    ${email}    ${dia_chi}
    log    ${data_str}
    Post request thr API     /customers    ${data_str}

Get list contact number by search text thr API
    [Arguments]    ${search_text}
    ${endpoint_str_search}    Format String    ${endpoint_search_kh_theo_3_so_cuoi_sdt}    ${search_text}
    ${get_list_contact_number}     Get raw data from API    ${endpoint_str_search}    $..Data..ContactNumber
    ${get_list_customer_code}     Get raw data from API    ${endpoint_str_search}    $..Data..Code
    ${get_list_customer_name}     Get raw data from API    ${endpoint_str_search}    $..Data..Name
    Return From Keyword    ${get_list_contact_number}    ${get_list_customer_code}    ${get_list_customer_name}

Get list email by search text thr API
    [Arguments]    ${search_text}
    ${endpoint_str_search}    Format String    ${endpoint_search_kh_theo_email}    ${search_text}
    ${get_list_customer_email}     Get raw data from API    ${endpoint_str_search}    $..Data..Email
    Return From Keyword    ${get_list_customer_email}

Assert Cong no khach hang
    [Arguments]     ${ma_kh}    ${input_no}     ${input_tongban}      ${input_tongban_tru_trahang}
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${input_no}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${input_tongban}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${input_tongban_tru_trahang}

Assert Cong no khach hang until succeed
    [Arguments]     ${ma_kh}    ${input_no}     ${input_tongban}      ${input_tongban_tru_trahang}
    Wait Until Keyword Succeeds    5x    3s    Assert Cong no khach hang    ${ma_kh}    ${input_no}     ${input_tongban}      ${input_tongban_tru_trahang}

Delete customer by phone number thr API
    [Arguments]     ${dien_thoai}
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Run Keyword If    ${get_id_kh}!=0     Delete customer   ${get_id_kh}

Get condition name to add customers to the group from API
    [Arguments]    ${input_ten_dk}
    [Timeout]    5 mins
    ${jsonpath_dk}    Format String    $..Data[?(@.Title=="{0}")].Name    ${input_ten_dk}
    ${get_ten_dk}    Get data from API    ${endpoint_filter_dk_them_kh_vao_nhom}    ${jsonpath_dk}
    Return From Keyword    ${get_ten_dk}

Get operator by name
    [Arguments]     ${input_so_sanh}
    ${operator}     Run Keyword If      '${input_so_sanh}'=='>'      Set Variable    0    ELSE IF      '${input_so_sanh}'=='>='      Set Variable    1       ELSE IF      '${input_so_sanh}'=='='      Set Variable    2     ELSE IF      '${input_so_sanh}'=='<'      Set Variable    3     ELSE      Set Variable    4
    Return From Keyword    ${operator}

Get type update list by name
    [Arguments]     ${input_name}
    ${get_type_update}     Run Keyword If      '${input_name}'=='Không cập nhật danh sách khách hàng'      Set Variable    0    ELSE IF      '${input_name}'=='Thêm khách hàng vào nhóm theo điều kiện'      Set Variable    1       ELSE       Set Variable    2
    Return From Keyword    ${get_type_update}

Add new group customer by the condition
    [Arguments]   ${input_ten_nhom}     ${input_dieu_kien}    ${input_so_sanh}    ${input_gia_tri}      ${input_option}     ${input_auto}
    ${get_ten_dk}   Get condition name to add customers to the group from API    ${input_dieu_kien}
    ${operator}   Get operator by name    ${input_so_sanh}
    ${get_type_update_list}   Get type update list by name     ${input_option}
    ${object}    Generate Random String     4    [NUMBERS]
    ${is_auto_actual}     Set Variable If    '${input_auto}'=='Không cập nhật danh sách khách hàng'    0      ${input_auto}
    ${payload}      Set Variable        {"CustomerGroup":{"Id":0,"Name":"${input_ten_nhom}","Description":"","filters":[{"FieldName":"${get_ten_dk}","Operator":${operator},"Value":${input_gia_tri},"DataType":"number"}],"Discount":null,"DiscountRatio":null,"CompareName":"","CompareDiscount":null,"CompareDiscountRatio":null,"typeUpdateList":${get_type_update_list},"isSystemAutoUpdate":${is_auto_actual},"DiscountType":"VND","Filter":"[{\\"FieldName\\":\\"${get_ten_dk}\\",\\"Operator\\":${operator},\\"Value\\":${input_gia_tri},\\"DataType\\":\\"number\\",\\"$$hashKey\\":\\"object:${object}\\"}]","TypeUpdate":1}}
    Log    ${payload}
    Post request thr API     ${endpoint_tao_nhom_kh}   ${payload}

Edit group customer by the condition
    [Arguments]   ${input_ten_nhom}     ${input_dieu_kien}    ${input_so_sanh}    ${input_gia_tri}      ${input_option}     ${input_auto}
    ${get_id_group}   Get customer group id thr API    ${input_ten_nhom}
    ${get_ten_dk}   Get condition name to add customers to the group from API    ${input_dieu_kien}
    ${operator}   Get operator by name    ${input_so_sanh}
    ${get_type_update_list}   Get type update list by name     ${input_option}
    ${is_auto_actual}     Set Variable If    '${input_auto}'=='Không cập nhật danh sách khách hàng'    false      ${input_auto}
    ${object}    Generate Random String     4    [NUMBERS]
    ${payload}      Set Variable      {"CustomerGroup":{"Id":${get_id_group},"Name":"${input_ten_nhom}","Description":"","filters":[{"FieldName":"${get_ten_dk}","Operator":${operator},"Value":${input_gia_tri},"DataType":"number"}],"CompareName":"","typeUpdateList":${get_type_update_list},"isSystemAutoUpdate":${is_auto_actual},"DiscountType":"VND","Filter":"[{\\"FieldName\\":\\"${get_ten_dk}\\",\\"Operator\\":${operator},\\"Value\\":${input_giatri},\\"DataType\\":\\"number\\",\\"$$hashKey\\":\\"object:${object}\\"}]","TypeUpdate":1}}
    Log    ${payload}
    Post request thr API     ${endpoint_tao_nhom_kh}   ${payload}

Delete customer group thr API
    [Arguments]    ${input_ten_nhom}
    [Timeout]    3 mins
    ${get_id_group}   Get customer group id thr API    ${input_ten_nhom}
    Delete request thr API    /customers/group/${get_id_group}?CompareName=${input_ten_nhom}&kvuniqueparam=2020

Delete customer group by customer id
    [Arguments]   ${input_ten_nhom}    ${input_id_nhom}
    [Timeout]    3 mins
    Delete request thr API    /customers/group/${input_id_nhom}?CompareName=${input_ten_nhom}&kvuniqueparam=2020

Delete customer if it exists
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_id_kh}'!='0'    Delete customer   ${get_id_kh}

Delete customer group if it exists
    [Arguments]    ${input_ten_nhom}
    [Timeout]    5 mins
    ${get_id_group}   Get customer group id thr API    ${input_ten_nhom}
    Run Keyword If    '${get_id_group}'!='0'    Delete customer group by customer id    ${input_ten_nhom}    ${get_id_group}

Get group of customer thr API
    [Arguments]     ${input_ma_kh}
    ${jsonpath_cus_group}    Format String    $..Data[?(@.Code=="{0}")].Groups    ${input_ma_kh}
    ${get_resp}   Get Request and return body    ${endpoint_khachhang}
    ${get_cus_group}    Get data from response json     ${get_resp}    ${jsonpath_cus_group}
    ${get_cus_group}    Convert To String    ${get_cus_group}
    Return From Keyword    ${get_cus_group}

Get customer reward point from API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_tong_diem}    Format String    $..Data[?(@.Code=="{0}")].RewardPoint    ${input_ma_kh}
    ${response_khachhang}    Get Request and return body    ${endpoint_khachhang}
    ${get_tong_diem}    Get data from response json    ${response_khachhang}    ${jsonpath_tong_diem}
    Return From Keyword    ${get_tong_diem}

Assert reward point af ex
    [Arguments]     ${input_ma_kh}    ${input_tongdiem_af}
    ${get_tong_diem_af}   Get customer reward point from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${input_tongdiem_af}    ${get_tong_diem_af}

Adjust point of customer thr API
    [Arguments]   ${input_ma_kh}    ${input_diem}
    ${get_id_kh}      Get customer id thr API    ${input_ma_kh}
    ${endpoint_dieu_chinh_diem}     Format String      ${endpoint_dieu_chinh_diem}    ${get_id_kh}
    ${data_str}   Set Variable    {"Adjustment":{"Balance":${input_diem},"AdjustmentDate":"","Value":${input_diem}},"customerId":${get_id_kh},"CompareCode":"PVKH003","CompareName":"abc","CompareBalance":0}
    log    ${data_str}
    Post request thr API    ${endpoint_dieu_chinh_diem}    ${data_str}

Assert value in tab cong no khach hang
    [Arguments]    ${invoice_code}    ${input_bh_ma_kh}    ${result_nohientai}    ${result_tongban}    ${input_bh_khachtt}    ${actual_khachtt}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    Log    assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}

Assert value in tab cong no khach hang incase order
    [Arguments]   ${input_ma_kh}    ${order_code}    ${result_no_hientai_kh}   ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${input_khtt}    ${actual_khtt}
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khtt}
