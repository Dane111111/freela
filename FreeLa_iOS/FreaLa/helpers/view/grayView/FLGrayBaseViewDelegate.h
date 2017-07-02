//
//  FLGrayBaseViewDelegate.h
//  FreeLa
//
//  Created by Leon on 16/1/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLGrayBaseViewDelegate <NSObject>


@optional
/**保存到本地*/
- (void)flGrayViewSaveErWeiMaInLocationWithImage:(UIImage*)iamgeUse;
/**转发*/
- (void)flGrayViewRelayTopicAvtivityToFriendsWithImage:(UIImage*)imageUse;
/**返回*/
- (void)flGrayViewGoBack;

@end
