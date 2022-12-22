*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          ../share/computation.robot
Resource          api_access.robot

*** Variables ***
${endpoint_audit}    /logs?format=json&%24inlinecount=allpages&BranchIds={0}

*** Keywords ***
Get content Audit Trail
    [Timeout]     3 minute
    ${endpoint_audit_trail_by_branch}    Format String    ${endpoint_audit}    ${BRANCH_ID}
    ${content_changed}    Format String    Tạo hóa đơn: HD000080, khách hàng KH000005,Bảng giá: Bảng giá chung, giá trị: 0, thời gian: 18/07/2018 16:56:21, Trạng thái: Hoàn thành, bao gồm:- HHBK0005 : 5*0
