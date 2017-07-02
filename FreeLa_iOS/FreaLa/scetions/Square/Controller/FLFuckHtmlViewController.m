//
//  FLFuckHtmlViewController.m
//  FreeLa
//
//  Created by Leon on 15/12/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLFuckHtmlViewController.h"
#import "FLPopBaseView.h"
#import "XJHtmlNeedModel.h"
#import "XJZhuLQShareViewController.h"
#import "XJCheckPublisherBusViewController.h"
#import "XJCheckPublisherViewController.h"
#import "XJLoadOutURLController.h"
#import "XJFreelaUVManager.h"
#import "XJShareContentModel.h"
#define xjSize_PageSize  20

@interface FLFuckHtmlViewController ()<UIWebViewDelegate,UIAlertViewDelegate,FLPopBaseViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate,UIScrollViewDelegate>

/**context*/
@property (nonatomic , strong) JSContext* flXQJSContext;
/**value*/
@property (nonatomic , strong) JSValue* flXQJSValue;
//@property (nonatomic , strong) WKWebView* xjview;
/**弹出层*/
@property (nonatomic , strong) FLPopBaseView* popView;

/**webView*/
@property (nonatomic , strong) UIWebView* webView;
/**详情数据模型*/
@property (nonatomic , strong) FLDetailsJSXQModel* fldetailJSXQModel;
/**详情字典*/
@property (nonatomic , strong)NSDictionary* myDicData;

//二次获取 传给 html
/**轮播图数组*/
@property (nonatomic , strong)NSArray* myDetailImageArray;

/**评分的星星*/
@property (nonatomic , strong)NSArray* myRankCountMapArray;
/**获取资格及原因*/
@property (nonatomic , strong)NSDictionary* myCheckQualificationData;
/**评价列表数组*/
@property (nonatomic , strong)NSMutableArray* myJudgeListArray;
/**评论列表数组*/
@property (nonatomic , strong)NSMutableArray* myJudgeListPLArray;
/**助力者列表数组*/
@property (nonatomic , strong)NSMutableArray* myActivityHelpListArray;
/**单条评论详情数组*/
@property (nonatomic , strong)NSArray* myJudgePLListArray;
/**导航view*/
@property (nonatomic , strong) UIView* flNaviView;

/**活动类型*/
@property (nonatomic , strong) NSString* flTopicType;
/**HTML Need Model*/
@property (nonatomic , strong) XJHtmlNeedModel *xjNeedModel;
/**menu to share*/
@property (nonatomic , strong) CHTumblrMenuView *menuView;
/**btn for go back*/
@property (nonatomic , strong) UIButton *xjGoBackBtn;
/**助力抢半圆里需要的参数*/
@property (nonatomic , strong) NSArray *xj;
/***/
@property (nonatomic , strong) XJShareContentModel* xjSharePlanModel;
/**
 *birdge
 */

/**给票券页准备的model*/
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;
@end
static NSInteger popViewTag;
@implementation FLFuckHtmlViewController {
    NSURLRequest *_request;
    NSInteger _flHTMLType; //用来加载那个js方法
    NSString* _flParentIdForReJudge; //用来恢复评论的参数 (父Id)
    NSArray*  _flRejudgeListArray;  //回评列表数组
    NSArray*  _flPartInfoListArray;   //获取填写领取信息
    NSArray* _flPerHelpListArray; //个人助力抢列表
    NSArray* _flTopicMessageArray; //活动发布者信息
    NSArray* _xjZhuliqiangTotalNumberArr; //助力抢界面总数据
    NSArray* _xjhowmanyPeopleTake; //总共多少人参与
    NSArray* _xjSearchHelpListNameArr; //助力抢已参与 搜索
    NSDictionary* _xjHTMLDetailDic;  //所有的 数据
    
    
    NSString* _flTopicImageStr; //缩略图
    NSArray* _flPVUVArr;   //统计数
    NSArray* _flHelpTitle;  //助力抢标题
    BOOL   _isHiddenNavi;//是否隐藏导航栏
    BOOL _isCollectionTopic;  //是否收藏
    BOOL _isRelayToPick ;  //是不是转发领
    BOOL _xjIsPartInListFull ;  //参与列表是否加载完毕
    BOOL _xjIsFriend;//是不是好友
    BOOL _xjIsRefresh; //是不是刷新
    BOOL _xjVersion_refresh; //用来刷新.html
    BOOL _xjIsJudgeListPLFull; //评论列表是否加载完毕
    BOOL _xjIsJudgeListPJFull; //评价列表是否加载完毕
    BOOL _xj_is_pariIn_show; //助力抢情况下是否 需要显示  您已参与成功字样
    BOOL _xj_is_Active ;//是否活跃界面
    BOOL _xj_is_search_page;//是不是搜索界面
    BOOL _xj_iszlListLoading;//助力抢列表是否正在加载
    
    NSInteger _xjPJTotalNumber; //评价列表总数
    NSInteger _xjPLTotalNumber;//评论列表总数
    NSInteger _xjPartInListCurrentPage; //参与列表当前页
    NSArray* _flIsBusAccount;//是否是个人
    NSString* _xjPerHelpListUserId; //获取个人助理列表的数据 userid
    NSInteger _xjzlqListCurrentPage;//参与列表 当前页
    
    NSDictionary* _xj_zlq_rankJson;//助力抢我的排名
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //     [self initWebViewInFuckHtml];
    _isHiddenNavi = NO;
    _isRelayToPick = NO;
    _xjIsRefresh = NO;
    _xjVersion_refresh= NO;
    _xj_is_pariIn_show = YES;
    _xj_is_Active = YES;
    _xj_iszlListLoading = NO;
    _xj_is_search_page=NO;
    self.view.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    self.myActivityHelpListArray = [NSMutableArray array];
    [self firstflIsCollectionTopic];
    [self initWebViewInFuckHtml];
    [self registerNSNotificationInFuckHtml];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjTextViewDidBeganToInputInHtmlPage:) name:UIKeyboardWillShowNotification object:nil];
    
}
#pragma  mark ---------------------------------lazy

- (FLDetailsJSXQModel *)fldetailJSXQModel {
    if (!_fldetailJSXQModel) {
        _fldetailJSXQModel = [[FLDetailsJSXQModel alloc] init];
    }
    return _fldetailJSXQModel;
}

- (XJShareContentModel *)xjSharePlanModel {
    if (!_xjSharePlanModel) {
        _xjSharePlanModel = [[XJShareContentModel alloc] init];
    }
    return _xjSharePlanModel;
}

- (NSDictionary *)flsquareAllFreeModel {
    if (!_flsquareAllFreeModel) {
        _flsquareAllFreeModel = [[NSDictionary alloc] init];
    }
    return _flsquareAllFreeModel;
}

- (NSMutableArray *)myJudgeListPLArray{
    if (!_myJudgeListPLArray) {
        _myJudgeListPLArray = [NSMutableArray array];
    }
    return _myJudgeListPLArray;
}

- (NSMutableArray *)myJudgeListArray {
    if (!_myJudgeListArray) {
        _myJudgeListArray = [NSMutableArray array];
    }
    return _myJudgeListArray;
}

