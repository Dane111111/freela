//
//  XJCreatGroupByChoiceView.h
//  FreeLa
//
//  Created by Leon on 16/6/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CommonLayer.h"
typedef NS_ENUM(NSInteger,XJCreatGroupType){
    XJCreatGroupTypeAll,
    XJCreatGroupTypePickList,
    XJCreatGroupTypePartWithOutPick,
};

@protocol XJCreatGroupByChoiceViewDelegate <NSObject>

- (void)xjTouchIndexRowWithIndex:(XJCreatGroupType)xjChooseType;

@end

@interface XJCreatGroupByChoiceView : CommonLayer

@property (nonatomic , weak) id<XJCreatGroupByChoiceViewDelegate>delegate;


@property (nonatomic , assign)XJCreatGroupType xjType;
@end
