//
//  FLSquarePersonalIssueModel.h
//  FreeLa
//
//  Created by Leon on 15/12/18.
//  Copyright © 2015年 FreeLa. All rights reserved.
//  个人发布的模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLSquarePersonalIssueModel : NSObject

/**背景图地址str*/
@property (nonatomic, strong) NSString *flStrBackGroundImageUrl;
/**背景图的size*/
@property (nonatomic, assign) CGSize flSizeBackGroundImageSize;


/**分类*/
@property (nonatomic , strong) NSString* flcateGoryStr;
/**发布类别(助力抢等)*/
@property (nonatomic , strong) NSString* flIssueType;
/**标题*/
@property (nonatomic , strong) NSString* fltitle;
/**阅读数*/
@property (nonatomic  ,strong) NSString* flReadNumber;
/**可领总数*/
@property (nonatomic , strong) NSString* flPickToalNumber;
/**已领取数*/
@property (nonatomic , strong) NSString* flTakeNumber;
/**nicakName*/
@property (nonatomic , strong) NSString* flNickName;
/**剩余时间*/
@property (nonatomic , strong) NSString* flTimeLeftStr;
/**头像*/
@property (nonatomic , strong) NSString* flHeaderImageStr;

@end
