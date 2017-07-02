//
//  FLAvtivityCustomTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLHeader.h"
#import <Masonry/Masonry.h>
 
@interface FLAvtivityCustomTableViewCell : UITableViewCell<UITextFieldDelegate>
/**图标*/
//@property (nonatomic , strong)UIImageView* flAvtivityLogoImageView;
/**描述内容*/
@property (nonatomic , strong)UILabel* flAvtivityDisCribeLabel;
/**输入描述内容*/
@property (nonatomic , strong)UILabel* flAvtivityDiscribeInfoLabel;



@end
