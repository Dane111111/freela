//
//  FLMyIssueJudgePlModel.h
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyIssueJudgePlModel : NSObject
/*
 avatar = "/resources/static/user/cut_xpuser1451955362141.jpg";
 businessId = 68;
 commentId = 105;
 commentType = 0;
 commentcode = 0;
 content = "\U53d1\U751f\U98de\U6d12\U53d1\U6211\U53d1\U6211";
 createTime = "2016-01-11 10:01:21";
 enable = 0;
 imgUrls = "";
 isFlush = 0;
 listImgURL =             (
 );
 nickname = "\U679c\U513f";
 parentId = 0;
 rank = 3;
 replies = 0;
 userId = 3;
 userType = person;
 
 */
/**头像*/
@property (nonatomic , strong) NSString* avatar;
/**昵称*/
@property (nonatomic , strong) NSString* nickname;
/**内容*/
@property (nonatomic , strong) NSString* content;
/**时间*/
@property (nonatomic , strong) NSString* createTime;
/**parentId*/
@property (nonatomic , strong) NSNumber* commentId;


@property (nonatomic , assign) NSInteger replies;


/**返回的时间
 * 刚刚
 * 1分钟前
 */
@property (nonatomic , strong) NSString* fltime;

@end








