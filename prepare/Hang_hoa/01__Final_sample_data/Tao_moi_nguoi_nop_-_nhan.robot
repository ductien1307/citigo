*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/soquy.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Tên người nộp/nhận    SDT
Tao moi nguoi noap nhan
                      [Tags]                SQ
                      [Template]            Add partner
                      Nguyễn Văn An         0321456
                      Trần Đình Trọng       0954863
                      Hà Diệu Linh          0764862
                      Phạm Phương Thảo      0764566
