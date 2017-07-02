//
//  XJJudgeBackModel.h
//  FreeLa
//
//  Created by Leon on 16/3/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJJudgeBackModel : NSObject
@property (nonatomic , strong) NSString* content;
@property (nonatomic , strong) NSString* replyObj;
@property (nonatomic , strong) NSString* avatar;
@property (nonatomic , strong) NSString* createTime;

/**cell高度*/
@property (nonatomic , assign) CGFloat xjAddCellHeight;

@end
/*
 avatar = "/resources/static/user/mobile1457658496409.jpg";
 businessId = 22;
 commentId = 5;
 commentType = 2;
 commentcode = 3;
 content = "At Dsa";
 createTime = "2016-03-11 09:10:18";
 enable = 0;
 isFlush = 0;
 nickname = "Xiaojia ";
 parentId = 3;
 replies = 0;
 replyObj = "Xiaojia  \U56de\U590d\U4e86 Xiaojia ";
 userId = 5;
 userType = person;
 
*/