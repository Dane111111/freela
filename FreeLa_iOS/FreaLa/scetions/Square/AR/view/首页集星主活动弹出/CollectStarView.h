//
//  CollectStarView.h
//  FreeLa
//
//  Created by MBP on 17/6/30.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectStarView : UIView
@property(nonatomic,strong)UIToolbar*maskView;
@property(nonatomic,strong)void(^pushBlock)();

- (instancetype)initWithBeginTime:(NSString*)beginTime endTime:(NSString*)endTime;
-(void)popUp;
-(void)popDown;

@end
