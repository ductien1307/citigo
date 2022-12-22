*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../Sources/giaodich.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Mã sp            Tên thuốc              Tên nhóm           Giá bán         Giá vốn      Đường dùng
EBL                   [Tags]           NTB
                      [Template]       Add medicine thr API
                      T00001          Thevapop                Thuốc nội          70000           50000        Nhỏ mắt
                      T00002          STAMICIS                Thuốc nội          60000           30000        Nhỏ mũi
                      T00003          Sulcetam Inj.           Thuốc nội          70000           35000.6      Nhỏ tai
                      T00004          Combigan                Thuốc nội          75000.5         50000        Tiêm dưới da
                      T00005          Moxetero                Thuốc nội          44000.2         30000.3      Tiêm tĩnh mạch
                      T00006          Coxwell-60              Thuốc nội          35000           55000        Nhỏ mắt
                      T00007          Rasanvisc               Thuốc nội          70000           115000       Nhỏ mũi
                      T00008          Aziplus                 Thuốc nội          70000           50000        Tiêm dưới da
                      T00009          Corosan                 Thuốc nội          70000           50000        Tiêm tĩnh mạch
                      T00010          Maltofer                Thuốc nội          70000           50000        Nhỏ mũi
                      T00011          Thevapop                Thuốc nội          70000           50000        Nhỏ mắt
                      T00012          STAMICIS                Thuốc nội          60000           30000        Nhỏ mũi
                      T00013          Sulcetam Inj.           Thuốc nội          70000           35000.6      Nhỏ tai
                      T00014          Combigan                Thuốc nội          75000.5         50000        Tiêm dưới da
                      T00015          Moxetero                Thuốc nội          44000.2         30000.3      Tiêm tĩnh mạch
                      T00016          Coxwell-60              Thuốc nội          35000           55000        Nhỏ mắt
                      T00017          Rasanvisc               Thuốc nội          70000           115000       Nhỏ mũi
                      T00018          Aziplus                 Thuốc nội          70000           50000        Tiêm dưới da
                      T00019          Corosan                 Thuốc nội          70000           50000        Tiêm tĩnh mạch
                      T00020          Maltofer                Thuốc nội          70000           50000        Nhỏ mũi
HHKK                 [Tags]           HHKK
                      [Template]       Add medicine thr API
                      TKK00001          Thevapop                Thuốc nội          70000           50000        Nhỏ mắt
                      TKK00002          STAMICIS                Thuốc nội          60000           30000        Nhỏ mũi

*** Keywords ***
