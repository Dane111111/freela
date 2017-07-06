//
//  XJHFiveCallLocationJsController.m
//  FreeLa
//
//  Created by Leon on 16/6/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJHFiveCallLocationJsController.h"
#import "XJXJScanViewController.h"
#import "XJXJFindARGiftViewController.h"
#import "XJFindGiftViewController.h"


#import <WebKit/WebKit.h>
#import "XJFreelaUVManager.h"
#define xjSize_PageSize  20

@interface XJHFiveCallLocationJsController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSURLRequest* _request;
    UIButton*               xjBackBtn;          //返回
    NSInteger _xjPLTotalNumber;//评论列表总数
    BOOL _xjIsJudgeListPLFull; //评论列表是否加载完毕
    BOOL _xjIsRefresh; //是不是刷新
    NSArray* _xjhowmanyPeopleTake; //总共多少人参与
    BOOL _xjIsPartInListFull ;  //参与列表是否加载完毕
    NSDictionary* _xjHTMLDetailDic;  //所有的 数据
    NSArray* _flPerHelpListArray; //个人助力抢列表
    
    NSArray* _flHelpTitle;  //助力抢标题
    NSString* _xjPerHelpListUserId; //获取个人助理列表的数据 userid
    NSString* _flParentIdForReJudge; //用来恢复评论的参数 (父Id)
    NSArray*  _flRejudgeListArray;  //回评列表数组
    
     BOOL _xj_iszlListLoading;//助力抢列表是否正在加载
    
    NSDictionary* _xj_zlq_rankJson;
    
}
/**context*/
@property (nonatomic , strong) JSContext* flXQJSContext;
/**详情数据模型*/
@property (nonatomic , strong) FLDetailsJSXQModel* fldetailJSXQModel;

@property (nonatomic , strong) UIWebView* xjWebView;
/**传进来的数据模型*/
@property (nonatomic , strong) NSDictionary* flsquareAllFreeModel;

/*参与者列表数组*/
@property (nonatomic , strong)NSMutableArray* myActivityHelpListArray;
/**评论列表数组*/
@property (nonatomic , strong)NSMutableArray* myJudgeListPLArray;
/**获取资格及原因*/
@property (nonatomic , strong)NSDictionary* myCheckQualificationData;
/**标记是否是个人进入*/
@property (nonatomic,  assign) BOOL isPersonalComeIn;
/**单条评论详情数组*/
@property (nonatomic , strong)NSArray* myJudgePLListArray;
@end

@implementation XJHFiveCallLocationJsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _xjIsRefresh = NO;
    _xj_iszlListLoading = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLActionPerZhuliqiangListClick:) name:FLFLHTMLActionPerZhuliqiangListClick object:nil];//进入个人助力抢界面，给助力抢界面传参 userId
    [self xjSetPagesInLoadURLPage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLHTMLInfoReJudgeWindow:) name:FLFLHTMLInfoReJudgeWindow object:nil];//给回复评论界面传参
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backPop:) name:@"FLFLHTMSethiddenWithNavi" object:nil];

}
-(instancetype)initWithTopicId:(NSString*)topicID {
    self = [super init];
    if (self) {
        self.xjTopicIdStr = topicID;
    }
    return self;
}

#pragma mark -------------------------------------------- [Lazy]

