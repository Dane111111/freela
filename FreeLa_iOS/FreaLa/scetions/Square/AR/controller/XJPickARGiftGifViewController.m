//
//  XJPickARGiftGifViewController.m
//  FreeLa
//
//  Created by Leon on 2017/1/23.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJPickARGiftGifViewController.h"
#import "XJGiftGifModel.h"

#define cellWidth  (FLUISCREENBOUNDS.width-100)/4

@interface XJPickARGiftGifViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionView* xjCollectionView;
@property (nonatomic , strong) UICollectionViewFlowLayout*  customLayout;
@property (nonatomic , strong) NSArray* dataSource;

@end

@implementation XJPickARGiftGifViewController

- (instancetype)initWithDelegate:(id<XJPickARGiftGifViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.view.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem* sssssss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(xjClickCancle)];
        self.navigationController.navigationItem.leftBarButtonItem = sssssss;
        
        [self.navigationItem setLeftBarButtonItem:sssssss];
//        self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(xjClickDone)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图库选择";
    self.xjCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.xjCollectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.xjCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"xjxj"];
    [self xj_getGifList];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self. navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)xjClickCancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)xjClickDone{
    
}
- (UICollectionViewLayout *)customLayout {
    if (!_customLayout) {
        _customLayout = [[UICollectionViewFlowLayout alloc] init];
//        _customLayout.itemSize = CGSizeMake(40, 40);
        _customLayout.headerReferenceSize = CGSizeMake(FLUISCREENBOUNDS.width, 64);
    }
    return _customLayout;
}
- (UICollectionView *)xjCollectionView {
    if (!_xjCollectionView) {
         CGRect rect = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
        _xjCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:self.customLayout];
        _xjCollectionView.delegate = self;
        _xjCollectionView.dataSource = self;
    }
    return _xjCollectionView;
}

- (void)xj_getGifList {
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    [FLNetTool xj_getGifListSuccess:^(NSDictionary *data) {
        FL_Log(@"this is gif data【%@】",data);
        if ([data[FL_NET_DATA_KEY] count]!=0) {
            NSArray* arr = data[FL_NET_DATA_KEY];
            self.dataSource = [XJGiftGifModel  mj_objectArrayWithKeyValuesArray:arr];
            [self.xjCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xjxj" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth)];
    }
    [cell addSubview: [self xj_cellViewWithframe:CGRectMake(0, 0, cellWidth, cellWidth) index:indexPath.item]];
    return cell;
}

- (UIView*)xj_cellViewWithframe:(CGRect)frame index:(NSInteger)index{
    UIView* base = [[UIView alloc] initWithFrame:frame];
    UIImageView* img = [[UIImageView alloc] initWithFrame:frame];
    [base addSubview:img];
    img.contentMode = UIViewContentModeScaleToFill;
    XJGiftGifModel* model = self.dataSource[index];
    [img sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (index==self.dataSource.count-1) {
             [[FLAppDelegate share] hideHUD];
        }
    }];
    
    return base;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XJGiftGifModel* model = self.dataSource[indexPath.item];
    NSString* xjurl = model.imgUrl;
    NSString* xjfilname = model.fileName;
    if([XJFinalTool xjStringSafe:xjurl]) {
        if ([self.delegate respondsToSelector:@selector(xjPickARGiftGifViewController:didchooseDone:imgurl:)]) {
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate xjPickARGiftGifViewController:self didchooseDone:xjfilname imgurl:xjurl];
        }
    }
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return (CGSize){cellWidth,cellWidth};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

@end












