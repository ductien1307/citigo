*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}        ${headless_browser}
Force Tags        NEG
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot

*** Test Cases ***    Ma SP         So luong
EBT                   [Tags]        NEGEB
                      [Template]    Add product to negative onhand
                      PIB10003      16
                      PIB10009      16
                      PIB10015      16
                      PIB10018      16

EBC                   [Tags]        NEGEB
                      [Template]    Add product to negative onhand
                      TPC023        16
                      TPC026        16
                      TPC029        16
                      TPC030        16
                      TPC035        16
                      TPC036        16
                      TPC037        16
                      TPC038        16
                      TPC044        16

DVT                   [Tags]        NEG                               CETE-003
                      [Template]    Add product to negative onhand
                      DVT0203       16
                      DVT0206       16
                      DVT0209       16
                      DVT0215       16
                      DVT0112       16
                      DVT0104       16
                      DVT0105       16
                      DVT0106       16

New invoice_          [Tags]        NEG                               NI
                      [Template]    Create invoice with customer
                      PIB10001      2                                 KH124

CBT                   [Tags]        CBT
                      [Template]    Add product to negative onhand
                      HH0003        16
                      HH0006        16
                      HH0009        16
                      HH0012        16
                      HH0015        16
                      HH0018        16
                      HH0021        16
                      HH0024        16
                      HH0027        16
                      HH0030        16
                      HH0033        16
                      HH0036        16

EDT                   [Tags]    NEGED
                      [Template]    Add product to negative onhand
                      HH0041        1
                      HH0045        1
                      HH0048        1
                      HH0051        1
                      HH0054        1
                      HH0057        1
                      HH0060        1
                      HH0061        1
                      HH0065        1
                      HH0069        1

EDT_update            [Tags]      NEGED
                      [Template]    Add product to negative onhand
                      HH0072        1
                      HH0075        1
                      HH0078        1
                      HH0081        1
                      HH0084        1
                      HH0087        1
                      HH0090        1
                      HH0093        1
                      HH0096        1
                      HH0099        1
                      HH0102        1
                      HH0105        1
                      HH0108        1
                      HH0111        1
                      HH0114        1
                      HH0117        1
                      HH0120        1
                      HH0122        1

EDVT                  [Tags]    NEGED
                      [Template]    Add product to negative onhand
                      DVT46         1
                      DVT49         1
                      DVT52         1
                      DVT55         1
                      DVT58         1
                      DVT61         1
                      DVT64         1
                      DVT67         1
                      DVT70         1
                      DVT72         1

EDVT_update           [Tags]    NEGED
                      [Template]    Add product to negative onhand
                      DVT75         1
                      DVT78         1
                      DVT81         1
                      DVT84         1
                      DVT87         1
                      DVT90         1
                      DVT93         1
                      DVT96         1
                      DVT99         1
                      DVT102        1
                      DVT105        1
                      DVT108        1
                      DVT111        1
                      DVT114        1
                      DVT117        1
                      DVT120        1
                      DVT123        1

EDC                   [Tags]    NEGED
                      [Template]    Add product to negative onhand
                      TP051         1
                      TP054         1
                      TP057         1
                      TP060         1
                      TP063         1
                      TP066         1
                      TP069         1
                      TP072         1
                      TP075         1
                      TP078         1
                      TP081         1
                      TP084         1
                      TP087         1
                      TP090         1
                      TP093         1
                      TP096         1
                      TP099         1
                      TP102         1
                      TP105         1
                      TP108         1

EDC_update            [Tags]    NEGED
                      [Template]    Add product to negative onhand
                      TP111         1
                      TP114         1
                      TP117         1
                      TP120         1
                      TP123         1
                      TP126         1
                      TP129         1
                      TP132         1
                      TP135         1
                      TP138         1
                      TP141         1
                      TP144         1
                      TP147         1
                      TP150         1
                      TP153         1
                      TP156         1
                      TP159         1
                      TP162         1
                      TP165         1
                      TP168         1
                      TP171         1
                      TP174         1
                      TP177         1
                      TP180         1
                      TP183         1
                      TP186         1
                      TP189         1
                      TP192         1
                      TP195         1
                      TP198         1
                      TP201         1
                      TP204         1
                      TP207         1
                      TP210         1
                      TP213         1
                      TP216         1
                      TP219         1
                      TP222         1
                      TP225         1
                      TP228         1

EBGT                  [Tags]        EBGT
                      [Template]    Add product to negative onhand
                      HH0126        1
                      HH0129        1
                      HH0132        1
                      HH0135        1
                      HH0138        1
                      HH0141        1
                      HH0144        1
                      HH0147        1
                      HH0150        1
                      HH0153        1
                      HH0156        1
                      HH0159        1
                      HH0162        1

EBGU                  [Tags]        EBGU
                      [Template]    Add product to negative onhand
                      DVT128        1
                      DVT131        1
                      DVT134        1
                      DVT137        1
                      DVT140        1
                      DVT143        1
                      DVT146        1
                      DVT149        1
                      DVT152        1
                      DVT155        1
                      DVT158        1
                      DVT161        1

EBGC                  [Tags]        EBGC
                      [Template]    Add product to negative onhand
                      TPG03         1
                      TPG06         1
                      TPG09         1
                      TPG12         1
                      TPG15         1
                      TPG18         1
                      TPG21         1
                      TPG24         1
                      TPG27         1
                      TPG30         1
                      TPG33         1
                      TPG36         1
                      TPG39         1
                      TPG42         1
                      TPG45         1
                      TPG48         1
                      TPG51         1
                      TPG54         1
                      TPG57         1
                      TPG60         1
                      TPG63         1
                      TPG66         1
                      TPG69         1
                      TPG72         1
                      TPG75         1

EDT_taohoadon_tamung  [Tags]    NEGED
                      [Template]    Add product to negative onhand
                      TP203         1
                      TP204         1
                      TP206         1
                      TP207         1
                      TP209         1
                      TP210         1
                      TP212         1
                      TP213         1
                      TP215         1
                      TP216         1
                      TP218         1
                      TP219         1
                      TP221         1
                      TP222         1
                      TP224         1
                      TP225         1
                      TP227         1
                      TP228         1
                      TP230         1
                      TP232         1
                      TP233         1
                      TP237         1
                      TP238         1
                      TP241         1
                      TP242         1
                      TP244         1

HHKK                  [Tags]    HHKK
                      [Template]    Add product to negative onhand
                      HTKK0005      1
                      HTKK0006      1

*** Keywords ***
Create invoice without customer
    Wait Until Keyword Succeeds    2 min    30 sec    Add product to negative onhand    ${ma_hh}    ${quantity}

Create invoice with customer
    [Arguments]    ${ma_hh}    ${quantity}    ${customer}
    Repeat Keyword    1 times    Create new invoice w customer    ${ma_hh}    ${quantity}    ${customer}
