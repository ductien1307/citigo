*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/API/api_lazada.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot

*** Test Cases ***    Shop Lazada       SKU Lazada                Mã sp
Lien ket              [Tags]              #LZD
                      [Template]          Mapping product with Lazada thr API
                      KiotViet           410E                    GHDCB003
                      KiotViet           410F                    GHDDV003
                      KiotViet           SP000110                GHDU004
                      KiotViet           Otek M437RB             GHDT001
                      KiotViet           1                       GHDCB004
                      KiotViet           SP000124                GHDDV004
                      KiotViet           LPQ80                   GHDU005
                      KiotViet           SP000136                GHDT002
                      KiotViet           Otek M437RC             GHDI005
                      KiotViet           Otek M437RD             GHDI006
                      KiotViet           V9                      TPG05

Lien ket              [Tags]               LZD
                      [Template]          Mapping product with Lazada thr API
                      KiotViet                V9                         TPG05
                      KiotViet                RT-410                     HTKM01
                      KiotViet                KV_LZD_240                 TP232
                      TEST SELLER 3           t630                       GHDCB003
                      TEST SELLER 3           chancua hinh chiec la 11   GHDDV003
                      TEST SELLER 3           piano1211                  GHDU004
                      TEST SELLER 3           bepnuong 3                 GHDT001
                      TEST SELLER 3           kep23                      GHDCB004
                      TEST SELLER 3           den101                     GHDDV004
                      TEST SELLER 3           keo22                      GHDU005
                      TEST SELLER 3           ketsatx                    GHDT002
                      TEST SELLER 3           xongtd                     GHDI005
                      TEST SELLER 3           khodai                     GHDI006
