*** Settings ***
Library           SeleniumLibrary
Resource          ../share/constants.robot
Resource          ../share/global.robot

*** Variables ***
${button_thietlap}    //li[@class='setting']/a
${button_quanly_nguoidung}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Quản lý người dùng']]
${button_thieplap_cuahang}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Thiết lập cửa hàng']]
${button_quanly_mauin}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Quản lý mẫu in']]
${button_quanly_branch}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Quản lý chi nhánh']]
${button_quanly_thukhac}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Quản lý thu khác']]
${button_quanly_lichsuthaotac}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Lịch sử thao tác']]
${button_chiphi_nhaphang}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Quản lý chi phí nhập hàng']]
${button_lichsu_thaotac}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Lịch sử thao tác']]
${button_quanly_khuyenmai}    //a[contains(text(),'Quản lý khuyến mại')]
${button_quanly_mautin}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Quản lý mẫu tin']]
${button_xoadulieu_hethong}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Xóa dữ liệu hệ thống']]
${button_themmoi_all_form}    //section[contains(@class,'mainWrap')]//article[contains(@class,'headerContent')]//a[contains(@class, 'btn-success')]
${button_xoadulieu_dungthu}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Xóa dữ liệu dùng thử']]
${button_dongy_xoadulieu_dungthu}    //div[contains(@class,'kv-window-footer')]//button[text()=' Đồng ý']
${button_quanly_voucher}    //section[contains(@class, 'settingNav')]//ul/li[a[text()=' Quản lý voucher']]

*** Keywords ***
Go to Quan ly nguoi dung
    Wait Until Element Is Visible    ${button_thietlap}
    Click Element    ${button_thietlap}
    Wait Until Element Is Visible    ${button_quanly_nguoidung}
    Click Element    ${button_quanly_nguoidung}

Go to any thiet lap
    [Arguments]    ${button_can_thietlap}
    Hover Mouse To Element       ${button_thietlap}
    Click Element Global         ${button_can_thietlap}

Select dropdown anyform by double click
    [Arguments]    ${xpath_textbox}    ${xpath_dropdown}    ${value}
    Input text    ${xpath_textbox}    ${value}
    ${xpath_dropdown_location}    Format String    ${xpath_dropdown}    ${value}
    Wait Until Element Is Enabled    ${xpath_dropdown_location}
    Double Click Element    ${xpath_dropdown_location}

Select dropdown anyform
    [Arguments]    ${xpath_textbox}    ${xpath_dropdown}    ${value}
    Input text    ${xpath_textbox}    ${value}
    ${xpath_dropdown_location}    Format String    ${xpath_dropdown}    ${value}
    Wait Until Page Contains Element    ${xpath_dropdown_location}    39s
    Press Key    ${xpath_textbox}    ${ENTER_KEY}

Select combobox any form
    [Arguments]    ${xpath_dropdown}    ${xpath_cell_item}    ${value}
    ${xpath_item}    Format String    ${xpath_cell_item}    ${value}
    Click Element JS    ${xpath_dropdown}
    Wait Until Element Is Enabled    ${xpath_item}
    Sleep    1s
    Click Element JS    ${xpath_item}

Select value any form
    [Arguments]    ${xpath_icon_value}    ${xpath_textbox_value}    ${input_giatri}
    Wait Until Element Is Visible    ${xpath_icon_value}
    Click Element    ${xpath_icon_value}
    Input data    ${xpath_textbox_value}    ${input_giatri}

Select dropdown anyform and click element js
    [Arguments]    ${xpath_textbox}    ${xpath_dropdown}    ${value}
    ${xpath_dropdown_location}    Format String    ${xpath_dropdown}    ${value}
    Input text    ${xpath_textbox}    ${value}
    Wait Until Page Contains Element    ${xpath_dropdown_location}    20s
    Click Element JS    ${xpath_dropdown_location}
    Sleep    1s

Select combobox any form and click element
    [Arguments]    ${xpath_dropdown}    ${xpath_cell_item}    ${value}
    ${xpath_item}    Format String    ${xpath_cell_item}    ${value}
    Click Element    ${xpath_dropdown}
    Wait Until Page Contains Element    ${xpath_item}    30s
    Click Element    ${xpath_item}

Select combobox any form and click element JS
    [Arguments]    ${xpath_dropdown}    ${xpath_cell_item}    ${value}
    ${xpath_item}    Format String    ${xpath_cell_item}    ${value}
    Click Element JS    ${xpath_dropdown}
    Wait Until Page Contains Element    ${xpath_item}    30s
    Click Element JS    ${xpath_item}
