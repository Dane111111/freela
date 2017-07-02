//
//  XJCricleLabel.h
//  FreeLa
//
//  Created by Leon on 16/5/26.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XJCricleLabel : UIView
/**size*/
@property (nonatomic , assign) CGFloat xjFontSize;
/**content*/
@property (nonatomic , strong) NSString* xjContentStr;

/**color*/
@property (nonatomic , strong) UIColor* xjTextColor;

/**background*/
@property (nonatomic , strong) UIColor* xjBackgroundColor;
/**background*/
@property (nonatomic , strong) UIColor* xjBorderColor;

 

@end



