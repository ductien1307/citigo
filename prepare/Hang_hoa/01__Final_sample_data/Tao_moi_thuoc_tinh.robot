*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot

*** Variables ***

*** Test Cases ***    Thuộc tính
Thuoc tinh            [Tags]        EP
                      [Template]    Add attribute thr API
                      Màu sắc
                      Size
                      Chất liệu
                      Kích thước
