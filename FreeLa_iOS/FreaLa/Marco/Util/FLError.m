//
//  FLError.m
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLError.h"

@implementation FLError

#pragma mark - HHError
+ (FLError *)error {
    FLError *_error = [[FLError alloc] init] ;
    return _error;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

//- (void)dealloc {
//    HHRELEASE(extra);
//    HHRELEASE(message);
//    HHRELEASE(method);
//    HHRELEASE(userInfo);
//    [super dealloc];
//}

#pragma mark - Get set dictionary
+ (FLError *)errorFromDictionary:(NSDictionary *)dictionary {
    FLError *_error = [FLError error];
    _error.code = [[dictionary objectForKey:@"code"] intValue];
    _error.extra = [dictionary objectForKey:@"extra"];
    _error.message = [dictionary objectForKey:@"message"];
    _error.method = [dictionary objectForKey:@"method"];
    _error.userInfo = [dictionary objectForKey:@"userInfo"]; // may be is nil;
    return _error;
}

- (NSDictionary *)getDictionaryFromError {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInt:self.code] forKey:@"code"];
    [dictionary setValue:self.extra forKey:@"extra"];
    [dictionary setValue:self.message forKey:@"message"];
    [dictionary setValue:self.method forKey:@"method"];
    [dictionary setValue:self.userInfo forKey:@"userInfo"];
    return dictionary;
}

#pragma mark - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"The error: { code = %ld, message = %@ }", code, message];
}



@end
