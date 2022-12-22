*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot

*** Variables ***

*** Test Cases ***    Vị trí
Thương hiệu           [Tags]        EP
                      [Template]    Add new trade mark thr API
                      Zara
                      Mac
                      Lyn
