//
//  XJMineCusTomTwoTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/3/9.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJMyCollectionInfoModel.h"
#import "XJMyWeaitPJModel.h"

@interface XJMineCusTomTwoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *xjimageView;
@property (weak, nonatomic) IBOutlet UILabel *xjNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *xjPJBtn;
@property (weak, nonatomic) IBOutlet UIView *xjBackGroundView;

/**model*/
@property (nonatomic , strong) XJMyWeaitPJModel* xjWeaitPJModel;




@end