- (UIWebView *)xjWebView {
    if (!_xjWebView) {
        _xjWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) ];//WithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    }
    return _xjWebView;
}
- (NSMutableArray *)myJudgeListPLArray{
    if (!_myJudgeListPLArray) {
        _myJudgeListPLArray = [NSMutableArray array];
    }
    return _myJudgeListPLArray;
}
- (JSContext *)flXQJSContext {
    if (!_flXQJSContext) {
        _flXQJSContext = [_xjWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    return _flXQJSContext;
}
- (FLDetailsJSXQModel *)fldetailJSXQModel {
    if (!_fldetailJSXQModel) {
        _fldetailJSXQModel = [[FLDetailsJSXQModel alloc] init];
    }
    return _fldetailJSXQModel;
}
-(NSMutableArray *)myActivityHelpListArray {
    if (!_myActivityHelpListArray) {
        _myActivityHelpListArray = [NSMutableArray array];
    }
    return  _myActivityHelpListArray;
}
- (void)setXjPushStyle:(HFivePushStyle)xjPushStyle {
    _xjPushStyle = xjPushStyle;
    NSString* xjStr = @"";
    switch (xjPushStyle) {
        case  HFivePushStyleJudgeList: {
            xjStr = @"commentListH5.html";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self xjInitRequest:xjStr];
            });
            [self getJudgeListInHMLWithCurrentPage:@1]; //评论列表
        }
            break;
        case  HFivePushStylePartInJBPage:  {
            xjStr = @"jubao.html";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self xjInitRequest:xjStr];
            });
        }
            break;
        case  HFivePushStylePartInList:  {
            xjStr = @"canyulist.html";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self xjInitRequest:xjStr];
            });
            [self xjGetHelpListWithCurrentPage:1 pageSize:xjSize_PageSize];
        }
            break;
        case  HFivePushStyleHelpList:  {  //助力抢
            xjStr = @"zhuliqiang.html";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self xjInitRequest:xjStr];
            });
            [self xjGetHelpListWithCurrentPage:1 pageSize:xjSize_PageSize];
            [self checkCanPickTopicInHTNL];
            [self getDetailsInfoInFuckHtmlVC];
            
            
        }
            break;
        case  HFivePushStylePutInfoForTake:  {  //填写信息
            xjStr = @"addreciveinfo.html";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self xjInitRequest:xjStr];
            });
            
        }
            break;
        default:
            break;
    }
}
- (void)xjInitRequest:(NSString*)xjStr {
    NSString* path = [NSString stringWithFormat:@"/assets/%@",xjStr];
    NSString* newPath = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],path];
    FL_Log(@"path = [%@] andadnadnadnandn [%@]",[[NSBundle mainBundle] resourcePath],newPath);
    NSURL* filePath = [NSURL fileURLWithPath:newPath];
    _request = [NSURLRequest requestWithURL:filePath];
    if (self.xjPushStyle == HFivePushStylePartInJBPage ||self.xjPushStyle == HFivePushStylePutInfoForTake) {
        [self.xjWebView loadRequest:_request];
    }
}
- (void)xjLoadRequest{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.xjWebView loadRequest:_request];
    });
}
#pragma  mark -------------------------------------------- [WebView Delegate]

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"_webview start to load");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"_webview did finished load");
    
    self.flXQJSContext[@"FLMethodXQModel"] = self.fldetailJSXQModel;
    self.fldetailJSXQModel.jsContext = self.flXQJSContext;
    self.fldetailJSXQModel.webView = self.xjWebView;
    
    self.flXQJSContext.exceptionHandler = ^(JSContext* context, JSValue* exceptionValue){
        context.exception = exceptionValue;
        //        FL_Log(@"error in fuck html = %@",exceptionValue);
    };
    
    [FLTool hideHUD];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInfoToHTMLToReload];
        if (_flsquareAllFreeModel) {
            [self callJSInHTMLWithMethod:@"xjSetBanYuanInfo" Data:@[[FLTool xj_returnJsonWithObj:_flsquareAllFreeModel]]]; //助力抢 总数据   ,模型
        }
        //是 H5 需要添加返回的功能
        [self.xjWebView stringByEvaluatingJavaScriptFromString:@"xj_is_h5_xqPage()"]; //助力抢界面
        [self.xjWebView stringByEvaluatingJavaScriptFromString:@"xj_is_h5_CYPage()"]; //参与界面
        [self.xjWebView stringByEvaluatingJavaScriptFromString:@"xj_is_h5_CommentPage()"]; //参与界面
        [self.xjWebView stringByEvaluatingJavaScriptFromString:@"xj_is_h5_JBPage()"]; //Jubao界面
    });
}


