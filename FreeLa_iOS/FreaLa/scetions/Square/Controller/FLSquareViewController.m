//
//  FLSquareViewController.m
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//


#import "FLSquareViewController.h"
#import "FLSaoMiaoViewController.h"
#import "BLImageSize.h"
#import "UIScrollView+MJRefresh.h"
#import "XJSearchViewController.h"
#import "XJSearchSystemParmModel.h"
#import "XJOnlySaoMiaoViewController.h"

#define TopViewHeight           (60 * FL_SCREEN_PROPORTION_height)
#define CouponseCellHeight              FLUISCREENBOUNDS.height - TopViewHeight - TabBarHeight - StatusBar_NaviHeight



@interface FLSquareViewController () <EMChatManagerDelegate,UISearchBarDelegate>{
    
    //全免费相关成员属性
    UITableView* allFreeTableView;
    
    //优惠券
    UITableView* couponsTableView;
    
    //个人发布
//    UICollectionView * personalPushCollectionView;
    
    NSInteger _selectBtn; //标记点了的按钮，全免费、优惠券、个人发布
    NSInteger _flcurrentPageAllFree; //全免费当前是第几页
    NSInteger _fltotalPageAllfree;   //全免费服务器返回的总共的个数
    NSInteger _flcurrentPagecouconpse; //优惠券当前是第几页
    NSInteger _fltotalPagecouconpse;   //优惠券服务器返回的总共的个数
    NSInteger _flcurrentPageperson; //个人当前是第几页
    NSInteger _fltotalPageperson;   //个人服务器返回的总共的页数
    
    BOOL  _isFirstTimeIn;   //是不是第一次加载
    BOOL  _isxjLoading;
    /**关于scrollView滑动方向的判断*/
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    CGFloat newContentOffsetY;
    
    
    BOOL _isStatusBarHidden;
    NSDictionary* _squareMainInfoDic; //拿到的字典
}

@property (nonatomic , strong)UIView* topView;
/** 顶部分栏的三个按钮*/
@property (nonatomic , strong)UIButton* allFreeBtn; //全免费
@property (nonatomic , strong)UIButton* couponsBtn; // 优惠券
@property (nonatomic , strong)UIButton* personalPushBtn; //个人发布
@property (nonatomic , strong)UILabel*  moveLabel;   //顶部分栏移动的 线条

@property (nonatomic , strong) UICollectionView * personalPushCollectionView; //个人发布

//背景
@property (nonatomic , weak)UIScrollView* scrollView;
/**当前选择的表格序号*/
@property (nonatomic , assign)NSInteger tableViewIndex;

//cell
/**全免费*/
@property (nonatomic , strong)FLSquareMainCell * flsquareCell;
/**优惠券*/
@property (nonatomic , strong)FLCouponsTableViewCell*   flcouponsCell;
/**个人*/
@property (nonatomic , strong)FLSquarePersonCollectionViewCell*   flpersonPushCell;

//头部视图
@property (nonatomic , strong)FLNaviBaseViewInSquare* topViewAndHeaderView;
/**model*/
@property (nonatomic , strong)FLSquareAllFreeModel* flsquareAllFreeModel;

@property (nonatomic , strong) NSMutableArray* xjSystemSearchTags;
/**不可变allfreemodels*/
@property (nonatomic , strong)NSArray* flsquareAllFreeModels;
/**allreemumodels*/
@property (nonatomic , strong)NSMutableArray* flsquareAllFreemodelmus;
/**不可变couponsemodels*/
//@property (nonatomic , strong)NSArray* flsquareCouponseModels;
/**couponsemumodels*/
@property (nonatomic , strong)NSMutableArray* flsquareCouponsemodelmus;
/**个人发布图片models*/
@property (nonatomic , strong)NSArray* flsquarePersonIssueModels;
/**个人发布图片mumodels*/
@property (nonatomic , strong)NSMutableArray* flsquarePersonIssuemodelmus;

/**个人发布图片models*/
@property (nonatomic , strong)NSArray* flsquarePersonIssueInfoModels;
/**个人发布图片mumodels*/
@property (nonatomic , strong)NSMutableArray* flsquarePersonIssueInfomodelmus;



/**三个tableview的 数组*/
@property (nonatomic , strong)NSArray* flsquareTableViews;
/**三个tableview的 type*/
@property (nonatomic , strong)NSArray* flsquareTableViewTypes;
/**三个tableview标记的当前页*/
@property (nonatomic , strong)NSArray* flsquareTagCurrentPages;


@property (nonatomic , strong)MJRefreshAutoGifFooter *MJfooter;
/**请求服务器的type(英文)*/
@property (nonatomic , strong)NSArray* flrequestEnglishType;

/**全免费界面数组*/
@property (nonatomic , strong)NSArray* flHTMLAllFreeArr;
/**全免费界面可变数组*/
@property (nonatomic , strong)NSMutableArray* flHTMLAllFreeMuArr;
/**优惠券界面数组*/
@property (nonatomic , strong)NSArray* flHTMLCouponseArr;
/**优惠券界面可变数组*/
@property (nonatomic , strong)NSMutableArray* flHTMLCouponseMuArr;
/**个人界面数组*/
@property (nonatomic , strong)NSArray* flHTMLPersonalArr;
/**个人界面可变数组*/
@property (nonatomic , strong)NSMutableArray* flHTMLPersonalMuArr;

//test test
@property (nonatomic,strong)UIImage * image; // 如果计算图片尺寸失败  则下载图片直接计算
@property (nonatomic,strong)NSMutableArray * heightArray;// 存储图片高度的数组
@property (nonatomic,strong)NSMutableArray * modelArray; //存储 model 类的数组
@property (nonatomic,assign)NSInteger page; // 一次刷新的个数

@end



