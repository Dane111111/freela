//
//  CYAttentionViewController.m
//  FreeLa
//
//  Created by cy on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYAttentionViewController.h"
#import "FLNetTool.h"
#import "CYHTTPRequestManager.h"
#import "CYAttentionModel.h"
#import "CYAttentionCell.h"
#import <MJExtension.h>

@interface CYAttentionViewController ()

@property(nonatomic,strong) NSMutableArray *models; // 模型数组
@property (nonatomic , assign) NSInteger xjCurrentPage; //当前页
@property (nonatomic , assign) NSInteger xjTotal ;//总数

@end

@implementation CYAttentionViewController

static NSString * const CYAttentioinCellID = @"attention";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.xjCurrentPage = 1;
    [self setUpTableView];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)setUpTableView{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CYAttentionCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CYAttentioinCellID];//注册
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 149,0); // 上 左 下 右
//    self.tableView.contentSize = self.view.frame.size;
    self.tableView.rowHeight = 150;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing]; // 第一次进入刷新
    self.tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
//    __weak typeof(self) weakSelf = self;
//    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
//        [weakSelf loadOldData];
//    }];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadOldData];
    }];
    
}

// 刷新数据
- (void)loadNewData{
    [self.models removeAllObjects];
    _xjCurrentPage = 1;
    [self xjLoadDataWithCurrentPage:1];
}

- (void)xjEndRefresh {
    [self.tableView.mj_header endRefreshing];
    if (self.xjTotal > self.models.count) {
       [self.tableView.mj_footer endRefreshing];
    } else {
       [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)xjLoadDataWithCurrentPage:(NSInteger)xjCurrentPage{
    NSDictionary *params = @{
                             @"userType":XJ_USERTYPE_WITHTYPE,
                             @"userId":XJ_USERID_WITHTYPE,
                             @"topic.userType":@"",
                             @"page.currentPage":[NSNumber numberWithInteger:xjCurrentPage]
                             };
    [FLNetTool xjfindAttentListByParm:params success:^(NSDictionary *data) {
        FL_Log(@"this is my attentlist by parm=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* dd = data[FL_NET_DATA_KEY];
            self.xjTotal = [data[@"total"] integerValue];
            NSMutableArray* xjMuarr = [NSMutableArray array];
            xjMuarr = [CYAttentionModel mj_objectArrayWithKeyValuesArray:dd];
            [self.models addObjectsFromArray:xjMuarr];
        }
        [self xjEndRefresh];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self xjEndRefresh];
    }];
}

//加载更多数据
- (void)loadOldData{
    if (self.xjTotal > self.models.count) {
        self.xjCurrentPage++;
        [self xjLoadDataWithCurrentPage:self.xjCurrentPage];
    } else {
        [self xjEndRefresh];
    }
}

// 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    取出cell
    CYAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:CYAttentioinCellID];
//    取出对应的模型
    if (indexPath.row <= self.models.count) {
        CYAttentionModel *model = self.models[indexPath.row];
        cell.model = model;
    }
//    设置模型
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLFuckHtmlViewController* xjFuckHtml = [[FLFuckHtmlViewController alloc] init];
    CYAttentionModel* cyModel = self.models[indexPath.row];
    xjFuckHtml.flFuckTopicId = [NSString stringWithFormat:@"%@",cyModel.topicId];
    [self.navigationController pushViewController:xjFuckHtml animated:YES];
}

@end
