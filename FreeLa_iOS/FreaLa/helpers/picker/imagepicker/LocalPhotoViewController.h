//
//  LocalPhotoViewController.h
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LocalPhotoCell.h"
#import "LocalAlbumTableViewController.h"
#import "AssetHelper.h"
#import "FLAppDelegate.h"
@class FLIssueNewActivityTableViewController;
@class ViewController;
@protocol SelectPhotoDelegate<NSObject>
-(void)getSelectedPhoto:(NSMutableArray *)photos;
@end
@interface LocalPhotoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,SelectAlbumDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
- (IBAction)btnConfirm:(id)sender;
@property (nonatomic,retain) id<SelectPhotoDelegate> selectPhotoDelegate;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) ALAssetsGroup *currentAlbum;
@property (nonatomic, strong) NSMutableArray *selectPhotos;

/**控制器*/
@property (nonatomic ,strong)FLIssueNewActivityTableViewController* issueVC;
/**是否是一张*/
@property (nonatomic ,assign)BOOL isInterfaceImageType;

/**选中的按钮*/
@property (nonatomic , assign) NSInteger flAlreadyImageInteger;
/**是否选满4张*/
@property (nonatomic , assign) BOOL flisFull;

/**评价选图为1*/
@property (nonatomic , assign) NSInteger xjSelectedImageType;

/**最多为几张(默认为4)*/
@property (nonatomic , assign) NSInteger xjMaxSelected;

@end






