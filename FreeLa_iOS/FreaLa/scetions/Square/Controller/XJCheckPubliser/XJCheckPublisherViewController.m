//
//  XJCheckPublisherViewController.m
//  FreeLa
//
//  Created by Leon on 16/6/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//  发布者的查看页(个人)

#import "XJCheckPublisherViewController.h"
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
#import "XJBusTopViewNumberView.h"
#import "XJFreelaUVManager.h"
#define xjTag      10010

@interface XJCheckPublisherViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    NSInteger _xjTotalMyIssue; //我发布的 总数
    CGRect fltopFrame;  //用于计算移动距离
    CGFloat fltopViewH;
    BOOL _isViewWillAperar;   //没办法了
}
@property (nonatomic , strong)UIImageView* portraitImageView; //肖像
/**头像button*/
@property (nonatomic , strong)UIButton*    portraitBtn;//头像button
/**headerVIew*/
@property (nonatomic , strong)UIView* headerVIew;
@property (nonatomic , strong)UIImageView* tipImageView;//提示图片
@property (nonatomic,  strong)UIImageView *backgroundImageView; //背景


@property (nonatomic , strong)UILabel*  moveLabel;   //顶部分栏移动的 线条
//头部视图
@property (nonatomic , strong)UIView* topViewAndHeaderView;

/**我发布的*/
@property (nonatomic , strong) XJTableView* flmyIssueTableView;

/**背景*/
@property (nonatomic , weak)UIScrollView* scrollView;
/**我发布的可变数组*/
@property (nonatomic , strong)NSMutableArray* flMyIssueInMineModelMus;

/**名称的button*/
@property (nonatomic , strong) UIButton* myNameButton;
/**收藏的button*/
@property (nonatomic , strong) UIButton* xjAddBtn;


@property (nonatomic , strong) NSString* xjUserIdStr;

@property (nonatomic , strong) FLMineInfoModel* xjMineInfoModel;
/**头像下方三个label*/
@property (nonatomic , strong)XJBusTopViewNumberView*  xjTopNumberView;//头像下方三个 label

@end

@implementation XJCheckPublisherViewController


- (instancetype)initWithUserId:(NSString*)xjUserId {
    self = [super init];
    if (self) {
        self.xjUserIdStr = xjUserId;
        [self xjCreateViewWithUserId];
    }
    return self;
}

- (void)xjCreateViewWithUserId {
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatScrollView]; //底部scrollview
    [self creatTopViewAndHeaderView];//头视图+顶部分栏
    [self creatTableView];//创建tableView
    [self getInfoMationInHTML]; //获取发布数等
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.flmyIssueTableView registerNib:[UINib nibWithNibName:@"XJMyIssueTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMyIssueTableViewCell"]; //我发布的
    // 添加所有子控制器
    [self setUpUI];
    //header footer
    [self refreshHeaderAndFooterInMine];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self seeAllUserInfo];
    _isViewWillAperar = YES;
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
    [self xjCheckIsFriend];
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    self.flmyIssueTableView.delegate = self;
    [self scrollViewDidScroll:self.flmyIssueTableView];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setHidden: NO];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma  mark  ---- --- -- -------------         Lazy
