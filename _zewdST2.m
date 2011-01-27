%zewdST2 ; Sencha Touch Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 839)
 ; Build Date: Thu, 27 Jan 2011 18:45:44
 ; 
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-11 M/Gateway Developments Ltd,                        |
 ; | Reigate, Surrey UK.                                                      |
 ; | All rights reserved.                                                     |
 ; |                                                                          |
 ; | http://www.mgateway.com                                                  |
 ; | Email: rtweed@mgateway.com                                               |
 ; |                                                                          |
 ; | This program is free software: you can redistribute it and/or modify     |
 ; | it under the terms of the GNU Affero General Public License as           |
 ; | published by the Free Software Foundation, either version 3 of the       |
 ; | License, or (at your option) any later version.                          |
 ; |                                                                          |
 ; | This program is distributed in the hope that it will be useful,          |
 ; | but WITHOUT ANY WARRANTY; without even the implied warranty of           |
 ; | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            |
 ; | GNU Affero General Public License for more details.                      |
 ; |                                                                          |
 ; | You should have received a copy of the GNU Affero General Public License |
 ; | along with this program.  If not, see <http://www.gnu.org/licenses/>.    |
 ; ----------------------------------------------------------------------------
 ;
 QUIT
 ;
 ;
container(nodeOID,attrValue,docOID,technology)
 ;
 ;
 n attr,bodyOID,childNo,childOID,contentPage,debug,funcOID,headOID,htmlOID
 n images,jsOID,jsText,locale,mainAttrs,OIDArray,path,resourcePath,rootPath
 n tagName,text,title,xOID
 ;
 ;<st:container rootPath="/sencha-1.0/" contentPage="intro" title="ST Demo App">
 ;  <st:images>
 ;    <st:image type="tabletStartupScreen" src=/images/tablet_startup.png" />
 ;    <st:image type="phoneStartupScreen" src="/images/phone_startup.png" />
 ;    <st:image type="icon" src="/images/icon.png" addGloss="true" />
 ;  </st:images>
 ;</st:container>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s contentPage=$g(mainAttrs("contentpage"))
 i contentPage="" s contentPage="pageNotDefined"
 s title=$g(mainAttrs("title"))
 i title="" s title="EWD/Sencha Touch Application"
 s rootPath=$g(mainAttrs("rootpath"))
 i rootPath="" s rootPath="/sencha/"
 s rootPath=$$addSlashAtEnd^%zewdST(rootPath)
 s debug=$g(mainAttrs("debug"))
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:images" d images(childOID,.images)
 . i tagName="st:locale" d locale(childOID,.locale)
 ;
 s htmlOID=$$addElementToDOM^%zewdDOM("ewd:xhtml",nodeOID)
 ; head
 s headOID=$$addElementToDOM^%zewdDOM("head",htmlOID)
 ;
 s attr("http-equiv")="Content-Type"
 s attr("content")="text/html; charset=utf-8"
 s xOID=$$addElementToDOM^%zewdDOM("meta",headOID,,.attr)
 ;
 s xOID=$$addElementToDOM^%zewdDOM("title",headOID,,,title)
 ;
 s attr("rel")="stylesheet"
 s attr("type")="text/css"
 s attr("href")=rootPath_"resources/css/sencha-touch.css"
 s xOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr)
 ;
 s attr("type")="text/javascript"
 s attr("src")=rootPath_"sencha-touch.js"
 i debug="true" s attr("src")=rootPath_"sencha-touch-debug.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 d createJSFile^%zewdST("stJS","ewdSTJS.js")
 s path=$g(^zewd("config","jsScriptPath",technology,"path"))
 s path=$$addSlashAtEnd^%zewdST(path)
 s attr("type")="text/javascript"
 s attr("src")=path_"ewdSTJS.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="script" d
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s xOID=$$appendChild^%zewdDOM(childOID,headOID)
 ;
 s attr("type")="text/javascript"
 s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s text=""
 s text=text_"Ext.setup({"
 s text=text_"tabletStartupScreen:'"_images("tabletStartupScreen","src")_"',"
 s text=text_"phoneStartupScreen:'"_images("phoneStartupScreen","src")_"',"
 s text=text_"icon:'"_images("icon","src")_"',"
 s text=text_"addGlossToIcon:"_images("icon","addgloss")_","
 s text=text_"onReady:function(){"
 s text=text_"EWD.sencha.loadContentPage()"
 s text=text_"}"
 s text=text_"});"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 s attr("return")="EWD.sencha.loadContentPage"
 s attr("addVar")="false"
 s attr("parameters")=""
 s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",jsOID,,.attr)
 ;
 s jsText=""
 i $g(locale("dateformat"))'="" s jsText=jsText_"Ext.util.Format.defaultDateFormat='"_locale("dateformat")_"';"_$c(13,10)
 s jsText=jsText_"ewd.ajaxRequest("""_contentPage_""",""ewdContent"");"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",funcOID,,,jsText)
 ;
 ;s attr("onLoad")="EWD.sencha.loadContentPage();"
 s bodyOID=$$addElementToDOM^%zewdDOM("body",htmlOID,,.attr)
 ;
 s attr("id")="ewdNullId"
 s attr("style")="display:none"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 s attr("id")="ewdContent"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
images(nodeOID,images)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:image" d image(childOID,.images)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
image(nodeOID,images)
 ;
 ;    <st:image type="tabletStartupScreen" src=/images/tablet_startup.png" />
 ;    <st:image type="phoneStartupScreen" src="/images/phone_startup.png" />
 ;    <st:image type="icon" src="/images/icon.png" addGloss="true" />
 ;
 n mainAttrs,type
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i $g(mainAttrs("type"))="" QUIT
 s type=mainAttrs("type")
 i $g(mainAttrs("src"))="" QUIT
 i type="icon",$g(mainAttrs("addgloss"))="" s mainAttrs("addgloss")="false"
 m images(type)=mainAttrs
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
locale(nodeOID,images)
 ;
 ;    <st:locale dateFormat="d/m/Y" />
 ;
 n mainAttrs,type
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 m locale=mainAttrs
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
qrCode(nodeOID,attrValue,docOID,technology)
 ;
 n attr,blockSize,correctionLevel,data,id,jsOID,jsText,mainAttrs,pointSize,stOID,xOID
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s blockSize=$g(mainAttrs("blocksize")) i blockSize="" s blockSize=7
 s correctionLevel=$g(mainAttrs("correctionlevel")) i correctionLevel="" s correctionLevel="H"
 s data=$g(mainAttrs("data")) i data="" s data="Undefined QRCode"
 s id=$g(mainAttrs("id")) i id="" s id="ewdSTQRCode"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s pointSize=$g(mainAttrs("pointsize")) i pointSize="" s pointSize=4
 ;
 s jsText="EWD.sencha.qrCode.draw({pointSize:"_pointSize_",correctionLevel:'"_correctionLevel_"',blockSize:"_blockSize_",data:'"_data_"',id:'"_id_"'});"
 s jsOID=$$createJS^%zewdST("standard")
 s stOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,jsText)
 ;
 s attr("id")=id
 s xOID=$$addElementToDOM^%zewdDOM("canvas",nodeOID,,.attr)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
writeCheckboxes(sessionName,jsVarName,idRoot,nameRoot,checkIf,labelAlign,sessid)
 ;
 n array,code,no,plist,result,text,x
 ;
 d mergeArrayFromSession^%zewdAPI(.plist,sessionName,sessid)
 s no=""
 f  s no=$o(plist(no)) q:no=""  d
 . s code=$g(plist(no,"code"))
 . s text=$g(plist(no,"text"))
 . s array(1,"zobj"_no,"id")=idRoot_no
 . s array(1,"zobj"_no,"label")=text
 . s array(1,"zobj"_no,"labelAlign")=labelAlign
 . s array(1,"zobj"_no,"name")=nameRoot_code
 . s array(1,"zobj"_no,"xtype")="checkbox"
 . s array(1,"zobj"_no,"listeners","zobj1","check")="<?= EWD.sencha.checkBoxHandler ?>"
 . i $g(checkIf)'="" d
 . . i $e(checkIf,1,5)="class" s checkIf="##"_checkIf
 . . i $e(checkIf,1,2)'="$$",$e(checkIf,1,2)'="##" s checkIf="$$"_checkIf
 . . i checkIf'["(code,text,sessid)" s checkIf=checkIf_"(code,text,sessid)"
 . . s x="s result="_checkIf
 . . x x
 . . i result s array(1,"zobj"_no,"checked")="true"
 ;
 w jsVarName_"="
 d walkObjectArray^%zewdCompiler19("array")
 w ";"
 w $c(13,10)
 QUIT
 ;
writeMenuOptions(sessionName,jsVarName,sessid)
 ;
 n array,len,no,plist,xno
 ;
 d mergeArrayFromSession^%zewdAPI(.plist,sessionName,sessid)
 s no=""
 f  s no=$o(plist(no)) q:no=""  d
 . s xno="0000"_no
 . s len=$l(xno)
 . s xno=$e(xno,len-3,len)
 . s array(1,"zobj"_xno,"text")=plist(no,"text")
 . s array(1,"zobj"_xno,"key")=no
 . s array(1,"zobj"_xno,"id")=sessionName_no
 . s array(1,"zobj"_xno,"leaf")="<?= true ?>"
 ;
 w jsVarName_"="
 d walkObjectArray^%zewdCompiler19("array")
 w ";"
 w $c(13,10)
 ;
 w "Ext.regModel('"_jsVarName_"List',{"
 w "fields: [{name: 'text',type: 'string'},{name: 'key',type: 'string'}]"
 w "});"
 w jsVarName_"Store=new Ext.data.TreeStore({"
 w "model: '"_jsVarName_"List',"
 w "root: {"
 w "items: "_jsVarName
 w "},"
 w "proxy: {type: 'ajax',reader: {type: 'tree',root: 'items'}}"
 w "});"
 ; 
 QUIT
 ;
replaceMenuOptions(sessionName,sessid)
 ;
 n array,in,no
 ;
 d mergeArrayFromSession^%zewdAPI(.in,sessionName,sessid)
 s no=""
 f  s no=$o(in(no)) q:no=""  d
 . s array(1,"zobj"_no,"text")=in(no)
 . s array(1,"zobj"_no,"leaf")="<?= true ?>"
 . s array(1,"zobj"_no,"key")=no
 w "EWD.sencha.mainMenu="
 d walkObjectArray^%zewdCompiler19("array")
 w ";"
 w $c(13,10)
 w "EWD.sencha.replaceNavigationMenu();"_$c(13,10)
 QUIT
 ;
insertNewNextSibling(elementName,nodeOID)
 ;
 n elOID,nsOID,parentOID
 ;
 s elOID=$$createElement^%zewdDOM(elementName,docOID)
 s nsOID=$$getNextSibling^%zewdDOM(nodeOID)
 i nsOID'="" d
 . s elOID=$$insertBefore^%zewdDOM(elOID,nsOID)
 e  d
 . s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 . s elOID=$$appendChild^%zewdDOM(elOID,parentOID)
 ;
 QUIT elOID
 ;
getCamelCase(string,options)
 ;
 n camelCase
 ;
 s camelCase=$g(options(string))
 i camelCase="" s camelCase=string
 ;
 QUIT camelCase
 ;
defineCamelCaseTerms(options)
 ;
 n line,lineNo
 ;
 k options
 f lineNo=1:1 s line=$t(camelCaseTerms+lineNo) q:line["***END***"  d
 . s line=$p(line,";;",2,200)
 . s options($$zcvt^%zewdAPI(line,"l"))=line
 QUIT
 ;
convertAttrsToCamelCase(mainAttrs)
 ;
 n attrcc,attrlc,copyAttrs,terms
 ;
 m copyAttrs=mainAttrs
 k mainAttrs
 d defineCamelCaseTerms(.terms)
 s attrlc=""
 f  s attrlc=$o(copyAttrs(attrlc)) q:attrlc=""  d
 . s attrcc=$$getCamelCase(attrlc,.terms)
 . s mainAttrs(attrcc)=copyAttrs(attrlc)
 QUIT
 ;
convertToCamelCase(string)
 ;
 n terms
 ;
 d defineCamelCaseTerms(.terms)
 QUIT $$getCamelCase(string,.terms)
 ;
camelCaseTerms
 ;;activeCls
 ;;activeItem
 ;;autoDestroy
 ;;baseCls
 ;;baseParams
 ;;bodyBorder
 ;;bodyMargin
 ;;bodyPadding
 ;;bubbleEvents
 ;;cardSwitchAnimation
 ;;componentCls
 ;;componentLayout
 ;;contentEl
 ;;dayText
 ;;defaultType
 ;;disabledClass
 ;;disabledCls
 ;;dockedItems
 ;;doneButton
 ;;enterAnimation
 ;;exitAnimation
 ;;floatingCls
 ;;hideOnMaskTap
 ;;itemTpl
 ;;labelWidth
 ;;layoutConfig
 ;;layoutOnOrientationChange
 ;;labelAlign
 ;;maxHeight
 ;;maxWidth
 ;;minHeight
 ;;minWidth
 ;;monitorOrientation
 ;;monthText
 ;;overCls
 ;;renderSelectors
 ;;renderTo
 ;;renderTpl
 ;;showAnimation
 ;;slotOrder
 ;;standardSubmit
 ;;stopMaskTapEvent
 ;;stretchX
 ;;stretchY
 ;;styleHtmlCls
 ;;styleHtmlContent
 ;;submitOnAction
 ;;tplWriteMode
 ;;useTitles
 ;;waitTpl
 ;;yearFrom
 ;;yearText
 ;;yearTo
 ;;***END***
 ;;
uiJS ;;
 ;;EWD.sencha.loadMenu = function() {
 ;; ewd.ajaxRequest("<launchPage>","st-uui-launchScreenContents");
 ;; <login>
 ;;};
 ;;EWD.sencha.resourcesPath = '<rootPath><uiPath>';
 ;;EWD.sencha.appTitle = {phone: '<phoneTitle>',tablet: '<tabletTitle>'};
 ;;EWD.sencha.navigationButtonText = '<navigationButtonText>';
 ;;EWD.sencha.codePanel = {scroll: 'vertical', height: <panelHeight>, width: <panelWidth>};
 ;;EWD.sencha.div = {nullId: '<nullId>',launchScreen: '<launchScreenId>'};
 ;;***END***
 ;;
