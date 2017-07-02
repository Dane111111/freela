//
//  FLDiscribeMyselfViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNetTool.h"
#import "FLAppDelegate.h"
#import "UINavigationBar+Awesome.h"
#import "FLTool.h"
#import "FLHeader.h"
#import "FLUserInfoModel.h"
@protocol FLDiscribeMyselfViewControllerDelegate;

@interface FLDiscribeMyselfViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *discribeText;
/**content*/
@property (nonatomic , strong) NSString* flStr;


@property (nonatomic , strong)id<FLDiscribeMyselfViewControllerDelegate>delegate;

@end

@protocol  FLDiscribeMyselfViewControllerDelegate<NSObject>

/**获取个人描述
 * @parm : 我写的描述
 */
- (void)FLDiscribeMyselfViewController:(FLDiscribeMyselfViewController*)discribe myDiscription:(NSString*)msg;

@end









