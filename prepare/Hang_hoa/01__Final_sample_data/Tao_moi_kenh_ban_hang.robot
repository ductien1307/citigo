*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/giaodich.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot

*** Test Cases ***
CRP
    [Tags]    CRP
    [Template]    Add new sale channel thr API
    Kênh 1
    Kênh 2
    Kênh 3
    Kênh 4