- (void)xjSetPagesInLoadURLPage {
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.xjWebView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
    self.xjWebView.delegate = self;
    self.xjWebView.scalesPageToFit = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.xjWebView.scrollView.delegate = self;
    self.xjWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.xjWebView.backgroundColor = [UIColor whiteColor];
    //    self.title = @"sada";
    [self.view addSubview:self.xjWebView];
    [self.xjWebView setUserInteractionEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
    
    
    //back btn
    xjBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xjBackBtn.frame =  CGRectMake(20, 30, 30, 30);
    [xjBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
    [xjBackBtn addTarget:self action:@selector(xjClickToGoBack) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem*xjItem = [[UIBarButtonItem alloc] initWithCustomView:xjBackBtn];
    //    self.navigationItem.leftBarButtonItem = xjItem;
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    //    [self.view addSubview:xjBackBtn];
    
    __unsafe_unretained UIWebView *webView = self.xjWebView;
    webView.delegate = self;
    __unsafe_unretained UIScrollView *scrollView = self.xjWebView.scrollView;
    // 添加下拉刷新控
    
    scrollView.mj_header = [XJBirdFlyGifHeader headerWithRefreshingBlock:^{
        _xjIsRefresh = YES;
        [self xjRefreshHTMLViewInHfsss];
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)xjClickBtnToPushBackInCoverView {
    [self xjClickToGoBack];
}

- (void)xjClickToGoBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)callJSInHTMLWithMethod:(NSString*)methodStr partInfoStr:(NSString*)partInfoStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        JSValue*function = self.flXQJSContext[methodStr];
        JSValue*result = [function callWithArguments:@[partInfoStr]];

    });
}
- (void)callJSInHTMLWithMethod:(NSString*)methodStr Data:(NSArray*)array {
    dispatch_async(dispatch_get_main_queue(), ^{
        JSValue* function = self.flXQJSContext[methodStr];
        //                [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@:(%@)",methodStr,array[0]]];
        NSString*str=[array componentsJoinedByString:@","];
        JSValue *result = [function callWithArguments:@[str]];
    });
    

//    //    dispatch_async(dispatch_get_main_queue(), ^{
//    //        JSValue* function = self.flXQJSContext[methodStr];
//    //        //    [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@",methodStr]];
//    //        JSValue *result = [function callWithArguments:array];
//    //    });
//    
//    if (array.count==0) {
//        [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@()",methodStr]];
//    } else if (array.count==1) {
//        [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@)",methodStr,array[0]]];
//    } else if (array.count==2) {
//        [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@,%@)",methodStr,array[0],array[1]]];
//    } else if (array.count==3) {
//        [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@,%@,%@)",methodStr,array[0],array[1],array[2]]];
//    } else {
//        JSValue* function = self.flXQJSContext[methodStr];
//        JSValue *result = [function callWithArguments:array];
//    }
//    
}

#pragma mark -------------------------------------------- [html 数据请求]

/**获取评论列表 评论 评论 重要的 事情说三遍
 */
- (void)getJudgeListInHMLWithCurrentPage:(NSNumber*)xjCurrentPage
{
    NSDictionary* detail = @{@"businessId":self.xjTopicIdStr ? self.xjTopicIdStr :@"",
                             @"commentType":@"0", //1为评价  0为评论
                             @"isFlush":@"false",}; //分页
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:detail],
                           @"page.isFlush":@"true",
                           @"page.currentPage":xjCurrentPage};
    [FLNetTool htmlListCommentInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html wi2th judge listwi2th type 222 =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if (!_xjIsRefresh) {
                [self xjLoadRequest];
            }
            NSMutableArray* xjMuArr = @[].mutableCopy;
            xjMuArr = data[FL_NET_DATA_KEY];
            [self.myJudgeListPLArray addObjectsFromArray:xjMuArr];
            _xjPLTotalNumber = [data [@"total"] integerValue];
            _xjIsJudgeListPLFull = _xjPLTotalNumber <= _myJudgeListPLArray.count ? YES : NO;
            if ([xjCurrentPage  isEqual: @1]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //                    [self callJSInHTMLWithMethod:@"xjcommentInfo" Data:@[_myJudgeListPLArray,[NSNumber numberWithBool:_xjIsJudgeListPLFull]]]; //评论列表
                });
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self setInfoToHTMLToReload];
            });
            
        }
        [self xjHfEndRefresh];
    } failure:^(NSError *error) {
        [self xjHfEndRefresh];
    }];
}
#pragma mark -------------------------------------------[参与列表]
- (void)xjGetHelpListWithCurrentPage:(NSInteger)xjCurrentPage pageSize:(NSInteger)xjPageSize{
    _xj_iszlListLoading = YES;
    NSDictionary* parm = @{@"participate.topicId":self.xjTopicIdStr ? self.xjTopicIdStr :@"",
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"page.currentPage":[NSNumber numberWithInteger:xjCurrentPage],
                           @"page.pageSize":  [NSNumber numberWithInteger:xjPageSize]
                           };
    [FLNetTool HTMLfindParticipateListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in search help list in html =%@",data);
        if (!_xjIsRefresh) {
            [self xjLoadRequest];
        }
        _xjhowmanyPeopleTake =  data[@"total"];
        NSInteger xjtest = [data[@"total"] integerValue];
        NSArray* xjArr = data[FL_NET_DATA_KEY];
        if (xjArr.count==0) {
            return ;
        }
        if (xjCurrentPage==1) {
            [self.myActivityHelpListArray removeAllObjects];
        }
        [self.myActivityHelpListArray addObjectsFromArray:xjArr];
        FL_Log(@"sssssssssssssssssaaaaaaaaaaaaaaaaaaaaa=%@",self.myActivityHelpListArray);
        if (_myActivityHelpListArray.count <  xjtest) {
            _xjIsPartInListFull = NO;
        } else {
            _xjIsPartInListFull = YES;
        }
        _xj_iszlListLoading = NO;
        [self setInfoToHTMLToReload];
    } failure:^(NSError *error) {
        _xj_iszlListLoading = NO;
        FL_Log(@"erroe with help list ====%@",error);
    }];
}
#pragma mark -------------------------------------------[webview]

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
                
            }
        }
    }
    return YES;
}

