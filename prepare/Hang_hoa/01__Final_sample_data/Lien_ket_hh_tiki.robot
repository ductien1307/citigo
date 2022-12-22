*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/API/api_tiki.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot

*** Test Cases ***    Shop tiki       SKU tiki            Mã sp
Lien ket              [Tags]               TIKI
                      [Template]           Mapping product with tiki thr API
                      KiotViet        HHHH22333          GHDCB001
                      KiotViet        AAA1234            GHDDV001
                      KiotViet        8439949383HHHH     GHDI001
                      KiotViet        KEIEIEKKEKE        GHDT011
                      KiotViet        67988770777        GHDU001
                      KiotViet        3534543636346      GHDI002
                      KiotViet        223FFFF54345       GHDI003
                      KiotViet        83284923959        TPG01
                      KiotViet        4533256            TPG02
                      KiotViet        990088             TPG03
                      KiotViet        OOOOOOO            HHCH02
                      KiotViet        12111841           SIM002
