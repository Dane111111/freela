//
//  FLLogIn_RegisterViewController.h
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "FLNetTool.h"
#import "FLAppDelegate.h"
#import "FLUserTool.h"
#import "HexColors.h"
#import "FLConst.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "FLMyThirdLogInModel.h"
@interface FLLogIn_RegisterViewController : UIViewController

/**model*/
@property (nonatomic , strong) FLMyThirdLogInModel* flThirdLogInModel;


@end
