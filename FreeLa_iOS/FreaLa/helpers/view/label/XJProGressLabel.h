//
//  XJProGressLabel.h
//  FreeLa
//
//  Created by Leon on 16/6/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJProGressLabel : UIView


/**内容*/
@property (nonatomic , strong) NSString* xjContent;


-(instancetype)initWithFrame:(CGRect)frame ProgressColor:(UIColor*)xjColor BackColor:(UIColor*) xjBackColor;


@end
