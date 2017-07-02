//
//  XJBusinessMineViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/25.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJBusinessMineViewController.h"
#import "XJRejudgePJBcakViewController.h"
#import "YYKit.h"
#import "FLMyPersonalDateTableViewController.h"
#import "XJMyIssueTableViewCell.h"
#import "XJPushMessageListViewController.h"
#import "XJPushMessagesBtn.h"
#import "XJPushMessageListModel.h"
#import "XJMineHeaderView.h"
#import "XJBusTopViewNumberView.h"

@interface XJBusinessMineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger _selectBtn; //标记点了的按钮， 全免费、优惠券
    
    NSInteger _xjTotalAllFree; // 全免费的 总数
    NSInteger _xjTotalCoupon; //优惠券的 总数
    CGRect fltopFrame;  //用于计算移动距离
    CGFloat fltopViewH;
    
    BOOL _isViewWillAperar;   //没办法了
}
@property (nonatomic , strong)UIImageView* portraitImageView; //肖像
/**头像button*/
@property (nonatomic , strong)UIButton*    portraitBtn;//头像button
/**headerVIew*/
@property (nonatomic , strong)UIView* headerVIew;
/**头像url*/
//@property (nonatomic , strong)NSString* portraitImageUrlStr;
@property (nonatomic , strong)UIImageView* tipImageView;//提示图片
@property (nonatomic,  strong)UIImageView *backgroundImageView; //背景

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic , strong)UILabel*  moveLabel;   //顶部分栏移动的 线条
//头部视图
@property (nonatomic , strong)UIView* topViewAndHeaderView;
/**顶部分栏*/
@property (nonatomic , strong)UIView* topView;
/**优惠券*/
@property (nonatomic , strong) UITableView* xjTableViewCoupon;
/**全免费*/
@property (nonatomic , strong) UITableView* xjTableViewAllFree;

/**全免费btn*/
@property (nonatomic , strong) UIButton* xjBtnAllFree;
/**优惠券的btn*/
@property (nonatomic , strong) UIButton* xjBtnCoupon;

/**背景*/
@property (nonatomic , weak)UIScrollView* scrollView;
/**当前选择的表格序号*/
@property (nonatomic , assign)NSInteger tableViewIndex;


/**我发布的 全免费可变数组*/
@property (nonatomic , strong)NSMutableArray* xjIssueAllFreeMuArr;
/**我发布的 优惠券的可变数组*/
@property (nonatomic , strong)NSMutableArray* xjIssueCouponMuArr;

/**商家号模型*/
@property (nonatomic , strong) FLBusAccountInfoModel* busAccountModel;
/**名称的button*/
@property (nonatomic , strong) UIButton* myNameButton;
/**消息列表View*/
@property (nonatomic , strong) XJPushMessagesBtn* xjHeaderMessageBtn;


/**头像下方三个label*/
@property (nonatomic , strong)XJBusTopViewNumberView*  xjTopNumberView;//头像下方三个 label

@end