- (void)setFlFuckTopicId:(NSString *)flFuckTopicId {
    _flFuckTopicId = flFuckTopicId; //topicId
    if ([XJFinalTool xjStringSafe:flFuckTopicId]) {
        [self getDetailsInfoInFuckHtmlVC];//获取详情页数据
        [MobClick event:@"fl_click_detail"];
    } else {
        [FLTool showWith:@"数据错误请稍后重新操作"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}
- (void)returnModelForTicketsWithData:(NSDictionary*)data {
    self.flmyReceiveMineModel.flIntroduceStr = data[@"topicExplain"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = data[@"topicId"];
    self.flmyReceiveMineModel.xjCreator = [data[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [data[@"userId"] integerValue];
    self.flmyReceiveMineModel.flTimeBegan = data[@"startTime"];
    self.flmyReceiveMineModel.xjinvalidTime = data[@"invalidTime"];
    self.flmyReceiveMineModel.xjUrl = data[@"url"];
    self.flmyReceiveMineModel.xjUserType = data[@"userType"];
    //    self.flmyReceiveMineModel.createTime = data[@"createTime"];
 
}

- (void)xjGetlingqushijian {
    if(!self.flmyReceiveMineModel.flDetailsIdStr){
        return;
    }
    FL_Log(@"this is the function for scrollview");
    NSDictionary* parm = @{@"participateDetailes.detailsid":self.flmyReceiveMineModel.flDetailsIdStr};
    [FLNetTool xjgetParticipateDetailesByIdWithParma:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is the function for balabala ==%@",dic);
        if ([dic[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* data = dic[@"data"];
            _flmyReceiveMineModel.flStateInt = [data[@"state"] integerValue];
            _flmyReceiveMineModel.xjUseTime = data[@"useTime"] ;
            _flmyReceiveMineModel.flDetailsIdStr = [data[@"detailsid"] stringValue];
            _flmyReceiveMineModel.createTime = data[@"createTime"];
            self.flmyReceiveMineModel.createTime = data[@"createTime"];
        }
        [self xjEndRefresh];
    } failure:^(NSError *error) {
        [self xjEndRefresh];
    }];
    //跳到票券
    XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
    ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
    FL_Log(@"this is teh action to push the page of ticke2t");
    [self.navigationController pushViewController:ticketVC animated:YES];
}

#pragma  mark ---------------------- main model 主要model
- (void)getDetailsInfoInFuckHtmlVC {
    NSString* xjStr = [NSString stringWithFormat:@"%@",FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID];
    if (!xjStr || [xjStr isEqualToString:@"(null)"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //    [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.webView];
    NSString* ddd = [XJFreelaUVManager xjSearchUVInLocationBySearchId:_flFuckTopicId];
    NSDictionary* parm = @{@"topic.topicId":_flFuckTopicId,
                           @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:_flFuckTopicId]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in details see html =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self xjEndRefresh];
            if ([[data[FL_NET_DATA_KEY] objectForKey:@"tempId"] integerValue]) {
                XJLoadOutURLController* xxx = [[XJLoadOutURLController alloc] init];
                xxx.xjTempId = [NSNumber numberWithInteger:[[data[FL_NET_DATA_KEY] objectForKey:@"tempId"] integerValue]];
                xxx.xjTopicIdStr = _flFuckTopicId;
                NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
                [array removeObject:self];
                [array addObject:xxx];
                if (_xj_is_Active) {
                    _xj_is_Active = NO;
                    [self.navigationController setViewControllers:array animated:YES];
                }
                //                [self.navigationController pushViewController:xxx animated:YES];
                return ;
            }
            _flTopicType = data[FL_NET_DATA_KEY][@"topicType"];
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:_flFuckTopicId];
            [self returnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
            _xjHTMLDetailDic = data;
            //            _flsquareAllFreeModel = data[FL_NET_DATA_KEY];
            _flsquareAllFreeModel = [FLTool returnDictionaryWithDictionary:data[FL_NET_DATA_KEY]];
            _xjNeedModel          = [XJHtmlNeedModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
            [self saveInfoInFuckHtmlWithData:_flsquareAllFreeModel];
            [self getHelpListHeadImageFromService]; //获取助力列表
            [self getJudgeListInHMLWithCurrentPage:@1]; //获取评论列表
            [self checkCanPickTopicInHTNL];    //判断是否具有领取资格
            //            [self flIsCollectionTopic]; //是否收藏
            [self getInfoMationInHTML];// 个人信息的
            [self xjCheckIsFriendOrNot];//判断是否为好友(关注)
            [self xjGetPartInfoList] ; //领取信息
            [self getPVUVWithTopicIdInHTML];//获取统计数
            [self xjSetProgressInDetails]; //设置进度条进度
            if([XJFinalTool xjStringSafe:data[FL_NET_DATA_KEY][@"participateId"]]) {
                [self xj_findmyrank:[NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][@"participateId"]]]; //查看排名
            }
        }
        [FLTool hideHUD];
    } failure:^(NSError *error) {
        [FLTool showWith:@"加载失败，请重新尝试"];
        [self.navigationController popViewControllerAnimated:YES];
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        [FLTool hideHUD];
    }];
}

- (JSContext *)flXQJSContext {
    if (!_flXQJSContext) {
        _flXQJSContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    return _flXQJSContext;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    //    [self.webView reload];
    _xj_is_Active = YES;
    if (_xj_is_Active&&self.webView) {
        [self xjRefreshHTMLView];
    }
    if (self.webView  && [XJFinalTool xj_is_phoneNumberBlind]) {
        [self checkCanPickTopicInHTNL];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request = %@ , type= %ld",request,(long)navigationType);
    NSString* str = [NSString stringWithFormat:@"%@",request.URL];
    if ([FLTool returnBoolWithIsHasHTTP:str includeStr:@"nima://"]) {
        NSInteger index = [str rangeOfString:@"nima://"].location;
        str = [str substringFromIndex:index + 7];
        FL_Log(@"this is function=%@",str);
        SEL selector = NSSelectorFromString(str);
        [self performSelector:selector withObject:nil];
    } else if ([FLTool returnBoolWithIsHasHTTP:str includeStr:@"js-call"]) {
        NSArray *components = [str  componentsSeparatedByString:@":"];
        NSString *commandName = (NSString*)[components objectAtIndex:1];
        NSString *argsAsString = [ (NSString*)[components objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
        NSDictionary* args = [FLTool returnDictionaryWithJSONString:argsAsString];
        if (args) {
            [self doSomethingWithName:commandName andObj:args];
        } else {
            [self doSomethingWithName:commandName andObj:argsAsString];
        }
    } else if ([FLTool returnBoolWithIsHasStringInclude:str includeStr:@".html"]) {
        _xj_is_search_page =NO;
        NSString* xjStr ;
        NSInteger index = [str rangeOfString:@".html"].location;
        xjStr = [str substringToIndex:index];
        //倒序拿到第一个@"/"
        if ([xjStr rangeOfString:@"/" options:NSBackwardsSearch].location != NSNotFound) {
            NSInteger xjIndex = [xjStr rangeOfString:@"/" options:NSBackwardsSearch].location;
            xjStr = [xjStr substringFromIndex:xjIndex + 1];
            FL_Log(@"this is function2=%@",xjStr);
            xjStr = [NSString stringWithFormat:@"xjTest%@",xjStr];
            [self doSomethingWithName:xjStr andObj:nil];
            if ([xjStr isEqualToString:@"xjTestzhuliqiang"] || [xjStr isEqualToString:@"xjTestrelay"]) {
                [self getHelpListHeadImageFromService];  //助力列表
                if (self.xjIsPushIn) {
                    if ([xjStr isEqualToString:@"xjTestrelay"]) {
                        [self getRejudgeListInHTML];
                    }
                    self.xjIsPushIn = NO;
                    self.xjGoWhere = nil;
                    return YES;
                } else if (!self.xjGoWhere){
                    return YES;
                } else {
                    return NO;
                }
            } else if ([xjStr isEqualToString:@"xjTestcanyulist"]) {
                [self getHelpListHeadImageFromService]; //助力列表
            } else if ([xjStr isEqualToString:@"xjcommentlist"]) {
                
            } else if ([xjStr isEqualToString:@"xjTestsearchpomoate"]) {
                _xj_is_search_page =YES;
            }
            
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"_webview start to load");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"_webview did finished load");
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [self setInfoToHTMLToReload];
    
    self.flXQJSContext[@"FLMethodXQModel"] = self.fldetailJSXQModel;
    self.fldetailJSXQModel.jsContext = self.flXQJSContext;
    self.fldetailJSXQModel.webView = self.webView;
    
    self.flXQJSContext.exceptionHandler = ^(JSContext* context, JSValue* exceptionValue){
        context.exception = exceptionValue;
        //        FL_Log(@"error in fuck html = %@",exceptionValue);
    };
    [FLTool hideHUD];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_xjNeedModel.topicNum) {    //设置滚动进度
            float xjFloat =  _xjNeedModel.receiveNum * 100 /  _xjNeedModel.topicNum ;
            NSString* xj = [FLTool getTheCorrectNum:[NSString stringWithFormat:@"%f",xjFloat]];
            [self callJSInHTMLWithMethod:@"xjSetProgressInHtml" Data:@[xj]];
        }
        if (_flsquareAllFreeModel) {
            [self callJSInHTMLWithMethod:@"xjSetBanYuanInfo" Data:@[[FLTool xj_returnJsonWithObj:_flsquareAllFreeModel]]]; //助力抢 总数据   ,模型
        }
    });
}

#pragma mark --- setInfo ---- --- -- --this is important调用接口
- (void)setInfoToHTMLToReload {
    //赋值
   
    if (_xjHTMLDetailDic) {
        NSString* json = [FLTool xj_returnJsonWithObj:_xjHTMLDetailDic];
        [self callJSInHTMLWithMethod:@"flGetJSXQInfomation" Data:@[json]];//活动详情
        //        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"flGetJSXQInfomation(%@)",json]];
    }
    if ( _myRankCountMapArray) {
        NSString* xjRank = [FLTool xj_returnJsonWithObj:_myRankCountMapArray];
        [self callJSInHTMLWithMethod:@"flXQgetStarNumberInHTML" Data:@[xjRank,[NSNumber numberWithInteger:_xjPJTotalNumber]]];//获取星星
        //        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"flXQgetStarNumberInHTML(%@,%@)",xjRank,[NSNumber numberWithInteger:_xjPJTotalNumber]]];
        
    }
    if (  _myDetailImageArray && _myRankCountMapArray)
    {
        //        CGFloat scale_screen = [UIScreen mainScreen].scale;
        //        CGFloat ss  = FLUISCREENBOUNDS.width;
        float xjfloat =  FLUISCREENBOUNDS.width ;
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"xjSetImageH(%@)",[NSNumber numberWithFloat:xjfloat]]];
        [self callJSInHTMLWithMethod:@"flGetJSXQInfomationCanyu" Data:@[[FLTool xj_returnJsonWithObj:_flsquareAllFreeModel]]];//模型
        [self callJSInHTMLWithMethod:@"flXQgetTopicPicInHtml" Data:@[[FLTool xj_returnJsonWithObj:_myDetailImageArray]]];//轮播图
        
        [self callJSInHTMLWithMethod:@"flXQisAlreadyCollectionInHTML" Data:@[[NSNumber numberWithBool:_isCollectionTopic]]];//是否收藏
    }
    if (FLUISCREENBOUNDS.width <=320) {
        [self callJSInHTMLWithMethod:@"xj_is_Screen_5" Data:@[@[@"i_5"]]];
    } else if(FLUISCREENBOUNDS.width >320 && FLUISCREENBOUNDS.width < 400){
        [self callJSInHTMLWithMethod:@"xj_is_Screen_5" Data:@[@[@"i_6"]]];
    } else if(FLUISCREENBOUNDS.width >320 && FLUISCREENBOUNDS.width > 400){
        [self callJSInHTMLWithMethod:@"xj_is_Screen_5" Data:@[@[@"i_6p"]]];
        //        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"xj_is_Screen_5()"]];
    }
    if (_myJudgeListArray && _myRankCountMapArray)
    {
        [self callJSInHTMLWithMethod:@"flXQgetJudgeListInHTML" Data:@[[FLTool xj_returnJsonWithObj:_myJudgeListArray],[FLTool xj_returnJsonWithObj:_myRankCountMapArray],[NSNumber numberWithBool:_xjIsJudgeListPJFull]]];
    }
    if (_flsquareAllFreeModel) {
        [self callJSInHTMLWithMethod:@"flXQgetDeatilsInHTML" Data:@[[FLTool xj_returnJsonWithObj:_flsquareAllFreeModel]]];//活动详情
        [self.webView stringByEvaluatingJavaScriptFromString:@"flXQgetDeatilsInHTML()"];
        //        [self callJSInHTMLWithMethod:@"xjSetBanYuanInfo" Data:@[_flsquareAllFreeModel]]; //助力抢 总数据   ,模型
    }
    if (_myCheckQualificationData) {
        [self callJSInHTMLWithMethod:@"xjSetZLQPageIsgetInfo" Data:@[[FLTool xj_returnJsonWithObj:_myCheckQualificationData]]];
        [self callJSInHTMLWithMethod:@"flXQreceivezige" Data:@[[FLTool xj_returnJsonWithObj:_myCheckQualificationData],[NSNumber numberWithBool:self.isPersonalComeIn]]]; //领取(资格)
        [self callJSInHTMLWithMethod:@"xjCheckPartInInZhuLQJS" Data:@[[FLTool xj_returnJsonWithObj:_myCheckQualificationData],[NSNumber numberWithBool:self.isPersonalComeIn]]]; //助力抢。js
    }
    if (self.myActivityHelpListArray && _xjhowmanyPeopleTake) {
        NSString* json = [FLTool xj_returnJsonWithObj:_myActivityHelpListArray];
        NSNumber* xxx = [NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@",_xjhowmanyPeopleTake] integerValue]];
        [self callJSInHTMLWithMethod:@"flXQActivityhelpListInXQJS" Data:@[[FLTool xj_returnJsonWithObj:_myActivityHelpListArray],xxx, [FLTool xj_returnJsonWithObj:@[XJ_USERTYPE_WITHTYPE]]]]; //助力列表
        //        [self callJSInHTMLWithMethod:@"topiczhuliqiangInZhuliqiangJS" Data:@[self.myActivityHelpListArray.mutableCopy,FL_USERDEFAULTS_USERID_NEW]];
        [self callJSInHTMLWithMethod:@"xjCanyuListTopicPartIn" Data:@[[FLTool xj_returnJsonWithObj:_myActivityHelpListArray].mutableCopy,[NSNumber numberWithBool:_xjIsPartInListFull]]]; //助力列表
        [self callJSInHTMLWithMethod:@"useUserId" Data:@[[FLTool xj_returnJsonWithObj:@[XJ_USERID_WITHTYPE]],[FLTool xj_returnJsonWithObj:@[XJ_USERTYPE_WITHTYPE]]]]; //
    }
    if (self.myJudgeListPLArray) {
        [self callJSInHTMLWithMethod:@"flXQActivityjudgePLListInXQJS" Data:@[[FLTool xj_returnJsonWithObj:_myJudgeListPLArray],[NSNumber numberWithInteger:_xjPLTotalNumber]]]; //评论列表
        [self callJSInHTMLWithMethod:@"xjcommentInfo" Data:@[[FLTool xj_returnJsonWithObj:_myJudgeListPLArray],[NSNumber numberWithBool:_xjIsJudgeListPLFull]]];
    }
    if (_myJudgePLListArray) {
        //        [self callJSInHTMLWithMethod:@"flReJudgegetInfoInHTML" Data:@[[FLTool xj_returnJsonWithObj:_myJudgePLListArray]]]; //改成@【】
        JSValue* function = self.flXQJSContext[@"flReJudgegetInfoInHTML"];
        JSValue *result = [function callWithArguments:_myJudgePLListArray];
        //        NSString* json = [FLTool xj_returnJsonWithObj: _myJudgePLListArray];
        //        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"flReJudgegetInfoInHTML(%@)",json]];
    }
    if (self.xjGoToRejudgeListArr) { //，e
        //        [self callJSInHTMLWithMethod:@"xjRejudgeListInfoPage" Data:[FLTool xj_returnJsonWithObj:self.xjGoToRejudgeListArr]];//改成@【】
        NSString* json = [FLTool xj_returnJsonWithObj:self.xjGoToRejudgeListArr];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"xjRejudgeListInfoPage(%@)",json]];
    }
    if (_flPerHelpListArray && _flPerHelpListArray.count!=0) {
        [self callJSInHTMLWithMethod:@"perzhuliqiangInPerZLQJS" Data:@[[FLTool xj_returnJsonWithObj:_flPerHelpListArray]]];
    }
    if (_flPVUVArr) {
        [self callJSInHTMLWithMethod:@"flXQPvUvTotalNumber" Data:@[[FLTool xj_returnJsonWithObj:_flPVUVArr]]]; //获取统计数
    }
    if (_flHelpTitle) {
        [self callJSInHTMLWithMethod:@"flXQSetHelpListTitleInHTML" Data:@[[FLTool xj_returnJsonWithObj:_flHelpTitle]]]; //更改标题
    }
    if (_flTopicMessageArray) {
        [self callJSInHTMLWithMethod:@"flXQSetTopicMessageInHTML" Data:@[[FLTool xj_returnJsonWithObj:_flTopicMessageArray]]]; //message
    }
    if (_xjhowmanyPeopleTake) {
        [self callJSInHTMLWithMethod:@"xjhowmanyPeopleTake" Data:@[_xjhowmanyPeopleTake]]; //总共多少个人参与
    }
    
    [self callJSInHTMLWithMethod:@"xjIsMySelfTopic" Data:@[[FLTool xj_returnJsonWithObj:@[XJ_USERID_WITHTYPE]],[FLTool xj_returnJsonWithObj:@[XJ_USERTYPE_WITHTYPE]]]];
    [self callJSInHTMLWithMethod:@"xjIsFriendOrNot" Data:@[[NSNumber numberWithBool:_xjIsFriend]]]; //是不是好友
    
    if (_xjZhuliqiangTotalNumberArr) {
        //        [self callJSInHTMLWithMethod:@"xjZhuliqiangTotalNumberSet" Data:@[_xjZhuliqiangTotalNumberArr]]; //助力抢 总数据
        //        [self callJSInHTMLWithMethod:@"xjSetBanYuanInfo" Data:@[_flsquareAllFreeModel]]; //助力抢 总数据   ,模型
    }
    //    [_webView reload];
    if (self.xjGoWhere) {
        [self callJSInHTMLWithMethod:@"xjgowhere" Data:@[self.xjGoWhere]];
    }
    
    if (_xjVersion_refresh) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"xjmeishenmeyong()"];
        _xjVersion_refresh = NO;
    }
    if (_xjSearchHelpListNameArr) {
        [self callJSInHTMLWithMethod:@"writeReceive1" Data:@[[FLTool xj_returnJsonWithObj:_xjSearchHelpListNameArr],[FLTool xj_returnJsonWithObj:_flsquareAllFreeModel]]]; //搜索结果的列表展示
    }
    if (self.myActivityHelpListArray && _xjhowmanyPeopleTake) {
        [self callJSInHTMLWithMethod:@"topiczhuliqiangInZhuliqiangJS" Data:@[[FLTool xj_returnJsonWithObj:self.myActivityHelpListArray],[FLTool xj_returnJsonWithObj:@[FL_USERDEFAULTS_USERID_NEW]]]];
    }
    if (_xj_zlq_rankJson) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"xj_zlq_myrank(%@)",[FLTool xj_returnJsonWithObj:_xj_zlq_rankJson]]];
    }
    if(!FLFLIsPersonalAccountType) {
        //        [self callJSInHTMLWithMethod:@"flIsBusAccountTypeAction" Data:@[_flIsBusAccount]];  //是不是商家号
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"flIsBusAccountTypeAction()"]];
    }
    
    //如果被禁
    if ([FLUserInfoModel share].flStateInt==1 || [FLBusAccountInfoModel share].busStateInt==1) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"xjBeProhibitEd()"];
        return;
    }
    
}
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    }
    return  _webView;
}


