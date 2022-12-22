*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        INIT
Resource          ../../Hang_hoa/Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Ten nhom hang
TNH                   [Tags]                       THD
                      [Template]                   Add categories thr API
                      Hàng gia dụng