@implementation XJBusinessMineViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatScrollView]; //底部scrollview
    [self creatTopViewAndHeaderView];//头视图+顶部分栏
    [self creatTableView];//创建tableView
    self.tableViewIndex = 40;
    _selectBtn = 1;
    [self setUpBtnColor:_selectBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.xjTableViewAllFree registerNib:[UINib nibWithNibName:@"XJMyIssueTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMyIssueTableViewCellnew"]; //全免费
    [self.xjTableViewCoupon registerNib:[UINib nibWithNibName:@"XJMyIssueTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMyIssueTableViewCellxjTableViewCoupon"]; //优惠券
    // 添加所有子控制器
    [self setUpUI];
    //header footer
    [self refreshHeaderAndFooterInMine];
    //    [self xjGetPushMessage];
    //     [self.flmyIssueTableView.mj_header beginRefreshing];
    [self getInfoMationInHTML]; //获取发布数等
    [self getFriendListInBusMinePage]; //获取好友列表
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //    [self seeUserInfo];
    [self seeAllUserInfo];
    _isViewWillAperar = YES;
    [self xjGetPushMessage];
    //    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
    
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    self.title = @"我的";
    [self getFriendListInBusMinePage]; //获取好友列表
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.tabBarController.tabBar.hidden = NO;
    if (FLFLIsPersonalAccountType) {
        _selectBtn = 1;
        [[FLAppDelegate share] setUpTabBar];
        [FLAppDelegate share].xjTabBar.selectedIndex = 2;
    }
}
#pragma  mark  ---- --- -- -------------         Lazy
- (UIView *)topViewAndHeaderView{
    if (!_topViewAndHeaderView) {
        //        _topViewAndHeaderView =[[XJMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height) topArr:@[@"我发布的",@"我领取的",@"我参与的",@"待评价的"]];
        _topViewAndHeaderView = [[UIView alloc] init];
        [self.view addSubview:_topViewAndHeaderView];
    }
    return _topViewAndHeaderView;
}
- (UITableView *)xjTableViewAllFree{
    if (!_xjTableViewAllFree) {
        _xjTableViewAllFree = [[UITableView alloc] init];
    }
    return _xjTableViewAllFree;
}
- (UITableView *)xjTableViewCoupon {
    if (!_xjTableViewCoupon) {
        _xjTableViewCoupon = [[UITableView alloc] init ];
    }
    return _xjTableViewCoupon;
}
- (XJBusTopViewNumberView *)xjTopNumberView{
    if (!_xjTopNumberView) {
        _xjTopNumberView = [[XJBusTopViewNumberView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 40)];
        _xjTopNumberView.xjItemsArr = @[@"发布数",@"粉丝数",@"热度"];
    }
    return _xjTopNumberView;
}

- (NSMutableArray *)xjIssueAllFreeMuArr {
    if (!_xjIssueAllFreeMuArr) {
        _xjIssueAllFreeMuArr = [NSMutableArray array];
    }
    return _xjIssueAllFreeMuArr;
}
- (NSMutableArray *)xjIssueCouponMuArr {
    if (!_xjIssueCouponMuArr) {
        _xjIssueCouponMuArr = [NSMutableArray array];
    }
    return _xjIssueCouponMuArr;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"我的";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_mine"];
    }
    return self;
}