- (UIView *)topViewAndHeaderView{
    if (!_topViewAndHeaderView) {
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
- (NSMutableArray *)flMyIssueInMineModelMus {
    if (!_flMyIssueInMineModelMus) {
        _flMyIssueInMineModelMus = [NSMutableArray array];
    }
    return _flMyIssueInMineModelMus;
}
- (XJBusTopViewNumberView *)xjTopNumberView{
    if (!_xjTopNumberView) {
        _xjTopNumberView = [[XJBusTopViewNumberView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 40)];
        _xjTopNumberView.xjItemsArr = @[@"发布数",@"粉丝数",@"热度"];
    }
    return _xjTopNumberView;
}


- (void)setUpUI {
    
    UIColor * titleColor = [UIColor blackColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    //背景色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    FL_Log(@"status width - %f", rectStatus.size.width); // 宽度
    FL_Log(@"status height - %f", rectStatus.size.height);   // 高度
    
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    FL_Log(@"nav width - %f", rectNav.size.width); // 宽度
    FL_Log(@"nav height - %f", rectNav.size.height);   // 高度
}
#pragma mark ----------Actions

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    UIColor* color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
        self.title = self.xjMineInfoModel.nickname;
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    }
    //movelabel移动功能
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.flMyIssueInMineModelMus.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier;
    CellIdentifier = @"XJMyIssueTableViewCell";
    XJMyIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.flMyIssueInMineModelMus.count > indexPath.row ) {
        cell.flMyIssueInMineModel =  self.flMyIssueInMineModelMus[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FL_Log(@"dianle=%@",indexPath);
    if (tableView == _flmyIssueTableView)  {
        FLMyIssueActivityControlViewController* detailVC = [[FLMyIssueActivityControlViewController alloc] init];
        [self getIssueInfoDataForAgainWithIndexPath:indexPath.row];
        //此处模型为详情model
        FLMyIssueInMineModel* xjModel = self.flMyIssueInMineModelMus.count >= indexPath.row ? self.flMyIssueInMineModelMus[indexPath.row]:nil;
        detailVC.xjTopicId = xjModel.flMineIssueTopicIdStr;
        
        //f
        FLFuckHtmlViewController* xjVc =  [[FLFuckHtmlViewController alloc] init];
        xjVc.flFuckTopicId = xjModel.flMineIssueTopicIdStr;
        [self.navigationController pushViewController:xjVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.flmyIssueTableView ) {
        return 130 ;
    }
    return 80;
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
                           @"topic.userId":self.xjUserIdStr ? self.xjUserIdStr:@"",
                           @"topic.userType":FLFLXJUserTypePersonStrKey
                           };
    NSMutableDictionary* xjxj = parm.mutableCopy;
    if ( [self.xjUserIdStr integerValue] ==[XJ_USERID_WITHTYPE integerValue]) {
        [xjxj setObject:@"" forKey:@"topic.checkUserId"];
    } else {
        [xjxj setObject:[NSString stringWithFormat:@"%@",self.xjUserIdStr] forKey:@"topic.checkUserId"];
    }
    parm = xjxj.mutableCopy;
    [FLNetTool searchTopicListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"check data in test my issue=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _xjTotalMyIssue = [data[@"total"] integerValue];
            NSArray* newArray = [FLMineTools returnMyIssueInMineModelsWithDictionary:data type:1];
            for (FLMyIssueInMineModel* model in newArray) {
                [self.flMyIssueInMineModelMus addObject:model];
            }
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
//刷新
- (void)refreshHeaderAndFooterInMine {
    self.flmyIssueTableView.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewMyIssue)];
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataInTableViewMyIssue)];
    self.flmyIssueTableView.mj_footer = footer;
    [self beginRefreshInMineViewController];
}
#pragma mark ------------------ 下啦刷新
- (void)loadNewDataWithTableViewMyIssue
{
    if (!FL_USERDEFAULTS_USERID_NEW ) {
        [self endRefreshInMineViewController];
    } else {
        [self getModelsInMineVCWithCurrentPage:[NSNumber numberWithInteger:1]];
        [self.flMyIssueInMineModelMus removeAllObjects];
    }
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FL_TopColumnView_Height + self.headerVIew.height);
    
}
//上拉加载
- (void)loadMoreDataInTableViewMyIssue {
    [self getModelsInMineVCWithCurrentPage:[FLTool xjRetuenCurrentWithArrLength:self.flMyIssueInMineModelMus.count andTotal:_xjTotalMyIssue xjSize:0]]; //评价列表
}
#pragma mark 刷新
//开始刷新
- (void)beginRefreshInMineViewController{
    [self.flMyIssueInMineModelMus removeAllObjects];
    [self.flmyIssueTableView.mj_header beginRefreshing];
}

