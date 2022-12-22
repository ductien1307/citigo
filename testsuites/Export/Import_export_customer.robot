*** Settings ***
Library           SeleniumLibrary
Suite Setup       Init Test Environment For Import Export File By UI    ${env}    ${remote}    ${account}    F
Suite Teardown    After Test Import Export
Test Timeout      3 minutes
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/global.robot
Resource          ../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../core/share/excel.robot
Resource          ../../core/API/api_khachhang.robot

*** Variables ***
${excelName}          CustomerFile.xlsx
${excelNameUpdate}    UpdateCustomerFile.xlsx
${excelPathImport}    ${EXECDIR}\\uploadfile\\ImportFile\\${excelName}
${excelPathImportUpdate}   ${EXECDIR}\\uploadfile\\ImportFile\\${excelNameUpdate}

*** Test Cases ***
Import Customer And Verify
      [Tags]        IMPKH  CTP
      [Documentation]   IMPORT/EXPORT - MHQL - IMPORT KHÁCH HÀNG BẰNG EXCEL FILE
      [template]    Import Khach Hang And Verify Ten Va SDT Va Dia Chi
      ${excelPathImport}    ${excelName}

Import Update Customer And Verify
      [Tags]        IMPKH  CTP
      [Documentation]   IMPORT/EXPORT - MHQL - UPDATE KHÁCH HÀNG BẰNG EXCEL FILE
      [template]    Import Update Khach Hang And Verify Ten Va SDT Va Dia Chi
      ${excelPathImportUpdate}    ${excelNameUpdate}

Export Customer And Verify
      [Tags]        IMPKH  CTP
      [Documentation]   IMPORT/EXPORT - MHQL - EXPORT KHÁCH HÀNG
      [template]    Export Khach Hang And Verify Ten Va SDT Va Dia Chi
      ${excelOpenedImport}

*** Keywords ***
Import Khach Hang And Verify Ten Va SDT Va Dia Chi
    [Arguments]   ${excelPathImport}    ${excelName}
    ${excelOpenedImport}   Open Excel By Python    \\uploadfile\\ImportFile\\${excelName}
    @{maKhachHang}  Get All Column Value From Speacial Row By Python   ${excelOpenedImport}    2    2
    :FOR  ${customer_code}  IN  @{maKhachHang}
    \  ${get_cus_id}    Get customer id thr API    ${customer_code}
    \  Run Keyword If    '${get_cus_id}'!='0'    Delete customer    ${get_cus_id}
    Import Khach Hang    ${excelPathImport}    ${excelName}
    Add Column Table View By Select Checkbox    ${checkbox_listview_diachi}
    Wait Until Keyword Succeeds    3 times    1 min    Check Ten Khach Hang Va SDT Va Dia Chi Sau Khi Import   ${excelOpenedImport}

Import Update Khach Hang And Verify Ten Va SDT Va Dia Chi
    [Arguments]   ${excelPathImport}    ${excelName}
    Import Khach Hang    ${excelPathImport}    ${excelName}
    ${excelOpenedImport}   Open Excel By Python    \\uploadfile\\ImportFile\\${excelName}
    Set Suite Variable    ${excelOpenedImport}    ${excelOpenedImport}
    Wait Until Keyword Succeeds    3 times    1 min    Check Ten Khach Hang Va SDT Va Dia Chi Sau Khi Import   ${excelOpenedImport}

Export Khach Hang And Verify Ten Va SDT Va Dia Chi
    [Arguments]   ${excelOpenedImport}
    ${excelNameExport}  @{maKhachHang}  Export Khach Hang After Import  ${excelOpenedImport}
    ${excelOpenedExport}  Open Excel By Python  \\uploadfile\\ExportFile\\${excelNameExport}
    Check Ten Khach Hang Va SDT Va Dia Chi Sau Khi Export  ${excelOpenedExport}
    Delete customer selected by checkbox by customer code    @{maKhachHang}
