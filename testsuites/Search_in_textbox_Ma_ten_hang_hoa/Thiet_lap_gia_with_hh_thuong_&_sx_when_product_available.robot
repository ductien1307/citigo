*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../core/Hang_Hoa/hanghoa_list_search.robot
Resource          ../../core/Hang_Hoa/thiet_lap_gia_list_action.robot

*** Variables ***
@{input_data_search}    6    k    K    s    SP0126    Khăn lụa giấy

*** Test Cases ***    Bang gia      Nhom hàng                                   Ma_sp     Ten sp                   Input_Search
hh_thuong, dang kd, duoi ton, con hang trong kho
                      [Template]    Check product searching in thiet lap gia
                      #             B                                           SP0126    Khăn giấy lụa Kleenex    @{input_data_search}
                      A             B                                           SP0126    Khăn giấy lụa Kleenex    @{input_data_search}

*** Keywords ***
Check product searching in thiet lap gia
    [Arguments]    ${input_banggia}    ${nhom_hang}    ${input_ma_sp}    ${input_ten_sp}    @{input_data_search}
    [Documentation]    *hh thường*..Check: Hàng hóa thường, đang kinh doanh, dưới định mức tồn, còn hàng trong kho
    [Timeout]
    Go to Thiet lap gia
    Sleep    2s
    Select Bang gia for Bang gia    ${input_banggia}
    ${select_nhomhang}    Format String    ${textcell_nhomhang}    ${nhom_hang}
    Click Element    ${select_nhomhang}
    #loop
    : FOR    ${element}    IN    @{input_data_search}
    \    Input Text    ${textbox_search_maten}    ${element}
    \    Run Keyword If    '${element}' == 'CONTINUE'    Continue For Loop
    \    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
