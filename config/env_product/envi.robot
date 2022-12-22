*** Settings ***
Library           StringFormat
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Library           pabot.PabotLib
Library           ArchiveLibrary
Resource          ../../core/login/login_action.robot
Resource          ../../core/share/print_preview.robot
Resource          ../../core/API/api_access.robot
Resource          ../../core/API/api_thietlap.robot
Resource          ../../core/Ban_Hang_page_menu.robot
Resource          ../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/API/api_phieu_nhap_hang.robot
Resource          ../../core/share/javascript.robot
Resource          ../../core/Ban_Hang/banhang_page.robot
Resource          ../../core/So_Quy/so_quy_navigation.robot
Resource          ../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../core/Dang_ky_moi/dangkymoi_page.robot
Resource          ../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../core/Thiet_lap/branch_list_action.robot
Resource          ../../core/Shopee_UAT/shopee_list_action.robot
Resource          ../../core/Lazada/lazada_list_action.robot
Resource          ../../core/Facebook/fbpos_list_action.robot

*** Variables ***
${page_open}      //section/h3
&{DICT_PROFILE}    live1=Profie 1   live2=Profie 2
${pathToExportFile}    ${EXECDIR}\\uploadfile\\ExportFile

*** Keywords ***
Fill env
    [Arguments]    ${env}    ${remote}    ${account}      ${headless_browser}
    Log    ${env}
    ${DICT_API_URL}    Create Dictionary    live1=https://autobot.kiotviet.vn/api    live2=https://autoto.kiotviet.vn/api    live3=https://autobot2.kiotviet.vn/api    live4=https://autobot3.kiotviet.vn/api     live5=https://auto888.kiotviet.vn/api
    ...    ZONE1=https://auto1.kiotviet.vn/api
    ...    ZONE2=https://auto2.kiotviet.vn/api    ZONE3=https://auto3.kiotviet.vn/api    ZONE4=https://auto4.kiotviet.vn/api    ZONE5=https://auto5.kiotviet.vn/api    ZONE6=https://auto6.kiotviet.vn/api
    ...    ZONE8=https://auto8.kiotviet.vn/api    ZONE9=https://auto9.kiotviet.vn/api    ZONE10=https://auto10.kiotviet.vn/api    ZONE11=https://auto11.kiotviet.vn/api    ZONE12=https://auto12.kiotviet.vn/api
    ...    ZONE13=https://auto13.kiotviet.vn/api    ZONE14=https://auto14.kiotviet.vn/api    ZONE17=https://auto17.kiotviet.vn/api    ZONE18=https://auto18.kiotviet.vn/api    ZONE19=https://auto19.kiotviet.vn/api
    ...    ZONE20=https://auto20.kiotviet.vn/api    ZONE21=https://auto21.kiotviet.vn/api     ZONE23=https://auto23.kiotviet.vn/api        ZONE24=https://auto24.kiotviet.vn/api       ZONE26=https://auto26.kiotviet.vn/api     LD=https://autoloda.kiotviet.vn/api    DR=https://autotestdr.kiotviet.vn/api
    ...    59922=https://auto59925.kvpos.com:59922/api        59925=https://auto59925.kvpos.com:59925/api    59909=https://autotest.kvpos.com:59909/api    59927=https://auto59927.kvpos.com:59927/api
    ...    59920=https://auto59920.kvpos.com:59920/api     59912=https://auto59912.kvpos.com:59912/api     59913=https://kvpos.com:59313/api      ML=https://autocheck.kiotviet.vn/api     NT=https://autonhathuoc1.kiotviet.vn/api      FNB=https://fnb.kiotviet.vn/api    MI59913=https://kvpos.com:59313/api
    ...    59916=https://auto59916.kvpos.com:59916/api      59511=https://fnb.kvpos.com:59511/api     59910=https://auto59910.kvpos.com:59910/api     59517=https://fnb.kvpos.com:59517/api     59924=https://auto59924.kvpos.com:59924/api
    ...    59919=https://auto9019.kvpos.com:59919/api     59918=https://auto59918.kvpos.com:59918/api     9009=https://kiotapi.kvpos.com:9009/api     9001=https://auto9001.kvpos.com:9001/api     NHIEUDL=https://nhieudata59922.kvpos.com:59922/api      ZONE28=https://auto28.kiotviet.vn/api   ZONE29=https://auto29.kiotviet.vn/api
    ...     ZONE30=https://testh80qns08.kiotviet.vn/api    9002=https://auto9002.kvpos.com:9002/api     ZONE32=https://auto32.kiotviet.vn/api       59903=https://auto59903.kvpos.com:59903/api     ZONE35=https://auto35.kiotviet.vn/api    ZONE36=https://testz36.kiotviet.vn/api
    ...    59508=https://fnb.kvpos.com:59508/api    FNB15=https://fnb.kiotviet.vn/api    ZONE37=https://kvpos.com:59913/api    AUTOZONE36=https://autozone36.kiotviet.vn/api    ZONE38=https://autoimei.kiotviet.vn/api    AT59913=https://kvpos.com:59313/api
    ${DICT_RETAILER_NAME}    Create Dictionary    live1=autobot    live2=autoto    live3=autobot2    live4=autobot3    live5=auto888    ZONE1=auto1    ZONE2=auto2    ZONE3=auto3    ZONE4=auto4
    ...    ZONE5=auto5    ZONE6=auto6    ZONE8=auto8    ZONE9=auto9    ZONE10=auto10    ZONE11=auto11    ZONE12=auto12    ZONE13=auto13    ZONE14=auto14
    ...    ZONE17=auto17    ZONE18=auto18    ZONE19=auto19    ZONE20=auto20    ZONE21=auto21    ZONE23=auto23       ZONE24=auto24    ZONE26=auto26   LD=autoloda    DR=autotestdr    59922=auto59925    59925=auto59925
    ...    59909=autotest     59927=auto59927     59920=auto59920    59912=auto59912    59913=auto59913    ML=autocheck      NT=autonhathuoc1      FNB=autotestfnb     59916=auto59916      59511=auto59511     59910=auto59910   59517=auto59517     59924=auto59924
    ...    59919=auto9019     59918=auto59918     9009=auto9009     9001=auto9001      NHIEUDL=nhieudata59922     ZONE28=auto28     ZONE29=auto29    AUTOZONE36=autozone36    ZONE38=autoimei    AT59913=at59913
    ${DICT_BRANCH_ID}    Create Dictionary    live1=62644    live2=74831    live3=11352    live4=32224    live5=1338410    ZONE1=172786    ZONE2=85976    ZONE3=152624    ZONE4=201570
    ...    ZONE5=50018    ZONE6=80994    ZONE8=76246    ZONE9=138    ZONE10=30530    ZONE11=76360    ZONE12=181235    ZONE13=43334    ZONE14=110843
    ...    ZONE17=63219    ZONE18=8309    ZONE19=48009    ZONE20=64629    ZONE21=14     ZONE23=29    ZONE24=46988    ZONE26=35    LD=11889    DR=28    59922=35    59925=35
    ...    59909=1184     59927=1016     59920=15359    59912=107407    59913=5572       ML=4114       NT=9459     FNB=17050    59916=6077        59511=7160      59910=9105     59517=7395      59924=17297
    ...    59919=14097      59918=22167     9009=14739    9001=15315    NHIEUDL=10691     ZONE28=41159     ZONE29=3241
    ...    ZONE30=43       9002=19373     ZONE32=4      59903=11848   ZONE35=100053      ZONE36=100046         59508=18     FNB15=1662    ZONE37=13533    AUTOZONE36=1300047    ZONE38=1300282    AT59913=13830
    ${DICT_LATESTBRANCH}    Create Dictionary    live1=LatestBranch_294113_172395    live2=LatestBranch_307027_201567    live3=LatestBranch_437336_20447    live4=LatestBranch_764833_61034    live5=LatestBranch_764833_61034    ZONE1=LatestBranch_366420_441968
    ...    ZONE2=LatestBranch_366521_196750    ZONE3=LatestBranch_366523_386013    ZONE4=LatestBranch_366526_492065    ZONE5=LatestBranch_366528_160324    ZONE6=LatestBranch_364689_192226
    ...    ZONE8=LatestBranch_366532_225382    ZONE9=LatestBranch_364685_1784    ZONE10=LatestBranch_388337_65584    ZONE11=LatestBranch_366647_226492    ZONE12=LatestBranch_339758_438680
    ...    ZONE13=LatestBranch_614772_84572    ZONE14=LatestBranch_614773_223338     ZONE17=LatestBranch_614774_120324    ZONE18=LatestBranch_561711_18176    ZONE19=LatestBranch_559564_100334
    ...    ZONE20=LatestBranch_415547_110623    ZONE21=LatestBranch_425301_29    ZONE23=LatestBranch_863297_509   ZONE24=LatestBranch_683557_106871    ZONE26=LatestBranch_725753_60    LD=LatestBranch_437946_21557    DR=LatestBranch_526696_44    59922=LatestBranch_19_47    59925=LatestBranch_19_47    59909=LatestBranch_279846_10752
    ...    59927=LatestBranch_523851_10030     59920=LatestBranch_391425_153582    59912=LatestBranch_1017293_168233    59913=LatestBranch_636438_53085        ML=LatestBranch_634535_16640      NT=LatestBranch_663303_20988
    ...    FNB=LatestBranch_678521_36317    59916=LatestBranch_386330_90282    59511=LatestBranch_386331_82001     59910=LatestBranch_384313_140323      59517=LatestBranch_583284_130900      59924=LatestBranch_15143_170278
    ...    59919=LatestBranch_433237_162865     59918=LatestBranch_308164_213837    9009=LatestBranch_20201_160824    PRELIVE=LatestBranch_20_8     9001=LatestBranch_18117_160376      ZONE28=LatestBranch_846995_88766      ZONE29=LatestBranch_833753_6101
    ...     ZONE30=LatestBranch_877746_533      9002=LatestBranch_15064_190432     ZONE32=LatestBranch_916469_8       59903=LatestBranch_810143_115215      ZONE35=LatestBranch_965233_100569      ZONE36=LatestBranch_961894_100544
    ...     59508=LatestBranch_810154_14     FNB15=LatestBranch_424636_11165    ZONE37=LatestBranch_294113_172395    AUTOZONE36=LatestBranch_1131589_1300547    ZONE38=LatestBranch_1133134_1300928    AT59913=LatestBranch_652114_126290
    ${DICT_URL}    Create Dictionary    live1=https://autobot.kiotviet.vn    live2=https://autoto.kiotviet.vn    live3=https://autobot2.kiotviet.vn    live4=https://autobot3.kiotviet.vn    live5=https://auto888.kiotviet.vn    ZONE1=https://auto1.kiotviet.vn    ZONE2=https://auto2.kiotviet.vn    ZONE3=https://auto3.kiotviet.vn
    ...    ZONE4=https://auto4.kiotviet.vn    ZONE5=https://auto5.kiotviet.vn    ZONE6=https://auto6.kiotviet.vn    ZONE8=https://auto8.kiotviet.vn    ZONE9=https://auto9.kiotviet.vn    ZONE10=https://auto10.kiotviet.vn    ZONE11=https://auto11.kiotviet.vn
    ...    ZONE12=https://auto12.kiotviet.vn    ZONE13=https://auto13.kiotviet.vn    ZONE14=https://auto14.kiotviet.vn    ZONE17=https://auto17.kiotviet.vn    ZONE18=https://auto18.kiotviet.vn    ZONE19=https://auto19.kiotviet.vn
    ...    ZONE20=https://auto20.kiotviet.vn    ZONE21=https://auto21.kiotviet.vn     ZONE23=https://auto23.kiotviet.vn    ZONE24=https://auto24.kiotviet.vn     ZONE26=https://auto26.kiotviet.vn   LD=https://autoloda.kiotviet.vn    DR=https://autotestdr.kiotviet.vn    59922=https://auto59925.kvpos.com:59922    59925=https://auto59925.kvpos.com:59925
    ...    59909=https://autotest.kvpos.com:59909     59927=https://auto59927.kvpos.com:59927     59920=https://auto59920.kvpos.com:59920    59912=https://auto59912.kvpos.com:59912    59913=https://auto59913.kvpos.com:59913      ML=https://autocheck.kiotviet.vn       NT=https://autonhathuoc1.kiotviet.vn
    ...    FNB=https://fnb.kiotviet.vn       59916=https://auto59916.kvpos.com:59916      59511=https://fnb.kvpos.com:59511     59910=https://auto59910.kvpos.com:59910      59517=https://fnb.kvpos.com:59517     59924=https://auto59924.kvpos.com:59924
    ...    59919=https://auto9019.kvpos.com:59919       59918=https://auto59918.kvpos.com:59918     9009=https://auto9009.kvpos.com:9009    PRELIVE=https://autoprelive1.kiotviet.fun      9001=https://auto9001.kvpos.com:9001     ZONE28=https://auto28.kiotviet.vn     ZONE29=https://auto29.kiotviet.vn
    ...    ZONE30=https://testh80qns08.kiotviet.vn      9002=https://auto9002.kvpos.com:9002     ZONE32=https://auto32.kiotviet.vn      59903=https://auto59903.kvpos.com:59903     ZONE35=https://auto35.kiotviet.vn    ZONE36=https://testz36.kiotviet.vn
    ...     59508=https://fnb.kvpos.com:59508     FNB15=https://fnb.kiotviet.vn    ZONE37=https://auto2811.kvpos.com:59913/       AUTOZONE36=https://autozone36.kiotviet.vn/    ZONE38=https://autoimei.kiotviet.vn/    AT59913=https://at59913.kvpos.com:59913/
    ${DICT_ADMIN}    Create Dictionary    live1=admin    live2=admin    live3=admin    live4=admin    live5=admin    ZONE1=admin    ZONE2=admin    ZONE3=admin    ZONE4=admin
    ...    ZONE5=admin    ZONE6=admin    ZONE8=admin    ZONE9=admin    ZONE10=admin    ZONE11=admin    ZONE12=admin    ZONE13=admin    ZONE14=admin
    ...    ZONE17=admin    ZONE18=admin    ZONE19=admin    ZONE20=admin    ZONE21=admin   ZONE23=admin   ZONE24=admin     ZONE26=admin   LD=admin    DR=admin    59922=admin    59925=admin
    ...    59909=admin     59927=admin     59920=admin    59912=admin    59913=admin       ML=admin    NT=admin      FNB=admin   59916=admin     59511=admin      59910=admin     59517=admin      59924=admin
    ...    59919=admin      59918=admin   9009=admin    PRELIVE=admin       9001=admin    ZONE28=admin      ZONE29=admin
    ...    ZONE30=admin      9002=admin     ZONE32=admin     59903=admin    ZONE35=admin    ZONE36=admin     59508=admin    FNB15=admin    ZONE37=admin     AUTOZONE36=admin    ZONE38=admin    AT59913=admin
    ${DICT_USER}    Create Dictionary    live1=admin    live2=admin    live3=tester    live4=admin    live5=admin    ZONE1=tester    ZONE2=tester    ZONE3=tester    ZONE4=tester
    ...    ZONE5=tester    ZONE6=tester    ZONE8=tester    ZONE9=tester    ZONE10=tester    ZONE11=tester    ZONE12=tester    ZONE13=tester    ZONE14=tester
    ...    ZONE17=tester    ZONE18=tester    ZONE19=tester    ZONE20=tester    ZONE21=tester    ZONE23=tester    ZONE24=tester     ZONE26=tester   LD=tester    DR=tester    59922=tester    59925=tester
    ...    59909=tester     59927=tester     59920=tester    59912=tester    59913=tester     ML=admin      NT=admin    FNB=admin     59916=admin      59511=admin     59910=admin    59517=admin    59924=tester
    ...    59919=tester     59918=tester      9009=tester    PRELIVE=admin      9001=tester    ZONE28=tester     ZONE29=tester
    ...    ZONE30=tester    9002=admin     ZONE32=tester      59903=tester    ZONE35=tester    ZONE36=tester     59508=tester     FNB15=tester    ZONE37=admin    AUTOZONE36=admin    ZONE38=admin    AT59913=admin
    ${DICT_PASSWORD}    Create Dictionary    live1=123    live2=123    live3=123    live4=123    live5=123456    ZONE1=123    ZONE2=123    ZONE3=123    ZONE4=123
    ...    ZONE5=123    ZONE6=123    ZONE8=123    ZONE9=123    ZONE10=123    ZONE11=123    ZONE12=123    ZONE13=123    ZONE14=123
    ...    ZONE17=123    ZONE18=123    ZONE19=123    ZONE20=123    ZONE21=123    ZONE23=123   ZONE24=123     ZONE26=123   LD=123    DR=123    59922=123    59925=123
    ...    59909=123     59927=123     59920=123    59912=123    59913=123       ML=123      NT=123      FNB=123   59916=123       59511=123     59910=123     59517=123     59924=123
    ...    59919=123      59918=123     9009=123    PRELIVE=123     9001=123     ZONE28=123     ZONE29=123    ZONE30=123        9002=123     ZONE32=123     59903=123       ZONE35=123    ZONE36=123
    ...    59508=123     FNB15=kiotviet123456      ZONE37=123456     AUTOZONE36=123    ZONE38=123    AT59913=123456
    ${DICT_SALE_API_URL}    Create Dictionary    live1=https://sale.kiotapi.com/api    live2=https://sale.kiotapi.com/api    live3=https://sale.kiotapi.com/api    live4=https://sale.kiotapi.com/api    live5=https://sale.kiotapi.com/api    ZONE1=https://sale.kiotapi.com/api    ZONE2=https://sale.kiotapi.com/api    ZONE3=https://sale.kiotapi.com/api
    ...    ZONE4=https://sale.kiotapi.com/api    ZONE5=https://sale.kiotapi.com/api    ZONE6=https://sale.kiotapi.com/api    ZONE8=https://sale.kiotapi.com/api    ZONE9=https://sale.kiotapi.com/api    ZONE10=https://sale.kiotapi.com/api    ZONE11=https://sale.kiotapi.com/api
    ...    ZONE12=https://sale.kiotapi.com/api    ZONE13=https://sale.kiotapi.com/api    ZONE14=https://sale.kiotapi.com/api    ZONE17=https://sale.kiotapi.com/api    ZONE18=https://sale.kiotapi.com/api    ZONE19=https://sale.kiotapi.com/api
    ...    ZONE20=https://sale.kiotapi.com/api    ZONE21=https://sale.kiotapi.com/api     ZONE24=https://sale.kiotapi.com/api     ZONE23=https://sale.kiotapi.com/api     ZONE26=https://sale.kiotapi.com/api     LD=https://sale.kiotapi.com/api    DR=https://sale.kiotapi.com/api    59922=https://kvpos.com:59322/api    59925=https://kvpos.com:54925/api
    ...    59909=https://autotest.kvpos.com:59909/api     59927=https://saleapi.kvpos.com:59327/api     59920=https://auto59920.kvpos.com:59920/api    59912=https://auto59912.kvpos.com:59912/api    59913=https://kvpos.com:59313/api     ML=https://sale.kiotapi.com/api
    ...    NT=https://sale.kiotapi.com/api   FNB=https://fnb.kiotviet.vn/api      59916=https://kvpos.com:59316/api      59511=https://fnb.kvpos.com:59511/api     59910=https://auto59910.kvpos.com:59910/api   59517=https://fnb.kvpos.com:59517/api     59924=https://kvpos.com:59324/api
    ...    59919=https://auto9019.kvpos.com:59919/api     59918=https://auto59918.kvpos.com:59918/api     9009=https://kiotapi.kvpos.com:9009/api/    PRELIVE=https://sale.kiotviet.fun/api     9001=https://auto9001.kvpos.com:9001/api         ZONE28=https://sale.kiotapi.com/api      ZONE29=https://sale.kiotapi.com/api
    ...    ZONE30=https://sale.kiotapi.com/api            9002=https://saleapihcm.kvpos.com:9302/api     ZONE32=https://sale.kiotapi.com/api        59903=https://saleapi.kvpos.com:59303/api     ZONE35=https://sale.kiotapi.com/api    ZONE36=https://sale.kiotapi.com/api
    ...    59508=https://fnb.kvpos.com:59508/api     FNB15=https://fnb.kiotviet.vn/api    ZONE37=https://sale.kiotapi.com/api    AUTOZONE36=https://sale.kiotapi.com/api    ZONE38=https://sale.kiotapi.com/api    AT59913=https://kvpos.com:59313/api
    ${DICT_PROMO_API}    Create Dictionary    live1=https://promotion.kiotapi.com/api    live2=https://promotion.kiotapi.com/api    live3=https://promotion.kiotapi.com/api    live4=https://promotion.kiotapi.com/api    live5=https://promotion.kiotapi.com/api    ZONE1=https://promotion.kiotapi.com/api
    ...    ZONE2=https://promotion.kiotapi.com/api    ZONE3=https://promotion.kiotapi.com/api    ZONE4=https://promotion.kiotapi.com/api    ZONE5=https://promotion.kiotapi.com/api    ZONE6=https://promotion.kiotapi.com/api
    ...    ZONE8=https://promotion.kiotapi.com/api    ZONE9=https://api-promotion2.kiotviet.vn/api   ZONE10=https://promotion.kiotapi.com/api    ZONE11=https://promotion.kiotapi.com/api    ZONE12=https://promotion.kiotapi.com/api
    ...    ZONE13=https://promotion.kiotapi.com/api    ZONE14=https://promotion.kiotapi.com/api     ZONE17=https://promotion.kiotapi.com/api    ZONE18=https://promotion.kiotapi.com/api    ZONE19=https://promotion.kiotapi.com/api
    ...    ZONE20=https://promotion.kiotapi.com/api    ZONE21=https://promotion.kiotapi.com/api   ZONE23=https://promotion.kiotapi.com/api    ZONE24=https://promotion.kiotapi.com/api     ZONE26=https://promotion.kiotapi.com/api   LD=https://promotion.kiotapi.com/api    DR=https://promotion.kiotapi.com/api    59922=https://kvpos.com:53222/api    59925=https://kvpos.com:53225/api    59909=https://kvpos.com:53209/api
    ...    59927=https://kvpos.com:53227/api       59920=https://kvpos.com:53220/api    59912=https://kvpos.com:53212/api     59913=https://kvpos.com:59313/api     59916=https://promotionhcm.kvpos.com:9000/api
    ...    ML=https://promotion.kiotapi.com/api      NT=https://promotion.kiotapi.com/api      FNB=https://promotion.kiotapi.com/api      59511=https://fnb.kvpos.com:59511/api       59910=https://kvpos.com:3209/api   59517=https://promotion.kiotapi.com/api     59924=https://kvpos.com:53224/api
    ...    59919=https://kvpos.com:53209/api      59918=https://kvpos.com:53218/api     9009=https://promotionhcm.kvpos.com:9000/api    PRELIVE=https://promotionapi.kiotviet.fun/api      9001=https://promotion.kiotapi.com/api       ZONE28=https://promotion.kiotapi.com/api    ZONE29=https://promotion.kiotapi.com/api
    ...    ZONE30=https://promotion.kiotapi.com/api     9002=https://promotionhcm.kvpos.com:9002/api     ZONE32=https://promotion.kiotapi.com/api     59903=https://promotionhn.kvpos.com:53203/api     ZONE35=https://promotion.kiotapi.com/api    ZONE36=https://promotion.kiotapi.com/api
    ...    59508=https://fnb.kvpos.com:59508/api     FNB15=https://promotion.kiotapi.com/api     ZONE37=https://promotion.kiotapi.com/api    AUTOZONE36=https://promotion.kiotapi.com/api    ZONE38=https://promotion.kiotapi.com/api    AT59913=https://kvpos.com:59313/api
    ${DICT_WARRANTY_API}    Create Dictionary    live1=https://api-guarantee.kiotviet.vn/api    live2=https://api-guarantee.kiotviet.vn/api    live3=https://api-guarantee.kiotviet.vn/api    live4=https://api-guarantee.kiotviet.vn/api    live5=https://api-guarantee.kiotviet.vn/api    ZONE1=https://api-guarantee.kiotviet.vn/api
    ...    ZONE2=https://api-guarantee.kiotviet.vn/api    ZONE3=https://api-guarantee.kiotviet.vn/api    ZONE4=https://api-guarantee.kiotviet.vn/api    ZONE5=https://api-guarantee.kiotviet.vn/api    ZONE6=https://api-guarantee.kiotviet.vn/api
    ...    ZONE8=https://api-guarantee.kiotviet.vn/api    ZONE9=https://api-guarantee2.kiotviet.vn/api    ZONE10=https://api-guarantee.kiotviet.vn/api    ZONE11=https://api-guarantee.kiotviet.vn/api    ZONE12=https://api-guarantee.kiotviet.vn/api
    ...    ZONE13=https://api-guarantee.kiotviet.vn/api    ZONE14=https://api-guarantee.kiotviet.vn/api     ZONE17=https://api-guarantee.kiotviet.vn/api    ZONE18=https://api-guarantee.kiotviet.vn/api    ZONE19=https://api-guarantee.kiotviet.vn/api
    ...    ZONE20=https://api-guarantee.kiotviet.vn/api    ZONE21=https://api-guarantee.kiotviet.vn/api   ZONE23=https://api-guarantee.kiotviet.vn/api     ZONE24=https://api-guarantee.kiotviet.vn/api     ZONE26=https://api-guarantee.kiotviet.vn/api   LD=https://api-guarantee.kiotviet.vn/api    DR=https://api-guarantee.kiotviet.vn/api    59922=https://kvpos.com:53322/api
    ...    59925=https://kvpos.com:53325/api    59909=https://kvpos.com:53309/api    59927=https://kvpos.com:53227/api       59920=https://kvpos.com:53220/api    59912=https://kvpos.com:53312/api     59913=https://kvpos.com:53313/api   ML=https://api-guarantee.kiotviet.vn/api      NT=https://api-guarantee.kiotviet.vn/api
    ...    FNB=https://api-guarantee.kiotviet.vn/api    59916=https://warrantyhcm.kvpos.com:9000/api       59511=https://fnb.kvpos.com:59511/api   59910=https://kvpos.com:53310/api     59517=https://api-guarantee.kiotviet.vn/api     59924=https://kvpos.com:53324/api
    ...    59919=https://kvpos.com:53309/api    59918=https://kvpos.com:53318/api     9009=https://warrantyhcm.kvpos.com:9000/api    PRELIVE=https://guaranteeapi.kiotviet.fun/api    9001=https://api-guarantee.kiotviet.vn/api        ZONE28=https://api-guarantee.kiotviet.vn/api     ZONE29=https://api-guarantee.kiotviet.vn/api
    ...    ZONE30=https://api-guarantee.kiotviet.vn/api    9002=https://warrantyhcm.kvpos.com:19002/api     ZONE32=https://api-guarantee.kiotviet.vn/api     59903=https://kvpos.com:59903/api      ZONE35=https://api-guarantee.kiotviet.vn/api    ZONE36=https://api-guarantee.kiotviet.vn/api
    ...    59508=https://fnb.kvpos.com:59508/api     FNB15=https://api-guarantee.kiotviet.vn/api     ZONE37=https://api-guarantee.kiotviet.vn/api    AUTOZONE36=https://api-guarantee.kiotviet.vn/api    ZONE38=https://api-guarantee.kiotviet.vn/api    AT59913=https://kvpos.com:53313/api
    ${DICT_TIMESHEET_API}    Create Dictionary    live1=https://api-timesheet.kiotviet.vn    live2=https://api-timesheet.kiotviet.vn    live3=https://api-timesheet.kiotviet.vn    live4=https://api-timesheet.kiotviet.vn    live5=https://api-timesheet.kiotviet.vn    ZONE1=https://api-timesheet.kiotviet.vn
    ...    ZONE2=https://api-timesheet.kiotviet.vn    ZONE3=https://api-timesheet.kiotviet.vn   ZONE4=https://api-timesheet.kiotviet.vn    ZONE5=https://api-timesheet.kiotviet.vn    ZONE6=https://api-timesheet.kiotviet.vn
    ...    ZONE8=https://api-timesheet.kiotviet.vn    ZONE9=https://api-timesheet2.kiotviet.vn    ZONE10=https://api-timesheet.kiotviet.vn    ZONE11=https://api-timesheet.kiotviet.vn    ZONE12=https://api-timesheet.kiotviet.vn
    ...    ZONE13=https://api-timesheet.kiotviet.vn    ZONE14=https://api-timesheet.kiotviet.vn     ZONE17=https://api-timesheet.kiotviet.vn    ZONE18=https://api-timesheet.kiotviet.vn    ZONE19=https://api-timesheet.kiotviet.vn       59916=https://kvpos.com:55011    59909=https://kvpos.com:55009    FNB=https://api-fnbtimesheet.kiotviet.vn
    ...    ZONE20=https://api-timesheet.kiotviet.vn    ZONE21=https://api-timesheet.kiotviet.vn     ZONE23=https://api-timesheet.kiotviet.vn      ZONE24=https://api-timesheet.kiotviet.vn   ZONE26=https://api-timesheet.kiotviet.vn    LD=https://api-timesheet.kiotviet.vn    DR=https://api-timesheet.kiotviet.vn    NT=https://api-timesheet.kiotviet.vn
    ...    59922=https://kvpos.com:53309/api           59511=https://kvpos.com:55011     59912=https://kvpos.com:55012     59913=https://kvpos.com:53213     59925=https://kvpos.com:55025      59910=https://kvpos.com:55010     59517=https://kvpos.com:55017      59924=https://api-timesheet.kiotviet.vn
    ...    59919=https://kvpos.com:53309/api      59918=https://kvpos.com:53309/api     9009=https://timesheetapi.kvpos.com:9009    PRELIVE=https://timesheet.kiotviet.fun      9001=https://api-timesheet.kiotviet.vn         ZONE28=https://api-timesheet.kiotviet.vn       ZONE29=https://api-timesheet.kiotviet.vn
    ...    ZONE30=https://api-timesheet.kiotviet.vn    9002=https://timesheetapi.kvpos.com:9002     ZONE32=https://api-timesheet.kiotviet.vn      59903=https://kvpos.com:55003     ZONE35=https://api-timesheet.kiotviet.vn       ZONE36=https://api-timesheet.kiotviet.vn    59508=https://kvpos.com:55008    FNB15=https://api-fnbtimesheet.kiotviet.vn
    ...    ZONE37=https://api-timesheet.kiotviet.vn    AUTOZONE36=https://api-timesheet.kiotviet.vn    ZONE38=https://api-timesheet.kiotviet.vn    AT59913=https://kvpos.com:53213
    #Set Global Variable    \${REMOTE_URL}    http://localhost:4444/wd/hub
    ${API_URL}    Get From Dictionary    ${DICT_API_URL}    ${env}
    ${BRANCH_ID}    Get From Dictionary    ${DICT_BRANCH_ID}    ${env}
    ${LATESTBRANCH}    Get From Dictionary    ${DICT_LATESTBRANCH}    ${env}
    ${URL}    Get From Dictionary    ${DICT_URL}    ${env}
    ${USER_ADMIN}    Get From Dictionary    ${DICT_ADMIN}    ${env}
    ${USER_ND}    Get From Dictionary    ${DICT_USER}    ${env}
    ${PASSWORD}    Get From Dictionary    ${DICT_PASSWORD}    ${env}
    ${RETAILER_NAME}    Get From Dictionary    ${DICT_RETAILER_NAME}    ${env}
    ${SALE_API_URL}    Get From Dictionary    ${DICT_SALE_API_URL}    ${env}
    ${PROMO_API}    Get From Dictionary    ${DICT_PROMO_API}    ${env}
    ${WARRANTY_API}    Get From Dictionary    ${DICT_WARRANTY_API}    ${env}
    ${TIMESHEET_API}    Get From Dictionary    ${DICT_TIMESHEET_API}    ${env}
    #${REMOTE_URL}    Set variable    ${remote}
    Set Global Variable    \${BROWSER}    Chrome
    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${BRANCH_ID}    ${BRANCH_ID}
    Set Global Variable    \${LATESTBRANCH}    ${LATESTBRANCH}
    Set Global Variable    \${URL}    ${URL}
    Run Keyword If    '${account}'=='admin'    Set Global Variable    \${USER_NAME}    ${USER_ADMIN}      ELSE      Set Global Variable    \${USER_NAME}    ${USER_ND}
    Set Global Variable    \${USER_ADMIN}    ${USER_ADMIN}
    Set Global Variable    \${PASSWORD}    ${PASSWORD}
    Set Global Variable    \${REMOTE_URL}    ${remote}
    Set Global Variable    \${RETAILER_NAME}    ${RETAILER_NAME}
    Set Global Variable    \${SALE_API_URL}    ${SALE_API_URL}
    Set Global Variable    \${PROMO_API}    ${PROMO_API}
    Set Global Variable    \${WARRANTY_API}    ${WARRANTY_API}
    Set Global Variable    \${IS_HEADLESS_BROWSER}    ${headless_browser}
    Set Global Variable    \${TIMESHEET_API}    ${TIMESHEET_API}

