*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Import Data From Json     ${list_test_case}
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/common/import_data.robot
Resource          ../../../core/Kiem_kho/api_kiem_kho.robot
# Resource          ../../../data/kiem_kho/hang_hoa_thuong.json
Test Template      Kiem kho hang imei

*** Variables ***
${list_test_case}    data/kiem_kho/hang_hoa_imei.json
${CreateBy}    "%CreateBy"
${BranchId}    "%BranchId"

*** Test Cases ***    data_test    index
Test case 1: Tạo phiếu kiểm tạm với hàng imei                                   [Tags]        KKIMEI
                      ${DATA_JSON}      1

Test case 2: Tạo phiếu kiểm tạm với hàng imei                                   [Tags]        KKIMEI
                       ${DATA_JSON}      2

Test case 3: Tạo phiếu kiểm tạm với hàng imei thiết lập hết tồn kho             [Tags]        KKIMEI
                       ${DATA_JSON}      3

Test case 4: Tạo phiếu kiểm tạm với hàng imei kiểm kho tăng tồn                 [Tags]        KKIMEI
                       ${DATA_JSON}      4

Test case 5: Tạo phiếu kiểm tạm với hàng imei để trống                          [Tags]        KKIMEI
                       ${DATA_JSON}      5

Test case 6: Tạo phiếu kiểm tạm với hàng imei kiểm kho tăng tồn                 [Tags]        KKIMEI
                       ${DATA_JSON}      6

Test case 7: Tạo phiếu kiểm tạm số lượng với imei không khớp nhau               [Tags]        KKIMEI
                       ${DATA_JSON}      7

Test case 8: Tạo phiếu kiểm tạm với imei trùng nhau                             [Tags]        KKIMEI
                      ${DATA_JSON}      8

Test case 9: Tạo phiếu kiểm hoàn thành với hàng imei thêm mới imei              [Tags]        KKIMEI
                       ${DATA_JSON}      9

Test case 10: Tạo phiếu kiểm hoàn thành với hàng imei                           [Tags]        KKIMEI
                      ${DATA_JSON}      10

Test case 11: Tạo phiếu kiểm hoàn thành với hàng imei thiết lập hết tồn kho     [Tags]        KKIMEI
                       ${DATA_JSON}      11

Test case 12: Tạo phiếu kiểm hoàn thành với hàng imei kiểm kho tăng tồn         [Tags]        KKIMEI
                      ${DATA_JSON}      12

Test case 13: Tạo phiếu kiểm tạm với hàng imei kiểm kho tăng tồn                [Tags]        KKIMEI
                       ${DATA_JSON}      13

Test case 14: Tạo phiếu kiểm tạm số lượng với imei không khớp nhau              [Tags]        KKIMEI
                      ${DATA_JSON}      14

Test case 15: Tạo phiếu kiểm tạm với imei trùng nhau                            [Tags]        KKIMEI
                       ${DATA_JSON}      15
*** Keywords ***
Kiem kho hang imei
    [Arguments]    ${data}    ${index}
    Post data list kiem kho hang imei    ${data}    ${index}