#pragma mark -----------------------------------------------[JS-CALL]
- (void)doSomethingWithName:(NSString*)xjname andObj:(id)xjObj {
    
    FL_Log(@"name and obj =%@ ,%@",xjname,xjObj);
    if ([xjname isEqualToString:@"setInfoAndSaveTopic"]) {
        [self setInfoAndSaveTopic:xjObj];
    } else if ([xjname isEqualToString:@"xjGotoMyPersonalHelpPage"]) {
        
    } else if ([xjname isEqualToString:@"xjTestcanyulist"]) {
        
    } else if ([xjname isEqualToString:@"xjCallOCToShowMorePartInfo"]) {
        NSInteger xjCurrent = [xjObj integerValue] + 1;
        [self xjGetHelpListWithCurrentPage:xjCurrent pageSize:xjSize_PageSize];
    } else if ([xjname isEqualToString:@"FLFLHTMLActionPerZhuliqiangHelpClick"]) {
        [self FLFLHTMLActionPerZhuliqiangHelpClick:xjObj];
    } else if ([xjname isEqualToString:@"xjSearchHTMLDetailsByCommentIdWithNickName"]) {
        
    } else if ([xjname isEqualToString:@"xjAlertInfoWithStr"]) {
        [self xjAlertInfoWithStr:xjObj];
    } else if ([xjname isEqualToString:@"xjPbulisherClick"]) {
        
    } else if ([xjname isEqualToString:@"xjInsertJudgeCommentWithStr"]) {
        [self xjInsertJudgeCommentWithStr:xjObj];
    } else if ([xjname isEqualToString:@"xjPushPerZLQAndPassId"]) {
        [self xjPushPerZLQAndPassId:xjObj];
    } else if ([xjname isEqualToString:@"xjInsertJudgeBackWithStr"]) {
        [self xjInsertJudgeBackWithStr:xjObj];
    }  else if ([xjname isEqualToString:@"HTMLjubaoclick"]) {
        [self HTMLjubaoclick:xjObj];
    }  else if ([xjname isEqualToString:@"xjLoadMoreHelpListInHtmlZlq"]) {
        [self xjLoadMoreHelpListInHtmlZlq:xjObj];
    }
    
    
}