Headless Chrome - Open Browser
    [Arguments]     ${link_url}
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    disable-gpu
    Call Method    ${chrome_options}   add_argument    enable-automation
    Call Method    ${chrome_options}   add_argument    no-sandbox
    Call Method    ${chrome_options}   add_argument    disable-extensions
    Call Method    ${chrome_options}   add_argument    disable-browser-side-navigation
    Call Method    ${chrome_options}   add_argument    --disable-notifications
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Wait Until Keyword Succeeds    3x   0.5s    Open Browser    ${link_url}    browser=chrome    remote_url=${REMOTE_URL}    desired_capabilities=${options}
    Set Window Size    1920    1080

Open Chrome no notifications
    [Arguments]     ${link_url}
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    --disable-notifications
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Wait Until Keyword Succeeds    3x   0.5s    Open Browser    ${link_url}    browser=chrome    remote_url=${REMOTE_URL}    desired_capabilities=${options}

KV Prepare Profile Folder
    :FOR    ${key}    IN    @{DICT_PROFILE}
    \    ${is_exist_profile_folder}    Run Keyword And Return Status    Directory Should Exist    C:\\Automation\\profiles\\chrome\\${DICT_PROFILE["${key}"]}
    \    Run Keyword If    '${is_exist_profile_folder}'=='False'    Extract Zip File    ${EXECDIR}\\Profile-Template.zip    C:\\Automation\\profiles\\chrome\\${DICT_PROFILE["${key}"]}
    \    ${is_exist_profile_download_folder}    Run Keyword And Return Status    Directory Should Exist    C:\\Automation\\profiles\\chrome\\${DICT_PROFILE["${key}"]}\\downloads
    \    Run Keyword If    '${is_exist_profile_download_folder}'=='False'    Create Directory    C:\\Automation\\profiles\\chrome\\${DICT_PROFILE["${key}"]}\\downloads

