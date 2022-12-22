*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/computation.robot

*** Variables ***
${env}            live3
${remote}         http://localhost:9999/wd/hub

*** Test Cases ***
Dieu chinh
    [Tags]    CNKHA
    [Template]    Dieu chinh cong no API
    CRPKH018    20000    none

*** Keywords ***
Dieu chinh cong no API
    [Arguments]    ${input_ma_kh}    ${input_giatri}    ${mo_ta}
    ${get_no_cuoi_af_ex}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${result_giatri}    Minus    ${input_giatri}    ${get_no_cuoi_af_ex}
    ${get_id_kh}  Get customer id thr API    ${input_ma_kh}
    ${endpoint_taophieu}        Format String    ${endpoint_tao_phieu_dieu_chinh}    ${get_id_kh}
    ${data_str}     Run Keyword If    '${mo_ta}'!='none'    Format String    {{"Adjustment":{{"Balance":{0},"Description":"{1}","AdjustmentDate":"2019-11-02T03:42:58.666Z","Value":{2}}},"customerId":{3},"CompareCode":"CRPKH018","CompareName":"A lâm 01689946055","CompareBalance":500000,"CompareAdjustmentDate":"2019-11-01T10:56:38.697Z"}}    ${input_giatri}     ${mo_ta}      ${result_giatri}      ${get_id_kh}        ELSE        Format String    {{"Adjustment":{{"Balance":{0},"AdjustmentDate":"2019-11-02T06:48:56.567Z","Value":{1}}},"customerId":{2},"CompareCode":"CRPKH018","CompareName":"A lâm 01689946055","CompareBalance":115000,"CompareAdjustmentDate":"2019-11-02T03:42:58.667Z"}}    ${input_giatri}   ${result_giatri}      ${get_id_kh}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    ${endpoint_taophieu}    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Should Be Equal As Strings    ${resp3.status_code}    200
    Sleep    5s
    ${get_ma_phieu}     ${get_giatri}     ${get_du_no}      Get ma phieu, gia tri, du no in tab No can thu tu khach    ${input_ma_kh}
    Should Be Equal As Numbers    ${input_giatri}    ${get_du_no}
    Run Keyword If    '${result_giatri}'=='0.0'    Log    Ignore Validate     ELSE     Should Be Equal As Numbers    ${result_giatri}    ${get_giatri}
    Run Keyword If    '${result_giatri}'=='0.0'    Log    Ignore delete phieu     ELSE        Delete balance adjustment thr API    ${input_ma_kh}    ${get_ma_phieu}
