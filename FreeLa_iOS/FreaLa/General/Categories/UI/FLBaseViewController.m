//
//  FLBaseViewController.m
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBaseViewController.h"
#import "FLAppDelegate.h"
#import "FLTestDDVote.h"
#import "UIView+EasyFrame.h"

@interface FLBaseViewController ()

@end

@implementation FLBaseViewController

- (NSString *)naviTitle {
    return @"";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = DDColor(249, 249, 249, 1);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //控制滑动返回, 如果有问题立即注释
    //    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //    [self createNavigationBar];
}
- (void)createNavigationBar{
    //    NSArray *controlls = self.navigationController.viewControllers;
    //    if (controlls.count <= 1) {
    //        return;
    //    }
    //
    //    NSInteger index = [controlls indexOfObject:self];
    //    if (index==0) {
    //        return;
    //    }
    //
    //    DDBaseViewController *superCtr = [controlls objectAtIndex:index-1];
    //    if (superCtr) {
    //        if ([superCtr isKindOfClass:[DDBaseViewController class]]) {
    //            [self createBackButtonWithImage:nil title:superCtr.naviTitle];
    //        }
    //        else{
    //            [self createBackButtonWithImage:nil title:superCtr.title];
    //        }
    //    }
}

- (void)createBackButtonWithImage:(UIImage *)image title:(NSString *)title {
    //    if (!title) {
    //        title = @"";
    //    }
    //
    //    int x =0 ;
    //    if (title.length < 3) {
    //        x = -15;
    //    }
    //
    //    // 设置左键
    //    IconButton *leftButton = [[IconButton alloc] initWithFrame:CGRectZero style:IconButtonStyleIconLeft];
    //    [leftButton setTitle:title forState:UIControlStateNormal];
    //    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [leftButton setTitleEdgeOffsets:UIEdgeOffsetsMake(x, 0, 0, 0)];
    //    if (!image) {
    //         [leftButton setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    //    }
    //    else{
    //         [leftButton setImage:image forState:UIControlStateNormal];
    //    }
    //
    //    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    //    [leftButton setFrame:CGRectMake(0, 0, 90, 45)];
    //    [leftButton setShowsTouchWhenHighlighted:YES];
    //    [leftButton addTarget:self action:@selector(returnBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIButton *holdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    holdBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    holdBtn.backgroundColor = [UIColor clearColor];
    holdBtn.showsTouchWhenHighlighted = YES;
    [holdBtn addTarget:self action:@selector(returnBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftBan = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBan.exclusiveTouch = YES;
    leftBan.showsTouchWhenHighlighted = YES;
    leftBan.frame = CGRectMake(-4, 0, 25, 25);
    [leftBan setImage:image forState:UIControlStateNormal];
    [holdBtn addSubview:leftBan];
    leftBan.userInteractionEnabled = NO;
    
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.backgroundColor = [UIColor clearColor];
    logo.image = [UIImage imageNamed:@"topLogo"];
    logo.frame = CGRectMake(21, 0, 29, 29);
    [holdBtn addSubview:logo];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = title;
    textLabel.font = [UIFont systemFontOfSize:17];
    textLabel.textColor = [UIColor whiteColor];
    CGSize textSize = [title sizeWithFont:textLabel.font];
    textLabel.size = textSize;
    textLabel.frame = CGRectMake(CGRectGetMaxX(logo.frame)+4, logo.frame.origin.y, textSize.width, textSize.height);
    [holdBtn addSubview:textLabel];
    
    holdBtn.width = CGRectGetMaxX(textLabel.frame);
    holdBtn.height = logo.height;
    textLabel.centerY = holdBtn.height/2;
    leftBan.centerY = holdBtn.height/2;
    logo.centerY = holdBtn.height / 2;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:holdBtn];
}

- (void)pushNavigationerToController:(FLBaseViewController *)controller {
    UINavigationController *nav = [FLAppDelegate share].naviController;
    [nav pushViewController:controller animated:YES];
}

- (void)popNavigationer {
    UINavigationController *nav = [FLAppDelegate share].naviController;
    [nav popViewControllerAnimated:YES];
}

- (void)returnBtnTapped:(id)sender {
    [self popNavigationer];
}

- (UIBarButtonItem *)buttonWithFrame:(CGRect)frame
                           andString:(NSString *)str
                           andTarget:(id)target
                         andSelector:(SEL)selector {
    UIButton *btn         = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame             = frame;
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font   = [UIFont systemFontOfSize:15];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}





@end





















