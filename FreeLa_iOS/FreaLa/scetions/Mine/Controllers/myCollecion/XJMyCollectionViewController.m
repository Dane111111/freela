//
//  XJMyCollectionViewController.m
//  FreeLa
//
//  Created by Leon on 16/3/16.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMyCollectionViewController.h"
#import "XJMyCollectionInfoModel.h"
#import "XJMyCollectionTableViewCell.h"
#import "FLFuckHtmlViewController.h"
#define xjTagIndexBase 10010

@interface XJMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) XJMyCollectionInfoModel* xjCollectionModel;
@property (nonatomic , strong) NSMutableArray* xjModelsArr;
@property (nonatomic , strong) UITableView* xjTableView;
@property (nonatomic , assign) NSInteger xjTotalNumber;
@property (nonatomic , assign) NSInteger xjCurrentPage;
@end

@implementation XJMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _xjCurrentPage = 1;
    self.xjModelsArr = [NSMutableArray array];
    [self initTableViewInCollectionView];
    [self setNavi];
    
    
}

- (void)setNavi {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.title =@"我收藏的";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavi];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJMyCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"XJMyCollectionTableViewCell" forIndexPath:indexPath];
    
    cell.xjModel = self.xjModelsArr.count > indexPath.row ?  self.xjModelsArr[indexPath.row] : nil;
    cell.xjBtn.tag = xjTagIndexBase + indexPath.row;
    [cell.xjBtn addTarget:self action:@selector(clickToDeleteFavourite:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    FLFuckHtmlViewController* HTMLVC = [[FLFuckHtmlViewController alloc] init];
//    XJMyCollectionInfoModel* xjmodel = self.xjModelsArr[indexPath.row];
//    HTMLVC.flFuckTopicId = [NSString stringWithFormat:@"%ld",xjmodel.topicId];
//    [self.navigationController pushViewController:HTMLVC animated:YES];
    
//    if (self.xjModelsArr.count>indexPath.row) {
//        XJMyCollectionInfoModel* xjmodel = self.xjModelsArr[indexPath.row];
//        NSDictionary* parm =@{@"token":FL_ALL_SESSIONID,
//                              @"userFavonites.userId":FL_USERDEFAULTS_USERID_NEW,
//                              @"userFavonites.topicId":[NSNumber numberWithInteger:xjmodel.topicId]};
//        [FLNetTool flquitecollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
//            FL_Log(@"this is the click action to delete my favourite= %@",dic);
//            if ([dic[@"success"] boolValue]) {
//                [FLTool showWith:@"成功"];
//                [self.xjModelsArr removeObjectAtIndex:indexPath.row];
//                [self.xjTableView reloadData];
//            } else {
//                [FLTool showWith:@"失败"];
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//    }
}

- (void)xjBeginToRefresh {
//    [self.xjTableView.mj_header beginRefreshing];
    self.xjCurrentPage = 1;
    [self.xjModelsArr removeAllObjects];
    [self requestInfoForTableViewWithCurrentpage:1];
}

- (void)xjLoadMoreInfo {
    self.xjCurrentPage++;
    [self requestInfoForTableViewWithCurrentpage:self.xjCurrentPage];
}

- (void)xjEndRefresh {
    if (self.xjModelsArr.count == self.xjTotalNumber && self.xjTotalNumber) {
        [self.xjTableView.mj_header endRefreshing];
         [self.xjTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.xjTableView.mj_header endRefreshing];
        [self.xjTableView.mj_footer endRefreshing];
    }
}

#pragma mark request
- (void)requestInfoForTableViewWithCurrentpage:(NSInteger)currentPage {
    
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"userFavonites.userId":FL_USERDEFAULTS_USERID_NEW,
                           @"page.currentPage":[NSNumber numberWithInteger:currentPage],};
    [FLNetTool xjdeleteFavonitesByCommentByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my test collection list=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* xjArr = [NSMutableArray array];
            xjArr = [XJMyCollectionInfoModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            [self.xjModelsArr addObjectsFromArray:xjArr];
            self.xjTotalNumber = [data[@"total"] integerValue];
             [self.xjTableView reloadData];
            [self xjEndRefresh];
        } else {
            [self xjEndRefresh];
        }
    } failure:^(NSError *error) {
        [self xjEndRefresh];
    }];
}


- (void)initTableViewInCollectionView {
    self.xjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.xjTableView];
    self.xjTableView.delegate = self;
    self.xjTableView.dataSource = self;
    [self requestInfoForTableViewWithCurrentpage:1];
    [self.xjTableView registerNib:[UINib nibWithNibName:@"XJMyCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMyCollectionTableViewCell"];
    self.xjTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjBeginToRefresh)];
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(xjLoadMoreInfo)];
    self.xjTableView.mj_footer = footer;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xjModelsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)clickToDeleteFavourite:(UIButton*)sender{
    NSInteger index = sender.tag - xjTagIndexBase ;
    XJMyCollectionInfoModel* xjmodel = self.xjModelsArr[index];
    NSDictionary* parm =@{@"token":FL_ALL_SESSIONID,
                           @"userFavonites.userId":FL_USERDEFAULTS_USERID_NEW,
                           @"userFavonites.topicId":[NSNumber numberWithInteger:xjmodel.topicId]};
    [FLNetTool flquitecollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is the click action to delete my favourite= %@",dic);
        if ([dic[@"success"] boolValue]) {
            [FLTool showWith:@"成功"];
            [self.xjModelsArr removeObjectAtIndex:index];
            [self.xjTableView reloadData];
        } else {
            [FLTool showWith:@"失败"];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end







