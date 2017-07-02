//
//  FLTakeRulesTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLTakeRulesTableViewCell.h"
#import "FLIssueNewActivityTableViewController.h"
#import "FLIssueBaseInfoViewController.h"
#import "KeyboardToolBar.h"

@interface FLTakeRulesTableViewCell ()<UITextFieldDelegate>
{
    BOOL _isFirstIn;
    BOOL _isClickBtn; //有没有点过btn
}
//label 选择卡
/**总高度*/
@property (nonatomic , assign)CGFloat totalViewHeight;

/**次*/
@property (nonatomic , strong)UILabel* flLabelFuck;

/**得到的字典*/
@property (nonatomic , strong)NSDictionary* flDictionary;
@end
static NSInteger selectedBtnIndex;
static BOOL     _flCanClick;
@implementation FLTakeRulesTableViewCell
- (void)awakeFromNib {
    // Initialization code
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectedBtn= 0;
        selectedBtnIndex= 0;
        _isFirstIn = NO;
        _isClickBtn = NO;
        _flCanClick = YES;
        self.flTextFieldHow = [[UITextField alloc] init];
        self.flTextFieldHow.delegate = self;
        self.flLabelFuck = [[UILabel alloc] init];
        [KeyboardToolBar registerKeyboardToolBar:self.flTextFieldHow];
     
    }
    return self;
}

- (void)setArrayCount:(NSArray *)arrayCount
{
    _arrayCount = arrayCount;
    for (NSInteger i = 0 ; i < _arrayCount.count; i ++ )
    {
        if ([_arrayCount[i] isEqualToString:_flBackStrKey])
        {
            if (!_isFirstIn) {
                self.selectedBtn= i ;
                selectedBtnIndex= i;
                _isFirstIn = YES;
            }
        }
    }
//    [self setUpUIInRules];
}


- (void)setArrayCountValue:(NSArray *)arrayCountValue
{
    _arrayCountValue = arrayCountValue;
   
    [self setUpUIInRules];
}
//回填的key
- (void)setFlBackStrKey:(NSString *)flBackStrKey
{
    _flBackStrKey = flBackStrKey;
    if (!_isClickBtn) {
        if ([_flBackStrKey isEqualToString:FLFLXJSquareIssuePerOneDay]) {
            self.flTextFieldHow.text = _flBackPerNumberStr;
            self.flTextFieldHow.userInteractionEnabled = YES;
        } else {
            self.flTextFieldHow.text = @"";
            self.flTextFieldHow.userInteractionEnabled = NO;
        }
    }
}

- (void)setFlBackPerNumberStr:(NSString *)flBackPerNumberStr{
    _flBackPerNumberStr = flBackPerNumberStr;
//    self.flTextFieldHow.text = _flBackPerNumberStr;
}

//用来判断是不是助力抢
- (void)setFlConditionsKey:(NSString *)flConditionsKey
{
    _flConditionsKey = flConditionsKey;
    if ([_flConditionsKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
        _flBackStrKey = @"ONCE";
        for (NSInteger i = 0 ; i < _arrayCount.count; i++) {
            if ([_arrayCount[i] isEqualToString:@"ONCE"]) {
                self.selectedBtn= i;
                selectedBtnIndex= i;
            }
        }
        self.flTextFieldHow.text = @"";
        _flCanClick = NO;
    } else {
        _flCanClick = YES;
//        self.flTextFieldHow.text = _isClickBtn ? @"": _flBackPerNumberStr;
    }
}

- (void)setTakeRulesString:(NSString *)takeRulesString
{
    _takeRulesString = takeRulesString;
    self.flDictionary = [FLTool returnDictionaryWithJSONString:_takeRulesString];

    FL_Log(@"my array = %@ dic= %@",_arrayCount,self.flDictionary);
    
    [self setUpUIInRules];
}

- (void)setUpUIInRules
{
    [self allocInRules];
    [self creatButtonsAndLabels];
    //点击事件
//    [self.flBtnRulesNone addTarget:self action:@selector(selectedNone) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addViewInRules];
    [self makeMyConstraints];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)allocInRules
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.muSubView) {
        [self.muSubView removeFromSuperview];
        self.muSubView = nil;
    }
    self.totalViewHeight = (self.muBtnArray.count * 30) + 60;
    self.muSubView = [[UIView alloc] init];//WithFrame:CGRectMake(15, 5, FLUISCREENBOUNDS.width - 30, self.totalViewHeight)];
    [self addSubview:self.muSubView ];
}

