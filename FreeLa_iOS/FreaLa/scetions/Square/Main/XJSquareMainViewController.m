
//  XJSquareMainViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/26.
//  Copyright © 2016年 FreeLa. All rights reserved.
//   button.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18]; 字体
////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`—'\____                             //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\—/''  |   |                         //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /—.—\  `. . ___                       //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=—='                                //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改         //
////////////////////////////////////////////////////////////////////

#import "XJSquareMainViewController.h"
#import "XJSearchViewController.h"
#import "YSLDraggableCardContainer.h"
#import "CardView.h"

#import "FLSaoMiaoViewController.h"
#import "XJSaoMaViewController.h"

#import "XJRecommendTopicListModel.h"
#import "XJRecommendNaviView.h"
#import "XJTableViewAllFreeVersionTwo.h"
#import "XJTableViewCouponVersionTwo.h"
#import "XJTableViewPersonVersionTwo.h"
#import "XJNaviTopImageModel.h"
//#import "UMMobClick/MobClick.h"
#import "XJFreelaUVManager.h"

#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"
#import "OneViewController.h"

#import "XJPickARGiftGifViewController.h"
#import "XJPickARGiftCustiomViewController.h"
#import "XJXJScanViewController.h"

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]
#define XJ_CARD_TOP      80
#define XJ_CARD_W      FLUISCREENBOUNDS.width - 20
#define XJ_CARD_H      XJ_CARD_W + 30
#define XJ_BOTTOM_H      (FLUISCREENBOUNDS.height - XJ_CARD_W + 50)
#define XJ_BTN_TAG      10908
@interface XJSquareMainViewController ()<YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource,UIAlertViewDelegate>
{
    NSInteger _xjRecommendTotal; //推荐列表一共有几个
    NSInteger _xjTopImageIndex;   //顶部图片的index
    
    BOOL _isClick;
    UIImageView *_imageView;
}
@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic, strong) NSMutableArray* xjRecommendTopicArr;  //cardview model
@property (nonatomic, strong) NSMutableArray* xjTopImgArr;  //cardview model
/**导航栏*/
@property (nonatomic , strong) XJRecommendNaviView* xjNaviView;
@end

@implementation XJSquareMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _xjTopImageIndex = 0;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.container];
    [self xjSetBottomBtnView];
    [self xjSetNviView];
    [FLTool xjSetJpushAlias];
    [self xjCheckVersion];
