*** Settings ***
Library           SeleniumLibrary
Resource          ../Ban Hang page menu.robot
Resource          ../hang_hoa/hang_hoa_navigation.robot
Resource          ../hang_hoa/danh_muc_list_action.robot

*** Keywords ***
Validate ton kho after selling
    [Arguments]    ${get_toncuoi_afterpurchasing}    ${result_toncuoi}
    ## Validate data in The Kho: so luong ton sau khi ban hang
    Go to Quan ly from Ban hang menu
    Assert Equals Number    ${get_toncuoi_afterpurchasing}    ${result_toncuoi}
