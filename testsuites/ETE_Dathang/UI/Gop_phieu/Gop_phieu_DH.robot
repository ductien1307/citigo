*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Dat Hang
Test Teardown     After Test
Library           Collections
Library           BuiltIn
Library           SeleniumLibrary
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/Giao_dich/dathang_list_action.robot
Resource          ../../../../core/Giao_dich/dathang_list_page.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/constants.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot

*** Variables ***
&{dict_pro_num1}       Combo034=2    DV301=1    HH0351=1    SI251=2    QD246=1
@{discount1}    10    0    4500    0    5000
@{discount_type1}    dis    none    disvnd    none    changeup
&{dict_pro_num2}       Combo034=2    DV301=1    HH0352=3    SI251=1    QD243=2
@{discount2}    10    0    0    45000    5000
@{discount_type2}    dis    disvnd    none    changedown    changeup
${product_in_invoice}    HH0352
${num_in_invoice}    1.5

*** Test Cases ***
Trang thai phieu tam va da xac nhan
    [Documentation]     chọn từng đơn hàng: đơn đặt hàng ở trạng thái phiếu tạm và đã xác nhận
    [Timeout]    4 mins
    [Tags]    GDH
    [Template]    Gop phieu dat hang 1
    KH126    ${dict_pro_num1}    ${dict_pro_num2}    20    0    ${discount1}    ${discount2}    ${discount_type1}    ${discount_type2}    all

Gop phieu khac chi nhanh
    [Documentation]     gộp 2 đơn đặt hàng ở 2 chi nhánh khác nhau
    [Timeout]    4 mins
    [Tags]    GDH
    [Template]    Gop phieu dat hang 2
    KH126    ${dict_pro_num1}    ${dict_pro_num2}    20    0    ${discount1}    ${discount_type1}    ${discount2}    ${discount_type2}    50000    Nhánh A
#case này live đang lỗi
Gop phieu dat hang ap dung promo
    [Documentation]     gộp 2 đơn đặt hàng có áp dụng chương trình khuyến mại (đang lỗi: đã báo bug)
    [Timeout]    4 mins
    [Tags]    GDH
    [Template]    Gop phieu dat hang 3
    KH127    ${dict_pro_num1}    ${dict_pro_num2}    KM001    KM002    0    0

Gop phieu dat hang khac khach hang va co thanh toan
    [Documentation]     gộp 2 đơn đặt hàng khác khách hàng và có đơn chứa phiếu thanh toán
    [Timeout]    4 mins
    [Tags]    GDH
    [Template]    Gop phieu dat hang 4
    KH126    KH127    20000    50000    ${dict_pro_num1}    ${dict_pro_num2}    ${discount1}    ${discount2}    ${discount_type1}    ${discount_type2}    50000

Khong chon don dat hang
    [Documentation]      mở popup gộp lên rồi mới chọn phiếu, đơn đặt hàng ở trạng thái phiếu tạm và đã xác nhận
    [Timeout]    4 mins
    [Tags]    GDH
    [Template]    Gop phieu dat hang 5
    KH126    ${dict_pro_num1}    ${dict_pro_num2}    20    0    ${discount1}    ${discount_type1}    ${discount2}    ${discount_type2}

Gop don o trang thai dang giao hang
    [Documentation]     Chọn từng đơn hàng: đơn đặt hàng ở trạng thái phiếu tạm và đang giao hàng
    [Timeout]    4 mins
    [Tags]    GDH
    [Template]    Gop phieu dat hang 6
    KH126    ${dict_pro_num1}    ${dict_pro_num2}    20    0    ${discount1}    ${discount_type1}    ${discount2}    ${discount_type2}    ${product_in_invoice}    ${num_in_invoice}

