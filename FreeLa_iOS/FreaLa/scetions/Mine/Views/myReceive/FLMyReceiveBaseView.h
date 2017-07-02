//
//  FLMyReceiveBaseView.h
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyReceiveListModel.h"

@interface FLMyReceiveBaseView : UIView
/**传进来的模型*/
@property (nonatomic , strong)FLMyReceiveListModel* flMyReceiveInMineModel;


/**背景图*/
@property (nonatomic , strong)UIImageView* flMyBackGroundImageView;
/**查看活动详情*/
@property (nonatomic , strong)UIButton * flCheckDetailBtn;
/**轮播数组*/
@property (nonatomic , strong) NSMutableArray* imagesURLStrings;
/**ScrollView*/
@property (nonatomic , strong)UIScrollView* flScrollView;

- (instancetype)initWithModel:(FLMyReceiveListModel*)flMyReceiveInMineModel;

@end
