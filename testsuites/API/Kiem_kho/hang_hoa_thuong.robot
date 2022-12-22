*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Import Data From Json     ${list_test_case}
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/common/import_data.robot
Resource          ../../../core/Kiem_kho/api_kiem_kho.robot
# Resource          ../../../data/kiem_kho/hang_hoa_thuong.json
Test Template      Kiemkho

*** Variables ***
${list_test_case}    data/kiem_kho/hang_hoa_thuong.json
${CreateBy}    "%CreateBy"
${BranchId}    "%BranchId"

*** Test Cases ***    data_test    index
Test case 1           [Tags]        KKHHT
                      ${DATA_JSON}       1

Test case 2           [Tags]        KKHHT
                       ${DATA_JSON}      2

Test case 3           [Tags]        KKHHT
                       ${DATA_JSON}      3

Test case 4           [Tags]        KKHHT
                       ${DATA_JSON}      4

Test case 5           [Tags]        KKHHT
                       ${DATA_JSON}      5

Test case 6           [Tags]        KKHHT
                       ${DATA_JSON}      6

Test case 7           [Tags]        KKHHT
                       ${DATA_JSON}      7

Test case 8           [Tags]        KKHHT
                       ${DATA_JSON}      8

Test case 9           [Tags]        KKHHT
                       ${DATA_JSON}      9

Test case 10           [Tags]       KKHHT
                       ${DATA_JSON}      10

Test case 11          [Tags]        KKHHT
                       ${DATA_JSON}      11

Test case 12          [Tags]        KKHHT
                       ${DATA_JSON}      12

Test case 13          [Tags]        KKHHT
                       ${DATA_JSON}      13

Test case 14          [Tags]        KKHHT
                       ${DATA_JSON}      14

Test case 15          [Tags]        KKHHT
                       ${DATA_JSON}      15

Test case 16          [Tags]        KKHHT
                       ${DATA_JSON}      16

Test case 17          [Tags]        KKHHT
                       ${DATA_JSON}      17

*** Keywords ***
Kiemkho
    [Arguments]    ${data}    ${index}
    Post data list kiem kho    ${data}    ${index}
