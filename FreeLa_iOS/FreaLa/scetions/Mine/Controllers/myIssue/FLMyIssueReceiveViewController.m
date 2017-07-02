//
//  FLMyIssueReceiveViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueReceiveViewController.h"
#import "FLMyIssueActivityPartInView.h"
#import "FLMyIssueInMineModel.h"
#import "FLGrayBaseView.h"
#import "XJCreatGroupForPickViewController.h"
#import "XJCreatGroupByChoiceView.h"
#import "CreateGroupViewController.h"
@interface FLMyIssueReceiveViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,XJCreatGroupByChoiceViewDelegate>
{
    FLMyIssueActivityPartInView * _flMyIssueActivityPartInView;
    NSInteger _fltotal;
    BOOL      _flIsAllCheck;
}

/**tableView*/
@property (nonatomic , strong) UITableView* flTableView;

/**点击列表的浮层*/
@property (nonatomic , strong) FLGrayBaseView* baseView;

/**参与列表需要的字典数组*/
@property (nonatomic , strong) NSMutableArray* flMuDicArray;

/**获取到的邮箱*/
@property (nonatomic , strong) NSString* flEmailToSend;
/**邮件的链接地址*/
@property (nonatomic , strong) NSString* flEmailContentStr;

/**我发布的模型*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmyIssueInMineModel;

/**模型数组*/
@property (nonatomic , strong) NSMutableArray* flMyTopicPartInArray;

/**cell*/
@property (nonatomic , strong) FLMyIssueReceiveTableViewCell* flcell;
@end

@implementation FLMyIssueReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBottonViewInMyIssueSecondVC];
    _flIsAllCheck = NO;
    [self creatTbleViewInMyIssueSecondVC];
    _flMyTopicPartInArray = [NSMutableArray array];
    _flMuDicArray = [NSMutableArray array];
}


- (void)creatTbleViewInMyIssueSecondVC {
    self.flTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FL_TopColumnView_Height_S + StatusBar_NaviHeight, FLUISCREENBOUNDS.width, self.view.height - TabBarHeight - FL_TopColumnView_Height_S - StatusBar_NaviHeight) style:UITableViewStyleGrouped];
    self.flTableView.delegate = self;
    self.flTableView.dataSource  =self;
    [self.view addSubview:self.flTableView];
    
    [self.flTableView registerNib:[UINib nibWithNibName:@"FLMyIssueReceiveTableViewCell" bundle:nil ] forCellReuseIdentifier:@"FLMyIssueReceiveTableViewCell"];
    
    //header  _footer
    self.flTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewReceiveList)];
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataInTableViewReceiveList)];
    self.flTableView.mj_footer = footer;
    [self.flTableView.mj_header beginRefreshing];
}

- (void)choiceReceiveListPeople
{
    FL_Log(@"test");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _flMyTopicPartInArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.flcell = [tableView dequeueReusableCellWithIdentifier:@"FLMyIssueReceiveTableViewCell" forIndexPath:indexPath];
    if (self.flcell == nil) {
        self.flcell = [[FLMyIssueReceiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FLMyIssueReceiveTableViewCell"];
    }
    if (_flMyTopicPartInArray.count == 0) {
        
    } else {
        
        FL_Log(@"崩在这3儿了啊，_flMyTopicPartInArray.count = %ld",_flMyTopicPartInArray.count);
        FLMyIssueReceiveModel* model = _flMyTopicPartInArray[indexPath.row];
        self.flcell.flnickName.text = model.nickname;
        [self.flcell.flAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.avatar]]];
        FL_Log(@"avatarin cell in my issue =%@",[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.avatar isSite:NO]]);
        self.flcell.fltimeStr.text = model.receiveTime;
        if ([model.state isEqual:@1]) {
            self.flcell.flStateStr.text = @"已使用";
        }  else if ([model.state isEqual:@0]) {
            self.flcell.flStateStr.text = @"未使用";
        }
        if (model.flIschecked) {
            [self.flcell.flStateBtn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
        } else {
            [self.flcell.flStateBtn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
        }
        
        self.flcell.flStateBtn.tag = indexPath.row;
        [self.flcell.flStateBtn addTarget:self action:@selector(testForStateBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.flcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.flcell;
}

- (void)testForStateBtn:(UIButton*)sender
{
    FLMyIssueReceiveModel* model = _flMyTopicPartInArray[sender.tag];
    model.flIschecked = !model.flIschecked;
    FL_Log(@"test for btn.sender =%ld",sender.tag);
    [self.flTableView reloadData];
}

#pragma mark ---delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FLMyIssueReceiveModel* model = _flMyTopicPartInArray[indexPath.row];
    NSDictionary* dic = _flMuDicArray[indexPath.row];
    self.baseView = [[FLGrayBaseView alloc] initWithFLMyIssueReceiveModeldelegate:self];
    self.baseView.flmodel = model;
    self.baseView.flDataDic = dic;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            [[UIApplication sharedApplication].keyWindow addSubview:self.baseView];
        }];
    });
    
}



