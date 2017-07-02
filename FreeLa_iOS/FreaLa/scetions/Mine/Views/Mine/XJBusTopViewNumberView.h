//
//  XJBusTopViewNumberView.h
//  FreeLa
//
//  Created by Leon on 16/5/25.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJBusTopViewNumberView : UIView
@property (nonatomic , strong) NSArray* xjItemsArr;
/**设置发布数*/
@property (nonatomic , strong) NSString* xjIssueStr;
/**设置粉丝数*/
@property (nonatomic , strong) NSString* xjFriendStr;
/**设置热度*/
@property (nonatomic , strong) NSString* xjHotStr;
@end
