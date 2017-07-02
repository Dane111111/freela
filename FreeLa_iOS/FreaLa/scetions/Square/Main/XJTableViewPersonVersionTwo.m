//
//  XJTableViewPersonVersionTwo.m
//  FreeLa
//
//  Created by Leon on 16/5/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJTableViewPersonVersionTwo.h"
#import "XJSearchViewController.h"
#import "XJNaviViewSearchBar.h"
#import "XJVersionTwoPersonalModel.h"
#import "FLCouponsTableViewCell.h"


#import "BLImageSize.h"
#import "AoiroSoraLayout.h"
#import "CYItemCell.h"
#import "ItemModel.h"

@interface XJTableViewPersonVersionTwo ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AoiroSoraLayoutDelegate,UISearchBarDelegate>
{
    NSInteger _xjAllFreeTotal; //个人发布总个数
}
/**模型数组*/
@property (nonatomic , strong) NSMutableArray* xjModelsMuArr;
/**navi*/
@property (nonatomic , strong) XJNaviViewSearchBar* xjNaviView;
/**个人发布*/
@property (nonatomic , strong) UICollectionView * xjPersonalPushCollectionView; //个人发布
@property (nonatomic,strong)NSMutableArray * heightArray;// 存储图片高度的数组
@end

//static NSInteger _lastPosition ; //作为上下滑动的基准

@implementation XJTableViewPersonVersionTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self xjSetTableViewAndNavi];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)xjSetTableViewAndNavi {
    self.xjPersonalPushCollectionView.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjBeginToRefreshNewInfoInAllFree)];
    self.xjPersonalPushCollectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(xjBeginToLoadMoreInfoInAllFree)];
    
    [self.xjPersonalPushCollectionView registerNib:[UINib nibWithNibName:@"CYItemCell" bundle:nil] forCellWithReuseIdentifier:@"CYItemCell"];
    [self.xjPersonalPushCollectionView setContentInset:UIEdgeInsetsMake(- FL_STATUSBAR.height, 0, 0, 0) ];
    [self.xjPersonalPushCollectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    self.xjNaviView.xjSearchBar.delegate = self;
    [self.xjNaviView.xjBackBtn addTarget:self action:@selector(xjGoBackToRootView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.xjPersonalPushCollectionView];
    [self.view addSubview:self.xjNaviView];
    
    [self.xjPersonalPushCollectionView.mj_header beginRefreshing];
}
#pragma  mark ----------------------Lazy
- (UICollectionView *)xjPersonalPushCollectionView {
    if (!_xjPersonalPushCollectionView) {
        //个人发布
        AoiroSoraLayout* layout = [[AoiroSoraLayout alloc] init];//创建布局
        //    layout.sectionInset = UIEdgeInsetsMake(0.5, 1, 0.5, 1);
        layout.interSpace = 5; // 每个item 的间隔
        layout.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.colNum = 2; // 列数;
        layout.delegate = self;
        _xjPersonalPushCollectionView   = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 69, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) collectionViewLayout:layout];// 根据布局创建CollectionView
        _xjPersonalPushCollectionView.delegate = self;
        _xjPersonalPushCollectionView.dataSource = self;
        _xjPersonalPushCollectionView.backgroundColor = [UIColor whiteColor];
        _xjPersonalPushCollectionView.showsVerticalScrollIndicator = NO;
        _xjPersonalPushCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_xjPersonalPushCollectionView];// 将CollectionView添加到ScrollView中
        _xjPersonalPushCollectionView.hidden = NO;
        
    }
    return _xjPersonalPushCollectionView;
}
- (NSMutableArray *)xjModelsMuArr {
    if (!_xjModelsMuArr) {
        _xjModelsMuArr = [NSMutableArray array];
    }
    return _xjModelsMuArr;
}
-  (XJNaviViewSearchBar *)xjNaviView{
    if (!_xjNaviView) {
        _xjNaviView = [[XJNaviViewSearchBar alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, StatusBar_NaviHeight)];
    }
    return _xjNaviView;
}
- (NSMutableArray *)heightArray {
    if (_heightArray == nil) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

#pragma  mark ---------------------- Actions  Refresh
- (void)xjBeginToRefreshNewInfoInAllFree {
    [self.xjModelsMuArr removeAllObjects];
    [self xjgetAllFreeInfoInAllFreeWithCurrentPage:@1];
}
- (void)xjBeginToLoadMoreInfoInAllFree {
    [self xjgetAllFreeInfoInAllFreeWithCurrentPage:[FLTool xjRetuenCurrentWithArrLength:self.xjModelsMuArr.count andTotal:_xjAllFreeTotal xjSize:0]];
}

- (void)xjEndRefresh {
//    [FLTool xjEndRefreshWithView:self.xjPersonalPushCollectionView total:_xjAllFreeTotal modelsCount:self.xjModelsMuArr.count];
    [self.xjPersonalPushCollectionView.mj_header endRefreshing];
    if (_xjAllFreeTotal > self.xjModelsMuArr.count) {
        [self.xjPersonalPushCollectionView.mj_footer endRefreshing];
    } else {
        [self.xjPersonalPushCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma  mark ---------------------- info
- (void)xjgetAllFreeInfoInAllFreeWithCurrentPage:(NSNumber*)xjCurrentPage {
    NSDictionary* dic = @{@"page.currentPage":xjCurrentPage ,
                          @"topic.topicType":FLFLXJSquarePersonStrKey};
    FL_Log(@"dic ivn square version2 la1= %@",dic);
    [FLNetTool getSquareInfoWithParm:dic success:^(NSDictionary *data) {
        FL_Log(@"data in squ2are = %@",data);
        if ([[data objectForKey:FL_NET_KEY_NEW]boolValue]) {
            _xjAllFreeTotal = [data[@"total"] integerValue];
            [self xjEndRefresh];
            NSArray* xjArr = [XJVersionTwoPersonalModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            for (NSUInteger i = 0; i < xjArr.count; i++) {
                XJVersionTwoPersonalModel* xjModel = xjArr[i];
                NSString* str = [NSString stringWithFormat:@"%@",[XJFinalTool xjReturnBigPhotoURLWithStr:xjModel.thumbnail with:XJ_IMAGE_PUBULIU_ADD]];
                if (str&&![FLTool returnBoolWithIsHasHTTP:str includeStr:@"http://"]) {
                    str = [FLBaseUrl stringByAppendingString:str];
                }
                FL_Log(@"str================%ld    %@",i,str);
                [self p_putImageWithURL:str];
            }
            [self.xjModelsMuArr addObjectsFromArray:xjArr];
            [self.xjPersonalPushCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in square tableview info =%@",[FLTool returnStrWithErrorCode:error]);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        [self xjEndRefresh];
    }];
}
#pragma  mark ---------------------- Actions
- (void)xjGoBackToRootView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma  mark ---------------------- delegate
#pragma mark -- 返回每个item的高度
- (CGFloat)itemHeightLayOut:(AoiroSoraLayout *)layOut indexPath:(NSIndexPath *)indexPath {
    
    XJVersionTwoPersonalModel* model =  self.xjModelsMuArr[indexPath.item];
    if ([self.heightArray[indexPath.row] integerValue] < 0 || !self.heightArray[indexPath.row]) {
        
        return 250;
    }  else  {
        NSInteger intger = [self.heightArray[indexPath.row] integerValue];
//        CGFloat ddd  = [CYItemCell xj_bottom_h:model];
        return intger + 120 ;
    }
    
}

#pragma mark -- collectionView 的分组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- 获取 图片 和 图片的比例高度
- (void)p_putImageWithURL:(NSString *)url {
    // 获取图片
    
    CGSize  size = [BLImageSize dowmLoadImageSizeWithURL:url];
    
    // 获取图片的高度并按比例压缩
    NSInteger itemHeight = size.height * (((self.view.frame.size.width - 20) / 2 / size.width));
    
    NSNumber * number = [NSNumber numberWithInteger:itemHeight];
    
    [self.heightArray addObject:number];
    
}
#pragma  mark ---------------------- datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.xjModelsMuArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYItemCell *cell = (CYItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CYItemCell"forIndexPath:indexPath];
    if (self.xjModelsMuArr.count > indexPath.row) {
        XJVersionTwoPersonalModel *model = [self.xjModelsMuArr objectAtIndex:indexPath.row];
        cell.xjPersonalModel = model;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.xjModelsMuArr.count > indexPath.row) {
        XJVersionTwoPersonalModel *model = [self.xjModelsMuArr objectAtIndex:indexPath.row];
        FLFuckHtmlViewController* xjHTMLVC = [[FLFuckHtmlViewController alloc] init];
        xjHTMLVC.flFuckTopicId = [NSString stringWithFormat:@"%ld",model.topicId];
        [self.navigationController pushViewController:xjHTMLVC animated:YES];
    }
}

#pragma mark ---------------------- ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xjSetNaviColorWithOffsety:scrollView.contentOffset.y];
    
}

- (void)xjSetNaviColorWithOffsety:(CGFloat)offsetY {
    UIColor* xjColor =  XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [self.xjNaviView setBackgroundColor:[xjColor colorWithAlphaComponent:alpha]];
            //            [self.xjNaviView.xjSearchBar setHidden:YES];
            [self.xjNaviView.xjBackBtn setImage:[UIImage imageNamed:@"btn_icon_goback_white"] forState:UIControlStateNormal]; //btn_icon_goback_white
        } else {
            [self.xjNaviView setBackgroundColor:[xjColor colorWithAlphaComponent:0]];
            [self.xjNaviView.xjSearchBar setHidden:NO];
            [self.xjNaviView.xjBackBtn setImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        }
    });
}
#pragma mark ---------------------- searchBar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    XJSearchViewController* xjSearch = [[XJSearchViewController alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:xjSearch animated:YES];
    return NO;
}

//给cell添加动画

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}


@end



















