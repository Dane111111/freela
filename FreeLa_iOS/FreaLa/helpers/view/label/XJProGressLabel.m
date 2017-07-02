//
//  XJProGressLabel.m
//  FreeLa
//
//  Created by Leon on 16/6/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJProGressLabel.h"

@interface XJProGressLabel ()
@property (nonatomic , strong) UILabel* xjLabelFirst;
@property (nonatomic , strong) UILabel* xjLabelSecond;
@end

@implementation XJProGressLabel

-(instancetype)initWithFrame:(CGRect)frame ProgressColor:(UIColor*)xjColor BackColor:(UIColor*) xjBackColor {
    self = [super initWithFrame:frame];
    if (self) {
//        self.xjLabelFirst = [[UILabel alloc] init];
        self.xjLabelFirst.font = [UIFont fontWithName:FL_FONT_NUMBER_NAME size:XJ_LABEL_SIZE_SMALL];
        self.xjLabelFirst.textAlignment = NSTextAlignmentCenter;
        self.xjLabelFirst.textColor = xjColor;
        [self addSubview:self.xjLabelFirst];
        
//        self.xjLabelSecond = [[UILabel alloc] init];
        self.xjLabelSecond.font = [UIFont fontWithName:FL_FONT_NUMBER_NAME size:XJ_LABEL_SIZE_SMALL];
        self.xjLabelSecond.textAlignment = NSTextAlignmentCenter;
        self.xjLabelSecond.textColor = xjBackColor;
        [self addSubview:self.xjLabelSecond];
    }
    return self;
}

-(UILabel *)xjLabelFirst{
    if (!_xjLabelFirst) {
        _xjLabelFirst = [[UILabel alloc] init];
    }
    return _xjLabelFirst;
}
- (UILabel *)xjLabelSecond {
    if (!_xjLabelSecond) {
        _xjLabelSecond = [[UILabel alloc] init];
    }
    return _xjLabelSecond;
}

- (void)setXjContent:(NSString *)xjContent {
    _xjContent = xjContent;
    if ([xjContent rangeOfString:@"/"].location != NSNotFound) {
        NSInteger xjInt = [xjContent rangeOfString:@"/"].location;
        NSString* xjStrFirst    = [xjContent substringToIndex:xjInt];
        NSString* xjStrSecond   = [xjContent substringFromIndex:xjInt +1];
        CGSize   xjSizeFirst    = [XJFinalTool xjReturnStrSizeWithStr:xjStrFirst fontSize:XJ_LABEL_SIZE_SMALL];
        CGSize   xjSizeSecond   = [XJFinalTool xjReturnStrSizeWithStr:xjStrSecond fontSize:XJ_LABEL_SIZE_SMALL];
        self.xjLabelFirst.frame = CGRectMake(0, 0, xjSizeFirst.width, self.frame.size.height);
        self.xjLabelSecond.frame = CGRectMake(xjSizeFirst.width, 0, xjSizeSecond.width+4, self.frame.size.height);
        self.xjLabelFirst.text = [NSString stringWithFormat:@"%@",xjStrFirst];
        self.xjLabelSecond.text = [NSString stringWithFormat:@"/%@",xjStrSecond];
    }
}


@end
