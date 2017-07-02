//
//  FLGrayBaseView.h
//  FreeLa
//
//  Created by Leon on 16/1/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLGrayBaseViewDelegate.h"
#import "FLMyIssueReceiveModel.h"

 
@interface FLGrayBaseView : UIView
/**代理*/
@property (nonatomic , strong) id<FLGrayBaseViewDelegate>delegate;

/**topicId*/
@property (nonatomic , strong) NSString* flTopicId;
/**二维码图*/
@property (nonatomic , strong) UIImageView* flErWeiMaImageView;
/**创建一个二维码浮层*/
- (instancetype)initWithInfo:(NSString*)infoStr delegate:(id)delegate;

/***********************************************************dsds*************************************************/
/**创建一个参与列表展示浮层*/
- (instancetype)initWithFLMyIssueReceiveModeldelegate:(id)delegate;
/**model*/
@property (nonatomic , strong) FLMyIssueReceiveModel* flmodel;
/**字典*/
@property (nonatomic , strong) NSDictionary* flDataDic;


@end


 






