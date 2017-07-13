//
//  XJGiftMapViewController.m
//  FreeLa
//
//  Created by Leon on 2016/12/28.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJGiftMapViewController.h"

//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapSearchKit/AMapSearchKit.h>
#import "CloudPOIAnnotation.h"

#import "LewPopupViewController.h"
#import "XJArHideGiftView.h"
#import "XJHideGiftViewController.h"

#import "XJPointAnnotation.h"
#import "XJAnnotationView.h"
#import "XJUserAnnotationView.h"

#import "CoordinateQuadTree.h"
#import "ClusterTableViewCell.h"
#import "CustomCalloutView.h"
#import "ClusterAnnotation.h"
//#import "XJClusterAnnotationView.h"
//#import "XJOutClusterAnnotationView.h"

#import "BGAnnotationView.h"
#import "BGOutAnnotationView.h"

#import "XJFindGiftViewController.h"
#import "XJJiaClusterAnnotationView.h"
#import "XJOutClusterCallOutView.h"
#import "XJBackGroundCircle.h"
#import "XJJiaOutClusterAnnotationView.h"
#import "XJHelpTouchView.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"


//#import <AMapLocationKit/AMapLocationKit.h>

static const NSInteger RoutePlanningPaddingEdge                    = 20;

#define kDefaultLocationZoomLevel       15.1
#define kDefaultControlMargin           22



#define kCalloutViewMargin  -35
#define Button_Height       70.0

@interface XJGiftMapViewController ()<AMapSearchDelegate,MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,AMapLocationManagerDelegate,CustomCalloutViewTapDelegate,UIGestureRecognizerDelegate>

/**search*/
@property (nonatomic , strong) AMapSearchAPI* search;
@property (nonatomic , strong) MAMapView* mapView;
@property (nonatomic , strong) AMapLocationManager *locationManager;
/**用户的定位点*/
@property (nonatomic , strong) XJPointAnnotation* xj_annotation;

//@property (nonatomic , strong) UIButton* xjHideGiftButton;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
/**暂时不知道干嘛用的*/
@property (nonatomic, assign) BOOL shouldRegionChangeReCalculate;
/**当前的 poi 云图搜索请求*/
@property (nonatomic, strong) AMapCloudPOIAroundSearchRequest *currentRequest;
/**当前的 poi 云图搜索请求  结果*/
@property (nonatomic, strong) NSMutableArray *selectedPoiArray;
/**四叉树*/
@property (nonatomic, strong) CoordinateQuadTree* coordinateQuadTree;
/**弹出层*/
@property (nonatomic, strong) CustomCalloutView *customCalloutView;
/**范围之外的弹出层*/
@property (nonatomic, strong) XJOutClusterCallOutView *xjOutClusterCallOutView;

/**圆环*/
@property (nonatomic, strong)  MACircle *xj_circle;

/**蒙层大圆*/
@property (nonatomic, strong)  XJBackGroundCircle *xj_Backcircle;
/**需要添加在地图上的假 大头针*/
@property (nonatomic , strong) NSArray* xj_jiaAnnotations;
/**需要添加在地图上的真 大头针*/
@property (nonatomic , strong) NSArray* xj_zhenAnnotations;

/**单手旋转问题*/
@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;
@property (strong, nonatomic) UIButton *flGoBackBtn;

@property(nonatomic,strong)NSString*makeiconStr;
/* 路径规划类型 */

@property (nonatomic, strong) AMapRoute *route;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@end

