//
//  BGAnnotationView.m
//  FreeLa
//
//  Created by MBP on 17/7/7.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "BGAnnotationView.h"
@interface BGAnnotationView ()
@property (nonatomic , strong) UIImageView* xjImgView;

@end

@implementation BGAnnotationView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 50, 50);
        self.backgroundColor = [UIColor clearColor];
        [self setupImgView];//创建imgview

    }
    
    return self;
}
#pragma mark Utility

- (void)setupImgView {
    _xjImgView = [[UIImageView alloc] init];
    [self addSubview:_xjImgView];
    _xjImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
- (void)setXjHeaderImgStr:(NSString *)xjHeaderImgStr{
    _xjHeaderImgStr = xjHeaderImgStr;
    if ([XJFinalTool xjStringSafe:xjHeaderImgStr]) {
        xjHeaderImgStr = [XJFinalTool xjReturnImageURLWithStr:xjHeaderImgStr isSite:NO];
        [self.xjImgView sd_setImageWithURL:[NSURL URLWithString:xjHeaderImgStr] placeholderImage:[UIImage imageNamed:@""]];
    }
}

- (void)xj_setCount:(NSInteger)count isInCircle:(BOOL)isin {
    _count = count;
//    self.countLabel.text = [NSString stringWithFormat:@"%ld个",count];// [@(_count) stringValue];
//    self.countLabel.hidden = count==1?YES:NO;
//    NSString* imgName;
//    if (isin) {
//        imgName = count==1?@"ar_gift_light_single":@"ar_gift_light_more";
//    } else {
//        imgName = count==1?@"ar_fudai-singl":@"ar_fudai-much";
//    }
//    _xjImgView.image = [UIImage imageNamed:imgName];
//    [self setNeedsDisplay];
}

@end
