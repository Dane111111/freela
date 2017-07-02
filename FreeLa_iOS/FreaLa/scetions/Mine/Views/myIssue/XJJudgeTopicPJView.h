//
//  XJJudgeTopicPJView.h
//  FreeLa
//
//  Created by Leon on 16/3/21.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XJRejudgePJBcakViewController.h"
@class XJRejudgePJBcakViewController;

@interface XJJudgeTopicPJView : UIView
@property (nonatomic , strong) UIButton * xjAddImageBtn;
@property (nonatomic , strong) FLMineInfoModel* xjUserModel;
@property (nonatomic , weak) XJRejudgePJBcakViewController* xjVC;

@property (nonatomic , assign) NSInteger xjChoiceBtnIndex;

@property (nonatomic , strong) NSMutableArray* xjImagesStrArray;
/**image数组*/
@property (nonatomic , strong) NSMutableArray* xjImagesImageArr;

@property (nonatomic , strong) UITextView* xjTextView;

@end