Cache Chrome - Open Browser
    [Arguments]     ${link_url}
    KV Prepare Profile Folder
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${PROFILE}    set variable    ${DICT_PROFILE['live1']}
    Call Method    ${chrome_options}   add_argument    user-data-dir\=C:\\Automation\\profiles\\chrome\\${PROFILE}
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Open Browser    ${link_url}    browser=chrome    remote_url=http://localhost:9999/wd/hub    desired_capabilities=${options}
    Set Window Size    1920    1080

Setup Test Suite
    [Arguments]    @{keyword}
    Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
    Set Selenium Speed    0.1
    Run Keywords    @{keyword}

Cache Chrome - Before Ban Hang for testing
    [Arguments]     ${link_url}
    KV Prepare Profile Folder
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${PROFILE}    set variable    ${DICT_PROFILE['live1']}
    Call Method    ${chrome_options}   add_argument    user-data-dir\=C:\\Automation\\profiles\\chrome\\${PROFILE}
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    #Set Window Size    1920    1080
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}      desired_capabilities=${options}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Keyword Succeeds    3 times    2 s    Deactivate print preview page

Init Test Environment
    [Arguments]    ${env}    ${remote}    ${account}      ${headless_browser}
    Fill env    ${env}    ${remote}     ${account}      ${headless_browser}
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Append To Environment Variable    PATH    ${EXECDIR}${/}drivers
    Set Screenshot Directory    ${EXECDIR}${/}out${/}failures
    Set Selenium Speed    0.3s

