//
//  FLTakeRulesTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import "FLHeader.h"
#import "FLTool.h"
@class FLIssueNewActivityTableViewController;
@class FLIssueBaseInfoViewController;
@interface FLTakeRulesTableViewCell : UITableViewCell
/**父图*/
@property (nonatomic , strong)UIView*  muSubView;
/**button数组*/
@property (nonatomic , strong)NSMutableArray* muBtnArray;
/**lablel数组*/
@property (nonatomic , strong)NSMutableArray* muLabelArray;
/**接受控制器的参数 数组*/
//@property (nonatomic , strong)NSDictionary* takeRulesDic;
@property (nonatomic , strong)NSString* takeRulesString;

/**selectedIndex*/
@property (nonatomic  ,assign)NSInteger selectedBtn;
/**每人每天多少次*/
@property (nonatomic , strong)UITextField* flTextFieldHow;
/**拿到controller*/
//@property (nonatomic  ,strong)FLIssueNewActivityTableViewController* issueVC;
@property (nonatomic , weak)FLIssueBaseInfoViewController* issueVC;


/**arraykey*/
@property (nonatomic , strong)NSArray* arrayCount;
/**arrayvlaue*/
@property (nonatomic , strong)NSArray* arrayCountValue;


/**回填的key*/
@property (nonatomic , strong) NSString* flBackStrKey;
/**回填，如果每人每天，个数*/
@property (nonatomic , strong) NSString* flBackPerNumberStr;


/**回填的模型，y用来确定是否是助力抢*/
@property (nonatomic , strong) NSString* flConditionsKey;



 
@end

















