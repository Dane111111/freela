//
//  FLSexChoiceTableViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/15.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNetTool.h"
#import "UINavigationBar+Awesome.h"

@protocol FLSexChoiceTableViewControllerDelegate;



@interface FLSexChoiceTableViewController : UITableViewController
@property (nonatomic , strong)id<FLSexChoiceTableViewControllerDelegate>delegate;
@end


@protocol FLSexChoiceTableViewControllerDelegate <NSObject>

-(void)FLSexChoiceTableViewController:(FLSexChoiceTableViewController*)sexChoice myChoice:(NSString*)msg;

@end


