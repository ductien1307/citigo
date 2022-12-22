*** Settings ***
Suite Setup       Init Test Mobile Environment    ${env}   http://127.0.0.1:4723/wd/hub    admin   man
Test Teardown     Run Keyword If Test Failed    Fail    Hãy check lại Mobile API!
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_hanghoa.robot
Resource          ../../core/API_mobile/api_access_mobile.robot
Resource          ../../core/API_mobile/api_product_list_mobile.robot
Resource          ../../core/API_mobile/api_sale_mobile.robot
Resource          ../../core/API_mobile/envi_mobile.robot
Resource          ../../core/API/api_hoadon_banhang.robot

*** Variables ***
&{dict_pr}      TP017=1

*** Test Cases ***
Check man api
    [Tags]              CTP
    [Template]          api_mb1
    [Documentation]     TẠO HÀNG HÓA QUA MOBILE API
    MBDKJ   Test moblie   Dịch vụ   50000   20000   30

Check pos api
    [Tags]              CTP
    [Template]          api_mb2
    [Documentation]     TẠO HÓA ĐƠN QUA MOBILE API
    CTKH008   ${dict_pr}   10   2000

*** Keyword ***
api_mb1
    [Arguments]   ${input_mahh}    ${input_tenhh}   ${input_nhomhh}    ${input_giaban}   ${input_giavon}     ${input_ton}
    Init Test Mobile Environment    ${env}   http://127.0.0.1:4723/wd/hub    admin   man
    Delete product if product is visible thr API    ${input_mahh}
    Add new normal product frm mobile api   ${input_mahh}    ${input_tenhh}   ${input_nhomhh}    ${input_giaban}   ${input_giavon}     ${input_ton}
    Delete product thr API    ${input_mahh}

api_mb2
    [Arguments]     ${input_ma_kh}    ${dict_product_nums}   ${input_gghd}    ${input_khtt}
    ${invoice_code}      Add new invoice from mobile api    ${input_ma_kh}    ${dict_product_nums}   ${input_gghd}    ${input_khtt}
    Delete invoice by invoice code      ${invoice_code}
