*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           Collections
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/API/api_dathangnhap.robot
Resource          ../../../../core/share/lodate.robot

*** Variables ***
&{list_product_u1}    LDQD041=1    LDQD042=2.4    TRLD043=2    TRLD044=3
@{discount}    15    20000    0    250000.55
@{discount_type}   dis     disvnd    none    changeup
&{list_product_u2}    LDQD041=1    LDQD042=2.4    TRLD043=2    TRLD044=3     TRLD045=4.5
@{list_product_delete}    TRLD045
&{dict_loaihh}     TRLD041=lodate     TRLD042=lodate     TRLD043=lodate     TRLD044=lodate     TRLD045=lodate

*** Test Cases ***
Tao DL mau
    [Tags]        LDH1                ULODA
    [Template]    Add du lieu
    lodate_unit    TRLD041    Trà sữa sen vàng      trackingld    70000    5000     none      none    none    none    none    Tuýp     LDQD041    140000    Thùng    2
    lodate_unit    TRLD042    Son merzy màu 01      trackingld    40000    5000    none    none    none    none    none    Chiếc     LDQD042    140000    Thùng    7
    lodate_unit    TRLD043    son BBIA màu 05       trackingld    20000    5000    none    none    none    none    none     Tuýp     LDQD043    140000    Thùng    6
    lodate_unit    TRLD044     Son merzy màu 02     trackingld    12000    5000    none    none    none    none    none    Chiếc     LDQD044    140000    Thùng    5
    lodate_unit    TRLD045    son BBIA màu 06       trackingld    50000    5000    none    none    none    none    none    Miếng     LDQD045    140000    Thùng    3

                      #Mã khách hàng    List product&nums     List GGSP        List discount type       GGDH       Khách thanh toán    Product to create    Nums to create   GGSP to create    Discount type       Payment create    Ghi chú
Add new product       [Tags]           LDH            ULODA
                      [Template]       Update_them_moi
                      CTKH087          ${list_product_u1}    ${discount}       ${discount_type}         15         all                LDQD045               3.6                  80000         changeup                  0          Thanh toán khi nhận hàng      ${dict_loaihh}
                      #Mã KH        Khách thanh toán    Ghi chú ĐH         GGDH     List product               List GGSP     List discount type        List product to create    Khách thanh toán to create
Delete product        [Tags]             LDH1            ULODA
                      [Template]         Update_xoa
                      CTKH088       500000                 Đã thanh toán      0         ${list_product_delete}    ${discount}    ${discount_type}         ${list_product_u2}      0     ${dict_loaihh}


*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Update_them_moi
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}
    ...    ${input_ma_hh}    ${input_soluong}   ${input_ggsp}   ${input_discount_type}    ${input_khtt_create_order}   ${input_ghichu}    ${dict_loaihh}
    #get info product, customer
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_ma_kh}
    ${order_code}    Add new order frm API    ${input_ma_kh}    ${input_ma_hh}    ${input_soluong}    ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_list_hh_in_order}    ${get_list_sl_in_order}   Get list product and quantity frm API    ${order_code}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    :FOR    ${item_hanghoa}   ${item_num}   IN ZIP          ${get_list_hh_in_order}    ${get_list_sl_in_order}
    \   Append To List    ${list_product}   ${item_hanghoa}
    \   Append To List    ${list_nums}   ${item_num}
    Append To List    ${list_ggsp}    ${input_ggsp}
    Append To List    ${list_discount_type}    ${input_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    Sleep    5s
    ${get_tongso_dh_bf_execute}    Get order summary by order code    ${order_code}
    #get value to Validate
    ${list_result_thanhtien}    Get result list total sale incase discount    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}
    #compute
    ${result_tongtienhang}    ${result_tongcong}    ${result_ggdh}    ${actual_khtt}    ${result_no_hientai_kh}    Computation total, discount and pay for customer incase order    ${input_ma_kh}    ${list_result_thanhtien}    ${input_ggdh}    ${input_khtt}
    #
    ${order_code}    Update order by add new lodate product    ${order_code}    ${dict_product_nums}    ${input_ma_kh}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${result_ggdh}    ${actual_khtt}    ${input_ghichu}
    #assert value product
    ${get_tongso_dh_af_execute}    Get order summary frm product API    ${input_ma_hh}
    Should Be Equal As Numbers    ${get_tongso_dh_af_execute}    ${get_tongso_dh_bf_execute}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    Assert values by order code until succeed    ${order_code}    ${input_ma_kh}    1    ${result_tongcong}    ${actual_khtt}    ${result_ggdh}
    #assert value khach hang and so quy
    Assert value in tab cong no khach hang incase order    ${input_ma_kh}    ${order_code}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${input_khtt}    ${actual_khtt}
    Delete order frm Order code    ${order_code}

Update_xoa
    [Arguments]    ${input_ma_kh}    ${input_khtt}    ${input_ghichu}   ${input_ggdh}    ${list_product_del}    ${list_ggsp}    ${list_discount_type}
    ...    ${dict_product_nums}    ${input_khtt_create_order}    ${dict_loaihh}
    #get info to validate
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_ma_kh}
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   Get list product frm API    ${order_code}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   IN     @{list_product_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product_del}
    ${list_soluong_in_dh}    ${list_tong_dh}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${get_list_hh_in_dh_bf_execute}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    Create List
    ${list_result_giamoi}    Create List
    : FOR    ${get_soluong_in_dh}    ${item_ggsp}   ${discount_type}   ${item_baseprice}    IN ZIP    ${list_soluong_in_dh}    ${list_ggsp}
    ...    ${list_discount_type}    ${get_list_baseprice}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${item_ggsp}
    \    ...    ELSE     Set Variable    ${item_baseprice}
    \    ${result_thanhtien}    Multiplication with price round 2    ${get_soluong_in_dh}    ${result_giamoi}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    #compute
    ${result_tongtienhang}    ${result_tongcong}    ${result_ggdh}    ${actual_khtt}    ${result_no_hientai_kh}    Computation total, discount and pay for customer incase order    ${input_ma_kh}    ${list_result_thanhtien}    ${input_ggdh}    ${input_khtt}
    #delete product by post API
    ${order_code}    Update order by delete lodate product    ${order_code}    ${list_product_del}    ${input_ma_kh}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${result_ggdh}    ${actual_khtt}    ${input_ghichu}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_tong_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${result_tongcong}    Evaluate    round(${result_tongcong}, 0)
    Assert values by order code until succeed    ${order_code}    ${input_ma_kh}    1    ${result_tongcong}    ${actual_khtt}    ${result_ggdh}
    #assert value khach hang and so quy
    Assert value in tab cong no khach hang incase order    ${input_ma_kh}    ${order_code}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${input_khtt}    ${actual_khtt}
    #Delete order frm Order code    ${order_code}
    Delete data of tracking lodate    ${dict_loaihh}