//结束刷新
- (void)endRefreshInMineViewController {
    [self.flmyIssueTableView.mj_header endRefreshing];
    if (self.flMyIssueInMineModelMus.count > _xjTotalMyIssue) {
        [self.flmyIssueTableView.mj_footer endRefreshing];
    } else {
        [self.flmyIssueTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark--------init
//创建底部scrollView

- (void)creatScrollView {
    CGFloat scrollX = 0;
    CGFloat scrollY = 0;//FL_TopColumnView_Height ;//CGRectGetMaxX(self.topView.frame);
    CGFloat scrollW = FLUISCREENBOUNDS.width;
    CGFloat scrollH = FLUISCREENBOUNDS.height;
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
    self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
    self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

    //    [self.portraitBtn setBackgroundImage:[UIImage imageNamed:@"logo_freela"] forState:UIControlStateNormal];
    self.portraitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.portraitBtn.layer.cornerRadius = 60 * FL_SCREEN_PROPORTION_width;
    self.portraitBtn.backgroundColor = [UIColor whiteColor];
    self.portraitBtn.layer.masksToBounds = YES;  //解决圆形button 添加图片溢出后的问题
    [self.headerVIew addSubview:self.portraitBtn];
    [self.portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.center.equalTo(self.backgroundImageView).with.offset(0);
        make.centerX.equalTo(self.backgroundImageView).with.offset(0);
        make.centerY.equalTo(self.backgroundImageView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(120 * FL_SCREEN_PROPORTION_width, 120 * FL_SCREEN_PROPORTION_width));
    }];
    
    
    
    //头像下方名字btn
    self.myNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.myNameButton setTitle:@"nickName" forState:UIControlStateNormal];
    [self.myNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.myNameButton.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
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
    // 收藏按钮
    self.xjAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjAddBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.xjAddBtn setImage:[UIImage imageNamed:@"btn_collection_white_version2"] forState:UIControlStateNormal];
    [self.xjAddBtn addTarget:self action:@selector(xjClickToAddFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *xjCollectionItem = [[UIBarButtonItem alloc] initWithCustomView:self.xjAddBtn];
    [self.navigationItem setRightBarButtonItem:xjCollectionItem];
    
    self.topViewAndHeaderView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width,  self.headerVIew.height);
    [self.view addSubview:self.topViewAndHeaderView];
}

- (void)xjClickToAddFriend{
    
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
    
    
}


#pragma mark- ------usernet

- (void)seeAllUserInfo {
    NSDictionary* parm  = @{@"userid": self.xjUserIdStr ? self.xjUserIdStr : @"",
                            @"accountType": FLFLXJUserTypePersonStrKey};
    FL_Log(@"see in新piuubliesherfo 新 in mine :sesdddssionId = %@  parm = %@",FL_ALL_SESSIONID,parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        if (data) {
            FL_Log(@"success in mine see info: %@  ,  tags = %@  dis = %@",data,[data objectForKey:@"tags"], [data objectForKey:@"description"]);
            self.xjMineInfoModel = [FLMineInfoModel mj_objectWithKeyValues:data];
            self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
            self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

            [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:self.xjMineInfoModel.avatar isSite:NO]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(!image){
                    image = [UIImage imageNamed:@""];
                }
                UIImage* imageTuUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
                self.backgroundImageView.image = imageTuUse;
            }];
            //            [self.myNameButton setTitle:self.xjMineInfoModel.nickname forState:UIControlStateNormal];
            self.title = self.xjMineInfoModel.nickname;
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

#pragma mark  TA发布的
- (void)getIssueInfoDataForAgainWithIndexPath:(NSInteger)indexPath {
    if (self.flMyIssueInMineModelMus.count > indexPath) {
        FLMyIssueInMineModel* xjModel = self.flMyIssueInMineModelMus[indexPath];
        NSDictionary* parm = @{@"topic.topicId":xjModel.flMineIssueTopicIdStr,
                               @"userType":  FLFLXJUserTypePersonStrKey ,
                               @"userId":self.xjUserIdStr,
                               @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjModel.flMineIssueTopicIdStr]};
        [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"test detail wit3h with =%@",data);
           [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjModel.flMineIssueTopicIdStr];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)xjSetAddBtnStateWithBool:(BOOL)xjIsFriend {
    [self.xjAddBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",xjIsFriend ? @"business":@"addGroup"]] forState:UIControlStateNormal];
    //    [self.xjAddBtn addTarget:self action:@selector(xjAddPublisher) forControlEvents:UIControlEventTouchUpInside];
    if (xjIsFriend) {
        [self.xjAddBtn setTarget:self action:@selector(xjRemoveFriend) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.xjAddBtn setTarget:self action:@selector(xjAddPublisher) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma  mark ----------  添加发布者为好友（关注)
-(void) xjAddPublisher {
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    NSDictionary* parm = @{@"owerName":[NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE],
                           @"friendName":[NSString stringWithFormat:@"%@_%@",FLFLXJUserTypePersonStrKey,self.xjUserIdStr]};
    [FLNetTool xjAddFriendsByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result 3to add friend=%@",data);
        NSDictionary* xjDic = data[FL_NET_DATA_KEY];
        if ([data[FL_NET_KEY_NEW] boolValue] && [xjDic[@"statusCode"] integerValue]==200) {
            [FLTool showWith:@"关注成功"];
            [self xjSetAddBtnStateWithBool:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma  mark ---------- 是不是好友（关注)
- (void)xjCheckIsFriend {
    NSDictionary* parm = @{@"imOwerName":[NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE],
                           @"imFriendName":[NSString stringWithFormat:@"%@_%@",FLFLXJUserTypePersonStrKey,self.xjUserIdStr]};
    [FLNetTool xjCheckIsFriendsByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result to check friend=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if ([data[FL_NET_DATA_KEY]boolValue]) {
                [self xjSetAddBtnStateWithBool:YES];
            } else {
                [self xjSetAddBtnStateWithBool:NO];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)xjRemoveFriend {
    EMError *error;
    NSString* xjStr = [NSString stringWithFormat:@"%@_%@",FLFLXJUserTypePersonStrKey,self.xjUserIdStr];
    [[EaseMob sharedInstance].chatManager removeBuddy:xjStr removeFromRemote:YES error:&error];
    [self hideHud];
    if (error) {
        [FLTool showWith:@"取消关注失败"];
    } else{
        [FLTool showWith:@"取消关注成功"];
        [self xjSetAddBtnStateWithBool:NO];
    }
}
#pragma mark -----------获取发布者数据
- (void)getInfoMationInHTML {
    NSDictionary* parm = @{@"topic.userId":self.xjUserIdStr ? self.xjUserIdStr :@"",
                           @"topic.userType":FLFLXJUserTypePersonStrKey,
                           @"token":FL_ALL_SESSIONID,
                           @"topic.checkUserId":@""};
    [FLNetTool flHTMLGetPublisherMessageByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my test nbus mine othis thing=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjTopNumberView.xjHotStr = [NSString stringWithFormat:@"%@",data[@"pvNum"] ? data[@"pvNum"] : @"0"];
            self.xjTopNumberView.xjIssueStr = [NSString stringWithFormat:@"%@",data[@"num"] ? data[@"num"]   : @"0"];
            self.xjTopNumberView.xjFriendStr = @"保密呀";
        }
        
    } failure:^(NSError *error) {
        
        FL_Log(@"this is my test nothis thing=%@",error);
    }];
}

@end











