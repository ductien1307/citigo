*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../Sources/hanghoa.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_access.robot

*** Variables ***

@{prodcode6}     DVTDE04      QDDE004      TPDEC03      HDEC003      DVTDE03      QDDE003      TPDEC02      HDEC002      DVTDE02      QDDE002      HDEC001      DVDEC01      SIDEC001      DVTDE01      QDDE001      TPDEC01      Combo300      Combo299      Combo298      Combo297      Combo296      Combo295      Combo294      Combo293      Combo292      Combo291      Combo290      Combo289      Combo288      Combo287      Combo286      HHTK02      HHTK01      SI250      SI249      SI248      SI247      SI246      SI245      SI244      SI243      SI242      SI241      SI240      SI239      SI238      SI237      SI236      SI235      SI234      SI233      SI232      SI231      SI230      SI229      SI228      SI227      SI226      SI225      SI224      SI223      SI222      SI221      SI220      SI219      SI218      SI217      SI216      SI215      SI214      SI213      SI212      SI211      SI210      SI209      SI208      SI207      SI206      SI205      SI204      SI203      SI202      SI201      SI200      SI199      SI198      SI197      SI196      SI195      SI194      SI193      SI192      SI191      SI190      SI189      SI188      SI187      SI186      SI185      SI184      SI183      SI182      SI181      SI180      SI179      SI178      SI177      SI176      SI175      SI174      SI173      SI172      SI171      SI170      SI169      SI168      SI167      SI166      SI165      SI164      SI163      SI162      SI161      SI160      SI159      SI158      SI157      SI156      SI155      SI154

@{prodcode17}        DV069      DV068      DV067      DV066      SI030      SI029      TP108      TP107      TP106      SI028      DV065      TP105      TP104      TP103      TP102      DV064      TP101      TP100      DV063      TP099      TP098      TP097      DV062      TP096      TP095      DV061      TP094      SI027      TP093      TP092      TP091      TP090      DV060      DVTD02      QDD0102      TP089      DVT72      QD139      TP088      DVT71      QD138      TP087      TP086      DVT70      QD137      TP085      DV059      DVT69      QD136      TP084      TP083      TP082      DVT68      QD135      TP081      HHD074      DVT67      QD134      TP080      HHD073      DV058      TP079      DVT66      QD133      HHD072      TP078      HHD071      DVT65      QD132      SI026      TP077      HHD070      DV057      DVT64      QD131      TP076      HH0069      TP075      DVT63      QD130      HH0068      TP074      HH0067      DVT62      QD129      TP073      HH0066      DV056      DVT61      QD128      TP072      HH0065      DVT60      QD127      TP071      HH0064      DVT59      QD126      TP070      DV055      HH0063      DVTD01      QDD01      QDD02      TP069      HH0062      TP068      HH0061      DVT58      QD124      QD125      DVT57      QD122      QD123      DVT56      QD120      QD121      DVT55      QD118      QD119      HH0060      DV054      HH0059      DVT54      QD116      QD117      TP067      HH0058      TP066      DVT53      QD114      QD115      HH0057      SI025      TP065      HH0056      DVT52      QD112      QD113      DV053      TP064      HH0055      TP063      DVT51      QD110      QD111      HH0054      TP062

@{prodcode21}        TP166      TP165      TP164      TP163      TP162      TP161      TP160      TP159      TP158      TP157      TP156      TP155      TP154      TP153      TP152      TP151      TP150      TP149      TP148      TP147      TP146      TP145      TP144      TP143      TP142      TP141      TP140      TP139      TP138      TP137      TP136      TP135      TP134      TP133      TP132      TP131      TP130      TP129      TP128      TP127      TP126      TP125      TP124      TP123      TP122      TP121      TP120      TP119       SI153      SI152      SI151      HH0125      DV133      HH0128      SI109      DV136      Combo285      Combo284      Combo283      Combo282      Combo281      Combo280      Combo279      Combo278      Combo277      Combo276      Combo275      Combo274      Combo273      Combo272      Combo271      Combo270      Combo269      Combo268      Combo267      Combo266      Combo265      Combo264      Combo263      Combo262      Combo261      Combo260      Combo259      Combo258      Combo257      Combo256        HH0053      DVT50      QD108      QD109      TP061      DV052      HH0052      TP060      DVT49      QD106      QD107      HH0051      TP059      DVT48      QD104      QD105      HH0050      TP058      HH0049      DV051      TP057      DVT47      QD102      QD103      TP056      HH0048      DVT46      QD100      QD101      HH0047      TP055

*** Test Cases ***    Ma SP
PIB                   [Tags]     DELP
                      [Template]                  Delete product list thr API
                      ${prodcode6}
                      ${prodcode17}
                      ${prodcode21}

*** Keywords ***
Delete product list thr API
    [Arguments]    ${list_product_codes}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${responseproductlist}    Get Request and return body    ${endpoint_pr}
    ${list_product_id}         Create list
    : FOR       ${item_product_code}     IN ZIP     ${list_product_codes}
    \      ${jsonpath_item_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${item_product_code}
    \      ${product_id}     Get data from response json    ${responseproductlist}    ${jsonpath_item_product_id}
    \      ${product_id}       Convert To String    ${product_id}
    \      Append to List         ${list_product_id}     ${product_id}
    Log     ${list_product_id}
    ${string_list_product_id}         Convert List to String       ${list_product_id}
    ${reqpayload}      Format String        {{"Ids":[{0}]}}        ${string_list_product_id}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}      cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    /products/deleteproductlist    data=${reqpayload}    headers=${headers1}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