Init Test Environment Before Test Ban Hang Co API
    [Arguments]    ${env}    ${remote}    ${account}      ${headless_browser}
    Fill env    ${env}    ${remote}     ${account}      ${headless_browser}
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Set Screenshot Directory    ${EXECDIR}${/}out${/}failures
    Set Selenium Speed    0.3s
    Before Test Ban Hang

Init Test Environment Before Test Quản Lý Có API
    [Arguments]    ${env}    ${remote}    ${account}      ${headless_browser}
    Fill env    ${env}    ${remote}     ${account}      ${headless_browser}
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Set Screenshot Directory    ${EXECDIR}${/}out${/}failures
    Set Selenium Speed    0.3s
    Before Test Quản Lý

Init Test Environment For Import Export File By UI
    [Arguments]    ${env}    ${remote}    ${account}      ${headless_browser}
    Fill env    ${env}    ${remote}     ${account}      ${headless_browser}
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Set Screenshot Directory    ${EXECDIR}${/}out${/}failures
    Set Selenium Speed    0.3s
    Before Test Import Export File

Init Test Direct Page
     [Arguments]    ${env}    ${remote}
     Set Global Variable    \${BROWSER}    Chrome
     Set Global Variable    ${env}    live1
     Set Global Variable    \${REMOTE_URL}    ${remote}
     Append To Environment Variable    PATH    ${EXECDIR}${/}drivers
     Set Screenshot Directory    ${EXECDIR}${/}out${/}failures
     Set Selenium Speed    0.6s

