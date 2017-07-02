//
//  FLMyReceiveControlViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyReceiveControlViewController.h"
 
#define FL_VC_Bottom_Top_Margin 5
#define FL_VC_Bottom_image_H  25
#define FL_Btn_baseTag        138
#define fl_topBtn_count     3

@interface FLMyReceiveControlViewController ()
{
    FLMyReceiveBaseViewController *chatVC;
    FLMyReceiveTicketsViewController *contactVC;
    FLMyReceiveJudgeViewController *attentionVC;
}
@property(nonatomic,weak) UIScrollView *contentView;
@property(nonatomic,strong)UIButton *selectedBtn; // 这个记录状态的必须强引用
@property(nonatomic,weak) UIView *redIndicatorView;
@property(nonatomic,weak)UIView *titleView;
@end

@implementation FLMyReceiveControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
    [self setupContentView];// UIScrollView
    [self setupChildVC];    // 设置的子控制器
    [self createSubVC:0];   // 第一次进入
    [self setupTitleView];//    标题部分 UIView,注意，由于标题要始终在上面，所以要最后添加
//    self.title = [NSString stringWithFormat:@"%@--%@",self.flmyReceiveMineModel.flMineTopicThemStr,_flmyReceiveMineModel.flMineIssueTopicIdStr];
    self.title = @"我领取的";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    //    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}


- (void)setUpNavBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}

/**
 *  内容部分 UIScrollView
 */
- (void)setupContentView{
    self.automaticallyAdjustsScrollViewInsets = NO; // 第一个子控件是ScrollView,不让系统自动调整
    //    self.view - ScrollView 的内容向下移动
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.cy_width, self.view.cy_height)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(self.view.cy_width * fl_topBtn_count, 0); //设置0 不可以在垂直方向滚动
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    self.contentView = contentView;
    self.contentView.delegate = self;
    //    self.contentView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:contentView];
}

/**
 *  添加子控制器
 */
- (void)setupChildVC{
    
    chatVC = [[FLMyReceiveBaseViewController alloc] init];
    chatVC.xjTioicId = _xjTopicId;
    chatVC.xjDetailsId = _xjDetailsId;
    [self addChildViewController:chatVC];
    
    contactVC = [[FLMyReceiveTicketsViewController alloc] init];
    contactVC.xjTioicId = _xjTopicId;
    contactVC.xjDetailsId = _xjDetailsId;
    [self addChildViewController:contactVC];
    
    attentionVC = [[FLMyReceiveJudgeViewController alloc] init];
    attentionVC.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    attentionVC.xjTioicId = _xjTopicId;
    attentionVC.xjDetailsId = _xjDetailsId;
    [self addChildViewController:attentionVC];
    
}

/**
 *  根据索引，拿到对应的控制器，将对应的控制器tableView添加到 scrollView的contentView上
 */
- (void)createSubVC:(NSInteger)index{
    UIViewController *tempVC = (UIViewController*)self.childViewControllers[index];
    tempVC.view.frame = CGRectMake(self.view.cy_width * index, 0, self.view.cy_width, self.view.cy_height);
    //    tempVC.tableView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.cy_bottom+35, 0, 49,0); // 上 左 下 右
    //    tempVC.v.scrollIndicatorInsets =UIEdgeInsetsMake(64+35, 0, 49,0); //设置滚动条的 insets
    [self.contentView addSubview:tempVC.view];
}

/**
 *标题部分 UIView
 */
-(void)setupTitleView{
    
    NSArray *titleStrArr = @[@"管理",@"票券",@"评价"];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBar_NaviHeight, self.view.cy_width,FL_TopColumnView_Height_S)];
    titleView.backgroundColor = [UIColor colorWithRed:249 green:249 blue:249 alpha:1];
    self.titleView = titleView;
    [self.view addSubview:titleView];
    
    CGFloat btnX = self.view.cy_width / fl_topBtn_count / 2;
    CGFloat btnY = 0;
    
    for (int i = 0; i < titleStrArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i; //
        [btn setTitle:titleStrArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:XJ_FCOLOR_REDFONT] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        if(i == 0){
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [btn setBackgroundColor:[UIColor blueColor]];
        [btn sizeToFit];
        btn.cy_centerX = btnX + i * (self.view.cy_width / fl_topBtn_count);
        btn.cy_y = btnY;
        
        [titleView addSubview:btn];
    }
    
    //    底部的指示条
    UIView * redIndicatorView = [[UIView alloc] init];
    redIndicatorView.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    
    UIButton *tempBtn = (UIButton*)titleView.subviews[0];
    
    redIndicatorView.cy_height = 1;
    redIndicatorView.cy_y = (35 - 1);
    [tempBtn.titleLabel sizeToFit];// 立刻根据文字内容计算label的宽度,这一步很关键，titleLable 不sizeToFit一下是不能知道尺寸的
    redIndicatorView.cy_width = tempBtn.titleLabel.cy_width * 2;
    redIndicatorView.cy_centerX = tempBtn.cy_centerX;
    self.redIndicatorView =redIndicatorView;
    
    [titleView addSubview:redIndicatorView];
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

- (UIScrollView *)contentView {
    if (!_contentView) {
        [self setupContentView];
    }
    return _contentView;
}


//选中了谁啊
- (void)setXjSelectedIndex:(NSInteger)xjSelectedIndex {
    _xjSelectedIndex = xjSelectedIndex;
    //    [self createSubVC:xjSelectedIndex];  //会导致崩溃呀
    if (!self.titleView) {
        [self setupTitleView];
    }
    [self.contentView setContentOffset:CGPointMake(xjSelectedIndex * FLUISCREENBOUNDS.width, 0) animated:YES]; //滚动位置
    //设置
    UIButton *btn = (UIButton*)self.titleView.subviews[xjSelectedIndex];
    [self changeTitle:btn];
}


@end








