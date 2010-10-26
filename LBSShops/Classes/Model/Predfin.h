/*
 *  Predfin.h
 *  GtFund
 *
 *  Created by xie yilong on 10-6-29.
 *  Copyright 2010 xyl. All rights reserved.
 *
 */

//=======Lbs========

//172.16.10.3:8080
//58.246.47.44:8080/gtproxy
#define kDatabaseName  @"shops.sqlite"
#define kServerUrl @"http://172.16.60.2:8080/gtproxy/"
#define kMainServerUrl @"http://www.gtfund.com/"
//http://172.16.60.2:8080/gtproxy/
//http://182.180.58.251:8080/tbaxis
#define kSubmitUrl @"http://172.16.60.2:8080/gtproxy/servlet/document/iphone/submit.do"
//#define kQuitUrl @"http://IP地址:端口/gtfund/servlet/document/iphone/proxy.do"
#define kSaveUrl @"http://172.16.60.2:8080/gtproxy/servlet/document/iphone/submit.do"
#define kConfirmUrl @"http://172.16.60.2:8080/gtproxy/servlet/document/iphone/confirm.do"
#define kUpdateUrl @"http://172.16.60.2:8080/gtproxy/servlet/document/iphone/update.do"

#define kSetTimeoutInterval 9
///gtfund/servlet/document/iphone/proxy.do

#define kBackGroundImage  @"bg.png"
#define kBtnBackTitle @"返回"
#define kBackGroundLogin @"bglogin.png"

//报文详细信息
#define kName_view @"view"
#define kName_layout @"layout"
#define kName_type @"type"
#define kName_id @"id"
#define kName_label @"label"
#define kName_submit @"submit"
#define kName_visible @"visible"
#define kName_department @"department"
#define kName_onChange @"onchange"
#define kName_Multi @"multi"
#define kName_uid @"UID"
#define kName_readOnly @"ReadOnly"
#define kWF_NodeName @"WF_NodeName"
#define kViewOnchange @"onchange"
//

#define kName_layoutType  @"layout_type"
#define kName_layoutId @"layout_id"
#define kName_layoutVisible @"layout_visible"
//
#define kName_viewLabel @"view_label"
#define kName_viewType	@"view_type"
#define kName_viewId @"view_id"
#define kName_viewValue @"view_value"
#define kName_viewSubmit @"view_submit"
#define kName_viewVisible @"view_visible"
#define kName_viewDepartment @"view_department"
#define kName_viewMulti @"view_multi"
#define kName_viewTime @"view_time"
#define kName_viewUid @"view_UID"
#define kName_viewReadonly @"view_readOnly"
#define kName_viewNodeName @"WF_NodeName"
#define kName_viewClfsValue @"view_clfsValue"
#define kName_ViewOnchange  @"view_onchange"
 
#define kGroupSubmitList @"submitList"
#define kZyxxFirstGroup @"zyxx_firstGroup" //摘要信息第一个group
#define kZyxxBz  @"zyxx_bz"
#define kZyxxSqyj @"zyxx_sqyj"		//审签意见
#define kZyxxClfs @"zyxx_clfs"		//选择人员
#define kZwnr @"zwnr"				//正文内容
#define kBlqk @"blqk"				//办理情况
#define kFj @"fj"					//附件

#define kNull  @"nil"


#define kClfsRowCount  4  //处理方式中每个节点内容共有几行 userName,userId,userUid,userDepId

//报文列表
#define kDocumentType @"DocumentType"
#define kDocumentBrief @"DocumentBrief"
#define kDocumentId @"DocumentId"
#define kDocumentName @"DocumentName"
#define kDocumentState @"DocumentState"
#define kDocumentTime @"time"
#define kInfoId @"infoId"
#define kInfoId_1 @"infoId_1"



#define KImageViewTag 999
#define KLabelTag     998
#define KDetailLabelTag 997
#define KTextFieldTag  996
#define kTimeTag 995

#define kOpinionSize  CGSizeMake(180,400);

//sqlite 
#define SQLITE_ExistRow        99   //表示该行已经存在


//======medical===========

#define kButtonNormalLabX 50
#define kButtonNormalLabY 100
#define kButtonSize  CGSizeMake(220,50)
#define kButtonHighMagrin 70

//#define kDatabaseName  @"Medical"

#define klabNameTag	100   //LabListViewController LabName tag
#define kUsSiUnitsTag 99     //LabListViewController Units tag

#define kTableViewCellHeight 60
#define kCellDetailTextHeight 5


#define kLayerCornerRadius 6
#define kLayerBorderWidth 1

