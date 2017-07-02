//
//  XJLoadOutURLController.m
//  FreeLa
//
//  Created by Leon on 16/6/22.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJLoadOutURLController.h"
#import "XJCoverTopView.h"
#import "XJCoverBottomView.h"
#import "XJTopicDetailModel.h"
//#import "XJTopicCommenListModel.h"
#import "XJTopicPartInModel.h"
#import "XJTopicStatisticModel.h"
#import "XJHFiveCallLocationJsController.h"
#import "XJQualificationModel.h"
#import "XJCheckPublisherBusViewController.h"
#import "XJCheckPublisherViewController.h"
#import "XJZhuLQShareViewController.h"
#import "XJFreelaUVManager.h"
#import "XJShareContentModel.h"

@interface XJLoadOutURLController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,XJCoverTopViewDelegate,XJCoverBottomViewDelegate>
{
    BOOL                    _xj_Click_Click;     //防止重复点击
    UIButton*               xjBackBtn;          //返回
    UIImageView*            _xjCoverImageView;  //蒙层
    XJTopicDetailModel*     _xjTopicDeatailModel; //详情
    NSInteger               _xjPartInTotal;         //参与宗人数
    XJTopicStatisticModel*  _xjTopicStatisticModel;//统计
    NSDictionary* _xjHtmlDeatilDic;//dic
    
    NSArray*  _flPartInfoListArray;   //获取填写领取信息
    BOOL    _xj_is_help_and_first; //助力抢是不是第一次参与
}
@property (nonatomic , strong) UIWebView* xjWebView;
@property (nonatomic , strong) XJCoverTopView* xjTopView;
@property (nonatomic , strong) XJCoverBottomView* xjBottomView;
/**menu to share*/
@property (nonatomic , strong) CHTumblrMenuView *menuView;

/**给票券页准备的model*/
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;

@property (nonatomic , strong) XJShareContentModel* xjSharePlanModel;

@end

@implementation XJLoadOutURLController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _xj_Click_Click = NO;
    //    [self xjRequestHTMLFiveOutURLById:self.xjTempId];
    [self xjSetPagesInLoadURLPage];
    _xj_is_help_and_first = NO;
    
}
- (void)initPage {
    
}

