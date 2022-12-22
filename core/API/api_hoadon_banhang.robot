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
Resource          api_khachhang.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_mhbh.robot
Resource          api_khachhang.robot

*** Variables ***
${endpoint_invoice_detail}    /invoices/{0}?Includes=TotalQuantity&Includes=Order&Includes=User&Includes=SoldBy&Includes=Return&Includes=Payments&Includes=Customer&Includes=PriceBook&Includes=InvoicePromotions&Includes=InvoiceOrderSurcharges    # 0 la ID hoa don
${endpoint_hd_contains_customer_info}    /invoices?format=json&Includes=BranchName&Includes=Branch&Includes=InvoiceDeliveries&Includes=TableAndRoom&Includes=Customer&Includes=Payments&Includes=SoldBy&Includes=User&Includes=InvoiceOrderSurcharges&Includes=Order&ForSummaryRow=true&Includes=SaleChannel&UsingStoreProcedure=false&%24inlinecount=allpages&%24top=100&ExpectedDeliveryFilterType=alltime
${endpoint_hd_contains_product_info}    /invoices/{0}/details?format=json&Includes=ProductName&Includes=ProductSName&Includes=ProductCode&Includes=SubTotal&Includes=Product&ForSale=true&%24inlinecount=allpages&%24top=100
${endpoint_kenhbanhang}    /salechannel?IncludeId=0&IsActive=true
${endpoint_hoadon}    /invoices?format=json&Includes=BranchName&Includes=Branch&Includes=DeliveryInfoes&Includes=DeliveryPackages&Includes=TableAndRoom&Includes=Customer&Includes=Payments&Includes=SoldBy&Includes=User&Includes=InvoiceOrderSurcharges&Includes=Order&ForSummaryRow=true&Includes=SaleChannel&UsingStoreProcedure=false&%24inlinecount=allpages&%24top=100&ExpectedDeliveryFilterType=alltime&%24filter=(BranchId+eq+{0}+and+PurchaseDate+eq+%27year%27+and+(Status+eq+3+or+Status+eq+1+or+Status+eq+5+or+Status+eq+2))    # 0: branchid
${endpoint_hoadon_giaohang}    /invoices?format=json&Includes=BranchName&Includes=Branch&Includes=DeliveryInfoes&Includes=DeliveryPackages&Includes=TableAndRoom&Includes=Customer&Includes=Payments&Includes=SoldBy&Includes=User&Includes=InvoiceOrderSurcharges&Includes=Order&ForSummaryRow=true
${endpoint_phieu_thanhtoan_hd}    /payments?InvoiceId={0}&format=json&Includes=User&Includes=CustomerName&Includes=Invoice&GroupCode=true&%24inlinecount=allpages&%24top=15    #id hóa đơn
${endpoint_hd_all_delivery_status}    /invoices?format=json&Includes=BranchName&Includes=Branch&Includes=DeliveryInfoes&Includes=DeliveryPackages&Includes=TableAndRoom&Includes=Customer&Includes=Payments&Includes=SoldBy&Includes=User&Includes=InvoiceOrderSurcharges&Includes=Order&ForSummaryRow=true&Includes=SaleChannel&UsingStoreProcedure=false&%24inlinecount=allpages&ExpectedDeliveryFilterType=alltime&%24filter=(BranchId+eq+{0}+and+PurchaseDate+eq+%27year%27+and+(Status+eq+3+or+Status+eq+1+or+Status+eq+5+or+Status+eq+2))    #branch id
${enpoint_kenh_ban_hang}    /salechannel
${endpoint_warranty_detail_in_invoice}   /invoice-warranty/list-by-product?InvoiceId={0}&ProductId={1}
${endpoint_list_invoice_currentdate}    /invoices?format=json&%24filter=(BranchId+eq+{0}+and+(PurchaseDate+ge+datetime%27{1}T00%3A00%3A00%27)+and+(Status+eq+3+or+Status+eq+1))   #branch id - current date
${endpoint_summary_inv_currentdate}   /invoices/dashboard?$filter=(BranchId+eq+{0}+and+(Status+eq+1+or+Status+eq+3)+and+(PurchaseDate+ge+datetime%27{1}T00:00:00%27))   #branch id - current date
${endpoint_hoadon_nhathuoc}       /invoices?format=json&Includes=BranchName&Includes=Branch&Includes=DeliveryInfoes&Includes=DeliveryPackages&Includes=Customer&Includes=Payments&Includes=SoldBy&Includes=User&Includes=InvoiceOrderSurcharges&Includes=Order&ForSummaryRow=true&Includes=SaleChannel&Includes=Returns&Includes=InvoiceMedicine&Includes=PriceBook&UsingTotalApi=true&UsingStoreProcedure=false&%24inlinecount=allpages&ExpectedDeliveryFilterType=alltime
${endpoint_shipping}    /v1/get-order?ORDER_NUMBER={0}&client_code={1}    #0 ma van don - 1 ma DTGH
#
${endpoint_invoice_omni}      /omnichannel/getChannelInvoiceSyncError?kvuniqueparam=2020
#
${endpoint_list_invoice}      /invoices/list?format=json&Includes=BranchName&Includes=Branch&Includes=DeliveryInfoes&Includes=DeliveryPackages&Includes=Customer&Includes=Payments&Includes=SoldBy&Includes=User&Includes=InvoiceOrderSurcharges&Includes=Order&ForSummaryRow=true&Includes=SaleChannel&Includes=Returns&Includes=InvoiceMedicine&Includes=PriceBook&UsingTotalApi=true&UsingStoreProcedure=false

*** Keywords ***
Get Endpoint Invoice incl product info
    [Arguments]    ${id}
    [Timeout]    5 mins
    ${ep}    Format String    ${endpoint_hd_contains_product_info}    ${id}
    Return From Keyword    ${ep}

Get product exchange info
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${get_first_ma_hd}    Get data from API    ${endpoint_hoadon_giaohang}    $..Data[1].Code
    ${jsonpath_ten_kh}    Format String    $..Data[?(@.Code == '{0}')].CustomerCode    ${get_first_ma_hd}
    ${get_ten_kh}    Get data from API    ${endpoint_hd_contains_customer_info}    ${jsonpath_ten_kh}
    ${ID}    Get data from API    ${endpoint_hd_contains_customer_info}    $..Data[1].Id
    ${endpoint_incl_product}    Get Endpoint Invoice incl product info    ${ID}
    ${get_ma_sp_tra}    Get data from API    ${endpoint_incl_product}    $..Product.Code
    Return From Keyword    ${get_first_ma_hd}    ${get_ten_kh}    ${get_ma_sp_tra}