@implementation FLSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNaviBar]; //瀑布流创建
    [self creatScrollView];//创建底部scrollView
    [self creatTableView];//创建tableView
    [self settingPageInfo]; //配置信息
    [self creatTopView];//顶部分栏
    [self addObserverInSquareVC];//增加通知
    //刷新
    [self regreshDataInTableView];
    //注册tableview
    [self registerTableView];
    //查看用户所有信息
    [self seeAllUserInfo];
    //设置极光别名
    if (XJ_USERID_WITHTYPE) {
        [FLTool xjSetJpushAlias];
    }
    if (![FLTool isNetworkEnabled]) {
        [[FLAppDelegate share] showHUDWithTitile:@"请检查网络" view:self.view  delay:1 offsetY:0];
    }
    allFreeTableView.contentInset=UIEdgeInsetsMake(TopViewHeight + StatusBar_NaviHeight, 0, 0, 0);
     [couponsTableView setContentInset:UIEdgeInsetsMake(TopViewHeight + StatusBar_NaviHeight , 0, 0, 0)];
    [_personalPushCollectionView setContentInset:UIEdgeInsetsMake(TopViewHeight + StatusBar_NaviHeight, 0, 0, 0)];
    
//    [self shanchu];

}

- (void)xjPushTest:(NSNotification*)xjObj {
    NSDictionary* xjDic = xjObj.object;
    
    UIAlertController* xjalert = [UIAlertController alertControllerWithTitle:@"ad" message:@"ada'" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* xjac = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [xjalert addAction:xjac];
    [self presentViewController:xjalert animated:YES completion:nil];
    
    NSString* xjStr = [xjDic objectForKey:@"topicId"];
    FLFuckHtmlViewController* xjFuck = [[FLFuckHtmlViewController alloc] init];
    xjFuck.flFuckTopicId = xjStr;
    [self.navigationController pushViewController:xjFuck animated:YES];

}

- (void)settingPageInfo {
     self.tableViewIndex = 10;
    _selectBtn = 1;
    [self setUpBtnColorInSquare:_selectBtn];
    _isStatusBarHidden = NO;
    _isFirstTimeIn = YES;
    _isxjLoading = NO;
    _flcurrentPageAllFree = 0;  //全免费当前页
    _flcurrentPagecouconpse = 0; //优惠券当前页
    _flcurrentPageperson = 0;  //个人当前页
    self.flsquareAllFreemodelmus = [NSMutableArray array];
    self.flsquareCouponsemodelmus = [NSMutableArray array];
    self.flsquarePersonIssuemodelmus = [NSMutableArray array];
    self.flsquarePersonIssueInfomodelmus = [NSMutableArray array];
    //传给html 可变数组
    self.flHTMLAllFreeMuArr = [NSMutableArray array];
    self.flHTMLCouponseMuArr = [NSMutableArray array];
    self.flHTMLPersonalMuArr = [NSMutableArray array];
    self.xjSystemSearchTags = [NSMutableArray array];
    self.flsquareTagCurrentPages = @[[NSNumber numberWithInteger:_flcurrentPageAllFree],[NSNumber numberWithInteger:_flcurrentPagecouconpse],[NSNumber numberWithInteger:_flcurrentPageperson]];
}
#pragma mark ------- init
//- (FLSquareAllFreeModel *)flsquareAllFreeModel
//{
//    if (!_flsquareAllFreeModel) {
//        _flsquareAllFreeModel = [[FLSquareAllFreeModel alloc] init];
//    }
//    return _flsquareAllFreeModel;
//}

-(NSArray *)flsquareAllFreeModels
{
    if (!_flsquareAllFreeModels) {
        _flsquareAllFreeModels = [NSArray array];
    }
    return _flsquareAllFreeModels;
}

- (void)setUpBtnColorInSquare:(NSInteger)selectedBtn
{
    [self.allFreeBtn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    [self.couponsBtn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    [self.personalPushBtn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
    if (selectedBtn == 1)
    {
        [self.allFreeBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    }
    else if (selectedBtn == 2)
    {
        [self.couponsBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    }
    else if (selectedBtn == 3)
    {
        [self.personalPushBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    }
    
}

- (void)addObserverInSquareVC { 
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionView) name:@"FLFLSquarePersonalCellSdwebImageDone" object:nil];
}

#pragma mark------setUpUI ----顶部分栏
- (void)creatTopView {
    self.topViewAndHeaderView = [[FLNaviBaseViewInSquare alloc] init];
    [self.topViewAndHeaderView.flAddressBtn setTitle:@"发现" forState:UIControlStateNormal];
//    [self.topViewAndHeaderView.flAddressBtn addTarget:self action:@selector(xjTestToGoSearch) forControlEvents:UIControlEventTouchUpInside];
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, 69);
    [self.topViewAndHeaderView.flIssueBtn addTarget:self action:@selector(issueANewActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.topViewAndHeaderView.flsaoBtn addTarget:self action:@selector(flsaomiaoTopic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topViewAndHeaderView];
    self.topViewAndHeaderView.flSearchBar.delegate = self;
    
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, FLUISCREENBOUNDS.width, TopViewHeight)];
    FL_Log(@"test heigh =%f",TopViewHeight);
    self.topView.backgroundColor = [UIColor whiteColor];
       _flsquareTableViewTypes = @[FLFLXJSquareAllFreeStr,FLFLXJSquareCouponseStr,FLFLXJSquarePersonStr];  //全免费等中文
    _flrequestEnglishType = @[FLFLXJSquareAllFreeStrKey,FLFLXJSquareCouponseStrKey,FLFLXJSquarePersonStrKey];    //全免费的key
    for (NSInteger i = 0; i < [_flsquareTableViewTypes count]; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0 + self.topView.frame.size.width / 3 * i, -5, self.topView.frame.size.width / 3, 80* FL_SCREEN_PROPORTION_height);
        btn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        [btn setTitle:[_flsquareTableViewTypes objectAtIndex:i] forState:UIControlStateNormal];
        if (i)   {
            [btn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
        }  else  {
            [btn setTitleColor:[UIColor colorWithHexString:XJ_FCOLOR_REDFONT] forState:UIControlStateNormal];
        }
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:btn];
        if (i == 0) {
            self.allFreeBtn = btn;
        }  else if ( i == 1) {
            self.couponsBtn = btn;
        } else  {
            self.personalPushBtn = btn;
        }
    }
//    中间分割线
//    for (NSInteger i  = 0; i < 3 ; i++)
//    {
//        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topView.frame.size.width / 3 * (i + 1), 6, 0.5, 50* FL_SCREEN_PROPORTION_height)];
//        imageView.backgroundColor = [UIColor lightGrayColor];
//        imageView.alpha = 0.7;
//        [self.topView addSubview:imageView];
//    }
    self.moveLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height - 2, self.topView.frame.size.width / 3, 2)];
    self.moveLabel.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    [self.topView addSubview:self.moveLabel];
    [self.view addSubview:self.topView];
}

//创建底部scrollView

- (void)creatScrollView {
    CGFloat scrollX = 0;
    CGFloat scrollY = 0;//TopViewHeight ;//CGRectGetMaxX(self.topView.frame);
    CGFloat scrollW = FLUISCREENBOUNDS.width;
    CGFloat scrollH = FLUISCREENBOUNDS.height - TabBarHeight ;
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollX, scrollY, scrollW, scrollH)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width * 3, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.bounces = NO;
}

