//
//  XJMyIssueTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/5/17.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyIssueInMineModel.h"
@interface XJMyIssueTableViewCell : UITableViewCell


//@property (nonatomic , strong) 
/**传进来的model*/
@property (nonatomic , strong)FLMyIssueInMineModel* flMyIssueInMineModel;

/**我参与的model*/
@property (nonatomic , strong) XJMyPartInInfoModel* xjMyPartInInfoModel;
/**
 *model version 2
 *model
 */
 

@end
