*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot

*** Variables ***

*** Test Cases ***    Vị trí
Vi tri                [Tags]        EP
                      [Template]    Add shelve thr API
                      Vị trí 1
                      Vị trí 2
                      Vị trí 3
                      Vị trí 4
                      Vị trí 5
