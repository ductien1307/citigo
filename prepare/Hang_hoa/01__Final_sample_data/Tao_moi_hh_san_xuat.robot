*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_sanxuat/envi.robot

*** Test Cases ***    Ma SP              TenSP                                                           Nhomhang              Giaban       Giavon      Ton     DVCB     TenDVT1          GTQD1    Giaban1     MaHH1       TenDVT2          GTQD2    Giaban2      MaHH2
Tạo hh sản xuất
                      [Tags]             EP
                      [Template]    Add product manufacturing
                      SX0001    Hàng sản xuất 1     Văn phòng phẩm    70000       500         TPD015      2    TPD016     3
                      SX0002    Hàng sản xuất 2     Văn phòng phẩm    80000       500         TPD017      1    TPD018     2
                      SX0003    Hàng sản xuất 3     Văn phòng phẩm    90000       500         SX0001      2    SX0002     3
