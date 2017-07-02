//
//  XJChooseFriendVersionToIssueVC.h
//  FreeLa
//
//  Created by Leon on 16/6/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJChooseFriendVersionToIssueVC;

@protocol XJChooseFriendVersionToIssueVCDelegate <NSObject>

/**
 *  选择完成之后代理方法
 *
 *  @param viewController  列表视图
 *  @param selectedSources 选择的联系人信息，每个联系人提供姓名和手机号两个字段，以字典形式返回
 *  @return 是否隐藏页面
 */
- (BOOL)viewController:(XJChooseFriendVersionToIssueVC *)viewController didFinishSelectedSources:(NSArray *)selectedSources;

@end


@interface XJChooseFriendVersionToIssueVC : UIViewController

@property (copy) void (^didSelectRowAtIndexPathCompletion)(id object);


- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames;
@property (nonatomic , weak) id<XJChooseFriendVersionToIssueVCDelegate>delegate;


@property (nonatomic , strong) NSArray* xjSelectedArr;
@end





