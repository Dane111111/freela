//
//  XJFindGiftViewController.h
//  FreeLa
//
//  Created by Leon on 2017/1/4.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJFindGiftViewController : UIViewController


@property(nonatomic,assign)BOOL isHtmlPop;

@property (nonatomic, strong) AMapCloudPOI *poi;



- (void)xjSetModel:(FLMyReceiveListModel*)model;

@end
