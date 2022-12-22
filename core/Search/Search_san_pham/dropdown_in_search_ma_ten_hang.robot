*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          ../../share/computation.robot

*** Variables ***
${textcell_in_search_mth_tensp}    ${EMPTY}
${textcell_in_search_mth_masp}    ${EMPTY}
${text_novalue_insearch}    ${EMPTY}
${dropdown_insearch_maten}    ${EMPTY}

*** Keywords ***
Get Ten
    [Arguments]    ${input_ten_sp}
    ${input_textcell_ten}    Format String    ${textcell_in_search_mth_tensp}    ${input_ten_sp}
    ${get_textcell_ten}    Get Text    ${input_textcell_ten}
    Return From Keyword    ${get_textcell_ten}

Get MaSP
    [Arguments]    ${input_ten_sp}
    ${input_textcell_masp}    Format String    ${textcell_in_search_mth_masp}    ${input_ten_sp}
    ${get_textcell_masp}    Get Text    ${input_textcell_masp}
    Return From Keyword    ${get_textcell_masp}

Assert item in drop down list
    [Arguments]    ${input_ten_sp}    ${input_ma_sp}
    ${get_textcell_tensp}    Get Ten    ${input_ten_sp}
    Element Should Be Visible    ${get_textcell_tensp}
    Should Be Equal As Strings    ${get_textcell_tensp}    ${input_ten_sp}
    ${get_textcell_masp}    Get MaSP    ${input_ma_sp}
    Element Should Be Visible    ${get_textcell_masp}
    Should Be Equal As Strings    ${get_textcell_masp}    ${input_ma_sp}

Assert item unavailable in dropdownlist
    Element Should Contain    ${dropdown_insearch_maten}    Không tìm thấy hàng hóa nào phù hợp
