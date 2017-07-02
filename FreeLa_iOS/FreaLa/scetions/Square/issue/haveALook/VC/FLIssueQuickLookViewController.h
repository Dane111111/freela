//
//  FLIssueQuickLookViewController.h
//  FreeLa
//
//  Created by Leon on 15/12/24.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLIssueInfoModel.h"
#import "FLTool.h"
@interface FLIssueQuickLookViewController : UIViewController
/**传进来的模型*/
@property (nonatomic , strong)FLIssueInfoModel* flissueInfoModel;
@property (weak, nonatomic) IBOutlet UIImageView *flthumbnailImage;
@property (weak, nonatomic) IBOutlet UIView *fltitleView;
@property (weak, nonatomic) IBOutlet UITextField *flchangeTitleText;
@property (weak, nonatomic) IBOutlet UIView *fltagView;
@property (weak, nonatomic) IBOutlet UITextField *fltagText;
@property (weak, nonatomic) IBOutlet UIButton *flSubMitBtn;
@property (weak, nonatomic) IBOutlet UIView *flTagBaseViewNew;

 


@end
