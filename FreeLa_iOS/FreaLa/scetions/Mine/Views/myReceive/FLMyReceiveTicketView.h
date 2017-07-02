//
//  FLMyReceiveTicketView.h
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyReceiveListModel.h"
#import "XJTicketNumberModel.h"
@interface FLMyReceiveTicketView : UIView
/**传进来的模型*/
@property (nonatomic , strong)FLMyReceiveListModel* flMyReceiveInMineModel;

/**baseView*/
@property (nonatomic , strong) UIImageView* flBaseImageView;
/**背景图*/
@property (nonatomic , strong)UIImageView* flMyBackGroundImageView;
/**查看活动详情*/
@property (nonatomic , strong)UIButton * flCheckDetailBtn;
/**轮播数组*/
@property (nonatomic , strong) NSMutableArray* imagesURLStrings;

/**我的信息模型*/
@property (nonatomic , strong) FLMineInfoModel* flMineInfoModel;

/**二维码信息*/
@property (nonatomic , strong) NSString* flEWMInfoStr;

/**使用按钮*/
@property (nonatomic , strong) UIButton* xjUseBtn;
/**券码*/
@property (nonatomic , strong) XJTicketNumberModel* xjTicketNumberModel;
@end