Get invoice info
    [Arguments]    ${invoice_code}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_thoigian_hd}    Get data from API    ${endpoint_invoice_by_id}    $.PurchaseDate
    ${get_ma_kh}    Get data from API    ${endpoint_invoice_by_id}    $.CustomerCode
    ${get_banggia_by_hd}    Get data from API    ${endpoint_invoice_by_id}    $..PriceBook.CompareName
    ${get_ma_dh_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $..OrderId
    ${get_trangthai}    Get data from API    ${endpoint_invoice_by_id}    $.StatusValue
    ${get_branch}    Get data from API    ${endpoint_invoice_by_id}    $.BranchId
    ${get_nguoi_ban_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $.SoldBy.GivenName
    ${get_nguoi_tao_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $.User.GivenName
    ${get_id_kenh_bh}    Get data from API    ${endpoint_kenhbanhang}    $..Data[0].Id
    ${endpoint_kenh_bh_by_id}    Format String    ${endpoint_kenhbanhang}    ${get_id_kenh_bh}
    ${get_ten_kenh_bh}    Get data from API    ${endpoint_kenhbanhang}    $..Data..Name
    Return From Keyword    ${get_thoigian_hd}    ${get_ma_kh}    ${get_banggia_by_hd}    ${get_ma_dh_in_hd}    ${get_trangthai}    ${get_branch}
    ...    ${get_nguoi_ban_in_hd}    ${get_nguoi_tao_in_hd}    ${get_ten_kenh_bh}

Get every single product sale in detail in invoice
    [Arguments]    ${invoice_code}    ${input_ma_sp}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${jsonpath_ten_hh}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')]..FullName    ${input_ma_sp}
    ${jsonpath_soluong_hh}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')]..Quantity    ${input_ma_sp}
    ${jsonpath_discount_hh}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')]..Discount    ${input_ma_sp}
    ${jsonpath_giaban_hh}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')]..Price    ${input_ma_sp}
    ${jsonpath_thanhtien_hh}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')]..SubTotal    ${input_ma_sp}
    ${get_ten_sp_in_hd}    Get data from API    ${endpoint_invoice_by_id}    ${jsonpath_ten_hh}
    ${get_so_luong_in_hd}    Get data from API    ${endpoint_invoice_by_id}    ${jsonpath_soluong_hh}
    ${get_don_gia_in_hd}    Get data from API    ${endpoint_invoice_by_id}    ${jsonpath_giaban_hh}
    ${get_discount_sp}    Get data from API    ${endpoint_invoice_by_id}    ${jsonpath_discount_hh}
    ${get_thanhtien_by_product}    Get data from API    ${endpoint_invoice_by_id}    ${jsonpath_thanhtien_hh}
    Return From Keyword    ${get_ten_sp_in_hd}    ${get_so_luong_in_hd}    ${get_don_gia_in_hd}    ${get_discount_sp}    ${get_thanhtien_by_product}

Assert sale products info in invoice
    [Arguments]    ${item_productcode}    ${item_product_name_bf_ex}    ${item_num_bf_ex}    ${item_baseprice_bf_ex}    ${item_discount_product}    ${item_totalsale_by_product}
    ...    ${invoice_code}
    [Timeout]    5 mins
    ${get_ten_sp_in_hd}    ${get_so_luong_in_hd}    ${get_don_gia_in_hd}    ${get_discount_sp}    ${get_thanhtien_by_product}    Get every single product sale in detail in invoice    ${invoice_code}
    ...    ${item_productcode}
    Should Be Equal As Strings    ${item_product_name_bf_ex}    ${get_ten_sp_in_hd}
    Should Be Equal As Numbers    ${item_num_bf_ex}    ${get_so_luong_in_hd}
    Should Be Equal As Numbers    ${item_baseprice_bf_ex}    ${get_don_gia_in_hd}
    Should Be Equal As Numbers    ${item_discount_product}    ${get_discount_sp}
    Should Be Equal As Numbers    ${item_totalsale_by_product}    ${get_thanhtien_by_product}

Get invoice info payment
    [Arguments]    ${invoice_code}
    [Timeout]    5 mins
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_tong_so_luong}    Get data from API    ${endpoint_invoice_by_id}    $.TotalQuantity
    ${get_discount_hd}    Get data from API    ${endpoint_invoice_by_id}    $.Discount
    ${get_thu_khac}    Get data from API    ${endpoint_invoice_by_id}    $.Surcharge
    ${get_khach_can_tra}    Get data from API    ${endpoint_invoice_by_id}    $.Total
    ${get_khachtt}    Get data from API    ${endpoint_invoice_by_id}    $.TotalPayment
    Return From Keyword    ${get_tong_so_luong}    ${get_discount_hd}    ${get_thu_khac}    ${get_khach_can_tra}    ${get_khachtt}

Assert payment invoice
    [Arguments]    ${total_num}    ${dicount_invoice}    ${other_payment}    ${total}    ${total_payment}    ${invoice_code}
    [Timeout]    5 mins
    ${get_tong_so_luong}    ${get_discount_hd}    ${get_thu_khac}    ${get_khach_can_tra}    ${get_khachtt}    Get invoice info payment    ${invoice_code}
    Should Be Equal As Numbers    ${total_num}    ${get_tong_so_luong}
    Should Be Equal As Numbers    ${get_discount_hd}    ${dicount_invoice}
    Should Be Equal As Numbers    ${other_payment}    ${get_thu_khac}
    Should Be Equal As Numbers    ${get_khach_can_tra}    ${total}
    Should Be Equal As Numbers    ${total_payment}    ${get_khachtt}

Get invoice info incl khach can tra
    [Arguments]    ${input_mahang}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    ${get_first_ma_hd}    Get data from API    ${endpoint_thekho_in_product}    $.Data[0]..DocumentCode
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${get_first_ma_hd}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_ma_kh_by_hd}    Get data from API    ${endpoint_invoice_by_id}    $.CustomerCode
    ${get_tong_tien_hang}    Get data from API    ${endpoint_invoice_by_id}    $.InvoiceDetails..SubTotal
    ${get_khach_tt}    Get data from API    ${endpoint_invoice_by_id}    $.TotalPayment
    ${get_giamgia_hd}    Get data from API    ${endpoint_invoice_by_id}    $.Discount
    ${get_khachcantra}    Get data from API    ${endpoint_invoice_by_id}    $.Total
    ${get_trangthai}    Get data from API    ${endpoint_invoice_by_id}    $.StatusValue
    Return From Keyword    ${get_first_ma_hd}    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}
    ...    ${get_trangthai}

Get invoice info with new price
    [Arguments]    ${input_mahang}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    ${get_first_ma_hd}    Get data from API    ${endpoint_thekho_in_product}    $.Data[0]..DocumentCode
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${get_first_ma_hd}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_discount_giamoi}    Get data from API    ${endpoint_invoice_by_id}    $.InvoiceDetails..Discount
    ${get_dongia_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $.InvoiceDetails..Price
    ${get_giamoi_in_hd}    Minus    ${get_dongia_in_hd}    ${get_discount_giamoi}
    ${get_ggsp}    Convert To String    ${get_discount_giamoi}
    ${get_ggsp}    Replace String    ${get_ggsp}    -    ${EMPTY}
    ${get_ggsp}    Convert To Number    ${get_ggsp}
    Return From Keyword    ${get_giamoi_in_hd}    ${get_ggsp}

Get serial number in invoice details
    [Arguments]    ${input_ma_hd}    ${input_mahang}
    [Timeout]    5 mins
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${input_ma_hd}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${jsonpathu_serialnumber}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')].SerialNumbers    ${input_mahang}
    ${get_list_serialnumber}    Get raw data from API    ${endpoint_invoice_by_id}    ${jsonpathu_serialnumber}
    Return From Keyword    ${get_list_serialnumber}

Get invoice details incl units
    [Arguments]    ${input_mahang}
    [Timeout]    5 mins
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    ${get_first_ma_hd}    Get data from API    ${endpoint_thekho_in_product}    $.Data[0]..DocumentCode
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${get_first_ma_hd}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_ma_sp_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $..Product.Code
    ${get_tenhang_unit_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $..FullName
    ${get_so_luong_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $.InvoiceDetails..Quantity
    ${get_don_gia_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $.InvoiceDetails..Price
    ${get_discount_sp}    Get data from API    ${endpoint_invoice_by_id}    $.InvoiceDetails..Discount
    ${get_thanhtien_in_hd}    Get data from API    ${endpoint_invoice_by_id}    $.InvoiceDetails..SubTotal
    Return From Keyword    ${get_ma_sp_in_hd}    ${get_tenhang_unit_in_hd}    ${get_so_luong_in_hd}    ${get_don_gia_in_hd}    ${get_discount_sp}    ${get_thanhtien_in_hd}

Get delivery info frm invoice API
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${get_invoice_id}    Get invoice id    ${input_ma_hd}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}       Get Request and return body    ${endpoint_invoice_by_id}
    ${get_tennguoinhan_gh_in_hd}    Get data from response json       ${get_resp}    $.InvoiceDelivery.Receiver
    ${get_dienthoai_gh_in_hd}    Get data from response json     ${get_resp}    $.InvoiceDelivery.ContactNumber
    ${get_dia_chi_gh_in_hd}   Get data from response json    ${get_resp}    $.InvoiceDelivery.Address
    ${get_khuvuc_gh_in_hd}    Get data from response json     ${get_resp}    $.InvoiceDelivery.LocationName
    ${get_phuongxa_gh_in_hd}    Get data from response json     ${get_resp}    $.InvoiceDelivery.WardName
    ${get_nguoi_gh_in_hd}    Get data from response json     ${get_resp}    $..DeliveryDetail.PartnerCode
    ${get_ten_DTGH_in_hd}    Get data from response json     ${get_resp}    $..DeliveryDetail.PartnerName
    ${get_trongluong_gh_in_hd}    Get data from response json     ${get_resp}    $..InvoiceDelivery..Weight
    ${get_phi_gh_in_hd}    Get data from response json     ${get_resp}    $.InvoiceDelivery.Price
    ${get_trangthai_gh_in_hd}   Get data from response json     ${get_resp}    $..DeliveryDetail.Status
    ${get_trangthai_thuhotien}   Get data from response json     ${get_resp}    $..DeliveryDetail.UsingPriceCod
    Return From Keyword    ${get_tennguoinhan_gh_in_hd}    ${get_dienthoai_gh_in_hd}    ${get_dia_chi_gh_in_hd}    ${get_khuvuc_gh_in_hd}    ${get_phuongxa_gh_in_hd}    ${get_nguoi_gh_in_hd}
    ...    ${get_ten_DTGH_in_hd}      ${get_trongluong_gh_in_hd}    ${get_phi_gh_in_hd}     ${get_trangthai_gh_in_hd}   ${get_trangthai_thuhotien}

Get invoice code and total payment frm API
    [Arguments]    ${input_ma_kh}
    [Timeout]    5 mins
    ${jsonpath_id_khachhang}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_khachhang}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_khachhang}
    ${endpoint_lichsu_bantrahang}    Format String    ${endpoint_tab_lichsu_bantrahang}    ${get_id_khachhang}
    ${get_ma_hd}    Get data from API    ${endpoint_lichsu_bantrahang}    $.Data[0]..Code
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_id_hd}    Format String    $.Data[?(@.Code == '{0}')].Id    ${get_ma_hd}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_hd}
    ${endpoint_hd_detail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_khachthanhtoan_in_hd}    Get data from API    ${endpoint_hd_detail}    $.TotalPayment
    Return From Keyword    ${get_ma_hd}    ${get_khachthanhtoan_in_hd}

