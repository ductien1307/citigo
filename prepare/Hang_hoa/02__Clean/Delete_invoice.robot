*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Mã HH
Invoice               [Tags]        CLEANINVOICE
                      [Template]    Delete_invoice
                      HD001012
                      HD001011
                      HD001010
                      HD001009
                      HD001008
                      HD001007
                      HD001006
                      HD001005
                      HD001004
                      HD001003
                      HD001002
                      HD001001
                      HD001000
                      HD000999
                      HD000998
                      HD000997
                      HD000996
                      HD000995
                      HD000994
                      HD000993
                      HD000992
                      HD000991
                      HD000990

*** Keywords ***
Delete_invoice
    [Arguments]    ${input_invoice_code}
    Delete invoice by invoice code    ${input_invoice_code}