#pragma  mark --------------------------------------------[评论记录]
- (void)xjInsertJudgeCommentWithStr:(NSString*)xjComment {
    if (![XJFinalTool xjStringSafe:xjComment]) {
        [FLTool showWith:@"评论内容不能为空"];
        return;
    }
    //插入评论记录
    NSDictionary* dic = @{@"businessId":self.xjTopicIdStr?self.xjTopicIdStr:@"",
                          @"commentType":@"0",   //0代表评论
                          @"content":xjComment,
                          @"parentId":@"0"};
    NSDictionary* parm = @{ @"commentPara":[FLTool returnDictionaryToJson:dic],
                            @"userType": FLFLXJUserTypePersonStrKey,
                            @"userId":FL_USERDEFAULTS_USERID_NEW};
    [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"insert comment in html judge = %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [_myJudgeListPLArray removeAllObjects];
            [self getJudgeListInHMLWithCurrentPage:@1];
            [_xjWebView reload];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in insert comment html =%@",error);
    }];
}

#pragma mark ------------------------获取评论列表
- (void)xjClickToCheckMoreJudgePL {
    [self getJudgeListInHMLWithCurrentPage:[FLTool xjRetuenCurrentWithArrLength:self.myJudgeListPLArray.count andTotal:_xjPLTotalNumber xjSize:20]];
}

#pragma mark 刷新

- (void)xjRefreshHTMLViewInHfsss {
    if (self.xjPushStyle == HFivePushStyleJudgeList) {
        [self.myJudgeListPLArray removeAllObjects];
        [self getJudgeListInHMLWithCurrentPage:@1];
    } else if (self.xjPushStyle == HFivePushStyleJudgeList) {
        //        _flPerHelpListArray
        [self xjGetHelpListWithCurrentPage:1 pageSize:xjSize_PageSize];
    } else {
        [self xjHfEndRefresh];
    }
}
- (void)xjHfEndRefresh {
    [self.xjWebView.scrollView.mj_header endRefreshing];
}


