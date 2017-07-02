//
//  FLTopColumnView.h
//  FreeLa
//
//  Created by Leon on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLTopColumnView : UIView

/**头数组*/
@property (nonatomic , strong)NSArray* flTopColumBtnArray;


- (instancetype)initWithArray:(NSArray*)flArray;

@end
