//
//  FLBusinessApplyNameTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FLBusinessApplyInfoModel.h"
#import "FLHeader.h"
#import "FLAppDelegate.h"
@class FLApplyBusinessAccountViewController;
@interface FLBusinessApplyNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *flmyFullNameText;
@property (weak, nonatomic) IBOutlet UITextField *flmySimpleNameText;
@property (weak, nonatomic) IBOutlet UITextField *flmyLiceneNameText;
@property (weak, nonatomic) IBOutlet UITextField *flindustryText;

@property (weak, nonatomic) IBOutlet UIButton *xjCoverBtn;

@property (weak, nonatomic) IBOutlet UIView *fullnameView;
@property (weak, nonatomic) IBOutlet UIView *simplenameView;
@property (weak, nonatomic) IBOutlet UIView *licenenameView;
@property (weak, nonatomic) IBOutlet UIView *flindustryView;

@property (nonatomic , weak)FLApplyBusinessAccountViewController* applyVC;

@end
