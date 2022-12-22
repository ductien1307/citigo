*** Settings ***
Library     SeleniumLibrary
Library     String
Library     Collections
Library     OperatingSystem

*** Variable ***
${ENTER_KEY}               \\13
${ESC_KEY}                 \\27
${F9_KEY}                  \ue039
${TAB_KEY}                 \\9
${F5_KEY}                  \\116
${excelDownloadPath}       ${EXECDIR}\\uploadFile\\ExportFile

${Short_Time}              30s
${LOADING_ICON}            //div[@class='k-loading-mask']
${POPUP_MESSAGE}           //div[@class='toast-message']
${TEXTBOX_SEARCH}          //input[@id='productSearchInput']
${LINK_NHANVAODETAIXUONG}  //a[text()='Nhấn vào đây để tải xuống']
*** Keywords ***
Wait To Loading Icon Invisible
    Wait Until Page Does Not Contain Element    ${LOADING_ICON}   ${Short_Time}
    Sleep  1s

Wait To Popup Message Invisible
    Wait Until Element Is Not Visible    ${POPUP_MESSAGE}   ${Short_Time}

Press Enter Key
    [Arguments]   ${locator}
    Wait Until Element Is Visible     ${locator}   ${Short_Time}
    Set Selenium Speed    0.5s
    Press Key    ${localtor}    ${ENTER_KEY}
    Set Selenium Speed    0s

Hover Mouse To Element
    [Arguments]  ${locator}
    Wait Until Element Is Visible     ${locator}   ${Short_Time}
    Mouse Over    ${locator}

Get Text Global
    [Arguments]   ${locator}
    Wait Until Element Is Visible     ${locator}   ${Short_Time}
    ${textResult}   Get Text    ${locator}
    Return From Keyword     ${textResult}

Input Text Global
    [Arguments]   ${localtor}   ${textInput}
    Wait Until Element Is Visible    ${localtor}  ${Short_Time}
    Clear Element Text    ${localtor}
    Input Text    ${localtor}   ${textInput}

Click Element Global
    [Arguments]   ${localtor}
    Wait Until Element Is Visible    ${localtor}  ${Short_Time}
    Click Element     ${localtor}

Input Text With Each Letter
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}
    Clear Element Text    ${locator}
    ${items}    Get Length    ${text}
    : FOR    ${item}    IN RANGE    0    ${items}
    \    Press Key    ${locator}    ${text[${item}]}

Search Text Global With Each Letter
    [Arguments]   ${text}
    Input Text With Each Letter  ${TEXTBOX_SEARCH}    ${text}

Wait Nhấn Vào Đây Để Tải Xuống Visible
    Wait Until Element Is Visible   ${LINK_NHANVAODETAIXUONG}   2 minutes
