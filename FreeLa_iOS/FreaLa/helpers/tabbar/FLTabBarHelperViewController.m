//
//  FLTabBarHelperViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLTabBarHelperViewController.h"
#import "FLHeader.h"
#import "AnimateTabbar.h"

#import "FLMineViewController.h"
#import "FLFreeCircleViewController.h"
#import "FLSquareViewController.h"


#define STATUSBAR_HIEGHT      FL_STATUSBAR.height     //状态栏高度
#define NAVI_BAR_HEIGHT       FL_NAVI_BAR_SIZE.height //导航栏高度


@interface FLTabBarHelperViewController ()<AnimateTabbarDelegate>
@property(nonatomic , strong)FLMineViewController* mineVC;
@property(nonatomic , strong)FLFreeCircleViewController* freeVC;
@property(nonatomic , strong)FLSquareViewController* squareVC;
@property(nonatomic , strong)UIViewController * currentVC;
//@property(nonatomic , strong)UIWindow *window;
@end

@implementation FLTabBarHelperViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
    
    AnimateTabbarView* tabbar = [[AnimateTabbarView alloc]initWithFrame:CGRectMake(0, 0,FLUISCREENBOUNDS.width , FLUISCREENBOUNDS.height)];
    tabbar.delegate = self;
    [self.view addSubview:tabbar];
    
    self.mineVC = [[FLMineViewController alloc]initWithNibName:@"FLMineViewController" bundle:nil];
    self.freeVC = [[FLFreeCircleViewController alloc]init];
    self.squareVC = [[FLSquareViewController alloc]init];
    
    [self.squareVC.view setFrame:CGRectMake(0, 60, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - 47 - STATUSBAR_HIEGHT - NAVI_BAR_HEIGHT)];
    [self.squareVC.view setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
    [self.freeVC.view setFrame:CGRectMake(0, 60, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - 47- STATUSBAR_HIEGHT - NAVI_BAR_HEIGHT)];
    [self.freeVC.view setBackgroundColor:[UIColor greenColor]    ];
    [self.mineVC.view setFrame:CGRectMake(0, 60, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - 47- STATUSBAR_HIEGHT - NAVI_BAR_HEIGHT)];
    [self.mineVC.view setBackgroundColor:[UIColor whiteColor]];
    
    [self addChildViewController:self.squareVC];
    [self addChildViewController:self.freeVC];
    [self addChildViewController:self.mineVC];
    [self.view addSubview:self.squareVC.view];
    self.currentVC = self.squareVC;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

// callback
int g_flags=1;
-(void)FirstBtnClick{
    
    if(g_flags==1)
        return;
    [self transitionFromViewController:self.currentVC toViewController:self.squareVC duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
         self.currentVC = self.squareVC;
        g_flags=1;
        
    }];
}
-(void)SecondBtnClick{
    if(g_flags==2)
        return;
    [self transitionFromViewController:self.currentVC toViewController:self.freeVC duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        self.currentVC=self.freeVC;
        g_flags=2;
        
    }];
    
}
-(void)ThirdBtnClick
{
    if(g_flags==3)
        return;
    [self transitionFromViewController:self.currentVC toViewController:self.mineVC duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        self.currentVC=self.mineVC;
        g_flags=3;
        
    }];
    
}
-(void)FourthBtnClick{
    //BarView.text=@"fourth";
}




@end
























