*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Mã NCC
Delete NCC            [Template]    Delete
                      NCC0001
                      NCC0002
                      NCC0003
                      NCC0004
                      NCC0005
                      NCC0006
                      NCC0007
                      NCC0008
                      NCC0009
                      NCC0010

*** Keywords ***
Delete
    [Arguments]    ${input_ma_ncc}
    Delete suplier    ${input_ma_ncc}
