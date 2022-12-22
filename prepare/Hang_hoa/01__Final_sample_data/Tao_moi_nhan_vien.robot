*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_nhanvien.robot

*** Variables ***

*** Test Cases ***    Vị trí
Nhan vien                [Tags]
                      [Template]      Add employee thr API
                      NV001			Nguyễn vẵn An			  	Nhánh A
                      NV002			Đặng Đăng Quan				Nhánh A
                      NV003			Trần Minh Tuấn				Nhánh A
                      NV004			Dào Văn Lê			     	Nhánh A
                      NV005			Nguyễn vẵn An			  	Nhánh A
                      NV006			Đặng Đăng Quan				Nhánh A
                      NV007			Trần Minh Tuấn				Nhánh A
                      NV008			Dào Văn Lê			     	Nhánh A
                      NV009			Nguyễn vẵn An			  	Nhánh A
                      NV010			Đặng Đăng Quan				Nhánh A
                      NV011			Trần Minh Tuấn				Nhánh A
                      NV012			Dào Văn Lê			     	Nhánh A
                      NV013			Nguyễn vẵn An			  	Nhánh A
                      NV014			Đặng Đăng Quan				Nhánh A
                      NV015			Trần Minh Tuấn				Nhánh A
                      NV016			Dào Văn Lê			     	Nhánh A
                      NV017			Nguyễn vẵn An			  	Nhánh A
                      NV018			Đặng Đăng Quan				Nhánh A
                      NV019			Trần Minh Tuấn				Nhánh A
                      NV020			Dào Văn Lê				    Nhánh A
                      NV021			Nguyễn vẵn An			  	Nhánh A
                      NV022			Đặng Đăng Quan				Nhánh A