#define kStarYellowImage @"star_yellow.png"
#define kStarGrayImage @"star_gray.png"

#define kTitleFont [UIFont systemFontOfSize:17]
#define kFont 	[UIFont fontWithName:@"Arial" size:16]
#define kTextFont [UIFont systemFontOfSize:18] 

#define kMoreAppsUrl @"http://budurl.com/morehippoapps"

#define kFavoriteWillAddNote		@"Are you sure to add this item to your favorites list?"
#define kFavoriteAddedOKNote		@"Item has successfully been added to your Favorites List"
//#define kFavoriteAddedOKNote		@"Item has successfully added to your favorites list"

#define kFavoriteAddedFailedNote	@"Failed to add to your favorites list"
#define kFavoriteRemoveConfirm		@"Are you sure to remove this item from your favorites list?"
#define kFavoriteRemovedOKNote		@"Item has successfully removed from your favorites list"
#define kFavoriteRemovedFailedNote	@"Failed to remove from your favorites list"

#define kRemoveFavoriteButtonImage	@"star_yellow.png"
#define kAddFavoriteButtonImage		@"star_gray.png"


//=======jepoque========

// MUISpreadMenuView的常量
#define kSpreadMenuHeight 42
#define kSpreadMenuItemWidth 36
#define kSpreadMenuItemCount 6
#define kSpreadMenuMinItems 3

//Manifesto 界面设置
#define kManifestoMenuWidth 160
#define kManifestoMenuItemCount 3
#define kManifestoMenuItemHeight 25
#define kManifestoMenuItemGapHeight 100
#define kManifestoBgName @"BG.png"
#define kManifestoTitleImage @"Mani_title.png"//manifesto_title logo
#define kSpreadMenuAlpha 0.6  //MUISpreadMenuView 和 ManifestoViewController中button的alpha 值

//MUIVerticalCell中cell 设置
#define kVerticalCellHeight 160
#define kVerticalCellImageViewWidth 80
#define kVerticalCellImageViewHeight 80

//RootViewController 和 NewCollectionViewController 中imageview 和 label  的x 坐标 和width
//kleftlabelx 以左边为起点的label 的X坐标
//krightlabelx 以中间为起点的label 的X坐标
#define KImageViewX 5
#define KImageViewWidth 310
#define KLeftLabelX	15	
#define KLeftLabelWidth	150
#define KRightLabelX 60
#define KRightLabelWidth 220
#define KNewCollectionImageViewX 10
#define kTopButtonMargin 10
#define KNewCollectionImageViewWidth 47   //NewCollection 新图图档Size:98*61

//#define kDatabaseName  @"jepoque.sql" //数据库的名称

//DataSyncViewController web端获取数据的接口地址
#define kServerIPStr @"http://www.jiaju0797.com:88"
#define kServerPath @"http://www.jiaju0797.com:88/webaccess/v1.5/admin/"
#define KImageIpStr @"http://www.jiaju0797.com:88/webaccess/v1.5/admin/Images/"
/*
 //http://www.prosoft.com.tw/mobiledata/admin/index.html
 #define kServerIPStr @"http://www.prosoft.com.tw"
 #define kServerPath @"http://www.prosoft.com.tw/mobiledata/admin/"
 #define KImageIpStr @"http://www.prosoft.com.tw/mobiledata/admin/Images/" 
 */ 

#define kOnlyRunLocally 2  //如果kOnlyRunLocally 值为1 程序中运行所需的部分资源是从本地获取
#define kViewHeadHeight 48 //headView 的height
#define kTableViewHeadHeight 36

#define kViewBackgroundImageName @"Home_BG.png"
#define kViewListBGName @"List_BG.png" //带有白色透明的背景
#define KStoreDyImageName @"Store_DY.png"

//JEpoqe logo设置
#define kLogoImageMagrin 16   //JpLogo.png 的y 坐标值
#define kLogoImageName @"JpLogo.png"



//title label 的背景设置
#define kTableViewHeadBackgroundColor [UIColor colorWithWhite:0 alpha:0.6]

//Back 按钮设置
#define kBackButtonMagrin 10
#define kBackButtonTitle @"Back"
#define kBackButtonSize  CGSizeMake(57, 35)  
#define kBackButtonFrame  CGRectMake(0, 0, 57, 35)
#define kBackButtonFontSize 17   

#define kLogoAnimateInterval 0.36  //程序启动时加载logoAnimation图片的animationDuration值(单位秒)
#define kBTNSmallArrowImg  @"BTN_SmallArrow.png" //TableViewCell 最右边小箭头的名称

#define kCountForNotification 10


