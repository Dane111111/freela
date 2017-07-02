//
//  XJSearchViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/5.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJSearchViewController.h"
#import "UIView+Location.h"
#import "XJSearchResultTableViewController.h"
#import "XJSearchResultModel.h"
#import "FLActivitySignUpBaseView.h"
#import "XJSearchWitoutSysTableViewController.h"
#import "XJSearchSystemParmModel.h"
@interface XJSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    UIView* _xjHeaderView;
}
/** 搜索框*/
@property(strong,nonatomic) UISearchBar *searchBar;
/** 占位文字*/
@property(copy,nonatomic) NSString *placeHolder;
/** tableView*/
@property(strong,nonatomic) UITableView *tableView;
/** 是否点击了搜索 */
@property(assign,nonatomic,getter=isSearching) BOOL searching;
/** 是有有搜索结果 */
@property(assign,nonatomic,getter=hasResult) BOOL result;
/**搜索结果*/
@property (nonatomic , strong) NSMutableArray* xjSearchResultArr;
/**搜索历史*/
@property (nonatomic , strong) NSMutableArray* xjSearchHisArr;


@end

@implementation XJSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self xjGetHistoryOfSearch];
    [self setupBasic];
    [self setupNav];
    [self xjRetuenHeaderView];
    [self xjgetUerTypeAndCagteGory];
   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
      [self xjGetHistoryOfSearch];
    [self.navigationController.navigationBar setHidden: NO];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_back_red_new"] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark 搜索相关(系统标签)
- (void)xjgetUerTypeAndCagteGory
{
    //    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
    //                           @"userId":FL_USERDEFAULTS_USERID_NEW,
    //                           @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey};
    [FLNetTool flPubTopicListBackByParm:nil success:^(NSDictionary *data) {
        FL_Log(@"this is my test for biaoqian to publish=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* dicArr = data[FL_NET_DATA_KEY];
            //            for (NSDictionary* dic in dicArr) {
            //                NSString* xjStr = dic[@"tagName"];
            //                [self.xjSystemSearchTags addObject:xjStr];
            //            }
            self.xjSearchSystemArr = [XJSearchSystemParmModel mj_objectArrayWithKeyValuesArray:dicArr];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - 初始化
- (void)setupBasic
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.searching = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.tableView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - 69);
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xjTableViewCell"];
    [self.view addSubview:self.tableView];
    
}
- (void)setupNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnDidClick:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]} forState:UIControlStateNormal];
}

- (void)rightBtnDidClick :(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"搜索"]) {
        NSLog(@"搜索");
        item.title = @"取消";
        //  标识替换
        self.searching = YES;
        [self xjGetTpoicListInfoWithIndexStr:self.searchBar.text isClickSystemTag:NO tag:nil];
        [self xjSaveHistoryOfSearch]; //保存;
        return;
    } else {
        
    }
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@ -1-textDidChange-1- %@",searchText,self.searchBar.text);
    if ([searchText isEqualToString:@""]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        return;
    }
    [self.navigationItem.rightBarButtonItem setTitle:@"搜索"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
         return self.xjSearchSystemArr.count;
    } else {
         return self.xjSearchHisArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
         return 40;
    } else {
         return 40;
    }
   
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"分类搜索";
    } else {
        return @"历史搜索";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return [self xjRetuenHeaderView];
    } else {
        return  nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xjTableViewCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0){
        if (self.xjSearchSystemArr.count >= indexPath.row) {
            XJSearchSystemParmModel* xjModel = self.xjSearchSystemArr[indexPath.row];
               cell.textLabel.text = xjModel.tagName;
        }
        return cell;
    } else   {
        if (self.xjSearchHisArr.count >= indexPath.row) {
             cell.textLabel.text = self.xjSearchHisArr[indexPath.row];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* xjStr = @"";
    if (indexPath.section == 0) {
         XJSearchSystemParmModel* xjModel = self.xjSearchSystemArr[indexPath.row];
        xjStr = [NSString stringWithFormat:@"%@",xjModel.tagName];
        [self xjGetTpoicListInfoWithIndexStr:nil isClickSystemTag:YES tag:xjStr];
    } else if (indexPath.section == 1) {
        xjStr = self.xjSearchHisArr[indexPath.row];
        [self xjGetTpoicListInfoWithIndexStr:xjStr isClickSystemTag:NO tag:nil];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //  标识替换
    self.searching = YES;
    [self xjGetTpoicListInfoWithIndexStr:self.searchBar.text isClickSystemTag:NO tag:nil];//请求 +跳转
    [self xjSaveHistoryOfSearch]; //保存
   
}
#pragma mark - Lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width - 80, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = self.placeHolder;
//        [self.searchBar becomeFirstResponder];
    }
    return _searchBar;
}

