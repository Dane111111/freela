//
//  FLBaseInfoCategoryCell.h
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLIssueHeader.h"
@class FLIssueBaseInfoViewController;


@interface FLBaseInfoCategoryCell : UITableViewCell
/**发布类型*/
@property (nonatomic , strong)NSString* flIssueType;

/**控制器*/
@end
