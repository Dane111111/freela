//
//  FLPopBaseViewDelegate.h
//  FreeLa
//
//  Created by Leon on 15/12/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol FLPopBaseViewDelegate <NSObject>


@optional
//取消按钮触发用户操作
- (void)canaleBtnClick;
/**确认按钮触发*/
- (void)entrueBtnClickWithStr:(NSString*)result;

 

@end