@implementation XJGiftMapViewController {
    XJHelpTouchView* xjRotationView;
}
- (UIButton *)flGoBackBtn {
    if (!_flGoBackBtn) {
        _flGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flGoBackBtn.frame = CGRectMake(20, 20, 40, 40);
        [_flGoBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        [_flGoBackBtn addTarget:self action:@selector(xj_popGoBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flGoBackBtn;
}
- (void)xj_popGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark mark icon
-(void)getMake{
    [FLNetTool deGetAdminMarkListWith:nil success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if (data[@"data"]) {
                NSArray*arr=data[@"data"];
                if (arr&&arr.count>0) {
                    self.makeiconStr=arr[0][@"imgUrl"];
                }
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldRegionChangeReCalculate = NO;
    [self hehehe];
    [self initCompleteBlock];
    [self initMapView];
    [self xj_createHideGift];//创建 藏红包功能
    [self.view addSubview:self.flGoBackBtn];

    [self getMake];
}
#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.coordinateQuadTree = [[CoordinateQuadTree alloc] init];
        
        self.selectedPoiArray = [[NSMutableArray alloc] init];
        
        self.customCalloutView = [[CustomCalloutView alloc] init];
        self.xjOutClusterCallOutView = [[XJOutClusterCallOutView alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [self cleanUpAction];
    
    self.completionBlock = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController.navigationBar setHidden:YES];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
     [self xj_checkUserLo];
    
    [self clear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hehehe
{
    //初始化检索对象
    [AMapServices sharedServices].apiKey = FL_GAODE_API_KEY;//@"1e0aebfcb8521c830d96712e95f896ae";
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    _search.timeout = 5; //超时
    
}

- (void)xj_initCircle{
    //构造圆
    if (self.xj_circle) {
        [self.mapView removeOverlay:self.xj_circle];
    }
    self.xj_circle = [MACircle circleWithCenterCoordinate:_xj_annotation.coordinate radius:500];
    //在地图上添加圆
    [_mapView addOverlay: self.xj_circle];
    
//    if (self.xj_Backcircle) {
//        [self.mapView removeOverlay:self.xj_Backcircle];
//    }
//    self.xj_Backcircle = [XJBackGroundCircle circleWithCenterCoordinate:_xj_annotation.coordinate radius:20000];
//    [_mapView addOverlay:self.xj_Backcircle];
}

- (MAMapView *)mapView{
    if (!_mapView) {
        
        //创建一个透明view 为了实现单手旋转操作
        xjRotationView = [[XJHelpTouchView alloc] initWithFrame:self.view.bounds];
        UIPanGestureRecognizer* panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)];
        xjRotationView.userInteractionEnabled = YES;
        _deltaAngle = atan2(FLUISCREENBOUNDS.height/2,FLUISCREENBOUNDS.width/2);
        [xjRotationView addGestureRecognizer:panResizeGesture];
        [self.view addSubview:xjRotationView];
        //地图
        _mapView =[[MAMapView alloc] initWithFrame:CGRectMake(0,  0, CGRectGetWidth(self.view.bounds), FLUISCREENBOUNDS.height+240)];
        [xjRotationView addSubview:_mapView];
//        //半圆蒙层
//        UIImageView* image = [[UIImageView alloc] init];
//        image.image = [UIImage imageNamed:@"ar_map_top"];
//        image.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, 160);
////        [self.mapView addSubview:image];
//        [self.mapView insertSubview:image atIndex:1];
        
        _mapView.delegate = self;
        [_mapView setRotateEnabled:YES];
        _mapView.userInteractionEnabled = YES;
        self.view.userInteractionEnabled =  YES;
    }
    return _mapView;
}

-(void)resizeTranslate:(UIPanGestureRecognizer *)recognizer{
    if ([recognizer state]== UIGestureRecognizerStateBegan){
        self.prevPoint = [recognizer locationInView:xjRotationView];
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:xjRotationView];
        float wChange = 0.0, hChange = 0.0;
        wChange = (point.x - _prevPoint.x);
        hChange = (point.y - _prevPoint.y);
        if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
            _prevPoint = [recognizer locationInView:xjRotationView];
            return;
        }
        if (wChange < 0.0f && hChange < 0.0f) {
            float change = MIN(wChange, hChange);
            wChange = change;
            hChange = change;
        }
        if (wChange < 0.0f) {
            hChange = wChange;
        } else if (hChange < 0.0f) {
            wChange = hChange;
        } else {
            float change = MAX(wChange, hChange);
            wChange = change;
            hChange = change;
        }
        _prevPoint = [recognizer locationInView:xjRotationView];
        /* Rotation */
        float ang = atan2([recognizer locationInView:xjRotationView].y - xjRotationView.center.y,
                          [recognizer locationInView:xjRotationView].x - xjRotationView.center.x);
        float angleDiff = _deltaAngle - ang;
        
        [self.mapView setRotationDegree:angleDiff*(180/M_PI) animated:YES duration:0.1];
        
    } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        self.prevPoint = [recognizer locationInView:xjRotationView];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)initMapView
{
    [AMapServices sharedServices].apiKey = FL_GAODE_API_KEY;//@"1e0aebfcb8521c830d96712e95f896ae";
    
//     //为了能单手旋转，设置一个透明界面 覆盖在 map 上
//    UIView* xjview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
//    [self.mapView addSubview:xjview];
////    xjview.backgroundColor = [UIColor redColor];
//    UIRotationGestureRecognizer* rota = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(xjccccc:)];
//    rota.delegate = self;
//    [xjview addGestureRecognizer:rota];
    
    

    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 22);
    self.mapView.scaleOrigin = CGPointMake(self.mapView.scaleOrigin.x, 22);
//    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    
    [self.mapView setMapType:MAMapTypeStandard]; //设置夜间模式
    _mapView.zoomEnabled = YES;//设置不能缩放
//    [_mapView setZoomLevel:17  animated:YES];
    _mapView.scrollEnabled = NO;//设置不能滑动
     _mapView.rotateEnabled= YES;
    _mapView.rotateCameraEnabled= NO;
    [_mapView setCameraDegree:40.f animated:NO duration:0.5];//设置倾斜度
    _mapView.showsBuildings = YES;
    _mapView.showTraffic = YES;
    _mapView.showsScale = NO;
    _mapView.showsLabels = YES;
    _mapView.showsUserLocation = NO;
    //设置可见区域
//    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
   
}
#pragma mark - Initialization

- (void)initCompleteBlock
{
    __weak XJGiftMapViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error，则不进行annotation的添加
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //得到定位信息，添加annotation
        if (location)
        {
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setCoordinate:location.coordinate];
            
            if (regeocode)
            {
                [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
                [weakSelf xjSearchPOIsFromARKitServiceWithLocationx:location.coordinate.longitude
                                                                  y:location.coordinate.latitude
                                                               city:regeocode.city];
            }
            else
            {
                [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
                [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
            }
            
            XJGiftMapViewController *strongSelf = weakSelf;
            [strongSelf addAnnotationToMapView:annotation];
        }
    };
}
- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    self.xj_annotation = [[XJPointAnnotation alloc] init];
    [self.xj_annotation setCoordinate:annotation.coordinate];
    [self.mapView addAnnotation:self.xj_annotation];
    
    [self.mapView selectAnnotation:annotation animated:NO];
    [self.mapView setZoomLevel:kDefaultLocationZoomLevel animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:NO];
    
//    [self xjSearchAroundWithLocationx:annotation.coordinate.longitude y:annotation.coordinate.latitude];
    
    [self xj_initCircle];//构造圆
}


- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}


- (void)xj_checkUserLo{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:6];
    
    [self reGeocodeAction];
    
  
}
#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    FL_Log(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}


- (void)xjSearchAroundWithLocationx:(CGFloat)longitude y:(CGFloat)latitude{
    AMapCloudPOIAroundSearchRequest *placeAround = [[AMapCloudPOIAroundSearchRequest alloc] init];
    [placeAround setTableID:(NSString *)XJ_GAODE_TABLEID];
    
    [placeAround setRadius:5000];
    
//    AMapGeoPoint* centerPoint = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    AMapGeoPoint *centerPoint = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    
    [placeAround setCenter:centerPoint];
    
//    [placeAround setKeywords:@" "];
    
    //过滤条件数组filters的含义等同于SQL语句:WHERE _address = "北京" AND _id BETWEEN 1 AND 20
//    NSArray *filters = [[NSArray alloc] initWithObjects: @"_address:北京",nil];
//    [placeAround setFilter:filters];
    
    
//    placeAround.keywords = @" ";
//    [placeAround setSortFields:@"_id"];
    placeAround.offset = 100;
    [placeAround setSortType:AMapCloudSortTypeDESC];
    
//    [placeAround setOffset:0];
    self.currentRequest = placeAround;
    [self.search AMapCloudPOIAroundSearch:placeAround];
    
}
#pragma mark -------------- 从自己后台获取云图数据
- (void)xjSearchPOIsFromARKitServiceWithLocationx:(CGFloat)longitude y:(CGFloat)latitude city:(NSString*)city{
    
    NSDictionary* parm = @{@"compid":@"",
                           @"city":city,
                           @"userid":XJ_USERID_WITHTYPE,
                           @"positon":[NSString stringWithFormat:@"%f,%f",longitude,latitude],
                           @"distance":@"1000000"
                           
                           };
    [FLNetTool xjGetGiftMapResultsFromServer:parm searchType:@"C" success:^(NSDictionary *data) {
        //        XJFL_Log(@"this is pois datsa=【%@】",data );
        NSArray* arr = data[@"data"];
        NSMutableArray* mu = @[].mutableCopy;
        for (NSDictionary* dic in arr) {
            if ([dic[@"lbsOnly"] integerValue]==1) {
                continue;
            }
            AMapCloudPOI* poi = [[AMapCloudPOI alloc] init];
            poi.address = dic[@"_address"];
            AMapGeoPoint* location =  [[AMapGeoPoint alloc] init];
            NSArray* loarr = [[NSString stringWithFormat:@"%@",dic[@"_location"]] componentsSeparatedByString:@","];
            location.longitude = [loarr[0] floatValue];
            location.latitude  = [loarr[1] floatValue];
            poi.location = location;
            
            poi.name = dic[@"_name"];
            poi.customFields = @{
                                 @"pictureCode":dic[@"pictureCode"]?dic[@"pictureCode"]:@"",
                                 @"topicId":dic[@"topicId"]?dic[@"topicId"]:@"",
                                 @"topicPublisher":dic[@"topicPublisher"]?dic[@"topicPublisher"]:@"",
                                 @"topicPublisherIcon":dic[@"topicPublisherIcon"]?dic[@"topicPublisherIcon"]:@""
                                 };
            [mu addObject:poi];
        }
        self.xj_zhenAnnotations = mu.mutableCopy;
        [self addAnnotations2WithPOIs:self.xj_zhenAnnotations];
        if (self.xj_zhenAnnotations.count <= 30) {
            /*  if [response POIs].count ==  0
             [self.mapView addAnnotation:_xj_annotation];
             return;
             */
            self.xj_jiaAnnotations = [self xj_returnJiaPOIs];
            [self addAnnotationsWithPOIs:self.xj_jiaAnnotations];
        }
        
//        @synchronized(self)  {
//            self.shouldRegionChangeReCalculate = NO;
//            
//            // 清理
//            [self.selectedPoiArray removeAllObjects];
//            [self.customCalloutView dismissCalloutView];
//            [self.xjOutClusterCallOutView dismissCalloutView];
//            [self.mapView removeAnnotations:self.xj_zhenAnnotations];
//            
//            
//            __weak typeof(self) weakSelf = self;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                /* 建立四叉树. */
//                if (self.xj_zhenAnnotations.count!=0) {
//                    [weakSelf.coordinateQuadTree buildTreeWithPOIs:self.xj_zhenAnnotations];
//                }
//                weakSelf.shouldRegionChangeReCalculate = YES;
//                
//                [weakSelf addAnnotationsToMapView:weakSelf.mapView];
//            });
//        }
        

    } failure:^(NSError *error) {
        
    }];
}
//回调
- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
    // 只处理最新的请求
    if (request != self.currentRequest) {
        return;
    }
    if ([response POIs].count <= 30) {
        /*  if [response POIs].count ==  0
        [self.mapView addAnnotation:_xj_annotation];
        return;
         */
        self.xj_jiaAnnotations = [self xj_returnJiaPOIs];
        [self addAnnotationsWithPOIs:self.xj_jiaAnnotations];
    }
    self.xj_zhenAnnotations = [response POIs];
    @synchronized(self)  {
        self.shouldRegionChangeReCalculate = NO;
        
        // 清理
        [self.selectedPoiArray removeAllObjects];
        [self.customCalloutView dismissCalloutView];
        [self.xjOutClusterCallOutView dismissCalloutView];
        [self.mapView removeAnnotations:self.xj_zhenAnnotations];
        
       
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 建立四叉树. */
            [weakSelf.coordinateQuadTree buildTreeWithPOIs:self.xj_zhenAnnotations];
            weakSelf.shouldRegionChangeReCalculate = YES;
            
            [weakSelf addAnnotationsToMapView:weakSelf.mapView];
        });
    }
}
- (NSArray*)xj_returnJiaPOIs{
    NSArray* xj;
    int total = (arc4random() % 9) + 1;
    
    CGFloat longitude = _xj_annotation.coordinate.longitude;
    CGFloat latitude = _xj_annotation.coordinate.latitude;
    NSMutableArray* xjmu = @[].mutableCopy;
    for (NSInteger i = 0; i < total; i++) {
        AMapCloudPOI* pois = [[AMapCloudPOI alloc] init];
        pois.customFields = @{@"xjjia":@"1",
                              @"topicPublisherIconPath":[FLTool xj_returnJiaAvatarStr],
                              };
        int xm = (arc4random() % 450) + 101;
        int xl = (arc4random() % 799) + 100;
        NSString* xmln = [NSString stringWithFormat:@"0.0%d",xm];
        NSString* xlln = [NSString stringWithFormat:@"0.0%d",xl];
        CGFloat xx = latitude - 0.0333 + [xmln floatValue];
        CGFloat mm = longitude - 0.0444 + [xlln floatValue];
        AMapGeoPoint* point = [AMapGeoPoint locationWithLatitude:xx longitude:mm];
        pois.location = point;
        [xjmu addObject:pois];
    }
    xj = xjmu.mutableCopy;
    return xj;
}

