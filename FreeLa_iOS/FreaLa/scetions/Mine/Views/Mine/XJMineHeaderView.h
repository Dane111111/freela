//
//  XJMineHeaderView.h
//  FreeLa
//
//  Created by Leon on 16/5/25.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJMineHeaderView : UIView
/**button数组*/
@property (nonatomic , strong) NSArray* xjTopBtnArr;


- (instancetype)initWithFrame:(CGRect)frame topArr:(NSArray*)xjTopArr;

@end
