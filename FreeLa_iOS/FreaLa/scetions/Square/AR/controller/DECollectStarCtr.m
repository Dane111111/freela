//
//  DECollectStarCtr.m
//  FreeLa
//
//  Created by MBP on 17/6/30.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "DECollectStarCtr.h"
#import "InstructionViewController.h"

@interface DECollectStarCtr ()
@property(nonatomic,strong)UIImageView*leftIconImageView;
@property(nonatomic,strong)UIImageView*rightIconImageView;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UIImageView*detilImageView;
@property(nonatomic,strong)UILabel*personNum;
@property(nonatomic,strong)UILabel*failureLabel;
@property(nonatomic,strong)UIView*collectView;
@property(nonatomic,assign)NSUInteger sumNumber;
@property(nonatomic,strong)NSArray*linqu_arr;
@property(nonatomic,strong)UIButton*linQu_button;
@property (nonatomic , strong) CHTumblrMenuView *menuView;
/**领取模型*/
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;

@property(nonatomic,assign)BOOL isShareSccuess;
@property(nonatomic,strong)UIImageView*backgroundView;
@end

@implementation DECollectStarCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xjreturnModelForTicketsWithData:self.jinXingZhu_dic];

    [self createUI];
    [self setData];
    [self jiXing_ziHuoDong];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    
}
- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}

