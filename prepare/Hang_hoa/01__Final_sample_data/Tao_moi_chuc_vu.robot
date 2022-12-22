*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/nhanvien.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Tên chức vụ
Tao moi chuc vu      [Tags]        TS     
                      [Template]    Create job title
                      Trưởng phòng
                      Nhân viên
