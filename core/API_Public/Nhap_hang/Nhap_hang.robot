*** Settings ***
Library   Collections
Resource  ../share.robot

*** Variables ***
${ENDPOINT_THEMMOI_HANGHOA}  /products

*** Keywords ***
Set data thêm mới nhập hàng
    [Arguments]    ${response}
    ${product_id_response}=         Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.productId)].productId
    ${quantity_response}=           Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.quantity)].quantity
    ${price_response}=              Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.price)].price
    ${discount_response}=           Get Value From Json   ${response}   $.purchaseOrderDetails[?(@.discount)].discount
    ${discount_bill_response}=      Get Value From Json   ${response}   $.discount
    ${payments_amount_response}=    Get Value From Json   ${response}   $.payments[?(@.amount)].amount
    @{list}  Create List    ${product_id_response}  ${quantity_response}  ${price_response}  ${attributeNameProduct}  ${attributeValueProduct}  ${branchIDProduct}  ${onHandProduct}  ${costProduct}  ${basePriceProduct}  ${weightProduct}  ${unitProduct}
    Return From Keyword    @{list}
