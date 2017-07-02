//
//  FLHelpDetailImageModels.h
//  FreeLa
//
//  Created by Leon on 16/1/13.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLHelpDetailImageModels : NSObject
/*
 attachid = 438;
 attachtype = "";
 businessid = 90;
 businesstype = 3;
 createdtime = "2016-01-13 15:33:10";
 creator = 3;
 filename = dachshund;
 size = 0;
 updatetime = "2016-01-13 15:33:10";
 url = "/resources/static/topic/person/3/dachshund";
 userId = 3;
 userType = person;
 }
 );
 msg = "\U6210\U529f";
 success = 1;
 total = 6;

 */
/**图类型 1 为缩略图 2为详情图 3为图文*/
@property (nonatomic , assign) NSNumber* businesstype;

@property (nonatomic , strong) NSString* url;


/**filename*/
@property (nonatomic , strong) NSString* filename;


@end
