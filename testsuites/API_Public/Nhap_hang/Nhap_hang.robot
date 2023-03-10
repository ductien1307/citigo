*** Settings ***
Library     StringFormat
Library     JSONLibrary
Library     Collections
Resource   ../../../config/env_product/envi_publicAPI.robot
Resource   ../../../core/API_Public/share.robot
Suite Setup  Init Test Environment    ${env}
Test Setup      This Is Before Test

*** Variables ***
${ENDPOINT_NHAP_HANG_ADD}   /purchaseorders
${ENDPOINT_NHAP_HANG_LIST}  /purchaseorders
${ENDPOINT_NHAP_HANG_DELETE}  /purchaseorders
${ENDPOINT_NHAP_HANG_UPDATE}  /purchaseorders
${ENDPOINT_HANG_HOA_LIST}   /products
${ENDPOINT_HANG_HOA_DETAIL}   /products/code
${ENDPOINT_CHI_NHANH_LIST}  /branches?orderBy=id
${product_price_0}=             10000
${product_price_1}=             10000
${product_discount_0}=          2000
${product_discount_1}=          2000
${product_discount_ratio_0}=    2
${product_discount_ratio_1}=    2
${product_quantity_0}=          2
${product_quantity_1}=          2
${bill_discount}=               3000
${payment_paid_amount}=         6000
${surcharges}=                  10000
${descriptions}=                This is descriptions

*** Keywords ***
This Is Before Test
    ${product_list}=    Get Request KiotViet Return Json    ${PublicAPISession}    ${ENDPOINT_HANG_HOA_LIST}    200
    ${branch_list}=     Get Request KiotViet Return Json    ${PublicAPISession}    ${ENDPOINT_CHI_NHANH_LIST}    200
    ${product_code}=      Get Value From Json   ${product_list}    $.data[?(@.code)].code
    ${branch_id}=       Get Value From Json   ${branch_list}   $.data[?(@.id)].id
    Set Global Variable    ${product_code}    ${product_code}
    Set Global Variable    ${branch_id}    ${branch_id[0]}

Check discount by ratio
    #purchaseOrderDetails.price  * purchaseOrderDetails.discountRatio / 100 = purchaseOrderDetails.discount
    [Arguments]   ${price}   ${ratio}   ${response}
    ${value}=    Evaluate    ${price} * ${ratio} / 100
    Should Be Equal As Numbers       ${response}      ${value}

Check discount by vnd
    #Sum((purchaseOrderDetails.price-purchaseOrderDetails.discount)*purchaseOrderDetails.quantity) + surcharges.value - discount = total
    [Arguments]   ${price}   ${discount}   ${quantity}    ${surcharges}   ${bill_discount}    ${response}
    ${value}=    Evaluate    ((${price} - ${discount}) * ${quantity}) + (${surcharges} - ${bill_discount})
    Should Be Equal As Numbers       ${response}      ${value}

Set id delete
    [Arguments]   ${id}
    Set Global Variable    ${id_delete}    ${id}

Set id delete 2
    [Arguments]   ${id}
    Set Global Variable    ${id_delete2}    ${id}

Set id update
    [Arguments]   ${id}
    Set Global Variable    ${id_update}    ${id}

Get t???n kho theo branchId
    [Arguments]  ${branchId}    ${product_code}
    ${response}=    Get Request KiotViet Return Json    ${PublicAPISession}    ${ENDPOINT_HANG_HOA_DETAIL}/${product_code}    200
    ${onHand}=      Get Value From Json KiotViet    ${response}    inventories[?(@.branchId==${branchId})].onHand
    Return From Keyword    ${onHand}

