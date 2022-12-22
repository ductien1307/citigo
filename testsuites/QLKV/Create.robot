*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test QLKV      admin@kiotviet.com      123456
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/QLKV/qlkv_list_action.robot
Resource          ../../core/share/Computation.robot

*** Variables ***

*** Test Cases ***    Name     Địa chỉ     Khu vực     Phường xã     Phone     Website       Contract Type     Maximum Branch      Maximum Products      Maximum Fanpages    KiotMail    Chi nhánh    Admin name      Admin user      Admin password
Nha thuoc
    [Tags]    QLKV
    [Template]    eqlkv
    admin     1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo    0985632175    none      Gói nâng cao    none      none        none      none     Nhà thuốc      Chi nhánh trung tâm     admin     admin   123

Tao moi shop QLKV
    [Tags]    QLKV
    [Template]    eqlkv
    admin     1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo    0985644175    none      Gói nâng cao    none      none        none      none     Nhà thuốc      Chi nhánh trung tâm     admin     admin   123

*** Keyword ***
eqlkv
    [Arguments]     ${details_name}    ${address}    ${khuvuc}   ${phuongxa}       ${phone}    ${website}    ${contract}
    ...   ${maximun_branch}   ${maximun_product}   ${maximun_fanpage}   ${kiot_mail}    ${industry}     ${branch_name}    ${admin_name}   ${admin_username}   ${admin_password}
    ${domain_name}       Generate code automatically    test
    #${domain_name}    Generate Random String    10   [LOWER]
    ${startdate}      Get Current Date
    ${enddate}      Add Time To Date    ${startdate}    15 days     result_format=%d/%m/%Y
    ${startdate}     Convert Date    ${startdate}      result_format=%d/%m/%Y
    Go to form add retailer
    Input data in form Detail    ${details_name}    ${address}    ${khuvuc}   ${phuongxa}   ${domain_name}     ${phone}    ${website}    ${contract}
    ...   ${maximun_branch}   ${maximun_product}   ${maximun_fanpage}   ${kiot_mail}    ${industry}    ${startdate}    ${enddate}
    Input text      ${textbox_qlkv_firstbranch_name}      ${branch_name}
    Input data in form Admin user    ${admin_name}    ${admin_username}   ${admin_password}
    Click Element     ${button_create}
    Wait Until Page Contains Element    ${toast_message}      1 min
    Element Should Contain    ${toast_message}    Retailer has been created successfully
    Go To    https://${domain_name}.kvpos.com:${env}/
    Wait Until Page Contains Element    ${textbox_login_username}    1 min
    Input Text    ${textbox_login_username}    ${admin_username}
    Input Text    ${textbox_login_password}    ${admin_password}
    Wait Until Page Contains Element    ${button_quanly}    1 min
    Click Element    ${button_quanly}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${menu_tongquan}    Tổng quan
    #Wait Until Keyword Succeeds    3 times    3s    Login        ${admin_username}   ${admin_password}
    Wait Until Page Contains Element    ${menu_hh}      2 min
