*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/soquy.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Loại thu chi    Hạch toán vào KQHHKD
Loai thu              [Tags]          SQ
                      [Template]      Create receipt category
                      Thu 1           true
                      Thu 2           true
                      Thu 3           true
                      Thu 4           false
                      Thu 5           false

Loai chi              [Tags]          SQ
                      [Template]      Create payment category
                      Chi 1           true
                      Chi 2           true
                      Chi 3           true
                      Chi 4           false
                      CHi 5           false