- (UIWebView *)xjWebView {
    if (!_xjWebView) {
        _xjWebView = [[UIWebView alloc] init];//WithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    }
    return _xjWebView;
}

- (XJCoverTopView *)xjTopView {
    if (!_xjTopView) {
        _xjTopView = [[XJCoverTopView alloc] initWithFrame:CGRectMake(0, -130, FLUISCREENBOUNDS.width, 130) delegate:self];
        //        self.xjTopView.frame = CGRectMake(0, FLUISCREENBOUNDS.height, FLUISCREENBOUNDS.width, 130);
    }
    return _xjTopView;
}
- (XJCoverBottomView *)xjBottomView {
    if (!_xjBottomView) {
        _xjBottomView = [[XJCoverBottomView alloc] initWithFrame:CGRectMake(0, FLUISCREENBOUNDS.height, FLUISCREENBOUNDS.width, 200) delegate:self];
    }
    return _xjBottomView;
}
- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}
- (void)xjSetPagesInLoadURLPage {
    self.view.backgroundColor = [UIColor whiteColor];
    self.xjWebView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
    self.xjWebView.delegate = self;
    self.xjWebView.scalesPageToFit = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.xjWebView.scrollView.delegate = self;
    self.xjWebView.scrollView.showsVerticalScrollIndicator = NO;
    //    self.xjTopView.delegate = self;
    //    self.xjBottomView.delegate =self;
    
    UITapGestureRecognizer* xjTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjClickToShowDeatil)];
    [xjTap setNumberOfTapsRequired:1];
    [xjTap setNumberOfTouchesRequired:1];
    xjTap.delegate  = self;
    [self.view addGestureRecognizer:xjTap];
    [self.view addSubview:self.xjWebView];
    [self.xjWebView setUserInteractionEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
    //cover
    _xjCoverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xj_cover_html"]];
    _xjCoverImageView.frame = self.xjWebView.frame;
    [_xjCoverImageView setHidden:YES];
    [self.view addSubview:_xjCoverImageView];
    
    [self.view addSubview:self.xjTopView];
    [self.view addSubview:self.xjBottomView];
    
    //back btn
    xjBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xjBackBtn.frame =  CGRectMake(20, 30, 30, 30);
    [xjBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
    [xjBackBtn addTarget:self action:@selector(xjClickToGoBack) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem*xjItem = [[UIBarButtonItem alloc] initWithCustomView:xjBackBtn];
    //    self.navigationItem.leftBarButtonItem = xjItem;
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.view addSubview:xjBackBtn];
    [self performSelectorOnMainThread:@selector(xjRequestHTMLFiveOutURLById:) withObject:self.xjTempId waitUntilDone:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self xjCheckTakeOrNot]; //获取领取资格
    
    
}
#pragma  mark  ------------------  [设置内容]
- (void)xjSetPageInfoWithModel {
    self.xjTopView.xjTopicDetailnModel = _xjTopicDeatailModel;
    self.xjBottomView.xjTopicDetailnModel = _xjTopicDeatailModel;
}

- (void)xjSetPartInCommenListAvatar:(NSArray*)xjArr {
    NSMutableArray* xjMuArr = @[].mutableCopy;
    for (XJTopicPartInModel* xjModel in xjArr) {
        NSString* xjAvatar = xjModel.avatar ? xjModel.avatar:@"";
        [xjMuArr addObject:xjAvatar];
    }
    self.xjTopView.xjTopicPartInArr = xjMuArr.mutableCopy;
}

- (void)xjSetStatisticNumber {
    //    _xjTopicDeatailModel
    _xjTopView.xjTpoicStatisticModel = _xjTopicStatisticModel;
    _xjBottomView.xjTpoicStatisticModel = _xjTopicStatisticModel;
}
#pragma  mark  ------------------  [刷新顶部]
- (void)xjRefreshTopViewInCoverView {
    [self getRequestDetailsOfTopicWithId:_xjTopicIdStr];
    [self xjGetHelpListWithCurrentPage:1 pageSize:100000000];
    [self getPVUVWithTopicIdInHTML];
    
}
- (void)xjRefreshPagesInCoverViewBottomView {
    [self getRequestDetailsOfTopicWithId:_xjTopicIdStr];
    [self xjGetHelpListWithCurrentPage:1 pageSize:100000000];
    [self getPVUVWithTopicIdInHTML];
    [self xjIsCollectionWithAction:NO];
}

#pragma  mark  ------------------  [网络请求]
//加载H5
- (void)xjRequestHTMLFiveOutURLById:(NSNumber*)xjId {
    if (!xjId) {
        return;
    }
    NSDictionary* parm = @{@"tempId":xjId};
    [FLNetTool xjRequestHtmlOUTBytempId:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the resutl of the out url==[%@]",data);
        NSString* xjStr = data[FL_NET_DATA_KEY];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self xjLoadURLWithURL:xjStr];
        });
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma  mark --- --------------------------------详情
- (void)getRequestDetailsOfTopicWithId:(NSString*)xjtopicid {
    if (!xjtopicid) {
        return;
    }
    NSDictionary* parm = @{@"topic.topicId":xjtopicid,
                           @"userType":XJ_USERTYPE_WITHTYPE,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjtopicid]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            FL_Log(@"thi si s the data of html 5=[%@]",data);
            _xjHtmlDeatilDic = data[FL_NET_DATA_KEY];
            [self returnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
            _xjTopicDeatailModel = [XJTopicDetailModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
            [self xjSetPageInfoWithModel];
            [self getPublisherInfoMationInHTMLWithId:_xjTopicDeatailModel.userId type:_xjTopicDeatailModel.userType];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma  mark --- --------------------------------参与列表
- (void)xjGetHelpListWithCurrentPage:(NSInteger)xjCurrentPage pageSize:(NSInteger)xjPageSize{
    NSDictionary* parm = @{@"participate.topicId":self.xjTopicIdStr,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"page.currentPage":[NSNumber numberWithInteger:xjCurrentPage],
                           @"page.pageSize":  [NSNumber numberWithInteger:xjPageSize]
                           };
    [FLNetTool HTMLfindParticipateListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in search help list in html =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _xjPartInTotal= [data[@"total"] integerValue];
            if (_xjPartInTotal!=0) {
                NSArray* xjArr = [XJTopicPartInModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
                [self xjSetPartInCommenListAvatar:xjArr];
                [self.xjTopView xjSet_total_numerInTopCoverView:_xjPartInTotal];
            }
        }
    } failure:^(NSError *error) {
        FL_Log(@"erroe with help list ====%@",error);
    }];
}
#pragma  mark --- -------------------------------- 统计
- (void)getPVUVWithTopicIdInHTML {
    
    [FLFinalNetTool flNewPVUVlWithTopicId:self.xjTopicIdStr success:^(NSDictionary *data) {
        FL_Log(@"data in html with PVUV listwith type 0 =%@",data);
        [self xjSetModel:data[FL_NET_DATA_KEY]];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)xjSetModel:(NSDictionary*)xjDic{
    
    _xjTopicStatisticModel = [[XJTopicStatisticModel alloc]init];
    _xjTopicStatisticModel.pv = [xjDic[@"pv"] integerValue];
    _xjTopicStatisticModel.transformNum = [xjDic[@"transformNum"] integerValue];
    _xjTopicStatisticModel.collentionNum = [xjDic[@"collentionNum"] integerValue];
    _xjTopicStatisticModel.receiveNum = [xjDic[@"receiveNum"] integerValue];
    _xjTopicStatisticModel.commentNum = [xjDic[@"commentNum"] integerValue];
    [self xjSetStatisticNumber];
}
#pragma  mark --- -------------------------------- 发布者热度
- (void)getPublisherInfoMationInHTMLWithId:(NSString*)xjUserId type:(NSString*)xjUserType {
    NSDictionary* parm = @{@"topic.userId":xjUserId,
                           @"topic.userType":xjUserType
                           };
    NSMutableDictionary* xjxj = parm.mutableCopy;
    if ( [_xjTopicDeatailModel.userId integerValue] ==[XJ_USERID_WITHTYPE integerValue]) {
        [xjxj setObject:@"" forKey:@"topic.checkUserId"];
    } else {
        [xjxj setObject:[NSString stringWithFormat:@"%@",_xjTopicDeatailModel.userId] forKey:@"topic.checkUserId"];
    }
    parm = xjxj.mutableCopy;
    [FLNetTool flHTMLGetPublisherMessageByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my test nothis thing=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self.xjBottomView xjSetPublisherInfoWithIssueNumber:[data[@"num"] integerValue] hotNum:[data[@"pvNum"] integerValue]];
        }
    } failure:^(NSError *error) {
        FL_Log(@"this is my test nothis thing=%@",error);
    }];
}


#pragma  mark --- -------------------------------- [入口]

- (void)setXjTopicIdStr:(NSString *)xjTopicIdStr {
    _xjTopicIdStr = xjTopicIdStr;
    if (!xjTopicIdStr && [xjTopicIdStr isEqualToString:@""]) {
        return ;
    }
    [self xjRefreshTopViewInCoverView];
}


- (void)xjLoadURLWithURL:(NSString*)xjURL {
    NSURLRequest* xjRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:xjURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [self.xjWebView loadRequest:xjRequest];
    [self xjCheckIsFriendOrNot];
    [self xjIsCollectionWithAction:NO];
    [self xjCheckTakeOrNot];
    [self xjCheckIsHasPutMessage];//是否需要回填信息
    
}

- (void)xjClickToShowDeatil {
    _xj_Click_Click = !_xj_Click_Click;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self xjShowTopAndBottomWithBool:_xj_Click_Click];
    });
    
    //    [self xjRefreshTopViewInCoverView];
    //    [self xjRefreshPagesInCoverViewBottomView];
    FL_Log(@"this is the cli ck = [%d]----[%d]",_xj_Click_Click,!_xj_Click_Click);
    if (_xj_Click_Click) {
        if (!_xjTopicDeatailModel || !_xjTopicStatisticModel) {
            [self xjRefreshTopViewInCoverView];
            [self xjRefreshPagesInCoverViewBottomView];
        }
    }
    
}

