*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/nhanvien.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Tên loại giảm trừ
Tên loại giảm trừ      [Tags]        TS   
                      [Template]    Create deduction
                      Đi muộn
                      Không mặc đồng phục
                      Vi phạm kỷ luật
