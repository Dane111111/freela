//
//  XJGiftPickSuccessView.h
//  FreeLa
//
//  Created by Leon on 2017/1/8.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
/**定义 点击完成事件block*/
typedef void(^xjPickSucessDoneAction)(void);

@interface XJGiftPickSuccessView : UIView
/**头像*/
@property (nonatomic , strong) UIImageView* xj_imageView;
/**昵称*/
@property (nonatomic , strong) UILabel* xj_NickNameL;
/**主题*/
@property (nonatomic , strong) UILabel* xj_TopicThemeL;
/**缩略图*/
@property (nonatomic , strong) UIImageView* xj_TopicImgView;


@property (nonatomic, weak)UIViewController *parentVC;

/**定义 block*/
@property (nonatomic , copy) xjPickSucessDoneAction block;


/**定义 点击完成事件*/
- (void)xj_findGiftSuccessDone:(xjPickSucessDoneAction)block;
@end
