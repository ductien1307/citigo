
*** Settings ***
Library           SeleniumLibrary
Library           DateTime
Resource          ../share/constants.robot
Resource          chamcong_list_page.robot
Resource          ../Thiet_lap/thiet_lap_nav.robot

*** Keywords ***
Select mutil shift
    [Arguments]   ${list_ca_lv}
    :FOR    ${item_ca_lv}     IN ZIP      ${list_ca_lv}
    \     Wait Until Keyword Succeeds    3 times    1s   Choose shift    ${item_ca_lv}

Choose shift
    [Arguments]     ${input_ten_ca}
    Click Element    ${cell_chonca_lamviec}
    ${locator_ca_lv}    Format String     ${item_ca_lamviec_in_dropdown}      ${input_ten_ca}
    Wait Until Page Contains Element    ${locator_ca_lv}      10s
    Click Element    ${locator_ca_lv}

Select multi employee
    [Arguments]   ${list_nhan_vien}
    :FOR    ${item_nhan_vien}     IN ZIP      ${list_nhan_vien}
    \     Input Text    ${textbox_nhanvien}    ${item_nhan_vien}
    \     Wait Until Page Contains Element    ${item_nv_in_dropdown}      30s
    \     Click Element    ${item_nv_in_dropdown}

Input data in form Dat lich lam viec khong lap lai
    [Arguments]     ${list_ca_lv}     ${input_nhan_vien}
    Wait Until Page Contains Element    ${textbox_nhanvien}   30s
    Select mutil shift    ${list_ca_lv}
    Input Text    ${textbox_nhanvien}    ${input_nhan_vien}
    Wait Until Page Contains Element    ${item_nv_in_dropdown}    30s
    Wait Until Keyword Succeeds    3 times    0.5s    Click Element    ${item_nv_in_dropdown}

Input data in form Dat lich lam viec lap lai
    [Arguments]     ${list_ca_lv}     ${input_nhan_vien}    ${input_ngaybatdau}   ${input_ngayketthuc}     ${input_songaylap}    ${input_ngaylap}
    Wait Until Page Contains Element    ${checkbox_laplai}   30s
    Click Element    ${checkbox_laplai}
    Input data      ${textbox_ngaybatdau}     ${input_ngaybatdau}
    Input_data      ${textbox_ngayketthuc}     ${input_ngayketthuc}
    Click Element    ${cell_laplaimoi}
    #${item_sogaylap}     Format String     ${item_ngay_indropdow}      ${input_songaylap}
    #Click Element    ${item_sogaylap}
    #Click Element    ${cell_ngay}
    #${item_ngaylap}      Format String     ${item_ngay_indropdow}      ${input_ngaylap}
    #Click Element    ${item_ngaylap}
    Select mutil shift    ${list_ca_lv}
    Input Text    ${textbox_nhanvien}    ${input_nhan_vien}
    Sleep    1s
    Wait Until Page Contains Element    ${item_nv_in_dropdown}    30s
    Wait Until Keyword Succeeds    3 times    0.5s    Click Element    ${item_nv_in_dropdown}

Go to Cham cong thu cong
    Click Element     ${button_thao_tac_chamcong}
    Wait Until Page Contains Element    ${button_chamcong_thucong}    10s
    Click Element    ${button_chamcong_thucong}
    Wait Until Page Contains Element    ${checkbox_vao}     20s

Go to Cham cong thu cong and choose check in, check out
    Go to Cham cong thu cong
    Click Element    ${checkbox_vao}
    Click Element    ${checkbox_ra}
    Click Element    ${button_luu_chamcong_thucong}

Go to Cham cong thu cong and select absent
    [Arguments]     ${input_nghi_lam}
    Go to Cham cong thu cong
    Click Element    ${cell_chamcong}
    Click Element     ${item_nghilam_indropdown}
    Run Keyword If    '${input_nghi_lam}'=='Có phép'      Click Element    ${checkbox_co_phep}    ELSE    Log    Ignore
    Click Element    ${button_luu_chamcong_thucong}
