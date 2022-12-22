*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          qlkv_list_page.robot
Resource          ../share/global.robot

*** Keywords ***
Login QLKV
    [Arguments]    ${input_username}  ${input_password}
    Wait Until Page Contains Element    ${textbox_qlkv_username}      1 min
    Input Text    ${textbox_qlkv_username}    ${input_username}
    Input Text    ${textbox_qlkv_password}    ${input_password}
    Click Element    ${button_qlkv_login}

Go to form add retailer
    Go to menu QLKV until succeed    List Retailers
    KV Click Element    ${button_add_retailer}

Input data in form Detail
    [Arguments]    ${details_name}    ${address}    ${khuvuc}   ${phuongxa}   ${domain_name}    ${phone}    ${website}    ${contract}
    ...   ${maximum_branch}   ${maximum_product}   ${maximum_fanpage}   ${kiot_mail}      ${industry}    ${startdate}    ${enddate}
    Wait Until Page Contains Element    ${textbox_qlkv_details_name}      30s
    Input Text    ${textbox_qlkv_details_name}    ${details_name}
    Input Text    ${textbox_qlkv_address}    ${address}
    Input Text    ${textbox_qlkv_khuvuc}    ${khuvuc}
    Input Text    ${textbox_qlkv_phuongxa}    ${phuongxa}
    Input Text    ${textbox_qlkv_domain}    ${domain_name}
    Run Keyword If    '${phone}' == 'none'    Log     Ignore input      ELSE    Input Text    ${textbox_qlkv_phone}    ${phone}
    Run Keyword If    '${website}' == 'none'    Log     Ignore input      ELSE    Input Text    ${textbox_qlkv_website}    ${website}
    ${contract_type}     Format String    ${contract_type}    ${contract}
    Click Element    ${combobox_contract_type}
    Wait Until Page Contains Element    ${contract_type}      20s
    Click Element    ${contract_type}
    Run Keyword If    '${maximum_branch}' == 'none'    Log     Ignore input      ELSE    Input Text    ${textbox_maximum_branch}    ${maximum_branch}
    Run Keyword If    '${maximum_product}' == 'none'    Log     Ignore input      ELSE    Input Text    ${textbox_maximum_product}    ${maximum_product}
    Run Keyword If    '${maximum_fanpage}' == 'none'    Log     Ignore input      ELSE    Input Text    ${textbox_maximum_fanpage}    ${maximum_fanpage}
    Run Keyword If    '${kiotmail}' == 'none'    Log     Ignore input      ELSE    Input Text    ${textbox_purchase_kiotmail}    ${kiotmail}
    ${industry_type}     Format String    ${item_industry_indropdown}    ${industry}
    Click Element    ${combobox_industry}
    Wait Until Page Contains Element    ${industry_type}      20s
    Click Element    ${industry_type}
    Input Text    ${textbox_startdate}    ${startdate}
    Input Text    ${textbox_enddate}    ${enddate}
    Click Element    ${checkbox_sample_data}

Input data in form Admin user
    [Arguments]    ${admin_name}    ${admin_username}   ${admin_password}
    Input Text    ${textbox_qlkv_admin_name}    ${admin_name}
    Input Text    ${textbox_admin_username}    ${admin_username}
    Input Text    ${textbox_admin_password}    ${admin_password}

Search retailer and click
    [Arguments]     ${ten_shop}
    Input data     ${textbox_keyword}      ${ten_shop}

Go to menu QLKV
    [Arguments]     ${menu}
    Reload Page
    KV Click Element By Code    ${menu_qlkv}    ${menu}

Go to menu QLKV until succeed
    [Arguments]     ${menu}
    Wait Until Keyword Succeeds    3x    2s    Go to menu QLKV   ${menu}

Click branch and wait button lock appear
    :FOR    ${time}   IN RANGE     5
    \     KV Click Element      ${cell_branch_first_row}
    \     ${status}    Run Keyword And Return Status      Wait Until Page Contains Element    ${button_lock_branch}     15s
    \     Exit For Loop If    '${status}'=='True'

Go to domain QLKV
    [Arguments]     ${menu}     ${domain}
    Go to menu QLKV   ${menu}
    KV Click Element By Code    ${menu_qlkv}    ${domain}

Go to domain QLKV until succeed
    [Arguments]     ${menu}     ${domain}
    Wait Until Keyword Succeeds    3x    2s    Go to domain QLKV       ${menu}     ${domain}

Go To Kiểm Kho
    Hover Mouse To Element    ${link_hanghoa}
    Click Element Global    ${link_kiemkho}
    Wait To Loading Icon Invisible

Go To Thiết Lập Cửa Hàng
    Hover Mouse To Element    ${icon_thietlap}
    Click Element Global    ${link_thietlapcuahang}
    Wait To Loading Icon Invisible
