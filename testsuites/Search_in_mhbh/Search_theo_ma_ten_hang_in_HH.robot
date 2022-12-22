*** Settings ***
Test Setup        Before Test
Test Teardown     After Test
Test Template     Check product searching
Library           SeleniumLibrary
Resource          ../../core/share/computation.robot
Resource          ../../core/Ban Hang page menu.robot
Resource          ../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/Search/Search_san_pham/dropdown_in_mhbh.robot
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/Search/Search_san_pham/dropdown_in_search_ma_ten_hang.robot

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
    ${get_textcell_tensp}    Get Ten    ${input_ten_sp}
    Element Should Be Visible    ${get_textcell_tensp}
    Should Be Equal As Strings    ${get_textcell_tensp}    ${input_ten_sp}
    ${get_textcell_masp}    Get MaSP    ${input_ma_sp}
    Element Should Be Visible    ${get_textcell_masp}
    Should Be Equal As Strings    ${get_textcell_masp}    ${input_ma_sp}
