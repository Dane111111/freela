//
//  XJUserAnnotationView.m
//  FreeLa
//
//  Created by Leon on 2017/1/4.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJUserAnnotationView.h"
#define kWidth  40.f
#define kHeight (kWidth * 1.4)

#define xjAvatarW  (kWidth - 14)


#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0


@interface XJUserAnnotationView ()

@property (nonatomic , strong) UIImageView* xjBaseImgView;
@end


@implementation XJUserAnnotationView

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (UIImageView *)xjUserHeaderImageView {
    if (!_xjUserHeaderImageView) {
        _xjUserHeaderImageView = [[UIImageView alloc] init];
    }
    return _xjUserHeaderImageView;
}

- (UIImageView *)xjBaseImgView {
    if (!_xjBaseImgView) {
        _xjBaseImgView = [[UIImageView alloc] init];
    }
    return _xjBaseImgView;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //user 目前 不需要 弹出框
//    if (self.selected == selected)
//    {
//        return;
//    }
//    
//    if (selected)
//    {
//        if (self.calloutView == nil)
//        {
//            /* Construct custom callout. */
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(10, 10, 40, 40);
//            [btn setTitle:@"Test" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//            [btn setBackgroundColor:[UIColor whiteColor]];
//            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self.calloutView addSubview:btn];
//            
//            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
//            name.backgroundColor = [UIColor clearColor];
//            name.textColor = [UIColor whiteColor];
//            name.text = @"Hello Amap!";
//            [self.calloutView addSubview:name];
//        }
//        
//        [self addSubview:self.calloutView];
//    }
//    else
//    {
//        [self.calloutView removeFromSuperview];
//    }
    
    [super setSelected:selected animated:animated];
}


#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
 
        CGFloat xjW = kWidth* 0.5;
        CGFloat xj_avatarX = (kWidth / 2) - (xjW / 2);
        CGFloat xj_avatarY = kWidth * 0.05;
        
        self.xjUserHeaderImageView.frame =  CGRectMake(xj_avatarX,  xj_avatarY, xjW, xjW);
        [self addSubview:_xjUserHeaderImageView];
        self.xjUserHeaderImageView.layer.cornerRadius = xjW/2;
        self.xjUserHeaderImageView.layer.masksToBounds = YES;
        self.xjUserHeaderImageView.backgroundColor = [UIColor blackColor];
        self.xjUserHeaderImageView.contentMode = UIViewContentModeScaleToFill;
        
        self.xjBaseImgView.frame = CGRectMake(0.f, 0.f, kWidth, kHeight);
        [self addSubview:self.xjBaseImgView];
        self.xjBaseImgView.image = [UIImage imageNamed:@"ar_marker_selfbackground"];
        
    }
    
    return self;
}



@end












