//
//  XJVersionCouponsCell.h
//  FreeLa
//
//  Created by Leon on 16/7/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJVersionTwoCouponsModel.h"

@interface XJVersionCouponsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *xjWhiteBaseView;
@property (nonatomic , strong) XJVersionTwoCouponsModel* xjCellModel;



@end
