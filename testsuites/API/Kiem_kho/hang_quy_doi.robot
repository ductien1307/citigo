*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Import Data From Json     ${list_test_case}
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/common/import_data.robot
Resource          ../../../core/Kiem_kho/api_kiem_kho.robot
# Resource          ../../../data/kiem_kho/hang_hoa_thuong.json
Test Template      Kiem kho hang quy doi

*** Variables ***
${list_test_case}    data/kiem_kho/hang_quy_doi.json
${CreateBy}    "%CreateBy"
${BranchId}    "%BranchId"

*** Test Cases ***    data_test    index
Test case 1: Tạo phiếu kiểm tạm với hàng quy đổi                                [Tags]        KKQD
                      ${DATA_JSON}      1

Test case 2: Tạo phiếu kiểm tạm với hàng đơn vị tính và hàng quy đổi           [Tags]        KKQD
                      ${DATA_JSON}      2
