//
//  XJArHideGiftView.h
//  FreeLa
//
//  Created by Leon on 2016/12/28.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

 

#import <UIKit/UIKit.h>
#define XJTopicRangeTag         123456
#define XJTopicARorLBS          122456
#define XJTopicPartInfoTag      124456
#define XJScreenSmall           (FLUISCREENBOUNDS.width<400)
//#define XJFontSize              (XJScreenSmall?10:14)
#define XJFontSize              13

// 一会要传的值为NSString类型
typedef void (^xjHideGiftBlock)(NSString * xjtitle , NSString* xjNumber ,NSString* xj_xiansuo,NSString* xj_range,BOOL xj_ispartinfo,NSInteger LBSorAR);
typedef void (^xjClickAddImg) (void);
typedef void (^xjClickChooseMap) (void);

@interface XJArHideGiftView : UIView

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






