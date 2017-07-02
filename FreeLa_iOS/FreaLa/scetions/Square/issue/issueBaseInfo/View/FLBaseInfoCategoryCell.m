//
//  FLBaseInfoCategoryCell.m
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBaseInfoCategoryCell.h"
@interface FLBaseInfoCategoryCell()
{
    NSInteger selectedBtn;
    NSMutableArray* btnArray;
    NSArray* array;
    NSArray* arrayKey;
}

@end

@implementation FLBaseInfoCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        selectedBtn = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 24, 44)];
        label.text =@"类别";
        label.font = [UIFont fontWithName:FL_FONT_NAME size:(XJ_LABEL_SIZE_NORMAL)];
        [self addSubview:label];
          array = @[];
        UIView* BtnView = [[UIView alloc] initWithFrame:CGRectMake(40 + 5, 0, FLUISCREENBOUNDS.width - 40, 44)];
        [self addSubview:BtnView];
        if (FLFLIsPersonalAccountType)
        {
            array = @[FLFLXJSquarePersonStr];
        }else
        {
            array =   @[FLFLXJSquareAllFreeStr,FLFLXJSquareCouponseStr];
            arrayKey= @[FLFLXJSquareAllFreeStrKey,FLFLXJSquareCouponseStrKey];
        }
        btnArray = [NSMutableArray array];
        for (NSInteger i = 0; i < array.count ;i++)
        {
            UILabel* label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:FL_FONT_NAME size:(XJ_LABEL_SIZE_NORMAL)];
            label.frame = CGRectMake(22 + i * 60,  0, 50, 44);
            label.text = array[i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0 + i * 60, 0, 20, 20);
            if (FLFLIsPersonalAccountType) {
//                 [btn setImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
            }
            else
            {
//                 [btn setImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
            }
            btn.tag = i;
            [btnArray addObject:btn];
            [btn addTarget:self action:@selector(ClickToChangeImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.centerY = label.centerY;
            [BtnView addSubview:label];
            [BtnView addSubview:btn];
        }
        
    }
    return self;

}

- (void)ClickToChangeImage:(UIButton* )sender
{
    if (FLFLIsPersonalAccountType)
    {
         
    }
    else
    {
        if (sender.tag == 0)
        {
            [btnArray[0] setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
            [btnArray[1] setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
            FL_Log(@"======in category cell%@, key = %@",array[0],arrayKey[0]);
            _flIssueType = arrayKey[0];
            
        }
        else
        {
            [btnArray[1] setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
            [btnArray[0] setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
             FL_Log(@"======in category cell%@ , key =  %@",array[1],arrayKey[1]);
             _flIssueType = arrayKey[1];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
