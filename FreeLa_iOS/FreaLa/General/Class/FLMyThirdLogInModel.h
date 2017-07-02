//
//  FLMyThirdLogInModel.h
//  FreeLa
//
//  Created by Leon on 16/1/25.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyThirdLogInModel : NSObject

/*
 accessSecret = "";
 accessToken = 3ED47A43418D833E9FCC88E9EFB0C5EC;
 expirationDate = "2016-04-24 06:54:33 +0000";
 iconURL = "http://q.qlogo.cn/qqapp/1104722431/DFBA48E359EB8A4DB4A4568358664C93/100";
 platformName = qq;
 profileURL = "";
 userName = SMD;
 usid = DFBA48E359EB8A4DB4A4568358664C93;
 
 
 city = Baoding;
 country = CN;
 headimgurl = "http://wx.qlogo.cn/mmopen/ibhzWy4ibIEpBiaA8tNTczGibJwR1vgD7JQh3ia6uxf5mlJahPYeebh1kribVcydOg44Toufw0wSyNQqhib3kRH9CMLKEuiaKX7mQUyib/0";
 language = "zh_CN";
 nickname = "\U5f20\U6d0b";
 openid = "osp-Qw-PKNJty808MwoWAtsx3-h4";
 privilege =     (
 );
 province = Hebei;
 sex = 1;
 unionid = "oIQ6YuCMiK6DDaZ-YorqPKkNiDoE";
 
 
 */

/**uid*/
@property (nonatomic , strong) NSString* usid;
/**unionid*/
@property (nonatomic , strong) NSString* unionid;
/**头像*/
@property (nonatomic , strong) NSString* iconURL;

/**数据源*/
@property (nonatomic , strong) NSString* platformName;
/**userName*/
@property (nonatomic , strong) NSString* userName;
/*sex*/
@property (nonatomic , assign) NSInteger sex;


/**上传用的数据源*/
@property (nonatomic , strong) NSString* flSource;
@end
