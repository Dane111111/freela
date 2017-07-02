//
//  XJVersionTPickSuccessView.h
//  FreeLa
//
//  Created by Leon on 2017/1/19.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPlayer.h"

/**定义 点击完成事件block*/
typedef void(^xjPickSucessDoneAction)(void);
typedef void(^xjClickCloseWindow)(void);

@interface XJVersionTPickSuccessView : UIView

/**头像*/
@property (nonatomic , strong) UIImageView* xj_imageView;

@property (nonatomic , strong) NSString* xj_imgUrlStr;
/**昵称*/
@property (nonatomic , strong) UILabel* xj_NickNameL;

/**主题*/
@property (nonatomic , strong) UILabel* xj_TopicThemeL;
/**缩略图*/
@property (nonatomic , strong) UIImageView* xj_TopicImgView;
/**播放MP4*/
@property (nonatomic , strong) WMPlayer* xjPlayView;


@property (nonatomic, weak)UIViewController *parentVC;

/**定义 block*/
@property (nonatomic , copy) xjPickSucessDoneAction block;
/**关闭界面*/
@property (nonatomic , copy) xjClickCloseWindow xjCloseBlock;

/**定义 点击完成事件*/
- (void)xj_findGiftSuccessDone:(xjPickSucessDoneAction)block;
/**关闭界面事件*/
- (void)xjClickToCloseWindow:(xjClickCloseWindow)block;
@end
