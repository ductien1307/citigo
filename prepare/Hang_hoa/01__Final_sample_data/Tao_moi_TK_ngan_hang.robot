*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/soquy.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Tên tk        Số tk
Tao tk ngan hang      [Tags]        SQ
                      [Template]    Create bank account
                      Linhtkl       1234
                      Thaopt        2134
                      Vuongct       3325

Chuyen quy noi bo      [Tags]        CSQ
                      [Template]    Create bank account
                      Hoangntq              1900347347348
                      Congstk               005407093473
                      Huongstr              44509300485745