- (void)addAnnotationsWithPOIs:(NSArray *)pois
{
    
    [self.mapView removeAnnotations:self.xj_jiaAnnotations];
    [self.mapView addAnnotation:self.xj_annotation];
    for (AMapCloudPOI *aPOI in pois)
    {
        //        NSLog(@"%@", [aPOI formattedDescription]);
        CloudPOIAnnotation *ann = [[CloudPOIAnnotation alloc] initWithCloudPOI:aPOI];
//        ann.coordinate = CLLocationCoordinate2DMake(aPOI.location.latitude, aPOI.location.longitude);
        [self.mapView addAnnotation:ann];
    }
}
- (void)addAnnotations2WithPOIs:(NSArray *)pois{
    [self.mapView removeAnnotations:self.xj_zhenAnnotations];
    for (AMapCloudPOI *aPOI in pois)
    {
        //        NSLog(@"%@", [aPOI formattedDescription]);
        ClusterAnnotation *ann = [[ClusterAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(aPOI.location.latitude, aPOI.location.longitude) count:1];
        ann.pois=@[aPOI].mutableCopy;

        [self.mapView addAnnotation:ann];
    }

}
//更改annotation
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[XJPointAnnotation class]]) {
        static NSString *customReuseIndetifierxj = @"customReuseIndetifierxj";
        
        XJUserAnnotationView *annotationView = (XJUserAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifierxj];
        
        if (annotationView == nil)
        {
            annotationView = [[XJUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifierxj];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
            annotationView.centerOffset = CGPointMake(0, 0);
        }
        
//         annotationView.image = [UIImage imageNamed:@"ar_gift"];
        NSString* xjAvatar = [[XJUserAccountTool share] xj_getUserAvatar];
        [annotationView.xjUserHeaderImageView sd_setImageWithURL:[NSURL URLWithString:xjAvatar] placeholderImage:[UIImage imageNamed:@"ar_gift"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        return annotationView;
    }
    /*
    if ([annotation isKindOfClass:[CloudPOIAnnotation class]]) {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        annotationView.frame = CGRectMake(0, 0, 60, 60*1.4);
        annotationView.image = [UIImage imageNamed:@"ar_gift_light_single"];
        //判断点是否在圆内
        CLLocationCoordinate2D location = annotation.coordinate;
        CLLocationCoordinate2D center = _xj_annotation.coordinate;
        BOOL isContains = MACircleContainsCoordinate(location, center, 500);
        if (!isContains) {
            annotationView.image = [UIImage imageNamed:@"ar_fudai-singl"];
        }
        [self.mapView bringSubviewToFront:annotationView];
        return annotationView;
    }
     */
    if ([annotation isMemberOfClass:[CloudPOIAnnotation class]]) {
        //判断点是否在圆内
        CLLocationCoordinate2D location = annotation.coordinate;
        CLLocationCoordinate2D center = _xj_annotation.coordinate;
        BOOL isContains = MACircleContainsCoordinate(location, center, 500);
        if (isContains) {  //在圆内
            /* dequeue重用annotationView. */
            static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseIDJiaIn";
            
            XJJiaClusterAnnotationView *annotationView = (XJJiaClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
            if (!annotationView) {
                annotationView = [[XJJiaClusterAnnotationView alloc] initWithAnnotation:annotation
                                                                     reuseIdentifier:AnnotatioViewReuseID];
            }
            /* 设置annotationView的属性. */
            annotationView.annotation = annotation;
            [annotationView xj_setCount:1 isInCircle:YES];
            CloudPOIAnnotation* xxx = (CloudPOIAnnotation*)annotation;
            AMapCloudPOI* pois = xxx.cloudPOI;
            annotationView.xjHeaderImgPath = pois.customFields[@"topicPublisherIconPath"];
            NSString* xjs = pois.customFields[@"topicPublisherIcon"];
            if ([XJFinalTool xjStringSafe:xjs]) {
                xjs = [XJFinalTool xjReturnImageURLWithStr:xjs isSite:NO];
                annotationView.xjHeaderImgStr = xjs;
            }

             /* 不弹出原生annotation */
            annotationView.canShowCallout = NO;
            return annotationView;
        }else{
            //在圆外，弹出提示曾    XJOutClusterAnnotationView
            /* dequeue重用annotationView. */
            static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseIDJia_out";
            
            XJJiaOutClusterAnnotationView *annotationView = (XJJiaOutClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
            if (!annotationView) {
                annotationView = [[XJJiaOutClusterAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:AnnotatioViewReuseID];
            }
            /* 设置annotationView的属性. */
            annotationView.annotation = annotation;
            [annotationView xj_setCount:1 isInCircle:NO];
            CloudPOIAnnotation* xxx = (CloudPOIAnnotation*)annotation;
            AMapCloudPOI* pois = xxx.cloudPOI;
            annotationView.xjHeaderImgPath = pois.customFields[@"topicPublisherIconPath"];
            NSString* xjs = pois.customFields[@"topicPublisherIcon"];
            if ([XJFinalTool xjStringSafe:xjs]) {
                xjs = [XJFinalTool xjReturnImageURLWithStr:xjs isSite:NO];
                annotationView.xjHeaderImgStr = xjs;
            }

            /* 不弹出原生annotation */
            annotationView.canShowCallout = NO;
            return annotationView;
        }

    }
    if ([annotation isKindOfClass:[ClusterAnnotation class]]) {
        //判断点是否在圆内
        CLLocationCoordinate2D location = annotation.coordinate;
        CLLocationCoordinate2D center = _xj_annotation.coordinate;
        BOOL isContains = MACircleContainsCoordinate(location, center, 500);
        
        if (isContains) {  //在圆内
            /* dequeue重用annotationView. */
            static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
            
            BGAnnotationView *annotationView = (BGAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
            if (!annotationView) {
                annotationView = [[BGAnnotationView alloc] initWithAnnotation:annotation
                                                                     reuseIdentifier:AnnotatioViewReuseID];
            }
            /* 设置annotationView的属性. */
            annotationView.annotation = annotation;
            
//            annotationView.count = [(ClusterAnnotation *)annotation count];
            [annotationView xj_setCount:[(ClusterAnnotation *)annotation count] isInCircle:YES];
            if (annotationView.count==1) {
                NSArray* ss = [(ClusterAnnotation *)annotation pois].mutableCopy;
                if (ss.count!=0) {
                    AMapCloudPOI *cloudPOI = ss[0];
                    NSString* xjs = cloudPOI.customFields[@"topicPublisherIcon"];
                    if ([XJFinalTool xjStringSafe:xjs]) {
                        xjs = [XJFinalTool xjReturnImageURLWithStr:xjs isSite:NO];
                        annotationView.xjHeaderImgStr =self.makeiconStr?self.makeiconStr: xjs;
                    }
                }
            }

            /* 不弹出原生annotation */
            annotationView.canShowCallout = NO;
            return annotationView;
        }else{
            //在圆外，弹出提示曾    XJOutClusterAnnotationView
            /* dequeue重用annotationView. */
            static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID_out";
            
            BGOutAnnotationView *annotationView = (BGOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
            if (!annotationView) {
                annotationView = [[BGOutAnnotationView alloc] initWithAnnotation:annotation
                                                                     reuseIdentifier:AnnotatioViewReuseID];
            }
            /* 设置annotationView的属性. */
            annotationView.annotation = annotation;
//            annotationView.count = [(ClusterAnnotation *)annotation count];
            [annotationView xj_setCount:[(ClusterAnnotation *)annotation count] isInCircle:NO];
            /* 不弹出原生annotation */
            annotationView.canShowCallout = NO;
            if (annotationView.count==1) {
                NSArray* ss = [(ClusterAnnotation *)annotation pois].mutableCopy;
                if (ss.count!=0) {
                    AMapCloudPOI *cloudPOI = ss[0];
                    NSString* xjs = cloudPOI.customFields[@"topicPublisherIcon"];
                    if ([XJFinalTool xjStringSafe:xjs]) {
                        xjs = [XJFinalTool xjReturnImageURLWithStr:xjs isSite:NO];
                        annotationView.xjHeaderImgStr =self.makeiconStr?self.makeiconStr: xjs;
                    }
                }
            }
            return annotationView;
        }
    }
    
    return nil;
}

//创建藏红包功能
- (void)xj_createHideGift{
    UIView* xjview = [[UIView alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width-100, FLUISCREENBOUNDS.height-100, 40, 65)];
    [self.view addSubview:xjview];
    
    UIButton* xjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [xjbtn setBackgroundImage:[UIImage imageNamed:@"ar_hide_btn_red"] forState:UIControlStateNormal];
//    xjbtn.backgroundColor = [UIColor blackColor];
    xjbtn.frame = CGRectMake(0, 0, 40, 40);
    [xjview addSubview:xjbtn];
    [xjbtn addTarget:self action:@selector(xjClickToHideGift) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* xjlabel = [[UILabel alloc] init];
    xjlabel.font = [UIFont fontWithName:FL_FONT_NAME size:16];
    xjlabel.textColor = [UIColor whiteColor];
    xjlabel.textAlignment = NSTextAlignmentCenter;
    xjlabel.text = @"藏宝";
    xjlabel.frame = CGRectMake(0, 45, 40, 20);
//    [xjview addSubview:xjlabel];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xjview addSubview:btn];
    btn.frame = CGRectMake(-10, 45, 60, 20);
    [btn setTitle:@"藏宝" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(xjClickToHideGift) forControlEvents:UIControlEventTouchUpInside];
}
//仓礼物
- (void)xjClickToHideGift{
    
    /**跳转到扫礼物界面*/
    XJHideGiftViewController* xjvc = [[XJHideGiftViewController alloc] initWithModel:nil];
    [self.navigationController pushViewController:xjvc animated:YES];
 
}

#pragma mark 这里是 点聚合相关
- (void)addAnnotationsToMapView:(MAMapView *)mapView
{
    @synchronized(self)
    {
        if (self.coordinateQuadTree.root == nil || !self.shouldRegionChangeReCalculate)
        {
            NSLog(@"tree is not ready.");
            return;
        }
        
        /* 根据当前zoomLevel和zoomScale 进行annotation聚合. */
        
        MAMapRect visibleRect = self.mapView.visibleMapRect;//MAMapRectMake(220880104, 101476980, 272496, 466656);//self.mapView.visibleMapRect;
        double zoomScale = self.mapView.bounds.size.width / visibleRect.size.width;
        double zoomLevel = 15;
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *annotations = [weakSelf.coordinateQuadTree clusteredAnnotationsWithinMapRect:visibleRect
                                                                                    withZoomScale:zoomScale
                                                                                     andZoomLevel:zoomLevel];
            /* 更新annotation. */
            [weakSelf updateMapViewAnnotationsWithAnnotations:annotations];
        });
    }
}

/* 更新annotation. */
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    /* 用户滑动时，保留仍然可用的标注，去除屏幕外标注，添加新增区域的标注 */
    NSMutableSet *before = [NSMutableSet setWithArray:self.xj_zhenAnnotations];//self.xj_zhenAnnotations
    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    
    /* 保留仍然位于屏幕内的annotation. */
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    /* 需要添加的annotation. */
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    /* 删除位于屏幕外的annotation. */
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    /* 更新. */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
        [self.mapView addAnnotation:self.xj_annotation];
    });
}

#pragma mark ------------------------------- CustomCalloutViewTapDelegate

- (void)didDetailButtonTapped:(NSInteger)index
{
    AMapCloudPOI* poi = self.selectedPoiArray[index];
    NSString* xjtopicid = [NSString stringWithFormat:@"%@",poi.customFields[@"topicId"]];
    
    //需要请求 是否有领取资格
    [self checkTakeCanOrNot:xjtopicid index:index];
    
}

#pragma mark ------------------------------- 领取资格
- (void)checkTakeCanOrNot:(NSString*)xjtopicid index:(NSInteger)index{

//    //等会儿要删除
//    XJFindGiftViewController *detail = [[XJFindGiftViewController alloc] init];
//    detail.poi = self.selectedPoiArray[index];
//    /* 进入POI详情页面. */
//    [self.navigationController pushViewController:detail animated:YES];
    
    
    FL_Log(@"this web view begin to reload for test");
    //检查领取资格
    NSDictionary* parm = @{@"participate.topicId": xjtopicid,
                           @"participate.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in check pi22ck topic =%@",data);
        NSString* buKey = data[@"buttonKey"];
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            XJFindGiftViewController *detail = [[XJFindGiftViewController alloc] init];
            if (self.selectedPoiArray.count >=index) {
               detail.poi = self.selectedPoiArray[index];
            }
            /* 进入POI详情页面. */
            [self.navigationController pushViewController:detail animated:YES];
        } else {
            if ([buKey isEqualToString:@"b22"]) {
                [FLTool showWith:@"您和发布者非好友,不能领取"];
            }else if ([buKey isEqualToString:@"b2"]) {
                [FLTool showWith:@"您没有绑定手机号，不能领取"];
            }else if ([buKey isEqualToString:@"b10"]) {
                [FLTool showWith:@"您已经领取过了"];
            }else {
                [FLTool showWith:@"您不在领取范围内,不能领取"];
            }
        }
    } failure:^(NSError *error) {
        [FLTool showWith:@"服务异常，请稍后重试"];
    }];
}


