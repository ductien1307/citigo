*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Doi Tac Khach Hang
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot

*** Variables ***
&{list_prs_num} 	 GHDV006=8
@{list_giamoi}    65000.5


*** Test Cases ***    Mã KH         List products and nums             List giá mới      GGHD    Mã Combo    Khách thanh toán    TIền thu từ khách
Thanh toan theo hd    [Tags]        CNKH
                      [Template]    Thanh toan cong no theo hoa don
                      CTKH006      ${list_prs_num}                    ${list_giamoi}    10000       none     100000              all

*** Keywords ***
Thanh toan cong no theo hoa don
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}    ${input_khtt}
    ...    ${input_tien_thu}
    ${get_ma_hd}    Add new invoice incase newprice with multi product - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}
    ...    ${input_khtt}
    ${get_no_hd}    Get du no hoa don thr API    ${get_ma_hd}
    Reload Page
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_thanhtoan_congno}
    Click Element JS    ${button_thanhtoan_congno}
    ${get_no_cuoi_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${result_tien_thu}    Set Variable If    '${input_tien_thu}'=='all'    ${get_no_hd}    ${input_tien_thu}
    ${result_tien_thu}    Run Keyword If    '${input_tien_thu}'=='all'    Replace floating point    ${result_tien_thu}
    ...    ELSE    Set Variable    ${input_tien_thu}
    ${result_no_af_ex}    Minus    ${get_no_cuoi_kh}    ${result_tien_thu}
    Wait Until Element Is Visible    ${textbox_thu_tu_khach_in_customer}    10s
    ${xp_thutien}    Format String    ${textbox_tien_thu_theo_hoadon}    ${get_ma_hd}
    Input Text    ${xp_thutien}    ${result_tien_thu}
    Click Element JS    ${button_tao_phieu_thu_in_customer}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    ${actual_tien_thu}    Minus    0    ${result_tien_thu}
    ${get_ma_phieu}    ${get_giatri}    ${get_du_no}    Get ma phieu, gia tri, du no in tab No can thu tu khach    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_giatri}    ${actual_tien_thu}
    Should Be Equal As Numbers    ${get_du_no}    ${result_no_af_ex}
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_actual_giatri}    ${get_loaithutien}    ${get_actual_id_kh}    Get payment detail in tab Tong quy thr API    ${get_ma_phieu}
    Should Be Equal As Numbers    ${get_actual_giatri}    ${result_tien_thu}
    Should Be Equal As Numbers    ${get_actual_id_kh}    ${get_id_kh}
    Should Be Equal As Strings    ${get_loaithutien}    Tiền khách trả