- (void)creatTableView {
    //全免费
    allFreeTableView              = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, self.scrollView.frame.size.height)];
    allFreeTableView.delegate     = self;
    allFreeTableView.dataSource   = self;
    allFreeTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    allFreeTableView.backgroundColor = [UIColor clearColor];
    allFreeTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:allFreeTableView];
    allFreeTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
//    allFreeTableView.tableHeaderView = self.topView;
    allFreeTableView.hidden = NO;
    //滚动视图自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    
    //优惠券
    couponsTableView                  = [[UITableView alloc] initWithFrame:allFreeTableView.frame style:UITableViewStylePlain];
    couponsTableView.x   = FLUISCREENBOUNDS.width;
    couponsTableView.dataSource  = self;
    couponsTableView.delegate    = self;
    couponsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    couponsTableView.showsVerticalScrollIndicator = NO;  // 垂直 不出现滚动条
//    couponsTableView.backgroundColor = [UIColor blueColor];
   
    [self.scrollView addSubview:couponsTableView];
    couponsTableView.hidden = NO;
    
    //个人发布
    AoiroSoraLayout* layout = [[AoiroSoraLayout alloc] init];//创建布局
//    layout.sectionInset = UIEdgeInsetsMake(0.5, 1, 0.5, 1);
    layout.interSpace = 5; // 每个item 的间隔
    layout.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.colNum = 2; // 列数;
    layout.delegate = self;
   
    _personalPushCollectionView   = [[UICollectionView alloc] initWithFrame:allFreeTableView.frame collectionViewLayout:layout];// 根据布局创建CollectionView
    _personalPushCollectionView.delegate = self;
    _personalPushCollectionView.dataSource = self;
    _personalPushCollectionView.x = FLUISCREENBOUNDS.width *2; //???
    _personalPushCollectionView.backgroundColor = [UIColor whiteColor];
    _personalPushCollectionView.showsVerticalScrollIndicator = NO;
    _personalPushCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollView addSubview:_personalPushCollectionView];// 将CollectionView添加到ScrollView中
    _personalPushCollectionView.hidden = NO;
     [self addFooter]; // 上拉刷新
    
    [allFreeTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [couponsTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [_personalPushCollectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
    //数组
    _flsquareTableViews = @[allFreeTableView,couponsTableView,_personalPushCollectionView];
}

- (void)addFooter {
   
    // 添加上拉刷新尾部控件
    _personalPushCollectionView.mj_footer =[ MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataWithTableViewAllFree)];
}

- (void)refreshData {
//    if (refreshing) {
    
//    }
}
//瀑布流
- (void)creatNaviBar
{}

#pragma mark- --------Actions
//顶部分栏的点击效果
- (void)topBtnClick:(id)sender {
    FL_Log(@"慢慢来");
    UIButton* btn = (UIButton*)sender;
    self.tableViewIndex = btn.tag;
    switch (btn.tag) {
        case 10:  {
            _selectBtn = 1;
            allFreeTableView.hidden = NO;
            [self moveLabel:0];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(0, 0);
                NSLog(@"点了1");
                _isFirstTimeIn = NO;
  
            }];
        }
            break;
        case 11:    {
            _selectBtn = 2;
            couponsTableView.hidden = NO;
            [self moveLabel:1];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(FLUISCREENBOUNDS.width, 0);
               
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    _isFirstTimeIn = YES;
                     NSLog(@"点了2");
 
                });
            }];
        }
            break;
        case 12:  {
            _selectBtn = 3;
            _personalPushCollectionView.hidden = NO;
            [self moveLabel:2];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(FLUISCREENBOUNDS.width * 2, 0);
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    _isFirstTimeIn = YES;
                      NSLog(@"点了3");
                });
            }];
        }
        default:
            break;
    }
}
//移动label的动作，判断发请求
- (void)moveLabel:(NSInteger)index {
    for (NSInteger i = 0; i < 3; i++)  {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10 + i];
        if (i != index)  {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }  else {
            [btn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.moveLabel.frame =  CGRectMake(self.topView.frame.size.width / 3 * index, self.topView.frame.size.height - 2, self.topView.frame.size.width / 3, 2);
    } completion:nil];
    if (index == 1)  {
//        [self getAllFreeData:1];
        NSLog(@"index ==  %ld",(long)self.tableViewIndex);
    }
}

- (void)logInAgain {
    FLLogIn_RegisterViewController* logInVC = [[FLLogIn_RegisterViewController alloc]init];
    [self presentViewController:logInVC animated:YES completion:nil];
}


