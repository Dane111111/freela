//
//  ClusterTableViewCell.m
//  iOS_3D_ClusterAnnotation
//
//  Created by PC on 15/7/7.
//  Copyright (c) 2015年 FENGSHENG. All rights reserved.
//

#import "ClusterTableViewCell.h"

#define  xjCellH        60
#define  xjHeaderImg    40
#define  xjMargin       (xjCellH-xjHeaderImg)/2

@implementation ClusterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.tapBtn = [[UIButton alloc] initWithFrame:self.bounds];
        self.tapBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
//        UIImage *tappedImage = [self createImageWithColor:[UIColor colorWithWhite:0.667 alpha:0.3] andSize:self.tapBtn.frame.size];
//        [self.tapBtn setBackgroundImage:tappedImage forState:UIControlStateHighlighted];
    
        [self addSubview:self.tapBtn];
        
        
        [self xj_initCallOutCell];
    }
    
    return self;
}

- (void)xj_initCallOutCell {
    self.xj_headerImg = [[UIImageView alloc] init];
    [self addSubview:_xj_headerImg];
    _xj_headerImg.frame = CGRectMake(xjMargin*2, xjMargin, xjHeaderImg, xjHeaderImg);
    
    
}

- (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
