//
//  XJSearchResultTableViewController.h
//  FreeLa
//
//  Created by Leon on 16/5/5.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJSearchResultModel.h"
@interface XJSearchResultTableViewController : UITableViewController
@property (nonatomic , strong) NSMutableArray* xjSearchResultArr;
@property (nonatomic , strong) NSString * xjTitle;
@end