//TODO
- (void)seeAllUserInfo {
    NSDictionary* parm = [NSDictionary dictionaryWithObjectsAndKeys:
                          XJ_USER_SESSION,@"token",
                          @"per",@"accountType"
                          , nil];
    FL_Log(@"see info :sesssionId = %@ ",XJ_USER_SESSION);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"success: with see in fo see1111=  %@",data);
        if (data) {
            //写入缓存
            //判断是否有手机号
            if (!data[@"phone"]) {
                FLFLXJIsHasPhoneBlind = 0;
            } else {
                FLFLXJIsHasPhoneBlind = 1;
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:data[@"phone"] key:XJ_VERSION2_PHONE];
            }
            
            //优化内容测试  $$$$model
            FLUserInfoModel* xjUserInfoModel = [FLUserInfoModel mj_objectWithKeyValues:data];//[FLUserInfoModel mj_objectWithKeyValues:data];
            [self xjSetUserInfoModelWithModel:xjUserInfoModel];
            
            //userInf
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:[data objectForKey:@"userId"] key:FL_USERDEFAULTS_USERID_KEY];
            [self huanxinLogin]; // 环信登录
            [FLTool xjSetJpushAlias];
        }
    } failure:^(NSError *error) {
        NSLog(@"error= %@, %@",error.description,error.debugDescription);
        
    }];
    
}
#pragma mark ---------- Issue A New Activity
- (void)issueANewActivity {
//    FLIssueNewActivityTableViewController * issueVC  = [[FLIssueNewActivityTableViewController alloc] init];
    //选择发布类型
//    FLIssueChoiceModelViewController* choiceModelVC = [[FLIssueChoiceModelViewController alloc] init];
    //发布的基本信息
    
//    NSURL *myUrl = [NSURL URLWithString:@"nidaye://topicId=1"]; //xxxApp为目标App跳转的key
//    if([[UIApplication sharedApplication] canOpenURL:myUrl]){
//        [[UIApplication sharedApplication] openURL:myUrl];
//    }
    FL_Log(@"sdas =%ld",[FLUserInfoModel share].flStateInt);
    if ([FLUserInfoModel share].flStateInt==1 && FLFLIsPersonalAccountType) {
        [self xjAlertAccountError];
        return;
    }
    if (!FLFLIsPersonalAccountType&&[FLBusAccountInfoModel share].busStateInt==1) {
        [self xjAlertAccountError];
        return;
    }
    if (FLFLXJIsHasPhoneBlind) {
        FLIssueBaseInfoViewController* baseInfoVC = [[FLIssueBaseInfoViewController alloc] init];
        //    测试图文混排
        //    FLIssueNewActivityTableViewController* baseInfoVC  = [[FLIssueNewActivityTableViewController alloc] init];
        baseInfoVC.flissueInfoModel = [[FLIssueInfoModel alloc] init];
        [self.navigationController pushViewController:baseInfoVC animated:YES];
    } else {
        UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:@"操作失败" message:@"您还没有绑定手机号，不能进行此操作" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            FL_Log(@"The \"Okay/Cancel\" alert's cancel action occured.");
        }];
        UIAlertAction *flSureAction = [UIAlertAction actionWithTitle:@"马上去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            FL_Log(@"go to blind phone number now.");
            FLBlindWithThirdTableViewController * blindVC = [[FLBlindWithThirdTableViewController alloc] init];
            [weakSelf.navigationController pushViewController:blindVC animated:YES];
        }];
        
        [flAlertViewController addAction:flCancleAction];
        [flAlertViewController addAction:flSureAction];
        [self presentViewController:flAlertViewController animated:YES completion:nil];
    }
   
}

#pragma mark 扫描二维码
- (void)flsaomiaoTopic {
//    FLSaoMiaoViewController* saomiaoVC = [[FLSaoMiaoViewController alloc] initWithNibName:@"FLSaoMiaoViewController" bundle:nil];
    XJOnlySaoMiaoViewController* saomiaoVC = [[XJOnlySaoMiaoViewController alloc] initWithType:1];
//    saomiaoVC.flComeType = 1;
    [self.navigationController pushViewController:saomiaoVC animated:YES];
}
#pragma mark ------btnClicke
- (void)disappearBtnClick:(UIButton*)sender
{
}

- (void)viewWillAppear:(BOOL)animated {
      [super viewWillAppear:animated];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_back_red"] forBarMetrics:UIBarMetricsDefault];
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjPushTest:) name:@"THISISTHETESTPUSH" object:nil];
    //读取缓存
    if (![FLTool isNetworkEnabled]) {
        [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:0];
    } else if ([[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION_IS_THIRD]) {
//         [[FLAppDelegate share] showHUDWithTitile:@"授权成功" view:self.view delay:1 offsetY:0];
        
    } else {
        NSString* xjPhone = XJ_USER_VALUE_PHONE;
        NSString* xjPwd = XJ_USER_VALUE_PHONE;
    [FLNetTool logInWithPhone:xjPhone password:xjPwd success:^(NSDictionary *dic) {
        FL_Log(@"dic in square login =%@",dic);
        if (dic) {
            if ([[dic objectForKey:FL_NET_KEY] boolValue])  {
                FL_Log(@"用户名密码 没什么问题");
                NSString* xjStr = [dic objectForKey:FL_NET_SESSIONID];
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjStr ? xjStr :@"" key:FL_NET_SESSIONID];
            }  else {
                [[FLAppDelegate share] showHUDWithTitile:@"用户名密码错误，请重新登录" view:self.view delay:1 offsetY:0];
                [self performSelector:@selector(logInAgain) withObject:self afterDelay:2];
            }
        }

    } failure:^(NSError *error)   {
         NSLog(@"i'm wrong =====  %@ ----------%@         。。。。。。。。。%ld",error.description,error.debugDescription,error.code);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@", [FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
     }];
    }
}

#pragma mark -----------init
- (void)setTotalTopViewHiddenWithBoolen:(BOOL)isTopHidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.hidden = isTopHidden;
        [self.topViewAndHeaderView setHidden:isTopHidden];
        [[UIApplication sharedApplication] setStatusBarHidden:isTopHidden withAnimation:UIStatusBarAnimationFade];
    });
}

//tabbar 隐藏啊
- (void)setTabBarHiddenWithBoolen:(BOOL)isTabBarHidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBarController.tabBar setHidden:isTabBarHidden];
       
    });
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title=@"发现";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_discover"];
    }
    return self;
}

#pragma mark-------------------------------------------------------------------------selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FL_Log(@"test ofr selected %@",indexPath);
    FLFuckHtmlViewController* htmlVC = [[FLFuckHtmlViewController alloc] init];
    htmlVC.isPersonalComeIn = NO;
    if (tableView == allFreeTableView)
    {
//        htmlVC.flsquareAllFreeModel  = self.flHTMLAllFreeArr[indexPath.row];
        htmlVC.flFuckTopicId = self.flHTMLAllFreeArr[indexPath.row][@"topicId"];
        [self.navigationController pushViewController:htmlVC animated:YES];
    }  else if (tableView == couponsTableView) {
        htmlVC.flFuckTopicId = self.flHTMLCouponseArr[indexPath.row][@"topicId"];
        [self.navigationController pushViewController:htmlVC animated:YES];
    }
  
}
#pragma mark-------------------------------------------------------------------------selected

