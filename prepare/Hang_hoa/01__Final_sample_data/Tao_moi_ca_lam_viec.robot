*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/nhanvien.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_chamcong.robot

*** Test Cases ***    Tên ca      Giờ bắt đầu       Giờ kết thúc        Chi nhánh
Tao moi ca lam viec     [Tags]        TS
                      [Template]    Add new shift
                      ca 1            07:00            10:00           Chi nhánh trung tâm
                      ca 2            13:00            17:00           Chi nhánh trung tâm
                      ca 1            07:00            10:00           Nhánh A
                      ca 2            13:00            17:00           Nhánh A
                      ca 1            07:00            10:00           Nhánh B
                      ca 2            13:00            17:00           Nhánh B

Tao moi ca lam viec     [Tags]        TS      jk
                      [Template]    Add new shift
                      ca 3            08:00            12:00           Chi nhánh trung tâm
                      ca 4            20:00            23:00           Chi nhánh trung tâm
                      ca 3            08:00            12:00           Nhánh A
                      ca 4            20:00            23:00           Nhánh A
                      ca 3            08:00            12:00           Nhánh B
                      ca 4            20:00            23:00           Nhánh B
