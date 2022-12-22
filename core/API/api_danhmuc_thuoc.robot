*** Settings ***
Resource          api_danhmuc_hanghoa.robot
Resource          api_access.robot
Resource          ../share/list_dictionary.robot
Library           StringFormat

*** Variables ***
${endpoint_danhmuc_thuoc}    /medicines?take=1000
${endpoint_hh_nha_thuoc}      /branchs/{0}/masterproducts?format=json&%24inlinecount=allpages
${endpoint_duong_dung}      /medicines/routeOfAdministration/search

*** Keywords ***
Get infor of medicine thr API
    [Arguments]       ${ten_thuoc}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_thuoc}
    ${jsonpath_ma_thuoc}    Format String    $..Data[?(@.Name=="{0}")].Code    ${ten_thuoc}
    ${jsonpath_so_dk}    Format String    $..Data[?(@.Name=="{0}")].RegistrationNo    ${ten_thuoc}
    ${jsonpath_hoat_chat}    Format String    $..Data[?(@.Name=="{0}")].ActiveElement    ${ten_thuoc}
    ${jsonpath_ham_luong}    Format String    $..Data[?(@.Name=="{0}")].Content    ${ten_thuoc}
    ${jsonpath_hang_san_xuat}    Format String    $..Data[?(@.Name=="{0}")].GlobalManufacturerName    ${ten_thuoc}
    ${jsonpath_quy_cach_dong_goi}    Format String    $..Data[?(@.Name=="{0}")].PackagingSize    ${ten_thuoc}
    ${jsonpath_don_vi}    Format String    $..Data[?(@.Name=="{0}")].Unit    ${ten_thuoc}
    ${get_ma_thuoc}       Get data from response json    ${get_resp}    ${jsonpath_ma_thuoc}
    ${get_so_dk}    Get data from response json    ${get_resp}    ${jsonpath_so_dk}
    ${get_hoat_chat}    Get data from response json    ${get_resp}    ${jsonpath_hoat_chat}
    ${get_ham_luong}    Get data from response json    ${get_resp}    ${jsonpath_ham_luong}
    ${get_hang_sx}    Get data from response json    ${get_resp}    ${jsonpath_hang_san_xuat}
    ${get_quy_cach_dong_goi}    Get data from response json    ${get_resp}    ${jsonpath_quy_cach_dong_goi}
    ${get_don_vi}    Get data from response json    ${get_resp}    ${jsonpath_don_vi}
    Return From Keyword    ${get_ma_thuoc}    ${get_so_dk}    ${get_hoat_chat}      ${get_ham_luong}      ${get_hang_sx}      ${get_quy_cach_dong_goi}    ${get_don_vi}

Assert data in case create medicine
    [Arguments]    ${input_mahang}    ${input_ten_thuoc}    ${input_nhomhang}    ${input_ton}    ${input_giavon}    ${input_giaban}    ${input_duong_dung}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_hh_nha_thuoc}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_price}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_cost}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${input_mahang}
    ${jsonpath_group}    Format String    $..Data[?(@.Code=="{0}")].CategoryName    ${input_mahang}
    ${jsonpath_duong_dung}    Format String    $..Data[?(@.Code=="{0}")].RouteOfAdministration    ${input_mahang}
    ${jsonpath_so_dk}    Format String    $..Data[?(@.Code=="{0}")].RegistrationNo    ${input_mahang}
    ${jsonpath_hoat_chat}    Format String    $..Data[?(@.Code=="{0}")].ActiveElement    ${input_mahang}
    ${jsonpath_ham_luong}    Format String    $..Data[?(@.Code=="{0}")].ActiveElement    ${input_mahang}
    ${jsonpath_hang_san_xuat}    Format String    $..Data[?(@.Code=="{0}")].GlobalManufacturerName    ${input_mahang}
    ${jsonpath_quy_cach_dong_goi}    Format String    $..Data[?(@.Code=="{0}")].PackagingSize    ${input_mahang}
    ${jsonpath_don_vi}    Format String    $..Data[?(@.Code=="{0}")].Unit    ${input_mahang}
    ${ten_thuoc}    Get data from response json    ${get_resp}    ${jsonpath_name}
    ${nhomhang}    Get data from response json    ${get_resp}    ${jsonpath_group}
    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_price}
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_cost}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${duong_dung}    Get data from response json    ${get_resp}    ${jsonpath_duong_dung}
    ${so_dk}    Get data from response json    ${get_resp}    ${jsonpath_so_dk}
    ${hoat_chat}    Get data from response json    ${get_resp}    ${jsonpath_hoat_chat}
    ${ham_luong}    Get data from response json    ${get_resp}    ${jsonpath_ham_luong}
    ${hang_sx}    Get data from response json    ${get_resp}    ${jsonpath_hang_san_xuat}
    ${quy_cach_dong_goi}    Get data from response json    ${get_resp}    ${jsonpath_quy_cach_dong_goi}
    ${don_vi}    Get data from response json    ${get_resp}    ${jsonpath_don_vi}
    ${get_ma_thuoc}    ${get_so_dk}    ${get_hoat_chat}      ${get_ham_luong}      ${get_hang_sx}      ${get_quy_cach_dong_goi}    ${get_don_vi}      Get infor of medicine thr API    ${input_ten_thuoc}
    Should Contain      ${ten_thuoc}    ${input_ten_thuoc}
    Should Be Equal As Strings    ${nhomhang}    ${input_nhomhang}
    Should Be Equal As Numbers    ${ton}    ${input_ton}
    Should Be Equal As Numbers    ${giavon}    ${input_giavon}
    Should Be Equal As Numbers    ${giaban}    ${input_giaban}
    Should Be Equal As Strings    ${duong_dung}    ${input_duong_dung}
    Should Be Equal As Strings    ${so_dk}    ${get_so_dk}
    Should Be Equal As Strings    ${hoat_chat}    ${get_hoat_chat}
    Should Be Equal As Strings    ${hang_sx}    ${get_hang_sx}
    Should Be Equal As Strings    ${quy_cach_dong_goi}    ${get_quy_cach_dong_goi}
    Should Be Equal As Strings    ${don_vi}    ${get_don_vi}

Get id duong dung thr API
    [Arguments]       ${ten_duong_dung}
    ${jsonpath_duong_dung}    Format String    $[?(@.Name=="{0}")].Id    ${ten_duong_dung}
    ${get_id_duongdung}    Get data from API    ${endpoint_duong_dung}    ${jsonpath_duong_dung}
    Return From Keyword    ${get_id_duongdung}
