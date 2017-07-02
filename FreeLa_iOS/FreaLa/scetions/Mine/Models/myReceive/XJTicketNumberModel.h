//
//  XJTicketNumberModel.h
//  FreeLa
//
//  Created by Leon on 16/5/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJTicketNumberModel : NSObject
@property (nonatomic , assign) NSInteger batchNumber;
@property (nonatomic , strong) NSString* cardnum;

@end
/*
 batchNumber = 1462847786343;
 cardnum = ADs734hj;
 couponid = 6;
 createTime = "2016-05-10 10:36:26";
 creator = 100004;
 state = 1;
 topicid = 1;
 userid = 100004;
 usertype = person;
*/