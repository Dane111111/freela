
//
//  XJChooseFriendToIssueVC.h
//  FreeLa
//
//  Created by Leon on 16/6/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "EMChooseViewController.h"


@interface XJChooseFriendToIssueVC : EMChooseViewController
//已有选中的成员username，在该页面，这些成员不能被取消选择
- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames;
@end
