*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Documentation     A resource file with reusable keywords and variables.
Library           String
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Resource          ../../config/env_product/envi.robot
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/Share/discount.robot

*** Keywords ***
Check multi MHBH
    [Arguments]    ${tai_khoan}     ${keyword}
    Open Browser    ${URL}/sale/#/    ${BROWSER}    remote_url=${REMOTE_URL}    alias=${tai_khoan}1
    Open Browser    ${URL}/sale/#/    ${BROWSER}    remote_url=${REMOTE_URL}    alias=${tai_khoan}2
    Set Global Variable    ${tai_khoan}    ${tai_khoan}
    #Pass any Key Word here to check localization
    KV Localization Test    ${keyword}

KV Localization Test
    [Arguments]    ${key_word}
    Switch Browser  ${tai_khoan}1
    Run Keyword    ${key_word}    ${tai_khoan}    1
    Sleep    5s
    ${language_vi_dict}    KV Get All Text in Body as List

    Switch Browser  ${tai_khoan}2
    Run Keyword    ${key_word}    ${tai_khoan}    2
    Sleep    5s
    ${language_en_dict}    KV Get All Text in Body as List

    ${ignore_words_str}    Get File    ${EXECDIR}/testsuites/Multi lagnuage/text_ignore_words.txt
    ${ignore_words}    Split To Lines    ${ignore_words_str}

    ${language_temp_dict}    Create Dictionary
    :FOR    ${key}    IN    @{language_vi_dict}
    \    KV Check Key in Dictionary    ${language_en_dict}    ${key}
    \    KV Check Key in Dictionary    ${language_temp_dict}    ${key}
    \    KV Update Language Map Dictionary    ${language_temp_dict}    ${language_vi_dict["${key}"]}    ${language_en_dict["${key}"]}    ${key}    ${ignore_words}

    ${language_dict}    Create Dictionary
    :FOR    ${key}    IN    @{language_temp_dict}
    \    ${final_list}    Remove Duplicates    ${language_temp_dict["${key}"]}
    \    Set To Dictionary    ${language_dict}    ${key}    ${final_list}

    Log Dictionary    ${language_dict}

    #assert Localization
    ${language_map_str}    Get File    ${EXECDIR}/testsuites/Multi lagnuage/text_language_map.txt
    ${language_map}    Split To Lines    ${language_map_str}

    ${error_dict}    Create Dictionary
    :FOR    ${key}    IN    @{language_dict}
    \       ${list_language_text}    Set Variable    ${language_dict["${key}"]}
    \       ${return_value}     Check string contains words and return status     ${list_language_text}     {
    \       Run Keyword If      '${return_value}'=='Pass'       Log    ignore assert    ELSE    KV Assert Localization    ${language_dict}    ${key}    ${error_dict}    ${language_map}
    Log Dictionary    ${error_dict}
    ${error_key_length}    Get Length    ${error_dict}
    Should Be Equal As Strings    ${error_key_length}    0

Check string contains words and return status
    [Arguments]     ${string}     ${word}
    ${string}     Convert To String    ${string}
    ${match}    Run Keyword And Return Status    Should Contain    ${string}    ${word}
    ${return_value}    Set Variable If   '${match}' == 'True'    Pass     False
    Return From Keyword    ${return_value}

KV Update Language Map Dictionary
    [Arguments]       ${language_dict}    ${text_vi_list}    ${text_en_list}    ${key}    ${ignore_words}
    Log     ${text_vi_list}
    Log     ${text_en_list}
    ${vi_length}    Get Length    ${text_vi_list}
    ${en_length}    Get Length    ${text_en_list}
    :FOR    ${i}    IN RANGE    0    ${vi_length}
    \    ${word_vi}    Set Variable    ${text_vi_list[${i}]}
    \    ${word_en}    Run Keyword If    ${i}<${en_length}    Set Variable    ${text_en_list[${i}]}    ELSE    Set Variable    ${EMPTY}
    \    ${vi_en}    Set Variable    ${word_vi} ____ ${word_en}
    \    ${index}    Get Index From List    ${ignore_words}    ${vi_en}
    \    Run Keyword If    ${index}<0    Append To List    ${language_dict["${key}"]}    ${vi_en}
    \    Log    ${language_dict["${key}"]}
    Log    ${language_dict}

KV Assert Localization
    [Arguments]    ${language_dict}    ${key}    ${error_dict}    ${language_map}
    ${list_language_text}    Set Variable    ${language_dict["${key}"]}
    ${length}    Get Length    ${list_language_text}
    :FOR    ${i}    IN RANGE    0    ${length}
    \    ${pass_result}    Set Variable    True
    \    @{words}    Split String    ${list_language_text[${i}]}    ____
    \    ${word_vi}    Replace String    ${words[0]}    ${SPACE}    ${EMPTY}
    \    ${word_en}    Replace String    ${words[1]}    ${SPACE}    ${EMPTY}
    \    ${word_en}    Replace String    ${word_en}    '    ${EMPTY}
    \    ${pass_result}    Run Keyword If    '${pass_result}'=='True' and '${word_en}'=='${EMPTY}'    Set Variable    False    ELSE    Set Variable    ${pass_result}
    \    ${pass_result}    Run Keyword If    '${pass_result}'=='True' and '${word_vi}'=='${word_en}'    Set Variable    False    ELSE    Set Variable    ${pass_result}
    \    Run Keyword If    '${pass_result}'=='False'    KV Check Key in Dictionary    ${error_dict}    ${key}
    \    Run Keyword If    '${pass_result}'=='False'    Append To List    ${error_dict["${key}"]}    ${list_language_text[${i}]} !Not translated yet!
    \    #assert language by language map
    \    Run Keyword If    '${pass_result}'=='True'    KV Assert In Language Map    ${list_language_text[${i}]}    ${key}    ${error_dict}    ${language_map}

KV Assert In Language Map
    [Arguments]    ${words}    ${key}    ${error_dict}    ${language_map}
    ${index}    Get Index From List    ${language_map}    ${words}
    ${pass_result}    Run Keyword If    ${index}<0    Set Variable    False    ELSE    Set Variable    True
    Run Keyword If    '${pass_result}'=='False'    KV Check Key in Dictionary    ${error_dict}    ${key}
    Run Keyword If    '${pass_result}'=='False'    Append To List    ${error_dict["${key}"]}    ${words} !Not found in language map!

KV Get All Text in Body as List
    &{language_dict}=    Execute Javascript    function getXPath(element) { var xpath = '//' + element.parents().addBack().map(function() { var $this = $(this); var tagName = this.nodeName; return tagName; }).get().join("/").toLowerCase(); return xpath; }; var allElems = window.$("body").find("*"); var all_text = [];var all_xpath = []; allElems.each(function() { var innerText = ''; var text_nodes = $(this).contents().filter(function() { return this.nodeType === 3; }); var length = text_nodes.length; for (var c = 0; c < length; c++) { var content = text_nodes[c]; innerText += content.nodeValue; } if (innerText.indexOf("$(this)") < 0 && innerText.indexOf("ten hang-") != 0) { innerText = innerText.replace(/[\\d+]?(?:\\.\\d+)?(?:,\\d+)?(?:\\-\\d+)?(?:\\s\\-\\s\\d+)?[+%.=_]*(\\#(.*?)\\#)?(\\<(.*?)\\>)?/gs, "").replace(/\\t/g, "").replace(/\\n/g, " ").trim(); if (innerText.length > 0) { var xpath = getXPath($(this)); all_xpath.push((xpath + "@").replace("/strong@","").replace("/font@","").replace("/i@","").replace("@","")); all_text.push(innerText.replace(/\\s+/g, ' ')); } } }); var length = all_xpath.length; var dict={}; for(var i=0; i<length; i++){ if(dict[all_xpath[i]]==undefined)dict[all_xpath[i]]=[]; dict[all_xpath[i]].push(all_text[i]); }return dict;
    Log Dictionary    ${language_dict}
    [Return]    ${language_dict}

KV Check Key in Dictionary
    [Arguments]    ${dict}    ${key}
    Log    ${dict}
    ${keys}    Get Dictionary Keys    ${dict}
    ${index}    Get Index From List    ${keys}    ${key}
    ${list}    Create List
    Run Keyword If    ${index}==-1    Set To Dictionary    ${dict}    ${key}    ${list}
    Log    ${dict}
