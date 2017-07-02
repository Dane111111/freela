//
//  XJMyReceiveTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/5/17.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJMyReceiveTableViewCell : UITableViewCell
/**我领取的model*/
@property (nonatomic , strong) FLMyReceiveListModel* flMyReceiveListModel;

/**我参与的model*/
@property (nonatomic , strong) XJMyPartInInfoModel* xjMyPartInInfoModel;

@end
