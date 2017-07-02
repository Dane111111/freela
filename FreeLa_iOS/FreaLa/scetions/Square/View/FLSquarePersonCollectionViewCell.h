//
//  FLSquarePersonCollectionViewCell.h
//  FreeLa
//
//  Created by Leon on 15/12/18.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLSquarePersonalIssueModel.h"
#import "FLTool.h"
@interface FLSquarePersonCollectionViewCell : UICollectionViewCell

/**背景图*/
@property (nonatomic, strong) UIImageView *flimageViewBackGround;


/**个人发布的model*/
@property (nonatomic , strong)FLSquarePersonalIssueModel* flsquarePersonIssueModel;

@end
