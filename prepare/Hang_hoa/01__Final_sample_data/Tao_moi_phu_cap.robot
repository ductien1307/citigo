*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/nhanvien.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Tên loại phụ cấp
Tên loại phụ cấp      [Tags]        TS    
                      [Template]    Create allowance
                      Ăn trưa
                      Xăng xe
                      Độc hại
