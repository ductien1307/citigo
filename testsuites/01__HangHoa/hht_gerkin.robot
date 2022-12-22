*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown    After Test
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/api/api_hanghoa.robot

*** Variables ***

*** Test Cases ***    Ma HH       Ten HH           Nhom Hang           Gia Ban     Gia Von    Ton Kho

Thêm mới              [Tags]          TCG
                      [Template]      Them hoa hoa chưa co tren he thong
                      [Documentation]   Thêm mới hàng thường
                      HTAT0002       GreenCross       Dịch vụ            80000.6     60000      2


*** Keyword ***
Them hoa hoa chưa co tren he thong
    [Arguments]      ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Given Hang hoa khong ton tai       ${ma_hh}
    When Reload Page
    And Click Them moi hang hoa
    And Input thong tin vao form Them hang hoa      ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    And Click button Luu
    And Click button Dong y ap dung gia von
    Then Message Them hang hoa thanh cong
    And Assert thong tin hang hoa    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${tonkho}    ${giavon}    ${giaban}
    When Delete product thr API    ${ma_hh}

Hang hoa khong ton tai
    [Arguments]     ${ma_hh}
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product by product id thr API    ${get_pr_id}

Click Them moi hang hoa
    [Timeout]   2 mins
    Wait Until Page Contains Element    ${button_them_moi}    1 mins
    Wait Until Keyword Succeeds    3x    3s   Click Element    ${button_them_moi}
    KV Click Element    ${button_them_hh}
    Wait Until Page Contains Element    ${textbox_ma_hh}    1 min

Input thong tin vao form Them hang hoa
    [Arguments]    ${ma_hh}    ${ten_hh}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    [Documentation]    Input dữ liệu với Nhóm hàng đã có sẵn trên hệ thống
    Set Selenium Speed    0.6 seconds
    Wait Until Page Contains Element    ${textbox_giavon}     30s
    Sleep    2s
    Run Keyword If    '${giavon}'!='none'   Wait Until Keyword Succeeds    4x    2s     Input Text    ${textbox_giavon}    ${giavon}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Input Text    ${textbox_tonkho}    ${tonkho}
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hh}
    Select Nhom Hang    ${nhom_hang}

Click button Luu
    Click Element    ${button_luu}

Click button Dong y ap dung gia von
    KV Click Element   ${button_dongy_apdung_giavon}

Message Them hang hoa thanh cong
    [Timeout]    1 minute
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}    Hàng hóa đã được tạo thành công

Assert thong tin hang hoa qua API
    [Arguments]    ${input_mahang}    ${input_ten_sp}    ${input_nhomhang}    ${input_ton}    ${input_giavon}    ${input_giaban}
    [Timeout]    3 minutes
    #${endpoint_pr}    Format String    /branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&KeyWord={1}    ${BRANCH_ID}    ${input_mahang}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_price}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_cost}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${input_mahang}
    ${jsonpath_group}    Format String    $..Data[?(@.Code=="{0}")].CategoryName    ${input_mahang}
    ${ten}    Get data from response json    ${get_resp}    ${jsonpath_name}
    ${nhomhang}    Get data from response json    ${get_resp}    ${jsonpath_group}
    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_price}
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_cost}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    Should Contain    ${ten}    ${input_ten_sp}
    Should Be Equal As Strings    ${nhomhang}    ${input_nhomhang}
    Should Be Equal As Numbers    ${ton}    ${input_ton}
    Should Be Equal As Numbers    ${giavon}    ${input_giavon}
    Should Be Equal As Numbers    ${giaban}    ${input_giaban}

Assert thong tin hang hoa
    [Arguments]    ${input_mahang}    ${input_ten_sp}    ${input_nhomhang}    ${input_ton}    ${input_giavon}    ${input_giaban}
    Wait Until Keyword Succeeds    3x    3s    Assert thong tin hang hoa qua API    ${input_mahang}    ${input_ten_sp}    ${input_nhomhang}    ${input_ton}    ${input_giavon}    ${input_giaban}
