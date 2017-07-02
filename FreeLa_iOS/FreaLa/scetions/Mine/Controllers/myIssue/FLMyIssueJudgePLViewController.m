//
//  FLMyIssueJudgePLViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueJudgePLViewController.h"



@interface FLMyIssueJudgePLViewController ()<UITableViewDelegate,UITableViewDataSource,FLPopBaseViewDelegate>
{
    NSInteger _flPartInCurrentPage;
    NSInteger _fltotal;
}

/**tableView*/
@property (nonatomic , strong) UITableView* flTableView;

/**弹出层*/
@property (nonatomic , strong) FLPopBaseView* popView;

/**我发布的模型*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmyIssueInMineModel;

/**模型数组*/
@property (nonatomic , strong) NSMutableArray* flMyTopicPartInArray;


/**cell*/
//@property (nonatomic ,strong) FLMyIssueJudgePLTableViewCell* flcell;

@end
static NSInteger _flClickRejudgeBtn;
@implementation FLMyIssueJudgePLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flMyTopicPartInArray = [NSMutableArray array];
    [self creatTbleViewInMyIssueSecondVC];
    [self loadNewDataWithTableViewPLList];
}


- (void)creatTbleViewInMyIssueSecondVC
{
    self.flTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FL_TopColumnView_Height_S + StatusBar_NaviHeight, FLUISCREENBOUNDS.width, self.view.height  - FL_TopColumnView_Height_S - StatusBar_NaviHeight) style:UITableViewStyleGrouped];
    self.flTableView.delegate = self;
    self.flTableView.dataSource  =self;
    [self.view addSubview:self.flTableView];
    
    
    [self.flTableView registerNib:[UINib nibWithNibName:@"FLMyIssueJudgePLTableViewCell" bundle:nil ] forCellReuseIdentifier:@"FLMyIssueJudgePLTableViewCell"];
    
    //header  _footer
    self.flTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewPLList)];
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataInTableViePLList)];
    self.flTableView.mj_footer = footer;
    
}

#pragma mark  tableview dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flMyTopicPartInArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLMyIssueJudgePLTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FLMyIssueJudgePLTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FLMyIssueJudgePLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FLMyIssueJudgePLTableViewCell"];
    }
    if (_flMyTopicPartInArray.count == 0) {
        FL_Log(@"崩在2这儿了啊，_flMyTopicPartInArray.count = %ld",_flMyTopicPartInArray.count);
    } else {
        
        cell.flmodel = _flMyTopicPartInArray[indexPath.row];
    }
    cell.flJudgeBtn.tag =   indexPath.row;
    [cell.flJudgeBtn addTarget:self action:@selector(clickJudgeBack:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark  tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XJReJudgePLListViewController* rejudgeListVC = [[XJReJudgePLListViewController alloc] init];
    rejudgeListVC.flPLModel = self.flMyTopicPartInArray[indexPath.row];
    rejudgeListVC.xjTopicIdStr = _xjTopicIdStr;
    [self.navigationController pushViewController:rejudgeListVC animated:YES];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark  get info

- (void)getJudgeListPLinMyIssueControlVC {
    NSDictionary* detail = @{@"businessId":_xjTopicIdStr ? _xjTopicIdStr :@"",
                             @"commentType":@"0", //1为评价  0为评论
                             }; //分页
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:detail],
                           @"page.currentPage":[NSNumber numberWithInteger:_flPartInCurrentPage],
                           @"isFlush":@"true"};
    [FLNetTool htmlListCommentInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html with PL listwith type 0 =%@",data);
        if (data) {
            _fltotal = [data[@"total"] integerValue];
            NSArray* array = [FLMineTools returnJudgePLModelWithDic:data[FL_NET_DATA_KEY]];
            [self.flMyTopicPartInArray addObjectsFromArray:array];
            [self.flTableView reloadData];
            [self endRefreshInTableViewPLList];
        }
    } failure:^(NSError *error) {
        [self endRefreshInTableViewPLList];
    }];
}



#pragma mark  refresh

- (void)loadNewDataWithTableViewPLList
{
    _flPartInCurrentPage = 1;
    [_flMyTopicPartInArray removeAllObjects];
     FL_Log(@"'loadNewDataWithTableViewPLListkkkkkkkkk");
    [self getJudgeListPLinMyIssueControlVC];
}

- (void)loadMoreDataInTableViePLList
{
    _flPartInCurrentPage ++;
    FL_Log(@"'loadMoreDataInTableViePLLissssssst");
    [self getJudgeListPLinMyIssueControlVC];
}

- (void)endRefreshInTableViewPLList
{
    [self.flTableView.mj_header endRefreshing];
    if (_fltotal == _flMyTopicPartInArray.count) {
        [self.flTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.flTableView.mj_footer endRefreshing];
    }
}

#pragma mark   judge Back
- (void) clickJudgeBack:(UIButton*)sender
{
    _flClickRejudgeBtn = sender.tag;
    [_popView removeFromSuperview];
    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写评论内容" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength:100 lengthType:FLLengthTypeLength originalStr:nil];
    [_popView.flInputTextField becomeFirstResponder];
//    popViewTag = 11;
    _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_popView];
    });
}

#pragma mark popView delegate
- (void)entrueBtnClickWithStr:(NSString *)result
{
    [self insertJudgeBackRecordInMyIssuePLWithParentId];
}

- (void) insertJudgeBackRecordInMyIssuePLWithParentId
{
//    if (!FLFLIsPersonalAccountType) {
//        [FLTool showWith:@"当前版本暂不支持商家回评"];
//    }
    FLMyIssueJudgePlModel* model = self.flMyTopicPartInArray[_flClickRejudgeBtn];
    //插入回评记录
    NSDictionary* dic = @{@"businessId":_xjTopicIdStr,
                          @"commentType":@"2",   //2代表回复
                          @"content":_popView.flInputTextField.text?_popView.flInputTextField.text:@"",
                          @"parentId":model.commentId};
    NSDictionary* parm =@{@"commentPara":[FLTool returnDictionaryToJson:dic],
                          @"userType":XJ_USERTYPE_WITHTYPE,
                          @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"insert comment in my receive rejudge = %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:@"回复成功" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in insert comment html =%@",error);
    }];
}



@end






