*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          ../share/computation.robot
Resource          ../share/imei.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_nha_cung_cap.robot
Resource          ../share/list_dictionary.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../prepare/Hang_hoa/Sources/giaodich.robot

*** Variables ***
${endpoint_result_return_dashboard}   /returns?$filter=(BranchId+eq+{0}+and+Status+eq+1+and+(ReturnDate+ge+datetime%27{1}T00:00:00%27))&ForManage=true&ForSummaryRow=true&Includes=TotalPayment     #branchid - current date
${endpoint_result_sale_dashboard}   /invoices/dashboard?$filter=(BranchId+eq+{0}+and+(Status+eq+1+or+Status+eq+3)+and+(PurchaseDate+ge+datetime%27{1}T00:00:00%27))     #branchid - current date
${endpoint_top10_product_dashboard}   /reportapi/charts/product/?format=json&IsDashboard=true&viewType=ProductBySale&Filter=%7B%22TimeRange%22%3A%22month%22%2C%22timeStamp%22%3A%22{0}T04%3A14%3A43.000Z%22%7D     #current date
${endpoint_birthday_dashboard}    /customers/birthday
${endpoint_customer_link_from_dashboard}  /customers?format=json&Includes=TotalInvoiced&Includes=Location&Includes=WardName&ForManageScreen=true&ForSummaryRow=true&UsingTotalApi=true&UsingStoreProcedure=false&SwitchToOrmLite=true&%24inlinecount=allpages&InvoicedLower=0&GroupId=0&DateFilterType=alltime&NewCustomerDateFilterType=alltime&NewCustomerLastTradingDateFilterType=alltime&CustomerBirthDateFilterType=today&IsActive=true&%24filter=IsActive+eq+true
${endpoint_doanhthuthuan_theo_thang_dashoard}     /reportapi/charts/sale/?format=json&IsDashboard=true&viewType=Branch&Filter=%7B%22TimeRange%22%3A%22month%22%2C%22timeStamp%22%3A%22{0}T10%3A12%3A12.187Z%22%7D     #current date
${endpoint_doanhthuthuan_theo_ngay_dashoard}    /reportapi/charts/sale/?format=json&IsDashboard=true&viewType=PurchaseDate&Filter=%7B%22TimeRange%22%3A%22month%22%2C%22timeStamp%22%3A%22{0}T10%3A12%3A12.183Z%22%2C%22TimeType%22%3A%22dd%2FMM%2Fyyyy%22%7D
${endpoint_doanhthuthuan_theo_gio_dashoard}   /reportapi/charts/sale/?format=json&IsDashboard=true&viewType=PurchaseDate&Filter=%7B%22TimeRange%22%3A%22month%22%2C%22timeStamp%22%3A%22{0}T10%3A38%3A57.136Z%22%2C%22TimeType%22%3A%22HH%3A00%22%7D
${endpoint_doanhthuthuan_theo_thu_dashoard}     /reportapi/charts/sale/?format=json&IsDashboard=true&viewType=PurchaseDate&Filter=%7B%22TimeRange%22%3A%22month%22%2C%22timeStamp%22%3A%22{0}T10%3A58%3A30.990Z%22%2C%22TimeType%22%3A%22ddd%22%7D

*** Keywords ***
Get result sale dashboard
    [Arguments]     ${endpoint}
    [Timeout]    3 minute
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${endpoint_result}    Format String    ${endpoint}    ${BRANCH_ID}    ${date_current}
    ${get_summary}   Get data from API    ${endpoint_result}    $.Total1Value
    ${get_summary_quanlity}   Get data from API    ${endpoint_result}    $.Total
    Return From Keyword    ${get_summary}    ${get_summary_quanlity}

Get top 10 product in dashboard
    [Timeout]    3 minute
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${endpoint_top10}    Format String    ${endpoint_top10_product_dashboard}    ${date_current}
    ${resp}   Get Request and return body    ${endpoint_top10}
    ${get_list_product_top10}    Get Value From Json    ${resp}    $..Extra1
    Return From Keyword    ${get_list_product_top10}