Before Test Ban Hang
    [Timeout]    10 minutes
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login MHBH    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s   Deactivate print warranty and preview page

Before Test Quản Lý
    [Timeout]    10 minutes
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login MHQL    ${USER_NAME}    ${PASSWORD}

Before Test Ban Hang with other user
    [Timeout]    10 minutes
    [Arguments]    ${input_ten_user}    ${input_pass}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    2 s    Login    ${input_ten_user}    ${input_pass}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print preview page

Before Test Ban Hang deactivate print warranty
    [Timeout]    10 minutes
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print warranty and preview page

Before Test turning on display mode
    [Arguments]    ${xpath_icon_tuychonhienthi}
    [Timeout]    10 minutes
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print preview page
    Wait Until Keyword Succeeds    3 times    5s    Go to tuy chon hien thi    ${xpath_icon_tuychonhienthi}

Before Test creating new product
    [Timeout]
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Go To Danh Muc Hang Hoa

Before Test Quan ly
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Run Keyword If    '${URL}'!='https://fnb.kiotviet.vn'    Wait Until Keyword Succeeds    3 times    5s    Login     ${USER_NAME}    ${PASSWORD}    ELSE    Wait Until Keyword Succeeds    3 times    5s    Login Fnb    ${RETAILER_NAME}     ${USER_NAME}    ${PASSWORD}
    #Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}

