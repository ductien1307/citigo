*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{list_prs_num_TH2}    CNKHDV02=2
@{discount}    140000
@{discount_type}    changedown


*** Test Cases ***    Mã KH        Tên KH         List products invoice 1     List products invoice 2      List discount      List discount type      Phí trả hàng    GGTH          Payment to return 1     Payment to return 2
Thanh toan no           [Tags]      UPBKH
                      [Template]    uiphanbo6
                      KHPBCN6     Khách công nợ 5      Chi 3      50000      ${list_prs_num_TH2}      ${discount}          ${discount_type}      15            15000      100000

*** Keywords ***
uiphanbo6
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${input_loai_thuchi}    ${input_giatri}    ${list_product_TH}    ${list_ggsp}   ${list_discount_type}   ${input_phi_th}
    ...   ${input_ggth}   ${input_khtt}
    Set Selenium Speed      0.5s
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${result_giatri}    Minus   0    ${input_giatri}
    ${ma_phieu}    Add cash flow in tab Tien mat for customer and not used for financial reporting    ${input_ma_kh}    ${input_loai_thuchi}    ${result_giatri}    0
    Sleep    20s
    ${list_product}   Get Dictionary Keys    ${list_product_TH}
    ${list_nums}   Get Dictionary Values    ${list_product_TH}
    #get order summary and sub total of products
    ${result_list_thanhtien}    ${get_list_giavon}    ${result_list_toncuoi}   Get list total sale - endingstock - cost incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhang}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}   Sum and replace floating point   ${input_giatri}    ${input_khtt}
    ##du no khach hang
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_cantrakhach}
    ${result_PTT_th_KH}    Sum and replace floating point    ${result_du_no_th_KH}    ${input_khtt}
    ${result_tongban_tru_TH}    Minus and replace floating point    ${get_tongban_tru_trahang_bf_execute}    ${result_cantrakhach}
    #create invoice frm Order API
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_discount}    ${item_price}    ${item_discount_type}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${list_ggsp}    ${get_list_baseprice}    ${list_discount_type}
    \    ${item_newprice}=    Run Keyword If    '${item_discount_type}' == 'dis'    Price after % discount product    ${item_price}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Minus    ${item_price}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Set Variable    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_price}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    20 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_discount}        ELSE       Log        ignore
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggth} < 100    Input % discount return    ${input_ggth}
    ...    ${result_ggth}    ELSE    Input VND discount return    ${input_ggth}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Page Contains Element    ${textbox_th_khachttTraHang}    1 min
    Wait Until Keyword Succeeds    3 times    20 s    Input data    ${textbox_th_khachttTraHang}    ${input_khtt}
    Apply allocate payment    ${input_giatri}
    Wait Until Page Contains Element    ${button_th}    2 mins
    Click Element JS    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${result_list_toncuoi}    ${get_list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    ##validate invoice allocate
    ${get_datrakhach}   ${get_ptt_pb}   Get return info after allocate    ${return_code}    ${ma_phieu}
    Should Be Equal As Numbers    ${get_datrakhach}    ${result_khtt}
    Should Be Equal As Numbers    ${get_ptt_pb}    ${input_giatri}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${return_code}    ${input_khtt}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${return_code}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_th_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute_kh}    ${result_tongban_tru_TH}
    Validate customer history and debt if return is paid    ${input_ma_kh}    ${return_code}    ${result_du_no_th_KH}    ${result_PTT_th_KH}
    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${input_khtt}
    Delete return thr API        ${return_code}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