#pragma mark ----init
- (void)initWebViewInFuckHtml
{
    //    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    FL_Log(@"path = %@",[[NSBundle mainBundle] resourcePath]);
    NSString* path = [NSString stringWithFormat:@"%@",@"/assets/xiangqing.html"];
    NSString* newPath = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],path];
    NSLog(@"new path = %@",newPath);
    NSURL* filePath = [NSURL fileURLWithPath:newPath];
    _request = [NSURLRequest requestWithURL:filePath];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.backgroundColor =[UIColor whiteColor];
    __unsafe_unretained UIWebView *webView = self.webView;
    webView.delegate = self;
    __unsafe_unretained UIScrollView *scrollView = self.webView.scrollView;
    // 添加下拉刷新控件
    scrollView.mj_header= [XJBirdFlyGifHeader headerWithRefreshingBlock:^{
        //        [webView reload];
        _xjIsRefresh = YES;
        [self xjRefreshHTMLView];
    }];
    
    //    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjRefreshHTMLView)];
    
    [self.view addSubview:self.webView];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    //    [self registerWebViewBridge];
    
    if (FLFLIsPersonalAccountType) {
        _flIsBusAccount = @[FLFLXJUserTypePersonStrKey];
    } else {
        _flIsBusAccount = @[FLFLXJUserTypeCompStrKey];
    }
    //go back btn
    self.xjGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjGoBackBtn.hidden = YES;
    self.xjGoBackBtn.frame = CGRectMake(10, 30, 40, 40);
    [self.xjGoBackBtn addTarget:self action:@selector(flGoBackToTabBarMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.xjGoBackBtn setImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
    //    [self.view addSubview:self.xjGoBackBtn];
}

#pragma mark ------ getInfo
- (void)saveInfoInFuckHtmlWithData:(NSDictionary*)infoDic {
    //给js 把模型传过去
    //    _myDicData = infoDic ;
    FL_Log(@"myDicData in fuck html =%@",infoDic);
    _flXQJSContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (infoDic) {
            [self getDetailImageStrWithModel];   //获取轮播图
            //            [_webView loadRequest:_request];
        }
    });
}
#pragma mark ----- get Info from service  领取资格
//获取领取资格
- (void)checkCanPickTopicInHTNL {
    NSDictionary* parm = @{@"participate.topicId": _flFuckTopicId,
                           @"participate.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FL_USERDEFAULTS_USERID_NEW};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html check pick topic =%@",data);
        if (data) {
            _myCheckQualificationData = data;
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
}

//获取轮播图
- (void)getDetailImageStrWithModel {
    _myDetailImageArray =nil;
    NSMutableArray* muArray = [NSMutableArray array];
    NSLog(@"====sd=as=ds==%@",_flFuckTopicId);
    NSDictionary* parm = @{@"topic.topicId":_flFuckTopicId};
    [FLNetTool getDetailImageStrInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in get detail imagein HTML =%@",data[FL_NET_DATA_KEY]);
        if (data) {
            [self getRankCountMapInHTML];        //获取打分星星
            NSArray* array = data[FL_NET_DATA_KEY];
            for (NSDictionary* dic in array) {
                if ([dic[@"businesstype"] integerValue] == 2) {
                    [muArray addObject:dic];
                } else if ([dic[@"businesstype"] integerValue] == 1) {
                    _flTopicImageStr = dic[@"url"];
                }
            }
            _myDetailImageArray = muArray.mutableCopy;
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//获取星星
- (void)getRankCountMapInHTML {
    NSDictionary* parmId = @{@"businessId":_flFuckTopicId};
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:parmId]};
    [FLNetTool getRankCountMapInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in get count star imagein HTML =%@",data[FL_NET_DATA_KEY]);
        if (data) {
            _myRankCountMapArray= nil;
            [self getListCommentInHTMLWithCurrentPage:@1]; //评价列表
            _myRankCountMapArray = data[FL_NET_DATA_KEY];
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"data in get start count imagein HTML error=%@",error);
    }];
    
}

- (void)xjClickToCheckMoreWithJudgePJ{
    [self getListCommentInHTMLWithCurrentPage:[FLTool xjRetuenCurrentWithArrLength:self.myJudgeListArray.count andTotal:_xjPJTotalNumber xjSize:20]]; //评价列表
}
#pragma mark ------------------------获取评价列表
/**获取评价列表 评价 评价 重要的事情说三遍
 */
- (void)getListCommentInHTMLWithCurrentPage:(NSNumber*)xjPage
{
    NSDictionary* detail = @{@"businessId":_flFuckTopicId,
                             @"commentType":@"1", //1为评价  2为评论
                             @"isFlush":@"false"
                             }; //分页
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:detail],
                           @"page.isFlush":@"true",
                           @"page.currentPage":xjPage};
    [FLNetTool htmlListCommentInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html with judge list =%@",data);
        if (data) {
            NSMutableArray* xjMuArr = @[].mutableCopy;
            xjMuArr = data[FL_NET_DATA_KEY];
            if ([xjPage isEqual:@1]) {
                [self.myJudgeListArray removeAllObjects];
            }
            [self.myJudgeListArray addObjectsFromArray:xjMuArr];
            NSString* sNumber=  data[@"total"];
            _xjPJTotalNumber = [sNumber integerValue];
            _xjIsJudgeListPJFull = _xjPJTotalNumber <= _myJudgeListArray.count ? YES : NO;
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ------------------------获取评论列表
- (void)xjClickToCheckMoreJudgePL {
    [self getJudgeListInHMLWithCurrentPage:[FLTool xjRetuenCurrentWithArrLength:self.myJudgeListPLArray.count andTotal:_xjPLTotalNumber xjSize:20]];
}
/**获取评论列表 评论 评论 重要的 事情说三遍
 */
- (void)getJudgeListInHMLWithCurrentPage:(NSNumber*)xjCurrentPage
{
    
    NSDictionary* detail = @{@"businessId":_flFuckTopicId,
                             @"commentType":@"0", //1为评价  0为评论
                             @"isFlush":@"false",}; //分页
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:detail],
                           @"page.isFlush":@"true",
                           @"page.currentPage":xjCurrentPage};
    [FLNetTool htmlListCommentInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html with judge listwith type 0 =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            //            _myJudgeListPLArray = @[data];
            NSMutableArray* xjMuArr = @[].mutableCopy;
            NSDictionary* xjDic =  data[FL_NET_DATA_KEY];
            //            xjMuArr = [self returnSelfWithAvatarDic:data[FL_NET_DATA_KEY]];
            xjMuArr = data[FL_NET_DATA_KEY];
            if ([xjCurrentPage isEqual:@1]) {
                [_myJudgeListPLArray removeAllObjects];
            }
            [self.myJudgeListPLArray addObjectsFromArray:xjMuArr];
            _xjPLTotalNumber = [data [@"total"] integerValue];
            _xjIsJudgeListPLFull = _xjPLTotalNumber <= _myJudgeListPLArray.count ? YES : NO;
            if ([xjCurrentPage  isEqual: @1]) {
                [self callJSInHTMLWithMethod:@"flXQActivityjudgePLListInXQJS" Data:@[[FLTool xj_returnJsonWithObj:_myJudgeListPLArray],[NSNumber numberWithInteger:_xjPLTotalNumber]]]; //评论列表
            }
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -------------------------------------------- 获取统计数
- (void)getPVUVWithTopicIdInHTML {
    [FLFinalNetTool flNewPVUVlWithTopicId:_flFuckTopicId success:^(NSDictionary *data) {
        FL_Log(@"data in html with PVUV listwith type 0 =%@",data);
        //        if ([data[FL_NET_KEY_NEW] boolValue]) {
        _flPVUVArr = data[FL_NET_DATA_KEY];
        [self setInfoToHTMLToReload];
        if (!_xjIsRefresh) {
            [self xjLoadRequest];
            
        }
        //        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjLoadRequest {
    FL_Log(@"xjlogdsadsadsa-d=-=-=-=-=-=-=");
    [_webView loadRequest:_request];
}

#pragma mark --------------------------------------------获取活动助力者列表，得到头像
- (void)getHelpListHeadImageFromService {
    [self xjGetHelpListWithCurrentPage:1 pageSize:xjSize_PageSize];
}

- (void)callJSInHTMLWithMethod:(NSString*)methodStr Data:(NSArray*)array {
    //    JSValue* function = self.flXQJSContext[methodStr];
    
    //    JSValue *result = [function callWithArguments:array];
    
    if (array.count==0) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@()",methodStr]];
    } else if (array.count==1) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@)",methodStr,array[0]]];
    } else if (array.count==2) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@,%@)",methodStr,array[0],array[1]]];
    } else if (array.count==3) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@,%@,%@)",methodStr,array[0],array[1],array[2]]];
    } else {
        JSValue* function = self.flXQJSContext[methodStr];
        JSValue *result = [function callWithArguments:array];
    }
    
    
    //    NSLog(@"factorial(10) = %@", [result toDictionary]);
}

