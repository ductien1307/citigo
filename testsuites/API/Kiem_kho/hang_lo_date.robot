*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Import Data From Json     ${list_test_case}
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/common/import_data.robot
Resource          ../../../core/Kiem_kho/api_kiem_kho.robot
# Resource          ../../../data/kiem_kho/hang_hoa_thuong.json
Test Template      Kiem kho hang lo date

*** Variables ***
${list_test_case}    data/kiem_kho/hang_hoa_lodate.json
${CreateBy}    "%CreateBy"
${BranchId}    "%BranchId"

*** Test Cases ***    data_test    index
Test case 1: Tạo phiếu kiểm tạm với hàng Lodate có tồn kho trong hệ thống       [Tags]        KKLD
                       ${DATA_JSON}      1

Test case 2: Tạo phiếu kiểm tạm với hàng Lodate thiết lập hết tồn               [Tags]        KKLD
                       ${DATA_JSON}      2

Test case 3: Tạo phiếu kiểm tạm với hàng Lodate để trống số tồn thực tế         [Tags]        KKLD
                       ${DATA_JSON}      3

Test case 4: Tạo phiếu kiểm tạm với hàng Lodate thêm Lô hạn sử dụng             [Tags]        KKLD
                       ${DATA_JSON}      4

Test case 5: Tạo phiếu kiểm tạm với hàng Lodate thêm nhiều Lô hạn sử dụng       [Tags]        KKLD
                       ${DATA_JSON}      5

Test case 6: Tạo phiếu kiểm tạm với hàng Lodate có tồn kho số tồn kho số lượng thực tế và số lượng của lô không khớp           [Tags]        KKLD
                       ${DATA_JSON}      6

Test case 7: Tạo phiếu kiểm tạm với hàng Lodate với Lô bị trùng                 [Tags]        KKLD
                       ${DATA_JSON}      7

Test case 8: Tạo phiếu kiểm tạm với 2 hàng Lodate có mã sản phẩm bị trùng       [Tags]        KKLD
                       ${DATA_JSON}      8

Test case 9: Tạo phiếu kiểm trạng thái hoàn thành với hàng Lodate có tồn kho trong hệ thống           [Tags]        KKLD
                       ${DATA_JSON}      9

Test case 10: Tạo phiếu kiểm trạng thái hoàn thành với hàng Lodate thiết lập hết tồn                  [Tags]        KKLD
                       ${DATA_JSON}      10

Test case 11: Tạo phiếu kiểm hoàn thành với hàng Lodate thêm Lô hạn sử dụng     [Tags]        KKLD
                       ${DATA_JSON}      11

Test case 12: Tạo phiếu kiểm hoàn thành với hàng Lodate thêm nhiều Lô hạn sử dụng                     [Tags]        KKLD
                       ${DATA_JSON}      12

Test case 13: Tạo phiếu kiểm tạm với hàng Lodate có tồn kho số tồn kho số lượng thực tế và số lượng của lô không khớp          [Tags]        KKLD
                       ${DATA_JSON}      13

Test case 14: Tạo phiếu kiểm tạm với hàng Lodate có tồn kho với trùng LÔ        [Tags]        KKLD
                       ${DATA_JSON}      14

Test case 15: Tạo phiếu kiểm tạm với hàng Lodate có mã sản phẩm bị trùng        [Tags]        KKLD
                       ${DATA_JSON}      15
