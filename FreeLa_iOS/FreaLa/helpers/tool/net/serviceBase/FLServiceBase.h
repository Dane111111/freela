//
//  FLServiceBase.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLError.h"
@interface FLServiceBase : NSObject


typedef void (^FLResultSuccessBlock) (NSDictionary *data,int code);
typedef void (^FLResultFailBlock)(NSDictionary *data,FLError *error);


@end
