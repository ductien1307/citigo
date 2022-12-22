*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/API/api_soquy.robot
Library           BuiltIn
Resource          ../../../../core/share/toast_message.robot

*** Variables ***
&{list_product_tk04}    HH0061=5    SI044=2    DVT64=3.5    DV068=1    Combo45=2.5    QDBTT07=3
&{list_product_tk05}    HH0062=5    SI045=1    DVT65=3.5    DV069=2    Combo46=1.8
&{list_product_tk06}    HH0063=5    SI046=2    DVT66=3.5    DV070=1    Combo48=3
&{list_product_tk07}    HH0064=5.6    SI047=1    DVT67=1.75    DV071=2    Combo49=3
@{list_product_delete_01}    HH0061    SI044    DVT64
@{list_product_delete02}    SI045    DV069    DVT65
@{list_product_delete03}    SI046    HH0063    Combo48
&{serial}       SI047=2
@{list_giamoi04}    30000    100000    50000    200000    180000
@{list_%_ggsp1}    5    10
@{list_vnd_ggsp}    1000    2000    3000

*** Test Cases ***    Mã KH              GGDH                 Mã thu khác    Khách thanh toán            List product
Khongtudong_BH_1thukhac
                      [Documentation]    1. Xử lý đặt hàng > Tạo hóa đơn cho đơn hàng được tạo qua API có giảm giá đặt hàng \n2. Thu khác không đc tự động đưa vào hóa đơn và đơn hàng có 1 thu khác \n3. Validate hàng hóa, công nợ khách hàng, sổ quỹ\n
                      [Tags]             EDTK
                      [Setup]
                      [Template]         uetedh_tk1
                      CTKH107            50000            TK004          0       ${list_product_delete_01}    ${list_product_tk04}

Khongtudong_BH_2thukhac
                      [Documentation]    1. Xử lý đặt hàng > Tạo hóa đơn cho đơn hàng được tạo qua API có giảm giá sản phẩm và không hoàn trả tạm ứng\n2. Thu khác không đc tự động đưa vào hóa đơn và đơn hàng có 2 thu khác \n3. Validate hàng hóa, công nợ khách hàng, sổ quỹ\n
                      [Tags]             EDTK
                      [Setup]
                      [Template]         uetedh_tk2
                      CTKH108            ${list_%_ggsp1}        0              ${list_product_delete02}       TK007                        TK003                      ${list_product_tk05}    3000000

Tudong_BH_1thukhac    [Documentation]    1. Xử lý đặt hàng > Tạo hóa đơn cho đơn hàng được tạo qua API có giảm giá hóa đơn và hoàn trả tạm ứng\n2. Thu khác tự động đưa vào hóa đơn và đơn hàng có 1 thu khác \n3. Validate hàng hóa, công nợ khách hàng, sổ quỹ\n
                      [Tags]             EDTKA
                      [Setup]
                      [Template]         uetedh_tk3
                      CTKH109            200000      TK005       ${list_product_delete03}    ${list_vnd_ggsp}     25      ${list_product_tk06}     1000000

Tudong_BH_2thukhac    [Documentation]    1. Đang check do có lỗi trên hệ thống
                      [Tags]             EDTKA
                      [Setup]
                      [Template]         uetedh_tk4
                      CTKH110            ${list_giamoi04}           ${serial}    45000      all     TK002    TK006       ${list_product_tk07}    100000

*** Keywords ***
uetedh_tk1
    [Arguments]    ${input_ma_kh}    ${input_gghd}    ${input_ma_thukhac}    ${input_khtt}    ${list_product}    ${dict_product_nums_to_create}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums_to_create}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_ma_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_ma_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    true
    #get info product, customer
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_tru_gghd}    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhang_tru_gghd}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${actual_surcharge_value}
    ${result_khachcantra}    sum    ${result_tongtienhang_tru_gghd}    ${actual_surcharge_value}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product}
    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount invoice    ${input_gghd}
    Wait Until Keyword Succeeds    3 times    8 s    Select one surcharge and get value frm xpath invoice    ${input_ma_thukhac}    ${actual_surcharge_value}    ${cell_surcharge_order}
    ...    ${cell_surcharge_value}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    false

uetedh_tk2
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${input_hoantratamung}    ${list_product}    ${input_thukhac1}    ${input_thukhac2}
    ...    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    #activate surcharge
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    #get info product, customer
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachdatra}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_tongtienhang}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_tongtienhang}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${total_surcharge}
    ${result_tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product}
    : FOR    ${item_product}    ${item_ggsp}    ${newprice}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}
    ...    ${list_result_giamoi}
    \    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${newprice}
    Wait Until Keyword Succeeds    3 times    8 s    Select two surcharege and get value frm xpath invoice    ${input_thukhac1}    ${input_thukhac2}    ${total_surcharge}
    ...    ${cell_surcharge_order}    ${cell_surcharge_value}
    Input customer payment and deposit refund into BH form    ${input_hoantratamung}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${get_khachdatra_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang_tovalidate}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false

uetedh_tk3
    [Arguments]    ${input_ma_kh}    ${input_hoantratamung}    ${input_ma_thukhac}    ${list_product}    ${list_ggsp}    ${input_gghd}
    ...    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order have surcharge    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_ma_thukhac}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}
    Before Test Ban Hang
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_ma_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_ma_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    true
    Reload Page
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_gghd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ${result_tongtienhang_tru_gghd}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhang_tru_gghd}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}    sum    ${result_tongtienhang_tru_gghd}    ${actual_surcharge_value}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Sum    ${result_du_no_hd_KH}    ${result_tamung}
    ${result_tongban_KH}    Sum and replace floating point    ${result_khachcantra}    ${get_tongban_bf_execute}
    ${result_khachdatra_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${actual_surcharge_value}
    #create invoice from order
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product}
    : FOR    ${item_product}    ${item_ggsp}    ${newprice}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}
    ...    ${list_result_giamoi}
    \    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${newprice}
    Wait Until Keyword Succeeds    3 times    20 s    Input % discount invoice    ${input_gghd}    ${result_gghd}
    Run Keyword If    '${input_hoantratamung}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment and deposit refund into BH form    ${result_tamung}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${result_tongtienhang}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_tamung}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    false

uetedh_tk4
    [Arguments]    ${input_ma_kh}    ${list_newprice}    ${dic_imei_nums}    ${input_gghd}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order have multi surcharge    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_thukhac1}    ${input_thukhac2}    ${input_khtt_tocreate}
    #get info product, customer
    ${list_imei}    Get Dictionary Keys    ${dic_imei_nums}
    ${list_nums}    Get Dictionary Values    ${dic_imei_nums}
    Create list imei    ${list_imei}    ${list_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #get order summary and sub total of products
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks incase newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_newprice}
    Before Test Ban Hang
    #activate surcharge
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    #compute for invoice, order
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}    Minus    ${result_tongtienhang}    ${input_gghd}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge2_value} > 100 and ${actual_surcharge1_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge1_value}    ${result_TTH_tru_gghd}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_TTH_tru_gghd}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}    Sum    ${result_TTH_tru_gghd}    ${total_surcharge}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khdatra_in_hd}    Sum and replace floating point    ${result_khachcantra_in_hd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khcantra_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khachcantra}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khcantra_all}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${total_surcharge}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #create invoice from order
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${item_imei}    IN ZIP    ${list_prs}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    : FOR    ${item_product}    ${newprice}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_newprice}
    \    Input newprice for multi product    ${item_product}    ${newprice}
    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra_in_hd}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
