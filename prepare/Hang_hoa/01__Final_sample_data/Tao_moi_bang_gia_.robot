*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_thietlapgia.robot

*** Test Cases ***    Bảng giá
Bang gia              [Tags]               EDH
                      [Template]           Add new price book and add all category - discount %
                      Bảng giá đặt hàng     5
                      Bảng giá hóa đơn      10

Bang gia - gg %       [Tags]               TLG
                      [Template]           Add new price book and add all category - discount %
                      Bảng giá test TLG    20

Bang gia ket hop      [Tags]               BGPV
                      [Template]           Create new pricebook with conditions combined
                      Bảng giá kết hợp     Thân thiết       tester      20

Bang gia CN           [Tags]               BGPV
                      [Template]           Create new pricebook with outlet
                      Bảng giá chi nhánh     25

Bang gia nguoi tạo     [Tags]              BGPV
                      [Template]           Create new pricebook with creator
                      Bảng giá người tạo     tester      10

Bang gia nhom KH      [Tags]               BGPV
                      [Template]           Create new pricebook with customer group
                      Bảng giá kh 1        Thân thiết       20
                      Bảng giá kh 2        Thành viên       15

Bang gia Tiki         [Tags]               TIKI
                      [Template]           Add new price book and add category and price formula
                      Bảng giá Tiki        Chuyển 1          10

Bang gia Lazada       [Tags]               LZD
                      [Template]           Add new price book and add category and price formula
                      Bảng giá Lazada      Máy KM      10

Bang gia Shopee       [Tags]               SPE
                      [Template]           Add new price book and add category and price formula
                      Bảng giá Shopee      KM hàng            10

Bang gia Sendo        [Tags]              SDO
                      [Template]           Add new price book and add category and price formula
                      Bảng giá Sendo       KM Hàng tặng       10

*** Keywords ***
Create new bang gia
    [Arguments]    ${input_ten_banggia}
    Add new bang gia    ${input_ten_banggia}

Create new pricebook with conditions combined
    [Arguments]    ${input_ten_banggia}     ${input_nhom_kh}      ${input_nguoitao}     ${giamgia}
    ${get_user_id}      Get User ID by UserName    ${input_nguoitao}
    ${get_nhom_kh_id}      Get customer group id thr API    ${input_nhom_kh}
    ${request_payload}    Format String    {{"PriceBook":{{"Id":0,"Name":"{0}","IsGlobal":false,"IsActive":true,"ForAllUser":false,"ForAllCusGroup":false,"StartDate":"2020-02-26T10:21:52.050Z","EndDate":"2025-02-25T10:21:52.050Z","price":0,"CommodityDisplayType":1,"discountTypes":{{"money":"VND","percent":"%"}},"CalcValueType":"%","CalcValue":0,"CalcZone":true,"CalcPriceType":-999999,"oparationTypes":{{"plus":"+","sub":"-"}},"oparation":"+","TotalPriceBookDetail":0,"UseAutoCreateProducts":false,"UseAutoRound":false,"UseAutoRoundValue":0,"selectedUser":[{1}],"selectedBranch":[{2}],"selectedCustomerGroup":[{3}],"defaultCalcPriceType":-999999,"calcActive":1,"PriceBookCustomerGroups":[{{"CustomerGroupId":{3}}}],"PriceBookUsers":[{{"UserId":{1}}}],"PriceBookBranches":[{{"BranchId":{2}}}]}},"IsUpdateProduct":false}}    ${input_ten_banggia}     ${get_user_id}      ${BRANCH_ID}      ${get_nhom_kh_id}
    log    ${request_payload}
    Post request thr API     /pricebook    ${request_payload}
    Add all category into price book thr API    ${input_ten_banggia}
    Reduced price for all product in pricebook thr API    ${input_ten_banggia}    ${giamgia}