- (void)setInfoToHTMLToReload {
    if (self.myJudgeListPLArray) {
        if (self.xjPushStyle == HFivePushStyleJudgeList && _myJudgeListPLArray) {
            //            [self callJSInHTMLWithMethod:@"xjcommentInfo" Data:@[_myJudgeListPLArray,[NSNumber numberWithBool:_xjIsJudgeListPLFull]]]; //评论列表
            [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"xjcommentInfo(%@,%@)",[FLTool xj_returnJsonWithObj:_myJudgeListPLArray],[NSNumber numberWithBool:_xjIsJudgeListPLFull]]];
        }
    }
    if (_myActivityHelpListArray) {
        
        if (_myCheckQualificationData) {
            [self callJSInHTMLWithMethod:@"xjCheckPartInInZhuLQJS" Data:@[[FLTool xj_returnJsonWithObj:_myCheckQualificationData],[NSNumber numberWithBool:self.isPersonalComeIn]]]; //助力抢。js
        }
        if (_xjHTMLDetailDic) {
            [self callJSInHTMLWithMethod:@"flGetJSXQInfomation" Data:@[[FLTool xj_returnJsonWithObj:_xjHTMLDetailDic]]];//活动详情
        }
        if (_xjhowmanyPeopleTake) {
            NSNumber* xxx = [NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@",_xjhowmanyPeopleTake] integerValue]];
            [self callJSInHTMLWithMethod:@"xjhowmanyPeopleTake" Data:@[xxx]]; //总共多少个人参与
        }
        [self callJSInHTMLWithMethod:@"useUserId" Data:@[[FLTool xj_returnJsonWithObj:@[XJ_USERID_WITHTYPE]],[FLTool xj_returnJsonWithObj:@[XJ_USERTYPE_WITHTYPE]]]];
        if (_xjPushStyle == HFivePushStyleHelpList) {
            [self callJSInHTMLWithMethod:@"topiczhuliqiangInZhuliqiangJS" Data:@[[FLTool xj_returnJsonWithObj:self.myActivityHelpListArray],[FLTool xj_returnJsonWithObj:@[FL_USERDEFAULTS_USERID_NEW]]]];
        }
    }
    
    if (_flPerHelpListArray) {
        //        [self callJSInHTMLWithMethod:@"perzhuliqiangInPerZLQJS" Data:@[_flPerHelpListArray]];
        [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"perzhuliqiangInPerZLQJS(%@)",[FLTool xj_returnJsonWithObj:_flPerHelpListArray]]];
    }
    
    if (self.xjPushStyle == HFivePushStylePutInfoForTake) {
        if (self.xjPartInfoArr) {
            [self callJSInHTMLWithMethod:@"writeReceiveInJubaoJS" Data:self.xjPartInfoArr];
        }else if (self.xjPartInfoStr){
            [self callJSInHTMLWithMethod:@"writeReceiveInJubaoJS" partInfoStr:self.xjPartInfoStr];

        }
    }
    if (_myJudgePLListArray) {
        //        [self callJSInHTMLWithMethod:@"flReJudgegetInfoInHTML" Data:@[[FLTool xj_returnJsonWithObj:_myJudgePLListArray]]];
        JSValue* function = self.flXQJSContext[@"flReJudgegetInfoInHTML"];
        JSValue *result = [function callWithArguments:_myJudgePLListArray];
        
    }
    if (_xj_zlq_rankJson) {
        [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"xj_zlq_myrank(%@)",[FLTool xj_returnJsonWithObj:_xj_zlq_rankJson]]];
    }
    
}
- (void)xjCanyuListTopicPartIn {
    if ( self.myActivityHelpListArray) {
        [self callJSInHTMLWithMethod:@"xjCanyuListTopicPartIn" Data:@[[FLTool xj_returnJsonWithObj:_myActivityHelpListArray],[NSNumber numberWithBool:_xjIsPartInListFull]]]; //助力列表
    }
}

#pragma mark ----- get Info from service  领取资格
//获取领取资格
- (void)checkCanPickTopicInHTNL {
    NSDictionary* parm = @{@"participate.topicId": _xjTopicIdStr,
                           @"participate.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FL_USERDEFAULTS_USERID_NEW};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in check pick topic =%@",data);
        if (data) {
            _myCheckQualificationData = data;
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ----- get Info from service  主要model
- (void)getDetailsInfoInFuckHtmlVC {
    NSString* xjStr = [NSString stringWithFormat:@"%@",FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID];
    if (!xjStr || [xjStr isEqualToString:@"(null)"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

        return;
    }
    //    [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.webView];
    NSDictionary* parm = @{@"topic.topicId":_xjTopicIdStr,
                           @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:_xjTopicIdStr]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in details see html =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _xjHTMLDetailDic = data;
            _flsquareAllFreeModel = [FLTool returnDictionaryWithDictionary:data[FL_NET_DATA_KEY]];
            if([XJFinalTool xjStringSafe:data[FL_NET_DATA_KEY][@"participateId"]]) {
                [self xj_findmyrank:[NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][@"participateId"]]]; //查看排名
            }
        }
        [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:_xjTopicIdStr];
        [FLTool hideHUD];
        
    } failure:^(NSError *error) {
        [FLTool showWith:@"加载失败，请重新尝试"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

        [FLTool hideHUD];
    }];
}

