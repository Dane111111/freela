//
//  FLMyReceiveJudgeViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyReceiveJudgeViewController.h"
#import "FLStartChoiceView.h"
#import "FLGrayLabel.h"
@interface FLMyReceiveJudgeViewController ()<UITableViewDelegate,UITableViewDataSource,FLPopBaseViewDelegate>
{
    NSInteger _flPartInCurrentPage;
    NSInteger _fltotal;
    NSInteger _xjStartCount;
    FLGrayLabel* _xjCountLabel;   //几个人
    FLGrayLabel* _xjAllCountLabel; //总评分
}

/**tableView*/
@property (nonatomic , strong) UITableView* flTableView;

/**弹出层*/
@property (nonatomic , strong) FLPopBaseView* popView;
/**header*/
@property (nonatomic , strong) FLStartChoiceView* xjStarView;

/**模型数组*/
@property (nonatomic , strong) NSMutableArray* flMyTopicPartInArray;


/**cell*/
@property (nonatomic ,strong) FLMyIssueJudgePJTableViewCell* flcell;

/**我的信息*/
@property (nonatomic  , strong) FLMineInfoModel* flMineInfoModel;
@end

@implementation FLMyReceiveJudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flMyTopicPartInArray = [NSMutableArray array];
    [self creatTbleViewInMyIssueThirdVC];
    
}

- (UITableView *)flTableView {
    if (!_flTableView) {
        _flTableView = [[UITableView alloc] init];
    }
    return _flTableView;
}

#pragma mark  tableview dataSource

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
//    self.flcell = [tableView dequeueReusableCellWithIdentifier:@"FLMyIssueJudgePJTableViewCell" forIndexPath:indexPath];
//    if (self.flcell == nil) {
//        self.flcell = [[FLMyIssueJudgePJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FLMyIssueJudgePJTableViewCell"];
//    }
    FLMyIssueJudgePJTableViewCell *cell = [[FLMyIssueJudgePJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FLMyIssueJudgePJTableViewCell"];
    if (_flMyTopicPartInArray.count == 0) {
        FL_Log(@"崩在这4儿了啊，_flMyTopicPartInArray.count = %ld",_flMyTopicPartInArray.count);
    } else {
        
        [self configureCell:cell atIndexPath:indexPath];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configureCell:(FLMyIssueJudgePJTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.flmodel = _flMyTopicPartInArray[indexPath.row];
}

- (void)setXjTioicId:(NSString *)xjTioicId {
    _xjTioicId = xjTioicId;
//    [self getRankCountMapInPJPage];
//    [self getJudgeListPJinMyIssueControlVC];
    [self.flTableView.mj_header beginRefreshing];
}
#pragma mark  tableview delegate


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLMyIssueJudgePJModel* model = _flMyTopicPartInArray[indexPath.row];
    CGFloat  cellH = [FLMineTools returnJudgePJCellHWithPJModel:model];
    return cellH +30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  20;
}


#pragma mark  Info
- (void)loadNewDataWithTableViewPJList
{
    _flPartInCurrentPage = 1;
    [_flMyTopicPartInArray removeAllObjects];
    [self getJudgeListPJinMyIssueControlVC];
    [self getRankCountMapInPJPage]; //获取星星
}

- (void)loadMoreDataInTableViePJList
{
    _flPartInCurrentPage ++;
}

- (void)getJudgeListPJinMyIssueControlVC
{
    NSDictionary* detail = @{@"businessId":_xjTioicId,
                             @"commentType":@"1", //1为评价  0为评论
                             }; //分页
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:detail],
                           @"page.currentPage":[NSNumber numberWithInteger:_flPartInCurrentPage],
                           @"isFlush":@"true"};
    [FLNetTool htmlListCommentInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html with PJ listwith type sad =%@",data);
        if (data) {
            _fltotal = [data[@"total"] integerValue];
            NSArray* array = [FLMineTools returnJudgePJModelWithDic:data[FL_NET_DATA_KEY]];
            [self.flMyTopicPartInArray addObjectsFromArray:array];
            [self.flTableView reloadData];
            [self endRefreshInTableViewPLList];
        }
    } failure:^(NSError *error) {
        [self endRefreshInTableViewPLList];
    }];
}


#pragma mark  UI
- (void)creatTbleViewInMyIssueThirdVC
{
    self.flTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FL_TopColumnView_Height_S + StatusBar_NaviHeight, FLUISCREENBOUNDS.width, self.view.height  - FL_TopColumnView_Height_S - StatusBar_NaviHeight) style:UITableViewStyleGrouped];
    self.flTableView.delegate = self;
    self.flTableView.dataSource  =self;
    [self.view addSubview:self.flTableView];
    
    [self.flTableView registerClass:[FLMyIssueJudgePJTableViewCell class] forCellReuseIdentifier:@"FLMyIssueJudgePJTableViewCell"];
    
    //header  _footer
    self.flTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewPJList)];
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataInTableViePJList)];
    self.flTableView.mj_footer = footer;
    
    self.flTableView.estimatedRowHeight = 44.0f;
    self.flTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    //Header
    UIView* xjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 20)];
    _xjCountLabel = [[FLGrayLabel alloc] initWithFrame:CGRectMake(145, 13, 160, 20)];
    _xjCountLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    _xjAllCountLabel = [[FLGrayLabel alloc] initWithFrame:CGRectMake(20, 13, 40, 20)];
    _xjAllCountLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    _xjAllCountLabel.text = @"总评分:";
    self.xjStarView = [[FLStartChoiceView alloc] initWithFrame:CGRectMake(60, 15, 80, 20)];
    self.xjStarView.xjIsCanBeChoice = NO;
    
    [xjView addSubview:_xjCountLabel];
    [xjView addSubview:_xjAllCountLabel];
    [xjView addSubview:self.xjStarView];
    self.flTableView.tableHeaderView = xjView;
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

//获取星星
- (void)getRankCountMapInPJPage
{
    NSDictionary* parmId = @{@"businessId":_xjTioicId};
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:parmId]};
    [FLNetTool getRankCountMapInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data ian get count star imagein 评价 =%@",data[FL_NET_DATA_KEY]);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* xj = data[FL_NET_DATA_KEY];
            NSDictionary* dj = xj[0];
            _xjStartCount = [dj[@"countavg"] integerValue];
            NSInteger   xjIn = [dj[@"counts"] integerValue];
            _xjCountLabel.text = [NSString stringWithFormat:@"%ld分(%ld人评价)",_xjStartCount?_xjStartCount:0,xjIn?xjIn:0];
            [self xjSetCountForHeader];
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"data in get start count imagein HTML error=%@",error);
    }];
    
}

- (void)xjSetCountForHeader{
    self.xjStarView.flrank = _xjStartCount;
}

@end