Get PTT invoice info
    [Arguments]    ${input_ma_hd}
    [Documentation]    1. Chọn hóa đơn 2.Click Tab lịch sử thanh toán 3. Get phiếu thanh toán hóa đơn
    [Timeout]    5 mins
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code =="{0}")].Id    ${input_ma_hd}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_hd}
    ${endpoint_phieu_tt_hd}    Format String    ${endpoint_phieu_thanhtoan_hd}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_phieu_tt_hd}
    ${get_ma_phieu_tt}    Get data from response json    ${get_resp}    $..Code
    ${get_phuongthuc_tt}    Get data from response json    ${get_resp}    $..Method
    ${get_trangthai_tt}    Get data from response json    ${get_resp}    $..Status
    ${get_tienthu_tt}    Get data from response json    ${get_resp}    $..Amount
    Return From Keyword    ${get_ma_phieu_tt}    ${get_phuongthuc_tt}    ${get_trangthai_tt}    ${get_tienthu_tt}

Create invoice with delivery
    [Arguments]    ${input_ma_kh}    ${input_ma_hang}    ${input_soluong}    ${input_trangthai_gh}    ${input_ma_dtgh}    ${phi_gh}
    ...    ${input_ngay_gh}    ${input_khtt}
    [Timeout]    5 mins
    Add new invoice no payment frm API    ${input_ma_kh}    ${input_ma_hang}    ${input_soluong}    ${input_trangthai_gh}    ${input_ma_dtgh}    ${phi_gh}
    ...    ${input_ngay_gh}    ${input_khtt}

Get list product frm Invoice API
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd }    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_hd}
    ${endpoint_invoicedetail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd }
    ${get_list_hh_in_order}    Get raw data from API    ${endpoint_invoicedetail}    $.InvoiceDetails..Code
    Return From Keyword    ${get_list_hh_in_order}

Get invoice info by invoice code
    [Arguments]    ${invoice_code}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $..CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $..Total
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}

Get invoice info incase discount by invoice code
    [Arguments]    ${invoice_code}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    Log    ${endpoint_hoadon_by_branch}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API   ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $.CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_giamgia_hd}    Get data from response json    ${get_resp}    $.Discount
    ${get_khachcantra}    Get data from response json    ${get_resp}    $.Total
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}

Assert values of Invoice
     [Arguments]     ${invoice_code}       ${input_invoice_discount}      ${result_tongtienhang}     ${result_khachcantra}      ${actual_khachtt}       ${input_bh_ma_kh}       ${result_discount_invoice}
     ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code    ${invoice_code}
     Run Keyword If    ${input_invoice_discount} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}     ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
     Run Keyword If    ${input_invoice_discount} == 0    Log    Ignore validate    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
     Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
     Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
     Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
     Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
     Should Be Equal As Strings    ${get_trangthai}    Hoàn thành

Assert Invoice until success
     [Arguments]     ${invoice_code}       ${input_invoice_discount}      ${result_tongtienhang}     ${result_khachcantra}      ${actual_khachtt}       ${input_bh_ma_kh}       ${result_discount_invoice}
     Wait Until Keyword Succeeds    5 times     3 s    Assert values of Invoice    ${invoice_code}       ${input_invoice_discount}      ${result_tongtienhang}     ${result_khachcantra}      ${actual_khachtt}       ${input_bh_ma_kh}       ${result_discount_invoice}

Get invoice info have note by invoice code
    [Arguments]    ${invoice_code}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_resp_hd}    Get Request and return body    ${endpoint_hoadon_by_branch}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${jsonpath_ghichu}    Format String    $..Data[?(@.Code == '{0}')].Description    ${invoice_code}
    ${get_invoice_id}    Get data from response json    ${get_resp_hd}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $..CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $..Total
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_khach_tt}    Convert To Number    ${get_khach_tt}    0
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    ${get_ghichu}    Get data from response json    ${get_resp_hd}    ${jsonpath_ghichu}
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu}

Get invoice info have note incase discount by invoice code
    [Arguments]    ${invoice_code}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_resp_hd}    Get Request and return body    ${endpoint_hoadon_by_branch}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${jsonpath_ghichu}    Format String    $..Data[?(@.Code == '{0}')].Description    ${invoice_code}
    ${get_invoice_id}    Get data from response json    ${get_resp_hd}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $.CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_khach_tt}    Convert To Number    ${get_khach_tt}    0
    ${get_giamgia_hd}    Get data from response json    ${get_resp}    $.Discount
    ${get_khachcantra}    Get data from response json    ${get_resp}    $.Total
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    ${get_ghichu}    Get data from response json    ${get_resp_hd}    ${jsonpath_ghichu}
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}
    ...    ${get_ghichu}

Get invoice info after allocate
    [Arguments]    ${invoice_code}    ${input_phieuthanhtoan}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_khach_tt}    Get data from API    ${endpoint_invoice_by_id}    $.TotalPayment
    ${endpoint_ptt_by_id}   Format String    ${endpoint_phieu_thanhtoan_hd}    ${get_invoice_id}
    ${jsonpath_ptt_pb}    Format String    $..Data[?(@.Code == "{0}")].PaidValue    ${input_phieuthanhtoan}
    ${get_ptt_pb}   Get data from API    ${endpoint_ptt_by_id}    ${jsonpath_ptt_pb}
    Return From Keyword    ${get_khach_tt}    ${get_ptt_pb}

Get invoice info with other branch and user
    [Arguments]    ${invoice_code}    ${input_ten_branch}   ${input_ten_user}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${get_branch_id}    Get BranchID by BranchName    ${input_ten_branch}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${get_branch_id}
    ${get_resp_hd}    Get Request and return body from API by BranchID and UserID    ${get_branch_id}    ${endpoint_hoadon_by_branch}    ${input_ten_user}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from response json    ${get_resp_hd}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body from API by BranchID and UserID    ${get_branch_id}    ${endpoint_invoice_by_id}    ${input_ten_user}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $.CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_khach_tt}    Convert To Number    ${get_khach_tt}    0
    ${get_giamgia_hd}    Get data from response json    ${get_resp}    $.Discount
    ${get_khachcantra}    Get data from response json    ${get_resp}    $.Total
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}

Get list quantity and gia tri quy doi by invoice code
    [Arguments]    ${list_product}    ${input_ma_hd}
    [Timeout]    5 mins
    ${list_soluong_in_hd}    Create List
    ${list_giatri_quydoi_in_hd}    Create List
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${input_ma_hd}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    : FOR    ${input_ma_hang}    IN    @{list_product}
    \    ${jsonpath_soluong}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}' )].Quantity    ${input_ma_hang}
    \    ${jsonpath_giatri_quydoi}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}' )]..ConversionValue    ${input_ma_hang}
    \    ${get_so_luong_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_soluong}
    \    ${get_giatri_quydoi_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_giatri_quydoi}
    \    Append To List    ${list_soluong_in_hd}    ${get_so_luong_in_hd}
    \    Append To List    ${list_giatri_quydoi_in_hd}    ${get_giatri_quydoi_in_hd}
    Return From Keyword    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}

Delete invoice by invoice code
    [Arguments]    ${invoice_code}
    [Timeout]    5 mins
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${invoice_code}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_hd}
    ${endpoint_delete_hd}    Format String    ${endpoint_delete_hd}    ${get_id_hd}    ${invoice_code}
    Delete request thr API    ${endpoint_delete_hd}

Delete list invoice by list code
    [Arguments]    ${order_code}
    [Timeout]    5 mins
    ${get_list_invoice_code}    Get list invoice code frm Order api    ${order_code}
    : FOR    ${item_code}    IN    @{get_list_invoice_code}
    \    Delete invoice by invoice code    ${item_code}


Delete invoice by invoice code and other branch
    [Arguments]    ${invoice_code}    ${inpute_ten_branch}
    [Timeout]    5 mins
    ${get_branch_id}    Get BranchID by BranchName    ${inpute_ten_branch}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${invoice_code}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${get_branch_id}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_hd}
    ${endpoint_delete_hd}    Format String    ${endpoint_delete_hd}    ${get_id_hd}    ${invoice_code}
    Delete request thr API    ${endpoint_delete_hd}