#pragma mark ------- 用于领取列表的接口数据
- (void)getInfoForReceiveListInMineWithCurrentPage:(NSNumber*)xjCurrenPage
{
    FL_Log(@"test tolen =%@  ,bus token=%@ ====%@",FL_ALL_SESSIONID , FLFLBusSesssionID,XJ_USER_SESSION);
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"page.currentPage":xjCurrenPage,
                           @"search.topicId":_xjTopicIdStr ? _xjTopicIdStr :@"",
                           //                           @"search.userId": XJ_USERID_WITHTYPE
                           };
    [FLNetTool searchMyReceiveListByIDWithParm:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            FL_Log(@"this is my data for my receive= %@",data);
            _fltotal = [data[@"total"] integerValue];
            NSArray* dicArray = data[@"data"];
            for (NSDictionary* dic in dicArray) {
                [_flMuDicArray addObject:dic];
            }
            NSArray* avatorArr = [FLTool returnArrayWithArr:data[FL_NET_DATA_KEY]];
            NSArray* array = [FLMyIssueReceiveModel mj_objectArrayWithKeyValuesArray:avatorArr];
            [_flMyTopicPartInArray addObjectsFromArray:array];
            for (FLMyIssueReceiveModel* model in array) {
                model.flIschecked = NO;
            }
            [self.flTableView reloadData];
            FL_Log(@"'mu array  =%@",_flMyTopicPartInArray);
        }
        [self endRefreshInTableViewReceiveList];
    } failure:^(NSError *error) {
        [self endRefreshInTableViewReceiveList];
    }];
}


#pragma mark  refaresh
- (void)loadNewDataWithTableViewReceiveList {
    [self.flMyTopicPartInArray removeAllObjects];
    [self.flMuDicArray removeAllObjects];
    [self getInfoForReceiveListInMineWithCurrentPage:@1];
    FL_Log(@"'loadNewDataWithTableViewReceiveList");
}

- (void)loadMoreDataInTableViewReceiveList
{
    [self getInfoForReceiveListInMineWithCurrentPage:[FLTool xjRetuenCurrentWithArrLength:self.flMyTopicPartInArray.count andTotal:_fltotal xjSize:0]];
    FL_Log(@"'loadMoreDataInTableViewReceiveList");
}

#pragma mark endrefresh
- (void) endRefreshInTableViewReceiveList {
    [self.flTableView.mj_header endRefreshing];
    if (_fltotal == _flMyTopicPartInArray.count ) {
        [self.flTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.flTableView.mj_footer endRefreshing];
    }
    
}


- (void)creatBottonViewInMyIssueSecondVC
{
    _flMyIssueActivityPartInView = [[FLMyIssueActivityPartInView alloc] initWithData:nil];
    _flMyIssueActivityPartInView.flmyIssueInMineModel = _flmyIssueInMineModel;
    [_flMyIssueActivityPartInView.flExcleBtn addTarget:self action:@selector(testLeft) forControlEvents:UIControlEventTouchUpInside];
    [_flMyIssueActivityPartInView.flmakeGroupBtn addTarget:self action:@selector(testRight) forControlEvents:UIControlEventTouchUpInside];
    [_flMyIssueActivityPartInView.flAllChooseBtn addTarget:self action:@selector(testAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flMyIssueActivityPartInView];
    
}

#pragma mark  Actions bottom
- (void)testLeft
{
    FL_Log(@"test left");
#warning 此处需要加密
    //    UIActionSheet* flActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送到邮箱",@"复制下载链接", nil];
    //    [flActionSheet showInView:self.view];
    
    NSString *flcopyButtonTitle = NSLocalizedString(@"复制下载链接", nil);
    NSString* flSendBtnTitle    = NSLocalizedString(@"发送到邮箱", nil);
    self.flEmailContentStr = [NSString stringWithFormat:@"%@/app/receives!exportReceiveUserlist.action?&topic.topicId=%@",FLBaseUrl,[NSString stringWithFormat:@"%@",_xjTopicIdStr]];
    
    UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        FL_Log(@"The OkayCancel alert's cancel action occured.");
    }];
    UIAlertAction *flotherAction = [UIAlertAction actionWithTitle:flcopyButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        FL_Log(@"The  copy action occured.");
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = weakSelf.flEmailContentStr;
        [[FLAppDelegate share] showHUDWithTitile:@"复制成功" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
    }];
    UIAlertAction *flSendAction = [UIAlertAction actionWithTitle:flSendBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        FL_Log(@"The  alert's send action occured.");
        UIAlertController* flAlertSecondVC = [UIAlertController alertControllerWithTitle:@"请填写您的邮箱地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            FL_Log(@"cancle in second.");
        }];
        UIAlertAction* flSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            FL_Log(@"sure in second.");
            weakSelf.flEmailToSend =  flAlertSecondVC.textFields[0].text;
            FL_Log(@"this is my email address to send =%@ iiid = %@",weakSelf.flEmailToSend,weakSelf.flEmailContentStr);
            [FLFinalNetTool flNewSendEmailWithTitle:@"点击下面地址下载列表" address:weakSelf.flEmailToSend content:weakSelf.flEmailContentStr attachementArr:nil success:^(NSDictionary *data) {
                FL_Log(@"this is test send eamilin my issue vc=%@",data);
                if ([data[FL_NET_KEY_NEW] boolValue]) {
                    [[FLAppDelegate share] showHUDWithTitile:@"邮件已发送" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }];
        [flAlertSecondVC addAction:flCancleAction];
        [flAlertSecondVC addAction:flSureAction];
        
        [flAlertSecondVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            self.flEmailToSend = textField.text;
            
        }];
        [weakSelf presentViewController:flAlertSecondVC animated:YES completion:nil];
        
    }];
    
    
    [flAlertViewController addAction:flCancleAction];
    [flAlertViewController addAction:flotherAction];
    [flAlertViewController addAction:flSendAction];
    [self presentViewController:flAlertViewController animated:YES completion:nil];
    
    
}

