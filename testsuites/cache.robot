*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Library           ArchiveLibrary
Resource         ../config/env_product/envi.robot
Resource         ../core/login/login_action.robot

*** Test Cases ***

KV Prepare Profile Folder        [Tags]                              CACT
        Cache Chrome - Open Browser    https://autobot.kiotviet.com/
        #Login     admin      123
        sleep    20s
        Close All Browsers