#pragma mark -registerNSNotificationInFuckHtml
- (void)registerNSNotificationInFuckHtml {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLInfoReJudgeWindow:) name:FLFLHTMLInfoReJudgeWindow object:nil];//给回复评论界面传参
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLAlertReJudgeWindow) name:FLFLHTMLAlertReJudgeWindow object:nil];//回复评论弹出层
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLGetPartInfoList) name:FLFLHTMLGetPartInfoList object:nil];//获取回填信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLSetPartInfoList:) name:FLFLHTMLSetPartInfoList object:nil];//回填信息填写完毕提交数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLActionZhuliqiangListClick) name:FLFLHTMLActionZhuliqiangListClick object:nil];//进入助力抢界面，给助力抢界面传参,用活动助力抢头像的data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLActionPerZhuliqiangListClick:) name:FLFLHTMLActionPerZhuliqiangListClick object:nil];//进入个人助力抢界面，给助力抢界面传参 userId
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLInsertParticipate) name:FLFLHTMLInsertParticipate object:nil];//插入参与记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLActionPerZhuliqiangHelpClick:) name:FLFLHTMLActionPerZhuliqiangHelpClick object:nil];//给别人助力一次
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLNotiRelayToPickClick) name:FLFLHTMLNotiRelayToPickClick object:nil];//通知转发可以领取，插入领取记录
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMSethiddenWithNavi:) name:@"FLFLHTMSethiddenWithNavi" object:nil]; //隐藏导航栏
    
}

#pragma mark ----Actions --- no
//点击举报

- (void)HTMLjubaoclick:(NSString*)notification {
    FL_Log(@"notifation with jubao clickon = %@", notification);
    FL_Log(@"this is report result= ===userId%@======%@",FL_USERDEFAULTS_USERID_NEW,notification);
    [FLFinalNetTool flNewHTMLInsertReportWithTopicId:_flFuckTopicId?_flFuckTopicId:@""
                                              userId:FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID
                                          reportDesc:[NSString stringWithFormat:@"%@",notification]
                                             success:^(NSDictionary *data) {
                                                 if ([data[FL_NET_KEY_NEW] boolValue])
                                                 {
                                                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"举报成功" message:@"感谢您的参与，我们会尽快审核，谢谢" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                     //主线程更新UI
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [alert show];
                                                     });
                                                 } else {
                                                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"举报失败" message:[NSString stringWithFormat:@"%@",data[@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                     //主线程更新UI
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [alert show];
                                                     });
                                                 }
                                             } failure:^(NSError *error) {
                                                 NSString* str = [FLTool returnStrWithErrorCode:error];
                                                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"举报失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                 //主线程更新UI
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [alert show];
                                                 });
                                                 FL_Log(@"举报失败======%@",str);
                                             }];
    
}
#pragma mark 直接领取
- (void)FLFLHTMLHTMLsaveTopicClickOn {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    NSString* xjUserId = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    NSString* xjCreator = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    if (!xjUserId  || !xjCreator) {
        xjUserId = @"";
        xjCreator = @"";
    }
    
    NSDictionary* parm = @{@"participateDetailes.topicId":_flFuckTopicId,
                           @"participateDetailes.userId":xjUserId,
                           @"participateDetailes.userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"participateDetailes.creator":xjCreator,//FL_USERDEFAULTS_USERID_NEW,
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID]};
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"notifation with SAVE clickon = %@",data);
        if (!data) {
            [FLTool showWith:@"请求结果错误"];
            return ;
        }
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            //            [self reloadDataAndRefreshPage];
            [self xjRefreshHTMLView];//更新数据，刷新界面
            [[FLAppDelegate share] showHUDWithTitile:@"操作成功" view:self.view delay:1 offsetY:0];
            //插入参与记录
            if (![_xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
                [self FLFLHTMLInsertParticipate];
            }
            //跳到票券页
            XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
            ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
            //            [self presentViewController:ticketVC animated:YES completion:nil];
            FL_Log(@"this is teh action to push the page of ticke3t");
            [self.navigationController pushViewController:ticketVC animated:YES];
            [self  getDetailsInfoInFuckHtmlVC];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
    }];
}

#pragma mark --------------------------------------------给回复评论界面JS传参 同时得到评论列表
- (void)FLFLHTMLInfoReJudgeWindow:(NSNotification*)notification {
    FL_Log(@"notifation with ReJudge clickon = %@", notification.object);
    _flParentIdForReJudge = notification.object[4];
    [self getRejudgeListInHTML];
    _myJudgePLListArray = @[notification.object[0],notification.object[1],notification.object[3],notification.object[4],notification.object[2]];
}

