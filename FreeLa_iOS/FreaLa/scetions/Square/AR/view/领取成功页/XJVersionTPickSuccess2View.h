//
//  XJVersionTPickSuccess2View.h
//  FreeLa
//
//  Created by MBP on 17/7/26.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPlayer.h"
#import "XJVersionTPickSuccessView.h"
@interface XJVersionTPickSuccess2View : UIView
//@property (nonatomic , strong) NSString* xjTopicIdStr;


@property(nonatomic,strong)UILabel*topicLabel;
@property(nonatomic,strong)UIImageView*topicImageV;
/**播放MP4*/
@property (nonatomic , strong) WMPlayer* topicPlayView;
/**发布者头像*/
@property(nonatomic,strong)UIImageView*headerImageV;
/**发布者昵称*/
@property (nonatomic , strong) UILabel* nickNameL;
/**发布时间*/
@property (nonatomic,strong)UILabel*timeLabel;
///**点赞数*/
//@property(nonatomic,strong)UILabel*zanLabel;

/**领取模型*/
@property (nonatomic, copy)FLMyReceiveListModel* flmyReceiveMineModel;
@property (nonatomic , strong) NSString* xj_imgUrlStr;
@property (nonatomic, weak)UIViewController *parentVC;
/**定义 block*/
@property (nonatomic , copy) xjPickSucessDoneAction block;
@property(nonatomic,strong)void(^popBlock)();
/**定义 点击完成事件*/
- (void)xj_findGiftSuccessDone:(xjPickSucessDoneAction)block;
@property(nonatomic,strong)UIToolbar*maskView;
-(void)popDown;
-(void)popUp;
@end
