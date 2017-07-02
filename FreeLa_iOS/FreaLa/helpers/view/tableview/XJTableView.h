//
//  XJTableView.h
//  FreeLa
//
//  Created by Leon on 16/6/3.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLGrayLabel.h"

typedef enum{
    XJImageStateNoInterNet            = 0,
    XJImageStateNoResult,
    XJImageStateNoInfo,
}XJImageState;


@interface XJTableView : UITableView
/**imageView*/
@property (nonatomic , strong) UIImageView* xjImageView;
@property (nonatomic , strong) FLGrayLabel* xjLabel;

- (void)xjSetHidden:(BOOL)xjHidden state:(XJImageState)xjState;
@property (nonatomic , assign)CGRect xjImageViewFrame;

@end
