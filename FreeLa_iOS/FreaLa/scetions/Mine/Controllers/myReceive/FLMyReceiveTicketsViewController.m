//
//  FLMyReceiveTicketsViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyReceiveTicketsViewController.h"
#import "XJTicketNumberModel.h"
#import "XJMyTicketView.h"
#import "XJFreelaUVManager.h"

@interface FLMyReceiveTicketsViewController ()<XJMyTicketViewDelegate>
/**票券页*/
@property (nonatomic , strong) FLMyReceiveTicketView* flMyTicketView;

@property (nonatomic , strong) UIScrollView* xjScrollView;

@property (nonatomic , strong) XJTicketNumberModel* xjTicketNumberModel;
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;


@property (nonatomic , strong) XJMyTicketView* xjMyTicketView;

/**我的信息*/
@property (nonatomic  , strong) FLMineInfoModel* flMineInfoModel;
@end

@implementation FLMyReceiveTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"票券";
    [self getIssueInfoDataWithTopicId:_xjTioicId];  //获取详情
    [self xjGetPersonalInfo];//获取个人数据
    [self creatrUIInReceiveTicketsVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if(!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc]init];
    }
    return _flmyReceiveMineModel;
}
- (XJMyTicketView *)xjMyTicketView {
    if (!_xjMyTicketView) {
        _xjMyTicketView = [[XJMyTicketView alloc] initWithUserId:nil];
    }
    return _xjMyTicketView;
}
- (FLMyReceiveTicketView *)flMyTicketView {
    if (!_flMyTicketView) {
        _flMyTicketView = [[FLMyReceiveTicketView alloc] initWithFrame:self.xjScrollView.frame];
    }
    return _flMyTicketView;
}

- (UIScrollView *)xjScrollView {
    if (!_xjScrollView) {
        _xjScrollView  = [[UIScrollView alloc] init];
        self.xjScrollView.frame = CGRectMake(0, FL_TopColumnView_Height_S + StatusBar_NaviHeight, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - FL_TopColumnView_Height);
    }
    return _xjScrollView;
}

- (FLMineInfoModel *)flMineInfoModel {
    if (!_flMineInfoModel) {
        _flMineInfoModel = [[FLMineInfoModel alloc] init];
    }
    return _flMineInfoModel;
}


#pragma mark UI
- (void)creatrUIInReceiveTicketsVC
{
    
 
    [self.view addSubview:self.xjScrollView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
 
    self.flMyTicketView.flMyReceiveInMineModel = self.flmyReceiveMineModel;
 
    [self.flMyTicketView.xjUseBtn addTarget:self action:@selector(testUserTickets) forControlEvents:UIControlEventTouchUpInside];
    
    //test
    
//    [self.xjScrollView addSubview:self.flMyTicketView]; //打开此句变为之前
//    self.xjMyTicketView.frame = CGRectMake(20, 20, FLUISCREENBOUNDS.width-40, FLUISCREENBOUNDS.height + 170);
//    self.xjScrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width,  self.xjMyTicketView.frame.size.height +100);
    self.xjMyTicketView.delegate = self;
    
//    [self.xjScrollView addSubview:self.xjMyTicketView];
   
    
    
    self.xjScrollView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjRefreshState)];
//    self.xjScrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width,  self.flMyTicketView.flBaseImageView.frame.size.height +100); //打开此句变为之前
    
    
 
    if ( _flmyReceiveMineModel.xjUrl.length!=0) {
        FL_Log(@"ticket has already used");
        self.flMyTicketView.xjUseBtn.hidden = NO;
    } else {
        FL_Log(@"ticket has not  already used");
        self.flMyTicketView.xjUseBtn.hidden = YES;
    }
    [self xjRefreshState];
}

- (void)xjClickUsrNoewInMyTicketView {
    [self testUserTickets];
}

