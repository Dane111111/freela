//
//  FLBusinessApplyEmailTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JKCountDownButton.h"
//创建一个代理
@protocol  FLBusinessApplyEmailTableViewCellDelegate<NSObject>

- (void)checkEmailAndSendMessage:(UITableViewCell*)cell;

@end

@interface FLBusinessApplyEmailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *flverifityView;
@property (weak, nonatomic) IBOutlet UIView *flemailView;
@property (strong, nonatomic) JKCountDownButton *flvirifityBtn;
@property (weak, nonatomic) IBOutlet UITextField *flverifityText;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UITextField *flemailText;
@property (weak, nonatomic) IBOutlet UIView *flpasswordView;
@property (weak, nonatomic) IBOutlet UITextField *flpasswordText;


//声明一个代码块
@property (nonatomic , strong)void(^btnClick)();
@property (nonatomic , assign)id<FLBusinessApplyEmailTableViewCellDelegate>delegate;
@end
