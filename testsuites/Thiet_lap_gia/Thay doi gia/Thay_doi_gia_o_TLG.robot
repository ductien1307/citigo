*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***
&{dict_prs_newprice}    GHC0006=25000    GHDV006=30000.5    GHIM06=115000.3    GHT0006=75000    GHU0006=36000.2
&{dict_prs_newprice1}    GHC0006=56000.2    GHDV006=68000    GHIM06=105000    GHT0006=80000.6    GHU0006=65000
@{list_type}      com    ser    imei    pro    unit

*** Test Cases ***
Check UI thanh suggest
    [Tags]    TDG
    [Template]    egb01
    Bảng giá chung    ${dict_prs_newprice}
    Bảng giá test TLG    ${dict_prs_newprice1}

CHeck UI tool bar
    [Tags]    TDG
    [Template]    egb02
    Bảng giá test TLG    ${dict_prs_newprice}    Văn phòng phẩm
    Bảng giá chung    ${dict_prs_newprice1}    Văn phòng phẩm

Golive
    [Tags]
    [Template]    egb01
    Bảng giá test TLG    ${dict_prs_newprice}
    Bảng giá test TLG    ${dict_prs_newprice1}

*** Keywords ***
egb01
    [Arguments]    ${ten_bang_gia}    ${dict_prs_price}
    ${list_prs}    Get Dictionary Keys    ${dict_prs_price}
    ${list_price}    Get Dictionary Values    ${dict_prs_price}
    Changing list price in price book thr API    ${ten_bang_gia}    ${list_prs}    ${list_price}
    Reload Page
    Sleep    7s
    Select Bang gia    ${ten_bang_gia}
    Sleep    6s
    : FOR    ${item_pr}    ${item_price}    IN ZIP    ${list_prs}    ${list_price}
    \    Input product and validate price in suggestion bar MHBH    ${item_pr}    ${item_price}
    \    ${get_price}    Get New price from UI    ${button_giamoi}
    \    Should Be Equal As Numbers    ${get_price}    ${item_price}
    Click Element JS    ${button_dong_tab_hoadon}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS    ${button_dongy_dong_hoadon}

egb02
    [Arguments]    ${ten_bang_gia}    ${dict_prs_price}    ${nhom_hang}
    ${list_prs}    Get Dictionary Keys    ${dict_prs_price}
    ${list_price}    Get Dictionary Values    ${dict_prs_price}
    Changing list price in price book thr API    ${ten_bang_gia}    ${list_prs}    ${list_price}
    Sleep    5s
    ${list_name_prs}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${jsonpath_productname}    Format String    $..Data[?(@.Code=="{0}")].Name    ${item_pr}
    \    ${productname}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_productname}
    \    Append To List    ${list_name_prs}    ${productname}
    Reload Page
    Sleep    7s
    Select Bang gia    ${ten_bang_gia}
    Sleep    7s
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
