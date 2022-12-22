*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../core/API/api_thietlap.robot
Resource          ../Sources/thietlap.robot

*** Variables ***

*** Test Cases ***
Tao moi CPNH theo VND
    [Tags]    CPNH
    [Template]    Create new Supplier's charge by vnd
    CPNH1    Phí nhập 1    35000    true    false
    CPNH2    Phí nhập 2    20000    true    true
    CPNH3    Phí nhập 3    55000    false    false
    CPNH4    Phí nhập 4    40000    false    true

Tao moi CPNH theo %
    [Tags]    CPNH
    [Template]    Create new Supplier's charge by percentage
    CPNH5    Phí nhập 5    15    true    false
    CPNH6    Phí nhập 6    20    true    true
    CPNH7    Phí nhập 7    50    false    false
    CPNH8    Phí nhập 8    30    false    true

Tao moi CPNHK theo VND
    [Tags]    CPNH
    [Template]    Create new Other charge by vnd
    CPNH9    Phí nhập 9    85000    true
    CPNH10    Phí nhập 10    110000    true
    CPNH11    Phí nhập 11    15000    false
    CPNH12    Phí nhập 12    65000    false

Tao moi CPNHK theo %
    [Tags]    CPNH
    [Template]    Create new Other charge by percentage
    CPNH13    Phí nhập 13    65    true
    CPNH14    Phí nhập 14    12    true
    CPNH15    Phí nhập 15    35    false
    CPNH16    Phí nhập 16    50    false

Toggle CPNH vnd
    [Tags]    CPNH
    [Template]    Toggle supplier's charge VND
    CPNH1    false
    CPNH2    false
    CPNH3    false
    CPNH4    false

Toggle CPNH %
    [Tags]    CPNH
    [Template]    Toggle supplier's charge %
    CPNH5    false
    CPNH6    false
    CPNH7    false
    CPNH8    false

Toggle CPNHK vnd
    [Tags]    CPNH
    [Template]    Toggle other charge VND
    CPNH9    false
    CPNH10    false
    CPNH11    false
    CPNH12    false

Toggle CPNHK %
    [Tags]    CPNH
    [Template]    Toggle other charge %
    CPNH13    false
    CPNH14    false
    CPNH15    false
    CPNH16    false
