//
//  FLChooseMapViewController.m
//  FreeLa
//
//  Created by Leon on 15/12/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLChooseMapViewController.h"


#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22

@interface FLChooseMapViewController ()<AMapSearchDelegate,MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
//    MAMapView* self.mapView;
//    AMapSearchAPI* _search;
    MAPointAnnotation * _flselectedAnnotation;
    
    CLLocation* _currentLocation;
    UIButton* _locationButton;
//    UILongPressGestureRecognizer* _longPressGr;
    
    UITableView *_tableView;
    NSArray *_pois;
    
    NSMutableArray *_annotations;
    UITextField* _searchTextfield;
    
    AMapPOI* _makeSurePoi;
    BOOL _isMapOn; //有没有定位
}

/**naviBar*/
@property (nonatomic , strong)UIView* naviBarView;
/**searchBar*/
@property (nonatomic , strong)UISearchBar* flSearchBar;
/**保存*/
@property (nonatomic , strong)UIButton* flSureBtn;
//
@property (nonatomic , strong) MAMapView* mapView;
/**search*/
@property (nonatomic , strong) AMapSearchAPI* search;
@end

@implementation FLChooseMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isMapOn = YES;
    [self initControls];
    [self hehehe];
    [self initLongPressGr];
    [self initTableView];
    [self initAttributes];
    [self initNaviBarView];
//    [self testCenter];//test center
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setHidden: YES];
}

- (MAMapView *)mapView
{
    if (!_mapView) {
        [self initMapView];
    }
    return _mapView;
}
- (AMapSearchAPI *)search
{
    if (!_search) {
        [self hehehe];
    }
    return _search;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//传进来的地点
- (void)setFlAddressDic:(NSDictionary *)flAddressDic
{
//    [self initMapView];
    _flAddressDic = flAddressDic;
    
    
    double lat = [_flAddressDic[@"latitude"] doubleValue];
    double longt = [_flAddressDic[@"longitude"] doubleValue];
    NSString* flaeddress  = _flAddressDic[@"address"];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = longt;
    
    if (longt&&lat) {
        FL_Log(@"这个有地址，按地址查询");
        [self searchAddressForLatAndLong:coordinate]; //按经纬度定位地址
        [self setAnAnnotationWithLocation:coordinate title:flaeddress];
    } else if (flaeddress) {
        FL_Log(@"这个地方没地址，按关键字==%@",flaeddress);
        [self searchActionWithKeyWords:flaeddress city:@"beijing"];
    } else {
         FL_Log(@"do nothing");
    }
    
//    [self.mapView setCenter:locationPoint];

    
}

- (void)searchAddressForLatAndLong:(CLLocationCoordinate2D)xjlocation
{
    [self.mapView setCenterCoordinate: xjlocation animated:YES];
    [self.mapView setZoomLevel:1000 animated:YES];
    
}

- (void)setAnAnnotationWithLocation:(CLLocationCoordinate2D)xjlocation title:(NSString*)xjtitle
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.coordinate = xjlocation;
    annotation.title = xjtitle;
    annotation.subtitle = [NSString stringWithFormat:@"%@%@",@"sub-----",xjtitle];
    
    [self.mapView addAnnotation:annotation];
}

- (void)initMapView
{
    [AMapServices sharedServices].apiKey = FL_GAODE_API_KEY;
    self.mapView = self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, StatusBar_NaviHeight, CGRectGetWidth(self.view.bounds), FLUISCREENBOUNDS.height  * 0.5)];
    self.mapView.delegate = self;
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 22);
    self.mapView.scaleOrigin = CGPointMake(self.mapView.scaleOrigin.x, 22);
    
    [self.view addSubview:self.mapView];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = 1;
    
    _flselectedAnnotation = [[MAPointAnnotation alloc] init];
    [self.mapView addAnnotation:_flselectedAnnotation];
    
}

