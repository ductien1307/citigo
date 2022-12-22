*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        NEG
Resource          ../../Hang_hoa/Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot

*** Test Cases ***    Ma SP         So luong
THD                   [Tags]        THD
                      [Template]    Create normal invoice
                      ATDD00001      1
                      ATDD00002      1
                      ATDD00003      1
                      ATDD00004      1

THD1                  [Tags]        THD
                      [Template]    Create multiple prducts invoice
                      ATDD00001      ATDD00002
                      ATDD00003      ATDD00004

THD                   [Tags]        THD
                      [Template]    Create delivery invoice
                      ATDD00009      1

THD                   [Tags]        THD
                      [Template]    Create normal invoice
                      ATDD00012      1
                      ATDD00013      1

UHD                   [Tags]        THD
                      [Template]    Deactive a product
                      ATDD00009

DHD                   [Tags]        THD
                      [Template]    Delete a Product
                      ATDD00013