- (void)setXjGoToRejudgeListArr:(NSArray *)xjGoToRejudgeListArr {
    _xjGoToRejudgeListArr = xjGoToRejudgeListArr;
    _flParentIdForReJudge = [NSString stringWithFormat:@"%@",xjGoToRejudgeListArr[0][@"commentId"]];
    //    [self getRejudgeListInHTML];
}
#pragma mark 得到回评列表
- (void)getRejudgeListInHTML {
    if (!_flParentIdForReJudge) {
        return;
    }
    NSDictionary*  commentPara = @{@"parentId":_flParentIdForReJudge};
    NSDictionary*  parm  = @{@"userId":FL_USERDEFAULTS_USERID_NEW,
                             @"userType":FLFLXJUserTypePersonStrKey,
                             @"commentPara":[FLTool returnDictionaryToJson:commentPara]};
    
    [FLNetTool HTMLRejudgeListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"rejudge list in html =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            //            _flRejudgeListArray = data[FL_NET_DATA_KEY];
            _flRejudgeListArray = [FLTool returnArrayWithArr:data[FL_NET_DATA_KEY]];
            if (_flRejudgeListArray) {
                [self callJSInHTMLWithMethod:@"replayList" Data:@[[FLTool xj_returnJsonWithObj:_flRejudgeListArray]]];
                [self setInfoToHTMLToReload];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 评论
- (void)FLFLHTMLAlertJudgeWindow {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"对不起，当前版本禁止商家回评"];
        return;
    }
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    //    [_popView remove];
    //    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写评论内容" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 40 lengthType:FLLengthTypeLength originalStr:nil] ;
    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写评论内容" delegate:self length:80 lengthType:FLLengthTypeLength originalStr:nil];
    //    [_popView.flInputTextField becomeFirstResponder];
    [_popView.xjTextView becomeFirstResponder];
    popViewTag = 11;
    _popView.isTextField = NO;
    //    _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_popView];
        
        //    flReJudgegetInfoInHTML
    });
}
#pragma mark /获取回填信息
- (void)FLFLHTMLGetPartInfoList {
    NSDictionary* parm =@{@"topic.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"topic.partInfo":_flsquareAllFreeModel[@"partInfo"]};
    [FLNetTool HTMLGetPartInfoListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"get partinfod success =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _flPartInfoListArray = data;//[FL_NET_DATA_KEY];
            [self callJSInHTMLWithMethod:@"writeReceiveInJubaoJS" Data:@[[FLTool xj_returnJsonWithObj:_flPartInfoListArray]]];
        }
    } failure:^(NSError *error) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"xjGoBackWithOutInfoError()"];
    }];
}
#pragma mark /获取回填信息
- (void) xjGetPartInfoList{
    NSDictionary* parm =@{@"topic.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"topic.partInfo":_flsquareAllFreeModel[@"partInfo"]};
    [FLNetTool HTMLGetPartInfoListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"get partinafo success =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _flPartInfoListArray = data;//[FL_NET_DATA_KEY];
            [self callJSInHTMLWithMethod:@"writeReceiveInJubaoJS" Data:@[[FLTool xj_returnJsonWithObj:_flPartInfoListArray]]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  ------=-=-=-=======++++++++++++++++——+-=-=-=信息回填完毕提交数据
- (void)xjSetPartInfoWithInfoUnderReceive:(NSString*)xjStr {
    NSDictionary* parm =@{@"topic.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"topic.partInfo":xjStr};
    [FLNetTool HTMLGetPartInfoListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"get partisnfo successs =%@",data);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)FLFLHTMLSetPartInfoList:(NSNotification*)notifition
{
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }

    FL_Log(@"notifition in fuck html=====%@",notifition.object);
    //    NSArray* array = [notifition.object componentsSeparatedByString:@","];
    //    NSString* str = [array componentsJoinedByString:array[0]];
    NSArray* array = [FLTool returnArrayWithJSONString:notifition.object];
    NSDictionary* dic= array[0];
    NSString* str = [FLTool returnDictionaryToJson:dic];
    NSDictionary* parm = @{@"participateDetailes.topicId":_flFuckTopicId,
                           @"participateDetailes.userId":FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID,
                           @"participateDetailes.userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"participateDetailes.creator":FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID,//FLFLIsPersonalAccountType ?_flsquareAllFreeModel[@"userId"] :_flsquareAllFreeModel[@"creator"],
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID],
                           @"participateDetailes.message": str};
    FL_Log(@"parm in why ? = %@",parm);
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in save topic info =%@",data[@"success"]);
        
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            [[FLAppDelegate share] showHUDWithTitile:@"操作成功" view:self.view delay:1 offsetY:0];
            //            [self reloadDataAndRefreshPage];//更新数据，刷新界面
            [self xjRefreshHTMLView];//更新数据，刷新界面
            [self xjSetPartInfoWithInfoUnderReceive:str];
            //插入参与记录
            if (![_xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
                [self FLFLHTMLInsertParticipate];
            }
            //重新校验领取资格
            [self checkCanPickTopicInHTNL]; //获取领取资格
            //跳到票券页
            XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
            ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
            FL_Log(@"this is teh action to push the page of ticket");
            [self.navigationController pushViewController:ticketVC animated:YES];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic info =%@",error);
    }];
    
}

#pragma mark 分享
#pragma mark 点击转发领
- (void)FLFLHTMLActionRelayPickClick
{
    FL_Log(@"点击转发领");
    dispatch_async(dispatch_get_main_queue(), ^{
        //集成share SDK
        //        [UMSocialSnsService presentSnsIconSheetView:self
        //                                             appKey:FL_YOUMENG_APPKEY
        //                                          shareText:@"freela是一款。。。。软件。 http://123.57.35.196:80"
        //                                         shareImage:nil
        //                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline, nil]
        //                                           delegate:self];
        
        
        [self showMenu];
        
    });
    
}
#pragma mark popMenu
- (void)showMenu {
    
    if (_menuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    }
    _menuView = [[CHTumblrMenuView alloc] init];
    __weak typeof(self) weakSelf = self;
    NSArray* nameArray = @[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"新浪",@"免费啦"];
    NSArray* imageArray = @[@"share_wechat",@"share_friend",@"share_qq",@"share_qzone",@"share_sina",@"share_mianfeila"];
    NSArray* typeArray = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,@"freela"];
    for (NSInteger i = 0; i < nameArray.count; i ++ )
    {
        [_menuView addMenuItemWithTitle:nameArray[i] andIcon:[UIImage imageNamed:imageArray[i]] andSelectedBlock:^{
            FL_Log(@"Phot2o selected= %ld",i);
            [weakSelf shareToWithType:typeArray[i]];
        }];
    }
    [self xj_getPlanByTopicId];//请求转发策略
    [_menuView show];
}
- (void)xj_getPlanByTopicId {
    [FLNetTool xj_getPlanByTopicId:_flFuckTopicId success:^(NSDictionary *data) {
        FL_Log(@"this is the result of relay paln===[%@]",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjSharePlanModel = [XJShareContentModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
        } else {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)shareToWithType:(NSString*)type
{
    if ([type isEqualToString:@"freela"]) {
        
    } else {
        NSInteger xjType ;
        if ([type isEqualToString:@"qq"]) {
            xjType = 1;
        } else if ([type isEqualToString:@"qzone"]) {
            xjType = 2;
        } else if ([type isEqualToString:@"wxsession"]) {
            xjType = 3;
        } else if ([type isEqualToString:@"wxtimeline"]) {
            xjType = 4;
        } else if ([type isEqualToString:@"sina"]) {
            xjType = 5;
        }
        //        微信 =3
        //        微信朋友圈4
        //        qq 1
        //        qzone 2
        //        sina 5
        
        
        //        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",FLBaseUrl,_flTopicImageStr]];
        
        NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@/transpond/transpond!isTranspond.action?topic.topicId=%@&type=%@&perUserId=%@",FLBaseUrl,_flFuckTopicId,[NSNumber numberWithInteger:xjType],XJ_USERID_WITHTYPE];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flsquareAllFreeModel[@"thumbnail"] isSite:NO]]];
        
        [UMSocialData defaultData].extConfig.title = _flsquareAllFreeModel[@"topicTheme"];
        if (self.xjSharePlanModel.planType) {
            //转发策略
            [UMSocialData defaultData].extConfig.title  = [self xj_return_sharePlan];
            if (self.xjSharePlanModel.planType==6) {
                NSString* xjjjj = [NSString stringWithFormat:@"%@%@",[self xj_return_sharePlan],_flsquareAllFreeModel[@"topicTheme"]];
                [UMSocialData defaultData].extConfig.title  = xjjjj;
            }
        }
        //        [UMSocialData defaultData].shareText = @"内容";
        //        [UMSocialData defaultData].shareImage = @"图片";
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qqData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [UMSocialData defaultData].urlResource;
        
        //        NSString* xjTopicExpline = [NSString stringWithFormat:@"使用说明:%@",_xjNeedModel.topicExplain.length != 0 ? _xjNeedModel.topicExplain : @"无"];
        NSString* xjTopicExpline =  @"我在这里发现了免费的好东东，来一起玩耍吧，嘎嘎~";
        if (self.xjSharePlanModel.remark) {
            xjTopicExpline = self.xjSharePlanModel.remark;
        }
        NSString* xjweiboStr= @"";
        if (xjType == 5) {
            xjweiboStr = [NSString stringWithFormat:@"%@%@",_flsquareAllFreeModel[@"topicTheme"],xjRelayContentStr];
            if (self.xjSharePlanModel.planType==6) {
                NSString* xjjjj = [NSString stringWithFormat:@"%@%@%@",[self xj_return_sharePlan],_flsquareAllFreeModel[@"topicTheme"],xjRelayContentStr];
                xjweiboStr  = xjjjj;
            }
        }
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:[NSString stringWithFormat:@"%@",xjType==5 ? xjweiboStr: xjTopicExpline] image:nil location:nil urlResource:[UMSocialData defaultData].urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                FL_Log(@"分享成功！");
                //                [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
                //                [self FLFLHTMLInsertParticipate];//插入参与记录
                //                if (_isRelayToPick) {
                //                    [self FLFLHTMLInsertParticipate];//插入参与记录
                //                } else {
                [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
                //                }
                //更新 统计数据
                [self getPVUVWithTopicIdInHTML];
            }
        }];
        
        //        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:@"友盟社会化分享让您快速实现分享等社会化功能，http://123.57.35.196:80" image:self.flhtmlMode.flimageMain location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        //            if (response.responseCode == UMSResponseCodeSuccess) {
        //                FL_Log(@"分享成功！");
        //                [self FLFLHTMLInsertParticipate];//插入参与记录
        //                [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
        //            }
        //        }];
        
        //        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        //            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
        //                FL_Log(@"分享成功！");
        //            }
        //        }];
        
    }
}

- (NSString* )xj_return_sharePlan {
    NSString* xjName = [[XJUserAccountTool share] xj_getUserName];
    NSString* xjPuser = self.xjNeedModel.nickName;
    NSString* xjContent1 = self.xjSharePlanModel.fixedContent1;
    NSString* xjContent2 = self.xjSharePlanModel.fixedContent2;
    switch (self.xjSharePlanModel.planType) {
        case 1: {
            return [NSString stringWithFormat:@"%@%@",xjName,xjContent2];
        }
            break;
        case 2: {
            return [NSString stringWithFormat:@"%@%@",xjPuser,xjContent2];
        }
            break;
        case 3: {
            return [NSString stringWithFormat:@"%@",xjContent2];
        }
            break;
        case 4: {
            return [NSString stringWithFormat:@"%@%@%@",xjContent1,xjName,xjContent2];
        }
            break;
        case 5:{
            return [NSString stringWithFormat:@"%@%@%@",xjContent1,xjPuser,xjContent2];
        }
            break;
        case 6: {
            return [NSString stringWithFormat:@"%@",xjContent1];
        }
            break;
            
        default:
            break;
    }
    return @"";
}

#pragma mark noti
#pragma mark 给助力抢界面传参，调用JS
- (void)FLFLHTMLActionZhuliqiangListClick
{
    FL_Log(@"点击进入助力抢界面，给助力抢界面传参");
    //    [self setInfoToHTMLToReload];
    NSDictionary* parm = @{@"topic.topicId":_flFuckTopicId,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"userType":FLFLXJUserTypePersonStrKey,
                           @"token":XJ_USER_SESSION};
    [FLNetTool flGetHelpListDetailsByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is my test zhuliqiang=%@msg =%@ ",dic,dic[@"msg"]);
        if ([dic[FL_NET_KEY_NEW] boolValue]) {
            _xjZhuliqiangTotalNumberArr = @[[FLTool returnDictionaryWithJSONString:dic[@"msg"]]];
            [self setInfoToHTMLToReload];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark --------------------------------------------进入个人助力抢界面，传进来userId

- (void)FLFLHTMLActionPerZhuliqiangListClick:(NSNotification*)notifation {
    FL_Log(@"点击进入个人助力抢界面，给助力抢界面传参= %@",notifation.object);
    NSArray* array = notifation.object;
    NSString* userId = array[0];
    NSString* nickname = array[1];
//    _flHelpTitle = @[nickname];
    _xjPerHelpListUserId = userId;
    [self getPerZLQLisetInHTMLWithID:userId];//获取个人助力抢列表
    //    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"flXQSetHelpListTitleInHTML()"]];
    
}

#pragma mark 点击插入参与记录 (发起助力抢等)
- (void)FLFLHTMLInsertParticipate
{
    FL_Log(@"点击插入参与记录");
    NSDictionary* parm =@{@"participate.topicId":_flFuckTopicId,
                          @"participate.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"participate.userType":FLFLXJUserTypePersonStrKey,   //商家不可以点击领取
                          @"participate.creator":FL_USERDEFAULTS_USERID_NEW};   //个人领取永远是个人id
    [FLNetTool HTMLinsertParticipateInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"点击插入参与记录成功= %@",data);
        [self getHelpListHeadImageFromService]; //头像
        [self checkCanPickTopicInHTNL]; //获取领取资格
        [self setInfoToHTMLToReload];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 给别人助力一次
- (void)FLFLHTMLActionPerZhuliqiangHelpClick:(NSString*)nsnotifation
{
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"当前版本暂不支持此功能"];
        return;
    }
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.view];

    NSDictionary* parm = @{@"topicPromote.sourceId":@"3",  //3代表 iOS 移动端
                           @"topicPromote.topicId":_flFuckTopicId,
                           @"topicPromote.participateId":nsnotifation,  //助力id
                           @"topicPromote.userToId":FL_USERDEFAULTS_USERID_NEW,
                           @"token":XJ_USER_SESSION,
                           };
    [FLNetTool HTMLInsertTopicPromoteInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"help other success =%@",data);
        [[FLAppDelegate share] hideHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            [FLTool showWith:data[@"msg"]];
            if ([data[FL_NET_KEY_NEW] boolValue]) {
                [self.myActivityHelpListArray removeAllObjects];
                if (!_xj_is_search_page) {
                    [self xjGetHelpListWithCurrentPage:1 pageSize:xjSize_PageSize];//刷新排名
                }
            }
        });
    } failure:^(NSError *error) {
        [[FLAppDelegate share] hideHUD];
    }];
    
}

#pragma mark 通知转发可以领取
- (void)FLFLHTMLNotiRelayToPickClick
{
    FL_Log(@"现在，转发可以领了");
    [self FLFLHTMLHTMLsaveTopicClickOn];
}

#pragma mark 回复评论
- (void)FLFLHTMLAlertReJudgeWindow {
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"对不起，当前版本禁止商家回评"];
        return;
    }
    //    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写回复内容" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 40 lengthType:FLLengthTypeLength originalStr:nil];
    //    [_popView.flInputTextField becomeFirstResponder];
    //    popViewTag = 12;
    //    _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //         [self.view addSubview:_popView];
    //
    ////    flReJudgegetInfoInHTML
    //    });
    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写评论内容" delegate:self length:80 lengthType:FLLengthTypeLength originalStr:nil];
    //    [_popView.flInputTextField becomeFirstResponder];
    [_popView.xjTextView becomeFirstResponder];
    popViewTag = 12;
    _popView.isTextField = NO;
    //    _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_popView];
        
        //    flReJudgegetInfoInHTML
    });
    
}



//- (void)FLFLHTMLJudgeListclickon
//{
//    FL_Log(@"此处我点了那个啥，跳转，可以先给JS赋值");
//      [self callJSInHTMLWithMethod:@"flXQgetJudgeListInHTML" Data:@[_myJudgeListArray,_myRankCountMapArray]];
//}
#pragma mark ----Actions
//获取个人助力抢列表
- (void)getPerZLQLisetInHTMLWithID:(NSString*)userId    //此处应该使用participateId
{
    NSDictionary* parm =@{@"page.currentPage":@"1",
                          @"topicPromote.topicId":_flFuckTopicId,
                          @"topicPromote.participateId":userId,
                          @"page.pageSize":  [NSNumber numberWithInteger:100000000]};
    [FLNetTool HTMLfindTopicPromoteListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in find personal help list =%@",data);
        //        _flPerHelpListArray = data[FL_NET_DATA_KEY];
        _flPerHelpListArray = [self returnSelfWithAvatarDic:data[FL_NET_DATA_KEY]];
        if ([data[FL_NET_KEY_NEW] boolValue] && _flPerHelpListArray.count!=0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self callJSInHTMLWithMethod:@"perzhuliqiangInPerZLQJS" Data:@[[FLTool xj_returnJsonWithObj:_flPerHelpListArray]]];
                [self setInfoToHTMLToReload];
            });
        }
    } failure:^(NSError *error) {
        
    }];
    
}