- (void)xjClickBtnToPushBackInCoverView {
    [self xjClickToGoBack];
}

- (void)xjClickToGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)xjShowTopAndBottomWithBool:(BOOL)xjShow {
    if (xjShow) {
        [self xjShowTop];
        [self xjShowBottom];
    } else {
        [self xjHideTop];
        [self xjHideBottom];
    }
    [_xjCoverImageView setHidden:!xjShow];
    [xjBackBtn setHidden:xjShow];
}

#pragma  mark --- -------------------------------- [是否好友]
- (void)xjCheckIsFriendOrNot {
    NSDictionary* parm = @{@"imOwerName":[NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE],
                           @"imFriendName":[NSString stringWithFormat:@"%@_%@",_xjTopicDeatailModel.userType,_xjTopicDeatailModel.userId]};
    [FLNetTool xjCheckIsFriendsByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"thi4s is the result to check friend=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if ([data[FL_NET_DATA_KEY]boolValue]) {
                [self.xjBottomView xjSet_is_friendInCoverBottom:YES];
            } else {
                [self.xjBottomView xjSet_is_friendInCoverBottom:NO];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma  mark --- -------------------------------- [添加&删除好友]

- (void)xjClickBtnToCarePublisherInCoverViewWithuserId:(NSString *)xjUserId type:(NSString *)xjType {
    [self xjCheckForDeleteOrAddIsFriendOrNot];
}
- (void)xjCheckForDeleteOrAddIsFriendOrNot {
    NSDictionary* parm = @{@"imOwerName":[NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE],
                           @"imFriendName":[NSString stringWithFormat:@"%@_%@",_xjTopicDeatailModel.userType,_xjTopicDeatailModel.userId]};
    [FLNetTool xjCheckIsFriendsByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"thfis is the result to check friend=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if ([data[FL_NET_DATA_KEY]boolValue]) {
                [self xjDelegateFriendWithID:_xjTopicDeatailModel.userId type:_xjTopicDeatailModel.userType];
            } else {
                [self xjADDFriendWithID:_xjTopicDeatailModel.userId type:_xjTopicDeatailModel.userType];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjDelegateFriendWithID:(NSString *)xjUserId type:(NSString *)xjType {
    EMError *error;
    NSString* xjStr = [NSString stringWithFormat:@"%@_%@",xjType,xjUserId];
    [[EaseMob sharedInstance].chatManager removeBuddy:xjStr removeFromRemote:YES error:&error];
    [self hideHud];
    if (error) {
        [self showHint:@"取消关注失败"];
        [self.xjBottomView xjSet_is_friendInCoverBottom:YES];
    }
    else{
        [self showHint:@"取消关注成功"];
        [self.xjBottomView xjSet_is_friendInCoverBottom:NO];
        if ([_xjTopicDeatailModel.topicConditionKey isEqualToString:FLFLXJSquareIssueCarePick]) {
            [self xjCheckTakeOrNot];//是关注领 则重新查询领取资格
        }
    }
}
- (void)xjADDFriendWithID:(NSString *)xjUserId type:(NSString *)xjType {
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    NSDictionary* parm = @{@"owerName":[NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE],
                           @"friendName":[NSString stringWithFormat:@"%@_%@",xjType,xjUserId]};
    [FLNetTool xjAddFriendsByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the res4ult to add friend=%@",data);
        NSDictionary* xjDic = data[FL_NET_DATA_KEY];
        if ([data[FL_NET_KEY_NEW] boolValue] && [xjDic[@"statusCode"] integerValue]==200) {
            [FLTool showWith:@"关注成功"];
            [self.xjBottomView xjSet_is_friendInCoverBottom:YES];
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjCallJSInCoverViewBottomViewWithType:(HFivePushStyle)xjType {
    switch (xjType) {
        case HFivePushStyleJudgeList: {
            XJHFiveCallLocationJsController* xjPush = [[XJHFiveCallLocationJsController alloc] initWithTopicId:_xjTopicIdStr?_xjTopicIdStr:@""];
            xjPush.xjPushStyle = HFivePushStyleJudgeList;
            [self.navigationController pushViewController:xjPush animated:YES];
        }
            break;
        case HFivePushStyleRelay: {
            [self showMenu];
        }
            break;
        case HFivePushStyleCollectoin: {
            [self xjIsCollectionWithAction:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark popMenu
- (void)showMenu
{
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
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
            FL_Log(@"Pho1to selected= %ld",i);
            [weakSelf shareToWithType:typeArray[i]];
        }];
    }
    
     [self xj_getPlanByTopicId];//请求转发策略
    [_menuView show];
    //插入转发记录
    if (![_xjTopicDeatailModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
        [self flRelayTopicWithNoTypeInHTMLVC];
    } else {
        [self FLFLHTMLInsertParticipate]; //插入参与记录
    }
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
        
        NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=%ld&perUserId=%@&topic.userId=%@&topic.tempId=%ld",FLBaseUrl,XJ_TRANS_HTML5,_xjTopicIdStr,xjType,FL_USERDEFAULTS_USERID_NEW,_xjTopicDeatailModel.userId,_xjTopicDeatailModel.tempId];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@", [XJFinalTool xjReturnImageURLWithStr:_xjTopicDeatailModel.thumbnail isSite:NO]]];
        [UMSocialData defaultData].extConfig.title = _xjTopicDeatailModel.topicTheme;
        
        if (self.xjSharePlanModel.planType) {
            //转发策略
            [UMSocialData defaultData].extConfig.title  = [self xj_return_sharePlan];
            if (self.xjSharePlanModel.planType==6) {
                NSString* xjjjj = [NSString stringWithFormat:@"%@%@",[self xj_return_sharePlan],_xjTopicDeatailModel.topicTheme];
                [UMSocialData defaultData].extConfig.title  = xjjjj;
            }
        }
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qqData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [UMSocialData defaultData].urlResource;
        
        //        NSString* xjTopicExpline = [NSString stringWithFormat:@"使用说明:%@",_xjTopicDeatailModel.topicExplain?_xjTopicDeatailModel.topicExplain: @"无"];
        NSString* xjTopicExpline =  @"我在这里发现了免费的好东东，来一起玩耍吧，嘎嘎~";
        if (self.xjSharePlanModel.remark) {
            xjTopicExpline = self.xjSharePlanModel.remark;
        }
        NSString* xjweiboStr= @"";
        if (xjType == 5) {
            xjweiboStr = [NSString stringWithFormat:@"%@%@",_xjTopicDeatailModel.topicTheme,xjRelayContentStr];
            if (self.xjSharePlanModel.planType==6) {
                NSString* xjjjj = [NSString stringWithFormat:@"%@%@%@",[self xj_return_sharePlan],_xjTopicDeatailModel.topicTheme,xjRelayContentStr];
                xjweiboStr  = xjjjj;
            }
        }
        
        FL_Log(@"dadsad=[%@],,,,,,=[%@]",[UMSocialData defaultData].urlResource.url,[NSString stringWithFormat:@"%@",xjType==5 ? xjweiboStr: xjTopicExpline]);
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:[NSString stringWithFormat:@"%@",xjType==5 ? xjweiboStr: xjTopicExpline] image:nil location:nil urlResource:[UMSocialData defaultData].urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                FL_Log(@"分享成功！");
            }
        }];
    }
}

- (void)xjIsCollectionWithAction:(BOOL)xjChangeState {
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"topicId":self.xjTopicIdStr ? self.xjTopicIdStr :@""};
    [FLNetTool flIscollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is my test with is collection =%@",dic);
        if ([dic[@"success"] boolValue]) {
            [self.xjBottomView xjSet_is_CollectionInCoverBottom:YES];
            if (xjChangeState) {
                [self xjRemoveCollectionToMine];
            }
        } else {
            [self.xjBottomView xjSet_is_CollectionInCoverBottom:NO];
            if (xjChangeState) {
                [self xjAddCollectionToMine];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)xjAddCollectionToMine {
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    //添加收藏
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"topicId":self.xjTopicIdStr?self.xjTopicIdStr:@"",
                           @"userId":FL_USERDEFAULTS_USERID_NEW};
    [FLNetTool flAddcollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is add collection result=%@",dic);
        if ([dic[@"success"] boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",dic[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            //            [self.xjBottomView xjSet_is_CollectionInCoverBottom:YES];
            [self xjRefreshTopViewInCoverView];
            [self xjRefreshPagesInCoverViewBottomView];
        } else {
            FL_Log(@"未知？？错误");
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)xjRemoveCollectionToMine {
    NSDictionary* parm1 =@{@"token":XJ_USER_SESSION,
                           @"userFavonites.userId":FL_USERDEFAULTS_USERID_NEW,
                           @"userFavonites.topicId":self.xjTopicIdStr?self.xjTopicIdStr:@""};
    [FLNetTool flquitecollectionTopicBackByParm:parm1 success:^(NSDictionary *dic) {
        FL_Log(@"this is quit collection result=%@",dic);
        if ([dic[@"success"] boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:@"取消收藏成功" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            //            [self.xjBottomView xjSet_is_CollectionInCoverBottom:NO];
            [self xjRefreshTopViewInCoverView];
            [self xjRefreshPagesInCoverViewBottomView];
        } else {
            FL_Log(@"未知错误？？");
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma  mark --- -------------------------------- [查看领取资格]
- (void)xjCheckTakeOrNot {
    NSDictionary* parm = @{@"participate.topicId": self.xjTopicIdStr?self.xjTopicIdStr:@"",
                           @"participate.userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FL_USERDEFAULTS_USERID_NEW};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in check h5 pick topic =%@",data);
        if (data) {
            XJQualificationModel* xjModel = [XJQualificationModel mj_objectWithKeyValues:data];
            self.xjBottomView.xjQualificationModel = xjModel;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma  mark --- -------------------------------- [view]
- (void)xjShowTop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.xjTopView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, 150);
        }];
    });
}
- (void)xjHideTop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.xjTopView.frame = CGRectMake(0, -150, FLUISCREENBOUNDS.width, 150);
        }];
    });
}
- (void)xjShowBottom {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.xjBottomView.frame = CGRectMake(0, FLUISCREENBOUNDS.height -200, FLUISCREENBOUNDS.width, 200);
        }];
    });
}
- (void)xjHideBottom {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.xjBottomView.frame = CGRectMake(0, FLUISCREENBOUNDS.height, FLUISCREENBOUNDS.width, 200);
        }];
    });
}
#pragma  mark --- -------------------------------- 不同情况下的点击事件
- (void)xjClickBtnToParInTopicInCoverView:(XJPartInClickType)xjClickType {
    if (xjClickType == XJPartInClickTypeb1) {
        
    } else if (xjClickType == XJPartInClickTypeb2) {
        FLBlindWithThirdTableViewController* xjBlind = [[FLBlindWithThirdTableViewController alloc] init];
        [self.navigationController pushViewController:xjBlind animated:YES];
    } else if (xjClickType == XJPartInClickTypeb1) {
        
    } else if (xjClickType == XJPartInClickTypeb4) {
        
    } else if (xjClickType == XJPartInClickTypeb5) {
        [FLTool showWith:@"哎呀来晚啦，下次要早点儿哦~"];
    } else if (xjClickType == XJPartInClickTypeb6) {
        [FLTool showWith:@"哎呀来晚啦，下次要早点儿哦~"];
    } else if (xjClickType == XJPartInClickTypeb7) {
        [FLTool showWith:@"请耐心等待表捉急哦~"];
    } else if (xjClickType == XJPartInClickTypeb8) {
        [FLTool showWith:@"哎呀来晚啦，下次要早点儿哦~"];
    } else if (xjClickType == XJPartInClickTypeb9) {
        [FLTool showWith:@"哎呀来晚啦，下次要早点儿哦~"];
        //立即参与
    } else if (xjClickType == XJPartInClickTypeb10) {
        [FLTool showWith:@"呃，你已经领取过了呢不要太贪心哦~"];
    } else if (xjClickType == XJPartInClickTypeb11) {
        [self xjTakeTicketsNowWithInfo:_flPartInfoListArray==nil?NO:YES];
    } else if (xjClickType == XJPartInClickTypeb12) {
        [FLTool showWith:@"正在为你关注TA，马上可以领取啦~"];
        [self xjADDFriendWithID:_xjTopicDeatailModel.userId type:_xjTopicDeatailModel.userType];//关注
        [self FLFLHTMLInsertParticipate];//插入参与记录
    } else if (xjClickType == XJPartInClickTypeb13) {
        [FLTool showWith:@"呵呵，今天已经到上限了呢，明天早点儿来哦~"];
    } else if (xjClickType == XJPartInClickTypeb14) {
        [self xjClickToStartRelayPage];//调起转发
        //        [self FLFLHTMLInsertParticipate];//插入 参与记录
    } else if (xjClickType == XJPartInClickTypeb15) {
        //        [self xjTakeTicketsWithOutInfo]; //领取
        [self xjTakeTicketsNowWithInfo:_flPartInfoListArray==nil?NO:YES];
    } else if (xjClickType == XJPartInClickTypeb16) {
        _xj_is_help_and_first = YES;
        [self xjClickToStartRelayPage];//调起转发
        [self FLFLHTMLInsertParticipate];//插入 参与记录
    } else if (xjClickType == XJPartInClickTypeb17) {
        _xj_is_help_and_first = NO;//继续发起助力&转发
        [self xjClickToStartRelayPage];//调起转发
    } else if (xjClickType == XJPartInClickTypeb18) {
        _xj_is_help_and_first = NO;//继续发起助力&转发
        [self xjClickToStartRelayPage];//调起转发
    } else if (xjClickType == XJPartInClickTypeb19) {
        _xj_is_help_and_first = NO;//继续发起助力&转发
        [self xjClickToStartRelayPage];//调起转发
    } else if (xjClickType == XJPartInClickTypeb20) {
        [FLTool showWith:@"您不在排名中，去看看其他的活动吧"];//不在排名中，不能领
    } else if (xjClickType == XJPartInClickTypeb21) {
        [FLTool showWith:@"您不在参与者范围中+，去看看其他的活动吧"];//不在领取范围中，不能领
    } else if (xjClickType == XJPartInClickTypeb22) {
        [FLTool showWith:@"您好，您不是发布者好友，不能领取"];//非好友不能领
    }
    
}

