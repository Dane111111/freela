//
//  FLWelcomeViewController.m
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/15.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//
#import "FLAppDelegate.h"
#import "FLWelcomeViewController.h"
#import "FLHeader.h"
#import "FLSquareViewController.h"
#import "FLMineViewController.h"
#import "FLFreeCircleViewController.h"
#import "FLRegisterViewController.h"

#import "FLViewoViewController.h"
#import "FLLogIn_RegisterViewController.h"

#import "FLTool.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"
#import <ImageIO/ImageIO.h>

@interface FLWelcomeViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *allImageNames;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIScrollView*myScrollView;

@end

@implementation FLWelcomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    scrollView.delegate=self;
    scrollView.pagingEnabled=YES;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    //    创建可见视图大小
    scrollView.frame = CGRectMake(0,0,  rect.size.width,rect.size.height);
//    [scrollView setBackgroundColor:[UIColor redColor]];
    scrollView.contentSize=CGSizeMake(FLUISCREENBOUNDS.width*self.allImageNames.count, rect.size.height);
    for (NSUInteger i =0; i<3; i++)
    {
        NSString*uslStr= [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_%ld.gif",i+1] ofType:nil];
        NSURL*url=[NSURL fileURLWithPath:uslStr];
        NSData*data=[NSData dataWithContentsOfURL:url];
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.backgroundColor=[UIColor blueColor];
        NSArray*imageArr=[self praseGIFDataToImageArray:data];
        imageView.animationImages=imageArr;
        imageView.image=imageArr[imageArr.count-1];
        imageView.animationRepeatCount=1;
        imageView.animationDuration=imageView.animationImages.count*0.04;
        [imageView startAnimating ];
        
//        YFGIFImageView* imageView = [[YFGIFImageView alloc] init];
//        imageView.gifPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_%ld.gif",i+1] ofType:nil];
//        imageView.unRepeat = NO;
// 
//        [imageView startGIF];
        
//        UIImageView*imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_%ld.gif",i+1]]];
        CGRect frame=CGRectZero;
        frame.size = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        frame.origin= CGPointMake(i*scrollView.frame.size.width, 0);
        
        imageView.frame  = frame;
//        NSLog(@"x :%f",self.view.frame.origin.x);
//        NSLog(@"y :%f",self.view.frame.origin.y);
//        NSLog(@"sx :%f",self.view.frame.size.width);
//        NSLog(@"sy :%f",self.view.frame.size.height);
        //添加到滚动视图中
        [scrollView addSubview:imageView];
        
    }
    
    
//    UIPageControl *pageControl=[[UIPageControl alloc]init];
//    self.pageControl=pageControl;//赋值
//    pageControl.frame=CGRectMake(0, FLUISCREENBOUNDS.height-40-30, self.view.frame.size.width, 30);
//    pageControl.numberOfPages=self.allImageNames.count;
//    pageControl.pageIndicatorTintColor=[UIColor blackColor] ;
//    pageControl.currentPageIndicatorTintColor=[UIColor redColor];
//    pageControl.userInteractionEnabled=NO;
//    //    pageControl.currentPage=3; 圆点将固定
//    [self.view addSubview:pageControl];
    
//    UIButton* button=[UIButton buttonWithType:UIButtonTypeSystem];
//    [button addTarget:self action:@selector(enterAPP:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame=CGRectMake((self.allImageNames.count-1)*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
//    
//    [scrollView addSubview:button];
    [self.view addSubview:scrollView];
    self.myScrollView=scrollView;

    
    
}
//gif 转数组、
-(NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    YFGIFImageView* imageView=[self.myScrollView subviews][0];
//    [imageView startGIF];

}




//小圆点随图片移动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint p = scrollView.contentOffset;
    //NSLog(@"%@",NSStringFromCGPoint(p));
    NSUInteger index = p.x/FLUISCREENBOUNDS.width;
    self.pageControl.currentPage = index;
    UIImageView*anImageView=[scrollView subviews][index];
    [anImageView startAnimating];
    

    //    将pageControl属性升级，并设置赋值
//    for(YFGIFImageView* imageView in [scrollView subviews]){
//                        [[YFGIFManager shared].gifViewHashTable removeObject:imageView];
//
//    }
//    YFGIFImageView* imageView=[scrollView subviews][index];
//    [imageView startGIF];

    if (scrollView.contentOffset.x >= (_allImageNames.count -1 ) * FLUISCREENBOUNDS.width) {
        scrollView.scrollEnabled=NO;
        [self performSelector:@selector(enterAPP:) withObject:nil/*可传任意类型参数*/ afterDelay:anImageView.animationImages.count*0.04];
    }
}
#pragma mark -------init

//初始化图片
-(NSArray *)allImageNames{
    if (!_allImageNames) {
//        _allImageNames=@[@"Welcome1.png",@"Welcome2.png",@"Welcome3.png",@"Welcome4.png"];
        _allImageNames = @[@"1",@"2",@"3"];
    }
    return _allImageNames;
}


//点击进入主界面
- (void)enterAPP:(UIButton* )button
{
    [self GoToFLRegisterView];
}

- (void)GoToFLRegisterView
{
    NSLog(@"点击scrollView成功");
    //推出注册登陆界面
//    FLRegisterViewController*  registerVC = [[FLRegisterViewController alloc]initWithNibName:@"FLRegisterViewController" bundle:nil];
    
//    FLViewoViewController* VideoVC = [FLViewoViewController alloc];
//    [self presentViewController:VideoVC animated:YES completion:^{
//        NSLog(@"推登陆注册页成功");
//    }];
    FLLogIn_RegisterViewController* LogIn_RegisterVC = [[FLLogIn_RegisterViewController alloc]init];
    [self presentViewController:LogIn_RegisterVC animated:YES completion:nil];
    
}





#warning 这儿进主界面
/*
- (void)enterAPP:(UIButton* )button
{
    //配置tabbar
    FLSquareViewController*        FLSquareVC     = [[FLSquareViewController alloc]initWithNibName:@"FLSquareViewController" bundle:nil];
    FLFreeCircleViewController*    FLFreeCircleVC = [[FLFreeCircleViewController alloc]initWithNibName:@"FLFreeCircleViewController" bundle:nil];
    FLMineViewController*          FLMineVC       = [[FLMineViewController alloc]initWithNibName:@"FLMineViewController" bundle:nil];
    UITabBarController*            tabBar         = [[UITabBarController alloc]init];
    UINavigationController*        NaviSquare     = [[UINavigationController alloc]initWithRootViewController:FLSquareVC];
    UINavigationController*        NaviMine       = [[UINavigationController alloc]initWithRootViewController:FLMineVC];
    UINavigationController*        NaviFreeCircle = [[UINavigationController alloc]initWithRootViewController:FLFreeCircleVC];
    tabBar.viewControllers                        = @[NaviSquare,NaviFreeCircle,NaviMine];
    FLAppDelegate*                 app            = [UIApplication sharedApplication].delegate;
    tabBar.tabBar.tintColor = [UIColor orangeColor];//文字颜色
//    tabBar.tabBar.selectionIndicatorImage         = [UIImage imageNamed:@"2.2"];//选中图片
//    tabBar.tabBar.selectionIndicatorImage=[UIImage imageNamed:@"tabbar_selected_back"];

    app.window.rootViewController = tabBar;
    
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
