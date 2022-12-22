
*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          phieu_bao_hanh_list_page.robot
Resource          ../share/computation.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Keywords ***
Go to select export file warranty
    [Arguments]   ${button_export}
    Wait Until Page Contains Element    ${button_xuatile_ds_pbh}    1 mins
    Click Element     ${button_xuatile_ds_pbh}
    Wait Until Page Contains Element    ${button_export}    1 mins
    Click Element    ${button_export}

Access button update warranty
    Wait Until Page Contains Element        //tr[contains(@class,'k-master-row')][1]//td[@class='cell-code'][1]//span      30s
    Click Element JS    //tr[contains(@class,'k-master-row')][1]//td[@class='cell-code'][1]//span
    Wait Until Page Contains Element    ${button_capnhat_pbh}    30s
