*** Settings ***
Resource          so_quy_list_action.robot
Resource          so_quy_add_action.robot

*** Variables ***
${menu_soquy}     //li[a[text()='Sổ quỹ']]
${button_menu_soquy}    //*[@id='columnSelection_mn_active']
${button_menu_trangthai}    //*[@id='columnSelection_mn_active']//span/label[contains(@class, 'quickaction')]
${domain_soquy}    //ul[contains(@class,'menu')]//a[contains(text(),'Sổ quỹ')]

*** Keywords ***
Go to So quy
    Wait Until Page Contains Element    ${domain_soquy}    2 mins
    Click Element    ${domain_soquy}
    Element Should Be Enabled    ${textbox_search_ma_phieu}