//获取个人助力抢列表
- (void)getPerZLQLisetInHTMLWithID:(NSString*)userId    //此处应该使用participateIdƒ√

{
    NSDictionary* parm =@{@"page.currentPage":@"1",
                          @"topicPromote.topicId":_xjTopicIdStr,
                          @"topicPromote.participateId":userId,
                          @"page.pageSize":  [NSNumber numberWithInteger:10000000]};
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


#pragma mark ------------------------------------------给别人助力一次
- (void)FLFLHTMLActionPerZhuliqiangHelpClick:(NSString*)nsnotifation {
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"当前版本暂不支持此功能"];
        return;
    }
    NSDictionary* parm = @{@"topicPromote.sourceId":@"3",  //3代表 iOS 移动端
                           @"topicPromote.topicId":_xjTopicIdStr,
                           @"topicPromote.participateId":nsnotifation,  //助力id
                           @"topicPromote.userToId":FL_USERDEFAULTS_USERID_NEW,
                           @"token":XJ_USER_SESSION,
                           };
    [FLNetTool HTMLInsertTopicPromoteInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"help other success =%@",data);
        [self xjAlertInfoWithStr:data[@"msg"]];
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self.myActivityHelpListArray removeAllObjects];
            [self xjGetHelpListWithCurrentPage:1 pageSize:xjSize_PageSize];//刷新排名
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjGoBackBtnClickInHFive {
    [self xjClickToGoBack];
}
- (void)xjAlertInfoWithStr:(NSString*)xjStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        [FLTool showWith:xjStr];
    });
    
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

#pragma mark --------------------------------------------进入个人助力抢界面，传进来userId

- (void)FLFLHTMLActionPerZhuliqiangListClick:(NSNotification*)notifation {
    FL_Log(@"点击进入个人助力抢界面，给助力抢界面传参= %@",notifation.object);
    NSArray* array = notifation.object;
    NSString* userId = array[0];
    NSString* nickname = array[1];
    _flHelpTitle = @[nickname];
    _xjPerHelpListUserId = userId;
    [self getPerZLQLisetInHTMLWithID:userId];//获取个人助力抢列表
    //    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"flXQSetHelpListTitleInHTML()"]];
    
}

- (void)xjPushPerZLQAndPassId:(NSString*)xjId {
    [self.xjWebView stringByEvaluatingJavaScriptFromString:@"xjPushPerZLQAndInitPage()"];
    [self.xjWebView stringByEvaluatingJavaScriptFromString:@"xjHrefZlqHtmlPage()"];
    NSArray* array = [xjId componentsSeparatedByString:@","];
    NSString* userId = array[0];
    NSString* nickname = array[1];
    _flHelpTitle = @[nickname];
    _xjPerHelpListUserId = userId;
    [self getPerZLQLisetInHTMLWithID:userId];//获取个人助力抢列表
}

