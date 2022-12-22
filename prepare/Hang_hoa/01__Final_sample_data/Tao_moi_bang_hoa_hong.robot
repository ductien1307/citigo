*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/nhanvien.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***
Tao mói bang hoa hong     [Tags]        TS
                      [Template]    Create commission
                      Hoa hồng        Dịch vụ     GHDV003      10    % Doanh thu       GHDV004       5000    VND