- (void)creatButtonsAndLabels
{
    self.muBtnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _arrayCount.count; i++ )
    {
        //btn 数组
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0 + (i * 35), 20, 20);
//        [btn setImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateSelected];
        
         [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
         [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClickInRules:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 50;
        [self.muSubView addSubview:btn];
        [self.muBtnArray addObject:btn];
        
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
             [btn setBackgroundImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateSelected];
        }
        
        //label 数组
        UILabel* label = [[UILabel alloc] init];
        label.text = _arrayCountValue[i];
        label.font = [UIFont fontWithName:FL_FONT_NAME size:18];
         CGSize tSize = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FL_FONT_NAME size:18]}];
//        FL_Log(@"ssssssssssin rules cell%f",tSize.width);
        label.frame = CGRectMake(30 ,   i * 35 ,tSize.width, 20);
        label.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        [self.muSubView addSubview:label];
        [self.muLabelArray addObject:label];
        //设置每人每天多少次
        if ([_arrayCount[i] isEqualToString:FLFLXJSquareIssuePerOneDay])
        {
         
            self.flTextFieldHow.frame = CGRectMake(tSize.width + 20, i * 35, 50, 20);
            self.flTextFieldHow.borderStyle = UITextBorderStyleLine;
            [self.muSubView addSubview:self.flTextFieldHow];
            self.flTextFieldHow.keyboardType = UIKeyboardTypeNumberPad;
            self.flLabelFuck.frame = CGRectMake(tSize.width + 20 + 51, i * 35, 20, 20);
            self.flLabelFuck.text = @"次";
            self.flLabelFuck.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
//            self.flTextFieldHow.text =  _flBackPerNumberStr; 
            [self.muSubView addSubview:self.flLabelFuck];
        } else {
//            self.flTextFieldHow.text = @"";
        }
    }
}

- (void)addViewInRules
{
}

- (void)makeMyConstraints
{
    
    [self.muSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        //        make.centerX.equalTo(self).with.offset(0);
        //        make.width.mas_equalTo(FLUISCREENBOUNDS.width - 30);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self).with.offset(15);
//        make.height.mas_equalTo(self.totalViewHeight);
        make.right.equalTo(self.mas_right).with.offset(15);
    }];

}

- (void)btnClickInRules:(UIButton*)sender
{
    FL_Log(@"sender.tag in take rules = %ld",(long)sender.tag);
    if (!_flCanClick) {
        [[FLAppDelegate share] showHUDWithTitile:@"助力抢规则只能选择每人一次" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        _isClickBtn = NO;
    } else {
        _flBackStrKey = nil;
        _isClickBtn = YES;
        self.issueVC.flTakeRulesChoiceStr =  _arrayCount[sender.tag - 50];
        for (NSInteger i = 0; i < _arrayCount.count; i++)
        {
            if ((sender.tag - 50) == i)
            {
                self.selectedBtn = i;
                selectedBtnIndex = i;
            }
        }
    }
    
    if ([_arrayCount[sender.tag - 50] isEqualToString:FLFLXJSquareIssuePerOneDay]) {
        self.flTextFieldHow.text = _flBackPerNumberStr;
        self.flTextFieldHow.userInteractionEnabled = YES;
    } else {
        self.flTextFieldHow.text = @"";
        self.flTextFieldHow.userInteractionEnabled = NO;
    }
     [self.issueVC.flBaseInfoTableView reloadData];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.flTextFieldHow) {
        if ([self.flTextFieldHow.text integerValue] > 99) {
//            [[FLAppDelegate share] showHUDWithTitile:@"不能超过99次" delay:1 offsetY:0];
            [FLTool showWith:@"不能超过99次"];
            self.flTextFieldHow.text = @"";
        }
    }
}


@end



















