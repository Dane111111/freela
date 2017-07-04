//
//  DEBaseViewController.m
//  FreeLa
//
//  Created by MBP on 17/7/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "DEBaseViewController.h"

@interface DEBaseViewController ()
@property(nonatomic,strong)UIButton*leftBtn;
@property(nonatomic,strong)UIButton*rightBtn;
@property(nonatomic,strong)UIView*titleView;

@end

@implementation DEBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    //    progressView = [[MBProgressHUD alloc] initWithView:self.view];
    //    progressView.dimBackground = NO;
    //    [self.view addSubview:progressView];
    
    [self setNavTitle:self.title ];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self. navigationController.viewControllers.count == 1) {
        self.tabBarController.hidesBottomBarWhenPushed=NO;
    }else{
        [self setNavBackArrowWithWidth:44];
        self.tabBarController.hidesBottomBarWhenPushed=YES;
    }
    
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn=btn;
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn=btn;
    }
    return _rightBtn;
    
}
-(UIView *)titleView{
    if (!_titleView) {
        UIView*view=[[UIView alloc]init];
        _titleView=view;
    }
    return _titleView;
}
-(UIView *)NavView{
    if (!_NavView) {
        self.navigationController.navigationBar.hidden=YES;
        UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
        view.backgroundColor=[UIColor whiteColor];
        view.alpha = 1;
        [self.view addSubview:view];
        
        _NavView=view;
    }
    return _NavView;
}
- (void)setNavTitle:(NSString *)title
{
    [self setNavTitle:title withColor:[UIColor whiteColor]];
}

- (void)setNavTitle:(NSString *)title withColor:(UIColor *)color
{
    if (_titleView) {
        [_titleView removeFromSuperview];
    }
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = color;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    
    CGFloat width = [Helper widthForLabelWithString:title withFontSize:20 withWidth:DEVICE_WIDTH withHeight:44];
    CGFloat maxWidth = 120;
    if(width <= DEVICE_WIDTH-2*maxWidth){
        titleLabel.frame = CGRectMake(0, 0, DEVICE_WIDTH-maxWidth*2, 44);
        titleView.frame = CGRectMake(maxWidth, 0, DEVICE_WIDTH-maxWidth*2, 44);
    }
    else{
        CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
        CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
        CGRect frame;
        CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
        maxWidth += 15;
        frame = titleLabel.frame;
        frame.size.width = DEVICE_WIDTH - maxWidth * 2;
        titleLabel.frame = frame;
        
        frame = titleView.frame;
        frame.size.width = DEVICE_WIDTH - maxWidth * 2;
        titleView.frame = frame;
    }
    titleLabel.text = title;
    [titleView addSubview:titleLabel];
    titleView.y=titleView.y+20;
    _titleView=titleView;
    
    [self.NavView addSubview:_titleView];
}
#pragma mark private method
-(void)setLeftButtonWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action btnTitleColor:(UIColor*)btnTitleColor{
    [self setButtonWithImg:norImg selImg:selImg title:title action:action type:0 btnTitleColor:btnTitleColor];
}
-(void)setRightButtonWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action btnTitleColor:(UIColor*)btnTitleColor{
    [self setButtonWithImg:norImg selImg:selImg title:title action:action type:1 btnTitleColor:btnTitleColor];
}

-(void)setButtonWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action type:(int)leftOrRight btnTitleColor:(UIColor*)btnTitleColor
{
    
    CGRect frame =  CGRectMake(10, 20, 44, 44);
    
    UIButton *button;
    if (leftOrRight==1) {
        [self.rightBtn removeFromSuperview];
        button=self.rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    }else{
        [self.leftBtn removeFromSuperview];
        button=self.leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    
    button.exclusiveTouch = YES;
    if (norImg)
        [button setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    if (selImg)
        [button setImage:[UIImage imageNamed:selImg] forState:UIControlStateHighlighted];
    if (title) {
        CGSize strSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        button.titleLabel.textAlignment=NSTextAlignmentLeft;
        [button setTitleColor:btnTitleColor forState:UIControlStateNormal];
        frame.size.width = MAX(frame.size.width, strSize.width+10);
    }
    button.frame = frame;
    if (leftOrRight==1) {
        button.cy_right=DEVICE_WIDTH-10;
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.NavView addSubview:button];
}

//设置返回按钮
- (void)setNavBackArrowWithWidth:(CGFloat)width
{
    
    UIButton *button = self.leftBtn;
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"btn_icon_goback_white"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 20, 44, width);
    [button addTarget:self action:@selector(navBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavView addSubview:button ];
}
//返回按钮点击事件
- (void)navBackButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) setNavWithLeftView:(UIView *) leftview andMidView:(UIView *) midView andRightView:(UIView*) RightView{
    [self.view addSubview:_NavView];
    
    if(leftview){
        [self.NavView addSubview:leftview];
    }
    if(midView){
        [self.NavView addSubview:midView];
    }
    if(leftview){
        [self.NavView addSubview:RightView];
    }
    
}



- (void) setNavWithLeftView:(UIView *) view andCenterView:(UIView *) centerView{
    [self.view addSubview:self.NavView];
    if(view){
        [self.NavView addSubview:view];
    }
    if(centerView){
        [self.NavView addSubview:centerView];
    }
}






- (void) setNavWithLeftView:(UIView *) view{
    if(view){
        [self.NavView addSubview:view];
    }
}

@end
