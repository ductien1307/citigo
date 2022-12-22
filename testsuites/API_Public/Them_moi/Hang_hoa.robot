*** Settings ***
Library     StringFormat
Library     JSONLibrary
Resource   ../../../config/env_product/envi_publicAPI.robot
Resource   ../../../core/API_Public/share.robot
Resource   ../../../core/share/excel.robot
Resource   ../../../core/API_Public/Them_moi/Them_moi_hang_hoa.robot
Suite Setup  Init Test Environment    ${env}

*** Variables ***
${ENDPOINT_THEMMOI_HANGHOA}  /products

*** Test Cases ***
Thêm mới hàng hóa thành công    [Tags]     PUBLICAPI_TMHH
    [Documentation]   PUBLIC API
    ${worksheet}   Open Excel By Python    \\testsuites\\API_Public\\Them_moi\\ThemMoiHangHoa.xlsx
    Set Suite Variable     ${worksheet}   ${worksheet}
    ${listCase1}  Get All Row Value By Python    ${worksheet}    2
    Log  ${listCase1[0]}
    ${data}  Data thêm mới hàng hóa theo excel file    ${listCase1}
    ${respone}  Thêm mới hàng hóa theo data    ${data}  200
    ${idProduct}  Get ID Product From Add Product Respone    ${respone}
    ${listInfoRespone}  Get Info Product From Add Product Respone    ${respone}
    ${data}  Convert String to JSON    ${data}
    ${listInfoInput}  Get Info Product From Add Product Respone    ${data}
    ${responeDetailProduct}  Get Request KiotViet Return Json    ${PublicAPISession}    ${ENDPOINT_THEMMOI_HANGHOA}/${idProduct}    200
    ${listInfoOutput}  Get Info Product From Add Product Respone    ${responeDetailProduct}
    Verify Info Output And Input     ${listInfoOutput}    ${listInfoInput}
    Verify Info Output And Input     ${listInfoRespone}    ${listInfoInput}
    Delete Request KiotViet    ${PublicAPISession}    ${ENDPOINT_THEMMOI_HANGHOA}/${idProduct}    200
    ${responeDetailProduct}  Get Request KiotViet Return Json    ${PublicAPISession}    ${ENDPOINT_THEMMOI_HANGHOA}/${idProduct}    420
    ${message}  Get Value From Json KiotViet    ${responeDetailProduct}    $.responseStatus.message
    Should Be Equal    ${message}    Product Code: : ProductId: ${idProduct}, Hàng hóa được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống

Thêm mới hàng hóa không có nhóm hàng    [Tags]     PUBLICAPI_TMHH
    [Documentation]   PUBLIC API
    ${listCase1}  Get All Row Value By Python    ${worksheet}    3
    Log  ${listCase1[0]}
    ${data}  Data thêm mới hàng hóa theo excel file    ${listCase1}
    ${respone}  Thêm mới hàng hóa theo data    ${data}   420
    ${message}  Get Value From Json KiotViet    ${respone}    $.responseStatus.message
    Should Be Equal    ${message}    Nhóm hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống

Thêm mới hàng hóa không có tên sản phẩm    [Tags]     PUBLICAPI_TMHH
    [Documentation]   PUBLIC API
    ${listCase1}  Get All Row Value By Python    ${worksheet}    4
    Log  ${listCase1[0]}
    ${data}  Data thêm mới hàng hóa theo excel file    ${listCase1}
    ${respone}  Thêm mới hàng hóa theo data    ${data}   420
    ${message}  Get Value From Json KiotViet    ${respone}    $.responseStatus.message
    Should Be Equal    ${message}    Tên sản phẩm không hợp lệ
