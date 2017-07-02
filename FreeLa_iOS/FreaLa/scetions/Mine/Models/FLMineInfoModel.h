//
//  FLMineInfoModel.h
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMineInfoModel : NSObject
/*
 address = "\U5317\U4eac\U6d77\U6dc0\U590d\U5174\U8def";
 avatar = "/resources/static/user/cut_xpuser1451955362141.jpg";
 birthday = "1989-04-22";
 createTime = "2016-01-05 08:51:52";
 description = "\U4e0d\U6c42\U8d5e\U626c\U8912\U5956\Uff0c\U4f46\U6c42\U65e0\U6127\U4e8e\U5fc3\Uff01\U5fc3\U6001\U8981\U597d\U2026\U2026";
 detailsId = 0;
 email = "512375804@qq.com";
 enable = 0;
 introduce = "123\U56de\U590d\U4f60\U4eec123";
 lastLoginTime = "2016-01-15 07:30:52";
 loginTimes = 1;
 modifyTime = "2016-01-14 17:22:17";
 nickname = "\U679c\U513f";
 password = e10adc3949ba59abbe56e057f20f883e;
 phone = 13426292366;
 sex = 1;
 state = 0;
 tags = "r,foggy";
 token = B9F3A7344AC0DE65C0A4E2DE73E507F6;
 userId = 3;
 */

/**nickname*/
@property (nonatomic , strong) NSString* nickname;
/**avatar*/
@property (nonatomic , strong) NSString* avatar;
/**一句话描述*/
@property (nonatomic , strong) NSString* fldescription; //fldescription --> description







@end







