*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test QLKV      admin@kiotviet.com      123456
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/QLKV/qlkv_list_action.robot
Resource          ../../core/share/Computation.robot
Resource          ../../core/API/api_qlkv.robot
Resource          ../../core/share/toast_message.robot

*** Variables ***

*** Test Cases ***  Name     Địa chỉ    Khu vực             Phường xã            Phone        Website       Contract Type     Maximum Branch   Maximum Products   Maximum Fanpages    KiotMail    Ngành hàng       Chi nhánh          Admin name  Admin user   Admin password
Tao moi shop QLKV
    [Tags]        QLKV
    [Template]    eqlkv1
    admin     1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo    0985644175    abc.com        Gói nâng cao         100             500              1                  2         Thời trang      Chi nhánh trung tâm     admin     admin       123

*** Keyword ***
eqlkv1
    [Arguments]      ${details_name}    ${address}    ${khuvuc}   ${phuongxa}       ${phone}    ${website}    ${contract}
    ...   ${maximun_branch}   ${maximun_product}   ${maximun_fanpage}   ${kiot_mail}    ${industry}     ${branch_name}    ${admin_name}   ${admin_username}   ${admin_password}
    ${domain_name}       Generate code automatically    test
    ${startdate}      Get Current Date
    ${enddate}      Add Time To Date    ${startdate}    15 days     result_format=%d/%m/%Y
    ${enddate_up}      Add Time To Date    ${startdate}    30 days     result_format=%d/%m/%Y
    ${startdate}     Convert Date    ${startdate}      result_format=%d/%m/%Y
    Wait Until Keyword Succeeds    3x    3s    Go to form add retailer
    Input data in form Detail    ${details_name}    ${address}    ${khuvuc}   ${phuongxa}   ${domain_name}     ${phone}    ${website}    ${contract}
    ...   ${maximun_branch}   ${maximun_product}   ${maximun_fanpage}   ${kiot_mail}    ${industry}    ${startdate}    ${enddate}
    Input text      ${textbox_qlkv_firstbranch_name}      ${branch_name}
    Input data in form Admin user    ${admin_name}    ${admin_username}   ${admin_password}
    Click Element     ${button_create}
    Retailer create success validation
    Search retailer and click    ${domain_name}
    Input data in form Detail    ${details_name}1    ${address}1    ${khuvuc}   ${phuongxa}   ${domain_name}1     ${phone}1    ${website}.vn    ${contract}
    ...   10   ${maximun_product}0   ${maximun_fanpage}0   ${kiot_mail}1    Điện tử - Điện máy    ${startdate}    ${enddate_up}
    Click Element     ${button_qlkv_update}
    Retailer update success validation
