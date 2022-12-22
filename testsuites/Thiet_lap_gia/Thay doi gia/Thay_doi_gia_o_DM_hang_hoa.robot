*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***
&{dict_prs_newprice}    GHC0005=50000.6    GHDV005=30000    GHIM05=120000.7    GHT0005=56000    GHU0005=18000
&{dict_prs_newprice1}    GHC0005=45000    GHDV005=112000.5    GHIM05=80000    GHT0005=75000    GHU0005=36000.3
@{list_type}      com    ser    imei    pro    unit

*** Test Cases ***
Check UI thanh suggest
    [Tags]    TDG
    [Template]    egb03
    ${dict_prs_newprice}    ${list_type}
    ${dict_prs_newprice1}    ${list_type}

Check UI tool bar
    [Tags]    TDG
    [Template]    egb04
    ${dict_prs_newprice}    ${list_type}    Nhà cửa
    ${dict_prs_newprice1}    ${list_type}    Nhà cửa

*** Keywords ***
egb03
    [Arguments]    ${dict_prs_price}    ${list_pr_type}
    ${list_prs}    Get Dictionary Keys    ${dict_prs_price}
    ${list_price}    Get Dictionary Values    ${dict_prs_price}
    : FOR    ${item_pr}    ${item_price}    ${item_pr_type}    IN ZIP    ${list_prs}    ${list_price}
    ...    ${list_pr_type}
    \    Update price product thr API    ${item_pr}    ${item_pr_type}    ${item_price}
    Reload Page
    Sleep    10s
    : FOR    ${item_pr}    ${item_price}    IN ZIP    ${list_prs}    ${list_price}
    \    Input product and validate price in suggestion bar MHBH    ${item_pr}    ${item_price}
    \    ${get_price}    Get New price from UI    ${button_giamoi}
    \    Should Be Equal As Numbers    ${get_price}    ${item_price}
    Click Element JS    ${button_dong_tab_hoadon}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS    ${button_dongy_dong_hoadon}

egb04
    [Arguments]    ${dict_prs_price}    ${list_pr_type}    ${nhom_hang}
    ${list_prs}    Get Dictionary Keys    ${dict_prs_price}
    ${list_price}    Get Dictionary Values    ${dict_prs_price}
    : FOR    ${item_pr}    ${item_price}    ${item_pr_type}    IN ZIP    ${list_prs}    ${list_price}
    ...    ${list_pr_type}
    \    Update price product thr API    ${item_pr}    ${item_pr_type}    ${item_price}
    ${list_name_prs}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${jsonpath_productname}    Format String    $..Data[?(@.Code=="{0}")].Name    ${item_pr}
    \    ${productname}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_productname}
    \    Append To List    ${list_name_prs}    ${productname}
    Log    ${list_name_prs}
    Reload Page
    Sleep    10s
    Filter group product in MHBH    ${nhom_hang}
    Click Element JS    ${button_group_prs}
    Sleep    4s
    : FOR    ${item_pr}    ${item_price}    ${item_name}    IN ZIP    ${list_prs}    ${list_price}
    ...    ${list_name_prs}
    \    ${xpath_giaban_toolbar}    Format String    ${cell_giaban_in_toolbar}    ${item_name}
    \    ${get_price}    Get New price from UI    ${xpath_giaban_toolbar}
    \    Should Be Equal As Numbers    ${get_price}    ${item_price}
    \    Click Element JS    ${xpath_giaban_toolbar}
    \    Sleep    2s
    \    ${get_price1}    Get New price from UI    ${button_giamoi}
    \    Should Be Equal As Numbers    ${get_price1}    ${item_price}
    Click Element JS    ${button_group_prs}
    Click Element JS    ${button_dong_tab_hoadon}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS    ${button_dongy_dong_hoadon}
