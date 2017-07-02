//
//  FLTakeConditionTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLTakeConditionTableViewCell.h"
#import "FLIssueNewActivityTableViewController.h"
#import "FLIssueBaseInfoViewController.h"

//#define flLabelSize     

@interface FLTakeConditionTableViewCell ()
{
    BOOL _isFirstIn;
    BOOL _isReloading;
}
/**总高度*/
@property (nonatomic , assign)CGFloat totalViewHeight;


@end
//用来解决下滑丢失数据问题
static NSInteger selectedBtnIndex;
static NSString* leastLimitNumber; //最低助力数
static NSString* takeRules;        //规则

@implementation FLTakeConditionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
         self.selectedBtn= 0;
        selectedBtnIndex= 0;
        _isFirstIn = NO;
        _isReloading = NO;
        [self creatHelpViewWithSender:nil];
    }
    return self;
}
//nil
- (void)setTakeConditionsString:(NSString *)takeConditionsString
{
    _takeConditionsString = takeConditionsString;
 
}

- (void)setFlBackStrKey:(NSString *)flBackStrKey
{
    _flBackStrKey = flBackStrKey;
    [self setUpUIInConditions];
}
//nil
- (void)setArrayCount:(NSArray *)arrayCount
{
    _arrayCount = arrayCount;
    for (NSInteger i = 0; i < arrayCount.count; i ++)
    {
        if ([arrayCount[i] isEqualToString:_flBackStrKey]) {
            if (!_isFirstIn) {
                self.selectedBtn= i ;
                selectedBtnIndex= i;
                _isFirstIn = YES;
            }
        }
        if ([_flBackStrKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
            self.issueVC.isHelpTypeSelected =YES;
            if (!_isReloading) {
                NSInteger x = [arrayCount indexOfObject:_flBackStrKey];
                self.selectedBtn= x;
                selectedBtnIndex= x;
                [self reloadDataWithVC];
                _isReloading = YES;
            }
        }
        
    }
    [self setUpUIInConditions];
}
//nil
- (void)setArrayCountValue:(NSArray *)arrayCountValue
{
    _arrayCountValue = arrayCountValue;
 
}

- (void)setUpUIInConditions
{
    [self allocInConditions];
    [self creatButtonsAndLabels];

    [self addViewInConditions];
}

- (void)creatButtonsAndLabels
{
    self.muBtnArray = [NSMutableArray array];
    self.muLabelArray = @[].mutableCopy;
    
    for (UIView *subview in self.muSubView.subviews) {
        [subview removeFromSuperview];
    }
    
    
    for (NSInteger i = 0; i < _arrayCount.count; i++ )
    {
        //btn 数组
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0 + (i * 35), 20, 20);
//        [btn setImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
         [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
        
     
        btn.tag = i + 30;
//        self.selectedBtn = selectedBtnIndex;
        if (i == self.selectedBtn)
        {
            selectedBtnIndex = self.selectedBtn;
//            [btn setImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
        }
        else
        {
//            [btn setImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClickInConditions:) forControlEvents:UIControlEventTouchUpInside];
        [self.muSubView addSubview:btn];
        [self.muBtnArray addObject:btn];
        //label 数组
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(30, 0 + (i * 35), FLUISCREENBOUNDS.width - 30 * 2, 20);
        label.text = _arrayCountValue[i];
        label.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        
        [self.muSubView addSubview:label];
        [self.muLabelArray addObject:label];
        
    }
    if (self.issueVC.isHelpTypeSelected)
    {
        
        CGRect frame = self.muSubView.frame;
        frame.origin.x = 30;
        frame.origin.y = 5 + _arrayCount.count * 35;
        frame.size.width = FLUISCREENBOUNDS.width - 30 - 30;
        frame.size.height = 60;
        self.helpView.frame = frame;
        frame = self.helpView.frame;
        [self addSubview:self.helpView];
        frame.origin.x =    102;
        frame.origin.y = 0;
        frame.size.width = 160;
        frame.size.height = 25;
        self.fltextfieldLimitNumber.frame= frame; 
        self.helpView.hidden= NO;
    }
    else
    {
        self.helpView.hidden= YES;
    }
    
}

- (void)allocInConditions
{
    if (!self.muBtnArray.count) {
        return;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.totalViewHeight = (self.muBtnArray.count * 30) + 60;
    FL_Log(@"my button in conditions cell =%@",self.muBtnArray);
    if (self.muSubView) {
        [self.muSubView removeFromSuperview];
        self.muSubView = nil;
    }
    self.muSubView = [[UIView alloc] init];
    
    [self addSubview:self.muSubView ];
    
    
}

- (void)addViewInConditions
{
    [self.muSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(15);
    }];

}
//最低助理数
- (void)setFlBackHelpNumberStr:(NSString *)flBackHelpNumberStr
{
    _flBackHelpNumberStr = flBackHelpNumberStr;
    self.fltextfieldLimitNumber.text = _flBackHelpNumberStr;
}
//领取规则
- (void)setFlBackHelpRulesStr:(NSString *)flBackHelpRulesStr
{
    _flBackHelpRulesStr = flBackHelpRulesStr;
      
    
//    [self.flRulesBtn setTitle:_flBackHelpRulesStr forState:UIControlStateNormal];
    
}



- (void)btnClickInConditions:(UIButton*)sender
{
    FL_Log(@"sender.tag = %ld",(long)sender.tag);
    self.issueVC.flTakeConditionsChoiceStr =  _arrayCount[sender.tag - 30];
    
    for (NSInteger i = 0; i < _arrayCount.count; i++)
    {
        if ((sender.tag - 30) == i)
        {
            self.selectedBtn = i;
            selectedBtnIndex = i;
        }
        [self reloadDataWithVC];
    }
    
    if ([_arrayCount[self.selectedBtn] isEqualToString:FLFLXJSquareIssueHelpPick])
    {
//        [self creatHelpViewWithSender:sender];
        self.issueVC.isHelpTypeSelected =YES;
        
            [self reloadDataWithVC];
    }
    else
    {
        self.issueVC.isHelpTypeSelected =NO;
        [self.helpView removeFromSuperview];
        _flBackStrKey = @"rilegou";
            [self reloadDataWithVC];
    }
}

- (void)reloadDataWithVC
{
    if (_selectedBtn != -1) {
        self.issueVC.flissueInfoModel.flactivityPickConditionKey = _arrayCount[_selectedBtn];
    }
    FL_Log(@"this ismy choice condition key =%@",self.issueVC.flissueInfoModel.flactivityPickConditionKey);
     [self.issueVC.flBaseInfoTableView reloadData];
}

- (void)creatHelpViewWithSender:(UIButton*)sender
{
    
    FL_Log(@"助力抢出来吧");
  
    CGRect frame = self.muSubView.frame;
    frame.origin.x = 30;
    frame.origin.y = 5 + _arrayCount.count * 35;
    frame.size.width = FLUISCREENBOUNDS.width - 30 - 30;
    frame.size.height = 60;
    self.helpView = [[UIView alloc]initWithFrame:frame];
    [self.muSubView addSubview:self.helpView];
    [self addSubview:self.helpView];
    //最低助力数
    UILabel* labelLimitNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    labelLimitNumber.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    labelLimitNumber.text = @"最低助力数:";
    labelLimitNumber.textAlignment = NSTextAlignmentRight;
    [self.helpView addSubview:labelLimitNumber];
    //textfield
    frame = self.helpView.frame;
    frame.origin.x =    102;
    frame.origin.y = 0;
    frame.size.width = 160;
    frame.size.height = 25;
    self.fltextfieldLimitNumber = [[UITextField alloc] initWithFrame:frame];
    self.fltextfieldLimitNumber.keyboardType = UIKeyboardTypeNumberPad;
    [KeyboardToolBar registerKeyboardToolBar:self.fltextfieldLimitNumber];
    [self.helpView addSubview:self.fltextfieldLimitNumber];
    //textfield
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0,0,0, 1 });
    self.fltextfieldLimitNumber.borderStyle = UITextBorderStyleLine;//边框式样
//    [self.fltextfieldLimitNumber.layer setBorderColor:colorref];//边框颜色
    
    //规则
    UILabel* labelRules = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 100, 25)];
    labelRules.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    labelRules.text = @"规则:";
    labelRules.textAlignment = NSTextAlignmentRight;
    [self.helpView addSubview:labelRules];
    frame.origin.y = 35;
    frame.size.width = 185;
    UIView* littleView = [[UIView alloc] initWithFrame: frame];
    littleView.layer.borderWidth = 1.0f;
    [littleView.layer setBorderColor:colorref];
    [self.helpView addSubview:littleView];
    //button
    frame.size.width = 160;
    self.flRulesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flRulesBtn.frame = frame;
    [self.flRulesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.flRulesBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
//    [self.flRulesBtn addTarget:self action:@selector(clickToPickRules) forControlEvents:UIControlEventTouchUpInside];
    [self.helpView addSubview:self.flRulesBtn];
    //按钮
    
    
}

//- (void)clickToPickRules
//{
//     [self.fltextfieldLimitNumber resignFirstResponder];
//    NSArray* array = @[@"你来你拿",@"我来我拿",@"谁来谁拿",@"拿完为止",@"不让拿",@"OK"];
//    [_pickview remove];
//    _pickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
//    _pickview.delegate =self.issueVC;
//    [_pickview show];
//}
//




@end















