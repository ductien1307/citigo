Before Test QL Hoa don
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Hoa don
