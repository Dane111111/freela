//
//  FLMyIssueReceiveModel.h
//  FreeLa
//
//  Created by Leon on 16/1/8.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyIssueReceiveModel : NSObject
/*
 avatar = "resources/images/img-kong.jpg";
 createTime = "2016-01-05 12:31:37";
 detailsId = 281;
 message = "{"姓名":"71","电话":"77"}";
 nickname = A0000017;
 phone = 13100000017;
 receiveTime = "2016-01-08 14:54:08";
 state = 0;
 userId = 36;
 
 */

/**昵称*/
@property (nonatomic , strong) NSString* nickname;
/**领取时间*/
@property (nonatomic , strong) NSString* receiveTime;
/**头像*/
@property (nonatomic , strong) NSString* avatar;
/**使用状态*/
@property (nonatomic , strong) NSNumber* state;
/**userid*/
@property (nonatomic , strong) NSString* userId;
/**是否选中*/
@property (nonatomic , assign) BOOL flIschecked;




@end
