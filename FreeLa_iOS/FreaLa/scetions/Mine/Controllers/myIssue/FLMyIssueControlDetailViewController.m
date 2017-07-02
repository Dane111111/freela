//
//  FLMyIssueControlDetailViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueControlDetailViewController.h"
#import "FLMyIssueActivityControlView.h"
#import "FLSaoMiaoViewController.h"
#import "XJOnlySaoMiaoViewController.h"
#import "FLMineTools.h"
#import "XJFreelaUVManager.h"
#define FL_VC_Bottom_Top_Margin 5
#define FL_VC_Bottom_image_H  25
#define FL_Btn_baseTag        138


@interface FLMyIssueControlDetailViewController ()<FLGrayBaseViewDelegate,UMSocialUIDelegate>
{
    FLMyIssueActivityControlView* _flMyIssueActivityControlView;
    UIButton* _xjGackTopicBtn;//撤回按钮
    UILabel* _xjIssueAgainLabel; //再发一条显示内容需要更改
}

/**下方三个控件的view*/
@property (nonatomic , strong) UIView* flBottomView;
/**再发一个按钮*/
@property (nonatomic , strong) UIButton* flIssueAgainBtn;

/**二维码浮层*/
@property (nonatomic , strong) FLGrayBaseView* flGrayBaseView;

/**二维码的链接，也是转发链接*/
@property (nonatomic , strong) NSString* xjRelayContentStr;
/**view*/
@property (nonatomic , strong) FLMyIssueActivityControlView*  flMyIssueActivityControlView;
@end

@implementation FLMyIssueControlDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _flissueInfoModel = [[FLIssueInfoModel alloc] init];
    //    _flMyIssueActivityControlView = [[FLMyIssueActivityControlView alloc] initWithModel:self.flmyIssueInMineModel];
    [self.flMyIssueActivityControlView.flCheckDetailBtn addTarget:self action:@selector(goToDetailPageWithHTML) forControlEvents:UIControlEventTouchUpInside];
    [self setUpUIInMyIssueActivityControlView];
    [self getIssueInfoDataForAgainInACVCWithTopicId: _xjTioicId? _xjTioicId:nil];
    
    UIScrollView* xjScrollview = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:xjScrollview];
    xjScrollview.contentSize = CGSizeMake(FLUISCREENBOUNDS.width, _flMyIssueActivityControlView.frame.size.height + 100);
    [xjScrollview addSubview: _flMyIssueActivityControlView];
    
    //    [self.view addSubview:_flMyIssueActivityControlView];
    
    NSString* xjtopicIdStr = self.flmyIssueInMineModel.flMineIssueTopicIdStr;
    _xjRelayContentStr = [NSString stringWithFormat:@"%@/transpond/transpond!isTranspond.action?topic.topicId=%@",FLBaseUrl,xjtopicIdStr];
    _flMyIssueActivityControlView.flScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjRefreshNum)];
    
    
    [_flMyIssueActivityControlView.xjOffBtn addTarget:self action:@selector(xjOffShelf) forControlEvents:UIControlEventTouchUpInside];
    
//    [self xjRefreshNum];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        [self xjRefreshNum];

}
- (FLMyIssueActivityControlView *)flMyIssueActivityControlView{
    if (!_flMyIssueActivityControlView) {
        _flMyIssueActivityControlView = [[FLMyIssueActivityControlView alloc] initWithModel:nil];
    }
    return _flMyIssueActivityControlView;
}

- (void)xjOffShelf {
    
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"topic.topicId":self.flmyIssueInMineModel.flMineIssueTopicIdStr,
                           @"topic.state":@"2"};
    [FLNetTool flLeftTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is the result of off the shelf data =%@",dic);
        if ([dic[FL_NET_KEY_NEW] boolValue]) {
            _flMyIssueActivityControlView.xjOffBtn.hidden = YES;
            self.flmyIssueInMineModel.flStateInt = 2;
        }
    } failure:^(NSError *error) {
        
    }];
}

-  (FLMyIssueInMineModel *)flmyIssueInMineModel {
    if (!_flmyIssueInMineModel) {
        _flmyIssueInMineModel = [[FLMyIssueInMineModel alloc] init];
    }
    return _flmyIssueInMineModel;
}

