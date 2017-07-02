//
//  XJSearchSystemParmModel.h
//  FreeLa
//
//  Created by Leon on 16/5/5.
//  Copyright © 2016年 FreeLa. All rights reserved.
//  用于上传 给服务器tag id

#import <Foundation/Foundation.h>

@interface XJSearchSystemParmModel : NSObject
@property (nonatomic , assign) NSInteger xjId;
@property (nonatomic , strong) NSString* tagName;
@end

/*
 authType = 1;
 id = 3;
 quantity = 0;
 tagName = "\U4e0a\U95e8\U670d\U52a1";
 userId = 0;
*/