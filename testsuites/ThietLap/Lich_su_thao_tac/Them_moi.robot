*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_action.robot
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/API/api_mhbh.robot
Resource         ../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{invoice_1}      HH0065=5.6    SI051=2    QD1008=3    DV042=2   SCCB01=1
@{list_giamgia}   0   0   0   0   0   0
@{list_giamoi}    30000    15000.56     95000.34    600000    250000
@{discount_type}   changeup     changedown   changeup    changedown    changedown
*** Test Cases ***      Mã KH   List product and nums   List discount   GGHD   Mã HH combo   Function name   Thao tác   Khách thanh toán
Invoice                 [Tags]            TL   GOLIVE2   CTP
                        [Template]        create01
                        [Documentation]   MHQL - CHECK LỊCH SỬ THAO TÁC
                        CTKH033   ${invoice_1}   ${list_giamgia}   0   SCCB01   Hóa đơn   Thêm mới   all

Order                 [Tags]      TL
                        [Template]    create02
                        CTKH034     ${invoice_1}            ${list_giamoi}      ${discount_type}     100000         Đặt hàng      Phiếu thu           Thêm mới    100000

*** Keywords ***
create01
        [Arguments]    ${input_ma_kh}    ${dict_product_nums}      ${list_discount}      ${input_gghd}      ${ma_hh_combo}   ${input_function_name}    ${input_thaotac}   ${input_khtt_create}
        ${invoice_code}   Add new invoice incase discount with multi product - no payment - get invoice code    ${input_ma_kh}    ${dict_product_nums}   ${list_discount}    ${input_gghd}    ${ma_hh_combo}
        Sleep    3s
        Get audit trail no payment info and validate    ${invoice_code}    ${input_function_name}    ${input_thaotac}
        Delete invoice by invoice code    ${invoice_code}

create02
        [Arguments]    ${input_ma_kh}    ${dict_product_nums}      ${list_newprice}     ${list_discount_type}      ${input_ggdh}      ${input_function_name}      ${input_function_payment}    ${input_thaotac}    ${input_khtt_create}
        ${order_code}   Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_newprice}     ${list_discount_type}    ${input_khtt_create}
        Sleep    7s
        Get audit trail payment info and validate    ${order_code}    ${input_function_name}      ${input_function_payment}    ${input_thaotac}
        Delete order frm Order code    ${order_code}