- (void)testUserTickets
{
   
    NSInteger flstate = _flmyReceiveMineModel.flStateInt;
    if (flstate !=1 ) {
        //这里是扫码接口
        NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                               @"participateDetailes.detailsid":_xjDetailsId,
                               @"participateDetailes.topicId":_xjTioicId,
                               @"participateDetailes.userId":[NSNumber numberWithInteger:self.flmyReceiveMineModel.xjUserId],
                               @"participateDetailes.creator":[NSNumber numberWithInteger:self.flmyReceiveMineModel.xjCreator],
                               @"participateDetailes.userType":self.flmyReceiveMineModel.xjUserType,
                               @"participateDetailes.checkUser":@""
                               };
        [FLNetTool fluseDetailesByIDWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"thisi is my test useticket =%@",data);
            if ([data[FL_NET_KEY_NEW] boolValue]) {
                [[FLAppDelegate share] showHUDWithTitile:@"使用成功" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                _flmyReceiveMineModel.flStateInt = 1;
                [self creatrUIInReceiveTicketsVC];
            } else {
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            }
        } failure:^(NSError *error) {
            
        }];

    }
       //跳转至url
    NSString* ss = [_flmyReceiveMineModel.xjUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:ss];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
    
}

- (void)xjRefreshState{
    [self xjGetTicketNum];
    [self xjGetTopicState];
    [self getIssueInfoDataWithTopicId:_xjTioicId];  //获取详情
}
- (void)xjGetTopicState{
    if(!_xjDetailsId){
      return;
    }
    FL_Log(@"this is the function for scrollview");
    NSDictionary* parm = @{@"participateDetailes.detailsid":_xjDetailsId};
    [FLNetTool xjgetParticipateDetailesByIdWithParma:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is the function for balabala ==%@",dic);
        if ([dic[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* data = dic[@"data"];
            _flmyReceiveMineModel.flStateInt = [data[@"state"] integerValue];
            _flmyReceiveMineModel.xjUseTime = data[@"useTime"] ;
            _flmyReceiveMineModel.flDetailsIdStr = [data[@"detailsid"] stringValue];
            _flmyReceiveMineModel.createTime = data[@"createTime"];
            [self xjSetTicketStateWithState:_flmyReceiveMineModel.flStateInt];
        }
        [self xjEndRefresh];
    } failure:^(NSError *error) {
        [self xjEndRefresh];
    }];
}

- (void)xjGetTicketNum {
    if (!_xjDetailsId || !_xjTioicId ) {
        return;
    }
    NSDictionary* parm = @{@"topicId":_xjTioicId,
                           @"detailsId":_xjDetailsId,
                           @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool xjGetTicketNumber:parm success:^(NSDictionary *data) {
        FL_Log(@"this istthe ticket number =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjTicketNumberModel = [XJTicketNumberModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
            self.flMyTicketView.xjTicketNumberModel = self.xjTicketNumberModel;
            self.xjMyTicketView.xjTicketNumberModel = self.xjTicketNumberModel;
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)xjEndRefresh {
    [self.xjScrollView.mj_header endRefreshing];
}

- (void)xjSetTicketStateWithState:(NSInteger)xjstate {
//    if (xjstate != 1 ) {
        FL_Log(@"ticket has already used");
        if (_flmyReceiveMineModel.xjUrl.length!=0) {
            self.flMyTicketView.xjUseBtn.hidden = NO;
//        }
    } else {
        FL_Log(@"ticket has not  already used");
        self.flMyTicketView.xjUseBtn.hidden = YES;
    }
    self.flMyTicketView.flMyReceiveInMineModel = _flmyReceiveMineModel;
}

- (void)xjRefreshViewFrameWithTickHeight:(CGFloat)xjTicketFloatH {
    self.xjMyTicketView.frame = CGRectMake(20, 20, FLUISCREENBOUNDS.width-40, xjTicketFloatH);
    self.xjScrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width,  xjTicketFloatH + FL_TopColumnView_Height + 40);
    [self.xjScrollView addSubview:self.xjMyTicketView];
}

#pragma  mark 请求数据
- (void)xjGetPersonalInfo {
    NSDictionary* parm  = @{@"token":FL_ALL_SESSIONID,
                            @"accountType":@"per",
                            };
    FL_Log(@"see info 新 in mine :sess222sionId = %@  parm = %@",FL_ALL_SESSIONID,parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is see info in 我领取的 page =%@",data);
//        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flMineInfoModel = [FLMineInfoModel mj_objectWithKeyValues:data];
            self.flMyTicketView.flMineInfoModel = self.flMineInfoModel;
        self.xjMyTicketView.xjMineInfoModel = self.flMineInfoModel;
//        }
    } failure:^(NSError *error) {
        
    }];
}

//我领取的
- (void)getIssueInfoDataWithTopicId:(NSString*)xjTopicId{
    NSDictionary* parm = @{@"topic.topicId": xjTopicId,
                           @"userType":XJ_USERTYPE_WITHTYPE,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjTopicId]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"test detail with with =%@",data);
           [self xjMaDanWithDic:data[FL_NET_DATA_KEY]];
//        self.flMyReceiveBaseView.flMyReceiveInMineModel = self.flmyReceiveMineModel;
        [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjTopicId];

    } failure:^(NSError *error) {
        
    }];
}

