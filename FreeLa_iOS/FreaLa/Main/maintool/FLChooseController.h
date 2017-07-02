//
//  FLChooseController.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FLTabViewController.h"
#import "FLNavigationController.h"
#import "FLAppDelegate.h"
@interface FLChooseController : NSObject

/**决定选择哪一个控制器*/
+ (UINavigationController*)chooseNaviController;


@end