Get total customer birthday
    [Timeout]    3 minute
    ${get_total_birthday}     Get data from API    ${endpoint_birthday_dashboard}    $.Total
    Return From Keyword    ${get_total_birthday}

Get list customer from birthday dashboard
    ${get_list_customer_frm_dashboard}     Get raw data from API    ${endpoint_customer_link_from_dashboard}    $.Data..Code
    Return From Keyword    ${get_list_customer_frm_dashboard}

Get net revenue this month in dashboard
    [Timeout]    3 minute
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${endpoint_dt}    Format String    ${endpoint_doanhthuthuan_theo_thang_dashoard}    ${date_current}
    ${resp}   Get Request and return body    ${endpoint_dt}
    Log    ${resp}
    ${get_dt_thuan}    Get Value From Json    ${resp}    $..Value
    ${get_dt_thuan}   Replace floating point    ${get_dt_thuan}
    ${get_dt_thuan}     Replace sq blackets    ${get_dt_thuan}
    Return From Keyword    ${get_dt_thuan}

Get net revenue current date in dashboard
    [Timeout]    3 minute
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${day_current}   Get Current Date      result_format=%d
    ${endpoint_dt}    Format String    ${endpoint_doanhthuthuan_theo_ngay_dashoard}    ${date_current}
    ${resp}   Get Request and return body    ${endpoint_dt}
    Log    ${resp}
    ${jsonpath_dt_theo_ngay}    Format String    $[?(@.Subject=='{0}')].Total    ${day_current}
    ${get_dt_thuan}    Get Value From Json    ${resp}    ${jsonpath_dt_theo_ngay}
    ${get_dt_thuan}   Replace floating point    ${get_dt_thuan}
    ${get_dt_thuan}     Replace sq blackets    ${get_dt_thuan}
    Return From Keyword    ${get_dt_thuan}

Get net revenue current hour in dashboard
    [Timeout]    3 minute
    [Arguments]     ${hour}
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${endpoint_dt}    Format String    ${endpoint_doanhthuthuan_theo_gio_dashoard}    ${date_current}
    ${resp}   Get Request and return body    ${endpoint_dt}
    Log to Console    ${resp}
    ${jsonpath_dt_theo_ngay}    Format String    $[?(@.Subject=='{0}')].Total    ${hour}
    ${get_dt_thuan}    Get Value From Json    ${resp}    ${jsonpath_dt_theo_ngay}
    ${get_dt_thuan}     Replace sq blackets    ${get_dt_thuan}
    Return From Keyword    ${get_dt_thuan}

Get net revenue current day in dashboard
    [Timeout]    3 minute
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${day_current}    Get Current Date      result_format=%A
    ${day_current}    Run Keyword If    '${day_current}'=='Monday'    Set Variable    T2      ELSE IF     '${day_current}'=='Tuesday'    Set Variable    T3      ELSE IF   '${day_current}'=='Wednesday'    Set Variable    T4      ELSE IF     '${day_current}'=='Thursday'    Set Variable    T5      ELSE IF     '${day_current}'=='Friday'    Set Variable    T6      ELSE IF   '${day_current}'=='Saturday'    Set Variable    T7      ELSE     Set Variable    CN
    ${endpoint_top10}    Format String    ${endpoint_doanhthuthuan_theo_thu_dashoard}    ${date_current}
    ${resp}   Get Request and return body    ${endpoint_top10}
    Log to Console    ${resp}
    ${jsonpath_dt_theo_ngay}    Format String    $[?(@.Subject=='{0}')].Total    ${day_current}
    ${get_dt_thuan}    Get Value From Json    ${resp}    ${jsonpath_dt_theo_ngay}
    ${get_dt_thuan}     Replace sq blackets    ${get_dt_thuan}
    Return From Keyword    ${get_dt_thuan}
