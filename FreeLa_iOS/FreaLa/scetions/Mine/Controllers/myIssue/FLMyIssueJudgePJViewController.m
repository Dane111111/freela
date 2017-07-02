//
//  FLMyIssueJudgePJViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueJudgePJViewController.h"
#import "FLStartChoiceView.h"


@interface FLMyIssueJudgePJViewController ()<UITableViewDelegate,UITableViewDataSource,FLPopBaseViewDelegate>
{
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
 
/**我发布的模型*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmyIssueInMineModel;

/**模型数组*/
@property (nonatomic , strong) NSMutableArray* flMyTopicPartInArray;


/**cell*/
@property (nonatomic ,strong) FLMyIssueJudgePJTableViewCell* flcell;

@end

@implementation FLMyIssueJudgePJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flMyTopicPartInArray = [NSMutableArray array];
    [self creatTbleViewInMyIssueThirdVC];
    [self loadNewDataWithTableViewPJList];
    [self getRankCountMapInPJPage];
    
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


//获取星星
- (void)getRankCountMapInPJPage
{
    NSDictionary* parmId = @{@"businessId":_xjTopicIdStr};
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:parmId]};
    [FLNetTool getRankCountMapInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in get cousnt star imagein 评价 =%@",data[FL_NET_DATA_KEY]);
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


#pragma mark  tableview dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flMyTopicPartInArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FLMyIssueJudgePJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLMyIssueJudgePJTableViewCell" forIndexPath:indexPath];
#warning 因为cell 写的不好所以没有办法复用cell
//    self.flcell = [tableView dequeueReusableCellWithIdentifier:@"FLMyIssueJudgePJTableViewCell" forIndexPath:indexPath];
//    if (self.flcell == nil) {
        FLMyIssueJudgePJTableViewCell *cell = [[FLMyIssueJudgePJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FLMyIssueJudgePJTableViewCell"];
//    }
    if (_flMyTopicPartInArray.count == 0) {
        FL_Log(@"崩在这1儿了啊，_flMyTopicPartInArray.count = %ld",_flMyTopicPartInArray.count);
    } else {
        
//        [self configureCell:self.flcell atIndexPath:indexPath];
        cell.flmodel = _flMyTopicPartInArray[indexPath.row];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configureCell:(FLMyIssueJudgePJTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.flmodel = _flMyTopicPartInArray[indexPath.row];
}


#pragma mark  tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_flMyTopicPartInArray.count==0) {
        return 0;
    }
    FLMyIssueJudgePJModel* model = _flMyTopicPartInArray[indexPath.row];
    CGFloat  cellH = [FLMineTools returnJudgePJCellHWithPJModel:model];
    return cellH + 30 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}


#pragma mark  Info
- (void)loadNewDataWithTableViewPJList {
    [_flMyTopicPartInArray removeAllObjects];
    [self getJudgeListPJinMyIssueControlVCWithCurrent:@1];
}

- (void)loadMoreDataInTableViePJList {
    [self getJudgeListPJinMyIssueControlVCWithCurrent:[FLTool xjRetuenCurrentWithArrLength:self.flMyTopicPartInArray.count andTotal:_fltotal xjSize:0]];
}

- (void)getJudgeListPJinMyIssueControlVCWithCurrent:(NSNumber*)xjCurrent {
    NSDictionary* detail = @{@"businessId":_xjTopicIdStr ? _xjTopicIdStr :@"",
                             @"commentType":@"1", //1为评价  0为评论
                             }; //分页
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:detail],
                           @"page.currentPage":xjCurrent,
                           @"isFlush":@"true"};
    [FLNetTool htmlListCommentInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html with PJ listwith type 0 =%@",data);
        if (data) {
            _fltotal = [data[@"total"] integerValue];
            NSArray* array = [FLMineTools returnJudgePJModelWithDic:data[FL_NET_DATA_KEY]];
            for (FLMyIssueJudgePJModel*model in array) {
                [self.flMyTopicPartInArray addObject:model];
            }
//            [self.flMyTopicPartInArray addObjectsFromArray:array];
            [self endRefreshInTableViewPLList];
        }
    } failure:^(NSError *error) {
        [self endRefreshInTableViewPLList];
    }];
}


#pragma mark  UI
- (void)creatTbleViewInMyIssueThirdVC {
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
    [self.flTableView.mj_header beginRefreshing];
}


- (void)endRefreshInTableViewPLList
{
    [self.flTableView.mj_header endRefreshing];
    if (_fltotal == _flMyTopicPartInArray.count) {
        [self.flTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.flTableView.mj_footer endRefreshing];
    }
     [self.flTableView reloadData];
}

- (void)xjSetCountForHeader{
    self.xjStarView.flrank = _xjStartCount;
}

- (void)setXjTopicIdStr:(NSString *)xjTopicIdStr {
    _xjTopicIdStr = xjTopicIdStr;
    if (xjTopicIdStr) {
        
    }
}
@end
























