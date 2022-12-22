*** Settings ***
Library     StringFormat
Library     JSONLibrary
Library     Collections
Resource   ../../../config/env_product/envi_publicAPI.robot
Resource   ../../../core/API_Public/share.robot
Suite Setup  Init Test Environment    ${env}

*** Variables ***
${ENDPOINT_DAT_HANG_ADD}   /orders


*** Keywords ***

*** Test Cases ***
Đặt hàng 1 sản phẩm nhiều dòng, có thanh toán và giảm giá   [Tags]     PUBLIC_API_DAT_HANG
    [Documentation]   Đặt hàng 1 SP, nhiều dòng, Có thanh toán, Giảm giá theo số tiền, Có giảm giá theo phiếu
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"paidAmount": ${payment_paid_amount},"paymentMethod": "Transfer","discount": ${bill_discount},"supplier": {"code": "NCCSO15","name": "Nhà Cung Cấp Hoa Linh","contactNumber": "0762043111","address": "223 Nguyễn Văn Linh","email": "dai.nh@kiotviet.com","comment": "Test số 1"},"surcharges": [{"code": "CHK000002","name": "Vận chuyển","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
