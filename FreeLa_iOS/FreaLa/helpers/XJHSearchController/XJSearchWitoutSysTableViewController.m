//
//  XJSearchWitoutSysTableViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/5.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJSearchWitoutSysTableViewController.h"
#import "XJSearchResultTableViewCell.h"
#import "XJSearchResultTableViewController.h"
@interface XJSearchWitoutSysTableViewController ()<UISearchBarDelegate>
{
    NSInteger _xjTotal; // 总个数
}
/** 搜索框*/
@property(strong,nonatomic) UISearchBar *searchBar;
/** 是否点击了搜索 */
@property(assign,nonatomic,getter=isSearching) BOOL searching;
/**搜索历史*/
@property (nonatomic , strong) NSMutableArray* xjSearchHisArr;

@end

@implementation XJSearchWitoutSysTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self xjGetHistoryOfSearch];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XJSearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"xjSearchResultCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjRefreshWithSearchSys)];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(xjLoadMoreWithSearchSys)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden: NO];
}
- (void)setupNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnDidClick:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]} forState:UIControlStateNormal];
    [self.searchBar becomeFirstResponder];
}

- (NSMutableArray *)xjSearchResultArr{
    if (!_xjSearchResultArr) {
        _xjSearchResultArr = [NSMutableArray array];
    }
    return _xjSearchResultArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 点击导航栏的搜索按钮
- (void)rightBtnDidClick :(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"搜索"]) {
        NSLog(@"搜索");
        item.title = @"取消";
        //  标识替换
        self.searching = YES;
        [self xjGetTpoicListInfoWithIndexStr:self.searchBar.text current:[NSNumber numberWithInteger:1]];
        return;
    } else {
        
    }
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width - 80, 30)];
        _searchBar.delegate = self;
//        _searchBar.placeholder = self.placeHolder;
    }
    return _searchBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
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
    return cell;
}
 
- (void)xjPushNextPage{
    XJSearchWitoutSysTableViewController* xjResultVC = [[XJSearchWitoutSysTableViewController alloc] initWithStyle:UITableViewStylePlain];
    xjResultVC.xjSearchResultArr = self.xjSearchResultArr;
    xjResultVC.xjTitle = self.searchBar.text;
    [self.navigationController pushViewController:xjResultVC animated:YES];
}

- (void)pushNviPage {
    XJSearchResultTableViewController* xjResultVC = [[XJSearchResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
    xjResultVC.xjSearchResultArr = self.xjSearchResultArr;
    xjResultVC.xjTitle = self.searchBar.text;
    [self.navigationController pushViewController:xjResultVC animated:YES];
}



//获取搜索历史
- (void)xjGetHistoryOfSearch {
    NSArray* xjarr = [[NSUserDefaults standardUserDefaults] objectForKey:@"xjMySearchHisArr"];
    if (xjarr) {
        self.xjSearchHisArr = xjarr.mutableCopy;
        [self.tableView reloadData];
    }
}

//保存搜索历史
- (void)xjSaveHistoryOfSearch {
    BOOL is_can_add = YES;
    for (NSString* xjStr in  _xjSearchHisArr) {
        if ([xjStr isEqualToString:_searchBar.text]) {
            is_can_add = NO;
        }
    }
    if (is_can_add) {
        [self.xjSearchHisArr addObject:_searchBar.text];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_xjSearchHisArr.mutableCopy forKey:@"xjMySearchHisArr"];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@ --textDidChange-- %@",searchText,self.searchBar.text);
    if ([searchText isEqualToString:@""]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        return;
    }
    [self.navigationItem.rightBarButtonItem setTitle:@"搜索"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
#pragma mark 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //  标识替换
    self.searching = YES;
    [self.xjSearchResultArr removeAllObjects];
    [self xjGetTpoicListInfoWithIndexStr:searchBar.text current:[NSNumber numberWithInteger:1]];//请求 +跳转
    [self xjSaveHistoryOfSearch]; //保存
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XJSearchResultModel* xjmodel = self.xjSearchResultArr[indexPath.row];
    FLFuckHtmlViewController* xjfuck = [[FLFuckHtmlViewController alloc] init];
    xjfuck.flFuckTopicId = [NSString stringWithFormat:@"%ld",xjmodel.topicId];
    [self.navigationController pushViewController:xjfuck animated:YES];
}

- (void)xjRefreshWithSearchSys {
    [self.xjSearchResultArr removeAllObjects];
    [self xjGetTpoicListInfoWithIndexStr:self.xjTag current:[NSNumber numberWithInteger:1]];
}
- (void)xjLoadMoreWithSearchSys {
    [self xjGetTpoicListInfoWithIndexStr:self.xjTag current:[FLTool xjRetuenCurrentWithArrLength:self.xjSearchResultArr.count andTotal:_xjTotal xjSize:0]];
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
- (void)xjGetTpoicListInfoWithIndexStr:(NSString*)xjStr current:(NSNumber*)xjCurrent {
    NSDictionary* parm =@{};
    if (self.searchBar.text.length == 0) {
        parm =@{@"topic.searchName": xjStr,
                @"page.currentPage":xjCurrent};
    } else {
        parm =@{@"topic.searchName": self.searchBar.text,
                @"page.currentPage":xjCurrent};
    }
    FL_Log(@"dic la2in square = %@",parm);
    [FLNetTool getSquareInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"dic in with searc3h =1= = %@",data );
        NSMutableArray* xjMuArr = [NSMutableArray array];
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            xjMuArr = [XJSearchResultModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            [self.xjSearchResultArr  addObjectsFromArray:xjMuArr];
            [self.tableView reloadData];
            _xjTotal = [data[@"total"] integerValue];
        }
        [self xjEndRefreshWithTotal:[data[@"total"] integerValue]];
    } failure:^(NSError *error) {
        [self xjEndRefreshWithTotal:0];
    }];
}



@end









