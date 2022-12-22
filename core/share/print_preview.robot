*** Settings ***
Library           SeleniumLibrary
Resource          constants.robot
Resource          javascript.robot

*** Variables ***
${button_print}    //div[contains(@class, 'header')]//li[contains(@class, 'print-button')]//a
${toggle_print}    //span[@title='Tắt chế độ tự động in']
${toggle_print_warranty}    //span[@ng-click='vm.toggleAutoPrintGuarantee()']
*** Keywords ***
Deactivate print preview page
    Click Element JS    ${button_print}
    Click Element JS    ${toggle_print}
    Comment    Press Key    ${toggle_print}    ${ESC_KEY}

Deactivate print delivery
    Click Element JS    ${button_print}
    Click Element JS    ${toggle_print}
    Comment    Press Key    ${toggle_print}    ${ESC_KEY}

Deactivate print warranty and preview page
    Click Element JS    ${button_print}
    Click Element JS    ${toggle_print}
    Click Element JS    ${button_print}
    Click Element JS    ${toggle_print_warranty}
    Comment    Press Key    ${toggle_print}    ${ESC_KEY}
