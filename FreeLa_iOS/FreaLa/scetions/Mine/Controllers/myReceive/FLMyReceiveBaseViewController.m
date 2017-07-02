//
//  FLMyReceiveBaseViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyReceiveBaseViewController.h"
#import "XJFreelaUVManager.h"

@interface FLMyReceiveBaseViewController ()
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;
@property (nonatomic , strong) UIScrollView* xjScrollView;

@property (nonatomic , strong)  FLMyReceiveBaseView * flMyReceiveBaseView; //UI
@end

@implementation FLMyReceiveBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xjRequestTopicInfo];
    [self xjCreatePageUI];  // 需要有了模型才可以
    [self getDetailImgesInReceiveVCAndCreateUI];
}

- (void)xjRequestTopicInfo {
    [self getIssueInfoDataWithTopicId:_xjTioicId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xjRefreshNumInMyReceive{
    if (  self.flMyReceiveBaseView.imagesURLStrings.count == 0) {
        [self getDetailImgesInReceiveVCAndCreateUI];
    }
    [self xjGetTongji];
}

- (void)xjCreatePageUI {
    //     _flMyReceiveBaseView = [[FLMyReceiveBaseView alloc] initWithModel:self.flmyReceiveMineModel];
    [self.flMyReceiveBaseView.flCheckDetailBtn addTarget:self action:@selector(goToDetailPageWithHTMLWithMyReceive) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:self.flMyReceiveBaseView];
    //scrollview
    self.xjScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _xjScrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width, self.flMyReceiveBaseView.frame.size.height);
    [self.view addSubview:_xjScrollView];
    [_xjScrollView addSubview:_flMyReceiveBaseView];
    self.xjScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjRefreshNumInMyReceive)];
    [self.xjScrollView.mj_header beginRefreshing];
}

#pragma mark get image
- (void)getDetailImgesInReceiveVCAndCreateUI
{
    NSMutableArray* muArr = [NSMutableArray array];
    [FLFinalNetTool flNewgetDetailImageStrInHTMLWithTopicId:_xjTioicId ? _xjTioicId :@"" success:^(NSDictionary *data) {
        FL_Log(@"new tool to request deteail images =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* array = data[FL_NET_DATA_KEY];
            array = [FLHelpDetailImageModels mj_objectArrayWithKeyValuesArray:array];
            for (FLHelpDetailImageModels* model in array) {
                if ([model.businesstype integerValue] == 2) {
                    [muArr addObject:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.url isSite:NO]]];
                } else if ([model.businesstype integerValue] == 1) {
                    
                }
            }
            if(muArr.count==0){
                for (FLHelpDetailImageModels* model in array) {
                    [muArr addObject:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.url isSite:NO]]];
                    
                }
            }
            
            self.flMyReceiveBaseView.imagesURLStrings = muArr;
        }
        [self xjEndRefresh];
    } failure:^(NSError *error) {
        [self xjEndRefresh];
    }];
}