#pragma mark - MAMapViewDelegate
/**
 * @brief 单击地图回调，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self clear];
}
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    [self.selectedPoiArray removeAllObjects];
    [self.customCalloutView dismissCalloutView];
    [self.xjOutClusterCallOutView dismissCalloutView];
    self.customCalloutView.delegate = nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isMemberOfClass:[BGAnnotationView class]]) {
        ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
        for (AMapPOI *poi in annotation.pois)
        {
            [self.selectedPoiArray addObject:poi];
        }
        AMapCloudPOI* poi = self.selectedPoiArray[0];
        NSString* xjtopicid = [NSString stringWithFormat:@"%@",poi.customFields[@"topicId"]];
        
        //需要请求 是否有领取资格
        [self checkTakeCanOrNot:xjtopicid index:0];

//        [self.customCalloutView setPoiArray:self.selectedPoiArray];
//        self.customCalloutView.delegate = self;
//        
//        // 调整位置
//        self.customCalloutView.center = CGPointMake(CGRectGetMidX(view.bounds), -CGRectGetMidY(self.customCalloutView.bounds) - CGRectGetMidY(view.bounds) - kCalloutViewMargin);
//        
//        [view addSubview:self.customCalloutView];
    }
    if([view isKindOfClass:[BGOutAnnotationView class]]) {
        ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
        AMapCloudPOI* poi=annotation.pois[0];
        
        [self luXianGuiHuaWithZDLat:poi.location.latitude ZDLong:poi.location.longitude];

        self.xjOutClusterCallOutView.xjCount = [annotation.pois count];
        self.xjOutClusterCallOutView.center = CGPointMake(CGRectGetMidX(view.bounds), -CGRectGetMidY(self.customCalloutView.bounds) - CGRectGetMidY(view.bounds) - kCalloutViewMargin);
        [view addSubview:self.xjOutClusterCallOutView];
    }
    if([view isKindOfClass:[XJJiaOutClusterAnnotationView class]]){
        CloudPOIAnnotation *annotation = (CloudPOIAnnotation *)view.annotation;
        
        [self luXianGuiHuaWithZDLat:annotation.cloudPOI.location.latitude ZDLong:annotation.cloudPOI.location.longitude];
        
        self.xjOutClusterCallOutView.xjCount = 1;
        self.xjOutClusterCallOutView.center = CGPointMake(CGRectGetMidX(view.bounds), -CGRectGetMidY(self.customCalloutView.bounds) - CGRectGetMidY(view.bounds) - kCalloutViewMargin);
        [view addSubview:self.xjOutClusterCallOutView];
    }
    if ([view isMemberOfClass:[XJJiaClusterAnnotationView class]]) {
        [FLTool showWith:@"您没有在领取范围内，不能领取哟"];
    }
}
#pragma mark 路线规划
-(void)luXianGuiHuaWithZDLat:(double)zdLat ZDLong:(double)zdLong{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.xj_annotation.coordinate.latitude
                                           longitude:self.xj_annotation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:zdLat
                                                longitude:zdLong];
    self.destinationCoordinate=CLLocationCoordinate2DMake(zdLat, zdLong);
    [self.search AMapWalkingRouteSearch:navi];

    
}
#pragma mark 路径规划搜索回调
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    self.route = response.route;

//    if (response.count > 0)
//    {
//        //移除地图原本的遮盖
//        [_mapView removeOverlays:_pathPolylines];
//        _pathPolylines = nil;
//        
//        // 只显⽰示第⼀条 规划的路径
//        _pathPolylines = [self polylinesForPath:response.route.paths[0]];
//        NSLog(@"%@",response.route.paths[0]);
//        //添加新的遮盖，然后会触发代理方法进行绘制
//        [_mapView addOverlays:_pathPolylines];
//    }

    
    
    
    if (response.count > 0)
    {
    
        [self presentCurrentCourse];
    }

    //解析response获取路径信息，具体解析见 Demo
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    [self clear];

    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:NO startPoint:[AMapGeoPoint locationWithLatitude:self.xj_annotation.coordinate.latitude longitude:self.xj_annotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude]];
    self.naviRoute.anntationVisible=NO;
    self.naviRoute.walkingColor=[UIColor colorWithHexString:@"#00b0ff" alpha:1];
    [self.naviRoute addToMapView:self.mapView];
    
    
    /* 缩放地图使其适应polylines的展示. */
