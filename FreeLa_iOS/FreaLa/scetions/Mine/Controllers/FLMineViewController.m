//
//  FLMineViewController.m
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//  12-14日更改，界面布局为头部视图+scrollview + 4个tableview

#import "FLMineViewController.h"
#import "XJMyCollectionViewController.h"
#import "FLFuckHtmlViewController.h"
#import "XJRejudgePJBcakViewController.h"
#import "YYKit.h"
#import "FLMyPersonalDateTableViewController.h"
#import "XJMyIssueTableViewCell.h"
#import "XJMyReceiveTableViewCell.h"
#import "XJPushMessageListViewController.h"
#import "XJPushMessagesBtn.h"
#import "XJPushMessageListModel.h"
#import "XJMineHeaderView.h"
#import "XJFreelaUVManager.h"

#define xjTag      10010
@interface FLMineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,XJRejudgePJBcakViewControllerDelegate>
{
    NSInteger _selectBtn; //标记点了的按钮，我发布的、我领取的、我参与的、收藏
    NSInteger _currentPageMyIssue; //我发布的当前页
    NSInteger _currentPageMyPick ;//我领取的当前页
    NSInteger _currentPageMyPartIn; //我参与的当前页
    NSInteger _currentPageMyWeaitPJ; //待评价的当前页
    //    NSInteger _currentPageMyPick ;//我领取的当前页
    NSInteger _xjTotalMyIssue; //我发布的 总数
    NSInteger _xjTotalMyPick; //我领取的 总数
    NSInteger _xjTotalMyPartIn; //我参与的 总数
    NSInteger _xjTotalMyWeatJudge; //待评价的 总数
    
    NSArray* _xjCurrentPageArr;     //所有当前页
    
    NSDictionary* _myReceiveData; //获取到的我发布的字典
    
    
    CGRect fltopFrame;  //用于计算移动距离
    CGFloat fltopViewH;
    