Verify data input vs output
    [Arguments]   ${response}   ${TC_ID}
    ${product_id_response}=         Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.productId)].productId
    ${quantity_response}=           Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.quantity)].quantity
    ${price_response}=              Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.price)].price
    ${discount_response}=           Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.discount)].discount
    ${discount_bill_response}=      Get Value From Json   ${response}   $.discount
    ${payments_amount_response}=    Get Value From Json   ${response}   $.payments[?(@.amount)].amount
    ${totalPayment_response}=       Get Value From Json   ${response}   $.totalPayment
    ${surcharges_response}=         Get Value From Json   ${response}   $.exReturnSuppliers
    ${discountRatio_response}=      Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.discountRatio)].discountRatio
    ${total_response}=              Get Value From Json   ${response}   $.total
    ${id}=                          Get Value From Json   ${response}   $.id
    Should Be Equal As Numbers       ${price_response[0]}             ${product_price_0}
    Should Be Equal As Numbers       ${quantity_response[0]}          ${product_quantity_0}
    Should Be Equal As Numbers       ${surcharges_response[0]}        ${surcharges}
    Run Keyword if    ${TC_ID}==1
    ...    Run Keywords
    ...    Should Be Equal As Numbers       ${payments_amount_response[0]}   ${payment_paid_amount}
    ...    AND    Should Be Equal As Numbers       ${totalPayment_response[0]}      ${payment_paid_amount}
    ...    AND    Should Be Equal As Numbers       ${discount_bill_response[0]}     ${bill_discount}
    ...    AND    Check discount by vnd    ${product_price_0}    ${product_discount_0}    ${product_quantity_0}    ${surcharges}    ${bill_discount}    ${total_response[0]}
    ...    AND    Set id delete    ${id[0]}
    Run Keyword if   ${TC_ID}==2 or ${TC_ID}==3
    ...    Run Keywords
    ...    Should Be Equal As Numbers       ${payments_amount_response[0]}   ${payment_paid_amount}
    ...    AND    Should Be Equal As Numbers       ${totalPayment_response[0]}      ${payment_paid_amount}
    ...    AND    Should Be Equal As Numbers       ${discount_bill_response[0]}     ${bill_discount}
    ...    AND    Check discount by ratio    ${price_response[0]}    ${discountRatio_response[0]}    ${discount_response[0]}
    ...    AND    Check discount by ratio    ${price_response[1]}    ${discountRatio_response[1]}    ${discount_response[1]}
    ...    AND    Set id delete 2    ${id[0]}
    Run Keyword if   ${TC_ID}==2 or ${TC_ID}==3 or ${TC_ID}==5 or ${TC_ID}==6
    ...    Run Keywords
    ...    Should Be Equal As Numbers       ${price_response[1]}             ${product_price_1}
    ...    AND    Should Be Equal As Numbers       ${quantity_response[1]}          ${product_quantity_1}
    Run Keyword if   ${TC_ID}==5    Set id update     ${id[0]}

*** Test Cases ***
Nh???p h??ng cho nhi???u s???n ph???m, 1 SP 1 d??ng   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   C?? Thanh To??n - C?? gi???m gi?? tr??n phi???u - C?? gi???m gi?? cho SP
    ${onHand_before}=  Get t???n kho theo branchId    ${branch_id}    ${product_code[0]}
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"paidAmount": ${payment_paid_amount},"paymentMethod": "Transfer","discount": ${bill_discount},"supplier": {"code": "NCCSO15","name": "Nh?? Cung C???p Hoa Linh","contactNumber": "0762043111","address": "223 Nguy???n V??n Linh","email": "dai.nh@kiotviet.com","comment": "Test s??? 1"},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    Verify data input vs output      ${response}   1
    ${onHand_expected}=  Evaluate    ${onHand_before}+2
    ${onHand_after}=  Get t???n kho theo branchId    ${branch_id}    ${product_code[0]}
    Should Be Equal As Numbers    ${onHand_after}    ${onHand_expected}