- (void)setUpUI {
    
    UIColor * titleColor = [UIColor blackColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    self.title = @"我的";
    //导航栏背景
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_back_red"] forBarMetrics:UIBarMetricsDefault];
    
    //背景色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"status width - %f", rectStatus.size.width); // 宽度
    NSLog(@"status height - %f", rectStatus.size.height);   // 高度
    
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    NSLog(@"nav width - %f", rectNav.size.width); // 宽度
    NSLog(@"nav height - %f", rectNav.size.height);   // 高度
    
}
#pragma mark ----------Actions
- (void)GoToPersonalPage {
    FLMyPersonalDateTableViewController* myPersonalDataVC = [[FLMyPersonalDateTableViewController alloc]initWithNibName:@"FLMyPersonalDateTableViewController" bundle:nil];
    //    myPersonalDataVC.portraitImageUrlWithOutTapStr = self.flmineInfoModel.avatar;
    [self.navigationController pushViewController:myPersonalDataVC animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat testY ;
    //    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    UIColor* color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    }
    
    //movelabel移动功能
    if (scrollView == self.scrollView) {
        self.moveLabel.x = (scrollView.contentOffset.x / FLUISCREENBOUNDS.width) * FLUISCREENBOUNDS.width / 4;
        if (scrollView.contentOffset.x == 0) {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width  + 1;
            self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
            testY =  self.topViewAndHeaderView.frame.size.height;
            FL_Log(@"iiiiiiii1=%f",offsetY);
            if (self.xjIssueAllFreeMuArr.count == 0) {
                [self beginRefreshInMineViewController];
            }
        }  else if (scrollView.contentOffset.x == FLUISCREENBOUNDS.width) {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width + 1;
            self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
            testY =  self.topViewAndHeaderView.frame.size.height;
            FL_Log(@"iiiiiiii2=%f",offsetY);
            if (self.xjIssueCouponMuArr.count == 0) {
                [self beginRefreshInMineViewController];
            }
        }
        [self setUpBtnColor:_selectBtn];
        
    }
    //透视图上下滑动且能固定在某一位置
    fltopFrame = self.topViewAndHeaderView.frame;
    fltopViewH = self.topViewAndHeaderView.frame.size.height - FL_TopColumnView_Height;
    
    //    FL_Log(@"frame.orign.yin mine vc =%f=====%f====%f====%f",offsetY,FL_TopColumnView_Height,self.topViewAndHeaderView.frame.origin.y,self.topViewAndHeaderView.frame.size.height);
    if (_isViewWillAperar) {
        _isViewWillAperar = NO;
    } else {
        if (offsetY < 0)  {
        }  else {
            if (-offsetY - FL_TopColumnView_Height < -fltopViewH) {
                
                fltopFrame.origin.y = - fltopViewH + StatusBar_NaviHeight;
            }  else if (- offsetY - FL_TopColumnView_Height > 0)  {
                fltopFrame.origin.y = 0;
            } else  {
                fltopFrame.origin.y = -offsetY ;
            }
        }
    }
    [self.topViewAndHeaderView setFrame:fltopFrame];
}

- (void)setUpBtnColor:(NSInteger)selectedBtn {
    [self.xjBtnAllFree setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    [self.xjBtnCoupon setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    
    if (selectedBtn == 1)  {
        [self.xjBtnAllFree setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    } else if (selectedBtn == 2)  {
        [self.xjBtnCoupon setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    //    [self.xjTableViewAllFree reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self endRefreshInMineViewController];
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (tableView == self.xjTableViewAllFree){
        number = self.xjIssueAllFreeMuArr.count;
    } else if (tableView == self.xjTableViewCoupon) {
        number = self.xjIssueCouponMuArr.count;
        
    }
    return number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier;
    if (tableView == self.xjTableViewAllFree)  {
        CellIdentifier = @"XJMyIssueTableViewCellnew";
        XJMyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.xjIssueAllFreeMuArr.count != 0) {
            cell.flMyIssueInMineModel =  self.xjIssueAllFreeMuArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else  if (tableView == self.xjTableViewCoupon) {
        CellIdentifier = @"XJMyIssueTableViewCellxjTableViewCoupon";
        XJMyIssueTableViewCell *cellx = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.xjIssueCouponMuArr.count != 0) {
            cellx.flMyIssueInMineModel =  self.xjIssueCouponMuArr[indexPath.row];
        }
        cellx.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellx;
    }  else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FL_Log(@"dianle=%@",indexPath);
    if (tableView == self.xjTableViewAllFree)  {
        FLMyIssueActivityControlViewController* detailVC = [[FLMyIssueActivityControlViewController alloc] init];
        //此处模型为详情model
        FLMyIssueInMineModel* xjModel = self.xjIssueAllFreeMuArr.count >= indexPath.row ? self.xjIssueAllFreeMuArr[indexPath.row]:nil;
        detailVC.flmyIssueInMineModel = xjModel ;
        detailVC.xjTopicId = xjModel.flMineIssueTopicIdStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (tableView == self.xjTableViewCoupon) {
        FLMyIssueActivityControlViewController* receiveVC = [[FLMyIssueActivityControlViewController alloc] init];
        if (self.xjIssueCouponMuArr.count >= indexPath.row) {
            FLMyReceiveListModel* xjReceiveModel = self.xjIssueCouponMuArr[indexPath.row];
            receiveVC.xjTopicId = xjReceiveModel.flMineIssueTopicIdStr;
            [self.navigationController pushViewController:receiveVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.xjTableViewAllFree) {
        return 130;
    } else if (tableView == self.xjTableViewCoupon){
        return 130;
    }
    return 100;
}

#pragma mark -----tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark -----refaresh  全免费
//获取用于展示列表的数据 --- model 模型
- (void)getModelsInMineVCWithCurrentPage:(NSNumber*)currentPage {
    NSString* xjTopicType  = _selectBtn == 1 ? FLFLXJSquareAllFreeStrKey:FLFLXJSquareCouponseStrKey;
    FL_Log(@"w ciao zheshi shenm3e gui =%@ == %@",FL_USERDEFAULTS_USERID_NEW,FL_ALL_SESSIONID);
    NSDictionary* parm = @{@"page.currentPage":currentPage,
                           @"topic.userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"topic.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"token":FL_ALL_SESSIONID,
                           @"topic.topicType":xjTopicType,
                           @"topic.checkUserId":@""
                           };
    [FLNetTool searchTopicListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in tedast myversion2 issue=%@",data);
        NSMutableArray* dataMu = @[].mutableCopy;
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* newArray = [FLMineTools returnMyIssueInMineModelsWithDictionary:data type:_selectBtn];
            for (FLMyIssueInMineModel* model in newArray) {
                [dataMu addObject:model];
            }
            if (_selectBtn==1) {
                _xjTotalAllFree = [data[@"total"] integerValue];
                [self.xjIssueAllFreeMuArr addObjectsFromArray:dataMu];
                [self.xjTableViewAllFree reloadData];
            } else {
                _xjTotalCoupon = [data[@"total"] integerValue];
                [self.xjIssueCouponMuArr addObjectsFromArray:dataMu];
                [self.xjTableViewCoupon reloadData];
            }
            [self endRefreshInMineViewController];
        } else {
            [self endRefreshInMineViewController];
        }
    } failure:^(NSError *error) {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        [self endRefreshInMineViewController];
    }];
}

//刷新
- (void)refreshHeaderAndFooterInMine {
    self.xjTableViewAllFree.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjloadNewBusMine)];
    self.xjTableViewAllFree.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(xjloadMoreBusMine)];
    self.xjTableViewCoupon.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjloadNewBusMine)];
    self.xjTableViewCoupon.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(xjloadMoreBusMine)];
    [self beginRefreshInMineViewController];
}
#pragma mark ------------------ 下啦刷新
- (void)xjloadNewBusMine
{
    if (!FL_USERDEFAULTS_USERID_NEW ) {
        [self endRefreshInMineViewController];
    } else {
        switch (_selectBtn) {
            case 1:  {
                [self getModelsInMineVCWithCurrentPage:[NSNumber numberWithInteger:1]];
                [self.xjIssueAllFreeMuArr removeAllObjects];
            }
                break;
            case 2: {
                [self.xjIssueCouponMuArr removeAllObjects];
                [self getModelsInMineVCWithCurrentPage:@1];
            }
                break;
            default:
                break;
        }
        
    }
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
    
}
//上拉加载
- (void)xjloadMoreBusMine {
    if (_selectBtn == 1) {
        NSNumber* xj = [FLTool xjRetuenCurrentWithArrLength:self.xjIssueAllFreeMuArr.count andTotal:_xjTotalAllFree xjSize:0];
        [self getModelsInMineVCWithCurrentPage:xj];
    } else if(_selectBtn == 2) {
        NSNumber* xj = [FLTool xjRetuenCurrentWithArrLength:self.xjIssueCouponMuArr.count andTotal:_xjTotalCoupon xjSize:0];
        [self getModelsInMineVCWithCurrentPage:xj];
    }
}
#pragma mark 刷新
//开始刷新
- (void)beginRefreshInMineViewController {
    
    if (_selectBtn == 1) {
        [self.xjIssueAllFreeMuArr removeAllObjects];
        [self.xjTableViewAllFree.mj_header beginRefreshing];
    } else if(_selectBtn == 2) {
        [self.xjIssueCouponMuArr removeAllObjects];
        [self.xjTableViewAllFree.mj_header beginRefreshing];
    }
}

//结束刷新
- (void)endRefreshInMineViewController{
    [self.xjTableViewAllFree.mj_header endRefreshing];
    [self.xjTableViewCoupon.mj_header endRefreshing];
    if (_selectBtn==1) {
        if (_xjTotalAllFree ==self.xjIssueAllFreeMuArr.count) {
            [self.xjTableViewAllFree.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.xjTableViewAllFree.mj_footer endRefreshing];
        }
    } else if (_selectBtn==2) {
        if (_xjTotalCoupon ==self.xjIssueCouponMuArr.count) {
            [self.xjTableViewCoupon.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.xjTableViewCoupon.mj_footer endRefreshing];
        }
    }
}


#pragma mark- --------Actions
//顶部分栏的点击效果
- (void)topBtnClick:(id)sender
{
    NSLog(@"慢慢来");
    UIButton* btn = (UIButton*)sender;
    self.tableViewIndex = btn.tag;
    switch (btn.tag)  {
        case 40:  {
            _selectBtn = 1;
            self.xjTableViewAllFree.hidden = NO;
            [self moveLabel:0];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(0, 0);
                NSLog(@"点了1");
                if (self.xjIssueAllFreeMuArr.count == 0) {
                    [self beginRefreshInMineViewController];
                }
            }];
        }
            break;
        case 41:  {
            _selectBtn = 2;
            self.xjTableViewCoupon.hidden = NO;
            [self moveLabel:1];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(FLUISCREENBOUNDS.width, 0);
                NSLog(@"点了2");
            }];
            if (self.xjIssueCouponMuArr.count == 0) {
                [self beginRefreshInMineViewController];
            }
        }
            break;
        default:
            break;
    }
}
//移动label的动作，判断发请求
- (void)moveLabel:(NSInteger)index {
    for (NSInteger i = 0; i < 4; i++)  {
        UIButton* btn = (UIButton*)[self.view viewWithTag:40 + i];
        if (i != index) {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else  {
            [btn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.moveLabel.frame =  CGRectMake(self.topView.frame.size.width / 4 * index, self.topView.frame.size.height - 2, self.topView.frame.size.width / 4, 2);
    } completion:nil];
    if (index == 1) {
        //        [self getAllFreeData:1];
        NSLog(@"index ==  %ld",(long)self.tableViewIndex);
    }
}

#pragma mark--------init
//创建底部scrollView

- (void)creatScrollView {
    CGFloat scrollX = 0;
    CGFloat scrollY = 0;//FL_TopColumnView_Height ;//CGRectGetMaxX(self.topView.frame);
    CGFloat scrollW = FLUISCREENBOUNDS.width;
    CGFloat scrollH = FLUISCREENBOUNDS.height - 49;
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollX, scrollY, scrollW, scrollH)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width * 4, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.bounces = NO;
}

#pragma mark------setUpUI ----顶部分栏
- (void)creatTopViewAndHeaderView {
    //蒙版view
    UIImageView* xjImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jianbian_bg_deper"]];
    //头视图
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height * 0.33)];
    self.backgroundImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"mine_back"];
    self.headerVIew = [[UIView alloc] initWithFrame:self.backgroundImageView.frame];
    [self.headerVIew addSubview:self.backgroundImageView];
    xjImage.frame = self.headerVIew.frame;
    [self.headerVIew addSubview:xjImage];
    //    [self.headerVIew addSubview:self.portraitBtn];
    [self.topViewAndHeaderView addSubview:self.headerVIew];
    
    
    //头像按钮，点击进入设置
    self.portraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
    self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

    [self.portraitBtn setBackgroundImage:[UIImage imageNamed:@"xj_default_avator"] forState:UIControlStateNormal];
    self.portraitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.portraitBtn.layer.cornerRadius = 60 * FL_SCREEN_PROPORTION_width;
    self.portraitBtn.backgroundColor = [UIColor whiteColor];
    self.portraitBtn.layer.masksToBounds = YES;  //解决圆形button 添加图片溢出后的问题
    [self.portraitBtn addTarget:self action:@selector(GoToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
    [self.headerVIew addSubview:self.portraitBtn];
    [self.portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView).with.offset(0);
        make.centerY.equalTo(self.backgroundImageView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(120 * FL_SCREEN_PROPORTION_width, 120 * FL_SCREEN_PROPORTION_width));
    }];
    //头像下方名字btn
    self.myNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.myNameButton setTitle:@"nickName" forState:UIControlStateNormal];
    [self.myNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.myNameButton.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    [self.myNameButton addTarget:self action:@selector(GoToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
    [self.headerVIew addSubview:self.myNameButton];
    [self.myNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitBtn.mas_bottom).with.offset(-5 * FL_SCREEN_PROPORTION_height);
        make.centerX.equalTo(self.headerVIew).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width / 2, 40));
    }];
    //名字下方 label
    [self.topViewAndHeaderView addSubview:self.xjTopNumberView];
    [self.xjTopNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myNameButton.mas_bottom).with.offset(-5 * FL_SCREEN_PROPORTION_height);
        make.centerX.equalTo(self.headerVIew).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width, 40));
    }];
    
    // 消息列表按钮
    self.xjHeaderMessageBtn = [[XJPushMessagesBtn alloc ] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width - 35, 30, 50, 50)];
    //    [self.headerVIew addSubview:self.xjHeaderMessageBtn];
    [self.xjHeaderMessageBtn.xjBtn addTarget:self action:@selector(clickToGoToPushMessagePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bellItem = [[UIBarButtonItem alloc] initWithCustomView:self.xjHeaderMessageBtn];
    [self.navigationItem setRightBarButtonItem:bellItem];
    //    [self.xjHeaderMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.headerVIew.mas_right).with.offset(-35);
    //        make.top.equalTo(self.topViewAndHeaderView ).with.offset(25);
    //        make.size.mas_equalTo(CGSizeMake(40 , 40));
    //    }];
    
    //顶部分栏
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerVIew.size.height, FLUISCREENBOUNDS.width, FL_TopColumnView_Height)];
    //创建顶部分栏下面的细线
    UIView* viewUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0, FL_TopColumnView_Height-1, FLUISCREENBOUNDS.width, 1)];
    viewUnderLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.topView addSubview:viewUnderLine];
    FL_Log(@"test heigh =%f",FL_TopColumnView_Height);
    NSArray* array = @[@"全免费",@"优惠券"];
    for (NSInteger i = 0; i < [array count]; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0 + self.topView.frame.size.width / 2 * i, 0, self.topView.frame.size.width / 2, 80* FL_SCREEN_PROPORTION_height);
        btn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
        btn.tag = 40 + i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topView addSubview:btn];
        if (i == 0) {
            self.xjBtnAllFree = btn;
        } else if ( i == 1) {
            self.xjBtnCoupon = btn;
        }
    }
    //    中间分割线
    for (NSInteger i  = 0; i < 2 ; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topView.frame.size.width / 2 * (i + 1), 6, 0.5, 50* FL_SCREEN_PROPORTION_height)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.alpha = 0.7;
        [self.topView addSubview:imageView];
    }
    self.moveLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height - 2, self.topView.frame.size.width / 2, 2)];
    //    self.moveLabel.backgroundColor = [UIColor colorWithHexString:@"#ff3e3e"];
    [self.topView addSubview:self.moveLabel];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.topViewAndHeaderView addSubview:self.topView];
    
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
}