//    [self xj_uploadVersionType];//上传版本号
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjCheckVersion) name:@"xj_freela_new_version" object:nil];
    [self xjGetRecommendInfoWithCurrentPage:@1];
    [self xjGetNaviImageByid];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XJCLICKSQUARETABBAR) name:@"XJCLICKSQUARETABBAR" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XJCLICKFREECIRCLETABBAR) name:@"XJCLICKFREECIRCLETABBAR" object:nil];
    
    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.image = [UIImage imageNamed:@"LaunchImage"];
    [self.view addSubview:_imageView];
    [self.view bringSubviewToFront:_imageView];
    
    
    
    

}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex==1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/mian-fei-la-xin-xian-xuan/id1137815992?mt=8"]];
//    }
//}
// 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:YES];
//    [self xjCheckVersion];
  
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)xjCheckVersion {
    [FLNetTool xj_GetVersionSuccess:^(NSDictionary *data) {
        if ([data[@"success"] boolValue]) {
            NSString* versionNew = data[@"versionNum"];
            NSString* versionLocal = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            FL_Log(@"%@",versionLocal);
            if (![versionLocal isEqualToString:versionNew]) {
                NSString* str = data[@"isUpdate"];//是否强制更新
                if ([str isEqualToString:@"N"]) {
                   [self showWithBig:NO new:versionNew]; //小版本更新 //不需要强制更新
                } else {
                     [self showWithBig:YES new:versionNew];
                }
//                [self showWithLocal:versionLocal new:versionNew];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    
//    NSDictionary* parm = @{@"searchName":@"rock"};
//    [FLNetTool xj_testsss:parm success:^(NSDictionary *data) {
//        FL_Log(@"data====test====%@",data);
//    } failure:^(NSError *error) {
//        
//    }];
    
}
- (void)showWithLocal:(NSString*)local new:(NSString*)new {
    NSArray* loArr = [local componentsSeparatedByString:@"."];
    NSArray* newArr = [new componentsSeparatedByString:@"."];
    CGFloat loaint = [local floatValue];
    CGFloat newint = [new floatValue];
    float ss = newint-loaint;
    if (ss>0) {
        if (loArr.count>=1) {
            NSInteger loaFirst = [loArr[0] integerValue];
            NSInteger newFirst = [newArr[0] integerValue];
            if (newFirst>loaFirst) {
                //大版本更新
                [self showWithBig:YES new:new];
            } else {
               [self showWithBig:NO new:new]; //小版本更新
            }
        }
    }
}
- (void)showWithBig:(BOOL)isBig new:(NSString*)new{
    UIAlertController* alert;
    if (!isBig) {
        alert = [UIAlertController alertControllerWithTitle:@"版本更新" message:[NSString stringWithFormat:@"现在有新版本%@，点击确定下载",new] preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alert = [UIAlertController alertControllerWithTitle:@"版本更新" message:[NSString stringWithFormat:@"现在有重大版本更新%@,如果不更新会影响您的使用",new] preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction* sure  = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/mian-fei-la-xin-xian-xuan/id1137815992?mt=8"]];
    }];
    [alert addAction:sure];
    if (!isBig) {
        [alert addAction:cancle];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)xjSetNviView {
    self.xjNaviView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.xjNaviView.xjsaoBtn addTarget:self action:@selector(clickToSaoMiao) forControlEvents:UIControlEventTouchUpInside];
    [self.xjNaviView.xjSearchBtn addTarget:self action:@selector(clickToSearchTopic) forControlEvents:UIControlEventTouchUpInside];
    [self.xjNaviView.xjMiddleBtn addTarget:self action:@selector(clickToPushSafari) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.xjNaviView];
}

- (void)xjSetBottomBtnView {
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc]init];
        CGFloat size = self.view.frame.size.width / 4;
        view.frame = CGRectMake(size * i, XJ_CARD_H + 20 + XJ_CARD_TOP, size, size + 10);
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        //        view.backgroundColor = [UIColor blueColor];
  
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, size - 20, size - 20);
        button.clipsToBounds = YES;
        button.layer.cornerRadius = button.frame.size.width / 2;
        button.tag = i + XJ_BTN_TAG;
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        //label
        UILabel* xjLabel = [[UILabel alloc] init];
        xjLabel.frame = CGRectMake(0, size - 10, size, 20);
//        xjLabel.text = @[@"全免费",@"优惠券",@"个人分享",@"发布"][i];
        xjLabel.text = @[@"限时助力抢",@"排名助力抢",@"AR寻宝",@"发布"][i];
        xjLabel.textColor = @[[UIColor colorWithHexString:@"#92CF4F"],[UIColor colorWithHexString:@"#5DCCCD"],[UIColor colorWithHexString:@"#65CA9C"],[UIColor colorWithHexString:@"#e5432d"]][i];
        xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        xjLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:xjLabel];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"btn_allfree_green_test"] forState:UIControlStateNormal];
//            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:@"http://www.hibang.net/userinfo/user-info!creatCode.action"] forState:UIControlStateNormal];
        }
        if (i == 1) {
            [button setImage:[UIImage imageNamed:@"btn_coupon_blue_test"] forState:UIControlStateNormal];
        }
        if (i == 2) {
            [button setImage:[UIImage imageNamed:@"btn_personal_share_test"] forState:UIControlStateNormal];
        }
        if (i == 3) {
            button.frame = CGRectMake(15, 15, size-30, size - 30);
            button.layer.cornerRadius = button.frame.size.width / 2;
            [button setImage:[UIImage imageNamed:@"btn_issue_add_red"] forState:UIControlStateNormal];
        }
    }
    
}

- (NSMutableArray *)xjRecommendTopicArr {
    if (!_xjRecommendTopicArr) {
        _xjRecommendTopicArr = [NSMutableArray array];
    }
    return _xjRecommendTopicArr;
}
- (NSMutableArray *)xjTopImgArr {
    if (!_xjTopImgArr) {
        _xjTopImgArr = [NSMutableArray array];
    }
    return _xjTopImgArr;
}

