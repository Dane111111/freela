//
//  FLChangeAddressViewController.h
//  FreeLa
//
//  Created by Leon on 15/11/20.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNetTool.h"

@protocol FLChangeAddressViewControllerDelegate ;


@interface FLChangeAddressViewController : UIViewController
@property (nonatomic , strong)id<FLChangeAddressViewControllerDelegate>delegate;


/**content*/
@property (nonatomic , strong) NSString* flStr;

@end


@protocol FLChangeAddressViewControllerDelegate <NSObject>

- (void)FLChangeAddressViewController:(FLChangeAddressViewController*)address myAddress:(NSString*)adress;

@end