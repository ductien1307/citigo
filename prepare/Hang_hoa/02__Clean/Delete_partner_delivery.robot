*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    DTGH
Delete Partner        [Template]    Delete
                      DT00001
                      DT00002
                      DT00003
                      DT00004
                      DT00005
                      DT00006
                      DT00007
                      DT00008
                      DT00009
                      DT00010
                      DT00011
                      DT00012
                      DT00013
                      DT00014
                      DT00015
                      DT00016

*** Keywords ***
Delete
    [Arguments]    ${input_ma_DTGH}
    Delete partner delivery    ${input_ma_DTGH}