#pragma mark- ---------tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (1)
    {
        if (tableView == allFreeTableView) {
            number = self.flsquareAllFreeModels.count;
        }
        else if (tableView == couponsTableView)
        {
            number =  _flsquareCouponsemodelmus.count;
        }
    }
    return number;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier;
    if (tableView == allFreeTableView)
    {
        identifier = @"FLSquareMainCell";
         self.flsquareCell = [allFreeTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (self.flsquareAllFreeModels.count != 0) {
             self.flsquareCell.flsquareAllFreeModel = self.flsquareAllFreeModels[indexPath.row];
        }
        self.flsquareCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置代理
        return self.flsquareCell;
    }
    else if (tableView == couponsTableView)
    {
        identifier = @"FLCouponsTableViewCell";
        self.flcouponsCell = [couponsTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (_flsquareCouponsemodelmus.count != 0) {
           self.flcouponsCell.flsquareConcouponseModel = _flsquareCouponsemodelmus[indexPath.row];
        }
//        NSLog(@"model ni ma de ++++++++++++++%@",[self.flsquareAllFreeModels[indexPath.row] class]);
        self.flcouponsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.flcouponsCell;
    }
    return self.flsquareCell;
}

#pragma mark ---------UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //开始的坐标
    oldContentOffsetY = scrollView.contentOffset.y;
}
static NSInteger _lastPosition ; //作为上下滑动的基准
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //将要完的坐标
    newContentOffsetY = scrollView.contentOffset.y;
    _lastPosition = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //movelabel移动功能
    if (scrollView == self.scrollView)
    {
        self.moveLabel.x = (scrollView.contentOffset.x / FLUISCREENBOUNDS.width) * FLUISCREENBOUNDS.width / 3;
        if (scrollView.contentOffset.x == 0)
        {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width  + 1;
            _isFirstTimeIn = NO;
            [self setTotalTopViewHiddenWithBoolen:NO];
        }
        else if (scrollView.contentOffset.x == FLUISCREENBOUNDS.width)
        {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width + 1;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _isFirstTimeIn = YES;
                [couponsTableView.mj_header beginRefreshing];
                NSLog(@"点了2");
             });
            [self setTotalTopViewHiddenWithBoolen:NO];
        }
        else if (scrollView.contentOffset.x == FLUISCREENBOUNDS.width * 2)
        {
            _selectBtn = scrollView.contentOffset.x / FLUISCREENBOUNDS.width +1;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _isFirstTimeIn = YES;
                NSLog(@"点了2");
                [_personalPushCollectionView.mj_header beginRefreshing];
            });
            [self setTotalTopViewHiddenWithBoolen:NO];
        }
        [self setUpBtnColorInSquare:_selectBtn];
    }
    //判断向上还是向下
//    CGRect scrollFrame = scrollView.frame;
    if (scrollView.contentOffset.y  - _lastPosition > 20 && scrollView.contentOffset.y  > 0 )
    {
//        NSLog(@"ScrollUp now");
       [self setTotalTopViewHiddenWithBoolen:YES];

    }
    if (_lastPosition - scrollView.contentOffset.y > 20 &&  scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.bounds.size.height - 20)
    {
//        NSLog(@"ScrollDown now");
        [self setTotalTopViewHiddenWithBoolen:NO];
    }
//    newContentOffsetY = scrollView.contentOffset.y;
   
    
//    if (newContentOffsetY - oldContentOffsetY > TopViewHeight )//&& oldContentOffsetY > contentOffsetY)
//    {
//        FL_Log(@"up-------------------");
//          self.topView.hidden = YES;
////        [self.topViewAndHeaderView setHidden:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//         _isStatusBarHidden = YES;
////        [self prefersStatusBarHidden];
//    }
//    else if (newContentOffsetY < oldContentOffsetY )//&& oldContentOffsetY< contentOffsetY)
//    {
//        FL_Log(@"down----------------");
//         self.topView.hidden = NO;
////        [self.topViewAndHeaderView setHidden:NO];
//         _isStatusBarHidden = NO;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
////        [self prefersStatusBarHidden];
//    }
//     FL_Log(@"newcontenty = %f   old= %f" ,newContentOffsetY ,oldContentOffsetY  );
    
//    [self.topViewAndHeaderView changedViewColorWithAlpha:newContentOffsetY];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat indexHeight = 44;
    if (tableView == allFreeTableView) {
        indexHeight = (FLUISCREENBOUNDS.height - StatusBar_NaviHeight - TopViewHeight - TabBarHeight) / 2;
    }
    else if (tableView == couponsTableView) {
        indexHeight = CouponseCellHeight;
    }
    return indexHeight;
}


- (void)registerTableView {
    [allFreeTableView registerNib:[UINib nibWithNibName:@"FLSquareMainCell" bundle:nil] forCellReuseIdentifier:@"FLSquareMainCell"];
    [couponsTableView registerClass:[FLCouponsTableViewCell class] forCellReuseIdentifier:@"FLCouponsTableViewCell"];
//    [personalPushCollectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:@"item"];
    [_personalPushCollectionView registerNib:[UINib nibWithNibName:@"CYItemCell" bundle:nil] forCellWithReuseIdentifier:@"CYItemCell"];
    
    self.flsquareCell = [[FLSquareMainCell alloc] init];
    self.flcouponsCell = [[FLCouponsTableViewCell alloc] init];
    self.flpersonPushCell = [[FLSquarePersonCollectionViewCell alloc] init];
    
}
#pragma mark -------获取详情
- (void)getSquareInfoWithCurrentPage:(NSInteger)currentPage TopicType:(NSString*)topicType
{
    _isxjLoading = YES;
    NSDictionary* dic = @{@"page.currentPage":[NSString stringWithFormat:@"%ld",(long)currentPage],
                          @"topic.topicType":topicType};
    FL_Log(@"dic in square la1= %@",dic);
    [FLNetTool getSquareInfoWithParm:dic success:^(NSDictionary *data) {
        FL_Log(@"data in squ5are = %@",data);
        if ([[data objectForKey:FL_NET_KEY_NEW]boolValue]) {
               _squareMainInfoDic = data;
            if (_selectBtn == 1) {
                _fltotalPageAllfree = [data[@"total"] integerValue];
            }  else if (_selectBtn == 2) {
                _fltotalPagecouconpse = [data[@"total"] integerValue];
            } else if (_selectBtn ==3) {
                _fltotalPageperson = [data[@"total"] integerValue];
            }
               //获取模型
            [self getModelForTableViewsWithTopicType:topicType data:(NSDictionary*)data];
            _isxjLoading = NO;
        } else {
            _isxjLoading = YES;
            [self endRefresh];
//            [[FLAppDelegate share] hideHUD];
        }
    } failure:^(NSError *error) {
        _isxjLoading = YES;
        FL_Log(@"error in square tableview info =%@",[FLTool returnStrWithErrorCode:error]);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        [self endRefresh];
//        [[FLAppDelegate share] hideHUD];
    }];
}