Get list product after create invoice
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${get_id_hd }    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_invoice_detail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd }
    ${get_resp}    Get Request and return body    ${endpoint_invoice_detail}
    ${get_list_hh_in_hd}    Get raw data from response json    ${get_resp}    $.InvoiceDetails..Code
    Return From Keyword    ${get_list_hh_in_hd}

Get status and customer payment to invoice
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_hd}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_trangthai_hd}    Get data from response json    ${get_resp}    $.Status
    ${get_khach_can_tra}    Get data from response json    ${get_resp}    $.Total
    Return From Keyword    ${get_trangthai_hd}    ${get_khach_can_tra}

Assert delivery info not time in invoice
    [Arguments]    ${input_ma_hd}    ${get_ten_kh_bf_execute}    ${get_dienthoai_kh_bf_execute}    ${get_diachi_kh_bf_execute}    ${get_khuvuc_kh_bf_execute}    ${get_phuongxa_kh_bf_execute}
    ...    ${input_ma_dtgh}    ${result_trongluong_gh}    ${input_phi_gh}
    [Timeout]    5 mins
    ${get_tennguoinhan_gh_af_execute}    ${get_dienthoai_gh_af_execute}    ${get_dia_chi_gh_af_execute}    ${get_khuvuc_gh_af_execute}    ${get_phuongxa_gh_af_execute}    ${get_nguoi_gh_af_execute}    ${get_ten_DTGH_af_execute}
    ...    ${get_trongluong_gh_af_execute}    ${get_phi_gh_af_execute}      ${get_trangthai_gh_af_execute}  ${get_trangthai_thuhotien}   Get delivery info frm invoice API
    ...    ${input_ma_hd}
    ${get_trangthai_hd}    ${get_khach_can_tra}    Get status and customer payment to invoice    ${input_ma_hd}
    Should Be Equal As Strings    ${get_tennguoinhan_gh_af_execute}    ${get_ten_kh_bf_execute}
    Should Be Equal As Numbers    ${get_dienthoai_gh_af_execute}    ${get_dienthoai_kh_bf_execute}
    Should Be Equal As Strings    ${get_dia_chi_gh_af_execute}    ${get_diachi_kh_bf_execute}
    Should Be Equal As Strings    ${get_khuvuc_gh_af_execute}    ${get_khuvuc_kh_bf_execute}
    Should Be Equal As Strings    ${get_phuongxa_gh_af_execute}    ${get_phuongxa_kh_bf_execute}
    Should Be Equal As Strings    ${get_nguoi_gh_af_execute}    ${input_ma_dtgh}
    Should Be Equal As Numbers    ${get_trongluong_gh_af_execute}    ${result_trongluong_gh}
    Should Be Equal As Numbers    ${get_phi_gh_af_execute}    ${input_phi_gh}
    Run Keyword If    '${get_trangthai_gh_af_execute}' == '1' or '${get_trangthai_gh_af_execute}' == '2'    Should Be Equal As Numbers    ${get_trangthai_hd}    3

Get delivery status frm Invoice
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${get_invoice_id}    Get invoice id    ${input_ma_hd}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp_hd}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_trangthai_gh_in_hd}    Get data from response json    ${get_resp_hd}    $.InvoiceDelivery..Status
    ${get_khach_can_tra}    Get data from response json    ${get_resp_hd}    $.Total
    Return From Keyword    ${get_trangthai_gh_in_hd}    ${get_khach_can_tra}

Get delivery info frm shipping api
    [Arguments]    ${input_mavandon}    ${input_ma_dtgh}
    ${endpoint_shipping}    Format String    ${input_mavandon}    ${input_ma_dtgh}
    ${get_resp_shipping}    Post Request and return body frm shipping api    ${endpoint_shipping}
    ${get_money_total}    Get data from response json    ${get_resp_shipping}    $..MONEY_TOTAL
    ${get_status}    Get data from response json    ${get_resp_shipping}    $..ORDER_STATUS
    ${get_tienthuho}    Get data from response json    ${get_resp_shipping}    $..MONEY_COLLECTION


Get invoice info by delivery invoice code
    [Arguments]    ${invoice_code}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon_giaohang}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_tong_tien_hang}    Get data from API    ${endpoint_invoice_by_id}    $..Total
    ${get_khach_tt}    Get data from API    ${endpoint_invoice_by_id}    $..PayingAmount
    Return From Keyword    ${get_tong_tien_hang}    ${get_khach_tt}

Get invoice info incase discount by delivery invoice code
    [Arguments]    ${invoice_code}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_giamgia_hd}    Get data from response json    ${get_resp}    $.Discount
    ${get_giamgia_hd}    Replace floating point    ${get_giamgia_hd}
    ${get_khachcantra}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_invoice_by_id}    $.Total
    Return From Keyword    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}

Get invoice info incase discount and haved payment by invoice code
    [Arguments]    ${invoice_code}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $.CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khach_tt}    Get data from response json    ${get_resp}    $..TotalPayment
    ${get_giamgia_hd}    Get data from response json    ${get_resp}    $.Discount
    ${get_khachcantra}    Get data from response json    ${get_resp}    $.Total
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}

Get PTT to invoice have deposit refund
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_hd}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_phieu_tt_hd}    Format String    ${endpoint_phieu_thanhtoan_hd}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_phieu_tt_hd}
    ${get_ma_phieu_tt}    Get data from response json    ${get_resp}    $..Code
    ${get_phuongthuc_tt}    Get data from response json    ${get_resp}    $..Method
    ${get_trangthai_tt}    Get data from response json    ${get_resp}    $..Status
    ${get_tienthu_tt_before}    Get data from response json    ${get_resp}    $..Amount
    ${get_tienthu_tt_before}    Convert To String    ${get_tienthu_tt_before}
    ${string_tienthu_tt}    Replace String    ${get_tienthu_tt_before}    -    ${EMPTY}
    ${get_tienthu_tt}    Convert To Number    ${string_tienthu_tt}
    Return From Keyword    ${get_ma_phieu_tt}    ${get_phuongthuc_tt}    ${get_trangthai_tt}    ${get_tienthu_tt}

Get list price after change pricebook frm invoice API
    [Arguments]    ${list_product}    ${input_ma_hd}
    [Timeout]    5 mins
    ${list_giaban}    Create List
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_invoice}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_invoice}
    : FOR    ${input_ma_hh}    IN    @{list_product}
    \    ${jsonpath_id_hh}    Format String    $..InvoiceDetails[?(@.Product.Code == '{0}')].ProductId    ${input_ma_hh}
    \    ${get_id_hh}    Get data from response json    ${get_resp}    ${jsonpath_id_hh}
    \    ${jsonpath_giaban}    Format String    $.InvoiceDetails[?(@.ProductId == {0})].Price    ${get_id_hh}
    \    ${get_giaban}    Get data from response json    ${get_resp}    ${jsonpath_giaban}
    \    Append To List    ${list_giaban}    ${get_giaban}
    Return From Keyword    ${list_giaban}

Get list product and quantity frm invoice API
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_invoicedetail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_invoicedetail}
    ${get_list_hh_in_hd}    Get raw data from response json    ${get_resp}    $.InvoiceDetails..Code
    ${get_list_sl_in_hd}    Get raw data from response json    ${get_resp}    $.InvoiceDetails..Quantity
    Return From Keyword    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}

Get list discount and quantity frm invoice api
    [Arguments]    ${input_ma_hd}    ${list_product}
    [Timeout]    5 mins
    ${list_ggsp}    Create List
    ${list_quantity_in_hd}    Create List
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_invoicedetail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_invoicedetail}
    : FOR    ${input_ma_hh}    IN    @{list_product}
    \    ${jsonpath_ggsp}    Format String    $.InvoiceDetails[?(@.Product.Code =='{0}')].Discount    ${input_ma_hh}
    \    ${jsonpath_ggsp_%}    Format String    $.InvoiceDetails[?(@.Product.Code =='{0}')].DiscountRatio    ${input_ma_hh}
    \    ${jsonpath_quantity_hh}    Format String    $.InvoiceDetails[?(@.Product.Code =='{0}')].Quantity    ${input_ma_hh}
    \    ${get_ggsp}    Get data from response json    ${get_resp}    ${jsonpath_ggsp}
    \    ${get_ggsp_%}    Get data from response json    ${get_resp}    ${jsonpath_ggsp_%}
    \    ${get_ggsp}    Set Variable If    0 < ${get_ggsp_%} < 100    ${get_ggsp_%}    ${get_ggsp}
    \    ${get_quantity}    Get data from response json    ${get_resp}    ${jsonpath_quantity_hh}
    \    Append To List    ${list_ggsp}    ${get_ggsp}
    \    Append To List    ${list_quantity_in_hd}    ${get_quantity}
    Return From Keyword    ${list_ggsp}    ${list_quantity_in_hd}

