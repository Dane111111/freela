//
//  CYItemCell.h
//  FreeLa
//
//  Created by cy on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLSquarePersonalIssueModel.h" 
#import "ItemModel.h"
#import "FLPerProgressView.h"
#import "XJVersionTwoPersonalModel.h"

@interface CYItemCell : UICollectionViewCell

/**model*/
@property (nonatomic , strong)FLSquarePersonalIssueModel* flsquarePersonalModel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic,strong)ItemModel *itemModel; //


/**model
 *version 2
 */
@property (nonatomic , strong) XJVersionTwoPersonalModel* xjPersonalModel;

+ (CGFloat)xj_bottom_h:(XJVersionTwoPersonalModel*)xjmode ;

@end
