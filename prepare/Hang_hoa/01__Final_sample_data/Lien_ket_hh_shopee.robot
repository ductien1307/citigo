*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/API/api_shopee.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot

*** Test Cases ***    Shop shopee          SKU shopee             Mã sp
Lien ket              [Tags]               SPE
                      [Template]           Mapping product with shopee thr API
                      thanhptk             BMD001                 TPC001
                      thanhptk             TIKKKKKKK              TPC002
                      thanhptk             CVAT004                TPC003
                      thanhptk             CA0005                 TPC005
                      thanhptk             CVAT003                GHIM05
                      thanhptk             HK000004               GHIM02
                      thanhptk             SP000065               PIB10015
                      thanhptk             SP00035                TP231
                      thanhptk             SPETH218               KLDV004
                      thanhptk             SPETH219               KLCB004
                      thanhptk             SPETH221               KLQD004
