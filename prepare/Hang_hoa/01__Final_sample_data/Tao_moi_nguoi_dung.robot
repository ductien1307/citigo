*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/thietlap.robot

*** Test Cases ***    Tên người dùng        Tên đăng nhập      Mật khẩu    SĐT              Vai trò
SQ                    [Tags]            SQ
                      [Template]        Create new user
                      Đặng Văn Lê           le.dv              123         0354478512       Quản trị chi nhánh
                      Nguyễn Thị An         an.nt              123         0395545534       Quản trị chi nhánh
                      Đỗ Xuân Sơn           son.dx             123         0987545821       Quản trị chi nhánh
                      Nguyễn Thùy Linh      linh.nt            123         0986451235       Quản trị chi nhánh
                      PHạm Thị Hằng         hang.pt            123         0987546325       Quản trị chi nhánh

ANU                   [Tags]            ANU
                      [Template]        Create new role full permissions
                      Full

ANU                   [Tags]            ANU
                      [Template]        Create new user by role
                      tester            123         Full

BGPV                  [Tags]            BGPV
                      [Template]        Create new user by role
                      tung.nt           123         Full

NBR                   [Tags]            NBR
                      [Template]        Create basic role
                      Quản trị chi nhánh
                      Nhân viên kho
                      Nhân viên thu ngân

PQ                    [Tags]            PQ
                      [Template]        Create new user
                      Chu Thị Thủy          thuy.ct            123         0985654785       Nhân viên thu ngân
                      Dào Bích Ngọc         ngoc.db            123         0985475214       Nhân viên thu ngân
                      Nguyễn Thị Nhâm       nham.nt            123         0985657524       Nhân viên thu ngân
                      Đặng Phương Thảo      thao.dp            123         0985478521       Nhân viên thu ngân
                      Nguyễn Thị Ninh       ninh.nt            123         0985632478       Nhân viên thu ngân
                      Hoàng Quốc Hùng       hung.hq            123         0985632587       Nhân viên thu ngân
                      Nguyễn Kim Anh        anh.nk             123         0985325456       Nhân viên kho
                      Nông Đức Mạnh         manh.nd            123         0985321456       Nhân viên kho

Nang cap chuyen hang                    [Tags]           NCCH
                      [Template]        Create new user
                      Hoàng Thị Mai        mai.ht              123         0985354545       Nhân viên thu ngân
