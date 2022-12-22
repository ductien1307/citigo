*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/lodate.robot
Resource          ../../../../core/API/api_dathangnhap.robot

*** Variables ***
&{list_product1}    LDQD036=4    LDQD037=2    LDQD038=1.5    TRLD039=5    TRLD040=2.4
&{list_product2}    LDQD036=4    LDQD037=2    TRLD038=1.5    TRLD039=5    TRLD040=2.4
&{list_product3}    LDQD036=4    LDQD037=2    TRLD038=1.5    TRLD039=5    TRLD040=2.4
&{list_product4}    LDQD036=3.5    LDQD037=2.5    TRLD038=1.7    TRLD039=2.5    TRLD040=2.4
&{list_product5}    LDQD036=5.5    LDQD037=2.7    TRLD038=1.5    TRLD039=5.5    TRLD040=2.4
@{discount}    5    2000    0    20000.55    99000
@{discount_type}   dis     disvnd    none    changedown    changeup

*** Test Cases ***
Tao DL mau
    [Tags]             LDH            ULODA
    [Template]    Add du lieu
    lodate_unit    TRLD036    Trà sữa sen vàng      trackingld    70000    5000     none      none    none    none    none    Tuýp     LDQD036    140000    Thùng    2
    lodate_unit    TRLD037    Son merzy màu 01      trackingld    40000    5000    none    none    none    none    none    Chiếc     LDQD037    140000    Thùng    7
    lodate_unit    TRLD038    son BBIA màu 05       trackingld    20000    5000    none    none    none    none    none     Tuýp     LDQD038    140000    Thùng    6
    lodate_unit    TRLD039     Son merzy màu 02     trackingld    12000    5000    none    none    none    none    none    Chiếc     LDQD039    140000    Thùng    5
    lodate_unit    TRLD040    son BBIA màu 06       trackingld    50000    5000    none    none    none    none    none    Miếng     LDQD040    140000    Thùng    3

                      #Mã KH         List product&nums     GGSP            List discount type      GGDH       Khách TT
Create order with customer payment
                      [Tags]        LDH            ULODA
                      [Template]    Dathang_lodate_co_KH
                      KHLD05       ${list_product1}     ${discount}      ${discount_type}        0          all
                      KHLD06       ${list_product3}     ${discount}      ${discount_type}       7          200000

Create order no payment
                      [Tags]        LDH            ULODA
                      [Template]    Dathang_lodate_co_KH
                      KHLD07       ${list_product2}     ${discount}      ${discount_type}       50000       0

Create order without customer payment
                      [Tags]        LDH            ULODA
                      [Template]    Dathang_lodate_KL
                      ${list_product2}     ${discount}      ${discount_type}       444444       all
Create order without customer payment
                      [Tags]        LDH            ULODA
                      [Template]    Dathang_lodate_KL
                      ${list_product2}     ${discount}      ${discount_type}       555555       0

*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Dathang_lodate_co_KH
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_ma_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    ${result_tongcong}    ${result_ggdh}    ${actual_khtt}    ${result_no_hientai_kh}    Computation total, discount and pay for customer incase order    ${input_ma_kh}    ${list_result_thanhtien}    ${input_ggdh}    ${input_khtt}
    ${order_code}   Add new order with lodate product incase discount - payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_khtt}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    Assert values by order code until succeed    ${order_code}    ${input_ma_kh}    1    ${result_tongcong}    ${actual_khtt}    ${result_ggdh}
    #assert value khach hang and so quy
    Assert value in tab cong no khach hang incase order    ${input_ma_kh}    ${order_code}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${input_khtt}    ${actual_khtt}
    Delete order frm Order code    ${order_code}
    Delete customer    ${get_id_kh}

Dathang_lodate_KL
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_discount_type}   ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_ordersummary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    ${order_code}    Add new order with lodate product no customer    ${input_ggdh}    ${result_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${actual_khtt}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Run Keyword If    ${input_ggdh} == 0    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Run Keyword If    ${input_ggdh} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    Delete order frm Order code    ${order_code}
