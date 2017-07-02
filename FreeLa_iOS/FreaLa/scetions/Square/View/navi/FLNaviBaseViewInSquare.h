//
//  FLNaviBaseViewInSquare.h
//  FreeLa
//
//  Created by Leon on 15/12/15.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLHeader.h"
#import <Masonry/Masonry.h>

@interface FLNaviBaseViewInSquare : UIView
/**地址选择*/
@property (nonatomic , strong)UIButton* flAddressBtn;
/**搜索栏*/
@property (nonatomic , strong)UISearchBar* flSearchBar;
/**伪装搜索栏*/

/**发布按钮*/
@property (nonatomic , strong)UIButton* flIssueBtn;
/**扫码按钮*/
@property (nonatomic , strong) UIButton* flsaoBtn;
/**背景渐变*/
- (void)changedViewColorWithAlpha:(float)alpha;
/**隐藏*/
- (void)setViewHiddenWithBool:(BOOL)isUp;


@end
