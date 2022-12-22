*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/branch_list_page.robot
Resource         ../../../core/Thiet_lap/branch_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_khachhang.robot
Resource         ../../../core/API/api_soquy.robot
Resource         ../../../core/API/api_access.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../prepare/Hang_hoa/Sources/doitac.robot

*** Test Cases ***      Mã KH         Tên KH       ĐT         Địa chỉ       ĐT new        Giới tính       Thao tác    Function name
Cap nhat khach hang     [Tags]                  TL
                        [Template]    updatecus
                        CTKH00N       Nam         0912754450    Hà Nội       0989998120     Nam           Cập nhật      Khách hàng

Xoa phieu chi          [Tags]                  TL
                      [Template]    delete
                      CTKH149       Thu 1     50000     Sổ quỹ      Hủy

*** Keywords ***
updatecus
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}      ${input_phone}      ${input_address}      ${input_phone_new}   ${input_gioitinh}
    ...    ${input_thaotac}    ${function_name}
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Add customers    ${input_ma_kh}    ${input_ten_kh}      ${input_phone}      ${input_address}
    ${content}    Format String     CậpnhậtthôngtinkháchhàngmãKH:{0},tênKH:{1},điệnthoại:{2}->{3},giớitính:{4}   ${input_ma_kh}    ${input_ten_kh}   ${input_phone}
    ...      ${input_phone_new}   ${input_gioitinh}
    ## update customer
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${request_payload}    Format String    {{"Customer":{{"Id":{0},"Type":0,"Code":"{1}","Name":"{2}","ContactNumber":"{3}","Email":"","Address":"{4}","RetailerId":{5},"CreatedDate":"2019-12-24T15:37:20.3030000+07:00","CreatedBy":{6},"LocationName":"","Uuid":"","IsActive":true,"BranchId":{7},"WardName":"","isDeleted":false,"Revision":"AAAAADEZW2o=","SearchNumber":"{8}","CustomerGroupDetails":[],"CustomerSocials":[],"AddressBooks":[],"PaymentAllocation":[],"IdOld":0,"CompareCode":"{1}","CompareName":"{2}","GenderName":"","MustUpdateDebt":false,"MustUpdatePoint":false,"InvoiceCount":0,"temploc":"","tempw":"","Gender":{9},"Organization":""}}}}    ${get_id_kh}    ${input_ma_kh}    ${input_ten_kh}      ${input_phone_new}      ${input_address}    ${get_id_nguoitao}    ${get_id_nguoiban}     ${BRANCH_ID}
    ...      ${input_phone}     1
    Log    ${request_payload}
    Post request thr API    /customers    ${request_payload}
    Sleep     4s
    ## validate lich su thao tac
    ${date_current}    Get Current Date    result_format=%Y-%m-%d
    ${endpoint_audittrail_detail}    Format String    ${endpoint_audittrail_detail}    ${BranchID}    ${input_ma_kh}    ${date_current}
    ${response_audittrail_info}    Get Request and return body    ${endpoint_audittrail_detail}
    ${jsonpath_id_nhanvien}    Format String    $.Data[?(@.FunctionName =='{0}')].UserId    ${function_name}
    ${jsonpath_thoigian}    Format String    $.Data[?(@.FunctionName =='{0}')].CreatedDate    ${function_name}
    ${jsonpath_thaotac}    Format String    $.Data[?(@.FunctionName =='{0}')].ActionName    ${function_name}
    ${jsonpath_id_chinhanh}    Format String    $.Data[?(@.FunctionName =='{0}')].BranchId    ${function_name}
    ${jsonpath_id_noidung}    Format String    $.Data[?(@.FunctionName =='{0}')].SubContent    ${function_name}
    ${get_lstt_id_nv}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_nhanvien}
    ${get_lstt_thoigian}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thoigian}
    ${time_cut}    Replace String    ${get_lstt_thoigian}    0000+07:00    ${EMPTY}
    ${get_lstt_thoigian}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%Y-%m-%d
    ${get_lstt_thaotac}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thaotac}
    ${get_lstt_id_chinhanh}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_chinhanh}
    ${get_subcontent}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_noidung}
    ${get_subcontent}   Replace String  ${get_subcontent}   ${SPACE}    ${EMPTY}
    Should Be Equal As Numbers    ${get_lstt_id_nv}    ${get_id_nguoiban}
    Should Be Equal As Strings    ${get_lstt_thoigian}    ${date_current}
    Should Be Equal As Strings    ${get_lstt_thaotac}    ${input_thaotac}
    Should Be Equal As Numbers    ${get_lstt_id_chinhanh}    ${BRANCH_ID}
    Should Be Equal As Strings    ${get_subcontent}    ${content}
    Delete customer    ${get_id_kh}

delete
      [Arguments]    ${input_ma_kh}    ${input_loai_thuchi}   ${input_giatri}    ${function_name}   ${input_thaotac}
      ${result_giatri}    Minus   0    ${input_giatri}
      ${ma_phieu}    Add cash flow in tab Tien mat for customer and not used for financial reporting    ${input_ma_kh}    ${input_loai_thuchi}
      ...    ${result_giatri}    0
      ${giatri}   Set Variable    -50,000
      ${content}    Format String     Hủy phiếu chi: {0}, giá trị: {1}    ${ma_phieu}    ${giatri}
      ## update customer
      Delete payment for cutomer not used for financial reporting thr API    ${ma_phieu}
      Sleep   10s
      ## validate lich su thao tac
      ${get_id_nguoiban}    Get User ID
      ${date_current}    Get Current Date    result_format=%Y-%m-%d
      ${endpoint_audittrail_detail}    Format String    ${endpoint_audittrail_detail}    ${BranchID}    ${ma_phieu}    ${date_current}
      ${response_audittrail_info}    Get Request and return body    ${endpoint_audittrail_detail}
      ${jsonpath_id_nhanvien}    Format String    $.Data[?(@.FunctionName =="{0}")].UserId    ${function_name}
      ${jsonpath_thoigian}    Format String    $.Data[?(@.FunctionName =="{0}")].CreatedDate    ${function_name}
      ${jsonpath_thaotac}    Format String    $.Data[?(@.FunctionName =='{0}')].ActionName    ${function_name}
      ${jsonpath_id_chinhanh}    Format String    $.Data[?(@.FunctionName =='{0}')].BranchId    ${function_name}
      ${jsonpath_id_noidung}    Format String    $.Data[?(@.FunctionName =='{0}')].SubContent    ${function_name}
      ${get_lstt_id_nv}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_nhanvien}
      ${get_lstt_thoigian}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thoigian}
      ${time_cut}    Replace String    ${get_lstt_thoigian}    0000+07:00    ${EMPTY}
      ${get_lstt_thoigian}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%Y-%m-%d
      ${get_lstt_thaotac}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thaotac}
      ${get_lstt_id_chinhanh}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_chinhanh}
      ${get_subcontent}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_noidung}
      Should Be Equal As Numbers    ${get_lstt_id_nv}    ${get_id_nguoiban}
      Should Be Equal As Strings    ${get_lstt_thoigian}    ${date_current}
      Should Be Equal As Strings    ${get_lstt_thaotac}    ${input_thaotac}
      Should Be Equal As Numbers    ${get_lstt_id_chinhanh}    ${BRANCH_ID}
      Should Be Equal As Strings    ${get_subcontent}    ${content}
