*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/nhanvien.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Tên phòng ban
Tao mói phòng ban     [Tags]        TS
                      [Template]    Create department
                      Phòng kế toán
                      Phòng hành chính
                      Phòng nhân sự
