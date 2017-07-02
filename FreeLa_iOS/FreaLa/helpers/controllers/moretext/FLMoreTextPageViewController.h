//
//  FLMoreTextPageViewController.h
//  FreeLa
//
//  Created by Leon on 16/2/16.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FLMoreTextPageViewControllerDelegate;


@interface FLMoreTextPageViewController : UIViewController
/**代理*/
@property (nonatomic , strong) id<FLMoreTextPageViewControllerDelegate>delegate;
/**content*/
@property (nonatomic , strong) NSString* XJStr;
/**限制字数*/
@property (nonatomic , assign) NSInteger XJMaxLimit;
/**title*/
@property (nonatomic , strong) NSString* XJtitle;
/**是否导航*/

/**来源一 ：更改使用说明*/
@property (nonatomic , assign) NSInteger XJComeTpye;

@end




@protocol FLMoreTextPageViewControllerDelegate <NSObject>
/**方法一 更改使用说明*/
- (void)FLMoreTextPageViewController:(FLMoreTextPageViewController*)flVC message:(NSString*)flmessage;

@end

