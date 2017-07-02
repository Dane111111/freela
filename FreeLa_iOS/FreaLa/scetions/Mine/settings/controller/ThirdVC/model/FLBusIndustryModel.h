//
//  FLBusIndustryModel.h
//  FreeLa
//
//  Created by Leon on 16/1/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLBusIndustryModel : NSObject

/*
 createTime = "2015-12-30 02:29:49";
 deleteBy = "";
 deleteTime = "2015-11-28 04:23:59";
 dicName = hlw;
 dicValue = "\U4e92\U8054\U7f51";
 enable = 0;
 id = 2;
 isfixed = 0;
 modifyTime = "2015-11-28 04:23:59";
 parentId = 1;
 */

/**id*/
@property (nonatomic , assign) NSInteger flid;

/**value*/
@property (nonatomic , strong) NSString* dicValue;

/**dicName*/
@property (nonatomic , strong) NSString* dicName;


@end
