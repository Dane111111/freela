//
//  FLFreeCircleViewController.m
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

#import "FLFreeCircleViewController.h"

#import "CYChatListViewController.h"
#import "CYContactViewController.h"
#import "CYAttentionViewController.h"
#import "CYRecommendViewController.h"

#import "ContactListViewController.h"
#import "ConversationListController.h"
#import "ApplyViewController.h"
 

@interface FLFreeCircleViewController ()<UIScrollViewDelegate>
{
    BOOL xjIsChangePersonType;
}


@property(nonatomic,weak) UIScrollView *contentView;
@property(nonatomic,strong)UIButton *selectedBtn; // 这个记录状态的必须强引用
@property(nonatomic,weak) UIView *redIndicatorView;
@property(nonatomic,weak)UIView *titleView;

@property(nonatomic,strong) ContactListViewController *xjContactsVC;
@property(nonatomic,strong) ConversationListController  *xjChatListVC;
@property(nonatomic,strong) CYAttentionViewController *xjAttentionVC;
@property(nonatomic,strong) CYRecommendViewController *xjRecommendVC;
@end
//static BOOL xjIsChangePersonType; //是不是改变 是角色
@implementation FLFreeCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    xjIsChangePersonType = FLFLIsPersonalAccountType;
    self.view.backgroundColor = [UIColor whiteColor];;
    [self setUpNavBar];
    [self setupContentView];// UIScrollView
    [self setupChildVC];    // 设置的子控制器
    [self createSubVC:0];   // 第一次进入
    [self setupTitleViewWithArr:@[@"推荐",@"关注",@"聊天",@"通讯录"]];//    标题部分 UIView,注意，由于标题要始终在上面，所以要最后添加
}

- (void)setUpNavBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_back_red_new"] forBarMetrics:UIBarMetricsDefault];
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    self.navigationController.navigationBar.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
}

/**
 *  内容部分 UIScrollView
 */
- (void)setupContentView{
    self.automaticallyAdjustsScrollViewInsets = NO; // 第一个子控件是ScrollView,不让系统自动调整
    //    self.view - ScrollView 的内容向下移动
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.cy_width, self.view.cy_height)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(self.view.cy_width * 4, 0); //设置0 不可以在垂直方向滚动
    contentView.pagingEnabled = YES;
    self.contentView = contentView;
    self.contentView.delegate = self;
//    self.contentView.backgroundColor = [UIColor blueColor];
    contentView.scrollEnabled = NO;
    [self.view addSubview:contentView];
}

#pragma  mark ---------------------- lazy
- (ContactListViewController *)xjContactsVC {
    if (!_xjContactsVC) {
        _xjContactsVC = [[ContactListViewController alloc] init];
    }
    return _xjContactsVC;
}
- (ConversationListController *)xjChatListVC {
    if (!_xjChatListVC) {
        _xjChatListVC = [[ConversationListController alloc] init];
    }
    return _xjChatListVC;
}
- (CYAttentionViewController *)xjAttentionVC {
    if (!_xjAttentionVC) {
        _xjAttentionVC = [[CYAttentionViewController alloc] init];
    }
    return _xjAttentionVC;
}
- (CYRecommendViewController *)xjRecommendVC {
    if (!_xjRecommendVC) {
        _xjRecommendVC = [[CYRecommendViewController alloc] init];
    }
    return _xjRecommendVC;
}
/**
 *  创建子控制器
 */
- (void)setupChildVC{
    
//    self.xjRecommendVC = [[CYRecommendViewController alloc] init];
    [self addChildViewController:self.xjRecommendVC]; //推荐
    
    //    self.xjAttentionVC = [[CYAttentionViewController alloc] init];
    [self addChildViewController:self.xjAttentionVC]; //关注
    
    //    self.xjChatListVC = [[ConversationListController alloc] init];
    //    CYChatListViewController *chatListVC = [[CYChatListViewController alloc] init];
    [self addChildViewController:self.xjChatListVC]; //聊天
    
    //    self.xjContactsVC = [[ContactListViewController alloc] init];
    [self addChildViewController:self.xjContactsVC]; //通讯录
}
/**
 *  添加子控制器
 */
- (void)xjSetChildVCWithBool:(BOOL)xjIsPersonal {
//    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (xjIsPersonal) {
        [self addChildViewController:self.xjRecommendVC];//推荐
        [self addChildViewController:self.xjAttentionVC];//关注
        [self addChildViewController:self.xjChatListVC];//聊天
        [self addChildViewController:self.xjContactsVC];//通讯录
        [self setupTitleViewWithArr:@[@"推荐",@"关注",@"聊天",@"通讯录"]];
    } else {
        [self addChildViewController:self.xjChatListVC];
        [self addChildViewController:self.xjContactsVC];
        [self setupTitleViewWithArr:@[@"聊天",@"通讯录"]];
    }
}