    BOOL _isViewWillAperar;   //没办法了
    //    BOOL _isFirstInitPagePick;    // 我领取的是不是第一次点进来
    
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
/**我发布的*/
@property (nonatomic , strong) XJTableView* flmyIssueTableView;
/**我领取的*/
@property (nonatomic , strong) XJTableView* flmyPickUpTableView;
/**我参与的*/
@property (nonatomic , strong) XJTableView* flmyPartInTopicTableView;
/**待评价的*/
@property (nonatomic , strong) XJTableView* flmyWeaitPJTableView;



/**我发布的btn*/
@property (nonatomic , strong) UIButton* flmyIssueBtn;
/**我领取的btn*/
@property (nonatomic , strong)UIButton* flmyPickUpBtn;
/**我参与的btn*/
@property (nonatomic , strong)UIButton* flmyWaitJudgeBtn;
/**待评价的*/
@property (nonatomic , strong)UIButton* flmyWeaitPJBtn;

/**背景*/
@property (nonatomic , weak)UIScrollView* scrollView;
/**当前选择的表格序号*/
@property (nonatomic , assign)NSInteger tableViewIndex;


/**我发布的可变数组*/
@property (nonatomic , strong)NSMutableArray* flMyIssueInMineModelMus;

/**我发布的用于详情界面的可变数组*/
@property (nonatomic , strong)NSMutableArray* flMyIssueInMineMuDicArray;
/**我发布的用于详情界面的不可变数组*/
@property (nonatomic , strong)NSArray* flMyIssueInMineDicArray;

/**我领取的可变数组*/
@property (nonatomic , strong)NSMutableArray* flMyReceiveInMineModelMus;

/**我参与的数组*/
@property (nonatomic , strong) NSMutableArray * xjMyParticipateNotReceiveArr;
/**待评价的数组*/
@property (nonatomic , strong) NSMutableArray * xjMyWeaitPJModelArr;
/**商家号模型*/
@property (nonatomic , strong) FLBusAccountInfoModel* busAccountModel;

/**4个tablev数组*/
@property (nonatomic , strong) NSArray* flTableViewArray;

/**名称的button*/
@property (nonatomic , strong) UIButton* myNameButton;
/**收藏的button*/
@property (nonatomic , strong) UIButton* xjCollectionBtn;
/**消息列表View*/
@property (nonatomic , strong) XJPushMessagesBtn* xjHeaderMessageBtn;

@property(nonatomic,strong)NSString*my_userId;

@end



@implementation FLMineViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.my_userId =  [[NSUserDefaults standardUserDefaults] objectForKey:FL_USERDEFAULTS_USERID_KEY];
;
    [self creatScrollView]; //底部scrollview
    [self creatTopViewAndHeaderView];//头视图+顶部分栏
    [self creatTableView];//创建tableView
    self.tableViewIndex = 40;
    _selectBtn = 1;
    [self setUpBtnColor:_selectBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.flmyPartInTopicTableView registerNib:[UINib nibWithNibName:@"XJMyIssueTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMyIssueTableViewCell"];//我参与的
    [self.flmyWeaitPJTableView registerNib:[UINib nibWithNibName:@"XJMineCusTomTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMineCusTomTwoTableViewCell"]; //待评价的
    [self.flmyPickUpTableView registerNib:[UINib nibWithNibName:@"XJMyReceiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMyReceiveTableViewCell"]; //我领取的
    [self.flmyIssueTableView registerNib:[UINib nibWithNibName:@"XJMyIssueTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMyIssueTableViewCell"]; //我发布的
    
    // 添加所有子控制器
    [self setUpUI];
    //header footer
    [self refreshHeaderAndFooterInMine];
    //     [self.flmyIssueTableView.mj_header beginRefreshing];
    [self getDetailInfoDataInMyIssueView];
    self.flMyIssueInMineModelMus = [NSMutableArray array];
    self.flMyIssueInMineMuDicArray = [NSMutableArray array];
    self.flMyReceiveInMineModelMus = [NSMutableArray array];
    self.xjMyParticipateNotReceiveArr = [NSMutableArray array];
    self.xjMyWeaitPJModelArr = [NSMutableArray array];
    //更改了账户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjChangeAccountNoti) name:XJNotiOfQuitOrChangeAccountMessage object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSString*str=[NSString stringWithFormat:@"%ld",[[[NSUserDefaults standardUserDefaults] objectForKey:FL_USERDEFAULTS_USERID_KEY]integerValue]];
    if (![self.my_userId isEqualToString:str]) {
        self.view=nil;
    }
    //    [self seeUserInfo];
    [self seeAllUserInfo];
    _isViewWillAperar = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
    
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    self.title = @"我的";
    self.flmyIssueTableView.delegate = self;
    [self scrollViewDidScroll:self.flmyIssueTableView];
    [self xjGetPushMessage];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.tabBarController.tabBar.hidden = NO;
    if (!FLFLIsPersonalAccountType) {
        _selectBtn = 1;
        //        [self beginRefreshInMineViewController];
        //        [self.scrollView removeAllSubviews];
        [[FLAppDelegate share] setUpTabBar];
        [FLAppDelegate share].xjTabBar.selectedIndex = 2;
    }
//    if (![self.my_userId isEqualToString:FL_USERDEFAULTS_USERID_KEY]) {
//        self.my_userId=FL_USERDEFAULTS_USERID_KEY;
//        [self.flMyIssueInMineModelMus removeAllObjects];
//        [self.flMyIssueInMineMuDicArray removeAllObjects];
//        [self.flMyReceiveInMineModelMus removeAllObjects];
//        [self.xjMyParticipateNotReceiveArr removeAllObjects];
//        [self.xjMyWeaitPJModelArr removeAllObjects];
//        [self.flmyIssueTableView reloadData];
//        [self.flmyPickUpTableView reloadData];
//        [self.flmyPartInTopicTableView reloadData];
//        [self.flmyWeaitPJTableView reloadData];
//
//    }
}
#pragma  mark  ---- --- -- -------------         Lazy
- (UIView *)topViewAndHeaderView{
    if (!_topViewAndHeaderView) {
        //        _topViewAndHeaderView =[[XJMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height) topArr:@[@"我发布的",@"我领取的",@"我参与的",@"待评价的"]];
        _topViewAndHeaderView = [[UIView alloc] init];
    }
    return _topViewAndHeaderView;
}
- (XJTableView *)flmyIssueTableView {
    if (!_flmyIssueTableView ) {
        _flmyIssueTableView = [[XJTableView alloc] init];
    }
    return _flmyIssueTableView;
}
- (XJTableView *)flmyPickUpTableView {
    if (!_flmyPickUpTableView) {
        _flmyPickUpTableView =[[XJTableView alloc] init];
    }
    return _flmyPickUpTableView;
}
- (XJTableView *)flmyPartInTopicTableView{
    if (!_flmyPartInTopicTableView) {
        _flmyPartInTopicTableView =[[XJTableView alloc] init];
    }
    return _flmyPartInTopicTableView;
}
- (XJTableView *)flmyWeaitPJTableView{
    if (!_flmyWeaitPJTableView) {
        _flmyWeaitPJTableView =[[XJTableView alloc] init];
    }
    return _flmyWeaitPJTableView;
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
    
    _currentPageMyIssue  = 1;
    _currentPageMyPick   = 1;
    _currentPageMyPartIn = 1;
    _currentPageMyWeaitPJ = 1;
    _xjCurrentPageArr = @[[NSNumber numberWithInteger:_currentPageMyIssue],[NSNumber numberWithInteger:_currentPageMyPick],[NSNumber numberWithInteger:_currentPageMyPartIn]];
}
#pragma mark ----------Actions
- (void)GoToPersonalPage
{
    
    FLMyPersonalDateTableViewController* myPersonalDataVC = [[FLMyPersonalDateTableViewController alloc]initWithNibName:@"FLMyPersonalDateTableViewController" bundle:nil];
    
    myPersonalDataVC.portraitImageUrlWithOutTapStr = self.flmineInfoModel.avatar;
    //    myPersonalDataVC.busAccountModel = self.busAccountModel;
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
        [self.xjHeaderMessageBtn changeImageWithBool:YES];
        [self.xjCollectionBtn setImage:[UIImage imageNamed:@"btn_collection_gray_version2"] forState:UIControlStateNormal];
        //        [self endRefreshInMineViewController];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [self.xjHeaderMessageBtn changeImageWithBool:NO];
        [self.xjCollectionBtn setImage:[UIImage imageNamed:@"btn_collection_white_version2"] forState:UIControlStateNormal];
    }
    
    //movelabel移动功能
    if (scrollView == self.scrollView) {
        self.moveLabel.x = (scrollView.contentOffset.x / FLUISCREENBOUNDS.width) * FLUISCREENBOUNDS.width / 4;
        if (scrollView.contentOffset.x == 0) {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width  + 1;
            self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
            testY =  self.topViewAndHeaderView.frame.size.height;
            FL_Log(@"iiiiiiii1=%f",offsetY);
        }  else if (scrollView.contentOffset.x == FLUISCREENBOUNDS.width) {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width + 1;
            self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
            testY =  self.topViewAndHeaderView.frame.size.height;
            FL_Log(@"iiiiiiii2=%f",offsetY);
            if (self.flMyReceiveInMineModelMus.count == 0) {
                [self beginRefreshInMineViewController];
            }
        }  else if (scrollView.contentOffset.x == FLUISCREENBOUNDS.width * 2)  {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width +1;
            self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
            testY =  self.topViewAndHeaderView.frame.size.height;
            FL_Log(@"iiiiiii3i=%f",offsetY);
            if (self.xjMyParticipateNotReceiveArr.count == 0) {
                [self beginRefreshInMineViewController];
            }
        }  else if (scrollView.contentOffset.x == FLUISCREENBOUNDS.width * 3) {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width +1;
            self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
            testY =  self.topViewAndHeaderView.frame.size.height;
            FL_Log(@"iiiiiiii4=%f",offsetY);
            if (self.xjMyWeaitPJModelArr.count == 0) {
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
    [self.flmyIssueBtn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    [self.flmyPickUpBtn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    [self.flmyWaitJudgeBtn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    [self.flmyWeaitPJBtn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    if (selectedBtn == 1)  {
        [self.flmyIssueBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    } else if (selectedBtn == 2)  {
        [self.flmyPickUpBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    }  else if (selectedBtn == 3) {
        [self.flmyWaitJudgeBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    }   else if (selectedBtn == 4) {
        [self.flmyWeaitPJBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [self.flmyIssueTableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    //seeinfo
    //    [self seeUserInfo];
    [super viewWillDisappear:animated];
    self.flmyIssueTableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
    [self endRefreshInMineViewController];
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (tableView == self.flmyIssueTableView){
        number = self.flMyIssueInMineModelMus.count;
    } else if (tableView == self.flmyPickUpTableView) {
        number = self.flMyReceiveInMineModelMus.count;
        
    } else  if (tableView == self.flmyPartInTopicTableView){
        number = self.xjMyParticipateNotReceiveArr.count;
    } else if (tableView == self.flmyWeaitPJTableView) {
        number = self.xjMyWeaitPJModelArr.count;
        FL_Log(@"adsadsadasdsadsadsadsadasdsadsadsad=%ld ===%ld",number,_selectBtn);
    }
    return number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier;
    if (tableView == self.flmyIssueTableView)  {
        CellIdentifier = @"XJMyIssueTableViewCell";
        XJMyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.flMyIssueInMineModelMus.count != 0) {
            cell.flMyIssueInMineModel =  self.flMyIssueInMineModelMus[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else  if (tableView == self.flmyPickUpTableView) {
        CellIdentifier = @"XJMyReceiveTableViewCell";
        XJMyReceiveTableViewCell *cellx = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.flMyReceiveInMineModelMus.count != 0) {
            cellx.flMyReceiveListModel =  self.flMyReceiveInMineModelMus[indexPath.row];
        }
        cellx.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellx;
    }  else  if (tableView == self.flmyPartInTopicTableView) {
        CellIdentifier = @"XJMyIssueTableViewCell";
        XJMyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.xjMyParticipateNotReceiveArr.count != 0) {
            cell.xjMyPartInInfoModel =  self.xjMyParticipateNotReceiveArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }  else  if (tableView == self.flmyWeaitPJTableView)  {
        CellIdentifier = @"XJMineCusTomTwoTableViewCell";   //xjMyWeaitPJModelArr
        XJMineCusTomTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.xjPJBtn.tag = xjTag + indexPath.row;
        [cell.xjPJBtn addTarget:self action:@selector(clickToPJTopic:) forControlEvents:UIControlEventTouchUpInside];
        if (self.xjMyWeaitPJModelArr.count != 0) {
            cell.xjWeaitPJModel =  self.xjMyWeaitPJModelArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }  else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FL_Log(@"dianle=%@",indexPath);
    if (tableView == _flmyIssueTableView)  {
        FLMyIssueActivityControlViewController* detailVC = [[FLMyIssueActivityControlViewController alloc] init];
        [self getIssueInfoDataForAgainWithIndexPath:indexPath.row];
        //此处模型为详情model
        detailVC.flIssueInfoModelDic =self.flMyIssueInMineDicArray.count >= indexPath.row ? self.flMyIssueInMineDicArray[indexPath.row]:nil;
        FLMyIssueInMineModel* xjModel = self.flMyIssueInMineModelMus.count >= indexPath.row ? self.flMyIssueInMineModelMus[indexPath.row]:nil;
        detailVC.flmyIssueInMineModel = xjModel ;
        detailVC.xjTopicId = xjModel.flMineIssueTopicIdStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (tableView == _flmyPickUpTableView) {
        FLMyReceiveControlViewController* receiveVC = [[FLMyReceiveControlViewController alloc] init];
        if (self.flMyReceiveInMineModelMus.count >= indexPath.row) {
            FLMyReceiveListModel* xjReceiveModel = self.flMyReceiveInMineModelMus[indexPath.row];
            receiveVC.xjTopicId = xjReceiveModel.flMineIssueTopicIdStr;
            receiveVC.xjDetailsId = xjReceiveModel.flDetailsIdStr;
            [self.navigationController pushViewController:receiveVC animated:YES];
        }
    } else if (tableView == _flmyPartInTopicTableView) {
        FLFuckHtmlViewController* receiveVC = [[FLFuckHtmlViewController alloc] init];
        XJMyPartInInfoModel* model = self.xjMyParticipateNotReceiveArr.count >= indexPath.row ?self.xjMyParticipateNotReceiveArr[indexPath.row]:nil;
        receiveVC.flFuckTopicId = model.flMineIssueTopicIdStr;
        [self.navigationController pushViewController:receiveVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.flmyIssueTableView || tableView == self.flmyPickUpTableView  ) {
        return 130 ;
    } else if (tableView == self.flmyPartInTopicTableView) {
        return 130 ;
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


#pragma mark -----refaresh我发布的
//获取用于展示列表的数据 --- model 模型
- (void)getModelsInMineVCWithCurrentPage:(NSNumber*)currentPage {
    FL_Log(@"w ciao zheshi shen2me gui =%@ == %@",FL_USERDEFAULTS_USERID_NEW,FL_ALL_SESSIONID);
    NSDictionary* parm = @{@"page.currentPage":currentPage,
                           @"topic.userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"topic.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"token":FL_ALL_SESSIONID,
                           @"topic.checkUserId":@""
                           };
    
    [FLNetTool searchTopicListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in tess t my issue=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _myReceiveData = data;
            _xjTotalMyIssue = [data[@"total"] integerValue];
            NSArray* dataArray = data[FL_NET_DATA_KEY];
            NSArray* newArray = [FLMineTools returnMyIssueInMineModelsWithDictionary:data type:_selectBtn];
            for (FLMyIssueInMineModel* model in newArray) {
                [self.flMyIssueInMineModelMus addObject:model];
            }
            //            self.flMyIssueInMineModelMus = [self.flMyIssueInMineModelMus mutableCopy];
            [self getHTMLDicInMyIssueWithArr:dataArray]; //用于详情数据的字典，不过需要重新请求接口
            [self.flmyIssueTableView reloadData];
            [self endRefreshInMineViewController];
            [FLTool xjSetEmptyStateWithTotal:_xjTotalMyIssue with:self.flmyIssueTableView]; //设置空白状态
        } else {
            [self endRefreshInMineViewController];
        }
    } failure:^(NSError *error) {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        [self endRefreshInMineViewController];
        [FLTool xjSetEmptyStateWithTotal:_xjTotalMyIssue with:self.flmyIssueTableView]; //设置空白状态
    }];
    
}
//获取用于详情的数据 --- dictionary
- (void)getHTMLDicInMyIssueWithArr:(NSArray* )array {
    for (NSDictionary* dic in array)
    {
        [self.flMyIssueInMineMuDicArray addObject:dic];
    }
    self.flMyIssueInMineDicArray = [self.flMyIssueInMineMuDicArray mutableCopy];
}

#pragma mark -----我领取的
//展示用
- (void)getMyReceiveTopicListWithCurrentPage:(NSInteger)currentPage {
    NSDictionary* parm = @{@"participateDetailes.userId":XJ_USERID_WITHTYPE,
                           @"participateDetailes.userType":XJ_USERTYPE_WITHTYPE ,
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID],
                           @"page.currentPage":[NSString stringWithFormat:@"%ld",currentPage]};
    //我领取的
    [FLNetTool searchTopicReceiveListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in t2est my issue2=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _myReceiveData = data;
            _xjTotalMyPick = [data[@"total"] integerValue];
            NSArray* newArray = [FLMineTools returnMyIssueInMineModelsWithDictionary:data type:_selectBtn];
            for (FLMyReceiveListModel* model in newArray) {
                [self.flMyReceiveInMineModelMus addObject:model];
            }
            [self.flmyPickUpTableView reloadData];
            [self endRefreshInMineViewController];
        } else {
            [self endRefreshInMineViewController];
        }
        [FLTool xjSetEmptyStateWithTotal:_xjTotalMyPick with:self.flmyPickUpTableView];//设置空白状态
    } failure:^(NSError *error) {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        [self endRefreshInMineViewController];
        [FLTool xjSetEmptyStateWithTotal:_xjTotalMyPick with:self.flmyPickUpTableView];//设置空白状态
    }];
    
}
#pragma mark -----我参与的
- (void)getfindParticipateNotReceiveByParmCurrentPage:(NSInteger)currentPage {
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"topic.userType":XJ_USERTYPE_WITHTYPE,
                           @"topic.userId":XJ_USERID_WITHTYPE,
                           @"page.currentPage":[NSNumber numberWithInteger:currentPage]};
    [FLNetTool xjfindParticipateNotReceiveByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in test my wocanyude =%@",data);
        _myReceiveData = data;
        _xjTotalMyPartIn = [data[@"total"] integerValue];
        if ([data[FL_NET_KEY_NEW] boolValue])  {
            NSArray* newArray = [FLMineTools returnMyIssueInMineModelsWithDictionary:data type:_selectBtn];
            for (XJMyPartInInfoModel* model in newArray)
            {
                [self.xjMyParticipateNotReceiveArr addObject:model];
            }
            [self.flmyPartInTopicTableView reloadData];
            [self endRefreshInMineViewController];
        }
        [FLTool xjSetEmptyStateWithTotal:_xjTotalMyPartIn with:self.flmyPartInTopicTableView]; //设置空白状态
    } failure:^(NSError *error) {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        [self endRefreshInMineViewController];
        [FLTool xjSetEmptyStateWithTotal:_xjTotalMyPartIn with:self.flmyPartInTopicTableView]; //设置空白状态
    }];
    
}

#pragma mark ---------- 待评价的
- (void)getuserTopicListByCommentByCurrent:(NSInteger)current {
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"topic.userId":XJ_USERID_WITHTYPE,
                           @"topic.userType":XJ_USERTYPE_WITHTYPE,
                           @"page.currentPage":[NSNumber numberWithInteger:current]};
    [FLNetTool xjuserTopicListByCommentByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in test my daipingjia d =%@",data);  //xjMyWeaitPJModelArr
        _myReceiveData = data;
        _xjTotalMyWeatJudge = [data[@"total"] integerValue];
        if ([data[FL_NET_KEY_NEW] boolValue])  {
            NSArray* newArray = [FLMineTools returnMyIssueInMineModelsWithDictionary:data type:_selectBtn];
            for (XJMyWeaitPJModel* model in newArray) {
                [self.xjMyWeaitPJModelArr addObject:model];
            }
        }
        [self.flmyWeaitPJTableView reloadData];
        [self endRefreshInMineViewController];
        [FLTool xjSetEmptyStateWithTotal:_xjTotalMyWeatJudge with:self.flmyWeaitPJTableView]; //设置空白状态
    } failure:^(NSError *error) {
        [self endRefreshInMineViewController];
        [FLTool showWith:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]]];
    }];
    [FLTool xjSetEmptyStateWithTotal:_xjTotalMyWeatJudge with:self.flmyWeaitPJTableView]; //设置空白状态
}

//刷新
- (void)refreshHeaderAndFooterInMine {
    for (UITableView* fltableview in _flTableViewArray) {
        fltableview.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewMyIssue)];
        MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataInTableViewMyIssueSMG)];
        fltableview.mj_footer = footer;
    }
    [self beginRefreshInMineViewController];
}
#pragma mark ------------------ 下啦刷新
- (void)loadNewDataWithTableViewMyIssue
{
    if (!FL_USERDEFAULTS_USERID_NEW ) {
        [self endRefreshInMineViewController];
    } else {
        switch (_selectBtn) {
            case 1:  {
                [self getModelsInMineVCWithCurrentPage:[NSNumber numberWithInteger:1]];
                [self.flMyIssueInMineModelMus removeAllObjects];
                [self.flMyIssueInMineMuDicArray removeAllObjects];
            }
                break;
            case 2: {
                [self.flMyReceiveInMineModelMus removeAllObjects];
                [self getMyReceiveTopicListWithCurrentPage:1];
            }
                break;
            case 3: {
                [self.xjMyParticipateNotReceiveArr removeAllObjects];
                [self getfindParticipateNotReceiveByParmCurrentPage:1];
            }
                break;
            case 4: {
                [self.xjMyWeaitPJModelArr removeAllObjects];
                [self getuserTopicListByCommentByCurrent:1];
            }
                break;
            default:
                break;
        }
        
    }
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
    
}
//上拉加载
- (void)loadMoreDataInTableViewMyIssueSMG {
    if (_selectBtn == 1) {
        NSNumber* xj = [FLTool xjRetuenCurrentWithArrLength:self.flMyIssueInMineModelMus.count andTotal:_xjTotalMyIssue xjSize:0];
        _currentPageMyIssue = [xj integerValue];
        NSNumber* numberCurrent = [NSNumber numberWithInteger:_currentPageMyIssue];
        [self getModelsInMineVCWithCurrentPage:numberCurrent];
    } else if(_selectBtn == 2) {
        NSNumber* xj = [FLTool xjRetuenCurrentWithArrLength:self.flMyReceiveInMineModelMus.count andTotal:_xjTotalMyPick xjSize:0];
        _currentPageMyPick = [xj integerValue];
        [self getMyReceiveTopicListWithCurrentPage:_currentPageMyPick];
    } else if(_selectBtn == 3) {
        NSNumber* xj = [FLTool xjRetuenCurrentWithArrLength:self.xjMyParticipateNotReceiveArr.count andTotal:_xjTotalMyPartIn xjSize:0];
        _currentPageMyPartIn= [xj integerValue];
        [self getfindParticipateNotReceiveByParmCurrentPage:_currentPageMyPartIn];
    } else if(_selectBtn == 4) {
        NSNumber* xj = [FLTool xjRetuenCurrentWithArrLength:self.xjMyWeaitPJModelArr.count andTotal:_xjTotalMyWeatJudge xjSize:0];
        _currentPageMyWeaitPJ = [xj integerValue];
        [self getuserTopicListByCommentByCurrent:_currentPageMyWeaitPJ];
    }
}
#pragma mark 刷新
//开始刷新
- (void)beginRefreshInMineViewController
{
    
    if (_selectBtn == 1) {
        _currentPageMyIssue = 1;
        [self.flMyIssueInMineModelMus removeAllObjects];
        //        NSNumber* numberCurrent = [NSNumber numberWithInteger:_currentPageMyIssue];
        //        [self getModelsInMineVCWithCurrentPage:numberCurrent];
    } else if(_selectBtn == 2) {
        _currentPageMyPick = 1;
        //        [self getMyReceiveTopicListWithCurrentPage:_currentPageMyPick];
        [self.flMyReceiveInMineModelMus removeAllObjects];
    } else if(_selectBtn == 3) {
        _currentPageMyPartIn = 1;
        //        [self getfindParticipateNotReceiveByParmCurrentPage:_currentPageMyPartIn];
        [self.xjMyParticipateNotReceiveArr removeAllObjects];
    } else if(_selectBtn == 4) {
        _currentPageMyWeaitPJ = 1;
        //        [self getuserTopicListByCommentByCurrent:_currentPageMyWeaitPJ];
        [self.xjMyWeaitPJModelArr removeAllObjects];
    }
    [((UITableView*)_flTableViewArray[_selectBtn - 1]).mj_header beginRefreshing];
    
}

//结束刷新
- (void)endRefreshInMineViewController
{
    [((UITableView*)_flTableViewArray[_selectBtn - 1]).mj_header endRefreshing];
    NSInteger pageCount ;
    NSInteger totalCount;
    if (_selectBtn==1) {
        pageCount = self.flMyIssueInMineModelMus.count;
        totalCount = _xjTotalMyIssue;
    } else if (_selectBtn==2) {
        pageCount = self.flMyReceiveInMineModelMus.count;
        totalCount = _xjTotalMyPick;
    } else if (_selectBtn==3) {
        pageCount = self.xjMyParticipateNotReceiveArr.count;
        totalCount = _xjTotalMyPartIn;
    } else if (_selectBtn == 4) {
        pageCount = self.xjMyWeaitPJModelArr.count;
        totalCount = _xjTotalMyWeatJudge;
    }
    if (totalCount == pageCount) {
        [((UITableView*)_flTableViewArray[_selectBtn - 1]).mj_footer endRefreshingWithNoMoreData];
    }else{
        [((UITableView*)_flTableViewArray[_selectBtn - 1]).mj_footer endRefreshing];
    }
}


#pragma mark- --------Actions
//顶部分栏的点击效果
- (void)topBtnClick:(id)sender {
    NSLog(@"慢慢来");
    UIButton* btn = (UIButton*)sender;
    self.tableViewIndex = btn.tag;
    switch (btn.tag)  {
        case 40:  {
            _selectBtn = 1;
            self.flmyIssueTableView.hidden = NO;
            [self moveLabel:0];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(0, 0);
                NSLog(@"点了1");
            }];
        }
            break;
        case 41:  {
            _selectBtn = 2;
            self.flmyPickUpTableView.hidden = NO;
            [self moveLabel:1];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(FLUISCREENBOUNDS.width, 0);
                NSLog(@"点了2");
            }];
            if (self.flMyReceiveInMineModelMus.count == 0) {
                [self beginRefreshInMineViewController];
            }
        }
            break;
        case 42:  {
            _selectBtn = 3;
            self.flmyPartInTopicTableView.hidden = NO;
            [self moveLabel:2];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(FLUISCREENBOUNDS.width * 2, 0);
                NSLog(@"点了3");
            }];
            if (self.xjMyParticipateNotReceiveArr.count == 0) {
                [self beginRefreshInMineViewController];
            }
        }
            break;
        case 43:  {
            _selectBtn = 4;
            self.flmyWeaitPJTableView.hidden = NO;
            [self moveLabel:3];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(FLUISCREENBOUNDS.width * 3, 0);
                NSLog(@"点了4");
            }];
            if (self.xjMyWeaitPJModelArr.count == 0) {
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
    //头视图
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height * 0.33)];
    self.backgroundImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"mine_back"];
    self.headerVIew = [[UIView alloc] initWithFrame:self.backgroundImageView.frame];
    [self.headerVIew addSubview:self.backgroundImageView];
    //    [self.headerVIew addSubview:self.portraitBtn];
    [self.topViewAndHeaderView addSubview:self.headerVIew];
    
    
    //头像按钮，点击进入设置
    self.portraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.portraitBtn setBackgroundImage:[UIImage imageNamed:@"logo_freela"] forState:UIControlStateNormal];
    self.portraitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.portraitBtn.layer.cornerRadius = 70 * FL_SCREEN_PROPORTION_width;
    self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
    self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

    self.portraitBtn.backgroundColor = [UIColor whiteColor];
    self.portraitBtn.layer.masksToBounds = YES;  //解决圆形button 添加图片溢出后的问题
    [self.portraitBtn addTarget:self action:@selector(GoToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
    [self.headerVIew addSubview:self.portraitBtn];
    [self.portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.center.equalTo(self.backgroundImageView).with.offset(0);
        make.centerX.equalTo(self.backgroundImageView).with.offset(0);
        make.centerY.equalTo(self.backgroundImageView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(140 * FL_SCREEN_PROPORTION_width, 140 * FL_SCREEN_PROPORTION_width));
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
    // 收藏按钮
    self.xjCollectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjCollectionBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.xjCollectionBtn setImage:[UIImage imageNamed:@"btn_collection_white_version2"] forState:UIControlStateNormal];
    [self.xjCollectionBtn addTarget:self action:@selector(clickGoToCollectionPage) forControlEvents:UIControlEventTouchUpInside];
    //    [self.headerVIew addSubview:self.xjCollectionBtn];
    //    [self.xjCollectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.headerVIew.mas_right).with.offset(-35);
    //        make.centerY.equalTo(self.myNameButton).with.offset(0);
    //        make.size.mas_equalTo(CGSizeMake(40 , 40));
    //    }];
    UIBarButtonItem *xjCollectionItem = [[UIBarButtonItem alloc] initWithCustomView:self.xjCollectionBtn];
    [self.navigationItem setRightBarButtonItem:xjCollectionItem];
    
    
    
    // 消息列表按钮
    //    self.xjHeaderMessageBtn = [[XJPushMessagesBtn alloc ] initWithFrame:CGRectMake(35, 80, 50, 50)];
    //    [self.headerVIew addSubview:self.xjHeaderMessageBtn];
    //    [self.xjHeaderMessageBtn.xjBtn addTarget:self action:@selector(clickToGoToPushMessagePage) forControlEvents:UIControlEventTouchUpInside];
    //    [self.xjHeaderMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.headerVIew).with.offset(35);
    //        make.centerY.equalTo(self.myNameButton).with.offset(0);
    //        make.size.mas_equalTo(CGSizeMake(40 , 40));
    //    }];
    
    // 消息列表按钮
    self.xjHeaderMessageBtn = [[XJPushMessagesBtn alloc ] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [self.headerVIew addSubview:self.xjHeaderMessageBtn];
    [self.xjHeaderMessageBtn.xjBtn addTarget:self action:@selector(clickToGoToPushMessagePageInMine) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bellItem = [[UIBarButtonItem alloc] initWithCustomView:self.xjHeaderMessageBtn];
    [self.navigationItem setLeftBarButtonItem:bellItem];
    
    
    //顶部分栏
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerVIew.size.height, FLUISCREENBOUNDS.width, FL_TopColumnView_Height)];
    //创建顶部分栏下面的细线
    UIView* viewUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0, FL_TopColumnView_Height-1, FLUISCREENBOUNDS.width, 1)];
    viewUnderLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.topView addSubview:viewUnderLine];
    FL_Log(@"test heigh =%f",FL_TopColumnView_Height);
    NSArray* array = @[@"我发布的",@"我领取的",@"我参与的",@"待评价的"];
    for (NSInteger i = 0; i < [array count]; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0 + self.topView.frame.size.width / 4 * i, 0, self.topView.frame.size.width / 4, 80* FL_SCREEN_PROPORTION_height);
        btn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
        btn.tag = 40 + i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:btn];
        if (i == 0) {
            self.flmyIssueBtn = btn;
        } else if ( i == 1) {
            self.flmyPickUpBtn = btn;
        } else if ( i == 2) {
            self.flmyWaitJudgeBtn = btn;
        } else if ( i == 3) {
            self.flmyWeaitPJBtn = btn;
        }
    }
    //    中间分割线
    for (NSInteger i  = 0; i < 4 ; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topView.frame.size.width / 4 * (i + 1), 6, 0.5, 50* FL_SCREEN_PROPORTION_height)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.alpha = 0.7;
        [self.topView addSubview:imageView];
    }
    self.moveLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height - 2, self.topView.frame.size.width / 4, 2)];
    //    self.moveLabel.backgroundColor = [UIColor colorWithHexString:@"#ff3e3e"];
    [self.topView addSubview:self.moveLabel];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.topViewAndHeaderView addSubview:self.topView];
    
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
}


