//
//  XJZhuLQShareViewController.h
//  FreeLa
//
//  Created by Leon on 16/5/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJZhuLQShareViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *xjImageView;
 
@property (weak, nonatomic) IBOutlet UITextView *xjTextView;
@property (weak, nonatomic) IBOutlet UILabel *xjInputTextLabel;
@property (strong, nonatomic)  NSString *xjTitleLabel;

/**topicID*/
@property (nonatomic , strong) NSString* xjTopicId;
/**dic */
@property (nonatomic , strong) NSDictionary* xjTopicDic;
@property (weak, nonatomic) IBOutlet UIView *xjBottomView;
@property (weak, nonatomic) IBOutlet UIView *xjDescribeView;
@property (weak, nonatomic) IBOutlet UIView *xjImageHelpBackGroundView; //给iamge约束用（）哎哎哎
@property (weak, nonatomic) IBOutlet UILabel *xjLabelPartIn;

@property (weak, nonatomic) IBOutlet UIImageView *xjShareBackGroundImageView;


@property (weak, nonatomic) IBOutlet UILabel *xjPlaceHolderLabel;
@property (nonatomic , strong) NSString*xjstr;
@end
