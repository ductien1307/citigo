*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../Sources/doitac.robot

*** Test Cases ***    Mã ĐTGH       Tên ĐTGH                SĐT
EBG                   [Tags]        EBG
                      [Template]    Add partner delivery
                      DT00001      Giao hàng nhanh              01689346782
                      DT00002      Giao hàng tiết kiệm          01689346783
                      DT00003      Viettel pos                  01689346784
                      DT00004      Shipper                      01689346785
                      DT00005      Grab delivery                01689346786
                      DT00006      Nguyễn Văn Nam               01689346787
                      DT00007      Hoàng Văn Anh                01689346788
                      DT00008      Bùi Thị Hồng                 01689346789
                      DT00009      Lê Thị Minh                  01689346790
                      DT00010      Trần Minh Tú                 01689346791
                      DT00011      Nguyễn Hải Phong             01689346792
                      DT00012      Lữ Bảo Hùng                  01689346793

EBG                   [Tags]        GDH
                      [Template]    Add partner delivery
                      DT00013      Phạm Anh Tú                  01679089901
