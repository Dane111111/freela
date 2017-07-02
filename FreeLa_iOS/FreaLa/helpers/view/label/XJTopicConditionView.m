//
//  XJTopicConditionView.m
//  FreeLa
//
//  Created by Leon on 16/5/26.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJTopicConditionView.h"

@interface XJTopicConditionView ()
@property (nonatomic , strong) UIImageView* xjBottomView;
@property (nonatomic , strong) UILabel* xjLabel;
@end

@implementation XJTopicConditionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xjInitPage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xjInitPage];
    }
    return self;
}

- (void)xjInitPage {
    self.xjBottomView = [[UIImageView alloc] init];
    self.xjBottomView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.xjLabel = [[UILabel alloc]init ];
    [self addSubview:self.xjBottomView];
    [self addSubview:self.xjLabel];
}

- (void)setXjContentStr:(NSString *)xjContentStr{
    _xjContentStr = xjContentStr;
    CGSize sizeM = [xjContentStr sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:self.xjFontSize ? self.xjFontSize : XJ_LABEL_SIZE_SMALL]}];
    
    self.xjLabel.frame = CGRectMake(20, -2, sizeM.width, self.frame.size.height );
    self.xjLabel.text = xjContentStr;
    self.xjLabel.textAlignment = NSTextAlignmentCenter;
    self.xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:self.xjFontSize ? self.xjFontSize : XJ_LABEL_SIZE_SMALL];
    //    self.xjLabel.textColor = [UIColor blackColor];
    //    self.xjBottomView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setXjBackImage:(UIImage *)xjBackImage {
    _xjBackImage = xjBackImage;
    self.xjBottomView.image = xjBackImage;
    self.xjBottomView.contentMode = UIViewContentModeScaleToFill;
}


- (void)setXjTextColor:(UIColor *)xjTextColor{
    self.xjLabel.textColor = xjTextColor;
    self.xjBottomView.layer.borderColor = xjTextColor.CGColor;
}



@end