Get list discount by product code
    [Arguments]    ${input_ma_hd}    ${list_product}
    [Timeout]    5 mins
    ${list_ggsp}    Create List
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_invoicedetail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_invoicedetail}
    : FOR    ${input_ma_hh}    IN    @{list_product}
    \    ${jsonpath_ggsp}    Format String    $.InvoiceDetails[?(@.Product.Code =='{0}')].Discount    ${input_ma_hh}
    \    ${jsonpath_ggsp_%}    Format String    $.InvoiceDetails[?(@.Product.Code =='{0}')].DiscountRatio    ${input_ma_hh}
    \    ${get_ggsp}    Get data from response json    ${get_resp}    ${jsonpath_ggsp}
    \    ${get_ggsp_%}    Get data from response json    ${get_resp}    ${jsonpath_ggsp_%}
    \    ${get_ggsp}    Set Variable If    0 < ${get_ggsp_%} < 100    ${get_ggsp_%}    ${get_ggsp}
    \    Append To List    ${list_ggsp}    ${get_ggsp}
    Return From Keyword    ${list_ggsp}

Get list newprice by product code
    [Arguments]    ${input_ma_hd}    ${input_ma_hh}    ${list_newprice}
    [Timeout]    5 mins
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_invoicedetail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_invoicedetail}
    ${jsonpath_newprice}    Format String    $.InvoiceDetails[?(@.Product.Code =='{0}')].Price    ${input_ma_hh}
    ${jsonpath_discount}    Format String    $.InvoiceDetails[?(@.Product.Code =='{0}')].Discount    ${input_ma_hh}
    ${get_newprice}    Get data from response json    ${get_resp}    ${jsonpath_newprice}
    ${get_discount}    Get data from response json    ${get_resp}    ${jsonpath_discount}
    ${result_giamoi}    Minus and round 2    ${get_newprice}    ${get_discount}
    Append To List    ${list_newprice}    ${result_giamoi}
    Return From Keyword    ${list_newprice}

Get additional invoice info by additional invoice code
    [Arguments]    ${invoice_code}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $.CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $..Total
    ${get_khachcantra}    Get data from response json    ${get_resp}    $.NewInvoiceTotal
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachcantra}    ${get_khach_tt}    ${get_trangthai}

Get additional invoice info incase discount by additional invoice code
    [Arguments]    ${invoice_code}
    [Documentation]    Thông tin của hóa đơn đầu tiên:
    ...    Mã hóa đơn_top
    ...    Tên Khách hàng
    ...    Mã sản phẩm trả
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_ma_kh_by_hd}    Get data from response json    ${get_resp}    $.CustomerCode
    ${get_tong_tien_hang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khach_tt}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_giamgia_hd}    Get data from response json    ${get_resp}    $.Discount
    ${get_khachcantra}    Get data from response json    ${get_resp}    $.NewInvoiceTotal
    ${get_trangthai}    Get data from response json    ${get_resp}    $.StatusValue
    Return From Keyword    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}

Get list quantity and gia tri quy doi frm additional invoice code
    [Arguments]    ${list_product}    ${input_ma_dth}
    [Timeout]    5 mins
    ${list_soluong_in_hd}    Create List
    ${list_giatriquydoi_in_hd}    Create List
    ${jsonpath_id_dth}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dth}
    ${endpoint_hd}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_dth }    Get data from API    ${endpoint_hd}    ${jsonpath_id_dth}
    ${endpoint_hoadon_detail}    Format String    ${endpoint_invoice_detail}    ${get_id_dth }
    ${get_resp}    Get Request and return body    ${endpoint_hoadon_detail}
    : FOR    ${item_ma_hang}    IN    @{list_product}
    \    ${jsonpath_soluong}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')].Quantity    ${item_ma_hang}
    \    ${jsonpath_giatri_quydoi}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')]..ConversionValue    ${item_ma_hang}
    \    ${get_so_luong_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_soluong}
    \    ${get_giatri_quydoi_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_giatri_quydoi}
    \    Append To list    ${list_soluong_in_hd}    ${get_so_luong_in_hd}
    \    Append To list    ${list_giatriquydoi_in_hd}    ${get_giatri_quydoi_in_hd}
    Return From Keyword    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}

Get invoice id
    [Arguments]    ${invoice_code}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${invoice_code}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_hd}
    Return From Keyword    ${get_id_hd}

Get invoice detail id
    [Arguments]    ${invoice_code}
    ${get_invoice_id}    Get invoice id    ${invoice_code}
    ${endpoint_chi_tiet_hd}    Format String    ${endpoint_hd_contains_product_info}    ${get_invoice_id}
    ${jsonpath_invoice_detail_id}    Format String    $..Data[?(@.InvoiceId== {0})].Id    ${get_invoice_id}
    ${get_invoice_detail_id}    Get data from API    ${endpoint_chi_tiet_hd}    ${jsonpath_invoice_detail_id}
    Return From Keyword    ${get_invoice_detail_id}

Get list invoicedetail id frm invoice api
    [Arguments]    ${invoice_code}    ${list_product}
    [Timeout]    3 minutes
    ${get_invoice_id}    Get invoice id    ${invoice_code}
    ${endpoint_chi_tiet_hd}    Format String    ${endpoint_hd_contains_product_info}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_chi_tiet_hd}
    ${list_invoice_detail_id}    Create List
    : FOR    ${item_product}    IN    @{list_product}
    \    ${jsonpath_id_orderdetail}    Format String    $.InvoiceDetails[?(@.Product.Code == '{0}')].Id    ${item_product}
    \    ${get_id_invoicedetail}    Get data from response json    ${get_resp}    ${jsonpath_id_orderdetail}
    \    Append to list    ${list_invoice_detail_id}    ${get_id_invoicedetail}
    Return From Keyword    ${list_invoice_detail_id}

Get list imei by product code in invoice
    [Arguments]    ${ma_hd}    ${list_product}
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${endpoint_chitiet_hd}    Format String    ${endpoint_hd_contains_product_info}    ${get_invoice_id}
    ${resp}    Get Request and return body    ${endpoint_chitiet_hd}
    ${get_list_pr_id}    Get list product id thr API    ${list_product}
    ${list_imei}    Create List
    : FOR    ${item_pr}    IN ZIP    ${get_list_pr_id}
    \    ${jsonpath_serail}    Format String    $.Data[?(@.ProductId=={0})].SerialNumbers    ${item_pr}
    \    ${get_serial}    Get raw data from response json    ${resp}    ${jsonpath_serail}
    \    Append To List    ${list_imei}    ${get_serial}
    Log    ${list_imei}
    Return From Keyword    ${list_imei}

Get sale channel id thr API
    [Arguments]    ${ten_kenh}
    ${jsonpath_id_kenh}    Format String    $..Data[?(@.Name == '{0}')].Id    ${ten_kenh}
    ${get_id_kenh}    Get data from API    ${endpoint_kenhbanhang}    ${jsonpath_id_kenh}
    Return From Keyword    ${get_id_kenh}

Create json for Invoice Details
     [Arguments]         ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
     ${liststring_prs_invoice_detail}     Set Variable      needdel
     : FOR    ${item_product_id}      ${item_product_type}       ${item_price}       ${item_num}        ${item_discount_value}       ${item_result_discountproduct}        ${item_discount_type}      ${item_imei}       IN ZIP       ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
     \    ${item_result_discountproduct}=        Run Keyword If     '${item_discount_type}' == 'none'    Set Variable      null       ELSE IF     '${item_discount_type}' == 'changedown'      Minus     0       ${item_result_discountproduct}     ELSE     Set Variable    ${item_result_discountproduct}
     \    ${item_discount_ratio}=       Run Keyword If    '${item_discount_type}' == 'dis'     Set Variable       ${item_discount_value}        ELSE      Set Variable      null
     \    ${item_imei}=      Run Keyword If    '${item_product_type}' == 'imei'       Set Variable    ${item_imei}      ELSE      Set Variable     ${EMPTY}
     \    ${item_imei_string}       Convert List to String    ${item_imei}
     \    ${payload_each_product}        Format string       {{"BasePrice":150000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{1},"ProductId":{0},"Quantity":{2},"ProductCode":"Combo30","SerialNumbers":"{5}","Discount":{3},"DiscountRatio":{4},"ProductName":"Set nước hoa Vial 06","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":795902,"Unit":"","Uuid":"","ProductWarranty":[]}}       ${item_product_id}      ${item_price}       ${item_num}       ${item_result_discountproduct}         ${item_discount_ratio}        ${item_imei_string}
     \    Log        ${payload_each_product}
     \    ${liststring_prs_invoice_detail}       Catenate      SEPARATOR=,      ${liststring_prs_invoice_detail}      ${payload_each_product}
     ${liststring_prs_invoice_detail}       Replace String      ${liststring_prs_invoice_detail}       needdel,       ${EMPTY}      count=1
     Log       ${liststring_prs_invoice_detail}
     Return From Keyword      ${liststring_prs_invoice_detail}

