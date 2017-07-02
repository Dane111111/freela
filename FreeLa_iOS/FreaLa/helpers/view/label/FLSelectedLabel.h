//
//  FLSelectedLabel.h
//  FreeLa
//
//  Created by Leon on 16/1/28.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLSelectedLabel : UILabel
/**是否选中*/
@property (nonatomic , assign) BOOL flselected;
/**是否可以被删除*/
@property (nonatomic , assign) BOOL xjIsCanBeDeleted;
- (instancetype)initWithFrame:(CGRect)frame selected:(BOOL)isSelected;

@end