*** Keywords ***
Gop phieu dat hang 1
    [Documentation]    Gộp phiếu đặt hàng chọn từng phiếu: phiếu tạm và đã xác nhận
    [Arguments]    ${input_ma_kh}    ${dict_pro_num1}    ${dict_pro_num2}    ${input_ggdh1}    ${input_ggdh2}    ${discount1}    ${discount2}    ${discount_type1}    ${discount_type2}    ${input_khtt}
    Set Selenium Speed    0.1
    ${list_product1}    Get Dictionary Keys    ${dict_pro_num1}
    ${list_nums1}    Get Dictionary Values    ${dict_pro_num1}
    ${list_product2}    Get Dictionary Keys    ${dict_pro_num2}
    ${list_nums2}    Get Dictionary Values    ${dict_pro_num2}
    #order1
    ${list_dh1}    Get list order summary frm product API    ${list_product1}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${order_code1}    Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh1}    ${dict_pro_num1}    ${discount1}    ${discount_type1}    ${input_khtt}
    ${get_tongtienhang1}    ${get_tongcong1}    ${get_ggdh1}    ${list_giaban1}    ${list_discount1}    Get info order have discount product after created
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${get_tongcong1}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_no_hientai_kh}    Minus    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ

    #order2
    ${list_dh2}    Get list order summary frm product API    ${list_product2}
    ${order_code2}    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh2}    ${dict_pro_num2}    ${discount2}    ${discount_type2}
    ${get_tongtienhang2}    ${get_tongcong2}    ${get_ggdh2}    ${list_giaban2}    ${list_discount2}    Get info order have discount product after created
    #so sánh và gộp list
    ${list_product_af_combine}    ${tong_so_luong}    ${list_tong_dh_expeted}    ${tong_tien_hang}    ${giam_gia_phieu_dat}    ${tong_cong}    Validate products and combine list before combine order    ${list_product1}    ${list_product2}    ${list_giaban1}    ${list_giaban2}    ${list_discount1}    ${list_discount2}    ${list_nums1}    ${list_nums2}
    ...    ${discount_type1}    ${discount_type2}    ${list_dh1}    ${list_dh2}    ${get_tongtienhang1}    ${get_tongcong1}    ${get_ggdh1}    ${get_tongtienhang2}    ${get_tongcong2}    ${get_ggdh2}
    #combine
    Search order code    ${order_code2}
    Change status of order to confirmed
    Sleep    5s
    Update order success validation    ${order_code2}
    Search and choose order by order code    ${order_code1}
    Search and choose order by order code    ${order_code2}
    Click Element    ${button_gopphieu}
    Combine 2 order by order code
    Sleep    5s
    ${Get_combine_code}    Get order code frm API    ${input_ma_kh}
    #validate info order after combine
    Get info and validate order after combine    ${Get_combine_code}    ${list_product_af_combine}    ${list_tong_dh_expeted}    ${tong_so_luong}    ${tong_tien_hang}    ${giam_gia_phieu_dat}    ${tong_cong}
    ...    ${input_khtt}    ${order_code1}    ${order_code2}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${Get_combine_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${Get_combine_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${Get_combine_code}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info if Order is not paid    ${Get_combine_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khtt}
    Delete order frm Order code    ${Get_combine_code}

Gop phieu dat hang 2
    [Documentation]    Gộp phiếu đặt hàng chọn từng phiếu: 2 phiếu khác chi nhánh
    [Arguments]    ${input_ma_kh}    ${dict_pro_num1}    ${dict_pro_num2}    ${input_ggdh1}    ${input_ggdh2}    ${discount1}    ${discount_type1}    ${discount2}    ${discount_type2}    ${input_khach_tt}    ${branch_name}
    Set Selenium Speed    0.1
    #order1
    ${order_code1}    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh1}    ${dict_pro_num1}    ${discount1}    ${discount_type1}
    #order2
    ${order_code2}    Add new order incase discount - payment with other branch    ${input_ma_kh}    ${input_ggdh2}    ${dict_pro_num2}    ${discount2}    ${discount_type2}    ${input_khach_tt}    ${branch_name}
    #gộp
    Select multiple branches    ${branch_name}
    Search and choose order by order code    ${order_code1}
    Search and choose order by order code    ${order_code2}
    Click Element    ${button_gopphieu}
    Message combine order with multiple branches
    Delete order frm Order code    ${order_code1}
    Delete order frm Order code    ${order_code2}


Gop phieu dat hang 3
    [Documentation]    Gộp 2 phiếu có áp dụng CTKM theo hóa đơn
    [Arguments]    ${input_ma_kh}    ${dict_pro_num1}    ${dict_pro_num2}    ${promo_code1}    ${promo_code2}    ${input_khtt1}    ${input_khtt2}
    Set Selenium Speed    0.1
    ${list_product1}    Get Dictionary Keys    ${dict_pro_num1}
    ${list_nums1}    Get Dictionary Values    ${dict_pro_num1}
    ${list_product2}    Get Dictionary Keys    ${dict_pro_num2}
    ${list_nums2}    Get Dictionary Values    ${dict_pro_num2}
    #order1
    ${list_dh1}    Get list order summary frm product API    ${list_product1}
    ${order_code1}    Add new order with order - order discount promotion    ${input_ma_kh}    ${dict_pro_num1}    ${promo_code1}    ${input_khtt1}
    ${get_tongtienhang1}    ${get_tongcong1}    ${khach_tt1}    ${list_giaban1}    Get info order after created
    #order2
    ${list_dh2}    Get list order summary frm product API    ${list_product2}
    ${order_code2}    Add new order with order - order discount promotion    ${input_ma_kh}    ${dict_pro_num2}    ${promo_code2}    ${input_khtt2}
    ${get_tongtienhang2}    ${get_tongcong2}    ${khach_tt2}    ${list_giaban2}    Get info order after created
    #gộp
    ${list_product_af_combine}    ${tong_so_luong}    ${list_tong_dh_expeted}    ${tong_tien_hang}    ${tong_cong}    Validate products and combine list before combine - orders have promotion    ${list_product1}    ${list_product2}    ${list_giaban1}    ${list_giaban2}    ${list_nums1}    ${list_nums2}
    ...    ${list_dh1}    ${list_dh2}    ${get_tongtienhang1}    ${get_tongcong1}    ${get_tongtienhang2}    ${get_tongcong2}
    Search and choose order by order code    ${order_code1}
    Search and choose order by order code    ${order_code2}
    Click Element    ${button_gopphieu}
    Combine 2 order by order code
    ${Get_combine_code}    Get order code frm API    ${input_ma_kh}
    #get info order af ex
    Get info and validate order combine - orders have promotion    ${Get_combine_code}    ${list_product_af_combine}    ${tong_so_luong}    ${tong_tien_hang}    ${tong_cong}
    ...    ${list_tong_dh_expeted}    ${order_code1}    ${order_code2}    ${khach_tt1}    ${khach_tt2}
    Delete order frm Order code    ${Get_combine_code}

Gop phieu dat hang 4
    [Documentation]    Gộp 2 phiếu trong đó có 1 phiếu có chứa phiếu thanh toán
    [Arguments]    ${input_ma_kh1}    ${input_ma_kh2}    ${input_ggdh1}    ${input_ggdh2}    ${dict_pro_num1}    ${dict_pro_num2}    ${discount1}    ${discount2}    ${discount_type1}    ${discount_type2}    ${input_khtt}
    Set Selenium Speed    0.1
    ${list_product1}    Get Dictionary Keys    ${dict_pro_num1}
    ${list_nums1}    Get Dictionary Values    ${dict_pro_num1}
    ${list_product2}    Get Dictionary Keys    ${dict_pro_num2}
    ${list_nums2}    Get Dictionary Values    ${dict_pro_num2}
    #order1
    ${order_code1}    Add new order incase discount - payment    ${input_ma_kh1}    ${input_ggdh1}    ${dict_pro_num1}    ${discount1}    ${discount_type1}    ${input_khtt}
    #order2
    ${order_code2}    Add new order incase discount - no payment    ${input_ma_kh2}    ${input_ggdh2}    ${dict_pro_num2}    ${discount2}    ${discount_type2}
    Search and choose order by order code    ${order_code1}
    Search and choose order by order code    ${order_code2}
    Click Element    ${button_gopphieu}
    Message combine order with payment and other customers
    Delete order frm Order code    ${order_code1}
    Delete order frm Order code    ${order_code2}

Gop phieu dat hang 5
    [Documentation]    Gộp phiếu đặt hàng ko chọn phiếu: phiếu tạm và đã xác nhận
    [Arguments]    ${input_ma_kh}    ${dict_pro_num1}    ${dict_pro_num2}    ${input_ggdh1}    ${input_ggdh2}    ${discount1}    ${discount_type1}    ${discount2}    ${discount_type2}
    Set Selenium Speed    0.1
    ${list_product1}    Get Dictionary Keys    ${dict_pro_num1}
    ${list_nums1}    Get Dictionary Values    ${dict_pro_num1}
    ${list_product2}    Get Dictionary Keys    ${dict_pro_num2}
    ${list_nums2}    Get Dictionary Values    ${dict_pro_num2}
    #order1
    ${list_dh1}    Get list order summary frm product API    ${list_product1}
    ${order_code1}    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh1}    ${dict_pro_num1}    ${discount1}    ${discount_type1}
    ${get_tongtienhang1}    ${get_tongcong1}    ${get_ggdh1}    ${list_giaban1}    ${list_discount1}    Get info order have discount product after created
    #order2
    ${list_dh2}    Get list order summary frm product API    ${list_product2}
    ${order_code2}    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh2}    ${dict_pro_num2}    ${discount2}    ${discount_type2}
    ${get_tongtienhang2}    ${get_tongcong2}    ${get_ggdh2}    ${list_giaban2}    ${list_discount2}    Get info order have discount product after created
    #so sánh 2 đơn đặt hàng
    ${list_product_af_combine}    ${tong_so_luong}    ${list_tong_dh_expeted}    ${tong_tien_hang}    ${giam_gia_phieu_dat}    ${tong_cong}    Validate products and combine list before combine order    ${list_product1}    ${list_product2}    ${list_giaban1}    ${list_giaban2}    ${list_discount1}    ${list_discount2}    ${list_nums1}    ${list_nums2}
    ...    ${discount_type1}    ${discount_type2}    ${list_dh1}    ${list_dh2}    ${get_tongtienhang1}    ${get_tongcong1}    ${get_ggdh1}    ${get_tongtienhang2}    ${get_tongcong2}    ${get_ggdh2}
    #combine
    Search order code    ${order_code2}
    Change status of order to confirmed
    Sleep    5s
    Update order success validation    ${order_code2}
    Click Element    ${button_gopphieu}
    Choose order by order code on popup    ${order_code1}    ${order_code2}    ${input_ma_kh}
    Combine 2 order by order code
    ${Get_combine_code}    Get order code frm API    ${input_ma_kh}
    #validate info order after combine
    Get info and validate order after combine    ${Get_combine_code}    ${list_product_af_combine}    ${list_tong_dh_expeted}    ${tong_so_luong}    ${tong_tien_hang}    ${giam_gia_phieu_dat}    ${tong_cong}
        ...    0    ${order_code1}    ${order_code2}
    Delete order frm Order code    ${Get_combine_code}

Gop phieu dat hang 6
    [Documentation]    Gộp phiếu đặt hàng chọn từng phiếu: phiếu ở trạng thái tạm và đang giao hàng
    [Arguments]    ${input_ma_kh}   ${dict_pro_num1}    ${dict_pro_num2}    ${input_ggdh1}    ${input_ggdh2}    ${discount1}    ${discount_type1}    ${discount2}    ${discount_type2}    ${input_ma_hang}     ${input_soluong}
    Set Selenium Speed    0.1
    #order1
    ${order_code1}    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh1}    ${dict_pro_num1}    ${discount1}    ${discount_type1}
    #order2
    ${order_code2}    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh2}    ${dict_pro_num2}    ${discount2}    ${discount_type2}
    ${invoice_code_1}     Add new delivery invoice from order code thr API    ${order_code2}    ${input_ma_kh}   ${input_ma_hang}     ${input_soluong}
    #gộp
    Search and choose order by order code    ${order_code1}
    Search and choose order by order code    ${order_code2}
    Click Element    ${button_gopphieu}
    Message combine with shipping order
    Delete order frm Order code    ${order_code1}
