//
//  FLBlindWithThirdTableViewController.h
//  FreeLa
//
//  Created by Leon on 16/1/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLBlindWithThirdTableViewControllerDelegate ;



@interface FLBlindWithThirdTableViewController : UITableViewController
@property (nonatomic , strong)id<FLBlindWithThirdTableViewControllerDelegate>delegate;


@end



@protocol FLBlindWithThirdTableViewControllerDelegate <NSObject>
/**绑定手机号代理*/
- (void)FLBlindWithThirdTableViewController:(FLBlindWithThirdTableViewController*)flvc blindPhoneNumber:(NSString*)phoneNumber;

@end