- (void)getModelForTableViewsWithTopicType:(NSString*)topicType data:(NSDictionary*)data {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* newArray = [FLSquareTools returnFLSquareAllFreeModelArray:data WithTopicType:topicType];
        if ([topicType isEqualToString:FLFLXJSquareAllFreeStrKey]) {
            for (FLSquareAllFreeModel* model in newArray) {
                [self.flsquareAllFreemodelmus addObject:model];
            }
            
        }  else if ([topicType isEqualToString:FLFLXJSquareCouponseStrKey])  {
            for (FLSquareConcouponseModel* model in newArray)  {
                [self.flsquareCouponsemodelmus addObject:model];
            }

        }  else if ([topicType isEqualToString:FLFLXJSquarePersonStrKey])  {
            for (FLSquarePersonalIssueModel* model in newArray)  {
                [self.flsquarePersonIssueInfomodelmus addObject:model];
            }
            NSMutableArray* muarray = [NSMutableArray array];
            NSArray* array = data[@"data"];
            for (NSInteger i = 0; i < newArray.count; i++) {
                NSString* str = [NSString stringWithFormat:@"%@%@",FLBaseUrl,array[i][@"thumbnail"]];
                str = [FLTool returnBigPhotoURLWithStr:str];
                FL_Log(@"str================%ld    %@",i,str);
                [self p_putImageWithURL:str];
                [muarray addObject:str];
            }
            NSArray* imageArray = [muarray mutableCopy];
            [self getImageWithArray:imageArray];
        }
         //本身界面用的模型
        self.flsquareAllFreeModels  = [self.flsquareAllFreemodelmus mutableCopy];
//        self.flsquareCouponseModels = [self.flsquareCouponsemodelmus mutableCopy];
        self.flsquarePersonIssueInfoModels = [self.flsquarePersonIssueInfomodelmus mutableCopy];
        //传给HTML页面的数组 也是没有更多数据的数据源
        [self getHTMLInfoInSquareWithData:data TopicType:topicType];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefresh];
            _isFirstTimeIn = NO;
        });
    });
    
}

- (void)getImageWithArray:(NSArray*)imageArray {
    for (NSString *item in imageArray) {
        ItemModel *model = [ItemModel new];
        model.imageUrl = item;
        [self.flsquarePersonIssuemodelmus addObject:model];
    }
    self.flsquarePersonIssueModels = [self.flsquarePersonIssuemodelmus mutableCopy];
    [self reloadDataWithController];
}

- (void)getHTMLInfoInSquareWithData:(NSDictionary*)data TopicType:(NSString*)topicType {
    NSArray* HTMLArr = data[FL_NET_DATA_KEY];
    if ([topicType isEqualToString:FLFLXJSquareAllFreeStrKey]) {
        for (NSDictionary* dic in HTMLArr) {
            [self.flHTMLAllFreeMuArr addObject:dic];
        }
    } else if ([topicType isEqualToString:FLFLXJSquareCouponseStrKey]) {
         for (NSDictionary* dic in HTMLArr) {
             [self.flHTMLCouponseMuArr addObject:dic];
         }
     }
     else if ([topicType isEqualToString:FLFLXJSquarePersonStrKey]) {
         for (NSDictionary* dic in HTMLArr) {
             [self.flHTMLPersonalMuArr addObject:dic];
         }
     }
    //传参
    self.flHTMLAllFreeArr = self.flHTMLAllFreeMuArr.mutableCopy;
    self.flHTMLCouponseArr =self.flHTMLCouponseMuArr.mutableCopy;
    self.flHTMLPersonalArr = self.flHTMLPersonalMuArr.mutableCopy;
}