/**
 *  根据索引，拿到对应的控制器，将对应的控制器tableView添加到 scrollView的contentView上
 */
- (void)createSubVC:(NSInteger)index{
    UIViewController *tempVC = (UIViewController*)self.childViewControllers[index];
    tempVC.view.frame = CGRectMake(self.view.cy_width * index, 35, self.view.cy_width, self.view.cy_height);
    //    tempVC.tableView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.cy_bottom+35, 0, 49,0); // 上 左 下 右
//    tempVC.v.scrollIndicatorInsets =UIEdgeInsetsMake(64+35, 0, 49,0); //设置滚动条的 insets
    [self.contentView addSubview:tempVC.view];
    [self.view endEditing:YES];
}

/**
 *标题部分 UIView
 */
-(void)setupTitleViewWithArr:(NSArray*)titleStrArr{
    if (self.titleView) {
        [self.titleView removeFromSuperview];
    }
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cy_width,35)];
    titleView.backgroundColor = [UIColor colorWithRed:249 green:249 blue:249 alpha:1];
    self.titleView = titleView;
    
    CGFloat btnX = self.view.cy_width / titleStrArr.count / 2;
    CGFloat btnY = 0;
    
    for (int i = 0; i < titleStrArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i; //
        [btn setTitle:titleStrArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15]; // 设置按钮的文字大小
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateSelected];
        if(i == 0){
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [btn setBackgroundColor:[UIColor blueColor]];
        [btn sizeToFit];
        btn.cy_centerX = btnX + i * (self.view.cy_width / titleStrArr.count);
        btn.cy_y = btnY;
        
        [titleView addSubview:btn];
    }

    //    底部的指示条
    UIView * redIndicatorView = [[UIView alloc] init];
    redIndicatorView.backgroundColor =  XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    
    UIButton *tempBtn = (UIButton*)titleView.subviews[0];
    
    redIndicatorView.cy_height = 2;
    redIndicatorView.cy_y = (35 - 2);
    [tempBtn.titleLabel sizeToFit];// 立刻根据文字内容计算label的宽度,这一步很关键，titleLable 不sizeToFit一下是不能知道尺寸的
    redIndicatorView.cy_width = tempBtn.titleLabel.cy_width * 2;
    redIndicatorView.cy_centerX = tempBtn.cy_centerX;
    self.redIndicatorView =redIndicatorView;
    
    [titleView addSubview:redIndicatorView];
    [self.view addSubview:titleView];
        [self createSubVC:0];   // 第一次进入


}


- (void)changeTitle:(UIButton*)btn{
    //    “三步曲”
    self.selectedBtn.selected = NO; //取消上次选中
    btn.selected = YES; // 当前按钮选中
    self.selectedBtn = btn; // 保存当前选中
    
    //    改变底部指示View的位置
    [UIView animateWithDuration:0.25 animations:^{
        self.redIndicatorView.cy_centerX = btn.cy_centerX;
    }];
}

/**
 *  操作方式一：点击标题
 */
- (void)onBtnClick:(UIButton*)btn{
    
    [self changeTitle:btn];
    
    //    滚动到相对的位置，展示对应的控制器
    [self.contentView setContentOffset:CGPointMake(self.view.cy_width * btn.tag, 0) animated:YES];
    
}
// 指定位置 -- 停止滚动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index =  scrollView.contentOffset.x / self.view.cy_width;
    [self createSubVC:index];
    //    NSLog(@"指定位置 滚动");
}

/**
 *  操作方式二：手势拖动 -- 停止滚动
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index =  scrollView.contentOffset.x / self.view.cy_width;
    
    [self createSubVC:index];
    
    UIButton *btn = (UIButton*)self.titleView.subviews[index];
    [self changeTitle:btn];
    //    CYLog(@"停止滚动"); // 手指抬起，感觉不能从减速来理解
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.tabBarController.tabBar setHidden: NO ] ;
    [self.navigationController.navigationBar setHidden:NO];
    [self setUpNavBar];
    
    if (xjIsChangePersonType != FLFLIsPersonalAccountType) {
        for (UIViewController* xjViewController in self.childViewControllers) {
            [xjViewController removeFromParentViewController];
        }
        self.xjContactsVC=nil;
        self.xjChatListVC=nil;
        self.xjAttentionVC=nil;
        self.xjRecommendVC=nil;

        xjIsChangePersonType = FLFLIsPersonalAccountType;
//        self.view=nil;
        [self xjSetChildVCWithBool:FLFLIsPersonalAccountType];
    }
}

@end
