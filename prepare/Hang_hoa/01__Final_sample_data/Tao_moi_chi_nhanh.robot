*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_thietlap.robot

*** Variables ***

*** Test Cases ***
Chi nhánh              [Tags]      GROUP
                      [Template]      Create new branch
                      Nhánh A       1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm       Phường Cửa Nam        0985632145
                      Nhánh B       1A Yết Kiêu     Hà Nội - Quận Hoàn Kiếm       Phường Cửa Nam        0985685145