#pragma  mark --- --------------------------------  是否需要填写领取信息
- (void)xjCheckIsHasPutMessage {
    if (![XJFinalTool xjStringSafe:_xjTopicDeatailModel.partInfo]) {
        _flPartInfoListArray = nil;
        return;
    }
    NSDictionary* parm =@{@"topic.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"topic.partInfo":_xjTopicDeatailModel.partInfo};
    [FLNetTool HTMLGetPartInfoListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"get partinfo success =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _flPartInfoListArray = @[data];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjTakeTicketsNowWithInfo:(BOOL)isInfo {
    if (!isInfo) {
        if (![_xjTopicDeatailModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
            [self FLFLHTMLInsertParticipate];//插入 参与记录
        }
        [self xjTakeTicketsWithOutInfo];  //直接领取
    } else {
        XJHFiveCallLocationJsController* xjf = [[XJHFiveCallLocationJsController alloc] init];
        xjf.xjPushStyle = HFivePushStylePutInfoForTake;
        xjf.xjTopicIdStr = _xjTopicIdStr ? _xjTopicIdStr :@"";
        xjf.xjPartInfoArr = _flPartInfoListArray;
        xjf.xjTopicDeatailModel = _xjTopicDeatailModel;
        xjf.flmyReceiveMineModel = _flmyReceiveMineModel;
        [self.navigationController pushViewController:xjf animated:YES];
    }
}
#pragma  mark --- --------------------------------插入领取记录
- (void)xjTakeTicketsWithOutInfo{
    if (_flPartInfoListArray) {
        return;
    }
    NSDictionary* parm = @{@"participateDetailes.topicId":self.xjTopicIdStr,
                           @"participateDetailes.userId": FL_USERDEFAULTS_USERID_NEW,
                           @"participateDetailes.userType":FLFLXJUserTypePersonStrKey,
                           @"participateDetailes.creator":FL_USERDEFAULTS_USERID_NEW,//FL_USERDEFAULTS_USERID_NEW,
                           @"token":FL_ALL_SESSIONID};
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"notifation wisth SAVE clickon = %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [FLTool showWith:@"领取成功"];
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            //跳到票券页
            XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
            ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
            //            [self presentViewController:ticketVC animated:YES completion:nil];
            FL_Log(@"this is teh action to push the page of ticke3t");
            [self.navigationController pushViewController:ticketVC animated:YES];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
    }];
}
#pragma  mark --- --------------------------------点击头像跳转
- (void)xjPushPubilisherPageViewWithType:(BOOL)xjIsComp {
    
    if (xjIsComp) {
        XJCheckPublisherBusViewController* xjBus = [[XJCheckPublisherBusViewController alloc] initWithUserId:_xjTopicDeatailModel.userId];
        [self.navigationController pushViewController:xjBus animated:YES];
    } else {
        XJCheckPublisherViewController* xjPer = [[XJCheckPublisherViewController alloc] initWithUserId:_xjTopicDeatailModel.userId];
        [self.navigationController pushViewController:xjPer animated:YES];
    }
}
#pragma  mark --- --------------------------------点击跳转参与列表& 助力抢列表ƒƒ
- (void)xjClickTopViewPartInListToPushHtml:(BOOL)xjIsHelp{
    XJHFiveCallLocationJsController* xjPush = [[XJHFiveCallLocationJsController alloc] initWithTopicId:_xjTopicIdStr ? _xjTopicIdStr :@""];
    xjPush.xjPushStyle = xjIsHelp ? HFivePushStyleHelpList: HFivePushStylePartInList;
    [self.navigationController pushViewController:xjPush animated:YES];
}
#pragma  mark --- --------------------------------调起转发
- (void)xjClickToStartRelayPage {
    if ([_xjTopicDeatailModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
        [self flRelayTopicWithNoTypeInHTMLVC]; //添加转发记录
        XJZhuLQShareViewController * xjZLQVC = [[XJZhuLQShareViewController alloc] initWithNibName:@"XJZhuLQShareViewController" bundle:nil];
        xjZLQVC.xjTopicId = _xjTopicIdStr;
        xjZLQVC.xjTopicDic = _xjHtmlDeatilDic;
        xjZLQVC.xjstr = _xj_is_help_and_first ? @"恭喜您参与成功":@"";
        FL_Log(@"this is teh action to push the page of tzhuli");
        [self.navigationController pushViewController:xjZLQVC animated:YES];
        
    } else {
        [self showMenu];
    }
    
    //    if ([self.xjNeedModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
    //               return;
    //    } else {
    //        [self showMenu];
    //    }
}
#pragma  mark --- --------------------------------插入参与记录
- (void)FLFLHTMLInsertParticipate
{
    FL_Log(@"点击插入参与记录");
    NSDictionary* parm =@{@"participate.topicId":_xjTopicIdStr,
                          @"participate.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"participate.userType":FLFLXJUserTypePersonStrKey,   //商家不可以点击领取
                          @"participate.creator":FL_USERDEFAULTS_USERID_NEW};   //个人领取永远是个人id
    [FLNetTool HTMLinsertParticipateInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"点击插入2参与记录成功= %@",data);
        [self xjGetHelpListWithCurrentPage:1 pageSize:10000000000]; //头像 xjGetHelpListWithCurrentPage
        [self xjCheckTakeOrNot]; //获取领取资格
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ---------------- 插入转发记录
- (void)flRelayTopicWithNoTypeInHTMLVC
{
    if ([_xjTopicDeatailModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
        return;
    }
    NSDictionary* parm = @{@"topic.userType":_xjTopicDeatailModel.userType,
                           @"topic.userId": _xjTopicDeatailModel.userId,
                           @"topic.topicId":_xjTopicIdStr,
                           @"topic.topicType":_xjTopicDeatailModel.topicType,
                           @"token":XJ_USER_SESSION};
    [FLNetTool flPubTopicShareFriendAnyTypeByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is to sahre test =%@",data);
        [self getPVUVWithTopicIdInHTML];
    } failure:^(NSError *error) {
        
    }];
}

- (void)xj_getPlanByTopicId {
    [FLNetTool xj_getPlanByTopicId:_xjTopicIdStr success:^(NSDictionary *data) {
        FL_Log(@"this is the result of relay paln===[%@]",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjSharePlanModel = [XJShareContentModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma  mark --- --------------------------------举报
- (void)xjClickTopViewJBToPushHtml {
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    __weak typeof(self) weakSelf = self;
    UIAlertController* flAlertSecondVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        FL_Log(@"cancle in second.");
    }];
    UIAlertAction* flJBAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        FL_Log(@"cancle in second.");
        XJHFiveCallLocationJsController* xjF = [[XJHFiveCallLocationJsController alloc] initWithTopicId:_xjTopicIdStr?_xjTopicIdStr:@""];
        xjF.xjPushStyle =  HFivePushStylePartInJBPage;
        [weakSelf.navigationController pushViewController:xjF animated:YES];
    }];
    
    [flAlertSecondVC addAction:flCancleAction];
    [flAlertSecondVC addAction:flJBAction];
    [weakSelf presentViewController:flAlertSecondVC animated:YES completion:nil];
}

#pragma  mark --- --------------------------------妈的没什么用
- (void)returnModelForTicketsWithData:(NSDictionary*)data {
    self.flmyReceiveMineModel.flIntroduceStr = data[@"topicExplain"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = data[@"topicId"];
    self.flmyReceiveMineModel.xjCreator = [data[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [data[@"userId"] integerValue];
    self.flmyReceiveMineModel.flTimeBegan = data[@"startTime"];
    self.flmyReceiveMineModel.xjinvalidTime = data[@"invalidTime"];
    self.flmyReceiveMineModel.xjUrl = data[@"url"];
    self.flmyReceiveMineModel.xjUserType = data[@"userType"];
}
- (NSString* )xj_return_sharePlan {
    NSString* xjName = [[XJUserAccountTool share] xj_getUserName];
    NSString* xjPuser = _xjTopicDeatailModel.nickName;
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

@end













