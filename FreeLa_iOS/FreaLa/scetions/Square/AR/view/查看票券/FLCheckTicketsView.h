//
//  FLCheckTicketsView.h
//  FreeLa
//
//  Created by MBP on 17/7/28.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLCheckTicketsView : UIView
/**传进来的模型*/
@property (nonatomic , strong)FLMyReceiveListModel* flMyReceiveInMineModel;

@property(nonatomic,strong)UIToolbar*maskView;
/**券码*/
@property (nonatomic , strong) XJTicketNumberModel* xjTicketNumberModel;
/**直接使用*/
@property(nonatomic,strong)void(^useVlock)();
/**关闭*/
@property(nonatomic,strong)void(^popDownlock)();
/**我的信息模型*/
@property (nonatomic , strong) FLMineInfoModel* flMineInfoModel;

-(instancetype)initWithSuperView:(UIView*)spView;
-(void)popUp;

@end
