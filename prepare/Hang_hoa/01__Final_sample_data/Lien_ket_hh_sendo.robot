*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/API/api_sendo.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot

*** Test Cases ***    Shop Sendo           SKU Sendo                 Mã sp
Lien ket              [Tags]               SDO
                      [Template]           Mapping product with sendo thr API
                      KiotViet             SD0508005                        TP022
                      KiotViet             SD000014                         HKM006
                      KiotViet             SD000008                         TP015
                      KiotViet             SD019110300                      KLCB004
                      KiotViet             290692159-1561373010648-0        KLDV004
                      KiotViet             20                               KLQD004
                      KiotViet             10                               KLT0004
                      KiotViet             SP35346451                       KLSI0004
                      KiotViet             thunhun533                       KLSI0005
                      KiotViet             SP0035170                        KLCB005
                      KiotViet             SD000010-7                       KLDV005
                      KiotViet             SP003527                         KLQD005
                      KiotViet             SDO020554584                     KLT0005
                      #KiotViet             bookvalue1HK431                  SIM002