- (void)creatTableView {
    //我发布的
    //     self.flmyIssueTableView              = [[XJTableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height)];
    self.flmyIssueTableView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height);
    self.flmyIssueTableView.delegate     = self;
    self.flmyIssueTableView.dataSource   = self;
    [self.flmyIssueTableView setContentInset:UIEdgeInsetsMake(self.topViewAndHeaderView.height, 0, 0, 0)];
    self.flmyIssueTableView.xjImageViewFrame = CGRectMake((FLUISCREENBOUNDS.width / 2) - FLUISCREENBOUNDS.width * 0.2, FLUISCREENBOUNDS.width * 0.1, FLUISCREENBOUNDS.width * 0.4, FLUISCREENBOUNDS.width * 0.2);
    self.flmyIssueTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.flmyIssueTableView.backgroundColor = [UIColor clearColor];
    self.flmyIssueTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview: self.flmyIssueTableView ];
    self.flmyIssueTableView.hidden = NO;
    
    //滚动视图自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //我领取的
    //    self.flmyPickUpTableView                  = [[XJTableView alloc] initWithFrame:self.flmyIssueTableView.frame style:UITableViewStylePlain];
    self.flmyPickUpTableView.frame = CGRectMake(FLUISCREENBOUNDS.width, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height);
    self.flmyPickUpTableView.dataSource  = self;
    self.flmyPickUpTableView.delegate    = self;
    self.flmyPickUpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.flmyPickUpTableView.showsVerticalScrollIndicator = NO;  // 垂直 不出现滚动条
    self.flmyPickUpTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.flmyPickUpTableView setContentInset:UIEdgeInsetsMake(self.topViewAndHeaderView.height , 0, 0, 0)];
    self.flmyPickUpTableView.xjImageViewFrame = CGRectMake((FLUISCREENBOUNDS.width / 2) - FLUISCREENBOUNDS.width * 0.2, FLUISCREENBOUNDS.width * 0.1, FLUISCREENBOUNDS.width * 0.4, FLUISCREENBOUNDS.width * 0.2);
    [self.scrollView addSubview:self.flmyPickUpTableView];
    self.flmyPickUpTableView.hidden = NO;
    
    //我参与的
    //    self.flmyPartInTopicTableView       = [[XJTableView alloc] initWithFrame:self.flmyIssueTableView.frame style:UITableViewStylePlain];
    self.flmyPartInTopicTableView.frame = CGRectMake(FLUISCREENBOUNDS.width * 2, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height);
    self.flmyPartInTopicTableView.delegate = self;
    self.flmyPartInTopicTableView.dataSource = self;
    self.flmyPartInTopicTableView.x = FLUISCREENBOUNDS.width *2;
    self.flmyPartInTopicTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.flmyPartInTopicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//点击效果
    self.flmyPartInTopicTableView.showsVerticalScrollIndicator = NO;
    [self.flmyPartInTopicTableView setContentInset:UIEdgeInsetsMake(self.topViewAndHeaderView.height , 0, 0, 0)];
    self.flmyPartInTopicTableView.xjImageViewFrame = CGRectMake((FLUISCREENBOUNDS.width / 2) - FLUISCREENBOUNDS.width * 0.2, FLUISCREENBOUNDS.width * 0.1, FLUISCREENBOUNDS.width * 0.4, FLUISCREENBOUNDS.width * 0.2);
    [self.scrollView addSubview:self.flmyPartInTopicTableView];
    self.flmyPartInTopicTableView.hidden = NO;
    //    __weak __typeof(self) weakSelf = self;
    //收藏
    //    self.flmyWeaitPJTableView       = [[XJTableView alloc] initWithFrame:self.flmyIssueTableView.frame style:UITableViewStylePlain];
    self.flmyWeaitPJTableView.frame = CGRectMake(FLUISCREENBOUNDS.width * 3, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height);
    self.flmyWeaitPJTableView.delegate = self;
    self.flmyWeaitPJTableView.dataSource = self;
    self.flmyWeaitPJTableView.x = FLUISCREENBOUNDS.width *3;
    self.flmyWeaitPJTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.flmyWeaitPJTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//点击效果
    self.flmyWeaitPJTableView.showsVerticalScrollIndicator = NO;
    [self.flmyWeaitPJTableView setContentInset:UIEdgeInsetsMake(self.topViewAndHeaderView.height, 0, 0, 0)];
    self.flmyWeaitPJTableView.xjImageViewFrame = CGRectMake((FLUISCREENBOUNDS.width / 2) - FLUISCREENBOUNDS.width * 0.2, FLUISCREENBOUNDS.width * 0.1, FLUISCREENBOUNDS.width * 0.4, FLUISCREENBOUNDS.width * 0.2);
    [self.scrollView addSubview:self.flmyWeaitPJTableView];
    self.flmyWeaitPJTableView.hidden = NO;
    [self.view addSubview:self.topViewAndHeaderView];
    
    //    [allFreeTableView addPullToRefreshWithActionHandler:^{
    //        //       [weakSelf ]
    //        NSLog(@"表1从新获得数据");
    //    }];
    //    [couponsTableView addPullToRefreshWithActionHandler:^{
    //        NSLog(@"表2 从新获得数据");
    //    }];
    //    [personalPushTableView addPullToRefreshWithActionHandler:^{
    //        NSLog(@"表3从新获得数据");
    //    }];
    
    self.flTableViewArray = @[self.flmyIssueTableView,self.flmyPickUpTableView,self.flmyPartInTopicTableView,self.flmyWeaitPJTableView ];
}


