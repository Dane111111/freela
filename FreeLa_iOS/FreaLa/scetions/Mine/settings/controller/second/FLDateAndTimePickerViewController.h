//
//  FLDateAndTimePickerViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/15.
//  Copyright © 2015年 FreeLa. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "FLUserInfoModel.h"
#import "flNetTool.h"
#import "FLTool.h"


//typedef NS_ENUM(NSInteger,FLDatePickerViewStyle) {
//    FLDatePickerViewStyleNYR = 0,   //年月日
//    FLDatePickerViewStyleNYRSFM,    //年月日时分 AM/PM
//};


@protocol FLDateAndTimePickerViewControllerDelegate;

@interface FLDateAndTimePickerViewController : UIViewController
@property (nonatomic , strong )id<FLDateAndTimePickerViewControllerDelegate>delegate;
/**日期选择的style，1为年月日 0为具体时间*/
@property (nonatomic , assign)BOOL FLDatePickerViewStyle;
@property (nonatomic , strong)FLUserInfoModel* userInfoModel;
@end



@protocol FLDateAndTimePickerViewControllerDelegate <NSObject>
- (void)FLDateAndTimePickerViewController:(FLDateAndTimePickerViewController*)myPersonalvc didInputReturnMessage:(NSString*)msg;

- (void)cancelButtonClicked:(FLDateAndTimePickerViewController*)secondDetailViewController;
@end