- (void)xjRefreshNum{
    [FLFinalNetTool flNewPVUVlWithTopicId:_xjTioicId success:^(NSDictionary *data) {
        FL_Log(@"data in html with tjs listwith type 0 =%@",data);
        if([data[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* dd = data[FL_NET_DATA_KEY];
            self.flmyIssueInMineModel.flMineIssueNumbersReadStr = [dd[@"pv"] isEqualToString:@""]? @"0":dd[@"pv"];
            self.flmyIssueInMineModel.flMineIssueNumbersRelayStr = [dd[@"transformNum"] isEqualToString:@""]? @"0":dd[@"transformNum"];
            self.flmyIssueInMineModel.flMineIssueNumbersAlreadyPickStr = [dd[@"receiveNum"] isEqualToString:@""]? @"0":dd[@"receiveNum"];//dd[@"receiveNum"] ? dd[@"receiveNum"] :@"0";
            self.flmyIssueInMineModel.xjPartInNumber = [dd[@"partNum"] integerValue];
            CGFloat ff = [self.flmyIssueInMineModel.flMineIssueNumbersAlreadyPickStr floatValue] / [self.flmyIssueInMineModel.flMineIssueNumbersTotalPickStr floatValue];
            self.flmyIssueInMineModel.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
            self.flmyIssueInMineModel.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
            
            //            _flMyIssueActivityControlView.flMyIssueInMineModel = self.flmyIssueInMineModel;
        }
        if (self.flmyIssueInMineModel.flStateInt == 1 &&  !self.flmyIssueInMineModel.xjPartInNumber) {
            _flMyIssueActivityControlView.xjOffBtn.hidden = NO;
        } else {
            _flMyIssueActivityControlView.xjOffBtn.hidden = YES;
        }
        [self xjEndRefresh];
    } failure:^(NSError *error) {
        [self xjEndRefresh];
    }];
    [self getIssueInfoDataWithTopicId:_xjTioicId];
}

- (void)xjEndRefresh {
    [_flMyIssueActivityControlView.flScrollView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)getDetailsImageInTopicControlVCWithTopicId:(NSString*)xjTopicId
{
    NSMutableArray* muArr = [NSMutableArray array];
    NSMutableArray* nameArr = [NSMutableArray array];
    if (!xjTopicId) {
        //        xjTopicId = @"";
    }
    [FLFinalNetTool flNewgetDetailImageStrInHTMLWithTopicId:xjTopicId ? xjTopicId:@""
                                                    success:^(NSDictionary *data) {
                                                        FL_Log(@"new tool to request detwail images =%@",data);
                                                        if ([data[FL_NET_KEY_NEW] boolValue]) {
                                                            NSArray* array = data[FL_NET_DATA_KEY];
                                                            array = [FLHelpDetailImageModels mj_objectArrayWithKeyValuesArray:array];
                                                            
                                                            for (NSInteger i = 0;i  < array.count; i++) {
                                                                FLHelpDetailImageModels* model = array[i];
                                                                if ([model.businesstype integerValue] == 2) {
                                                                    [muArr addObject:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.url isSite:NO]]];
                                                                    [nameArr addObject: model.filename];
                                                                    if (muArr.count >4) {
                                                                        [muArr removeLastObject];
                                                                        [nameArr addObject: model.filename];
                                                                    }
                                                                } else if ([model.businesstype integerValue] == 1) {
                                                                    _flissueInfoModel.flactivitytopicThumbnailStr = [NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.url isSite:NO]];
                                                                    _flissueInfoModel.flactivitytopicThumbnailFileName = model.filename;
                                                                }
                                                            }
                                                            //                for (FLHelpDetailImageModels* model in array) {
                                                            //                    if ([model.businesstype integerValue] == 2) {
                                                            //                        [muArr addObject:[NSString stringWithFormat:@"%@%@",FLBaseUrl,model.url]];
                                                            //                        [nameArr addObject: model.filename];
                                                            //                    } else if ([model.businesstype integerValue] == 1) {
                                                            //                        _flissueInfoModel.flactivitytopicThumbnailStr = [NSString stringWithFormat:@"%@%@",FLBaseUrl,model.url];
                                                            //                        _flissueInfoModel.flactivitytopicThumbnailFileName = model.filename;
                                                            //                    }
                                                            //                }
                                                            if(muArr.count==0){
                                                                for (FLHelpDetailImageModels* model in array) {
                                                                    [muArr addObject:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.url isSite:NO]]];
                                                                    
                                                                }
                                                            }
                                                            _flMyIssueActivityControlView.imagesURLStrings = muArr;
                                                            _flissueInfoModel.flactivitytopicDetailchartArr = muArr.mutableCopy;
                                                            NSArray* topicDetailFileNameArr = nameArr.mutableCopy;
                                                            _flissueInfoModel.flactivitytopicDetailchartFileName = [FLTool  returnStrWithArr:topicDetailFileNameArr];
                                                            
                                                            FL_Log(@"===============ss=====================%@,=====%@ ======%@======%@",_flissueInfoModel.flactivitytopicDetailchartArr,_flissueInfoModel.flactivitytopicThumbnailStr,_flissueInfoModel.flactivitytopicThumbnailFileName,_flissueInfoModel.flactivitytopicDetailchartFileName);
                                                        }
                                                        
                                                    } failure:^(NSError *error) {
                                                        
                                                    }];
}