#pragma mark- ------usernet

- (void)seeAllUserInfo {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if (FLFLIsPersonalAccountType) {
        NSDictionary* parm  = @{@"token":FL_ALL_SESSIONID,
                                @"accountType":@"per",
                                };
        FL_Log(@"see info 新 in mine :sesdddssionId = %@  parm = %@",FL_ALL_SESSIONID,parm);
        [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
            if (data) {
                FL_Log(@"success in mine see info: %@  ,  tags = %@  dis = %@",data,[data objectForKey:@"tags"], [data objectForKey:@"description"]);
                self.flmineInfoModel = [FLMineInfoModel mj_objectWithKeyValues:data];
                [[NSUserDefaults standardUserDefaults] setObject:data[@"phone"] forKey:XJ_VERSION2_PHONE];
                [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:self.flmineInfoModel.avatar isSite:NO]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(!image){
                        image = [UIImage imageNamed:@""];
                    }
                    UIImage* imageTuUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
                    self.backgroundImageView.image = imageTuUse;
                }];
                [[XJUserAccountTool share] xj_saveUserAvatar:data[@"avatar"]];
                [[XJUserAccountTool share] xj_saveUserName:data[@"nickname"]];
                
                [self.myNameButton setTitle:self.flmineInfoModel.nickname forState:UIControlStateNormal];
                NSMutableData* dicData = [[NSMutableData alloc] init];
                NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dicData];
                [archiver encodeObject:data forKey:@"someKeyValue"];
                [archiver finishEncoding];
                //写入缓存
                //userInfo
                [userDefaults setObject:[[data objectForKey:@"userId"] stringValue] forKey:FL_USERDEFAULTS_USERID_KEY];
                //关于tags高度
                [userDefaults synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.flmyIssueTableView reloadData];
                });
                
            } else {
                [[FLAppDelegate share] showHUDWithTitile:@"网络错误" view:self.view delay:1 offsetY:0];
            }
        } failure:^(NSError *error) {
            FL_Log(@"error= %@, %@",error.description,error.debugDescription);
        }];
    }
    else
    {
        
        NSDictionary* parmBus =@{@"token":FLFLIsPersonalAccountType?FL_ALL_SESSIONID :FLFLBusSesssionID,
                                 @"accountType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey};
        FL_Log(@"see info :sesssionId = %@ ",parmBus);
        [FLNetTool seeInfoWithParm:parmBus success:^(NSDictionary *data) {
            FL_Log(@"see info in getuserminebus tool success=%@, avatar = %@",data,[data objectForKey:@"avatar"]);
            if (data)
            {
                self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
                self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

                self.busAccountModel = [FLTool flNewGetBusAccountInfoModelWithDic:data];
                //                FLFLXJBusinessUserHeaderImageURLStr = self.busAccountModel.busHeaderImageStr;
                FLFLXJBusinessUserHeaderImageURLStr = [XJFinalTool xjReturnImageURLWithStr:self.busAccountModel.busHeaderImageStr isSite:NO];
                [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:self.busAccountModel.busHeaderImageStr isSite:NO]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    UIImage* imageTuUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
                    self.backgroundImageView.image = imageTuUse;
                }];
                
                
                [self.myNameButton setTitle:self.busAccountModel.busSimpleName forState:UIControlStateNormal];
            }
            
        } failure:^(NSError *error) {
            FL_Log(@"see info in mine failure=%@,%@",error.description,error.debugDescription);
        }];
    }
    
    [FLTool xjSetJpushAlias];
}