- (void)initControls
{
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(20, CGRectGetHeight(self.mapView.bounds) - 80, 40, 40);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    _locationButton.backgroundColor = [UIColor whiteColor];
    _locationButton.layer.cornerRadius = 5;
    
    [_locationButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    
    [self.mapView addSubview:_locationButton];
    
    //
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame = CGRectMake(80, CGRectGetHeight(self.mapView.bounds) - 80, 40, 40);
    searchButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
//    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.mapView addSubview:searchButton];
    
}

- (void)hehehe
{
    //初始化检索对象
    [AMapServices sharedServices].apiKey = FL_GAODE_API_KEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    _search.timeout = 1; //超时
 
}

- (void)initLongPressGr
{
    //长按屏幕，添加大头针
    UILongPressGestureRecognizer *Lpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(myDestination:)];
    Lpress.delegate = self;
    Lpress.minimumPressDuration = 1.0;//1.0秒响应方法
    Lpress.allowableMovement = 50.0;
    [self.mapView addGestureRecognizer:Lpress];
    
    
}
#pragma mark 长安手势
- (void)myDestination:(UILongPressGestureRecognizer*)gestureRecognizer
{
    FL_Log(@"this is so long long ");
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        return;
    }
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self creatAnnotion:touchMapCoordinate];
}

- (void)initAttributes
{
    _annotations = [NSMutableArray array];
    _pois = nil;
}

- (void)initTableView
{
//    CGFloat halfHeight = CGRectGetHeight(self.view.bounds) * 0.5;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mapView.height + StatusBar_NaviHeight, CGRectGetWidth(self.view.bounds), FLUISCREENBOUNDS.height * 0.5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)initNaviBarView
{
//    self.naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 64)];
//    self.naviBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
//    [self.view addSubview:self.naviBarView];
//    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 64)];
//    [button setTitle:@"返回" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(goBackToIssue) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
     self.flSearchBar = [[UISearchBar alloc ]init];
    self.flSearchBar.placeholder = @"搜索";
    self.flSearchBar.backgroundColor = [UIColor whiteColor];
    self.flSearchBar.tintColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK); //光标
    self.flSearchBar.barTintColor = [UIColor whiteColor];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    self.flSearchBar.layer.borderWidth = 1;
    [self.flSearchBar.layer setBorderColor:colorref];
    self.flSearchBar.delegate  =self ;
    self.flSearchBar.frame = CGRectMake(60, 25, FLUISCREENBOUNDS.width - 110, 30);
    
    //保存
    self.flSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flSureBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.flSureBtn.frame = CGRectMake(self.flSearchBar.frame.origin.x + self.flSearchBar.frame.size.width, 25, 50, 30);
    [self.flSureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.flSureBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [self.flSureBtn addTarget:self action:@selector(saveThisString) forControlEvents:UIControlEventTouchUpInside];
   
    
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, StatusBar_NaviHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 50, 44);
    btn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gogogoback) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
//    self.flSearchBar.center = self.naviBarView.center;
    [topView addSubview:self.flSearchBar];
    [topView addSubview:self.flSureBtn];
}

- (void)saveThisString
{
    FL_Log(@"map vc click to save this string");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确定位置"
                                                    message:self.flSearchBar.text
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",
                          nil];
    _isMapOn = NO;
    [alert show];
}

- (void)gogogoback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------

- (void)goBackToIssue
{
    FL_Log(@"dimis");
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    // 选中定位annotation的时候进行逆地理编码查询
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        [self reGeoAction];
    }
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    // 修改定位按钮状态
    if (mode == MAUserTrackingModeNone)
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    }
    else
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }
}
#pragma mark - Helpers