Create new pricebook with outlet
    [Arguments]    ${input_ten_banggia}     ${giamgia}
    ${request_payload}    Format String    {{"PriceBook":{{"Id":0,"Name":"{0}","IsGlobal":false,"IsActive":true,"ForAllUser":true,"ForAllCusGroup":true,"StartDate":"2020-02-26T09:50:15.212Z","EndDate":"2025-02-25T09:50:15.212Z","price":0,"CommodityDisplayType":1,"discountTypes":{{"money":"VND","percent":"%"}},"CalcValueType":"%","CalcValue":0,"CalcZone":true,"CalcPriceType":-999999,"oparationTypes":{{"plus":"+","sub":"-"}},"oparation":"+","TotalPriceBookDetail":0,"UseAutoCreateProducts":false,"UseAutoRound":false,"UseAutoRoundValue":0,"selectedUser":[],"selectedBranch":[{1}],"selectedCustomerGroup":[],"defaultCalcPriceType":-999999,"calcActive":1,"PriceBookCustomerGroups":[],"PriceBookUsers":[],"PriceBookBranches":[{{"BranchId":{1}}}]}},"IsUpdateProduct":false}}    ${input_ten_banggia}     ${BRANCH_ID}
    log    ${request_payload}
    Post request thr API     /pricebook    ${request_payload}
    Add all category into price book thr API    ${input_ten_banggia}
    Reduced price for all product in pricebook thr API    ${input_ten_banggia}    ${giamgia}

Create new pricebook with creator
    [Arguments]    ${input_ten_banggia}     ${input_nguoitao}    ${giamgia}
    ${get_user_id}      Get User ID by UserName    ${input_nguoitao}
    ${request_payload}    Format String    {{"PriceBook":{{"Id":0,"Name":"{0}","IsGlobal":true,"IsActive":true,"ForAllUser":false,"ForAllCusGroup":true,"StartDate":"2020-02-26T10:06:52.993Z","EndDate":"2025-02-25T10:06:52.993Z","price":0,"CommodityDisplayType":1,"discountTypes":{{"money":"VND","percent":"%"}},"CalcValueType":"%","CalcValue":0,"CalcZone":true,"CalcPriceType":-999999,"oparationTypes":{{"plus":"+","sub":"-"}},"oparation":"+","TotalPriceBookDetail":0,"UseAutoCreateProducts":false,"UseAutoRound":false,"UseAutoRoundValue":0,"selectedUser":[{1}],"selectedBranch":[],"selectedCustomerGroup":[],"defaultCalcPriceType":-999999,"calcActive":1,"PriceBookCustomerGroups":[],"PriceBookUsers":[{{"UserId":{1}}}],"PriceBookBranches":[]}},"IsUpdateProduct":false}}    ${input_ten_banggia}     ${get_user_id}
    log    ${request_payload}
    Post request thr API     /pricebook    ${request_payload}
    Add all category into price book thr API    ${input_ten_banggia}
    Reduced price for all product in pricebook thr API    ${input_ten_banggia}    ${giamgia}

Create new pricebook with customer group
    [Arguments]    ${input_ten_banggia}     ${input_nhom_kh}      ${giamgia}
    ${get_nhom_kh_id}      Get customer group id thr API    ${input_nhom_kh}
    ${request_payload}    Format String    {{"PriceBook":{{"Id":0,"Name":"{0}","IsGlobal":true,"IsActive":true,"ForAllUser":true,"ForAllCusGroup":false,"StartDate":"2020-02-26T10:10:53.308Z","EndDate":"2025-02-25T10:10:53.308Z","price":0,"CommodityDisplayType":1,"discountTypes":{{"money":"VND","percent":"%"}},"CalcValueType":"%","CalcValue":0,"CalcZone":true,"CalcPriceType":-999999,"oparationTypes":{{"plus":"+","sub":"-"}},"oparation":"+","TotalPriceBookDetail":0,"UseAutoCreateProducts":false,"UseAutoRound":false,"UseAutoRoundValue":0,"selectedUser":[],"selectedBranch":[],"selectedCustomerGroup":[{1}],"defaultCalcPriceType":-999999,"calcActive":1,"PriceBookCustomerGroups":[{{"CustomerGroupId":{1}}}],"PriceBookUsers":[],"PriceBookBranches":[]}},"IsUpdateProduct":false}}    ${input_ten_banggia}      ${get_nhom_kh_id}
    log    ${request_payload}
    Post request thr API     /pricebook    ${request_payload}
    Add all category into price book thr API    ${input_ten_banggia}
    Reduced price for all product in pricebook thr API    ${input_ten_banggia}    ${giamgia}