//    [CommonUtility mapRectForOverlays:self.naviRoute.routePolylines];
//    [self.mapView setVisibleMapRect:
//                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
//                           animated:YES];
}
/* 清空地图上已有的路线. */
- (void)clear
{
    if (self.naviRoute) {
        [self.naviRoute removeFromMapView];

    }
}

#pragma mark 路径规划失败回调

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        polylineRenderer.lineJoinType=kMALineJoinMiter;
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        polylineRenderer.lineJoinType=kMALineJoinMiter;
        polylineRenderer.lineCapType=kMALineCapSquare;
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    if ([overlay isMemberOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle*)overlay];
        
        circleRenderer.lineWidth    = 15.f;
        circleRenderer.strokeColor  = [[UIColor colorWithHexString:@"#6cb5ff"] colorWithAlphaComponent:0.4];
        circleRenderer.fillColor    = [[UIColor colorWithHexString:@"#69b7ff"] colorWithAlphaComponent:0.4];
        return circleRenderer;
    }
    if ([overlay isMemberOfClass:[XJBackGroundCircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle*)overlay];
        circleRenderer.lineWidth    = 5.f;
        circleRenderer.fillColor    =  [[UIColor colorWithHexString:@"#00196c"] colorWithAlphaComponent:0.6];
        return circleRenderer;
    }
    return nil;
}

@end