#pragma mark ---alertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    JSValue* function = self.flXQJSContext[@"jubaoClickBackToXQ"];
    JSValue *result = [function callWithArguments:nil]; //获取资格
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_flNaviView removeFromSuperview];
    });
    _xj_is_Active = NO;
}


#pragma mark ---Pop Delegate

- (void) entrueBtnClickWithStr:(NSString *)result {
    if(result.length==0) {
        [FLTool showWith:@"不能为空"];
        return;
    }
    FL_Log(@"make it sure in HTML = %@",_popView.flInputTextField.text);
    [_popView removeFromSuperview];
    switch (popViewTag) {
        case 11: {
            //插入评论记录
            NSDictionary* dic = @{@"businessId":_flFuckTopicId,
                                  @"commentType":@"0",   //0代表评论
                                  @"content":_popView.xjTextView.text,
                                  @"parentId":@"0"};
            NSDictionary* parm = @{ @"commentPara":[FLTool returnDictionaryToJson:dic],
                                    @"userType": XJ_USERTYPE_WITHTYPE,
                                    @"userId":XJ_USERID_WITHTYPE};
            [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
                FL_Log(@"insert comment in html judge = %@",data);
                if ([data[FL_NET_KEY_NEW] boolValue]) {
                    [_myJudgeListPLArray removeAllObjects];
                    [self getJudgeListInHMLWithCurrentPage:@1];
                    [_webView reload];
                }
            } failure:^(NSError *error) {
                FL_Log(@"error in insert comment html =%@",error);
            }];
        }
            break;
        case 12: {
            //插入回评记录
            NSDictionary* dic = @{@"businessId":_flFuckTopicId,
                                  @"commentType":@"2",   //2代表回复
                                  @"content":_popView.xjTextView.text,
                                  @"parentId":_flParentIdForReJudge};
            NSDictionary* parm =@{@"commentPara":[FLTool returnDictionaryToJson:dic],
                                  @"userType":FLFLXJUserTypePersonStrKey,
                                  @"userId":FL_USERDEFAULTS_USERID_NEW};
            [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
                FL_Log(@"insert comment in html rejudge in flthml = %@",data);
                if ([data[FL_NET_KEY_NEW] boolValue]) {
                    [self getRejudgeListInHTML];
                } else {
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                }
            } failure:^(NSError *error) {
                FL_Log(@"error in insert comment html =%@",error);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma  mark --------------------------------------------[评论记录]
- (void)xjInsertJudgeCommentWithStr:(NSString*)xjComment {
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"对不起，当前版本禁止商家回评"];
        return;
    }
    //插入评论记录
    NSDictionary* dic = @{@"businessId":_flFuckTopicId,
                          @"commentType":@"0",   //0代表评论
                          @"content":xjComment,
                          @"parentId":@"0"};
    NSDictionary* parm = @{ @"commentPara":[FLTool returnDictionaryToJson:dic],
                            @"userType": XJ_USERTYPE_WITHTYPE,
                            @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"insert comment in html judge = %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [_myJudgeListPLArray removeAllObjects];
            [self getJudgeListInHMLWithCurrentPage:@1];
            [_webView reload];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in insert comment html =%@",error);
    }];
}
#pragma  mark --------------------------------------------[回复评论]
- (void)xjInsertJudgeBackWithStr:(NSString*)xjComment {
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"对不起，当前版本禁止商家回评"];
        return;
    }
    //插入回评记录
    NSDictionary* dic = @{@"businessId":_flFuckTopicId,
                          @"commentType":@"2",   //2代表回复
                          @"content":xjComment,
                          @"parentId":_flParentIdForReJudge};
    NSDictionary* parm =@{@"commentPara":[FLTool returnDictionaryToJson:dic],
                          @"userType":XJ_USERTYPE_WITHTYPE,
                          @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"insert comment in html rejudge in flthml = %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self getRejudgeListInHTML];
        } else {
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in insert comment html =%@",error);
    }];
}
#pragma mark --- shareDelegate
#pragma mark 分享得回调
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    FL_Log(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的平台名
        FL_Log(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        //转发成功，可以领取
        [self FLFLHTMLInsertParticipate];
        
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)returnSelfWithAvatarDic:(NSArray*)flarray {
    
    if (!flarray ) {
        return nil;
    }
    NSMutableArray* muArr = @[].mutableCopy;
    for (NSDictionary* dic in flarray) {
        NSMutableDictionary* mudic = dic.mutableCopy;
        NSString* str = mudic[@"avatar"];
        if (![FLTool returnBoolWithIsHasHTTP:str includeStr:@"/"] && [FLTool returnBoolWithIsHasStringInclude:str includeStr:@"img-kong"] ) {
            [mudic setObject:[NSString stringWithFormat:@"/%@",str] forKey:@"avatar"];
        }
        if ([FLTool returnBoolWithIsHasHTTP:str includeStr:@"http://"]) {
            [mudic setObject:str forKey:@"avatar"];
        } else {
            [mudic setObject:[NSString stringWithFormat:@"%@%@",FLBaseUrl,str] forKey:@"avatar"];
        }
        [muArr addObject:mudic];
    }
    
    return muArr.mutableCopy;
}

#pragma mark 创建导航栏
- (void)initNaviBarMenu {
    //    _flNaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 64)];
    //    _flNaviView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    //    [self.view.layer addSublayer:view.layer];
    //    [FL_KEYWINDOW_VIEW_NEW addSubview:_flNaviView];
}

- (void)naviHiddenWithBool:(BOOL)hidden {
    [_flNaviView setHidden:hidden];
}

- (void)FLFLHTMSethiddenWithNavi:(NSNotification*)noti {
    //    _isHiddenNavi  = noti.object;
    //    NSNumber *aaa = [noti.object boolValue];
    BOOL aba = [noti.object boolValue];
    if (!aba) {
        _isHiddenNavi = NO;
    } else {
        _isHiddenNavi = YES;
    }
    FL_Log(@"hidden or not=%@ and this is my noti=%@",[NSNumber numberWithBool:_isHiddenNavi],noti.object);
    [self naviHiddenWithBool:_isHiddenNavi];
}



#pragma mark WebBrigde

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self callJSInHTMLWithMethod:@"xjtextGoback" Data:nil];//模型
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark 分享
- (void)FLFLHTMLShareToFriendWithAnyType {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    //如果是转发领，插入参与记录
    if ([self.xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
        [self FLFLHTMLInsertParticipate];
    } else if ([self.xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
        [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
//        XJZhuLQShareViewController * xjZLQVC = [[XJZhuLQShareViewController alloc] initWithNibName:@"XJZhuLQShareViewController" bundle:nil];
//        xjZLQVC.xjTopicId = _flFuckTopicId;
//        xjZLQVC.xjTopicDic = _flsquareAllFreeModel;
//        FL_Log(@"this is teh action to push the page of zhuli");
//        [self.navigationController pushViewController:xjZLQVC animated:YES];
//        return;
    } else {
        [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
    }
    [self showMenu];
}
#pragma mark ---------------- 插入转发记录
- (void)flRelayTopicWithNoTypeInHTMLVC {
    NSDictionary* parm = @{@"topic.userType":_flsquareAllFreeModel[@"userType"],
                           @"topic.userId": _flsquareAllFreeModel[@"userId"],
                           @"topic.topicId":_flFuckTopicId,
                           @"topic.topicType":_flTopicType,
                           @"token":XJ_USER_SESSION};
    [FLNetTool flPubTopicShareFriendAnyTypeByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is to sahre test =%@",data);
        [self getPVUVWithTopicIdInHTML];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark     判断是否收藏

- (void)firstflIsCollectionTopic
{
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"topicId":_flFuckTopicId ? _flFuckTopicId :@""};
    [FLNetTool flIscollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is my test with is collection =%@",dic);
        if ([dic[@"success"] boolValue]) {
            //            NSDictionary* xjIsColl = dic[FL_NET_DATA_KEY];
            //            BOOL isColl = xjIsColl[@"isCollection"];
            _isCollectionTopic = YES;
            [self setInfoToHTMLToReload];
        } else {
            _isCollectionTopic = NO;
            [self setInfoToHTMLToReload];
        }
        //        [self xjRefreshHTMLView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjIsCollecitonClick {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }

    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"topicId":_flFuckTopicId};
    [FLNetTool flIscollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is my test with is collection =%@",dic);
        if ([dic[@"success"] boolValue]) {
            _isCollectionTopic = YES;
            [self collectionOrNot];
            //            NSDictionary* xjDic = dic[@"isCollection"];
            //            if ([xjDic[@"isCollection"] boolValue]) {
            //                _isCollectionTopic = YES;
            //                [self collectionOrNot];
            //            } else {
            ////                _isCollectionTopic = NO;
            ////                [self collectionOrNot];
            //            }
        } else {
            _isCollectionTopic = NO;
            [self collectionOrNot];
        }
    } failure:^(NSError *error) {
        
    }];
    //    [self collectionOrNot];
}

- (void)collectionOrNot {
    if (_isCollectionTopic) {
        //取消收藏
        NSDictionary* parm1 =@{@"token":XJ_USER_SESSION,
                               @"userFavonites.userId":FL_USERDEFAULTS_USERID_NEW,
                               @"userFavonites.topicId":_flFuckTopicId};
        [FLNetTool flquitecollectionTopicBackByParm:parm1 success:^(NSDictionary *dic) {
            FL_Log(@"this is quit collection result=%@",dic);
            if ([dic[@"success"] boolValue]) {
                [[FLAppDelegate share] showHUDWithTitile:@"取消收藏成功" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                //                _isCollectionTopic = NO;
                [self getPVUVWithTopicIdInHTML];//获取统计数
                [self firstflIsCollectionTopic];
            } else {
                FL_Log(@"未知错误？？");
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        //添加收藏
        NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                               @"topicId":_flFuckTopicId,
                               @"userId":FL_USERDEFAULTS_USERID_NEW};
        [FLNetTool flAddcollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
            FL_Log(@"this is add collection result=%@",dic);
            if ([dic[@"success"] boolValue]) {
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",dic[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                //                _isCollectionTopic = YES;
                [self getPVUVWithTopicIdInHTML];//获取统计数
                [self firstflIsCollectionTopic];
            } else {
                FL_Log(@"未知？？错误");
            }
            //            [_webView reload];
        } failure:^(NSError *error) {
            
        }];
    }
    
}
#pragma mark 查看发布者热度
- (void)getInfoMationInHTML
{
    NSDictionary* parm = @{@"topic.userId":_flsquareAllFreeModel[@"userId"],
                           @"topic.userType":_flsquareAllFreeModel[@"userType"],
                           @"token":XJ_USER_SESSION ,
                           };
    NSMutableDictionary* xjxj = parm.mutableCopy;
    if ( [_flsquareAllFreeModel[@"userId"] integerValue] ==[XJ_USERID_WITHTYPE integerValue]) {
        [xjxj setObject:@"" forKey:@"topic.checkUserId"];
    } else {
        [xjxj setObject:[NSString stringWithFormat:@"%@",_flsquareAllFreeModel[@"userId"]] forKey:@"topic.checkUserId"];
    }
    parm = xjxj.mutableCopy;
    [FLNetTool flHTMLGetPublisherMessageByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my test nothis thing=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _flTopicMessageArray = @[data];
            [self setInfoToHTMLToReload];
        }
        
    } failure:^(NSError *error) {
        [self setInfoToHTMLToReload];
        FL_Log(@"this is my test nothis thing=%@",error);
    }];
}
#pragma mark 刷新数据
- (void)reloadDataAndRefreshPage
{
    NSDictionary* parm = @{@"topic.topicId":_flFuckTopicId,
                           @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:_flFuckTopicId]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in detailss see html =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:_flFuckTopicId];
            //            _flsquareAllFreeModel = data[FL_NET_DATA_KEY];
            _flsquareAllFreeModel = [FLTool returnDictionaryWithDictionary:data[FL_NET_DATA_KEY]];
            [self setInfoToHTMLToReload];
            //            [_webView reload];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjSearchHTMLDetailsByCommentIdWithNickName:(NSString*)xjSearchStr {
    NSDictionary* parm = @{@"userId":XJ_USERID_WITHTYPE,
                           @"participate.topicId":_flFuckTopicId,
                           @"participate.nickname":xjSearchStr};
    [FLNetTool xjSearchHTMLDetailsByCommentId:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the lalalala search la =%@",data);
        _xjSearchHelpListNameArr = @[data];
        NSArray* xjArr = _xjSearchHelpListNameArr[0][FL_NET_DATA_KEY];
        if (xjArr.count >0) {
            //            [self.webView stringByEvaluatingJavaScriptFromString:@"xjHrefToShenMeGuia()"];
            [self callJSInHTMLWithMethod:@"xjHrefToShenMeGuia" Data:nil]; //搜索结果的列表展示
        }
        [self setInfoToHTMLToReload];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ++++===-=-=-=-=-=-=-=-=-=-=- =-=-=-    URL functions
#pragma mark 返回主菜单
- (void)flGoBackToTabBarMenu {
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------------------------------------------[JS-CALL]
- (void)doSomethingWithName:(NSString*)xjname andObj:(id)xjObj {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    FL_Log(@"name and obj =%@ ,%@",xjname,xjObj);
    if ([xjname isEqualToString:@"setInfoAndSaveTopic"]) {
        [self setInfoAndSaveTopic:xjObj];
    } else if ([xjname isEqualToString:@"xjGotoMyPersonalHelpPage"]) {
        [self xjGotoMyPersonalHelpPageWithxjObj:xjObj];
    } else if ([xjname isEqualToString:@"xjTestcanyulist"]) {
        
    } else if ([xjname isEqualToString:@"xjCallOCToShowMorePartInfo"]) {
        NSInteger xjCurrent = [xjObj integerValue] + 1;
        [self xjGetHelpListWithCurrentPage:xjCurrent pageSize:xjSize_PageSize];
    } else if ([xjname isEqualToString:@"FLFLHTMLActionPerZhuliqiangHelpClick"]) {
        [self FLFLHTMLActionPerZhuliqiangHelpClick:xjObj];
    } else if ([xjname isEqualToString:@"xjSearchHTMLDetailsByCommentIdWithNickName"]) {
        [self xjSearchHTMLDetailsByCommentIdWithNickName:xjObj];
    } else if ([xjname isEqualToString:@"xjAlertInfoWithStr"]) {
        [self xjAlertInfoWithStr:xjObj];
    } else if ([xjname isEqualToString:@"xjPbulisherClick"]) {
        [self xjPbulisherClick:xjObj];
    } else if ([xjname isEqualToString:@"xjInsertJudgeCommentWithStr"]) {
        [self xjInsertJudgeCommentWithStr:xjObj];
    } else if ([xjname isEqualToString:@"xjInsertJudgeBackWithStr"]) {
        [self xjInsertJudgeBackWithStr:xjObj];
    }  else if ([xjname isEqualToString:@"xjPushPerZLQAndPassId"]) {
        [self xjPushPerZLQAndPassId:xjObj];
    } else if ([xjname isEqualToString:@"HTMLjubaoclick"]) {
        [self HTMLjubaoclick:xjObj];
    } else if ([xjname isEqualToString:@"xjLoadMoreHelpListInHtmlZlq"]) {
        [self xjLoadMoreHelpListInHtmlZlq:xjObj];
    }
}

#pragma mark do nothing
- (void)wozhenshirilegou {
    FL_Log(@"this is the function to do nothing");
}

- (void)zhuanfaAndCanyuWithContinueZhuli{
    [FLTool showWith:@"加油加油，继续转发获取助力吧~"];
    _xj_is_pariIn_show = NO;
    [self performSelector:@selector(zhuanfaAndCanyu) withObject:nil afterDelay:2];
}

- (void)zhuanfaAndCanyu {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    [self FLFLHTMLInsertParticipate];//插入 参与记录
    //    [self flRelayTopicWithNoTypeInHTMLVC];//插入领取记录
    FL_Log(@"this is the function to zhuanfa and canyu");
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
            [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
            XJZhuLQShareViewController * xjZLQVC = [[XJZhuLQShareViewController alloc] initWithNibName:@"XJZhuLQShareViewController" bundle:nil];
            xjZLQVC.xjTopicId = _flFuckTopicId;
            xjZLQVC.xjTopicDic = _flsquareAllFreeModel;
            xjZLQVC.xjstr = @"";
            FL_Log(@"this is teh action to push the page of tzhuli");
            [self.navigationController pushViewController:xjZLQVC animated:YES];
            return;
        } else {
            [self showMenu];
        }
    });
}

- (void)xjZhuanfaOnlyWithHelp {
    
}

- (void)xjAlertZHUANFALING {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    [FLTool showWith:@"嘻嘻，好东东要分享之后才能领取哦~"];
    [self performSelector:@selector(xjZhuanFaLing) withObject:nil afterDelay:2];
}
- (void)xjZhuanFaLing {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    _isRelayToPick = YES;
    [self FLFLHTMLInsertParticipate];//插入 参与记录
    [self flRelayTopicWithNoTypeInHTMLVC];//插入领取记录
    FL_Log(@"this is the function to zhuanfa and canyu");
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
            [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
            XJZhuLQShareViewController * xjZLQVC = [[XJZhuLQShareViewController alloc] initWithNibName:@"XJZhuLQShareViewController" bundle:nil];
            xjZLQVC.xjTopicId = _flFuckTopicId;
            xjZLQVC.xjTopicDic = _flsquareAllFreeModel;
            FL_Log(@"this is teh action to push the page of zhuliket");
            [self.navigationController pushViewController:xjZLQVC animated:YES];
            return;
        } else {
            [self showMenu];
        }
    });
}

- (void)xjPushZLQHTMLPageAndAlert{
    [FLTool showWith:@"即刻发起助力，拼颜值拼人品的时候到啦~"];
    [self performSelector:@selector(zhuanfaAndCanyu) withObject:nil afterDelay:2];
}

- (void)onlyShreToFriend {
    _isRelayToPick = NO;
}
- (void)wozhenshirilegoudizhi {
    FLChooseMapViewController* mapViewC = [[FLChooseMapViewController alloc] init];
    mapViewC.flAddressDic = self.flsquareAllFreeModel;
    FL_Log(@"this is teh action to push the page of t,map");
    [self.navigationController pushViewController:mapViewC animated:YES];
}
- (void)setInfoAndSaveTopic:(id)xjDic {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }

    FL_Log(@"this is my dicccc=%@",xjDic);
    //    NSArray* array = xjDic;//[FLTool returnArrayWithJSONString:notifition.object];
    //    NSDictionary* dic= array[0];
    NSString* str = [FLTool returnDictionaryToJson:xjDic];
    NSDictionary* parm = @{@"participateDetailes.topicId":_flFuckTopicId,
                           @"participateDetailes.userId":FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID,
                           @"participateDetailes.userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"participateDetailes.creator":FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID,//FLFLIsPersonalAccountType ?_flsquareAllFreeModel[@"userId"] :_flsquareAllFreeModel[@"creator"],
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID],
                           @"participateDetailes.message": str};
    FL_Log(@"parm in why ? = %@",parm);
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in save topic info =%@",data[@"success"]);
        
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            
            [[FLAppDelegate share] showHUDWithTitile:@"操作成功" view:self.view delay:1 offsetY:0];
            //            [self reloadDataAndRefreshPage];//更新数据，刷新界面
            [self xjRefreshHTMLView];//更新数据，刷新界面
            [self xjSetPartInfoWithInfoUnderReceive:str];
            //插入参与记录
            //            [self FLFLHTMLInsertParticipate];
            //插入参与记录
            if (![_xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
                [self FLFLHTMLInsertParticipate];
            }
            [self xjGetlingqushijian]; //
            //跳到票券页
            
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic info =%@",error);
    }];
    
}
//调用给 参与列表传参
- (void)xjCanyuListTopicPartIn {
    if ( self.myActivityHelpListArray) {
        [self callJSInHTMLWithMethod:@"xjCanyuListTopicPartIn" Data:@[[FLTool xj_returnJsonWithObj:_myActivityHelpListArray],[NSNumber numberWithBool:_xjIsPartInListFull]]]; //助力列表
    }
}