#pragma mark ----- bottomUI
- (void)setUpUIInMyIssueActivityControlView
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //底部控件
    CGRect frame =_flMyIssueActivityControlView.frame;
    frame.origin.y = FLUISCREENBOUNDS.height - TabBarHeight - StatusBar_NaviHeight - FL_TopColumnView_Height_S;
    frame.size.width = FLUISCREENBOUNDS.width;
    frame.size.height = TabBarHeight;
    self.flBottomView = [[UIView alloc] initWithFrame:frame];
    self.flBottomView.backgroundColor = [UIColor whiteColor];
    [_flMyIssueActivityControlView addSubview:self.flBottomView];
    //细线
    UIView* middleGrayFirstView = [[UIView alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width / 3    , 0, 1, TabBarHeight)];
    UIView* middleGraySecondView =[[UIView alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width * 2 / 3, 0, 1, TabBarHeight)];
    middleGrayFirstView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    middleGraySecondView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    [self.flBottomView addSubview:middleGraySecondView];
    [self.flBottomView addSubview:middleGrayFirstView];
    //button iamgeview label  3个循环添加
    NSArray* nameArray = @[@"验票",@"查看并转发二维码",@"再发一条"];
    NSArray* imageArray = @[@"iconfont_saomiao_gray",@"iconfont_erweima",@"iconfont_fabu_gray"];
    for (NSInteger i = 0; i < nameArray.count; i ++)
    {
        //btn
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( i * (FLUISCREENBOUNDS.width / 3), 0, FLUISCREENBOUNDS.width / 3, TabBarHeight);
        btn.tag = FL_Btn_baseTag + i;
        [btn addTarget:self action:@selector(clickBottomBtnWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [self.flBottomView addSubview:btn];
        //image
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (i * (FLUISCREENBOUNDS.width / 3)) , FL_VC_Bottom_Top_Margin, FL_VC_Bottom_image_H, FL_VC_Bottom_image_H)];
        imageView.centerX  =  (i * (FLUISCREENBOUNDS.width / 3))+ ((FLUISCREENBOUNDS.width / 3) / 2);
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [self.flBottomView addSubview:imageView];
        //title
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((i * (FLUISCREENBOUNDS.width / 3)), FL_VC_Bottom_image_H + FL_VC_Bottom_Top_Margin,FLUISCREENBOUNDS.width / 3 , TabBarHeight -FL_VC_Bottom_image_H - FL_VC_Bottom_Top_Margin)];
        label.text = nameArray[i];
        label.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 2) {
            //            [btn setImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forState:UIControlStateNormal];
            btn.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
            label.textColor = [UIColor whiteColor];
            _xjIssueAgainLabel = label;
        }
        label.centerX = imageView.centerX;
        [self.flBottomView addSubview:label];
    }
    
}