- (void)testRight {
    FL_Log(@"test rigth");
    //这里变为要先弹出选择窗口
    XJCreatGroupByChoiceView* xjView = [[XJCreatGroupByChoiceView alloc] init];
    xjView.delegate = self;
    
    //    NSMutableArray* xjMu = @[].mutableCopy;
    //    for (FLMyIssueReceiveModel* model in _flMyTopicPartInArray) {
    //        if (model.userId) {
    //            [xjMu addObject:model.userId];
    //        }
    //    }
    //    NSArray* xjjArr = [FLTool xjReturnArrWithoutRepeat:xjMu.mutableCopy]; //数组去重
    //    XJCreatGroupForPickViewController* xjCreatVC = [[XJCreatGroupForPickViewController alloc] init];
    //    xjCreatVC.xjUserIdArr = xjjArr;
    //    [self.navigationController pushViewController:xjCreatVC animated:YES];
}

- (void)testAll
{
    FL_Log(@"test all");
    [self setAllReceiveListInfo];
    
    if (_flIsAllCheck)
    {
        for (FLMyIssueReceiveModel* model in _flMyTopicPartInArray)
        {
            model.flIschecked = NO;
            _flIsAllCheck = NO;
        }
    }
    else
    {
        for (FLMyIssueReceiveModel* model in _flMyTopicPartInArray)
        {
            model.flIschecked = YES;
            _flIsAllCheck = YES;
        }
    }
    
    [self.flTableView reloadData];
}

- (void)setAllReceiveListInfo
{
    [FLFinalNetTool flNewexportUserReceiveToExcelWithTopicId:_xjTopicIdStr
                                                     success:^(NSDictionary *data) {
                                                         FL_Log(@"this is all choice receivelist = %@",data);
                                                     } failure:^(NSError *error) {
                                                         
                                                     }];
}

#pragma  mark 推送 啊
- (void)setXjTopicIdStr:(NSString *)xjTopicIdStr {
    _xjTopicIdStr = xjTopicIdStr;
    if (xjTopicIdStr) {
        //        [self getInfoForReceiveListInMineWithCurrentPage:@1];
    }
}

#pragma  mark ---------------------------- 一件件群代理实现
- (void)xjTouchIndexRowWithIndex:(XJCreatGroupType)xjChooseType {
    switch (xjChooseType) {
        case  XJCreatGroupTypeAll:  {   //全选
            [self xjxjRequestUserIdWith:@"3"];
        }
            break;
        case  XJCreatGroupTypePickList:  {  //已领取
            [self xjxjRequestUserIdWith:@"2"];
        }
            break;
        case  XJCreatGroupTypePartWithOutPick:  {  //参与未领取
            [self xjxjRequestUserIdWith:@"1"];
        }
            break;
            
        default:
            break;
    }
}

- (void)xjxjRequestUserIdWith:(NSString*)xjType {
    FL_Log(@"-----[%@],[%@],[%@]",_xjTopicIdStr,XJ_USER_SESSION,xjType);
    [FLFinalNetTool  xjGetUserIdForCreatGroupFromeSerWithtopicidStr:_xjTopicIdStr  token:XJ_USER_SESSION  searchConditionNum:xjType success:^(NSDictionary *data) {
        FL_Log(@"this is the userid to creat group=[%@]",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* xjUS = data[FL_NET_DATA_KEY];
            FL_Log(@"xjuser=[%@]",xjUS);
            if (xjUS.count!=0) {
                [self xjCreatGroupWithArr:xjUS];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//创建群组
- (void)xjCreatGroupWithArr:(NSArray*)xjArr {
    //    NSMutableArray* xjMu = @[].mutableCopy;
    //    for (FLMyIssueReceiveModel* model in _flMyTopicPartInArray) {
    //        if (model.userId) {
    //            [xjMu addObject:model.userId];
    //        }
    //    }
    //    NSArray* xjjArr = [FLTool xjReturnArrWithoutRepeat:xjMu.mutableCopy]; //数组去重
    XJCreatGroupForPickViewController* xjCreatVC = [[XJCreatGroupForPickViewController alloc] init];
    xjCreatVC.xjUserIdArr = xjArr;
    [self.navigationController pushViewController:xjCreatVC animated:YES];
}





@end




















