//
//  FLMyPersonalDateTableViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLMySettingsTableViewController.h"
//#import <AFNetworking/AFHTTPRequestOperation.h>
//#import "UIImageView+WebCache.h"    //使用SDWebImage 来管理头像
#import <SDWebImage/UIButton+WebCache.h>
#import <Reachability/Reachability.h>
#import "FLDiscribeTableViewCell.h"
#import "FLAboutBusAccountViewController.h"
#import "FLAddTagsTableViewCell.h"

#import "UINavigationBar+Awesome.h"
#import "FLConst.h"
#import "FLChangeAddressViewController.h"
#import "FLBusIndustryModel.h"

//picker
#import "ZHPickView.h"
#import "KTSelectDatePicker.h"
#import "FLPopBaseView.h"
#import "FLBlindWithThirdTableViewController.h"
#import "XJBaseTableViewController.h"

//extern NSString*  FLFLXJBusinessUserHeaderImageURLStr;
@protocol FLMyPersonalDateTableViewControllerDelegate;


 
@interface FLMyPersonalDateTableViewController : XJBaseTableViewController<ZHPickViewDelegate,FLPopBaseViewDelegate>
@property (nonatomic , strong)id<FLMyPersonalDateTableViewControllerDelegate>delegate;
/**没有选择照片，但自己有头像时*/
@property (nonatomic , strong)NSString* portraitImageUrlWithOutTapStr;
/**商家没有选择照片，但自己有头像时*/
@property (nonatomic , strong)NSString* portraitBUSImageUrlWithOutTapStr;

/**navi*/
@property (nonatomic , strong)UINavigationController* navigationControllerByDIY;

/**pickerView*/
@property (nonatomic , strong)ZHPickView* pickview;


/**popViewTag*/
@property (nonatomic , assign)NSInteger popViewTag;
@end

@protocol FLMyPersonalDateTableViewControllerDelegate <NSObject>

-(void)FLMyPersonalDateTableViewController:(FLMyPersonalDateTableViewController*)myVC passImage:(UIImage*)image;

@end
