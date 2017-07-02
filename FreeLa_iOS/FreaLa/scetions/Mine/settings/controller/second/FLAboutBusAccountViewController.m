//
//  FLAboutBusAccountViewController.m
//  FreeLa
//
//  Created by Leon on 15/11/12.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLAboutBusAccountViewController.h"
#define NAVBAR_CHANGE_POINT 50

@interface FLAboutBusAccountViewController ()<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView* scrollView;
@property (nonatomic , strong)UITableView* tableView;

@property (nonatomic , strong)UIButton* buttonApply;
@property (nonatomic , strong)UIButton* buttonAlready;
//@property (nonatomic , assign)NSNumber* blindNumber;
@property (nonatomic , assign)NSInteger blindNumber;
@end

@implementation FLAboutBusAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatSrollView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.delegate = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    //    [self.scrollView setContentOffset:CGPointMake(0, 69) animated:YES]; //设置起始位置
    //设置颜色
    UIColor * titleColor = [UIColor blackColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.title = @"我的商家账号";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor redColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self checkMyBlindNumber];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.scrollView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    UIColor * color = [UIColor redColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        UIColor * titleColor = [UIColor whiteColor];
        NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:dict];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        UIColor * titleColor = [UIColor blackColor];
        NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:dict];
    }
}


- (void)checkMyBlindNumber {
    NSDictionary* parm = @{@"token":XJ_USER_SESSION };
    //
    if (![FLTool isNetworkEnabled]) {
        [[FLAppDelegate share] showHUDWithTitile:@"没有网络" view:self.view delay:1 offsetY:0];
    }else{
        //fortest
        [FLNetTool checkNumbersOfblindWithMyselfWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"this is my count in check %ld======",[[data objectForKey:@"count"]integerValue]);
            self.blindNumber = [[data objectForKey:@"count"] integerValue];
        } failure:^(NSError *error) {
            FL_Log(@" %@ =======  %@",error.description,error.debugDescription);
        }];
    }
    
}

- (void)applyBusAccount {
    
    if(self.blindNumber >= 5){
        NSString* xjUserId = XJ_USERID_WITHTYPE;
        NSInteger userId = [xjUserId integerValue];
        if ([XJFinalTool  xj_is_superAccount]) {
            FLApplyBusinessAccountViewController * applyVC = [[FLApplyBusinessAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
            FLFLXJISApplyBusOrRevokeMyAccount = 1;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:FL_BUSAPPLY_INFO_KEY];
            applyVC.flBusRegistModelNew.phone = self.flPhone;
            [self.navigationController pushViewController:applyVC animated:YES];
        } else {
            [[FLAppDelegate share] showHUDWithTitile:@"个人的最大绑定数量为5个" view:self.view delay:1 offsetY:0];
        }
    } else{
        FLApplyBusinessAccountViewController * applyVC = [[FLApplyBusinessAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
        FLFLXJISApplyBusOrRevokeMyAccount = 1;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:FL_BUSAPPLY_INFO_KEY];
        applyVC.flBusRegistModelNew.phone = self.flPhone;
        [self.navigationController pushViewController:applyVC animated:YES];
    }
}

- (void)goToBusAccount
{
    if(self.blindNumber == 0)
    {
        [[FLAppDelegate share] showHUDWithTitile:@"你还没有商家号，快去注册一个吧" view:self.view delay:1 offsetY:0];
    }
    else
    {
        FLChangeMyAccountTableViewController* changeVC = [[FLChangeMyAccountTableViewController alloc] init];
        [self.navigationController pushViewController:changeVC animated:YES];
        //        [self presentViewController:changeVC animated:YES completion:nil];
    }
    
}


- (void)creatSrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, -69, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
    [self.view addSubview:self.scrollView];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutBus.png"]];
    CGFloat imgH = imageView.image.size.height;
    imageView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, imgH);
    [self.scrollView addSubview:imageView];
    
    CGRect frame = CGRectZero;
    frame = imageView.frame;
    //    frame.size.height += 64;
    //scrollview 的属性
    self.scrollView.contentSize = frame.size;
    //隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    //设置button 的view
    UIView *view = [[UIView alloc] init];
    frame.origin = CGPointMake(0, FLUISCREENBOUNDS.height - 64);
    frame.size  = CGSizeMake(FLUISCREENBOUNDS.width, 64);
    view.frame = frame;
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    //设置button
    self.buttonApply = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonAlready = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.buttonApply setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    [self.buttonAlready setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    
    [self.buttonApply setTitle:@"申请商家号" forState:UIControlStateNormal];
    [self.buttonAlready setTitle:@"已有商家号" forState:UIControlStateNormal];
    
    [self.buttonApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonAlready setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [view addSubview:self.buttonApply];
    [view addSubview:self.buttonAlready];
    
    [self.buttonApply addTarget:self action:@selector(applyBusAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonAlready addTarget:self action:@selector(goToBusAccount) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonApply.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    self.buttonAlready.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    //约束
    [self.buttonApply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).with.offset(0);
        make.left.equalTo(view).with.offset(10);
        make.width.mas_equalTo((FLUISCREENBOUNDS.width / 2) - 40);
        
        
    }];
    
    [self.buttonAlready mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonApply).with.offset(0);
        make.right.equalTo(view).with.offset(-10);
        make.width.mas_equalTo((FLUISCREENBOUNDS.width / 2) - 40);
    }];
}



@end















