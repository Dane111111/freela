//
//  FLChangePhoneNumberTableViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNetTool.h"
#import "FLUserInfoModel.h"
#import "FLTool.h"
#import "FLAppDelegate.h"
#import "FLConst.h"
#import "FLNetTool.h"
@protocol FLChangePhoneNumberTableViewControllerDelegate;


@interface FLChangePhoneNumberTableViewController : UITableViewController
@property (nonatomic , strong)id<FLChangePhoneNumberTableViewControllerDelegate>delegate;
/**绑定手机号？*/
@property (nonatomic , assign) NSInteger isBlindPhoneNumber;  //1为正常  2为绑定手机号
@end



@protocol FLChangePhoneNumberTableViewControllerDelegate <NSObject>

- (void)FLChangePhoneNumberTableViewController:(FLChangePhoneNumberTableViewController*)changePhone passValue:(NSString*)msg;


@end