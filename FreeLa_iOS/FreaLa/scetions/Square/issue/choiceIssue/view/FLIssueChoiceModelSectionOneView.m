//
//  FLIssueChoiceModelSectionOneView.m
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLIssueChoiceModelSectionOneView.h"
@interface FLIssueChoiceModelSectionOneView()
@property (nonatomic , strong)UILabel* flLabelUp;
@property (nonatomic , strong)UILabel* flLabelDown;

@end

@implementation FLIssueChoiceModelSectionOneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.flLabelUp   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        self.flLabelDown = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 150, 20)];
        self.flLabelUp.font   = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        self.flLabelDown.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
        
        self.flLabelDown.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
        self.flLabelUp.text   = @"请选择模板";
        self.flLabelDown.text = @"标准模板";
        [self addSubview:self.flLabelDown];
        [self addSubview:self.flLabelUp];
        
    }
    return self;
}
- (void)setDownLabel:(NSString*)text
{
    [self.flLabelDown removeFromSuperview];
    self.flLabelUp.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flLabelUp.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.flLabelUp.text =@"自定义模板";
}
@end
