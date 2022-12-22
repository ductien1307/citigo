*** Settings ***
Library     SeleniumLibrary
Resource    banhang_page.robot

*** KeyWord ***
Login Man hinh quan ly
      Input Text    $xpathusername        admin
      Input Text    $xpath_pass       123

Open Browser    html:///


*** Test case ***
Tesst1
     Open Browser    url
     Login Man hinh quan ly    