#pragma mark ------refresh 注册
- (void)regreshDataInTableView {
//     __weak typeof(self) weakSelf = self;
//    allFreeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewAllFree)];
//    MJRefreshAutoGifFooter * footerOne = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataWithTableViewAllFree)];
//    allFreeTableView.mj_footer = footerOne;
//    
//    couponsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewAllFree)];
//     MJRefreshAutoGifFooter * footerTwo = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataWithTableViewAllFree)];
//    couponsTableView.mj_footer = footerTwo;
//    
//    _personalPushCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewAllFree)];
//    MJRefreshAutoGifFooter * footerThree = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataWithTableViewAllFree)];
//    _personalPushCollectionView.mj_footer = footerThree;
//    personalPushCollectionView.mj_footer
 
    for (UITableView* fltableview in _flsquareTableViews) {
        fltableview.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewAllFree)];
 
 
        //        _MJfooter =  [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataWithTableViewAllFree)];
        //        fltableview.mj_footer = self.MJfooter;
        MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataWithTableViewAllFree)];
        fltableview.mj_footer = footer;
    }
       [self beganToRefresh];
}
//下拉刷新
- (void)loadNewDataWithTableViewAllFree {
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.flsquareTagCurrentPages];
    switch (_selectBtn) {
        case 1: {
           self.flsquareAllFreeModels = nil;
            self.flHTMLAllFreeArr = nil;
              [self.flsquareAllFreemodelmus removeAllObjects];
            [self.flHTMLAllFreeMuArr removeAllObjects];
            NSInteger currentpage = [self.flsquareTagCurrentPages[_selectBtn - 1] integerValue];
            currentpage = 0;
            FL_Log(@"this is the current page===%ld",currentpage);
            [array replaceObjectAtIndex:(_selectBtn -1)  withObject:[NSNumber numberWithInteger:currentpage]];
            self.flsquareTagCurrentPages = array.mutableCopy;
        }
            break;
        case 2:{
//             self.flsquareCouponseModels = nil;
             [self.flsquareCouponsemodelmus removeAllObjects];
            [self.flHTMLCouponseMuArr removeAllObjects];
            NSInteger currentpage = [self.flsquareTagCurrentPages[_selectBtn - 1] integerValue];
            currentpage = 0;
            FL_Log(@"this is the current page===%ld",currentpage);
            [array replaceObjectAtIndex:(_selectBtn -1)  withObject:[NSNumber numberWithInteger:currentpage]];
            self.flsquareTagCurrentPages = array.mutableCopy;
        }
            break;
        case 3:{
            [self.flsquarePersonIssuemodelmus removeAllObjects];
            [self.heightArray removeAllObjects];
            [self.flsquarePersonIssueInfomodelmus removeAllObjects];
            [self.flHTMLPersonalMuArr removeAllObjects];
            NSInteger currentpage = [self.flsquareTagCurrentPages[_selectBtn - 1] integerValue];
            currentpage = 0;
            FL_Log(@"this is the current page===%ld",currentpage);
            [array replaceObjectAtIndex:(_selectBtn -1)  withObject:[NSNumber numberWithInteger:currentpage]];
            self.flsquareTagCurrentPages = array.mutableCopy;
        }
            break;
        default:
            break;
    }
    [self setTotalTopViewHiddenWithBoolen:NO];
    [self getSquareInfoWithCurrentPage:1 TopicType:_flrequestEnglishType[_selectBtn -1]];
    [self reloadDataWithController];
}
//reload data
- (void)reloadDataWithController {
    if (_selectBtn == 3) {
//         [((UICollectionView*)_flsquareTableViews[_selectBtn - 1]) reloadData];
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:NSNotFound inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [((UICollectionView*)_flsquareTableViews[_selectBtn - 1]) reloadItemsAtIndexPaths:@[indexPath]];
        });
    } else {
       [((UITableView*)_flsquareTableViews[_selectBtn - 1]) reloadData];
    }
}

- (void)loadMoreDataWithTableViewAllFree {
    //通过数组下标返回当前页
//    [[FLAppDelegate share] showSimplleHUDWithTitle:@"正在加载" view:FL_KEYWINDOW_VIEW_NEW];
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.flsquareTagCurrentPages];
    NSInteger currentpage = [self.flsquareTagCurrentPages[_selectBtn - 1] integerValue];
    if (!_isxjLoading) {
         currentpage ++;
    }
    FL_Log(@"this is the current page===%ld",currentpage);
    [array replaceObjectAtIndex:(_selectBtn -1)  withObject:[NSNumber numberWithInteger:currentpage]];
    self.flsquareTagCurrentPages = [array mutableCopy];
    FL_Log(@"ssssssssssssssssssss%ld",(long)[self.flsquareTagCurrentPages[_selectBtn - 1] integerValue]);
    //获得各个模型
    [self getSquareInfoWithCurrentPage:[self.flsquareTagCurrentPages[_selectBtn - 1] integerValue] + 1 TopicType:self.flrequestEnglishType[_selectBtn -1]];
}

#pragma mark ---refresh
- (void)beganToRefresh {
    if (_selectBtn == 3)  {
        [_personalPushCollectionView.mj_header beginRefreshing];
        [_personalPushCollectionView.mj_footer beginRefreshing];
    } else {
         [((UITableView*)_flsquareTableViews[_selectBtn - 1]).mj_header beginRefreshing];
         [((UITableView*)_flsquareTableViews[_selectBtn - 1]).mj_footer beginRefreshing];
    }
}

- (void)endRefresh {
    //添加没有更多数据
    if (_selectBtn == 3)  {
        [((UICollectionView*)_flsquareTableViews[_selectBtn - 1]).mj_header endRefreshing];
        [((UICollectionView*)_flsquareTableViews[_selectBtn - 1]).mj_footer endRefreshing];
        [self.personalPushCollectionView reloadData];
        if (_fltotalPageperson == self.flsquarePersonIssueInfomodelmus.count) {
            [_personalPushCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else{
            [_personalPushCollectionView.mj_footer endRefreshing];
        }
    }  else  {
        switch (_selectBtn) {
            case 1: {
                if ( _fltotalPageAllfree == _flsquareAllFreeModels.count ) {
                 
                    [((UITableView*)_flsquareTableViews[_selectBtn - 1]).mj_footer endRefreshingWithNoMoreData];
                } else {
                    [((UITableView*)_flsquareTableViews[_selectBtn - 1]).mj_footer endRefreshing];
                }
            }
                break;
            case 2:  {
                if ( _fltotalPagecouconpse == _flsquareCouponsemodelmus.count ) {
                    
                    [((UITableView*)_flsquareTableViews[_selectBtn - 1]).mj_footer endRefreshingWithNoMoreData];
                } else {
                    [((UITableView*)_flsquareTableViews[_selectBtn - 1]).mj_footer endRefreshing];
                }
            }
                break;
            
            default:
                break;
        }
           [((UITableView*)_flsquareTableViews[_selectBtn - 1]).mj_header endRefreshing];
        [_flsquareTableViews[_selectBtn - 1] reloadData];
    }
    
}

#pragma mark -- item 的个数
#pragma mark ------ UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.flsquarePersonIssuemodelmus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    创建cell
//    ItemCell *cell = (ItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"item"forIndexPath:indexPath];
    CYItemCell *cell = (CYItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CYItemCell"forIndexPath:indexPath];
//    拿到数据
    ItemModel *model = [self.flsquarePersonIssueModels objectAtIndex:indexPath.row];
    
//    给cell设置数据
    cell.itemModel = model;
    if (self.flsquarePersonIssueInfoModels.count!=0) {
        cell.flsquarePersonalModel = self.flsquarePersonIssueInfoModels[indexPath.row];
    }
//    NSString *imgUrlString = model.imageUrl;
//    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
////            NSLog(@"cy----%@",NSStringFromCGSize(image.size));
//            if (!CGSizeEqualToSize(model.imageSize, image.size)) {
//                model.imageSize = image.size;
////                [personalPushCollectionView reloadItemsAtIndexPaths:@[indexPath]];
//            }
//        }
//    }];
    return cell;
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    ItemModel *model = [self.flsquarePersonIssueModels objectAtIndex:indexPath.row];
//    if (!CGSizeEqualToSize(model.imageSize, CGSizeZero)) {
//        CGSize flsize = model.imageSize;
//        flsize.height += 100;
//        return flsize;
//    }
//    return CGSizeMake(150, 150);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FL_Log(@"indexPathInSquare=%@",indexPath);
     FLFuckHtmlViewController* htmlVC = [[FLFuckHtmlViewController alloc] init];
    htmlVC.flFuckTopicId = self.flHTMLPersonalArr[indexPath.row][@"topicId"];
    htmlVC.isPersonalComeIn = YES;
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)reloadCollectionView {
//    FL_Log(@"接收到了通知，刷新collectionView");
//    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:NSNotFound inSection:0];
//    [personalPushCollectionView reloadItemsAtIndexPaths:@[indexPath]];
}


#pragma mark -------view did disappare
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //防止其他界面隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 登录
- (void)huanxinLogin{
    NSString *userName = [NSString stringWithFormat:@"person_%@",FL_USERDEFAULTS_USERID_NEW];
    NSLog(@"cyuserid %@",FL_USERDEFAULTS_USERID_NEW);
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:@"123456" completion:^
     (NSDictionary *loginInfo, EMError *error) {
         if (!error && loginInfo) {
             FL_Log(@"登录成功W3ith环信");
         }
     } onQueue:nil];
    // 设置自动登录
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
    [self saveLastLoginUsername]; // 保存一下，以后会用得到
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self xjSetApns];
    
}



