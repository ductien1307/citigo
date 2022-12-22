*** Settings ***
Library   Collections
Resource  ../share.robot

*** Variables ***
${ENDPOINT_THEMMOI_HANGHOA}  /products

*** Keywords ***
Data thêm mới hàng hóa theo excel file
    [Arguments]  ${listData}
    ${listID}  Get All ID Categories
    ${randomID}  Random One Value In List    ${listID}
    ${data_themmoi_hanghoa}  Set Variable If
    ...  '${listData[1]}'=='${None}'  {"name":"${listData[2]}","allowsSale":true,"description":"${listData[3]}","hasVariants":true,"isActive":true,"IsRewardPoint":true,"attributes":[{"attributeName":"${listData[4]}","attributeValue":"${listData[5]}"}],"branchId":${BRANCH_ID},"inventories":[{"branchId":${BRANCH_ID},"onHand":${listData[7]},"cost":${listData[8]},"reserved":0}],"unit": "${listData[6]}", "basePrice":${listData[9]},"weight":${listData[10]}}
    ...  '${listData[2]}'=='${None}'  {"categoryId":${randomID},"allowsSale":true,"description":"${listData[3]}","hasVariants":true,"isActive":true,"IsRewardPoint":true,"attributes":[{"attributeName":"${listData[4]}","attributeValue":"${listData[5]}"}],"branchId":${BRANCH_ID},"inventories":[{"branchId":${BRANCH_ID},"onHand":${listData[7]},"cost":${listData[8]},"reserved":0}],"unit": "${listData[6]}", "basePrice":${listData[9]},"weight":${listData[10]}}
    ...  '${listData[1]}'!='${None}' and '${listData[2]}'!='${None}'  {"name":"${listData[2]}","categoryId":${randomID},"allowsSale":true,"description":"${listData[3]}","hasVariants":true,"isActive":true,"IsRewardPoint":true,"attributes":[{"attributeName":"${listData[4]}","attributeValue":"${listData[5]}"}],"branchId":${BRANCH_ID},"inventories":[{"branchId":${BRANCH_ID},"onHand":${listData[7]},"cost":${listData[8]},"reserved":0}],"unit": "${listData[6]}", "basePrice":${listData[9]},"weight":${listData[10]}}
    Return From Keyword    ${data_themmoi_hanghoa}

Thêm mới hàng hóa theo data
    [Arguments]  ${data}  ${status_code}
    ${them_hanghoa_respone}  Post Request KiotViet With Data And Return Json  ${PublicAPISession}  ${ENDPOINT_THEMMOI_HANGHOA}  ${data}  ${status_code}
    Return From Keyword    ${them_hanghoa_respone}

Get ID Product From Add Product Respone
    [Arguments]    ${them_hanghoa_respone}
    ${idProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.id
    Return From Keyword    ${idProduct}

Get Info Product From Add Product Respone
    [Arguments]    ${them_hanghoa_respone}
    ${nameProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.name
    ${categoryIdProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.categoryId
    ${descriptionProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.description
    ${attributeNameProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.attributes[0].attributeName
    ${attributeValueProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.attributes[0].attributeValue
    ${branchIDProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.inventories[0].branchId
    ${onHandProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.inventories[0].onHand
    ${costProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.inventories[0].cost
    ${basePriceProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.basePrice
    ${weightProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.weight
    ${unitProduct}  Get Value From Json KiotViet    ${them_hanghoa_respone}    $.unit
    @{list}  Create List    ${nameProduct}  ${categoryIdProduct}  ${descriptionProduct}  ${attributeNameProduct}  ${attributeValueProduct}  ${branchIDProduct}  ${onHandProduct}  ${costProduct}  ${basePriceProduct}  ${weightProduct}  ${unitProduct}
    Return From Keyword    @{list}