- (YSLDraggableCardContainer *)container{
    if (!_container) {
        _container =[[YSLDraggableCardContainer alloc]init];
        _container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        _container.backgroundColor = [UIColor clearColor];
        _container.dataSource = self;
        _container.delegate = self;
        _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionUp | YSLDraggableDirectionDown;
    }
    return _container;
}
- (XJRecommendNaviView *)xjNaviView {
    if (!_xjNaviView) {
        _xjNaviView = [[XJRecommendNaviView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, StatusBar_NaviHeight)];
    }
    return _xjNaviView;
}
#pragma mark ---------- 网络请求
- (void)xjGetRecommendInfoWithCurrentPage:(NSNumber*)xjCurrentPage {
    [self.xjRecommendTopicArr removeAllObjects];
    [FLNetTool xjgetRcommendTopicListByCommentId:nil success:^(NSDictionary *data) {
        FL_Log(@"this is the test to weai new jielou=%@",data);
        _xjRecommendTotal = [data[@"total"] integerValue];
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSMutableArray* xjMu = @[].mutableCopy;
            xjMu = [XJRecommendTopicListModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            [self.xjRecommendTopicArr addObjectsFromArray:xjMu];
            [self.container reloadCardContainer];
            
        }
    } failure:^(NSError *error) {
        
    }];
    if(_xjRecommendTotal==0 ||!_xjRecommendTotal) {
        [self.container reloadCardContainer];
    }
}

- (void)xjGetNaviImageByid {
    [self.xjTopImgArr removeAllObjects];
    [FLNetTool xjgetNaviRecommendImageById:nil  success:^(NSDictionary *data) {
        FL_Log(@"th12iss iss t12she tesst t21o weai new jielou21212=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjTopImgArr = [XJNaviTopImageModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            //设置第一张 顶部导航栏的图
            [self xjSetNaviImageViewWithIndex:_xjTopImageIndex];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjSetNaviImageViewWithIndex:(NSInteger)xjIndex{
    
    if (self.xjTopImgArr.count > xjIndex) {
        XJNaviTopImageModel* xjModel = self.xjTopImgArr[xjIndex];
        self.xjNaviView.xjNaviImageStr = xjModel.filePath;
    }
}

#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index {
    
    if (self.xjRecommendTopicArr.count > index) {
        XJRecommendTopicListModel* xjModel = self.xjRecommendTopicArr[index];
        CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, XJ_CARD_TOP, XJ_CARD_W, XJ_CARD_H)];
        view.backgroundColor = [UIColor whiteColor];
        //        [view.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FLBaseUrl,xjModel.thumbnail]]];
        view.xjModel = xjModel;
        return view;
    }
    //首先检查网络状态
    if (![FLTool isNetworkEnabled]) {
        CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, XJ_CARD_TOP, XJ_CARD_W, XJ_CARD_H)];
        [view xjSetEmptyImage:[UIImage imageNamed:@"image_nointernet_default"]];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    } else {
        CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, XJ_CARD_TOP, XJ_CARD_W, XJ_CARD_H)];
        if(_xjRecommendTotal==0 ||!_xjRecommendTotal) {
            [view xjSetEmptyImage:[UIImage imageNamed:@"image_noinfo_default"]];
        } else {
            [view xjSetEmptyImage:[UIImage imageNamed:@"image_noinfo_default"]];
        }
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return  nil;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return self.xjRecommendTopicArr.count==0?1:self.xjRecommendTopicArr.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    if (draggableDirection == YSLDraggableDirectionDown) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    //当界面消失，替换顶部的图片
    _xjTopImageIndex +=1;
    if (_xjTopImageIndex==self.xjTopImgArr.count) {
        _xjTopImageIndex=0;
    }
    
    [self xjSetNaviImageViewWithIndex:_xjTopImageIndex];
    
    [self xj_getPvNumberIndex:index];
    [self xj_testTwoIndex:index];
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    CardView *view = (CardView *)draggableView;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        view.selectedView.backgroundColor = RGB(215, 104, 91);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    if (draggableDirection == YSLDraggableDirectionUp) {
        view.selectedView.backgroundColor = RGB(66, 172, 255);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    if (draggableDirection == YSLDraggableDirectionDown) {
        view.selectedView.backgroundColor = RGB(66, 172, 255);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container {
    NSLog(@"++ Did CompleteAll");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container reloadCardContainer];
    });
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView{
    FL_Log(@"++ Tap card index : %ld",(long)index);
    if (self.xjRecommendTopicArr.count > index) {
        XJRecommendTopicListModel* xjModel = self.xjRecommendTopicArr[index];
        FLFuckHtmlViewController* xjHTMLVC = [[FLFuckHtmlViewController alloc] init];
        xjHTMLVC.flFuckTopicId = [NSString stringWithFormat:@"%@",xjModel.topicId];
        [self.navigationController pushViewController:xjHTMLVC animated:YES];
    }
}