Create json in case promotion for Invoice Details
    [Arguments]         ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}      ${list_promotion_id}
    ${liststring_prs_invoice_detail}     Set Variable      needdel
    : FOR    ${item_product_id}      ${item_product_type}       ${item_price}       ${item_num}        ${item_discount_value}       ${item_result_discountproduct}        ${item_discount_type}      ${item_imei}       ${item_promotion_id}     IN ZIP       ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}        ${list_promotion_id}
    \    ${item_result_discountproduct}=        Run Keyword If     '${item_discount_type}' == 'none'    Set Variable      null       ELSE IF     '${item_discount_type}' == 'changedown'      Minus     0       ${item_result_discountproduct}     ELSE     Set Variable    ${item_result_discountproduct}
    \    ${item_discount_ratio}=       Run Keyword If    '${item_discount_type}' == 'dis'     Set Variable       ${item_discount_value}        ELSE      Set Variable      null
    \    ${item_imei}=      Run Keyword If    '${item_product_type}' == 'imei'       Set Variable    ${item_imei}      ELSE      Set Variable     ${EMPTY}
    \    ${item_imei_string}       Convert List to String    ${item_imei}
    \    ${payload_each_product}        Format string       {{"BasePrice":150000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{1},"ProductId":{0},"Quantity":{2},"ProductCode":"Combo30","SerialNumbers":"{5}","Discount":{3},"DiscountRatio":{4},"ProductName":"Set nước hoa Vial 06","SalePromotionId":{6},"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":795902,"Unit":"","Uuid":"","ProductWarranty":[]}}       ${item_product_id}      ${item_price}       ${item_num}       ${item_result_discountproduct}         ${item_discount_ratio}        ${item_imei_string}      ${item_promotion_id}
    \    Log        ${payload_each_product}
    \    ${liststring_prs_invoice_detail}       Catenate      SEPARATOR=,      ${liststring_prs_invoice_detail}      ${payload_each_product}
    ${liststring_prs_invoice_detail}       Replace String      ${liststring_prs_invoice_detail}       needdel,       ${EMPTY}      count=1
    Log       ${liststring_prs_invoice_detail}
    Return From Keyword      ${liststring_prs_invoice_detail}

Create json for Invoice Details in case multi-lines
      [Arguments]         ${list_product_id}       ${list_product_type}      ${list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
      ${liststring_prs_invoice_detail}     Set Variable      needdel
      : FOR    ${item_product_id}      ${item_product_type}       ${item_price}       ${item_list_num}        ${item_list_discount_value}       ${item_list_result_discountproduct}        ${item_list_discount_type}      ${item_list_imei}       IN ZIP       ${list_product_id}       ${list_product_type}      ${list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
      \    ${liststring_eachproduct_incl_mullines}       Create json for each product in Invoice Details in case multi-lines     ${item_product_id}      ${item_product_type}       ${item_price}       ${item_list_num}        ${item_list_discount_value}       ${item_list_result_discountproduct}        ${item_list_discount_type}      ${item_list_imei}
      \    ${liststring_prs_invoice_detail}       Catenate      SEPARATOR=,      ${liststring_prs_invoice_detail}      ${liststring_eachproduct_incl_mullines}
      ${liststring_prs_invoice_detail}       Replace String      ${liststring_prs_invoice_detail}       needdel,       ${EMPTY}      count=1
      Log       ${liststring_prs_invoice_detail}
      Return From Keyword      ${liststring_prs_invoice_detail}

Create json for each product in Invoice Details in case multi-lines
       [Arguments]         ${product_id}       ${product_type}      ${baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei}
       ${liststring_eachproduct_incl_mullines}     Set Variable      needdel
       : FOR    ${item_num}        ${item_discount_value}       ${item_result_discountproduct}        ${item_discount_type}      ${item_imei}       IN ZIP       ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei}
       \    ${item_result_discountproduct}=        Run Keyword If     '${product_type}' == 'none'    Set Variable      null       ELSE IF     '${item_discount_type}' == 'changedown'      Minus     0       ${item_result_discountproduct}     ELSE     Set Variable    ${item_result_discountproduct}
       \    ${item_discount_ratio}=       Run Keyword If    '${item_discount_type}' == 'dis'     Set Variable       ${item_discount_value}        ELSE      Set Variable      null
       \    ${item_imei}=      Run Keyword If    '${product_type}' == 'imei'       Set Variable    ${item_imei}      ELSE      Set Variable     ${EMPTY}
       \    ${item_imei_string}       Convert List to String    ${item_imei}
       \    ${payload_each_product}        Format string       {{"BasePrice":150000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{1},"ProductId":{0},"Quantity":{2},"ProductCode":"Combo30","SerialNumbers":"{5}","Discount":{3},"DiscountRatio":{4},"ProductName":"Set nước hoa Vial 06","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":795902,"Unit":"","Uuid":"","ProductWarranty":[]}}       ${product_id}      ${baseprice}       ${item_num}       ${item_result_discountproduct}         ${item_discount_ratio}        ${item_imei_string}
       \    Log        ${payload_each_product}
       \    ${liststring_eachproduct_incl_mullines}       Catenate      SEPARATOR=,      ${liststring_eachproduct_incl_mullines}      ${payload_each_product}
       ${liststring_eachproduct_incl_mullines}       Replace String      ${liststring_eachproduct_incl_mullines}       needdel,       ${EMPTY}      count=1
       Log       ${liststring_eachproduct_incl_mullines}
       Return From Keyword      ${liststring_eachproduct_incl_mullines}

Get du no hoa don thr API
   [Arguments]    ${invoice_code}
   [Timeout]    5 mins
   ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
   ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${invoice_code}
   ${get_invoice_id}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
   ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
   ${get_khach_can_tra}    Get data from API    ${endpoint_invoice_by_id}    $.Total
   ${get_khachtt}    Get data from API    ${endpoint_invoice_by_id}    $.TotalPayment
   ${result_no_hd}     Minus    ${get_khach_can_tra}    ${get_khachtt}
   Return From Keyword    ${result_no_hd}

Get receipt number - method - amount in tab Lich su thanh toan hoa don thr API
    [Arguments]    ${input_ma_hd}
    [Timeout]    5 mins
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code =="{0}")].Id    ${input_ma_hd}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_hd}
    ${endpoint_phieu_tt_hd}    Format String    ${endpoint_phieu_thanhtoan_hd}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_phieu_tt_hd}
    ${get_ma_phieu_tt}    Get raw data from response json        ${get_resp}    $..Code
    ${get_phuongthuc_tt}    Get raw data from response json    ${get_resp}    $..Method
    ${get_tienthu_tt}    Get raw data from response json    ${get_resp}    $..Amount
    Return From Keyword    ${get_ma_phieu_tt}    ${get_phuongthuc_tt}    ${get_tienthu_tt}

Get paid value from invoice api
    [Arguments]    ${invoice_code}
    [Timeout]    5 mins
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")]..Id    ${invoice_code}
    ${get_invoice_id}    Get data from API    ${endpoint_hoadon}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_khach_can_tra}    Get data from API    ${endpoint_invoice_by_id}    $.Total
    ${get_khachtt}    Get data from API    ${endpoint_invoice_by_id}    $.TotalPayment
    Return From Keyword    ${get_khach_can_tra}    ${get_khachtt}

Get seller name from invoice code
    [Arguments]    ${invoice_code}
    [Documentation]    Tên người bán
    [Timeout]    5 mins
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${get_invoice_id}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_nguoi_ban}    Get data from response json    ${get_resp}    $.SoldBy.GivenName
    Return From Keyword    ${get_nguoi_ban}

Get guarranty info frm invoice API
    [Arguments]    ${input_inv_id}    ${input_product_id}
    ${endpoint_warranty_detail}    Format String     ${endpoint_warranty_detail_in_invoice}    ${input_inv_id}    ${input_product_id}
    ${resp}   Get Request and return body    ${endpoint_warranty_detail}
    ${get_time_bh_in_order}    Get raw data from response json    ${resp}    $..Data[?(@.WarrantyType==1)].NumberTime
    ${get_timetype_bh_in_order}    Get raw data from response json    ${resp}    $..Data[?(@.WarrantyType==1)].TimeType
    ${get_time_bt_in_order}    Get data from response json    ${resp}    $..Data[?(@.WarrantyType==3)].NumberTime
    ${get_timetype_bt_in_order}    Get data from response json    ${resp}    $..Data[?(@.WarrantyType==3)].TimeType
    ${get_time_bh_in_order}   Remove Duplicates    ${get_time_bh_in_order}
    ${get_timetype_bh_in_order}   Remove Duplicates    ${get_timetype_bh_in_order}
    Return From Keyword    ${get_time_bh_in_order}    ${get_timetype_bh_in_order}    ${get_time_bt_in_order}    ${get_timetype_bt_in_order}