After Test
    #Click Element JS    //div[@class='wrapper invoice']
    Close All Browsers

After Test Promotion
    [Arguments]      ${promotion_code}    ${status}
    Set Test Variable    \${promotion_code}    ${input_khuyemmai}
    Toggle status of promotion    ${promotion_code}    ${status}
    Close All Browsers

After Test API Promotion
    [Arguments]      ${promotion_code}    ${status}
    Toggle status of promotion    ${promotion_code}    ${status}

After Test multiple tests in MHBH
    Run Keyword If Test Failed    Click Element JS    ${button_bh_thanhtoan}
    Close All Browsers

Before Test BH co giao hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Page Contains Element    ${checkbox_delivery}    2 mins
    Click Element JS    ${checkbox_delivery}
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print preview page
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print delivery

Before Test Kiem Kho
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}
    Go to Kiem kho

Before Test Banhang with popup
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    1 min    5s    Access page    ${button_banhang_login}
    Maximize Browser Window
    Login MHBH frm Quanly    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_dong_popup}    2 mins
    Wait Until Keyword Succeeds    1 min    5sec    Click Element JS    ${button_dong_popup}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    1 min    30 sec    Deactivate print preview page

Before Test Inventory Transfer
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}
    Go To Inventory Transfer

Headless Before Test Ban Hang
    [Timeout]    3 minutes
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    #my_create_webdriver    Chrome    ${options}
    create webdriver    Chrome    chrome_options=${options}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Maximize Browser Window
    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    1 min    5sec    Deactivate print preview page