- (void)setInfoAndSaveTopic:(id)xjDic {
    FL_Log(@"this is my dicccc=%@",xjDic);
    NSString* str = [FLTool returnDictionaryToJson:xjDic];
    NSDictionary* parm = @{@"participateDetailes.topicId":_xjTopicIdStr ? _xjTopicIdStr :@"",
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
            
            [self xjSetPartInfoWithInfoUnderReceive:str];
            
            //插入参与记录
            if (![self.xjTopicDeatailModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
                [self FLFLHTMLInsertParticipate];
            }
            //跳到票券页
            for (UIViewController*ctr in [self.navigationController childViewControllers]) {
                if ([ctr isKindOfClass:[XJXJScanViewController class]]) {
                    XJXJScanViewController* scCtr=(XJXJScanViewController*)ctr;
                    scCtr.isHtmlPop=YES;
                }else if([ctr isKindOfClass:[XJXJFindARGiftViewController class]]){
                    XJXJFindARGiftViewController* scCtr=(XJXJFindARGiftViewController*)ctr;
                    scCtr.isHtmlPop=YES;
                    
                }else if([ctr isKindOfClass:[XJFindGiftViewController class]]){
                    XJFindGiftViewController*scCtr=(XJFindGiftViewController*)ctr;
                    scCtr.isHtmlPop=YES;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];

//            XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
//            ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
//            FL_Log(@"this is teh action to push the page of ticke2t");
//            [self.navigationController pushViewController:ticketVC animated:YES];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic info =%@",error);
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

#pragma mark 点击插入参与记录 (发起助力抢等)
- (void)FLFLHTMLInsertParticipate
{
    FL_Log(@"点击插入参与记录");
    NSDictionary* parm =@{@"participate.topicId":_xjTopicIdStr?_xjTopicIdStr:@"",
                          @"participate.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"participate.userType":FLFLXJUserTypePersonStrKey,   //商家不可以点击领取
                          @"participate.creator":FL_USERDEFAULTS_USERID_NEW};   //个人领取永远是个人id
    [FLNetTool HTMLinsertParticipateInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"点击插入参与记录成功= %@",data);
        [self checkCanPickTopicInHTNL]; //获取领取资格
        [self setInfoToHTMLToReload];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ------------------------------------------------[点击加载更多]

- (void)xjLoadMoreHelpListInHtmlZlq:(NSString*)xjCueetnt {
    FL_Log(@"this i s the cueent from js=[%@]",xjCueetnt);
    if (_xjIsPartInListFull) {
        return;
    }
    if (_xj_iszlListLoading) {
        return;
    }
    if ([XJFinalTool xjStringSafe:xjCueetnt]) {
        [self xjGetHelpListWithCurrentPage:[xjCueetnt integerValue]+1 pageSize:xjSize_PageSize];//刷新排名
    }
}
#pragma mark -----------------------JS返回
-(void)backPop:(NSNotification*)notification{
//    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });

}

#pragma mark --------------------------------------------给回复评论界面JS传参 同时得到评论列表
- (void)FLFLHTMLInfoReJudgeWindow:(NSNotification*)notification {
    FL_Log(@"notifation with ReJudge clickon = %@", notification.object);
    _flParentIdForReJudge = notification.object[4];
    [self getRejudgeListInHTML];
    _myJudgePLListArray = @[notification.object[0],notification.object[1],notification.object[3],notification.object[4],notification.object[2]];
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
#pragma  mark --------------------------------------------[回复评论]
- (void)xjInsertJudgeBackWithStr:(NSString*)xjComment {
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"当前版本暂不支持此功能"];
        return;
    }
    //插入回评记录
    NSDictionary* dic = @{@"businessId":_xjTopicIdStr?_xjTopicIdStr:@"",
                          @"commentType":@"2",   //2代表回复
                          @"content":xjComment,
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

#pragma mark ------------------------------------------------[查看排名]
- (void)xj_findmyrank:(NSString*)xjStr {
    if (![XJFinalTool xjStringSafe:xjStr]) {
        return;
    }
    NSDictionary* parm = @{@"participate.topicId":_xjTopicIdStr?_xjTopicIdStr:@"",
                           @"participate.participateId":xjStr};
    [FLNetTool xj_findMyRankInHelpList:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result of data=[%@]",data);
        if (data ) {
            _xj_zlq_rankJson = data;
            //            [self.xjWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"xj_zlq_myrank(%@)",[FLTool xj_returnJsonWithObj:_xj_zlq_rankJson]]];
            [self setInfoToHTMLToReload];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ----Actions --- no
//点击举报

- (void)HTMLjubaoclick:(NSString*)notification {
    FL_Log(@"notifation with jubao clickon = %@", notification);
    FL_Log(@"this is report result= ===userId%@======%@",FL_USERDEFAULTS_USERID_NEW,notification);
    [FLFinalNetTool flNewHTMLInsertReportWithTopicId:_xjTopicIdStr?_xjTopicIdStr:@""
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


@end