- (void)clickBottomBtnWithSender:(UIButton*)sender
{
    if (sender.tag == FL_Btn_baseTag)
    {
        FL_Log(@"first = btn");
//        FLSaoMiaoViewController* saomiaoView = [[FLSaoMiaoViewController alloc] initWithNibName:@"FLSaoMiaoViewController" bundle:nil];
        XJOnlySaoMiaoViewController* saomiaoView = [[XJOnlySaoMiaoViewController alloc] initWithType:2];
        saomiaoView.flmodel = _flmyIssueInMineModel;
//        saomiaoView.flComeType = 2;
        [self.navigationController pushViewController:saomiaoView animated:YES];
        
        //测试撤销 活动接口
        //        NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
        //                               @"topic.topicId":_flIssueInfoModelDic[@"topicId"],
        //                               @"topic.state":@"2"};
        //        [FLNetTool flLeftTopicBackByParm:parm success:^(NSDictionary *dic) {
        //            FL_Log(@"this is my test dic for left  topic =%@",dic);
        //        } failure:^(NSError *error) {
        //
        //        }];
        
    } else if (sender.tag == FL_Btn_baseTag + 1) {
        FL_Log(@"erweima");
        [self creatErWeiMaAndShow];
        
    } else if (sender.tag == FL_Btn_baseTag + 2) {
        FL_Log(@"third = btn == issue again");
        FLIssueBaseInfoViewController* baseIssueVC = [[FLIssueBaseInfoViewController alloc] init];
        FLFLXJIssueWithDataOrNot = 1; //全局变量，1为数据回填
        baseIssueVC.flissueInfoModel = _flissueInfoModel;
        if (_flissueInfoModel.hideGift==1) {
             //藏宝活动，禁止再发一条
            [FLTool showWith:@"藏宝活动暂不支持此功能"];
            return;
        }
        if (_flissueInfoModel) {
            [self.navigationController pushViewController:baseIssueVC animated:YES];
        }
    }
    
}
#pragma mark -----------用于数据回填的接口
- (void)getIssueInfoDataForAgainInACVCWithTopicId:(NSString*)xjTopicId
{
    if (!xjTopicId) {
        return;
    }
    NSDictionary* parm = @{@"topic.topicId": xjTopicId};
    [FLNetTool getTopicForIssueAgainByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data for test again issue =%@",data);
        
        _flissueInfoModel =  [FLSquareTools retutnIssueInfoModelWithDic:data WithModel:_flissueInfoModel];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ------ Btn Actions
- (void)goToDetailPageWithHTML {
    FL_Log(@"从这里点击进入html 界面");
    FLFuckHtmlViewController* htmlVC = [[FLFuckHtmlViewController alloc] init];
    htmlVC.flFuckTopicId = _flmyIssueInMineModel.flMineIssueTopicIdStr;
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark  -------- erweima
- (void)creatErWeiMaAndShow {
    self.flGrayBaseView = [[FLGrayBaseView alloc] initWithInfo:[NSString stringWithFormat:@"%@",_flmyIssueInMineModel.flMineIssueTopicIdStr] delegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.flGrayBaseView];
}


#pragma mark grayView delegate

- (void)flGrayViewRelayTopicAvtivityToFriendsWithImage:(UIImage *)imageUse
{
    [_flGrayBaseView removeFromSuperview];
    FL_Log(@"relay erweima ");
    //集成share SDK
    [self showMenu];
    [self flRelayTopicWithNoTypeInHTMLVC];//插入一条转发记录
}

#pragma mark ---------------- 插入转发记录
- (void)flRelayTopicWithNoTypeInHTMLVC {
    NSDictionary* parm = @{@"topic.userType":XJ_USERTYPE_WITHTYPE,
                           @"topic.userId": XJ_USERID_WITHTYPE,
                           @"topic.topicId":self.flmyIssueInMineModel.flMineIssueTopicIdStr,
                           @"topic.topicType":XJ_USERTYPE_WITHTYPE,
                           @"token":XJ_USER_SESSION};
    [FLNetTool flPubTopicShareFriendAnyTypeByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is to sahre test =%@",data);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark --- shareDelegate
//分享得回调
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    FL_Log(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        FL_Log(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
    }
}

- (void)flGrayViewSaveErWeiMaInLocationWithImage:(UIImage*)iamgeUse
{
    FL_Log(@"save erweima ");
    UIImageWriteToSavedPhotosAlbum(iamgeUse, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//保存到本地的回调方法
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    [_flGrayBaseView removeFromSuperview];
    if (!error) {
        FL_Log(@"picture saved with no error.in my issue");
        [[FLAppDelegate share] showHUDWithTitile:@"保存成功" view:self.navigationController.view delay:1 offsetY:0];
    }
    else
    {
        FL_Log(@"error occured while saving the picture%@", error);
        
    }
    
}

#pragma mark popMenu
- (void)showMenu
{
    
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    NSArray* nameArray = @[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"新浪",@"免费啦"];
    NSArray* imageArray = @[@"share_wechat",@"share_friend",@"share_qq",@"share_qzone",@"share_sina",@"share_mianfeila"];
    NSArray* typeArray = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,@"freela"];
    for (NSInteger i = 0; i < nameArray.count; i ++ )
    {
        [menuView addMenuItemWithTitle:nameArray[i] andIcon:[UIImage imageNamed:imageArray[i]] andSelectedBlock:^{
            FL_Log(@"Phot3o selected= %ld",i);
            [self shareToWithType:typeArray[i]];
        }];
    }
    
    [menuView show];
}

- (void)shareToWithType:(NSString*)type
{
    if ([type isEqualToString:@"freela"]) {
        
    } else {
        NSInteger xjType ;
        if ([type isEqualToString:@"qq"]) {
            xjType = 1;
        } else if ([type isEqualToString:@"qzone"]) {
            xjType = 2;
        } else if ([type isEqualToString:@"wxsession"]) {
            xjType = 3;
        } else if ([type isEqualToString:@"wxtimeline"]) {
            xjType = 4;
        } else if ([type isEqualToString:@"sina"]) {
            xjType = 5;
        }
        //        微信 =3
        //        微信朋友圈4
        //        qq 1
        //        qzone 2
        //        sina 5
        
        //        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",FLBaseUrl,_flTopicImageStr]];
        
        NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@/transpond/transpond!isTranspond.action?topic.topicId=%@&type=%@&perUserId=%@",FLBaseUrl,self.flmyIssueInMineModel.flMineIssueTopicIdStr,[NSNumber numberWithInteger:xjType],XJ_USERID_WITHTYPE];
        //如果是H5
        if ([XJFinalTool xjStringSafe:self.xj_tempId]) {
            xjRelayContentStr = [NSString stringWithFormat:@"%@/transpondh/transpondh!isTranspond.action?topic.topicId=%@&type=%@&perUserId=%@&topic.tempId=%@",FLBaseUrl,self.flmyIssueInMineModel.flMineIssueTopicIdStr,[NSNumber numberWithInteger:xjType],XJ_USERID_WITHTYPE,self.xj_tempId];
        }
        
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:self.flmyIssueInMineModel.flMineIssueBackGroundImageStr isSite:NO]]];
        [UMSocialData defaultData].extConfig.title = self.flmyIssueInMineModel.flMineTopicThemStr;
        //        [UMSocialData defaultData].shareText = @"内容";
        //        [UMSocialData defaultData].shareImage = @"图片";
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = xjRelayContentStr;
        //        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qqData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [UMSocialData defaultData].urlResource;
        
        
        NSString* xjTopicExpline = @"我在这里发现了免费的好东东，来一起玩耍吧，嘎嘎~";
        if (self.flmyIssueInMineModel.xjTopicExplain.length != 0) {
            //            xjTopicExpline = [NSString stringWithFormat:@"使用说明：%@",self.flmyIssueInMineModel.xjTopicExplain.length != 0 ? self.flmyIssueInMineModel.xjTopicExplain : @"无"];
        }
        NSString* xjweiboStr= @"";
        if (xjType == 5) {
            xjweiboStr = [NSString stringWithFormat:@"%@%@",self.flmyIssueInMineModel.flMineIssueBackGroundImageStr,xjRelayContentStr];
        }
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:[NSString stringWithFormat:@"%@",xjType==5 ? xjweiboStr: xjTopicExpline] image:self.flGrayBaseView.flErWeiMaImageView.image location:nil urlResource:[UMSocialData defaultData].urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                FL_Log(@"分享成功！");
            }
        }];
        
        //        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:@"友盟社会化分享让您快速实现分享等社会化功能，http://123.57.35.196:80" image:self.flhtmlMode.flimageMain location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        //            if (response.responseCode == UMSResponseCodeSuccess) {
        //                FL_Log(@"分享成功！");
        //                [self FLFLHTMLInsertParticipate];//插入参与记录
        //                [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
        //            }
        //        }];
        
        //        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        //            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
        //                FL_Log(@"分享成功！");
        //            }
        //        }];
        
    }
}

