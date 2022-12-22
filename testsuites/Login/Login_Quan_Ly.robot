*** Settings ***
Test Setup        Before Test Login
Test Teardown     After Test
Test Template     Input data login
Resource          ../../core/login/login_action.robot
Resource          ../../core/Tong_Quan/Tongquan_navigation.robot

*** Test Cases ***    USER      PASSWORD          EXPECT
Valid Login           admin     123               OK

Invalid Login         123456    kiotviet123456    Sai Tên đăng nhập hoặc mật khẩu!
                      admin     123456            Sai Tên đăng nhập hoặc mật khẩu!
                      123456    !@$%^&*()         Sai Tên đăng nhập hoặc mật khẩu!

*** Keywords ***
Input data login
    [Arguments]    ${user}    ${password}    ${expect}
    Login    ${user}    ${password}
    Run Keyword If    '${expect}' == 'OK'    Assert success text
    ...    ELSE    Assert failure text    ${expect}
