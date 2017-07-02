//
//  XJSearchByNickNameCompModel.h
//  FreeLa
//
//  Created by Leon on 16/5/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJSearchByNickNameCompModel : NSObject
@property (nonatomic , assign) NSInteger userId;
@property (nonatomic , strong) NSString* nickname;
@property (nonatomic , strong) NSString* avatar;
/**需要自己添加*/
@property (nonatomic , strong) NSString* xjUserType;
@end

/*
 "userId": 100007,
 "nickname": "魅族mx3",
 "password": "e10adc3949ba59abbe56e057f20f883e",
 "phone": "13231675260",
 "state": 0,
 "loginTimes": 1,
 "source": "1",
 "avatar": "/resources/static/user/cut_xpuser1464147240435.jpg",
 "birthday": "",
 "email": "",
 "address": "",
 "description": "",
 "tags": "",
 "lastLoginTime": "2016-05-25 11:33:17",
 "createTime": "2016-05-20 17:09:19",
 "modifyTime": "2016-05-26 18:26:44",
 "enable": 0,
 "token": "331ae3375ae0466b9fcc1557cc8442a2",
 "alias": "person_100007_2",
 "detailsId": 0,
 "isThirdName": "0",
 "isThirdAvatar": "0",
 "isThirdSex": "0",
 "isFriend": 0
 */