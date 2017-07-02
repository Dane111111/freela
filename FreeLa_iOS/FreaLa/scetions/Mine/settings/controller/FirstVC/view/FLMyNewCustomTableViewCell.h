//
//  FLMyNewCustomTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/1/29.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLMyNewCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fltitle;
@property (weak, nonatomic) IBOutlet UILabel *flDetailLabel;

/**titleArray*/
@property (nonatomic , strong) NSArray* flTitleArray;




@end
