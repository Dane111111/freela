//
//  FLChooseMapViewController.h
//  FreeLa
//
//  Created by Leon on 15/12/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FLHeader.h"
#import "FLTool.h"

@protocol FLChooseMapViewControllerDelegate;



@interface FLChooseMapViewController : UIViewController

@property (nonatomic , strong)id<FLChooseMapViewControllerDelegate>delegate;


/**传进来的数据*/
@property (nonatomic , strong) NSDictionary* flAddressDic;
@end


@protocol FLChooseMapViewControllerDelegate <NSObject>

- (void)FLChooseMapViewController:(FLChooseMapViewController*)chooseMapvc didInputReturnLocation:(NSString*)chooseLocation title:(NSString*)title subtitle:(NSString*)subtitle;

- (void)FLChooseMapViewController:(FLChooseMapViewController*)chooseMapvc didInputReturnLocation:(NSString*)chooseLocationJ Location:(NSString*)chooseLocationW title:(NSString*)title subtitle:(NSString*)subtitle;

@end