- (void)xjGetTongji{
    [FLFinalNetTool flNewPVUVlWithTopicId:_xjTioicId success:^(NSDictionary *data) {
        FL_Log(@"data in html with tjs listwi2th type 0 =%@",data);
        if([data[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* dd = data[FL_NET_DATA_KEY];
            self.flmyReceiveMineModel.flMineIssueNumbersReadStr = [dd[@"pv"] isEqualToString:@""]? @"0":dd[@"pv"];
            self.flmyReceiveMineModel.flMineIssueNumbersRelayStr = [dd[@"transformNum"] isEqualToString:@""]? @"0":dd[@"transformNum"];
            self.flmyReceiveMineModel.flMineIssueNumbersAlreadyPickStr = [dd[@"receiveNum"] isEqualToString:@""]? @"0":dd[@"receiveNum"];//dd[@"receiveNum"] ? dd[@"receiveNum"] :@"0";
            CGFloat ff = [self.flmyReceiveMineModel.flMineIssueNumbersAlreadyPickStr floatValue] / [self.flmyReceiveMineModel.flMineIssueNumbersTotalPickStr floatValue];
            self.flmyReceiveMineModel.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
            self.flmyReceiveMineModel.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
        }
        [self xjEndRefresh];
    } failure:^(NSError *error) {
        [self xjEndRefresh];
    }];
    [self getIssueInfoDataWithTopicId:_xjTioicId];
}
- (void)xjEndRefresh {
    [self.xjScrollView.mj_header endRefreshing];
}


#pragma mark 详情
- (void)goToDetailPageWithHTMLWithMyReceive
{
    FL_Log(@"从这里点击进入我领取的html 界面");
    FLFuckHtmlViewController* htmlVC = [[FLFuckHtmlViewController alloc] init];
    htmlVC.flFuckTopicId = _xjTioicId ? _xjTioicId :@"";
    [self.navigationController pushViewController:htmlVC animated:YES];
}

#pragma  mark lazy loading
- (FLMyReceiveBaseView *)flMyReceiveBaseView {
    if (!_flMyReceiveBaseView) {
        _flMyReceiveBaseView = [[FLMyReceiveBaseView alloc] initWithModel:nil];
    }
    return _flMyReceiveBaseView;
}
#pragma  mark 请求数据
//我领取的
- (void)getIssueInfoDataWithTopicId:(NSString*)xjTopicId{
    if (!xjTopicId) {
        return;
    }
    NSDictionary* parm = @{@"topic.topicId": xjTopicId,
                           @"userType":XJ_USERTYPE_WITHTYPE,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjTopicId]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"test detail with 1with =%@",data);
        [self xjMaDanWithDic:data[FL_NET_DATA_KEY] WithModel:self.flmyReceiveMineModel];
         [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjTopicId];
        
    } failure:^(NSError *error) {
        
    }];
}

-  (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}

- (void)xjMaDanWithDic:(NSDictionary*)dic WithModel:(FLMyReceiveListModel*)model{
    self.flmyReceiveMineModel.flMineIssueBackGroundImageStr =  [FLTool returnBigPhotoURLWithStr:dic[@"thumbnail"] ];//  dic[@"thumbnail"];
    self.flmyReceiveMineModel.flMineIssueDayStr    = [FLMineTools returnDateStrWithDateStr:dic[@"createTime"] ForType:1];
    self.flmyReceiveMineModel.flMineIssueMonthStr  = [FLMineTools returnDateStrWithDateStr:dic[@"createTime"] ForType:2];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr =  dic[@"topicId"];
    self.flmyReceiveMineModel.flMineIssueNumbersTotalPickStr = dic[@"topicNum"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = dic[@"topicId"];
    self.flmyReceiveMineModel.flMineIssueNumbersJudgeStr = [dic[@"commentCount"] stringValue];
    self.flmyReceiveMineModel.flMineTopicThemStr = dic[@"topicTheme"];
    self.flmyReceiveMineModel.flTimeBegan = dic[@"createTime"];
    self.flmyReceiveMineModel.flTimeEnd   = dic[@"endTime"];
    self.flmyReceiveMineModel.flTimeService = dic[@"newDate"];
    self.flmyReceiveMineModel.flMineIssueTopicConditionStr = dic[@"topicCondition"];
    CGFloat ff = [model.flMineIssueNumbersAlreadyPickStr floatValue] / [model.flMineIssueNumbersTotalPickStr floatValue];
    self.flmyReceiveMineModel.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
    self.flmyReceiveMineModel.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
    self.flmyReceiveMineModel.flMineTopicAddressStr = dic[@"address"];
    self.flmyReceiveMineModel.flIntroduceStr = dic[@"topicExplain"];
    self.flmyReceiveMineModel.flDetailsIdStr = dic[@"detailsid"];
    self.flmyReceiveMineModel.flStateInt = [dic[@"state"] integerValue];
    self.flmyReceiveMineModel.xjCreator = [dic[@"publisherId"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [dic[@"publisherId"] integerValue];
    self.flmyReceiveMineModel.xjUrl = dic[@"url"];
    self.flmyReceiveMineModel.xjinvalidTime = dic[@"invalidTime"];
    self.flmyReceiveMineModel.xjUseTime = dic[@"useTime"];
    self.flmyReceiveMineModel.xjUserType = dic[@"userType"];
    self.flmyReceiveMineModel.xjTopicTagStr = dic[@"topicTag"];
    self.flmyReceiveMineModel.xjPublishName = dic[@"publishName"];
    self.flMyReceiveBaseView.flMyReceiveInMineModel = self.flmyReceiveMineModel;
}


@end
