Get guarranty imei info frm invoice API
    [Arguments]    ${input_inv_id}    ${input_product_id}
    ${endpoint_warranty_detail}    Format String     ${endpoint_warranty_detail_in_invoice}    ${input_inv_id}    ${input_product_id}
    ${resp}   Get Request and return body    ${endpoint_warranty_detail}
    ${get_time_bh_in_order}    Get raw data from response json    ${resp}    $..Data[?(@.WarrantyType==1)].NumberTime
    ${get_timetype_bh_in_order}    Get raw data from response json    ${resp}    $..Data[?(@.WarrantyType==1)].TimeType
    ${get_time_bt_in_order}    Get data from response json    ${resp}    $..Data[?(@.WarrantyType==3)].NumberTime
    ${get_timetype_bt_in_order}    Get data from response json    ${resp}    $..Data[?(@.WarrantyType==3)].TimeType
    Return From Keyword    ${get_time_bh_in_order}    ${get_timetype_bh_in_order}    ${get_time_bt_in_order}    ${get_timetype_bt_in_order}

Get list guarranty info frm invoice API
    [Arguments]    ${input_inv_code}    ${list_product}
    ${list_time_bh_in_order}   Create List
    ${list_timetype_bh_order}   Create List
    ${list_time_bt_in_order}   Create List
    ${list_timetype_bt_in_order}   Create List
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_id_inv}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_inv_code}
    ${get_id_inv}    Get data from API    ${endpoint_hoadon_by_branch}    ${jsonpath_id_inv}
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    :FOR    ${product_id}   IN      @{get_list_product_id}
    \    ${get_time_bh_in_order}    ${get_timetype_bh_in_order}    ${get_time_bt_in_order}    ${get_timetype_bt_in_order}   Get guarranty info frm invoice API
    \    ...    ${get_id_inv}    ${product_id}
    \    Append To List     ${list_time_bh_in_order}    ${get_time_bh_in_order}
    \    Append To List     ${list_timetype_bh_order}    ${get_timetype_bh_in_order}
    \    Append To List     ${list_time_bt_in_order}    ${get_time_bt_in_order}
    \    Append To List     ${list_timetype_bt_in_order}    ${get_timetype_bt_in_order}
    Return From Keyword     ${list_time_bh_in_order}     ${list_timetype_bh_order}     ${list_time_bt_in_order}     ${list_timetype_bt_in_order}

Get invoice code frm api
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_invoice_code}    Get data from API    ${endpoint_hoadon_by_branch}    $.Data[1]..Code
    Return From Keyword    ${get_invoice_code}

Get price book in invoice detail
    [Arguments]    ${input_ma_hd}
    [Timeout]    3 minutes
    ${get_id_hd}      Get invoice id    ${input_ma_hd}
    ${endpoint_invoice_detail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}     Get Request and return body    ${endpoint_invoice_detail}
    ${get_ten_banggia}    Get data from response json       ${get_resp}    $.PriceBook..Name
    Return From Keyword    ${get_ten_banggia}

Assert price book in invoice detail
    [Arguments]   ${invoice_code}    ${input_bang_gia}
    ${get_ten_banggia}      Get price book in invoice detail    ${invoice_code}
    Should Be Equal As Strings    ${get_ten_banggia}    ${input_bang_gia}

Get list invoice by current date
    [Timeout]    3 minutes
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${endpoint_invoice}    Format String    ${endpoint_list_invoice_currentdate}    ${BRANCH_ID}    ${date_current}
    ${endpoint_summary_invoice}   Format String    ${endpoint_summary_inv_currentdate}    ${BRANCH_ID}    ${date_current}
    ${get_list_invoice}    Get raw data from API    ${endpoint_invoice}    $.Data..Code
    ${get_summary_invoice}    Get data from API    ${endpoint_summary_invoice}    $.Total1Value
    Return From Keyword    ${get_list_invoice}    ${get_summary_invoice}

Get Thong tin don thuoc from invoice code
    [Arguments]    ${invoice_code}
    ${resp}   Get Request and return body    ${endpoint_hoadon_nhathuoc}
    ${jsonpath_madonthuoc}      Format String    $..Data[?(@.Code=='{0}')].Prescription.Code    ${invoice_code}
    ${jsonpath_bskd}      Format String    $..Data[?(@.Code=='{0}')].Prescription.Doctor.Name    ${invoice_code}
    ${jsonpath_cskb}      Format String    $..Data[?(@.Code=='{0}')].Prescription.Clinic.Name    ${invoice_code}
    ${jsonpath_tenbn}      Format String    $..Data[?(@.Code=='{0}')].Patient.Name   ${invoice_code}
    ${jsonpath_tuoibn}      Format String    $..Data[?(@.Code=='{0}')].Patient.Age    ${invoice_code}
    ${jsonpath_gioitinh}      Format String    $..Data[?(@.Code=='{0}')].Patient.Gender    ${invoice_code}
    ${jsonpath_cannang}      Format String    $..Data[?(@.Code=='{0}')].Patient.Weight    ${invoice_code}
    ${jsonpath_cmt}      Format String    $..Data[?(@.Code=='{0}')].Patient.IdentityCard    ${invoice_code}
    ${jsonpath_bhyt}      Format String    $..Data[?(@.Code=='{0}')].Patient.HealthInsuranceCard    ${invoice_code}
    ${jsonpath_diachi}      Format String    $..Data[?(@.Code=='{0}')].Patient.Address     ${invoice_code}
    ${jsonpath_nguoigiamho}      Format String    $..Data[?(@.Code=='{0}')].Patient.Guardian    ${invoice_code}
    ${jsonpath_sdt}      Format String    $..Data[?(@.Code=='{0}')].Patient.PhoneNumber    ${invoice_code}
    ${jsonpath_chandoan}      Format String    $..Data[?(@.Code=='{0}')].Prescription.Description    ${invoice_code}
    ${get_madonthuoc}    Get data from response json    ${resp}    ${jsonpath_madonthuoc}
    ${get_bskd}    Get data from response json    ${resp}    ${jsonpath_bskd}
    ${get_cskb}    Get data from response json    ${resp}    ${jsonpath_cskb}
    ${get_tenbn}    Get data from response json    ${resp}    ${jsonpath_tenbn}
    ${get_tuoibn}    Get data from response json    ${resp}    ${jsonpath_tuoibn}
    ${get_gioitinh}    Get data from response json and return false value    ${resp}    ${jsonpath_gioitinh}
    ${get_cannang}    Get data from response json    ${resp}    ${jsonpath_cannang}
    ${get_cmt}    Get data from response json    ${resp}    ${jsonpath_cmt}
    ${get_bhyt}    Get data from response json    ${resp}    ${jsonpath_bhyt}
    ${get_diachi}    Get data from response json    ${resp}    ${jsonpath_diachi}
    ${get_nguoigiamho}    Get data from response json    ${resp}    ${jsonpath_nguoigiamho}
    ${get_sdt}    Get data from response json    ${resp}    ${jsonpath_sdt}
    ${get_chandoan}    Get data from response json    ${resp}    ${jsonpath_chandoan}
    Return From Keyword    ${get_madonthuoc}    ${get_bskd}    ${get_cskb}    ${get_tenbn}    ${get_tuoibn}   ${get_gioitinh}     ${get_cannang}      ${get_cmt}      ${get_bhyt}   ${get_diachi}   ${get_nguoigiamho}    ${get_sdt}    ${get_chandoan}

Assert infor invoice incase combine invoice
    [Arguments]   ${invoice_code}   ${invoice_code_1}     ${invoice_combine}    ${input_ma_dtgh}      ${message}
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_resp_hd}    Get Request and return body    ${endpoint_hoadon_by_branch}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${invoice_code}
    ${jsonpath_invoice_id_1}    Format String    $..Data[?(@.Code == '{0}')].Id    ${invoice_code_1}
    ${jsonpath_hd_gop_id}    Format String    $..Data[?(@.Code == '{0}')].Id    ${invoice_combine}
    ${get_invoice_id}    Get data from response json    ${get_resp_hd}    ${jsonpath_invoice_id}
    ${get_invoice_id_1}    Get data from response json    ${get_resp_hd}    ${jsonpath_invoice_id_1}
    ${get_hd_gop_id}    Get data from response json    ${get_resp_hd}    ${jsonpath_hd_gop_id}
    ${endpoint_invoice}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_trangthai_hd}    Get data from API    ${endpoint_invoice}    $.StatusValue
    ${endpoint_invoice_1}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id_1}
    ${get_trangthai_hd_1}    Get data from API    ${endpoint_invoice_1}    $.StatusValue
    ${endpoint_hd_gop}    Format String    ${endpoint_invoice_detail}    ${get_hd_gop_id}
    ${get_ghi_chu}    Get data from API    ${endpoint_hd_gop}    $.Description
    ${get_ma_dtgh}      Get data from API    ${endpoint_hd_gop}    $..DeliveryInfo.PartnerCode
    Should Be Equal As Strings    ${get_ma_dtgh}    ${input_ma_dtgh}
    Should Be Equal As Strings    ${get_trangthai_hd}    Đã hủy
    Should Be Equal As Strings    ${get_trangthai_hd_1}    Đã hủy
    Should Be Equal As Strings    ${get_ghi_chu}    ${message}