Nh???p h??ng cho 1 s???n ph???m nhi???u d??ng   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   C?? Thanh To??n - C?? gi???m gi?? tr??n phi???u - C?? gi???m gi?? cho SP
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"paidAmount": ${payment_paid_amount},"paymentMethod": "Transfer","discount": ${bill_discount},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0},"discountRatio": ${product_discount_ratio_0}},{"productCode":"${product_code[0]}","quantity":${product_quantity_1},"price":${product_price_1},"discount": ${product_discount_1},"discountRatio": ${product_discount_ratio_1}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    Verify data input vs output      ${response}   2

Nh???p h??ng cho nhi???u s???n ph???m nhi???u d??ng   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   C?? Thanh To??n - C?? gi???m gi?? tr??n phi???u - C?? gi???m gi?? cho SP
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"paidAmount": ${payment_paid_amount},"paymentMethod": "Transfer","discount": ${bill_discount},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0},"discountRatio": ${product_discount_ratio_0}},{"productCode":"${product_code[1]}","quantity":${product_quantity_1},"price":${product_price_1},"discount": ${product_discount_1},"discountRatio": ${product_discount_ratio_1}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    Verify data input vs output      ${response}   3

Nh???p h??ng cho nhi???u s???n ph???m, 1 SP 1 d??ng   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   Kh??ng Thanh To??n - Kh??ng gi???m gi?? tr??n phi???u - Kh??ng gi???m gi?? cho SP
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails":[{"productCode":"${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    Verify data input vs output      ${response}   4

Nh???p h??ng cho 1 s???n ph???m nhi???u d??ng   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   Kh??ng Thanh To??n - Kh??ng gi???m gi?? tr??n phi???u - Kh??ng gi???m gi?? cho SP
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"isDraft":true,"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails":[{"productCode":"${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0}},{"productCode":"${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    Verify data input vs output      ${response}   5

Nh???p h??ng cho nhi???u s???n ph???m nhi???u d??ng   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   Kh??ng Thanh To??n - Kh??ng gi???m gi?? tr??n phi???u - Kh??ng gi???m gi?? cho SP
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails":[{"productCode":"${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0}},{"productCode":"${product_code[1]}","quantity":${product_quantity_1},"price":${product_price_1}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    Verify data input vs output      ${response}   6

Thay ?????i th??ng tin chung c???a phi???u nh???p (Kh??ng bao g???m purchaseOrderDetails)   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   C?? Thanh To??n - C?? gi???m gi?? tr??n phi???u - C?? gi???m gi?? cho SP
    ${products_info}  Set Variable
    ...   {"isDraft":true,"description":"${descriptions}","branchId":${branch_id},"purchaseOrderDetails":[]}
    ${response}=    Put Request KiotViet Return Json    ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_UPDATE}/${id_update}     ${products_info}    200
    ${description_response}=       Get Value From Json   ${response}   $.description
    Should Be Equal As Strings    ${description_response[0]}    ${descriptions}

H???y phi???u nh???p v?? h???y phi???u thanh to??n   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   H???y phi???u nh???p - H???y phi???u thanh to??n
    ${response}=    Delete Request KiotViet And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_DELETE}?id=${id_delete}    200
    ${status}=       Get Value From Json   ${response}   $.status
    Should Be Equal As Numbers    ${status[0]}    4

H???y phi???u nh???p v?? kh??ng h???y phi???u thanh to??n   [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]   H???y phi???u nh???p - Kh??ng h???y phi???u thanh to??n
    ${response}=    Delete Request KiotViet And Return Json    ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_DELETE}?id=${id_delete2}    200
    ${status}=       Get Value From Json   ${response}   $.status
    Should Be Equal As Numbers    ${status[0]}    4

###---Test Case NCC ---###
T???o m???i NCC t??? NH, Nh???p m?? , SDT, email m???i    [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]
    ${ncc_code} =   Random Number Automatically    5
    ${ncc_phone_number}=            Random Number Automatically    9
    ${ncc_email}=                   Random Email Automatically
    ${ncc_name}=                    Random Full Name Automatically
    Set Global Variable    ${ncc_code}    ${ncc_code}
    Set Global Variable    ${ncc_phone_number}    ${ncc_phone_number}
    Set Global Variable    ${ncc_email}    ${ncc_email}
    Set Global Variable    ${ncc_name}    ${ncc_name}
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"supplier": {"code": "${ncc_code}","name": "${ncc_name}","contactNumber": "${ncc_phone_number}","address": "123 Nguy???n V??n Linh","email":"${ncc_email}","comment": "Test s??? 1"},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    ${supplierName_response}=    Get Value From Json   ${response}   $.supplierName
    Should Be Equal As Strings    ${supplierName_response[0]}    ${ncc_name}

Tr??ng th??ng tin khi t???o m???i, Tr??ng email, tr??ng sdt khi t???o m???i NCC    [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"supplier": {"code": "${ncc_code}","name": "${ncc_name}","contactNumber": "${ncc_phone_number}","address": "123 Nguy???n V??n Linh","email":"${ncc_email}","comment": "Test s??? 1"},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    ${supplierCode_response}=    Get Value From Json   ${response}   $.supplierCode
    Should Be Equal As Strings    ${supplierCode_response[0]}    ${ncc_code}

Tr??ng th??ng tin khi t???o m???i, Tr??ng email, sdt m???i , ?????a ch??? v?? m?? ncc m???i    [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]
    ${ncc_code2} =   Random Number Automatically    5
    ${ncc_phone_number2}=            Random Number Automatically    9
    ${ncc_name2}=                    Random Full Name Automatically
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"supplier": {"code": "${ncc_code2}","name": "${ncc_name2}","contactNumber": "${ncc_phone_number2}","address": "123 Nguy???n V??n Linh","email":"${ncc_email}","comment": "Test s??? 1"},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    ${supplierCode_response}=    Get Value From Json   ${response}   $.supplierCode
    Should Be Equal As Strings    ${supplierCode_response[0]}    ${ncc_code}

Tr??ng th??ng tin khi t???o m???i, sdt ,email, ?????a ch??? m???i, tr??ng sdt    [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]
    ${ncc_code3} =   Random Number Automatically    5
    ${ncc_email3}=                   Random Email Automatically
    ${ncc_name3}=                    Random Full Name Automatically
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"supplier": {"code": "${ncc_code3}","name": "${ncc_name3}","contactNumber": "${ncc_phone_number}","address": "123 Nguy???n V??n Linh","email":"${ncc_email3}","comment": "Test s??? 1"},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    ${supplierCode_response}=    Get Value From Json   ${response}   $.supplierCode
    Should Be Equal As Strings    ${supplierCode_response[0]}    ${ncc_code}

Tr??ng m?? NCC khi t???o m???i    [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]
    ${ncc_code3} =   Random Number Automatically    5
    ${ncc_phone_number3}=            Random Number Automatically    9
    ${ncc_email3}=                   Random Email Automatically
    ${ncc_name3}=                    Random Full Name Automatically
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"supplier": {"code": "${ncc_code}","name": "${ncc_name3}","contactNumber": "${ncc_phone_number3}","address": "123 Nguy???n V??n Linh","email":"${ncc_email3}","comment": "Test s??? 1"},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    200
    ${supplierName_response}=    Get Value From Json   ${response}   $.supplierName
    Should Be Equal As Strings    ${supplierName_response[0]}    ${ncc_name}

Thi???u mail, sdt    [Tags]     PUBLIC_API_NHAP_HANG
    [Documentation]
    ${ncc_code4} =   Random Number Automatically    5
    ${ncc_name4}=    Random Full Name Automatically
    ${products_info}  Set Variable
    ...   {"branchId": ${branch_id},"supplier": {"code": "${ncc_code4}","name": "${ncc_name4}","address": "123 Nguy???n V??n Linh","comment": "Test s??? 1"},"surcharges": [{"code": "CHK000002","name": "V???n chuy???n","value": ${surcharges},"valueRatio": "0","isSupplierExpense": "","type": ""}],"purchaseOrderDetails" :[{"productCode": "${product_code[0]}","quantity":${product_quantity_0},"price":${product_price_0},"discount":${product_discount_0}}]}
    ${response}=   Post Request KiotViet With Data And Return Json  ${PublicAPISession}    ${ENDPOINT_NHAP_HANG_ADD}    ${products_info}    420
    ${message}  Get Value From Json KiotViet    ${response}    $.responseStatus.message
    Should Be Equal    ${message}    B???n c???n nh???p s??? ??i???n tho???i ho???c email c???a nh?? cung c???p
