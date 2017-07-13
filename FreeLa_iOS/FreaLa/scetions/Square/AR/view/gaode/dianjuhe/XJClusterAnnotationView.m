//
//  XJClusterAnnotationView.m
//  iOS_ClusterAnnotation_3D
//
//  Created by Leon on 2017/1/5.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

#import "XJClusterAnnotationView.h"
#import "ClusterAnnotation.h"

#define kWidth  60.f
#define kHeight (kWidth * 1.1)

static CGFloat const ScaleFactorAlpha = 0.3;
static CGFloat const ScaleFactorBeta = 0.4;
/* 返回rect的中心. */
CGPoint RectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/* 返回中心为center，尺寸为rect.size的rect. */
CGRect CenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

/* 根据count计算annotation的scale. */
CGFloat ScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * ScaleFactorAlpha * powf(value, ScaleFactorBeta)));
}

#pragma mark -

@interface XJClusterAnnotationView()
@property (nonatomic , strong) UILabel *countLabel;
@property (nonatomic , strong) UIImageView* xjImgView;
@property (nonatomic , strong) UIImageView* xjHeaderImgView;
@end

@implementation XJClusterAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setupImgView];//创建imgview
        [self setCount:1];
    }
    
    return self;
}

#pragma mark Utility

- (void)setupImgView {
    _xjImgView = [[UIImageView alloc] init];
    _xjImgView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:_xjImgView];
    _xjImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self setupLabel];
}
- (void)setupLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height-10)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor       = [UIColor whiteColor];
    _countLabel.textAlignment   = NSTextAlignmentCenter;
    _countLabel.shadowColor     = [UIColor colorWithWhite:0.0 alpha:0.75];
    _countLabel.shadowOffset    = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
    
    
    self.xjHeaderImgView = [[UIImageView alloc] init];
    self.xjHeaderImgView.frame = CGRectMake(0, 0, 22, 22);
    self.xjHeaderImgView.center = CGPointMake(_xjImgView.centerX, 20);
    self.xjHeaderImgView.layer.cornerRadius = 11;
    self.xjHeaderImgView.layer.masksToBounds = YES;
//    self.xjHeaderImgView.backgroundColor = [UIColor redColor];
    [_xjImgView addSubview:self.xjHeaderImgView];
    
}



- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subViews = self.subviews;
    if ([subViews count] > 1)
    {
        for (UIView *aSubView in subViews)
        {
            if ([aSubView pointInside:[self convertPoint:point toView:aSubView] withEvent:event])
            {
                return YES;
            }
        }
    }
    if (point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < self.frame.size.height)
    {
        return YES;
    }
    return NO;
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    /* 按count数目设置view的大小. */
//    CGRect newBounds = CGRectMake(0, 0, roundf(44 * ScaledValueForValue(count)), roundf(44 * ScaledValueForValue(count)));
//    self.frame = CenterRect(newBounds, self.center);
    
//    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
//    self.countLabel.frame = CenterRect(newLabelBounds, RectCenter(newBounds));
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld个",count];// [@(_count) stringValue];
    self.countLabel.hidden = count==1?YES:NO;
    
    NSString* imgName = count==1?@"jialibaokong":@"ar_gift_light_more";
//    _xjImgView.backgroundColor = [UIColor blackColor];
    _xjImgView.image = [UIImage imageNamed:imgName];
    [self setNeedsDisplay];
}
- (void)xj_setCount:(NSInteger)count isInCircle:(BOOL)isin {
    _count = count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld个",count];// [@(_count) stringValue];
    self.countLabel.hidden = count==1?YES:NO;
    NSString* imgName;
    if (isin) {
        imgName = count==1?@"jialibaokong":@"ar_gift_light_more";
    } else {
        imgName = count==1?@"jialibaokong":@"ar_fudai-much";
    }
    _xjImgView.image = [UIImage imageNamed:imgName];
    [self setNeedsDisplay];
}

- (void)setXjHeaderImgStr:(NSString *)xjHeaderImgStr{
    _xjHeaderImgStr = xjHeaderImgStr;
    if ([XJFinalTool xjStringSafe:xjHeaderImgStr]) {
        xjHeaderImgStr = [XJFinalTool xjReturnImageURLWithStr:xjHeaderImgStr isSite:NO];
        [self.xjHeaderImgView sd_setImageWithURL:[NSURL URLWithString:xjHeaderImgStr] placeholderImage:[UIImage imageNamed:@""]];
    }
}
- (void)setXjHeaderImgPath:(NSString *)xjHeaderImgPath {
    _xjHeaderImgPath = xjHeaderImgPath;
    if ([XJFinalTool xjStringSafe:xjHeaderImgPath]){
        self.xjHeaderImgView.image = [UIImage imageNamed:xjHeaderImgPath];
    }
}

#pragma mark - annimation

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self addBounceAnnimation];
}

- (void)addBounceAnnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    bounceAnimation.duration = 0.6;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++)
    {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    
    bounceAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

#pragma mark draw rect

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetAllowsAntialiasing(context, true);
//    
//    UIColor *outerCircleStrokeColor = [UIColor colorWithWhite:0 alpha:0.25];
//    UIColor *innerCircleStrokeColor = [UIColor whiteColor];
//    UIColor *innerCircleFillColor = [UIColor colorWithRed:(255.0 / 255.0) green:(95 / 255.0) blue:(42 / 255.0) alpha:1.0];
//    
//    CGRect circleFrame = CGRectInset(rect, 4, 4);
//    
//    [outerCircleStrokeColor setStroke];
//    CGContextSetLineWidth(context, 5.0);
//    CGContextStrokeEllipseInRect(context, circleFrame);
//    
//    [innerCircleStrokeColor setStroke];
//    CGContextSetLineWidth(context, 4);
//    CGContextStrokeEllipseInRect(context, circleFrame);
//    
//    [innerCircleFillColor setFill];
//    CGContextFillEllipseInRect(context, circleFrame);
}

@end