- (void)buttonTap:(UIButton *)button{
    NSInteger xjInt = button.tag;
    switch (xjInt) {
        case XJ_BTN_TAG: {
            XJTableViewAllFreeVersionTwo* xjAllFree = [[XJTableViewAllFreeVersionTwo alloc] initWithType:1];
            [self.navigationController pushViewController:xjAllFree animated:YES];
        }
            break;
        case XJ_BTN_TAG + 1: {
//            XJTableViewCouponVersionTwo* xjCoupon = [[XJTableViewCouponVersionTwo alloc] init];
            XJTableViewAllFreeVersionTwo* xjCoupon = [[XJTableViewAllFreeVersionTwo alloc] initWithType:2];
            [self.navigationController pushViewController:xjCoupon animated:YES];
        }
            break;
        case XJ_BTN_TAG + 2: {
//            XJTableViewPersonVersionTwo* xjPerson = [[XJTableViewPersonVersionTwo alloc] init];
            XJXJScanViewController* xjPerson = [[XJXJScanViewController alloc] init];
            [self.navigationController pushViewController:xjPerson animated:YES];
//            [self clickToSaoMiao];
        }
            break;
        case XJ_BTN_TAG + 3: {
            [self issueANewActivity];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark ---------- Issue A New Activity
- (void)issueANewActivity {
    
    NSString* xjBusState = [[NSUserDefaults standardUserDefaults] objectForKey:XJ_xjBusAccountState];
    if (![xjBusState isEqualToString:@"0"]&& !FLFLIsPersonalAccountType) {
        [FLTool showWith:@"账号异常"];
        return;
    }
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    NSString* xjPhone = [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION2_PHONE];
    if ((!xjPhone || xjPhone.length<11 || [xjPhone isEqualToString:@""]) && FLFLIsPersonalAccountType ) {
        [self xjalertMessageForBindPhone];
        return;
    }
    FL_Log(@"sdas =%ld",[FLUserInfoModel share].flStateInt);
    if ([FLUserInfoModel share].flStateInt==1 && FLFLIsPersonalAccountType) {
        [self xjAlertAccountError];
        return;
    }
    if (!FLFLIsPersonalAccountType&&[FLBusAccountInfoModel share].busStateInt==1) {
        [self xjAlertAccountError];
        return;
    }
    if (FLFLXJIsHasPhoneBlind) {
        FLIssueBaseInfoViewController* baseInfoVC = [[FLIssueBaseInfoViewController alloc] init];
        
        baseInfoVC.flissueInfoModel = [[FLIssueInfoModel alloc] init];
        [self.navigationController pushViewController:baseInfoVC animated:YES];
    } else {
        [self xjalertMessageForBindPhone];
    }
    [MobClick event:@"fl_click_issue"];
}

#pragma  mark  ---------------------------------- 点此绑定手机号
- (void)xjalertMessageForBindPhone {
    UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:@"操作失败" message:@"您还没有绑定手机号，不能进行此操作" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        FL_Log(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    UIAlertAction *flSureAction = [UIAlertAction actionWithTitle:@"马上去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        FL_Log(@"go to blind phone number now.");
        FLBlindWithThirdTableViewController * blindVC = [[FLBlindWithThirdTableViewController alloc] init];
        [weakSelf.navigationController pushViewController:blindVC animated:YES];
    }];
    [flAlertViewController addAction:flCancleAction];
    [flAlertViewController addAction:flSureAction];
    [self presentViewController:flAlertViewController animated:YES completion:nil];
}

- (void)xjAlertAccountError {
    UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:@"对不起" message:@"账户处于非正常状态，请联系管理员" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* xjSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [flAlertViewController addAction:xjSureAction];
    [self presentViewController:flAlertViewController animated:YES completion:nil];

}

#pragma mark  -------------------------- Actions

- (void)clickToSaoMiao {
    
//    FLSaoMiaoViewController* saomiaoVC = [[FLSaoMiaoViewController alloc] initWithNibName:@"FLSaoMiaoViewController" bundle:nil];
    
    XJSaoMaViewController* saomiaoVC = [[XJSaoMaViewController alloc] initWithType:1];
    
//    saomiaoVC.flComeType = 1;
    [self.navigationController pushViewController:saomiaoVC animated:YES];
}

- (void)clickToPushSafari {
    if (self.xjTopImgArr.count > _xjTopImageIndex) {
        XJNaviTopImageModel* xjModel = self.xjTopImgArr[_xjTopImageIndex];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",xjModel.url]]]) {
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",xjModel.url]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)clickToSearchTopic {
    
    XJSearchViewController* xjSearch = [[XJSearchViewController alloc] init];
    //    xjSearch.xjSearchSystemArr = self.xjSystemSearchTags.mutableCopy;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:xjSearch animated:YES];
    /*
    XJPickARGiftCustiomViewController* ss = [[XJPickARGiftCustiomViewController alloc] init];
//    XJPickARGiftGifViewController* ss = [[XJPickARGiftGifViewController alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:ss animated:YES];
    */
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    OneViewController *one = [[OneViewController alloc]init];
    one.myBlock = ^(BOOL isClick){
        _isClick = isClick;
        [_imageView removeFromSuperview];
        _imageView = nil;
    };
    if (_isClick == NO) {
//        CATransition * animation = [CATransition animation];
//        animation.duration = 0.5;    //  时间
//        animation.type = @"oglFlip";
//        animation.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:one animated:YES completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjPushTest:) name:@"THISISTHETESTPUSH" object:nil];
    //读取缓存
    
    //读取缓存
    NSString* xjPhone = XJ_USER_VALUE_PHONE;
    NSString* xjPwd = XJ_USER_VALUE_PWD;
    NSString* xxxcao = [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION_IS_THIRD];
   
    if (![FLTool isNetworkEnabled]) {
        [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:0];
    } else if ([XJFinalTool xjStringSafe:xxxcao]) {
        //         [[FLAppDelegate share] showHUDWithTitile:@"授权成功" view:self.view delay:1 offsetY:0];
        NSString* xjstr = XJ_USERID_WITHTYPE;
        if ([XJFinalTool xjStringSafe:xjstr]) {
            [self xj_umsinginWithId:[NSString stringWithFormat:@"%@",xjstr]];
        }
        NSString* xx = XJ_USER_SESSION;
        if ([XJFinalTool xjStringSafe:xx]) {
            [self xjRequestUserInfoWithToken:xx];
        }
    } else {
        if (!xjPwd || !xjPhone) {
            return;
        }
        [FLNetTool logInWithPhone:xjPhone password:xjPwd success:^(NSDictionary *dic) {
            FL_Log(@"dic in square login =%@",dic);
            if (dic) {
                if ([[dic objectForKey:FL_NET_KEY] boolValue])  {
                    FL_Log(@"用户名密码 没什么问题");
                    NSString* xjStr = [dic objectForKey:FL_NET_SESSIONID];
                    NSString* nimaUsierid = dic[@"userid"];
                    [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjStr ? xjStr :@"" key:FL_NET_SESSIONID];
                    [self xjRequestUserInfoWithToken:xjStr];
                    [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPhone ? xjPhone :@"" key:XJ_VERSION2_PHONE]; //手机号
                    [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPwd ? xjPwd :@"" key:XJ_VERSION2_PWD]; //密码
                     [XJFinalTool xjSaveUserInfoInUserdefaultsValue:nimaUsierid ? nimaUsierid :@"" key:FL_USERDEFAULTS_USERID_KEY]; //userid
                }  else {
                    [[FLAppDelegate share] showHUDWithTitile:@"用户名密码错误，请重新登录" view:self.view delay:1 offsetY:0];
                    NSLog(@"dddddddddddddddddddddddd%@%@",xjPhone,xjPwd);
                    [self performSelector:@selector(logInAgain) withObject:self afterDelay:2];
                }
            }
            
        } failure:^(NSError *error)   {
            NSLog(@"i'm wrong =====  %@ ----------%@         。。。。。。。。。%ld",error.description,error.debugDescription,error.code);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@", [FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        }];
    }
    

    
}
- (void)logInAgain {
    FLLogIn_RegisterViewController* logInVC = [[FLLogIn_RegisterViewController alloc]init];
    [self presentViewController:logInVC animated:YES completion:nil];
}
- (void)XJCLICKSQUARETABBAR {
    [self xjGetRecommendInfoWithCurrentPage:@1];
    [self xjGetNaviImageByid];
    
    [XJFreelaUVManager xjAddUVStr:@"ddddsadsadasdsadadsadsa" SearchId:@"111"];
    [XJFreelaUVManager xjSearchUVInLocationBySearchId:@"111"];
}
- (void)XJCLICKFREECIRCLETABBAR {
    BOOL nimabi = [XJFinalTool xj_is_phoneNumberBlind];
    if(!nimabi) {
        [self xj_alertNumberBind];
    }
}

- (void)xjRequestUserInfoWithToken:(NSString*)xjToken {
    NSDictionary* parm  = @{@"token":xjToken,
                            @"accountType":@"per",
                            };
    FL_Log(@"see info 新 in mine :sesdddssionId = %@  parm = %@",xjToken,parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result of login =%@",data);
        if (data) {
            NSString* xjStr = [NSString stringWithFormat:@"%@",data[@"userId"]];
            NSString* xjPhone=[NSString stringWithFormat:@"%@",data[@"phone"]];
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjStr key:FL_USERDEFAULTS_USERID_KEY];
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPhone key:XJ_VERSION2_PHONE];
            
            [[XJUserAccountTool share] xj_saveUserName:data[@"nickname"]];
            [[XJUserAccountTool share] xj_saveUserAvatar:data[@"avatar"]];
            [[XJUserAccountTool share] xj_saveUserState:[NSString stringWithFormat:@"%@",data[@"state"]]];
            
            //友盟账号统计
            [self xj_umsinginWithId:xjStr?xjStr:@""];
//            [self xj_uploadVersionType];//上传版本号
            [self xj_uploadVersionNumber];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)xj_uploadVersionType {
//    //保存一个UUID字符串到钥匙串：
//    CFUUIDRef uuid = CFUUIDCreate(NULL);assert(uuid != NULL);CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
//    [SAMKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr]
//                 forService:@"com.yourapp.yourcompany"account:@"user"];
//    
//    //从钥匙串读取UUID：
//    NSString *retrieveuuid = [SAMKeychain passwordForService:@"com.yourapp.yourcompany"account:@"user"];
    FL_Log(@".....此方法作为 获得设备唯一标示备用");
    

}
- (void)xj_umsinginWithId:(NSString*)xjId  {
    if ([XJFinalTool xjStringSafe:[[XJUserAccountTool share] xj_userdefault_thirdloginInfo]]) {
        NSString* xx = [[XJUserAccountTool share] xj_userdefault_thirdloginInfo];
        [MobClick profileSignInWithPUID:xjId?xjId:@"" provider:xx];
    } else {
        [MobClick profileSignInWithPUID:xjId?xjId:@""];
    }
}
#pragma mark ---------------- 新增的接口
- (void)xj_getPvNumberIndex:(NSInteger)index {
    if (self.xjRecommendTopicArr.count > index) {
       XJRecommendTopicListModel* model = self.xjRecommendTopicArr[index];
        NSDictionary* parma = @{@"advertId":model.advertId};
        [FLNetTool xj_updatePvWithparma:parma success:^(NSDictionary *data) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)xj_testTwoIndex:(NSInteger)index {
    
    if (self.xjRecommendTopicArr.count > index) {
        XJRecommendTopicListModel* model = self.xjRecommendTopicArr[index];
        NSDictionary* parma = @{@"advertId":model.advertId};
        [FLNetTool xj_updateLinkNumWithparma:parma success:^(NSDictionary *data) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end







