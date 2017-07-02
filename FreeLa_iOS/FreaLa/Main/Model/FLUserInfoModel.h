//
//  FLUserInfoModel.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FLUserInfoModel : NSObject<NSCoding>
/**手机号*/
@property(nonatomic, copy) NSString *flloginNumber;
/**密码*/
@property(nonatomic, copy) NSString *flpassWord;
/**userid*/
@property(nonatomic, copy) NSString *fluserId;

/**昵称*/
@property(nonatomic, copy) NSString *flnickName;
/**头像地址*/
//@property(nonatomic, copy) NSString *flheadPortrait;
/**生日*/
@property(nonatomic, copy) NSString *flbirthday;
//性别
@property(nonatomic , strong) NSString* flsex;
/**个人标签*/
@property(nonatomic , strong) NSArray* fltagsArray;
/**一句话描述*/
@property(nonatomic , strong) NSString* fldescription;
/**头像地址*/
@property (nonatomic , strong) NSString* flavatar;
/**地址*/
@property (nonatomic , strong) NSString* fladdress;

/**账户来源*/
@property (nonatomic , assign) NSInteger flSource;
/**账户被禁情况*/  //1为被禁
@property (nonatomic , assign) NSInteger flStateInt;
/**tags str*/
@property (nonatomic, strong) NSString* flTagsStr;
+ (FLUserInfoModel*) share;

@end


