- (void)creatTableView {
    //我发布的
    self.xjTableViewAllFree.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height);
    
    [self.xjTableViewAllFree setContentInset:UIEdgeInsetsMake(self.topViewAndHeaderView.height, 0, 0, 0)];
    self.xjTableViewAllFree.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.xjTableViewAllFree.backgroundColor = [UIColor clearColor];
    self.xjTableViewAllFree.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview: _xjTableViewAllFree];
    self.xjTableViewAllFree.hidden = NO;
    self.xjTableViewAllFree.delegate = self;
    self.xjTableViewAllFree.dataSource = self;
    
    
    self.xjTableViewCoupon.frame = CGRectMake(FLUISCREENBOUNDS.width, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height);
    [self.xjTableViewCoupon setContentInset:UIEdgeInsetsMake(self.topViewAndHeaderView.height, 0, 0, 0)];
    self.xjTableViewCoupon.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.self.xjTableViewCoupon.backgroundColor = [UIColor clearColor];
    _xjTableViewCoupon.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview: self.xjTableViewCoupon];
    self.xjTableViewCoupon.hidden = NO;
    self.xjTableViewCoupon.delegate = self;
    self.xjTableViewCoupon.dataSource = self;
}


#pragma mark- ------usernet

- (void)seeAllUserInfo {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* parmBus =@{@"token": FLFLBusSesssionID,
                             @"accountType": FLFLXJUserTypeCompStrKey};
    FL_Log(@"see info :sesssionId = %@ ",parmBus);
    [FLNetTool seeInfoWithParm:parmBus success:^(NSDictionary *data) {
        FL_Log(@"see info in getuserminessbus tool success=%@, avatar = %@",data,[data objectForKey:@"avatar"]);
        if (data) {
            self.busAccountModel = [FLTool flNewGetBusAccountInfoModelWithDic:data];
            //                FLFLXJBusinessUserHeaderImageURLStr = self.busAccountModel.busHeaderImageStr;
            FLFLXJBusinessUserHeaderImageURLStr = [NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:self.busAccountModel.busHeaderImageStr isSite:NO]];
            self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
            self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

            [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.busAccountModel.busHeaderImageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                UIImage* imageTuUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
                self.backgroundImageView.image = imageTuUse;
            }];
            
            
            [self.myNameButton setTitle:self.busAccountModel.busSimpleName forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"see info in mine failure=%@,%@",error.description,error.debugDescription);
    }];
    [FLTool xjSetJpushAlias];
}