- (void)locateAction
{
    if (self.mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}

- (void)reGeoAction
{
    if (_currentLocation)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        
        [self.search AMapReGoecodeSearch:request];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response :%@", response);
    
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    {
        // 直辖市的city为空，取province
        title = response.regeocode.addressComponent.province;
    }
    
    // 更新我的位置title
    self.mapView.userLocation.title = title;
    self.mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    self.flSearchBar.text=response.regeocode.formattedAddress;
}
#pragma mark 关键字搜索
- (void)searchActionWithKeyWords:(NSString*)keyWords city:(NSString*)city
{
    if (self.mapView) {
        AMapPOIKeywordsSearchRequest* request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        //    request.types =
        request.keywords = keyWords;
        request.city = city;
        [self.search AMapPOIKeywordsSearch:request];
    }
//    if (_currentLocation == nil || self.search == nil)
//    {
//        NSLog(@"search failed");
//        return;
//    }
//    AMapPOIIDSearchRequest * request = [[AMapPOIIDSearchRequest alloc] init];

    
//    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
//    request.searchType = AMapSearchType_PlaceAround;
//    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
//    
//    request.keywords = @"餐饮";
//    
   
}

#pragma mark location搜索
- (void)searchActionWithLocation:(AMapGeoPoint*)fllocation
{
    if (_currentLocation == nil || _search == nil) {
        NSLog(@"search failed in location");
        return;
    }
    AMapPOIAroundSearchRequest* request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = fllocation;
    request.radius = 3000;  //搜索半径
    
    
    //    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    //    request.searchType = AMapSearchType_PlaceAround;
    //    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    //
    //    request.keywords = @"餐饮";
    //
    [_search AMapPOIAroundSearch:request];
}

#pragma mark ----searchdeleegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    FL_Log(@"request :%@",request);
     FL_Log(@"response :%@",response);
    if (response.pois.count > 0)
    {
        _pois = response.pois;
        
        [_tableView reloadData];
        // 清空标注
        [self.mapView removeAnnotations:_annotations];
        [_annotations removeAllObjects];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
//    FL_Log(@"userlocation:%@",userLocation.location);
    _currentLocation = [userLocation.location copy];
}



#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    AMapPOI *poi = _pois[indexPath.row];
    
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pois.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isMapOn = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 为点击的poi点添加标注
    _makeSurePoi= _pois[indexPath.row];
    
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(_makeSurePoi.location.latitude, _makeSurePoi.location.longitude);
    annotation.title = _makeSurePoi.name;
    annotation.subtitle = _makeSurePoi.address;
    
    [self.mapView addAnnotation:annotation];
    [_annotations addObject:annotation];
    
    FL_Log(@"经纬度 =%f    =  %f",_makeSurePoi.location.latitude,_makeSurePoi.location.longitude);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",annotation.title]
                                                    message:[NSString stringWithFormat:@"%@",annotation.subtitle]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",
                                                            nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        FL_Log(@"sure");
        if (_isMapOn) {
            
            [self.delegate FLChooseMapViewController:self didInputReturnLocation:[NSString stringWithFormat:@"%f",_makeSurePoi.location.longitude] Location:[NSString stringWithFormat:@"%f",_makeSurePoi.location.latitude] title:_makeSurePoi.name subtitle:_makeSurePoi.address];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
           NSString*wd= [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.latitude];
            NSString*jd=[NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.longitude];
            [self.delegate FLChooseMapViewController:self didInputReturnLocation:jd Location:wd title:self.flSearchBar.text subtitle:@""];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
}

#pragma mark ------ search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    FL_Log(@"searchbar text = %@",searchBar.text);
//    [self.view endEditing:YES];
    [searchBar resignFirstResponder];
    [self searchActionWithKeyWords:searchBar.text city:@"beijing"];
}

- (void)testCenter
{
    CGFloat xx = 39.789422;
    CGFloat yy = 116.326557;
    [self.mapView setCenterCoordinate: CLLocationCoordinate2DMake(xx, yy) animated:YES];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];

    annotation.coordinate = CLLocationCoordinate2DMake(xx, yy);
    
    annotation.title = @"ghg";
    annotation.subtitle =@"hhh";
    [self.mapView addAnnotation:annotation];
    [self.mapView setZoomLevel:1000 animated:YES];
    
    
}

#pragma mark 解决长按手势不能响应的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark add annotation
- (void)creatAnnotion:(CLLocationCoordinate2D)fllocation
{
//    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [self.mapView removeAnnotation:_flselectedAnnotation];
    _flselectedAnnotation.coordinate = CLLocationCoordinate2DMake(fllocation.latitude, fllocation.longitude);
    [self.mapView addAnnotation:_flselectedAnnotation];
//    [_annotations addObject:annotation];
    AMapGeoPoint* point = [[AMapGeoPoint alloc] init];
    point.latitude = fllocation.latitude;
    point.longitude = fllocation.longitude;
    [self searchActionWithLocation: point];
    
}

#pragma mark 错误回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    FL_Log(@"this is error for request=%@",error);
    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedDescriptionKey]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
    
}

@end



