Assert invoice exist succeed
    [Arguments]    ${invoice_code}
    ${get_id_hd}    Get invoice id    ${invoice_code}
    Should Not Be Equal As Numbers    ${get_id_hd}     0

Get invoice omni id
    [Arguments]    ${invoice_code}
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code=='{0}')].Id    ${invoice_code}
    ${get_id_hd}    Get data from API    ${endpoint_invoice_omni}    ${jsonpath_id_hd}
    Return From Keyword    ${get_id_hd}

Assert invoice omni succeed
    [Arguments]    ${invoice_code}
    ${get_id_hd}     Get invoice omni id   ${invoice_code}
    Should Not Be Equal As Strings       ${get_id_hd}     0

Assert values by invoice code
    [Arguments]     ${ma_hd_kv}   ${input_khachcantra}      ${input_tongtienhang}     ${input_makh}    ${input_khtt}      ${input_gghd}      ${input_trangthai}
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${ma_hd_kv}
    Should Be Equal As Numbers    ${get_khachcantra}    ${input_khachcantra}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${input_tongtienhang}
    Should Be Equal As Numbers    ${get_khach_tt}    ${input_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_makh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    ${input_trangthai}

Assert values by invoice code until succeed
    [Arguments]     ${ma_hd_kv}   ${input_khachcantra}      ${input_tongtienhang}     ${input_makh}    ${input_khtt}      ${input_gghd}      ${input_trangthai}
    Wait Until Keyword Succeeds    5x     3s      Assert values by invoice code    ${ma_hd_kv}   ${input_khachcantra}      ${input_tongtienhang}     ${input_makh}    ${input_khtt}      ${input_gghd}      ${input_trangthai}

Assert delivery info by invoice code
    [Arguments]     ${ma_hd_kv}       ${input_dtgh}     ${input_ten_kh}     ${input_sdt}      ${input_diachi}     ${input_khuvuc}     ${input_phuongxa}     ${input_trangthai_gh}     ${input_trangthai_thuho}
    ${get_tennguoinhan_gh_in_hd}    ${get_dienthoai_gh_in_hd}    ${get_dia_chi_gh_in_hd}    ${get_khuvuc_gh_in_hd}    ${get_phuongxa_gh_in_hd}    ${get_nguoi_gh_in_hd}
    ...    ${get_ten_DTGH_in_hd}      ${get_trongluong_gh_in_hd}    ${get_phi_gh_in_hd}     ${get_trangthai_gh_in_hd}   ${get_trangthai_thuhotien}   Get delivery info frm invoice API    ${ma_hd_kv}
    Should Be Equal As Strings    ${get_ten_DTGH_in_hd}    ${input_dtgh}
    Should Be Equal As Strings    ${get_tennguoinhan_gh_in_hd}    ${input_ten_kh}
    Run Keyword If    '${input_sdt}'=='none'     Should Be Equal As Strings    ${get_dienthoai_gh_in_hd}   0       ELSE      Should Be Equal As Strings    ${get_dienthoai_gh_in_hd}    ${input_sdt}
    Should Be Equal As Strings    ${get_dia_chi_gh_in_hd}     ${input_diachi}
    Should Be Equal As Strings    ${get_khuvuc_gh_in_hd}    ${input_khuvuc}
    Should Be Equal As Strings    ${get_phuongxa_gh_in_hd}    ${input_phuongxa}
    Should Be Equal As Strings    ${get_trangthai_gh_in_hd}     ${input_trangthai_gh}
    Should Be Equal As Strings    ${get_trangthai_thuhotien}     ${input_trangthai_thuho}

Assert delivery info by invoice code until succeed
    [Arguments]     ${ma_hd_kv}       ${input_dtgh}     ${input_ten_kh}     ${input_sdt}      ${input_diachi}     ${input_khuvuc}     ${input_phuongxa}     ${input_trangthai_gh}     ${input_trangthai_thuho}
    Wait Until Keyword Succeeds    10x     12s      Assert delivery info by invoice code      ${ma_hd_kv}       ${input_dtgh}     ${input_ten_kh}     ${input_sdt}      ${input_diachi}     ${input_khuvuc}     ${input_phuongxa}     ${input_trangthai_gh}     ${input_trangthai_thuho}

Assert invoice info after execute
    [Arguments]    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_khachcantra}    ${actual_khtt}    ${result_discount_invoice}
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành

Assert customer debit amount and general ledger after invoice execute
    [Arguments]    ${invoice_code}    ${input_khtt}    ${input_ma_kh}    ${result_nohientai}    ${result_tongban}     ${actual_khachtt}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_khtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${invoice_code}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_khachtt}

Post list invoice by invoice code thr API
    [Arguments]     ${invoice_code}
    [Timeout]    3 minutes
    ${filter_for_orm}     Set Variable    {"Code":"${invoice_code}","Description":"","DescriptionProduct":"","BranchIds":[${BRANCH_ID}],"PriceBookIds":[],"FromDate":null,"ToDate":null,"TimeRange":"month","InvoiceStatus":["3","1"],"UsingCod":[],"TableIds":[],"SalechannelIds":[],"StartDeliveryDate":null,"EndDeliveryDate":null,"UsingPrescription":2,"Prescription":"","Patient":"","Diagnosis":""}
    ${filter}   Set Variable      (substringof('${invoice_code}',Code) and BranchId eq ${BRANCH_ID} and PurchaseDate eq 'month' and (Status eq 3 or Status eq 1))
    ${payload}    Create Dictionary     $top=10         FiltersForOrm=${filter_for_orm}     $filter=${filter}
    Log    ${payload}
    ${resp}   Post request thr API    ${endpoint_list_invoice}    ${payload}
    Return From Keyword    ${resp}

Get invoice summary infor by invoice code thr API
    [Arguments]     ${invoice_code}
    ${resp}     Post list invoice by invoice code thr API    ${invoice_code}
    ${get_ma_kh}      Get data from response json    ${resp}    $.Data[?(@.Code=='${invoice_code}')].Customer.Code
    ${get_tongtienhang}      Get data from response json    ${resp}    $.Data[?(@.Code=='${invoice_code}')].SubTotal
    ${get_giamgia_hd}      Get data from response json    ${resp}    $.Data[?(@.Code=='${invoice_code}')].Discount
    ${get_khachcantra}      Get data from response json    ${resp}    $.Data[?(@.Code=='${invoice_code}')].NewInvoiceTotal
    ${get_khachdatra}      Get data from response json    ${resp}    $.Data[?(@.Code=='${invoice_code}')].TotalPayment
    ${get_trangthai_hd}      Get data from response json    ${resp}    $.Data[?(@.Code=='${invoice_code}')].StatusValue
    Return From Keyword    ${get_ma_kh}     ${get_tongtienhang}   ${get_giamgia_hd}   ${get_khachcantra}    ${get_khachdatra}      ${get_trangthai_hd}

Assert invoice summary values after excute
    [Arguments]     ${invoice_code}      ${input_ma_kh}    ${input_tongtienhang}   ${input_giamgia_hd}     ${input_khachcantra}    ${input_khachdatra}   ${input_trangthai_hd}
    ${get_ma_kh}     ${get_tongtienhang}   ${get_giamgia_hd}   ${get_khachcantra}    ${get_khachdatra}      ${get_trangthai_hd}     Get invoice summary infor by invoice code thr API    ${invoice_code}
    Should Be Equal As Strings    ${input_ma_kh}    ${get_ma_kh}
    Should Be Equal As Numbers    ${input_tongtienhang}    ${get_tongtienhang}
    Should Be Equal As Numbers    ${input_giamgia_hd}    ${get_giamgia_hd}
    Should Be Equal As Numbers    ${input_khachcantra}    ${get_khachcantra}
    Should Be Equal As Numbers    ${input_khachdatra}    ${get_khachdatra}
    Should Be Equal As Strings    ${input_trangthai_hd}    ${get_trangthai_hd}

Assert invoice summary values until succeed
    [Arguments]     ${invoice_code}      ${input_ma_kh}    ${input_tongtienhang}   ${input_giamgia_hd}     ${input_khachcantra}    ${input_khachdatra}   ${input_trangthai_hd}
    Wait Until Keyword Succeeds    3x    3x    Assert invoice summary values after excute    ${invoice_code}      ${input_ma_kh}    ${input_tongtienhang}   ${input_giamgia_hd}     ${input_khachcantra}    ${input_khachdatra}   ${input_trangthai_hd}