- (void)getDetailInfoDataInMyIssueView
{
    
    
}
//我发布的
- (void)getIssueInfoDataForAgainWithIndexPath:(NSInteger)indexPath
{
    NSString* _flFuckTopicId = self.flMyIssueInMineDicArray[indexPath][@"topicId"];
    if (!_flFuckTopicId) {
        return;
    }
    NSDictionary* parm = @{@"topic.topicId":self.flMyIssueInMineDicArray[indexPath][@"topicId"],
                           @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"userId":FLFLIsPersonalAccountType ? [[NSUserDefaults standardUserDefaults] objectForKey:FL_USERDEFAULTS_USERID_KEY] : FLFLXJBusinessUserID,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:_flFuckTopicId]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"test detail wit3h with =%@",data);
        [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:_flFuckTopicId];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -------- 去待评价的
- (void)clickToPJTopic:(UIButton*)xjSender {
    FL_Log(@"this is the action to pj");
    NSInteger xjIndex = xjSender.tag - xjTag;
    XJRejudgePJBcakViewController* judgePJVC = [[XJRejudgePJBcakViewController alloc] init];
    judgePJVC.delegate = self;
    judgePJVC.xjUserModel = self.flmineInfoModel;
    judgePJVC.xjWeaiPJModel = self.self.xjMyWeaitPJModelArr[xjIndex];
    [self.navigationController pushViewController:judgePJVC animated:YES];
}

