//
//  BGFillInformation.h
//  FreeLa
//
//  Created by MBP on 17/7/7.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJTopicDetailModel.h"

@interface BGFillInformation : UIView
@property(nonatomic,strong)UIToolbar*maskView;
@property(nonatomic,strong)void(^tiJiaoBlock)();
@property (nonatomic , strong) NSString* xj_topicId;

@property(nonatomic,strong)NSString*partInfostr;
@property(nonatomic,strong)NSString*hearderImageStr;
@property(nonatomic,strong)NSMutableDictionary*cellDic;

/**票券需要的领取model*/
@property (nonatomic , strong) FLMyReceiveListModel *flmyReceiveMineModel;
///**详情Model*/
//@property (nonatomic , strong) XJTopicDetailModel*     xjTopicDeatailModel; //详情

-(instancetype)initWithPartInfoStr:(NSString*)partInfoStr;
-(void)popUp;
-(void)popDown;


@end