- (void)xjreturnModelForTicketsWithData:(NSDictionary*)data {
    //    FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
    self.flmyReceiveMineModel.flIntroduceStr = data[@"topicExplain"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = data[@"topicId"];
    self.flmyReceiveMineModel.xjCreator = [data[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [data[@"userId"] integerValue];
    self.flmyReceiveMineModel.flTimeBegan = data[@"startTime"];
    self.flmyReceiveMineModel.xjinvalidTime = data[@"invalidTime"];
    self.flmyReceiveMineModel.xjUrl = data[@"url"];
    self.flmyReceiveMineModel.xjUserType = data[@"userType"];
    NSString* suolve = data[@"sitethumbnail"];
    self.flmyReceiveMineModel.xj_suolvetuStr = suolve;
    
    self.flmyReceiveMineModel.flMineTopicThemStr = data[@"topicTheme"];
    self.flmyReceiveMineModel.xj_xiansuotuStr = data[@"detailchart"];
    self.flmyReceiveMineModel.xj_suolvetuStr=data[@"thumbnail"];
    NSString* ad = data[@"thumbnail"];
    FL_Log(@"dsadsafsadsad===【%@】",ad);
    self.flmyReceiveMineModel.createTime = data[@"createTime"];
    self.flmyReceiveMineModel.pictureCode = data[@"pictureCode"];
    
}
- (void)FLFLHTMLHTMLsaveTopicClickOn:(id)iii{
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    NSString* xjUserId = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    NSString* xjCreator = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    if (!xjUserId  || !xjCreator) {
        xjUserId = @"";
        xjCreator = @"";
    }
    
    NSDictionary* parm = @{@"participateDetailes.topicId":self.flmyReceiveMineModel.flMineIssueTopicIdStr ,
                           @"participateDetailes.userId":xjUserId,
                           @"participateDetailes.userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"participateDetailes.message":iii?iii:@"",
                           @"participateDetailes.creator":xjCreator,//FL_USERDEFAULTS_USERID_NEW,
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID]};
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"notifation with SAVE gift clickon = %@",data);
        if (!data) {
            [FLTool showWith:@"请求结果错误"];
            return ;
        }
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
            ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
            FL_Log(@"thi1s is te1h acti1on to push the page of ticke3t");
            [self.navigationController pushViewController:ticketVC animated:YES];

        }else{
            [FLTool showWith:@"领取过了,去我的票券页查看"];

        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
    }];
}
// 点击插入参与记录 (发起助力抢等)
- (void)FLFLHTMLInsertParticipate
{
    FL_Log(@"点击插入参与记录");
    NSDictionary* parm =@{@"participate.topicId":self.flmyReceiveMineModel.flMineIssueTopicIdStr,
                          @"participate.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"participate.userType":FLFLXJUserTypePersonStrKey,   //商家不可以点击领取
                          @"participate.creator":FL_USERDEFAULTS_USERID_NEW};   //个人领取永远是个人id
    [FLNetTool HTMLinsertParticipateInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"点击插入参ss与记录ssssdsa成功= %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)setData{
    NSURL*iconURL=[NSURL URLWithString:self.jinXingZhu_dic[@"avatar"]];
    [self.rightIconImageView sd_setImageWithURL:iconURL];
    self.titleLabel.text=self.jinXingZhu_dic[@"topicTheme"];
    NSURL*detilURL=[NSURL URLWithString:self.jinXingZhu_dic[@"sitethumbnail"]];
    [self.detilImageView sd_setImageWithURL:detilURL];
    self.personNum.text=[NSString stringWithFormat:@"已参与%ld人",[self.jinXingZhu_dic[@"pv"] integerValue]+13];
    self.failureLabel.text=self.jinXingZhu_dic[@"invalidTime"];
}
-(void)jiXing_ziHuoDong{
    [FLNetTool deGetIsChildListWith:nil success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray * dataArr=data[@"data"];
            if (dataArr&&dataArr.count>0) {
                self.sumNumber=dataArr.count;
                [self jixing_zihuodong_woshoujide];
            }
        }

    } failure:^(NSError *error) {
        
    }];
}
-(void)jixing_zihuodong_woshoujide{
    NSDictionary*parm=@{@"participateDetailes.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,@"participateDetailes.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,@"participateDetailes.isChild":@"1",@"participateDetailes.startTime":self.jinXingZhu_dic[@"startTime"],@"participateDetailes.endTime":self.jinXingZhu_dic[@"endTime"]};
    
    [FLNetTool deTopicReceiveListWith:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.linqu_arr=data[@"data"];
            [self lngqu];
        }

    } failure:^(NSError *error) {
        
    }];

}
-(void)lngqu{
    if (self.sumNumber==0) {
        return;
    }
    if (self.linqu_arr.count>=self.sumNumber) {
        self.linQu_button.selected=YES;
    }
    int i=0;
    for (NSDictionary *dic in self.linqu_arr) {
        NSURL*url=[NSURL URLWithString:dic[@"thumbnail"]];
        if (self.sumNumber<=i) {
            return;
        }
        UIImageView*imageV=[self.collectView subviews][i];
        [imageV sd_setImageWithURL:url];
                            i++;
    }
}
-(void)setSumNumber:(NSUInteger)sumNumber{
    _sumNumber=sumNumber;
    [self.collectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(sumNumber*40, 75));
        make.centerX.equalTo(self.backgroundView);
        make.top.equalTo(self.failureLabel.mas_bottom).offset(0);
    }];

    for (int i=0; i<sumNumber; i++) {
        UIImageView*imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jixing_xingxing"]];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=20;
        [self.collectView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(40*i);
            make.centerY.equalTo(self.collectView);
        }];
    }
}
-(void)createUI{
    UIImageView*backguoundView=({
       UIImageView*imagV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jixinghuodong_beijing"]];
        imagV.frame=self.view.frame;
        imagV.userInteractionEnabled=YES;
        [self.view addSubview: imagV];
        imagV;

    });
    self.backgroundView=backguoundView;
    self.leftIconImageView=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=40;
        imageV.frame=CGRectMake(0, 55, 80, 80);
        imageV.cy_right=DEVICE_WIDTH*0.5-35;
        imageV.image=[UIImage imageNamed:@"logo_freela"];
        [backguoundView addSubview:imageV];
        imageV;
    });
    self.rightIconImageView=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=40;
        imageV.frame=CGRectMake(0, 55, 80, 80);
        imageV.cy_x=DEVICE_WIDTH*0.5+35;
        [backguoundView addSubview:imageV];

        imageV;
    });
    UIButton*wenhao_btn=({
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"jixing_wenhao"] forState:UIControlStateNormal];
        [backguoundView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(self.rightIconImageView);
            make.right.mas_equalTo(-25);
        }];
        [btn addTarget:self action:@selector(wenhaoAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    UIImageView*titleimageV=({
        UIImage*image=[UIImage imageNamed:@"jixingdazuozhan"];
        UIImageView*imageV=[[UIImageView alloc]initWithImage:image];
        imageV.frame=CGRectMake(0, 0, 406/2, 89/2);
        imageV.y=self.rightIconImageView.cy_bottom+15;
        imageV.centerX=backguoundView.centerX;
        [backguoundView addSubview: imageV];
        imageV;
    });
    self.titleLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:20];
        label.textColor=[UIColor whiteColor];
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleimageV.mas_bottom).offset(8);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    self.detilImageView=({
        UIImageView*imageV=[[UIImageView alloc]init];
        [backguoundView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(180, 180));
            make.centerX.equalTo(backguoundView);
        }];
        imageV;
    });
    self.personNum=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:15];
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detilImageView.mas_bottom).offset(8);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    self.failureLabel=({
        UILabel*label=[[UILabel alloc] init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:14];
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.personNum.mas_bottom).offset(3);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    self.collectView=({
        UIView*view=[[UIView alloc] init];
        [backguoundView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 75));
            make.centerX.equalTo(backguoundView);
            make.top.equalTo(self.failureLabel.mas_bottom).offset(0);
        }];
        view;
    });
    UILabel*yaoLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor whiteColor];
        label.text=@"快来邀请你的小伙伴一起来寻宝吧!";
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectView.mas_bottom);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    self.linQu_button=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"jixing_diangjilingqu_hui"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"jixingdianjilingqu_huang"] forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:13];
        
        [btn setTitle:@"转发" forState:UIControlStateNormal];
        [btn setTitle:@"立即领取" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [backguoundView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo( CGSizeMake(180*1.3, 33*1.3));
            make.top.equalTo(yaoLabel.mas_bottom).offset(5);
            make.centerX.equalTo(backguoundView);
        }];
        [btn addTarget:self action:@selector(lijiLingQuAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });

}
#pragma  mark  -------------------------- 分享
- (void)showMenu {
    
    if (_menuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    }
    _menuView = [[CHTumblrMenuView alloc] init];
    __weak typeof(self) weakSelf = self;
    NSArray* nameArray = @[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"新浪",@"免费啦"];
    NSArray* imageArray = @[@"share_wechat",@"share_friend",@"share_qq",@"share_qzone",@"share_sina",@"share_mianfeila"];
    NSArray* typeArray = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,@"freela"];
    for (NSInteger i = 0; i < nameArray.count; i ++ )
    {
        [_menuView addMenuItemWithTitle:nameArray[i] andIcon:[UIImage imageNamed:imageArray[i]] andSelectedBlock:^{
            FL_Log(@"Phot2o selected= %ld",i);
            [weakSelf shareToWithType:typeArray[i]];
        }];
    }
    [_menuView show];
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
        
        //        NSString* xjRelayContentStr = [NSString stringWithFormat:@"http://www.freela.com.cn/WeiXinOt/arTranspond.html"];
        
        NSString* xjRelayContentStr = [NSString stringWithFormat:@"http://www.freela.com.cn/share.jsp"];
        
        NSString* da = self.jinXingZhu_dic[@"sitethumbnail"];
        FL_Log(@"dasaiaf=【%@】",da);
        
        NSString* xjtu = [XJFinalTool xjReturnImageURLWithStr:[NSString stringWithFormat:@"%@", self.jinXingZhu_dic[@"sitethumbnail"]] isSite:NO];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:xjtu];
        [UMSocialData defaultData].extConfig.title =self.jinXingZhu_dic[@"topicTheme"];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qqData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [UMSocialData defaultData].urlResource;
        
        NSString* xjTopicExpline =  @"我给你藏好了一个AR大礼包，速速来找吧~";
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:xjTopicExpline image:self.detilImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                self.isShareSccuess=YES;
                FL_Log(@"分享成功！");
                //                [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
            }
        }];
    }
}
#pragma  mark ----------------------_request
// 领取资格
- (void)checkTakeCanOrNot {
    //    [self xj_testToShowOK];
    FL_Log(@"this web view begin to reload for test");
    //检查领取资格
    NSDictionary* parm = @{@"participate.topicId": self.flmyReceiveMineModel.flMineIssueTopicIdStr,
                           @"participate.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in check pi22ck topic =%@",data);
        [FLTool showWith:[NSString stringWithFormat:@"%@",data[@"msg"]]];

        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if ([data[@"buttonKey"] isEqualToString: @"b11"]) {
                                //可以领取，查看是否有领取信息
                if (self.isShareSccuess) {
                    [self FLFLHTMLHTMLsaveTopicClickOn:nil];
                    [self FLFLHTMLInsertParticipate];
                }else{
                    [self showMenu];
                }
            }else if ([data[@"buttonKey"] isEqualToString: @"b10"]){
                [self lingQuGuoHouZhiJieTiaoPiaoQuanYe];
            }
            
        } else if ([data[@"buttonKey"] isEqualToString: @"b10"]){
            [self lingQuGuoHouZhiJieTiaoPiaoQuanYe];

        }else {
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)lingQuGuoHouZhiJieTiaoPiaoQuanYe{
    NSDictionary*dic=@{@"topicId":self.flmyReceiveMineModel.flMineIssueTopicIdStr,@"userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID};
    [FLNetTool xjxjGetDetailsIdWith:dic success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flmyReceiveMineModel.flDetailsIdStr=data[@"data"];
                XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
                ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
                [self.navigationController pushViewController:ticketVC animated:YES];

        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)wenhaoAction{
    InstructionViewController*vc=[[InstructionViewController alloc]init];
    vc.detilStr=self.jinXingZhu_dic[@"topicExplain"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)lijiLingQuAction:(UIButton*)btn{
    if (btn.isSelected) {
        [self checkTakeCanOrNot];

    }else{
        [self showMenu];

    }
}
@end
