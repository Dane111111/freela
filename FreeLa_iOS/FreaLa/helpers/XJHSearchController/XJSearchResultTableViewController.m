//
//  XJSearchResultTableViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/5.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJSearchResultTableViewController.h"
#import "XJSearchResultTableViewCell.h"
#import "XJSearchResultModel.h"
#import "FLFuckHtmlViewController.h"
@interface XJSearchResultTableViewController ()
{
    NSInteger _xjTotal; // 总个数
}
@end

@implementation XJSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"XJSearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"xjSearchResultCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = [NSString stringWithFormat:@"%@的搜索结果",self.xjTitle];
    self.tableView.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjRefreshWithSearch)];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(xjLoadMoreWithSearch)];
    [self.tableView.mj_header beginRefreshing];
}

- (NSMutableArray *)xjSearchResultArr{
    if (!_xjSearchResultArr) {
        _xjSearchResultArr = [NSMutableArray array];
    }
    return _xjSearchResultArr;
}

- (void)xjRefreshWithSearch {
    [self.xjSearchResultArr removeAllObjects];
    [self xjGetTpoicListInfoWithIndexStr:self.xjTitle current:[NSNumber numberWithInteger:1]];
}
- (void)xjLoadMoreWithSearch {
    [self xjGetTpoicListInfoWithIndexStr:self.xjTitle current:[FLTool xjRetuenCurrentWithArrLength:self.xjSearchResultArr.count andTotal:_xjTotal xjSize:0]];
}
- (void)xjEndRefreshWithTotal:(NSInteger)xjTotal {
    [self.tableView.mj_header endRefreshing];
    if (self.xjSearchResultArr.count >= xjTotal) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}


#pragma mark 网络请求
- (void)xjGetTpoicListInfoWithIndexStr:(NSString*)xjStr current:(NSNumber*)xjCurrent{
    NSDictionary* parm =@{@"topic.searchName": xjStr,
                          @"page.currentPage":xjCurrent};
    FL_Log(@"dic la2in square = %@",parm);
    [FLNetTool getSquareInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"dic in with search =1= = %@",data );
        NSMutableArray* xjMuArr = [NSMutableArray array];
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            xjMuArr = [XJSearchResultModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            [self.xjSearchResultArr  addObjectsFromArray:xjMuArr];
            _xjTotal = [data[@"total"] integerValue];
            [self.tableView reloadData];
        }
        [self xjEndRefreshWithTotal:[data[@"total"] integerValue]];
    } failure:^(NSError *error) {
        [self xjEndRefreshWithTotal:0];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden: NO];
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.xjSearchResultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xjSearchResultCell" forIndexPath:indexPath];
    if (self.xjSearchResultArr.count >= indexPath.row) {
       cell.xjModel = self.xjSearchResultArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.xjSearchResultArr.count >indexPath.row) {
        XJSearchResultModel* xjmodel = self.xjSearchResultArr[indexPath.row];
        FLFuckHtmlViewController* xjfuck = [[FLFuckHtmlViewController alloc] init];
        xjfuck.flFuckTopicId = [NSString stringWithFormat:@"%ld",xjmodel.topicId];
        [self.navigationController pushViewController:xjfuck animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
