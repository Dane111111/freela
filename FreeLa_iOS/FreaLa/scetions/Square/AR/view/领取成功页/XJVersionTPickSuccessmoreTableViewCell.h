//
//  XJVersionTPickSuccessmoreTableViewCell.h
//  FreeLa
//
//  Created by MBP on 17/7/28.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XJVersionTPickSuccessmoreTableViewCellAction)(void);

@interface XJVersionTPickSuccessmoreTableViewCell : UITableViewCell
@property(nonatomic,strong)XJVersionTPickSuccessmoreTableViewCellAction block;
@end
