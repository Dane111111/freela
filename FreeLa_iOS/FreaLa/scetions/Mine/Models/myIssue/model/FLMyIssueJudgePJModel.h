//
//  FLMyIssueJudgePJModel.h
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyIssueJudgePJModel : NSObject
/*
 data =     (
 {
 avatar = "/resources/static/user/cut_xpuser1452062552152.jpg";
 businessId = 75;
 commentId = 122;
 commentType = 1;
 commentcode = 0;
 content = "\U8bf7\U963f\U8fbe\U6492";
 createTime = "2016-01-11 15:42:11";
 enable = 0;
 imgUrls = "comment_1452498121000.jpg,comment_1452498123344.jpg,comment_1452498125531.jpg,comment_1452498127750.jpg,comment_1452498130203.jpg";
 isFlush = 0;
 listImgURL =             (
 "/resources/static/comment/122/comment_1452498121000.jpg",
 "/resources/static/comment/122/comment_1452498123344.jpg",
 "/resources/static/comment/122/comment_1452498125531.jpg",
 "/resources/static/comment/122/comment_1452498127750.jpg",
 "/resources/static/comment/122/comment_1452498130203.jpg"
 );
 nickname = A0000001;
 parentId = 0;
 rank = 5;
 replies = 0;
 userId = 13;
 userType = person;
 }
 );
 msg = "\U6570\U636e\U5df2\U4f20\U8f93\U6210\U529f";
 success = 1;
 total = 1;
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
@property (nonatomic , strong) NSNumber* parentId;

/**images*/
@property (nonatomic , strong) NSArray* listImgURL;
/**rank*/
@property (nonatomic , strong) NSNumber* rank;




/**返回的时间
 * 刚刚
 * 1分钟前
 */
@property (nonatomic , strong) NSString* fltime;

/**计算cell高度*/
@property (nonatomic , assign) CGFloat flCellH;



@end
















