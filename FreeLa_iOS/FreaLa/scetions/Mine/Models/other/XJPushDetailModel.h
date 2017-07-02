//
//  XJPushDetailModel.h
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJPushDetailModel : NSObject
@property (nonatomic , strong) NSString* createTime;
@property (nonatomic , strong) NSString* msgTypeString;
@property (nonatomic , strong) NSString* fromUser;
@property (nonatomic , strong) NSString* msgContent;
/**手动添加 cellheight*/
@property (nonatomic , assign) CGFloat xjCellHeight;
@end
/*
 count = 0;
 createTime = "2016-05-18 11:59:38";
 fromUser = "manager_1";
 fromUserId = 0;
 msgContent = "push ";
 msgId = 291;
 msgType = 1;
 msgTypeString = "\U7cfb\U7edf\U6d88\U606f";
 state = 0;
 targetUserId = 0;
 topicId = "-1";
 userName = "Freela\U5e73\U53f0";
*/