- (void)saveLastLoginUsername {
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

- (void)shanchu {
    NSString* sstr= [NSString stringWithFormat:@"%@/app/receives!exportReceiveUserlist.action?d=%d&topic.topicId=%@",FLBaseUrl,randomNumber,@"16"];
//    sstr = [NSString stringWithFormat:@"点击下载\n%@\n如果不能下载，右键复制链接",sstr];
    
//    [FLFinalNetTool flNewSendEmailWithTitle:@"点击下面地址下载列表" address:@"121314202@qq.com" content:sstr attachementArr:nil success:^(NSDictionary *data) {
//        FL_Log(@"this is test send eamil=%@",data);
//    } failure:^(NSError *error) {
//        
//    }];
//    NSDictionary* parm = @{@"nikeName":@"x"};
//    [FLNetTool xjgetPersonInfoByNickName:parm success:^(NSDictionary *data) {
//        FL_Log(@"sdadsadasfasdaewqraw=%@",data);
//        NSArray* xjArrPerson = data[FLFLXJUserTypePersonStrKey];
//        NSArray* xjArrComp   = data[FLFLXJUserTypeCompStrKey];
//        NSArray* xxx = [XJSearchByNickNamePersonModel mj_objectArrayWithKeyValuesArray:xjArrPerson];
//        FL_Log(@"lllllslsllslslsl=%@ = =%@",xjArrPerson,xjArrPerson);
//    } failure:^(NSError *error) {
//        
//    }];
//
}

#pragma mark -- 返回每个item的高度
- (CGFloat)itemHeightLayOut:(AoiroSoraLayout *)layOut indexPath:(NSIndexPath *)indexPath {
    
    if ([self.heightArray[indexPath.row] integerValue] < 0 || !self.heightArray[indexPath.row]) {
        
        return 250;
    }  else  {
        NSInteger intger = [self.heightArray[indexPath.row] integerValue];
        return intger + 100;
    }
    
}

#pragma mark -- collectionView 的分组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark -- 获取 图片 和 图片的比例高度
- (void)p_putImageWithURL:(NSString *)url {
    // 获取图片
    
    CGSize  size = [BLImageSize dowmLoadImageSizeWithURL:url];
    
    // 获取图片的高度并按比例压缩
    NSInteger itemHeight = size.height * (((self.view.frame.size.width - 20) / 2 / size.width));
    
    NSNumber * number = [NSNumber numberWithInteger:itemHeight];
    
    [self.heightArray addObject:number];
    
}

// 懒加载数组
- (NSMutableArray *)heightArray {
    if (_heightArray == nil) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

- (void)xjSetUserInfoModelWithModel:(FLUserInfoModel*) xjUserInfoModel{
    [FLUserInfoModel share].flloginNumber = xjUserInfoModel.flloginNumber;
    [FLUserInfoModel share].flpassWord = xjUserInfoModel.flpassWord;
    [FLUserInfoModel share].fluserId = xjUserInfoModel.fluserId;
    [FLUserInfoModel share].flnickName = xjUserInfoModel.flnickName;
    [FLUserInfoModel share].flbirthday = xjUserInfoModel.flbirthday;
    [FLUserInfoModel share].flsex = xjUserInfoModel.flsex;
    [FLUserInfoModel share].flavatar = xjUserInfoModel.flavatar;
    [FLUserInfoModel share].fladdress = xjUserInfoModel.fladdress;
    [FLUserInfoModel share].flSource = xjUserInfoModel.flSource;
    [FLUserInfoModel share].flStateInt = xjUserInfoModel.flStateInt;
    NSArray* xjtasgArr= [xjUserInfoModel.flTagsStr componentsSeparatedByString:@","];
    [FLUserInfoModel share].fltagsArray = xjtasgArr;
    
}

- (void)xjAlertAccountError {
    UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:@"对不起" message:@"账户处于非正常状态，请联系管理员" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* xjSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [flAlertViewController addAction:xjSureAction];
    [self presentViewController:flAlertViewController animated:YES completion:nil];
}

- (void)xjSetApns{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    options.displayStyle = ePushNotificationDisplayStyle_simpleBanner;
    options.nickname = @"caocaocaocoacoao";
    
}

- (void)didReceiveMessage:(EMMessage *)message {
    
}

- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage {
   
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages {
    
}

- (void)xjTestToGoSearch { //暂时不用
    XJSearchViewController* xjSearch = [[XJSearchViewController alloc] init];
    xjSearch.xjSearchSystemArr = self.xjSystemSearchTags.mutableCopy;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:xjSearch animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    XJSearchViewController* xjSearch = [[XJSearchViewController alloc] init];
    xjSearch.xjSearchSystemArr = self.xjSystemSearchTags.mutableCopy;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:xjSearch animated:YES];
    return NO;
}

 

@end








































