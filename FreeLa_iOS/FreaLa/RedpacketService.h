//
//  RedpacketService.h
//  MobileCooperativeOffice
//
//  Created by Nile on 2017/1/16.
//  Copyright © 2017年 pcitc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    RedpacketType_qiandai,
    RedpacketType_fudai,
    RedpacketType_totalnumber,
}RedpacketType;




@interface RedpacketService : NSObject

+ (void)startRedpacketRainWithView:(UIView *)view;

@end