Before Test Sale IMEI
    [Arguments]    ${dict}
    [Timeout]    3 mins
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    ${imei_by_product_inlist}    create list
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_prs}    ${list_num}
    \    ${imei_by_product}    Import multi imei for product    ${item_product}    ${item_num}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    Set Test Variable    \${imei_inlist}    ${imei_by_product_inlist}
    Set Test Variable    \${list_prs}    ${list_prs}
    Set Test Variable    \${list_num}    ${list_num}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    5s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    2 s    Deactivate print preview page

Before Test Inventory Transfer Imei
    [Arguments]    ${dict}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    ${imei_by_product_inlist}    create list
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_prs}    ${list_num}
    \    ${imei_by_product}    Import multi imei for product    ${item_product}    ${item_num}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    Set Test Variable    \${imei_inlist}    ${imei_by_product_inlist}
    Set Test Variable    \${list_prs}    ${list_prs}
    Set Test Variable    \${list_num}    ${list_num}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Go To Inventory Transfer

Before Test Import Product
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    #Wait Until Keyword Succeeds    3 times    2 s    Access page    ${button_banhang_login}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    3s    Go To nhap Hang

Access page
    [Arguments]    ${location_get_text}    ${text}
    : FOR    ${checkStatus}    IN RANGE    0
    \    ${status}    Get Matching Xpath Count    ${location_get_text}
    \    Exit For Loop If    ${status}>0    # Break out of loop if status is expected value
    \    Run Keyword    Reload Page

Get text on page and wait until it is visible
    [Arguments]    ${location_get_text}
    Wait Until Element Is Enabled    ${location_get_text}    1 min
    ${status}    Get Text    ${location_get_text}
    Wait Until Page Contains    ${status}    2 mins    # Check that the element exists
    Return From Keyword    ${status}

Before Test Thiet lap gia
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Set Selenium Speed    0.1
    Wait Until Keyword Succeeds    3 times    5 s    Go to Thiet lap gia

Before Test Xuat Huy
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Xuat Huy

Before Test Hang Hoa
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    3 times    2s    Click DMHH

Before Test So Quy
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    15s    Go to So quy

Before Test Dat Hang Nhap
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Dat Hang Nhap

Before Test Tra Hang Nhap
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go To Tra Hang Nhap

Before Test Doi Tac Khach Hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Khach Hang
    #Create new customer       ${cus1_name}
    #Create new customer       ${cus2_name}
    #Set Suite Variable    ${cus1_name}    \${cus1_name}
    #Set Suite Variable    ${cus2_name}    \${cus2_name}

Before Test Nha Cung Cap
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Nha cung cap

Before Test Doi Tac Giao Hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Doi Tac Giao hang
    Wait Until Keyword Succeeds    3 times    5s    KV Click Element JS     ${tab_khac}


Before Test BC Cuoi Ngay
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC cuoi ngay

Before Test BC Ban Hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC ban hang

Before Test BC Dat Hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC dat hang

Before Test BC Hang Hoa
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC hang hoa

Before Test BC Khach Hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC khach hang

Before Test BC Nha Cung Cap
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC nha cung cap

Before Test BC Nhan Vien
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC nhan vien

Before Test BC Kenh Ban Hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC kenh ban hang

Before Test BC Tai Chinh
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to BC tai chinh

