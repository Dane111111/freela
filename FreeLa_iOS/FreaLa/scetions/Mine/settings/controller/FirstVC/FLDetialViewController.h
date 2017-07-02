//
//  FLDetialViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/13.
//  Copyright © 2015年 FreeLa. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "FLNetTool.h"
#import "FLAppDelegate.h"
#import "FLTool.h"

//@class FLDetialViewController;
@protocol  FLDetialViewControllerDelegate;




@interface FLDetialViewController : UIViewController
@property (nonatomic , retain)id <FLDetialViewControllerDelegate>delegate;
@end



@protocol FLDetialViewControllerDelegate <NSObject>

- (void)FLDetialViewController:(FLDetialViewController*)myPersonalvc didInputReturnMessage:(NSString*)msg;
- (void)cancelButtonClicked:(FLDetialViewController*)secondDetailViewController;
@end