- (void)xjInitiateHelpAndRealy {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    //插入参与记录
    [self xjInsertPartRecordOnly];
    //调起转发  需要分情况
    if ([self.xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
        [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
        XJZhuLQShareViewController * xjZLQVC = [[XJZhuLQShareViewController alloc] initWithNibName:@"XJZhuLQShareViewController" bundle:nil];
        xjZLQVC.xjTopicId = _flFuckTopicId;
        xjZLQVC.xjTopicDic = _flsquareAllFreeModel;
        FL_Log(@"this is teh action to push the page of tzhulit");
        [self.navigationController pushViewController:xjZLQVC animated:YES];
        return;
    } else {
        [self showMenu];
    }
    
    //刷新界面
    [self xjRefreshHTMLView];
}
//到我的助力列表
- (void)xjGotoMyPersonalHelpPageWithxjObj:(NSString*)xjobj{
    _xjPerHelpListUserId = xjobj;
    [self getPerZLQLisetInHTMLWithID:xjobj]; //此处id 为participateId
}

#pragma mark -------------- new request
- (void)xjInsertPartRecordOnly {
    FL_Log(@"点击插入参与记录only");
    NSDictionary* parm =@{@"participate.topicId":_flFuckTopicId,
                          @"participate.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"participate.userType":FLFLXJUserTypePersonStrKey,   //商家不可以点击领取
                          @"participate.creator":FL_USERDEFAULTS_USERID_NEW};   //个人领取永远是个人id
    [FLNetTool HTMLinsertParticipateInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"点击插入参与记录成功only= %@",data);
        [self.webView reload];
        [self checkCanPickTopicInHTNL];//查看领取资格
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ----- get Info from service  领取资格
- (void)checkTakeCanOrNot {
    FL_Log(@"this web view begin to reload for test");
    //检查领取资格
    NSDictionary* parm = @{@"participate.topicId": _flFuckTopicId,
                           @"participate.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in check pi22ck topic =%@",data);
        if (data) {
            _myCheckQualificationData = data;
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjGetHelpListWithCurrentPage:(NSInteger)xjCurrentPage pageSize:(NSInteger)xjPageSize{
    _xj_iszlListLoading = YES;
    NSDictionary* parm = @{@"participate.topicId":_flFuckTopicId,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"page.currentPage":[NSNumber numberWithInteger:xjCurrentPage],
                           @"page.pageSize":  [NSNumber numberWithInteger:xjPageSize]
                           };
    [FLNetTool HTMLfindParticipateListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"dassssta in search help list in html =%@",data);
        _xjhowmanyPeopleTake =  data[@"total"];
        NSMutableArray* xjTemp = @[].mutableCopy;
        NSInteger xjtest = [data[@"total"] integerValue];
        NSArray* xjArr = [self returnSelfWithAvatarDic:data[FL_NET_DATA_KEY]];
        for (NSInteger i = 0; i < xjArr.count; i++) {
            id obj = xjArr[i];
            [xjTemp addObject:obj];
        }
        if (xjCurrentPage ==1) {
            [self.myActivityHelpListArray removeAllObjects];
        }
        [self.myActivityHelpListArray addObjectsFromArray:xjTemp];
        FL_Log(@"sssssssssssssssssaaaaaaaaaaaaaaaaaaaaa=%@",self.myActivityHelpListArray);
        if (_myActivityHelpListArray.count <  xjtest) {
            _xjIsPartInListFull = NO;
        } else {
            _xjIsPartInListFull = YES;
        }
        [self setInfoToHTMLToReload];
        _xj_iszlListLoading = NO;
    } failure:^(NSError *error) {
        _xj_iszlListLoading = NO;
        FL_Log(@"erroe with help list ====%@",error);
    }];
}
- (void)xjSetProgressInDetails {
    
}

- (void)xjHTMLCareOnly{
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    FL_Log(@"this is the action to care only=%@",self.xjNeedModel.topicConditionKey);
    if (_xjIsFriend ) {
        //       [[FLAppDelegate share] showHUDWithTitile:@"你们已经是好友了" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        //        return;
        //调用IM删除好友
        [self xjRemoveFriend];
    } else {
        //添加好友
        [self xjAddFriendAndRefresh];
    }
    
}

- (void)xjRemoveFriend {
    EMError *error;
    NSString* xjStr = [NSString stringWithFormat:@"%@_%ld",_xjNeedModel.userType,_xjNeedModel.userId];
    [[EaseMob sharedInstance].chatManager removeBuddy:xjStr removeFromRemote:YES error:&error];
    [self hideHud];
    if (error) {
        if ([_xjNeedModel.userType isEqualToString:FLFLXJUserTypeCompStrKey]) {
            [self showHint:@"取消关注失败"];
        } else {
            [self showHint:@"删除好友失败"];
        }
    }
    else{
        if ([_xjNeedModel.userType isEqualToString:FLFLXJUserTypeCompStrKey]) {
            [self showHint:@"取消关注成功"];
        } else {
            [self showHint:@"删除好友成功"];
        }
        
        [self xjRefreshHTMLView];
    }
}

#pragma mark 是否是好友
- (void)xjCheckIsFriendOrNot {
    NSDictionary* parm = @{@"imOwerName":[NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE],
                           @"imFriendName":[NSString stringWithFormat:@"%@_%ld",self.xjNeedModel.userType,(long)self.xjNeedModel.userId]};
    [FLNetTool xjCheckIsFriendsByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is t2he result to check friend=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if ([data[FL_NET_DATA_KEY]boolValue]) {
                _xjIsFriend = YES;
            } else {
                _xjIsFriend = NO;
            }
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
    
    //    [self xjAddFriendAndRefresh];
}

#pragma mark 添加好友
- (void)xjAddFriendAndRefresh {
    NSDictionary* parm = @{@"owerName":[NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE],
                           @"friendName":[NSString stringWithFormat:@"%@_%ld",self.xjNeedModel.userType,(long)self.xjNeedModel.userId]};
    [FLNetTool xjAddFriendsByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the ressult to add friend=%@",data);
        NSDictionary* xjDic = data[FL_NET_DATA_KEY];
        if ([data[FL_NET_KEY_NEW] boolValue] && [xjDic[@"statusCode"] integerValue]==200) {
            _xjIsFriend = YES;
            if ([_xjNeedModel.userType isEqualToString:FLFLXJUserTypeCompStrKey]) {
                [[FLAppDelegate share] showHUDWithTitile:@"关注成功" view:self.view delay:1 offsetY:0];
            } else {
                [[FLAppDelegate share] showHUDWithTitile:@"添加好友成功" view:self.view delay:1 offsetY:0];
            }
            //查看领取资格
            [self checkCanPickTopicInHTNL];
        } else {
            _xjIsFriend = NO;
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma  mark --------------------跳转
- (void)xjPbulisherClick:(NSString*)xjStr {
    if ([xjStr rangeOfString:@","].location != NSNotFound) {
        NSArray* xjArr = [xjStr componentsSeparatedByString:@","];
        if ([xjArr[0] isEqualToString:FLFLXJUserTypePersonStrKey]) {
            XJCheckPublisherViewController* xjPublishPer  = [[XJCheckPublisherViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@",xjArr[1]]];
            [self.navigationController pushViewController:xjPublishPer animated:YES];
        } else {
            XJCheckPublisherBusViewController* xjPbuliser = [[XJCheckPublisherBusViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@",xjArr[1]]];
            [self.navigationController pushViewController:xjPbuliser animated:YES];
        }
    }
    FL_Log(@"this is teh action to push the page of push");
}

#pragma  mark 关注并参与
- (void)xjHTMLCareAndPartIn{
    [FLTool showWith:@"正在为你关注TA，马上可以领取啦~"];
    [self xjAddFriendAndRefresh];
    //插入参与记录
    [self FLFLHTMLInsertParticipate];
    //查看领取资格
    [self checkCanPickTopicInHTNL];
    [self xjRefreshHTMLView];
}

- (void)xjHTMLPickUpAndPartIn {
    //插入参与记录
    [self FLFLHTMLInsertParticipate];
    //lingqu
    [self FLFLHTMLHTMLsaveTopicClickOn];
}

- (void)xjBlindYourPhoneNumber {
    [FLTool showWith:@"绑定手机号就可以马上参与活动啦~"];
    FL_Log(@"this is teh action to push the page of tiphonet");
    [self performSelector:@selector(pushBilndController) withObject:nil afterDelay:2.0f];
    
}
- (void)pushBilndController{
    FLBlindWithThirdTableViewController* xjBlind = [[FLBlindWithThirdTableViewController alloc] init];
    [self.navigationController pushViewController:xjBlind animated:YES];
}

#pragma mark 滑动效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 60) {
        //        FL_Log(@"thisi s ads =%lf",offsetY);
        
        self.xjGoBackBtn.hidden = NO;
    } else {
        self.xjGoBackBtn.hidden = YES;
    }
    
    
    
    
    
}
#pragma mark 刷新

- (void)xjRefreshHTMLView {
    [self.myActivityHelpListArray removeAllObjects];
    [self.myJudgeListPLArray removeAllObjects];
    [self.myJudgeListArray removeAllObjects];
    [self getDetailsInfoInFuckHtmlVC];
    [self checkCanPickTopicInHTNL];
    if (_xjIsRefresh) {
        if (![_flParentIdForReJudge isEqualToString:@""]) {
            [self getRejudgeListInHTML];//得到回评列表
        }
        if (_xjPerHelpListUserId.length!=0) {
            [self getPerZLQLisetInHTMLWithID:_xjPerHelpListUserId];
        }
        
    }
    _xjVersion_refresh = YES;
    
}

#pragma mark ACiont Sheet
- (void)XJAlertActionSheet {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }

    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    UIAlertController* xjAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* xjAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction* xjActionJB = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"xjJBActionToHref()"];
    }];
    [xjAlert addAction:xjAction];
    [xjAlert addAction:xjActionJB];
    [self presentViewController:xjAlert animated:YES completion:nil];
}


- (void)xjEndRefresh {
    [self.webView.scrollView.mj_header endRefreshing];
}

- (void)xjAlertInfoWithStr:(NSString*)xjStr {
    [FLTool showWith:xjStr];
    if ([_myCheckQualificationData[@"buttonKey"] isEqualToString:@"b10"]) {
        //已领取，请求details id
        NSDictionary* parm = @{@"topicId":self.flFuckTopicId,
                               @"userId":XJ_USERID_WITHTYPE};
        [FLNetTool xjxjGetDetailsIdWith:parm success:^(NSDictionary *data) {
            FL_Log(@"'this is the derstails id = 【%@】",data);
            if ([data[FL_NET_KEY_NEW] boolValue]) {
                NSString* detailsid = data[@"data"];
                self.flmyReceiveMineModel.flDetailsIdStr = detailsid;
                [self xjGetlingqushijian];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)xjxjxjxjTestLog {
    FL_Log(@"");
}

- (void)xjTextViewDidBeganToInputInHtmlPage:(NSNotification*)xjNoti{
    NSDictionary *userInfo = [xjNoti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    FL_Log(@"键盘高度22是  %d",height);
    FL_Log(@"键盘宽度22是  %d",width);
    //    [self callJSInHTMLWithMethod:@"keybordHeight" Data:@[[NSNumber numberWithFloat:height]]];
    
}

- (void)xjPushPerZLQAndPassId:(NSString*)xjId {
    [self.webView stringByEvaluatingJavaScriptFromString:@"xjPushPerZLQAndInitPage()"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"xjHrefZlqHtmlPage()"];
    NSArray* array = [xjId componentsSeparatedByString:@","];
    NSString* userId = array[0];
    NSString* nickname = @"我";
    if (array.count > 1) {
        nickname = array[1];
    }
    _flHelpTitle = @[nickname?nickname:@""];
    _xjPerHelpListUserId = userId;
    [self getPerZLQLisetInHTMLWithID:userId];//获取个人助力抢列表
    
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark ------------------------------------------------[点击加载更多]

- (void)xjLoadMoreHelpListInHtmlZlq:(NSString*)xjCueetnt {
    FL_Log(@"this i s the cueent from js=[%@]",xjCueetnt);
    NSInteger xxxx = [xjCueetnt integerValue];
    if (_xjIsPartInListFull) {
        return;
    }
    if (_xj_iszlListLoading) {
        return;
    }
    if ([XJFinalTool xjStringSafe:xjCueetnt]) {
        [self xjGetHelpListWithCurrentPage:xxxx+1 pageSize:xjSize_PageSize];//刷新排名
    }
}
#pragma mark ------------------------------------------------[点击跳转我自己的助力列表]
- (void)xjclicktopushselfhelplist {
    [self.webView stringByEvaluatingJavaScriptFromString:@"xj_pushSelfHelpList()"];
    [self xjPushPerZLQAndPassId:[NSString stringWithFormat:@"%@",self.xjNeedModel.participateId]];
}

#pragma mark ------------------------------------------------[查看排名]
- (void)xj_findmyrank:(NSString*)xjStr {
    if (![XJFinalTool xjStringSafe:xjStr]) {
        return;
    }
    NSDictionary* parm = @{@"participate.topicId":_flFuckTopicId?_flFuckTopicId:@"",
                           @"participate.participateId":xjStr};
    NSMutableDictionary* xjmu = parm.mutableCopy;
    if ([_xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]
        && [_xjNeedModel.zlqRule isEqualToString:@"FIRST"]) {
        [xjmu setObject:@"FIRST" forKey:@"participate.zlqRule"];
    }
    parm = xjmu.mutableCopy;
    
    [FLNetTool xj_findMyRankInHelpList:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result of data=[%@]",data);
        if (data ) {
            _xj_zlq_rankJson = data;
        }
    } failure:^(NSError *error) {
        
    }];
}
@end





