//
//  XJMyTicketView.h
//  FreeLa
//
//  Created by Leon on 16/7/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  XJMyTicketViewDelegate <NSObject>
/**跳转到stafari*/
- (void)xjClickUseTicketBtnToStartStafari;
/**更新frame*/
- (void)xjRefreshViewFrameWithTickHeight:(CGFloat)xjTicketFloatH;
/**立即使用*/
- (void)xjClickUsrNoewInMyTicketView;

@end

@interface XJMyTicketView : UIView
@property (nonatomic , weak) id <XJMyTicketViewDelegate>delegate;

/**我的信息模型*/
@property (nonatomic , strong) FLMineInfoModel* xjMineInfoModel;
/**传进来的模型*/
@property (nonatomic , strong)FLMyReceiveListModel* xjMyReceiveInMineModel;
/**券码*/
@property (nonatomic , strong) XJTicketNumberModel* xjTicketNumberModel;

- (instancetype)initWithFrame:(CGRect)frame userId:(NSString*)xjUserId;
- (instancetype)initWithUserId:(NSString*)xjUserId;

/**刷新界面*/
- (void)xjRefreshMyTicketView;

@end
