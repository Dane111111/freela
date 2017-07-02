//
//  XJBusTopViewNumberView.m
//  FreeLa
//
//  Created by Leon on 16/5/25.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJBusTopViewNumberView.h"

#define xj_per_view_w       (xjBaseViewFrame.size.width / _xjItemsArr.count)
#define xj_per_view_h       xjBaseViewFrame.size.height
#define xj_number_label_tag  10089
@interface XJBusTopViewNumberView ()
@property (nonatomic , strong) NSMutableArray* xjNumbersLabelArr;

@end
static CGRect xjBaseViewFrame;
@implementation XJBusTopViewNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        xjBaseViewFrame = frame;
    }
    return self;
}
- (void)setXjItemsArr:(NSArray *)xjItemsArr {
    _xjItemsArr = xjItemsArr;
    [self allocPageInNumberViewWithArr:xjItemsArr];
}
- (void)setXjIssueStr:(NSString *)xjIssueStr{
    _xjIssueStr = xjIssueStr;
    UILabel* xjLabelIssue = self.xjNumbersLabelArr[0];
    xjLabelIssue.text = xjIssueStr;
}
- (void)setXjFriendStr:(NSString *)xjFriendStr {
    _xjFriendStr = xjFriendStr;
    UILabel* xjLabel = self.xjNumbersLabelArr[1];
    xjLabel.text = xjFriendStr;
    
}
- (void)setXjHotStr:(NSString *)xjHotStr{
    _xjHotStr = xjHotStr;
    UILabel* xjLabelHot = self.xjNumbersLabelArr[2];
    xjLabelHot.text =  xjHotStr;
}

- (NSMutableArray *)xjNumbersLabelArr {
    if (!_xjNumbersLabelArr) {
        _xjNumbersLabelArr = [NSMutableArray array];
    }
    return _xjNumbersLabelArr;
}

- (void)allocPageInNumberViewWithArr:(NSArray*)xjNamesArr{
    for (NSInteger i = 0; i < _xjItemsArr.count; i++) {
        UIView* xjBaseView = [[UIView alloc] initWithFrame:CGRectMake(0 + i * xj_per_view_w, 0, xj_per_view_w, xj_per_view_h)];
        xjBaseView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addSubview:xjBaseView];
        UILabel* xjLabelNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, xj_per_view_w, xj_per_view_h / 2)];
        UILabel* xjLabelStr    = [[UILabel alloc] initWithFrame:CGRectMake(0, xj_per_view_h / 2, xj_per_view_w, xj_per_view_h / 2)];
        xjLabelNumber.textColor = [UIColor whiteColor];
        xjLabelNumber.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        xjLabelNumber.tag = xj_number_label_tag + i;
        xjLabelNumber.textAlignment = NSTextAlignmentCenter;
        xjLabelStr.textColor = [UIColor whiteColor];
        xjLabelStr.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        xjLabelStr.text = xjNamesArr[i];
        xjLabelStr.textAlignment = NSTextAlignmentCenter;
        [xjBaseView addSubview:xjLabelStr];
        [xjBaseView addSubview:xjLabelNumber];
        [self.xjNumbersLabelArr addObject:xjLabelNumber];
        //竖线
        if (i!=0) {
            UIView* xjVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 1, 20)];
            [xjBaseView addSubview:xjVerticalLine];
            xjVerticalLine.backgroundColor = [UIColor whiteColor];
        }
    }
}


@end






