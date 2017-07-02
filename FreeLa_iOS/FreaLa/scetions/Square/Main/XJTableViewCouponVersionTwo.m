//
//  XJTableViewCouponVersionTwo.m
//  FreeLa
//
//  Created by Leon on 16/5/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJTableViewCouponVersionTwo.h"
#import "XJSearchViewController.h"
#import "XJNaviViewSearchBar.h"
#import "XJVersionTwoCouponsModel.h"
#import "FLCouponsTableViewCell.h"
#import "XJVersionCouponsCell.h"

@interface XJTableViewCouponVersionTwo ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSInteger _xjAllFreeTotal; //全免费总个数
}
@property (nonatomic , strong) UITableView * xjTableView;
/**模型数组*/
@property (nonatomic , strong) NSMutableArray* xjModelsMuArr;
/**navi*/
@property (nonatomic , strong) XJNaviViewSearchBar* xjNaviView;
@end

@implementation XJTableViewCouponVersionTwo

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    [self xjSetTableViewAndNavi];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)xjSetTableViewAndNavi {
    self.xjTableView.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjBeginToRefreshNewInfoInAllFree)];
    self.xjTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(xjBeginToLoadMoreInfoInAllFree)];
//    [self.xjTableView registerClass:[FLCouponsTableViewCell class] forCellReuseIdentifier:@"FLCouponsTableViewCell"];
    [self.xjTableView registerNib:[UINib nibWithNibName:@"XJVersionCouponsCell" bundle:nil] forCellReuseIdentifier:@"XJVersionCouponsCell"];
    [self.xjTableView setContentInset:UIEdgeInsetsMake(- FL_STATUSBAR.height, 0, 0, 0) ];
    [self.xjTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    self.xjNaviView.xjSearchBar.delegate = self;
    [self.xjNaviView.xjBackBtn addTarget:self action:@selector(xjGoBackToRootView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.xjTableView];
    [self.view addSubview:self.xjNaviView];
    [self.xjTableView.mj_header beginRefreshing];
}
#pragma  mark ----------------------Lazy
- (UITableView *)xjTableView {
    if (!_xjTableView) {
        _xjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStylePlain];
        _xjTableView.delegate = self;
        _xjTableView.dataSource = self;
        _xjTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _xjTableView.tableFooterView = [[UIView alloc] init];
    }
    return _xjTableView;
}
- (NSMutableArray *)xjModelsMuArr {
    if (!_xjModelsMuArr) {
        _xjModelsMuArr = [NSMutableArray array];
    }
    return _xjModelsMuArr;
}
-  (XJNaviViewSearchBar *)xjNaviView{
    if (!_xjNaviView) {
        _xjNaviView = [[XJNaviViewSearchBar alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, StatusBar_NaviHeight)];
    }
    return _xjNaviView;
}
#pragma  mark ---------------------- Actions  Refresh
- (void)xjBeginToRefreshNewInfoInAllFree {
    [self.xjModelsMuArr removeAllObjects];
    [self xjgetAllFreeInfoInAllFreeWithCurrentPage:@1];
}
- (void)xjBeginToLoadMoreInfoInAllFree {
    [self xjgetAllFreeInfoInAllFreeWithCurrentPage:[FLTool xjRetuenCurrentWithArrLength:self.xjModelsMuArr.count andTotal:_xjAllFreeTotal xjSize:0]];
}

- (void)xjEndRefresh {
    [FLTool xjEndRefreshWithView:self.xjTableView total:_xjAllFreeTotal modelsCount:self.xjModelsMuArr.count];
}
#pragma  mark ---------------------- info
- (void)xjgetAllFreeInfoInAllFreeWithCurrentPage:(NSNumber*)xjCurrentPage {
    NSDictionary* dic = @{@"page.currentPage":xjCurrentPage ,
                          @"topic.topicType":FLFLXJSquareCouponseStrKey};
    FL_Log(@"dic idn square version2 la1= %@",dic);
    [FLNetTool getSquareInfoWithParm:dic success:^(NSDictionary *data) {
        FL_Log(@"data in sq3uare = %@",data);
        if ([[data objectForKey:FL_NET_KEY_NEW]boolValue]) {
            _xjAllFreeTotal = [data[@"total"] integerValue];
            NSArray* xjArr = [XJVersionTwoCouponsModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            for (XJVersionTwoAllFreeModel* xjModel in xjArr) {
                xjModel.thumbnail = [XJFinalTool xjReturnBigPhotoURLWithStr:xjModel.thumbnail with:XJ_IMAGE_PUBULIU_ADD];
                [self.xjModelsMuArr addObject:xjModel];
            }
            //            [self.xjModelsMuArr addObjectsFromArray:xjArr];
            [self.xjTableView reloadData];
            [self xjEndRefresh];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in square tableview info =%@",[FLTool returnStrWithErrorCode:error]);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        [self xjEndRefresh];
    }];
}
#pragma  mark ---------------------- Actions
- (void)xjGoBackToRootView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma  mark ---------------------- delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.xjModelsMuArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return FLUISCREENBOUNDS.width * 1.4;
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.xjModelsMuArr.count > indexPath.row) {
        XJVersionTwoCouponsModel* xjModel = self.xjModelsMuArr[indexPath.row];
        FLFuckHtmlViewController* xjHTMLVC = [[FLFuckHtmlViewController alloc] init];
        xjHTMLVC.flFuckTopicId = [NSString stringWithFormat:@"%ld",xjModel.topicId];
        [self.navigationController pushViewController:xjHTMLVC animated:YES];
    }
}

#pragma  mark ---------------------- datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier =  @"XJVersionCouponsCell";//@"FLCouponsTableViewCell";//@"XJVersionCouponsCell";
    XJVersionCouponsCell *cell = (XJVersionCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XJVersionCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.xjModelsMuArr.count > indexPath.row) {
        XJVersionTwoCouponsModel* xjModel = self.xjModelsMuArr[indexPath.row];
        cell.xjCellModel = xjModel;
    }
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark ---------------------- ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xjSetNaviColorWithOffsety:scrollView.contentOffset.y];
    
}

- (void)xjSetNaviColorWithOffsety:(CGFloat)offsetY {
    UIColor* xjColor =  XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [self.xjNaviView setBackgroundColor:[xjColor colorWithAlphaComponent:alpha]];
            //            [self.xjNaviView.xjSearchBar setHidden:YES];
            [self.xjNaviView.xjBackBtn setImage:[UIImage imageNamed:@"btn_icon_goback_white"] forState:UIControlStateNormal]; //btn_icon_goback_white
        } else {
            [self.xjNaviView setBackgroundColor:[xjColor colorWithAlphaComponent:0]];
            [self.xjNaviView.xjSearchBar setHidden:NO];
            [self.xjNaviView.xjBackBtn setImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        }
    });
}
#pragma mark ---------------------- searchBar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    XJSearchViewController* xjSearch = [[XJSearchViewController alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:xjSearch animated:YES];
    return NO;
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}


@end
