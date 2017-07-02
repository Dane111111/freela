//
//  FLTakeConditionTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "FLHeader.h"
#import "FLTool.h"
#import "ZHPickView.h"
@class FLIssueNewActivityTableViewController;
@class FLIssueBaseInfoViewController;

@interface FLTakeConditionTableViewCell : UITableViewCell<ZHPickViewDelegate>
/**父图*/
@property (nonatomic , strong)UIView*  muSubView;
/**button数组*/
@property (nonatomic , strong)NSMutableArray* muBtnArray;
/**lablel数组*/
@property (nonatomic , strong)NSMutableArray* muLabelArray;
/**接受控制器的参数数组*/
//@property (nonatomic , strong)NSDictionary* takeConditionsDic;
@property (nonatomic , strong)NSString* takeConditionsString;
/**助力抢view*/
@property (nonatomic , strong)UIView * helpView;

/**pickerView*/
@property (nonatomic , strong)ZHPickView* pickview;
/**规则文本*/
@property (nonatomic , strong)NSString* flRulesString;
/**规则*/
@property (nonatomic , strong)UIButton* flRulesBtn;
/**拿到controller*/
//@property (nonatomic  ,weak)FLIssueNewActivityTableViewController* issueVC;
@property (nonatomic , weak)FLIssueBaseInfoViewController* issueVC;

/**selectedIndex*/
@property (nonatomic  ,assign)NSInteger selectedBtn;

/**arraykey*/
@property (nonatomic , strong)NSArray* arrayCount;
/**arrayvalue*/
@property (nonatomic , strong)NSArray* arrayCountValue;

/**最低助力数textfield*/
@property (nonatomic , strong)UITextField* fltextfieldLimitNumber;



/**回填的key*/
@property (nonatomic , strong) NSString* flBackStrKey;
/**回填，如果是助力抢，个数*/
@property (nonatomic , strong) NSString* flBackHelpNumberStr;
/**回填，如果是助力抢，规则*/
@property (nonatomic , strong) NSString* flBackHelpRulesStr;


@end







