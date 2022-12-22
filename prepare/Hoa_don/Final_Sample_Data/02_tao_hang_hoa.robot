*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Resource          ../../Hang_hoa/Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot

*** Test Cases ***    Ma SP                            Ten sp                                       Nhom hang             Gia ban       Gia von     Ton
TMHH                  [Tags]                           THD
                      [Template]                       Add product and wait
                      ## EBT
                      ATDD00001                         Test hóa đơn lần 01                          Hàng gia dụng         200000         100000       100
                      ATDD00002                         Test hóa đơn lần 02                          Hàng gia dụng         200000         100000       100
                      ATDD00003                         Test hóa đơn lần 03                          Hàng gia dụng         200000         100000       100     #ton am
                      ATDD00004                         Test hóa đơn lần 04                          Hàng gia dụng         200000         100000       100
                      ATDD00005                         Test hóa đơn lần 05                          Hàng gia dụng         200000         100000       100
                      ATDD00006                         Test hóa đơn lần 06                          Hàng gia dụng         200000         100000       100
                      ATDD00007                         Test hóa đơn lần 07                          Hàng gia dụng         200000         100000       100
                      ATDD00008                         Test hóa đơn lần 08                          Hàng gia dụng         200000         100000       100
                      ATDD00009                         Test hóa đơn lần 09                          Hàng gia dụng         200000         100000       100
                      ATDD00010                         Test hóa đơn lần 10                          Hàng gia dụng         200000         100000       100
                      ATDD00011                         Test hóa đơn lần 11                          Hàng gia dụng         200000         100000       100
                      ATDD00012                         Test hóa đơn lần 12                          Hàng gia dụng         200000         100000       100
                      ATDD00013                         Test hóa đơn lần 13                          Hàng gia dụng         200000         100000       100
