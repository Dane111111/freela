//
//  XJPushMessagesBtn.m
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJPushMessagesBtn.h"
#define xj_badge_w 0
#define xj_btn_w   frame.size.width - xj_badge_w

@interface XJPushMessagesBtn ()
@property (nonatomic , strong) UILabel* xjBadgeLabel;
@end

@implementation XJPushMessagesBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.xjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.xjBtn.frame = CGRectMake(0, 0,frame.size.width - xj_badge_w, frame.size.width - xj_badge_w);
        [self.xjBtn setImage:[UIImage imageNamed:@"icon_notification_bell_gray"] forState:UIControlStateNormal];
        [self addSubview:self.xjBtn];
        //角标
        self.xjBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xj_btn_w - 15, 5, 14, 14)];
        self.xjBadgeLabel.textColor = [UIColor whiteColor];
        self.xjBadgeLabel.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
        self.xjBadgeLabel.layer.cornerRadius = self.xjBadgeLabel.frame.size.width / 2;
        self.xjBadgeLabel.layer.masksToBounds = YES;
        self.xjBadgeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
        self.xjBadgeLabel.textAlignment = NSTextAlignmentCenter;
        self.xjBadgeLabel.hidden = YES;
        [self addSubview:self.xjBadgeLabel];
    }
    return self;
}

- (void)setXjBadges:(NSInteger)xjBadges {
    _xjBadges = xjBadges;
    [self xjSetBadgesWithBadge:xjBadges];
}

- (void)xjSetBadgesWithBadge :(NSInteger)xjInt{
    if (xjInt == 0) {
        self.xjBadgeLabel.hidden = YES;
    } else {
         self.xjBadgeLabel.hidden = NO;
        self.xjBadgeLabel.text = [NSString stringWithFormat:@"%ld",xjInt];
    }
}
- (void)setXjImage:(UIImage *)xjImage {
    _xjImage = xjImage;
    if (xjImage) {
        [self.xjBtn setImage:[UIImage imageNamed:@"icon_notification_bell_white"] forState:UIControlStateNormal];
    } else {
        [self.xjBtn setImage:[UIImage imageNamed:@"icon_notification_bell_gray"] forState:UIControlStateNormal];
    }
}

- (void)changeImageWithBool:(BOOL)xjIsWhite {
    [self.xjBtn setImage:xjIsWhite ? [UIImage imageNamed:@"icon_notification_bell_white"] :[UIImage imageNamed:@"icon_notification_bell_gray"] forState:UIControlStateNormal];
}



@end






