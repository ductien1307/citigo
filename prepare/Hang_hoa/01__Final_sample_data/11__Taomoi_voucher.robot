*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        INIT
Resource          ../Sources/thietlap.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_thietlap.robot
Library           DateTime

*** Test Cases ***    Code          Ten dot phat hanh         Menh gia           Tong tien hang
Tao moi dot phat hanh voucher
                      [Tags]        VOUCHER
                      [Template]      Create voucher issue
                      VOUCHER003         Đợt voucher 001              500000           800000
                      #VOUCHER11         Đợt voucher 001              500000           800000


Tao moi voucher
                      [Tags]        ADDVOUCHER
                      [Template]      Add new voucher code
                      VOUCHER001        3