- (void)xjRefreshWeatPJListController{
    [self.flmyWeaitPJTableView.mj_header beginRefreshing];
}

#pragma mark 到我收藏的界面
- (void)clickGoToCollectionPage {
    FL_Log(@"clickGoToCollectionPage");
    XJMyCollectionViewController* xjVC = [[XJMyCollectionViewController alloc] init];
    [self.navigationController pushViewController:xjVC animated:YES];
}

- (void)clickToGoToPushMessagePageInMine{
    XJPushMessageListViewController* xjPushVC = [[XJPushMessageListViewController alloc] init];
    [self.navigationController pushViewController:xjPushVC animated:YES];
}


- (void)xjGetPushMessage {
    NSString* xjUserId = [NSString stringWithFormat:@"%@", XJ_USERID_WITHTYPE];
    NSString* xjUserType = [NSString stringWithFormat:@"%@", XJ_USERTYPE_WITHTYPE];
    NSString* xjToken = [NSString stringWithFormat:@"%@", FL_ALL_SESSIONID];
    if (!xjUserId || xjUserId.length==0 || !xjUserType || !xjToken || [xjUserType isEqualToString:@"(null)"] || [xjUserId isEqualToString:@"(null)"] ) {
        return;
    }
    
    NSDictionary* parm = @{@"msgPush.targetUserId":XJ_USERID_WITHTYPE,
                           @"msgPush.targetUserType":XJ_USERTYPE_WITHTYPE,
                           @"types":@"1,6,7,8"};
    [FLNetTool xjGetPushMessagesByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the p2ush message that i don't read =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            XJPushMessageListModel* xjxj = [XJPushMessageListModel mj_objectWithKeyValues:data];
            self.xjHeaderMessageBtn.xjBadges = xjxj.count1 + xjxj.count6 + xjxj.count7 + xjxj.count8;
            //            self.xjHeaderMessageBtn.xjBadges = 10;
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)xjChangeAccountNoti {
    [self.flmyIssueTableView.mj_header beginRefreshing];
    [self.flmyPickUpTableView.mj_header beginRefreshing];
    [self.flmyPartInTopicTableView.mj_header beginRefreshing];
    [self.flmyWeaitPJTableView.mj_header beginRefreshing];
}


@end





















