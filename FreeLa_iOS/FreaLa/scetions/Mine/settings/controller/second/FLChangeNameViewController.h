//
//  FLChangeNameViewController.h
//  FreeLa
//
//  Created by Leon on 15/11/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNetTool.h"
#import "FLAppDelegate.h"
#import "FLTool.h"
#import "FLConst.h"

@protocol FLChangeNameViewControllerDelegate ;




@interface FLChangeNameViewController : UIViewController
@property (nonatomic  , retain)id<FLChangeNameViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *flnickNameAndContactName;
@end

@protocol FLChangeNameViewControllerDelegate <NSObject>

- (void)FLChangeNameViewController:(FLChangeNameViewController*)myPersonalvc didInputReturnMessage:(NSString*)msg;
- (void)cancelButtonClicked:(FLChangeNameViewController*)secondDetailViewController;

- (void)FLChangeContectNameViewController:(FLChangeNameViewController *)myPersonalvc didInputReturnMessage:(NSString *)msg;


@end