- (NSMutableArray *)xjSearchResultArr {
    if (!_xjSearchResultArr) {
        _xjSearchResultArr = [NSMutableArray array ];
    }
    return _xjSearchResultArr;
}

- (NSMutableArray *)xjSearchHisArr{
    if (!_xjSearchHisArr) {
        _xjSearchHisArr = [NSMutableArray array];
    }
    return _xjSearchHisArr;
}

#pragma mark 网络请求
- (void)xjGetTpoicListInfoWithIndexStr:(NSString*)xjStr isClickSystemTag:(BOOL)xjIsSystem tag:(NSString*)xjTag{
    NSDictionary* parm =@{};
    if (xjIsSystem) {
        parm = @{@"topic.topicTag": xjTag};
    } else {
         parm = @{@"topic.searchName": xjStr};
    }
    FL_Log(@"dic la2in square = %@",parm);
    [FLNetTool getSquareInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"dic in with searc2h =1= = %@",data );
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjSearchResultArr = [XJSearchResultModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            if (xjIsSystem) {
                [self xjPushNextPageWithXJTag:xjTag];//下一步
            } else {
               [self pushNviPageWithTitle:xjStr];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjPushNextPageWithXJTag:(NSString*)xjTag{
    XJSearchWitoutSysTableViewController* xjResultVC = [[XJSearchWitoutSysTableViewController alloc] initWithStyle:UITableViewStylePlain];
    xjResultVC.xjSearchResultArr = self.xjSearchResultArr;
    xjResultVC.xjTag = xjTag ;
    [self.navigationController pushViewController:xjResultVC animated:YES];
}

- (void)pushNviPageWithTitle:(NSString*)xjTitle {
    XJSearchResultTableViewController* xjResultVC = [[XJSearchResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
    xjResultVC.xjSearchResultArr = self.xjSearchResultArr;
    xjResultVC.xjTitle = self.searchBar.text.length !=0 ?self.searchBar.text : xjTitle ;
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

- (UIView*)xjRetuenHeaderView {
    _xjHeaderView= [[UIView alloc] initWithFrame:CGRectMake(10, 0, 60, 44)];
    UILabel* xjLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    xjLabel.text = @"历史记录";
    xjLabel.textAlignment = NSTextAlignmentCenter;
    xjLabel.textColor = [UIColor grayColor];
    xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [_xjHeaderView addSubview:xjLabel];
    UIButton* xjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xjBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [xjBtn setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
    xjBtn.frame = CGRectMake(FLUISCREENBOUNDS.width - 90, 5, 80, 30);
    xjBtn.layer.cornerRadius = 15;
    xjBtn.layer.masksToBounds = YES;
    xjBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [xjBtn addTarget:self action:@selector(xjClickToClearHis) forControlEvents:UIControlEventTouchUpInside];
    [_xjHeaderView addSubview:xjBtn];
    if (self.xjSearchHisArr.count == 0) {
        xjBtn.hidden = YES;
    }
    
    return _xjHeaderView;
}
//清除历史记录
- (void)xjClickToClearHis{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"xjMySearchHisArr"];
    [self.xjSearchHisArr removeAllObjects];
    [self.tableView reloadData];
}
@end



















