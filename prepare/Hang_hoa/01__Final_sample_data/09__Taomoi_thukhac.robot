*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        INIT
Resource          ../Sources/thietlap.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_thietlap.robot

*** Test Cases ***    Ten           Gia tri thu                           So thu tu    Tu dong dua vao HD    Hoan lai khi tra hang
Tao moi thu khac theo % HD
                      [Tags]        SURCHARGE
                      [Template]    Create new Surcharge by percentage
                      TK001         Phí VAT1                              10           1                     true                     false
                      TK002         Phí VAT2                              5            2                     true                     true
                      TK003         Phí VAT3                              10           3                     false                    false
                      TK004         Phí VAT4                              5            4                     false                    true

Tao moi thu khac theo VND
                      [Tags]        SURCHARGE
                      [Template]    Create new Surcharge by vnd
                      TK005         Phí giao hàng1                        20000        5                     true                     false
                      TK006         Phí giao hàng2                        20000        6                     true                     true
                      TK007         Phí giao hàng3                        20000        7                     false                    false
                      TK008         Phí giao hàng4                        20000        8                     false                    true

Toggle surcharge %    [Tags]        ACTIVATE
                      [Template]    Toggle surcharge percentage
                      TK001         true

Toggle surcharge vnd
                      [Tags]        ACTIVATE
                      [Template]    Toggle surcharge VND
                      TK002         true
