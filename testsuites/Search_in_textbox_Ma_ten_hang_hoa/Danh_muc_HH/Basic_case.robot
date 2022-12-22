*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Test Template     Check combo_dichvu searching in danh muc hh
Library           SeleniumLibrary
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot
Resource          ../../../core/Hang_Hoa/hanghoa_list_search.robot

*** Test Cases ***    Ma_sp     Ten sp                   Search
search keyword theo so, chu cai lower-upper case
                      SP0126    Khăn giấy lụa Kleenex    6                        #search keyword theo số
                      SP0126    Khăn giấy lụa Kleenex    K                        #search keyword theo chữ hoa
                      SP0126    Khăn giấy lụa Kleenex    k                        #search keyword theo chữ thường
                      SP0126    Khăn giấy lụa Kleenex    s                        #search keyword theo chữ thường khi list dài
                      SP0126    Khăn giấy lụa Kleenex    SP0126                   #search đúng mã sản phẩm
                      SP0126    Khăn giấy lụa Kleenex    Khăn giấy lụa Kleenex    #search đúng tên sản phẩm

*** Keywords ***
Check product searching
    [Arguments]    ${input_ma_sp}    ${input_ten_sp}    ${input_keyword_search}
    [Timeout]
    Go To Danh Muc Hang Hoa
    sleep    1s
    Input Text    ${textbox_search_maten}    ${input_keyword_search}
    Sleep    2s
    Assert item in drop down list    ${input_ten_sp}    ${input_ma_sp}