- (void)xjMaDanWithDic:(NSDictionary*)dic  {
    self.flmyReceiveMineModel.flMineIssueBackGroundImageStr =  [FLTool returnBigPhotoURLWithStr:dic[@"thumbnail"] ];//  dic[@"thumbnail"];
    self.flmyReceiveMineModel.flMineIssueDayStr    = [FLMineTools returnDateStrWithDateStr:dic[@"createTime"] ForType:1];
    self.flmyReceiveMineModel.flMineIssueMonthStr  = [FLMineTools returnDateStrWithDateStr:dic[@"createTime"] ForType:2];
    self.flmyReceiveMineModel.flMineIssueNumbersAlreadyPickStr = [dic[@"receiveNum"] stringValue];
    self.flmyReceiveMineModel.flMineIssueNumbersReadStr = [dic[@"pv"] stringValue];
    self.flmyReceiveMineModel.flMineIssueNumbersRelayStr = [dic[@"transformNum"]stringValue ];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr =  dic[@"topicId"];
    self.flmyReceiveMineModel.flMineIssueNumbersTotalPickStr = dic[@"topicNum"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = dic[@"topicId"];
    self.flmyReceiveMineModel.flMineIssueNumbersJudgeStr = [dic[@"commentCount"] stringValue];
    self.flmyReceiveMineModel.flMineTopicThemStr = dic[@"topicTheme"];
    self.flmyReceiveMineModel.flTimeBegan = dic[@"createTime"];
    self.flmyReceiveMineModel.flTimeEnd   = dic[@"endTime"];
    self.flmyReceiveMineModel.flTimeService = dic[@"newDate"];
    self.flmyReceiveMineModel.flMineIssueTopicConditionStr = dic[@"topicCondition"];
    CGFloat ff = [self.flmyReceiveMineModel.flMineIssueNumbersAlreadyPickStr floatValue] / [self.flmyReceiveMineModel.flMineIssueNumbersTotalPickStr floatValue];
    self.flmyReceiveMineModel.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
    self.flmyReceiveMineModel.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
    self.flmyReceiveMineModel.flMineTopicAddressStr = dic[@"address"];
    self.flmyReceiveMineModel.flIntroduceStr = dic[@"topicExplain"];
//    self.flmyReceiveMineModel.flDetailsIdStr = dic[@"detailsid"];
//    self.flmyReceiveMineModel.flStateInt = [dic[@"state"] integerValue];
    self.flmyReceiveMineModel.xjCreator = [dic[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [dic[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUrl = dic[@"url"];
    self.flmyReceiveMineModel.xjinvalidTime = dic[@"invalidTime"];
    self.flmyReceiveMineModel.xjUseTime = dic[@"useTime"];
    self.flmyReceiveMineModel.xjUserType = dic[@"userType"];
    self.flmyReceiveMineModel.xjTopicTagStr = dic[@"topicTag"];
    self.flmyReceiveMineModel.xjPublishName = dic[@"publishName"];
//    self.flmyReceiveMineModel.createTime = dic[@"createTime"];
    self.flMyTicketView.flMyReceiveInMineModel = self.flmyReceiveMineModel;
    self.xjMyTicketView.xjMyReceiveInMineModel = self.flmyReceiveMineModel;
}

@end
