- (void)clickToGoToPushMessagePage{
    XJPushMessageListViewController* xjPushVC = [[XJPushMessageListViewController alloc] init];
    [self.navigationController pushViewController:xjPushVC animated:YES];
}


- (void)xjGetPushMessage {
    NSDictionary* parm = @{@"msgPush.targetUserId":XJ_USERID_WITHTYPE,
                           @"msgPush.targetUserType":XJ_USERTYPE_WITHTYPE,
                           @"types":@"1,6,7,8"};
    [FLNetTool xjGetPushMessagesByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the p3ush message that i don't read =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            XJPushMessageListModel* xjxj = [XJPushMessageListModel mj_objectWithKeyValues:data];
            self.xjHeaderMessageBtn.xjBadges = xjxj.count1 + xjxj.count6 + xjxj.count7 + xjxj.count8;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -----------获取发布者数据
- (void)getInfoMationInHTML {
    NSDictionary* parm = @{@"topic.userId":FLFLXJBusinessUserID,
                           @"topic.userType":FLFLXJUserTypeCompStrKey,
                           @"token":FLFLBusSesssionID,
                           @"topic.checkUserId":@""};
    [FLNetTool flHTMLGetPublisherMessageByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my test nbus mine othis thing=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjTopNumberView.xjHotStr = [NSString stringWithFormat:@"%@",data[@"pvNum"] ? data[@"pvNum"] : @"0"];
            self.xjTopNumberView.xjIssueStr = [NSString stringWithFormat:@"%@",data[@"num"] ? data[@"num"]   : @"0"];
        }
        
    } failure:^(NSError *error) {
        
        FL_Log(@"this is my test nothis thing=%@",error);
    }];
}

- (void)getFriendListInBusMinePage{
    if (![[EaseMob sharedInstance].chatManager  isLoggedIn]) {
        //自动登录环信
        NSString *userName = [NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE];
        NSLog(@"cyuser的撒大大打的撒 id %@",userName);
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:@"123456" completion:^
         (NSDictionary *loginInfo, EMError *error) {
             if (!error && loginInfo) {
                 FL_Log(@"登录成功With s 环信=%@",userName);
                 NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
                 self.xjTopNumberView.xjFriendStr = buddyList ? [NSString stringWithFormat:@"%ld",buddyList.count] :@"0";
             }
         } onQueue:nil];
        // 设置自动登录
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        [FLTool xjSaveLastLoginUsernameInTool]; // 保存一下，以后会用得到
        
    }
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    self.xjTopNumberView.xjFriendStr = buddyList ? [NSString stringWithFormat:@"%ld",buddyList.count] :@"0";
}


@end
























