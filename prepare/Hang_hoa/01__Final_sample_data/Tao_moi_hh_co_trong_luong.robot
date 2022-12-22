*** Settings ***
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/Live_autotest/live_access.robot

*** Test Cases ***    Mã SP         Tên SP                           Nhóm hàng    Giá bán    Giá vốn    Tồn kho    Trọng lượng
HH co trong luong     [Template]    Add HH co trong luong thr API
                      TL001         Khi hơi thở hóa thinh không      Sách         80000      15000      10         0.85
