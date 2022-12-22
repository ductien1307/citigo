*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        INIT
Resource          ../Sources/doitac.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Ten nhom hang
Nhom KH        [Tags]                     PROMOTION
                      [Template]                   Add customers group and filter total sale
                      Nhóm khách VIP        500000      null      0      %

BGPV           [Tags]       BGPV
                      [Template]           Add customers group
                      Thân thiết
                      Thành viên
