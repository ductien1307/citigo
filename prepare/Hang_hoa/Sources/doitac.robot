*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           JSONLibrary
Library           StringFormat
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/API/api_khachhang.robot

*** Keywords ***
Add customers
    [Arguments]    ${makh}    ${tenkh}    ${sdt}    ${diachi}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"","tempw":"","Code":"{1}","Name":"{2}","ContactNumber":"{3}","Address":"{4}","LocationName":"","WardName":"","CustomerGroupDetails":[],"RetailerId":{5},"Uuid":""}}}}    ${BRANCH_ID}    ${makh}    ${tenkh}    ${sdt}
    ...    ${diachi}    ${retailer_id}
    log    ${data_str}
    Post request thr API    /customers    ${data_str}

Add customers without contact number
    [Arguments]    ${makh}    ${tenkh}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"","tempw":"","Code":"{1}","Name":"{2}","LocationName":"","WardName":"","CustomerGroupDetails":[],"RetailerId":{3},"Uuid":""}}}}    ${BRANCH_ID}    ${makh}    ${tenkh}
    ...      ${retailer_id}
    log    ${data_str}
    Post request thr API    /customers    ${data_str}

Add customers with customer group
    [Arguments]    ${makh}    ${tenkh}    ${nhom_kh}
    ${retailer_id}    Get RetailerID
    ${get_nhom_kh_id}     Get customer group id thr API    ${nhom_kh}
    ${data_str}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"","tempw":"","Code":"{1}","Name":"{2}","Organization":"","ContactNumber":"","LocationName":"","WardName":"","CustomerGroupDetails":[{{"GroupId":{3}}}],"RetailerId":{4},"Uuid":""}}}}    ${BRANCH_ID}    ${makh}    ${tenkh}     ${get_nhom_kh_id}    ${retailer_id}
    log    ${data_str}
    Post request thr API    /customers    ${data_str}

Add customer with address
    [Arguments]    ${input_khuvuc}    ${input_phuongxa}    ${input_ma_kh}    ${input_ten_kh}    ${input_sdt}    ${input_ngaysinh}
    ...    ${input_diachi}    ${input_gioitinh}
    ${request_payload}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"{1}","tempw":"{2}","Code":"{3}","Name":"{4}","ContactNumber":"{5}","BirthDate":"{6}","Address":"{7}","LocationName":"Hà Nội - Quận Hoàng Mai","WardName":"Phường Hoàng Liệt","LocationId":244,"Gender":{8},"CustomerGroupDetails":[],"RetailerId":307027,"Uuid":"a445b010-51fa-4a59-9d16-a4dfae4257ba"}}}}    ${BRANCH_ID}    ${input_khuvuc}    ${input_phuongxa}    ${input_ma_kh}
    ...    ${input_ten_kh}    ${input_sdt}    ${input_ngaysinh}    ${input_diachi}    ${input_gioitinh}
    log    ${request_payload}
    Post request thr API    /customers    ${request_payload}

Add customer with birthday
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${input_ngaysinh}
    ${request_payload}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"","tempw":"","Code":"{1}","Name":"{2}","ContactNumber":"","BirthDate":"{3}","Address":"","LocationName":"","WardName":"","CustomerGroupDetails":[],"RetailerId":307027,"Uuid":""}}}}    ${BRANCH_ID}    ${input_ma_kh}
    ...    ${input_ten_kh}    ${input_ngaysinh}
    log    ${request_payload}
    Post request thr API    /customers    ${request_payload}

Add partner delivery
    [Arguments]    ${input_ma_dtgh}    ${input_ten_dtgh}    ${input_sdt}
    ${data_payload}    Format String    {{"PartnerDelivery":{{"Type":0,"temploc":"","tempw":"","Code":"{0}","Name":"{1}","ContactNumber":"{2}","PartnerDeliveryGroupDetails":[],"RetailerId":307027,"LocationName":"","WardName":""}}}}    ${input_ma_dtgh}    ${input_ten_dtgh}    ${input_sdt}
    log    ${data_payload}
    Post request thr API    /partnerdelivery    ${data_payload}

Delete partner delivery
    [Arguments]    ${input_ma_dtgh}
    ${jsonpath_id_dtgh}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_dtgh}
    ${get_id_dtgh}    Get data from API    ${endpoint_dtgh}    ${jsonpath_id_dtgh}
    ${endpoint_delete_partners}    Format String    ${endpoint_delete_partner}    ${get_id_dtgh}
    Delete request thr API    ${endpoint_delete_partners}

Add supplier
    [Arguments]    ${input_ma_ncc}    ${input_ten_ncc}    ${input_sdt}
    ${data_payload}    Format String    {{"Supplier":{{"Type":0,"temploc":"","tempw":"","Code":"{0}","Name":"{1}","Phone":"{2}","RetailerId":307027,"LocationName":"","WardName":"","SupplierGroupDetails":[]}}}}    ${input_ma_ncc}    ${input_ten_ncc}    ${input_sdt}
    log    ${data_payload}
    Post request thr API    /suppliers    ${data_payload}

Delete suplier
    [Arguments]    ${input_ma_ncc}
    ${jsonpath_id_ncc}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_ncc}
    ${get_id_ncc}    Get data from API    ${endpoint_ncc}    ${jsonpath_id_ncc}
    ${endpoint_delete_ncc}    Format String    ${endpoint_delete_suppliers}    ${get_id_ncc}
    Delete request thr API    ${endpoint_delete_ncc}

Get Customer ID
    [Arguments]    ${input_bh_ma_kh}
    ${json_path_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_bh_ma_kh}
    ${get_khachhang_id}    Get data from API    ${endpoint_khachhang}    ${json_path_id}
    Return From Keyword    ${get_khachhang_id}

Add customers group and filter total sale
    [Arguments]    ${input_ten_group}   ${input_giatri_tongtien}    ${input_discount_vnd}    ${input_discount_%}    ${input_discoun_type}
    ${result_discountvalue}   Set Variable If    "${input_discount_vnd}" == "null"    ${input_discount_%}    ${input_discount_vnd}
    ${data_str}    Format String    {{"CustomerGroup":{{"Id":0,"Name":"{0}","Description":"","filters":[{{"FieldName":"TotalRevenue","Operator":0,"Value":{1},"DataType":"number"}}],"Discount":{2},"DiscountRatio":{3},"CompareName":"","CompareDiscount":null,"CompareDiscountRatio":null,"typeUpdateList":"1","isSystemAutoUpdate":true,"DiscountType":"{4}","DiscountValue":{5},"Filter":"[{{\\"FieldName\\":\\"TotalRevenue\\",\\"Operator\\":0,\\"Value\\":{1},\\"DataType\\":\\"number\\",\\"$$hashKey\\":\\"object:5622\\"}}]","TypeUpdate":5}}}}    ${input_ten_group}   ${input_giatri_tongtien}    ${input_discount_vnd}    ${input_discount_%}    ${input_discoun_type}    ${result_discountvalue}
    log    ${data_str}
    Post request thr API    /customers/group    ${data_str}

Add customers group
    [Arguments]    ${input_ten_group}
    ${data_str}    Format String    {{"CustomerGroup":{{"Id":0,"Name":"{0}","Description":"","filters":[],"Discount":null,"DiscountRatio":null,"CompareName":"","CompareDiscount":null,"CompareDiscountRatio":null,"typeUpdateList":1,"isSystemAutoUpdate":0,"DiscountType":"VND","Filter":"[]","TypeUpdate":1}}}}    ${input_ten_group}
    log    ${data_str}
    Post request thr API    /customers/group    ${data_str}