- (void)setXjTioicId:(NSString *)xjTioicId {
    _xjTioicId = xjTioicId;
    if (xjTioicId) {
        self.flmyIssueInMineModel.flMineIssueTopicIdStr = xjTioicId;
        [self getDetailsImageInTopicControlVCWithTopicId:xjTioicId];
        [self getIssueInfoDataWithTopicId:xjTioicId];
    }
}

//我发布的
- (void)getIssueInfoDataWithTopicId:(NSString*)xjTopicId{
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    NSDictionary* parm = @{@"topic.topicId": xjTopicId,
                           @"userType":XJ_USERTYPE_WITHTYPE,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjTopicId]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"test detail with2 with =%@",data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self xjMaDanWithDic:data[FL_NET_DATA_KEY]];
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjTopicId];
        });
        [[FLAppDelegate share] hideHUD];
    } failure:^(NSError *error) {
        [[FLAppDelegate share] hideHUD];
    }];
}

- (void)xjMaDanWithDic:(NSDictionary*)dic {
    self.flmyIssueInMineModel.flMineIssueBackGroundImageStr = [FLTool returnBigPhotoURLWithStr:dic[@"thumbnail"] ];//dic[@"thumbnail"];
    self.flmyIssueInMineModel.flMineIssueNumbersTotalPickStr = [dic[@"topicNum"] stringValue];
    self.flmyIssueInMineModel.flMineIssueDayStr    = [FLMineTools returnDateStrWithDateStr:dic[@"createTime"] ForType:1];
    self.flmyIssueInMineModel.flMineIssueMonthStr  = [FLMineTools returnDateStrWithDateStr:dic[@"createTime"] ForType:2];
    self.flmyIssueInMineModel.flMineIssueNumbersAlreadyPickStr = [dic[@"receiveNum"] stringValue]?[dic[@"receiveNum"] stringValue]:@"0";
    //    self.flmyIssueInMineModel.flMineIssueNumbersReadStr = [dic[@"pv"] stringValue];
    //    self.flmyIssueInMineModel.flMineIssueNumbersRelayStr = [dic[@"transformNum"]stringValue ];
    self.flmyIssueInMineModel.flMineIssueTopicIdStr =  dic[@"topicId"];
    self.flmyIssueInMineModel.flMineTopicThemStr = dic[@"topicTheme"];
    self.flmyIssueInMineModel.flMineTopicAddressStr = dic[@"address"];
    self.flmyIssueInMineModel.flTimeBegan = dic[@"startTime"];
    self.flmyIssueInMineModel.flTimeEnd   = dic[@"endTime"];
    self.flmyIssueInMineModel.flTimeService = dic[@"newDate"];
    self.flmyIssueInMineModel.flMineIssueTopicConditionStr = dic[@"topicCondition"];
    CGFloat ff = [self.flmyIssueInMineModel.flMineIssueNumbersAlreadyPickStr floatValue] / [self.flmyIssueInMineModel.flMineIssueNumbersTotalPickStr floatValue];
    self.flmyIssueInMineModel.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
    self.flmyIssueInMineModel.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
    self.flmyIssueInMineModel.flMineIssueNumbersJudgeStr = [dic[@"commentCount"] stringValue];
    self.flmyIssueInMineModel.flStateInt = [dic[@"state"] integerValue];
    self.flmyIssueInMineModel.xjTopicExplain = dic[@"topicExplain"];
    self.flmyIssueInMineModel.xjPartInNumber = [dic[@"partNum"] integerValue];
    self.flmyIssueInMineModel.xjTopicTagStr =  dic[@"topicTag"];
    
    self.flMyIssueActivityControlView.flMyIssueInMineModel = self.flmyIssueInMineModel;
    if (self.flmyIssueInMineModel.flStateInt==0) {
        _xjIssueAgainLabel.text = @"发布";
    }
}

@end










