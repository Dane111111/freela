//
//  BGHideARAndLBSView.h
//  FreeLa
//
//  Created by MBP on 17/7/10.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJArHideGiftView.h"

@interface BGHideARAndLBSView : UIView
@property(nonatomic,strong)UIToolbar*maskView;
/**用户发布的model*/
@property (nonatomic , strong)FLIssueInfoModel* xjIssueModel;

/**位置信息*/
@property (nonatomic , strong)NSString* xjLocationStr;

@property (nonatomic, weak)UIViewController<FLChooseMapViewControllerDelegate> *parentVC;

// 声明block属性
@property (nonatomic, copy) xjHideGiftBlock block;

@property (nonatomic , copy) xjClickAddImg  xj_imgBlock;
@property (nonatomic , copy) xjClickChooseMap  xj_ChooseMapBlock;

/**缩略图*/
@property (nonatomic , strong) UIButton* xj_topicThBtn;
// 声明block方法
- (void)xjHideGiftBack:(xjHideGiftBlock)block;

/**添加图*/
- (void)xjClickToAddImg:(xjClickAddImg)block;
/**添加地址*/
- (void)xjClickToChooseMap:(xjClickChooseMap)block;

@end