Before Test Dang Ky Shop Moi
    [Arguments]       ${remote}
    Open Browser    https://kiotviet.vn/?refcode=3670    gc    remote_url=${remote}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    3s    Element Should Be Visible    ${button_dky_dung_thu_mien_phi}

Before Test QL Dat Hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Dat hang

Before Test QL Hoa don
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Hoa don

Đi tới trang quản lý hoá đơn
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Hoa don

Before Test QL Tra hang
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    5s    Go to Tra hang

Before Test Banhang By Sale URL
    ${SALE_URL}      Set Variable    ${URL}/sale/#/
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser   ${SALE_URL}     ELSE    Open Browser    ${SALE_URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    2 s    Login MHBH      ${USER_NAME}    ${PASSWORD}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Keyword Succeeds    3 times    2 s    Deactivate print preview page

Before Test Nhan vien
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Run Keyword If    '${URL}'!='https://fnb.kiotviet.vn' and '${URL}'!='https://fnb.kvpos.com:59508'    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}    ELSE    Wait Until Keyword Succeeds    3 times    2 s    Login Fnb    ${RETAILER_NAME}     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Nhan vien

Before Test Bang tinh luong
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Run Keyword If    '${URL}'!='https://fnb.kiotviet.vn' and '${URL}'!='https://fnb.kvpos.com:59508'    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}    ELSE    Wait Until Keyword Succeeds    3 times    2 s    Login Fnb    ${RETAILER_NAME}     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Bang tinh luong

Before Test Bang tinh luong and switch branch
    [Arguments]   ${input_branch}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Run Keyword If    '${URL}'!='https://fnb.kiotviet.vn' and '${URL}'!='https://fnb.kvpos.com:59508'    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}    ELSE    Wait Until Keyword Succeeds    3 times    2 s    Login Fnb    ${RETAILER_NAME}     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    1 s    Switch Branch    Chi nhánh trung tâm    ${input_branch}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Bang tinh luong

Before Test Cham cong
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Run Keyword If    '${URL}'!='https://fnb.kiotviet.vn' and '${URL}'!='https://fnb.kvpos.com:59508'    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}    ELSE    Wait Until Keyword Succeeds    3 times    2 s    Login Fnb    ${RETAILER_NAME}     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Cham cong

Before Test Thiet lap hoa hong
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Run Keyword If   '${URL}'!='https://fnb.kiotviet.vn' and '${URL}'!='https://fnb.kvpos.com:59508'    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}    ELSE    Wait Until Keyword Succeeds    3 times    2 s    Login Fnb    ${RETAILER_NAME}     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Thiet lap hoa hong

Before Test Hang Hoa and set up folder download default
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${is_exist_download_folder}    Run Keyword And Return Status    Directory Should Exist    D:\\auto_download\\${env}
    Run Keyword If    '${is_exist_download_folder}'=='False'    Create Directory    D:\\auto_download\\${env}   ELSE    Empty Directory     D:\\auto_download\\${env}
    ${prefs}    Create Dictionary    download.default_directory=D:\\auto_download\\${env}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Call Method    ${chrome_options}   add_argument    headless
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Call Method    ${chrome_options}   add_argument    disable-gpu
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}    desired_capabilities=${options}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Set Window Size    1920    1080
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    15s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    3 times    15s    Click DMHH

Before Test PHieu bao hanh
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to PHieu bao hanh

Before Test San xuat
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go To San Xuat

Before Test Yeu Cau Sua Chua
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    2 s    Login     ${USER_NAME}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    2 s    Go to Yeu Cau Sua Chua

Before Test Shopee
    [Arguments]     ${input_taikhoan}    ${input_matkhau}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    https://uat.shopee.vn/buyer/login      ELSE    Open Browser    https://uat.shopee.vn/buyer/login    ${BROWSER}    remote_url=${REMOTE_URL}
    Maximize Browser Window
    Login Shopee    ${input_taikhoan}    ${input_matkhau}

Before Test Lazada
    [Arguments]     ${input_taikhoan}    ${input_matkhau}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    https://member.lazada.vn/user/login      ELSE    Open Browser    https://member.lazada.vn/user/login    ${BROWSER}    remote_url=${REMOTE_URL}
    Maximize Browser Window
    Login to Lazada    ${input_taikhoan}    ${input_matkhau}

Before Test QLKV
    [Arguments]     ${input_qlkv_user}    ${input_qlkv_pass}
    Set Selenium Speed    0.1
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    https://qlkv.kvpos.com:${env}      ELSE    Open Browser    https://qlkv.kvpos.com:${env}    ${BROWSER}    remote_url=${REMOTE_URL}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1s    Login QLKV      ${input_qlkv_user}    ${input_qlkv_pass}

Before Test Facebook POS
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Headless Chrome - Open Browser    ${URL}      ELSE    Open Chrome no notifications    ${URL}
    Wait Until Keyword Succeeds    3 times    5s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Run Keyword If    '${URL}'!='https://fnb.kiotviet.vn'    Wait Until Keyword Succeeds    3 times    5s    Login     ${USER_NAME}    ${PASSWORD}    ELSE    Wait Until Keyword Succeeds    3 times    5s    Login Fnb    ${RETAILER_NAME}     ${USER_NAME}    ${PASSWORD}
    KV Click Element    ${button_facebook}
    Login Facebook    minhthuytest    Citigo@1234

Before Test and set up folder download default
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${is_exist_download_folder}    Run Keyword And Return Status    Directory Should Exist    C:\\auto_download\\${env}
    Run Keyword If    '${is_exist_download_folder}'=='False'    Create Directory    C:\\auto_download\\${env}   ELSE    Empty Directory     C:\\auto_download\\${env}
    ${prefs}    Create Dictionary    download.default_directory=C:\\auto_download\\${env}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Call Method    ${chrome_options}   add_argument    headless
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Call Method    ${chrome_options}   add_argument    disable-gpu
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}    desired_capabilities=${options}
    Run Keyword If    '${IS_HEADLESS_BROWSER}'=='T'   Set Window Size    1920    1080
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login MHQL    ${USER_NAME}    ${PASSWORD}

Before Test Import Export File
    Create Directory    ${pathToExportFile}
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}    Create Dictionary    download.default_directory=${pathToExportFile}
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}    desired_capabilities=${options}
    Wait Until Keyword Succeeds    3 times    2 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    1 s    Login    ${USER_NAME}    ${PASSWORD}

After Test Import Export
    Empty Directory    ${pathToExportFile}
    Remove Directory     ${pathToExportFile}
    Close All Browsers
