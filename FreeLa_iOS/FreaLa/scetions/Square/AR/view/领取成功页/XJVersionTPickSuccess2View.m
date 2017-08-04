//
//  XJVersionTPickSuccess2View.m
//  FreeLa
//
//  Created by MBP on 17/7/26.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJVersionTPickSuccess2View.h"
#import "XJVersionTPickSuccess2TableViewCell.h"
#import "BGReview.h"
#import "XJVersionTPickSuccessmoreTableViewCell.h"
#import "NSDate+time.h"
@interface XJVersionTPickSuccess2View ()<UITableViewDelegate,UITableViewDataSource,ReViewProtocol>
{
    NSInteger _flPartInCurrentPage;
    NSInteger _fltotal;
    UIView*titleBackgroundImageV;
}

@property(nonatomic,strong)UITableView*myTabelView;
//评论输入框
@property(nonatomic,strong)BGReview * reviewView;
/**模型数组*/
@property (nonatomic , strong) NSMutableArray* flMyTopicPartInArray;
@property(nonatomic,strong)UIActivityIndicatorView *testActivityIndicator;
@property(nonatomic,strong)UIImageView*fabu_view;
@property(nonatomic,strong)UIButton*chaKanPiaoQuanBtn;
@property(nonatomic,strong)UIImageView*backgroundImageV;
@property(nonatomic,strong)UIButton*zanBtn;
@property(nonatomic,strong)UILabel*zanLabel;
@property(nonatomic,strong)UIImageView*zanImageV;
@property (strong, nonatomic) UIButton *flGoBackBtn;

@end

@implementation XJVersionTPickSuccess2View
-(instancetype)init{
    if (self=[super init]) {
        self.flMyTopicPartInArray = [NSMutableArray array];
        [self createUI];
        [self setKeyboard];


    }
    return self;
}
-(UIToolbar *)maskView{
    if (!_maskView) {
        _maskView=[[UIToolbar alloc]init];
        _maskView.frame=CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        _maskView.barStyle=UIBarStyleBlackTranslucent;
        //        _maskView.backgroundColor=[UIColor blackColor];
        _maskView.alpha=0.0;
        
    }
    return _maskView;
}
- (UIButton *)flGoBackBtn {
    if (!_flGoBackBtn) {
        _flGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flGoBackBtn.frame = CGRectMake(20, 20, 40, 40);
        [_flGoBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        [_flGoBackBtn addTarget:self action:@selector(flGoBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flGoBackBtn;
}
-(void)flGoBackBtnAction{
    [self popDown];
    if (self.popBlock) {
        self.popBlock();
    }
}
-(void)setFlmyReceiveMineModel:(FLMyReceiveListModel *)flmyReceiveMineModel{
    _flmyReceiveMineModel=flmyReceiveMineModel;
    [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:flmyReceiveMineModel.avatar]];
    self.topicLabel.text=_flmyReceiveMineModel.flMineTopicThemStr;
    self.topicLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
    if (_flmyReceiveMineModel.flMineTopicThemStr.length>14) {
        [self.topicLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DEVICE_WIDTH*0.5);
        }];
    }else{
        [self.topicLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo(titleBackgroundImageV).with.insets(UIEdgeInsetsMake(2.5, 4, 2.5, 4))
            make.left.equalTo(titleBackgroundImageV).offset(7+4);
            make.right.equalTo(titleBackgroundImageV).offset(-11);
            make.centerY.equalTo(titleBackgroundImageV);
            
            
            
        }];

    }
    NSDate*date=[NSDate dateWithStr:_flmyReceiveMineModel.flTimeBegan];
    self.timeLabel.text    =[NSString stringWithFormat:@"%@发布",[date getTime]] ;

    self.nickNameL.text=_flmyReceiveMineModel.xjPublishName;
    self.xj_imgUrlStr=_flmyReceiveMineModel.xj_suolvetuStr;
    _reviewView.flFuckTopicId=_flmyReceiveMineModel.flMineIssueTopicIdStr;

    [self isdianzan];
    [self loadNewDataWithTableViewPLList];
    [self getCollectNum];
}
-(void)setXjTopicIdStr:(NSString *)xjTopicIdStr{
    _xj_imgUrlStr=xjTopicIdStr;
    [self loadNewDataWithTableViewPLList];

}
#pragma mark 获取点赞数
-(void)getCollectNum{
    
    NSDictionary*dic=@{@"idsArray":_flmyReceiveMineModel.flMineIssueTopicIdStr};
    
    [FLNetTool defindTopicCollectNumWith:dic success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
//            self.zanLabel.text=data[FL_NET_DATA_KEY][@"collentionNums"];
            if ([data[FL_NET_DATA_KEY][@"collentionNums"] integerValue]==0) {
                self.zanLabel.text=@"";
                _flmyReceiveMineModel.flMineIssueNumbersCollectStr=@"0";

            }else{
                _flmyReceiveMineModel.flMineIssueNumbersCollectStr=data[FL_NET_DATA_KEY][@"collentionNums"];
                self.zanLabel.text=data[FL_NET_DATA_KEY][@"collentionNums"];

            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(UIActivityIndicatorView *)testActivityIndicator{
    if (!_testActivityIndicator) {
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        testActivityIndicator.center = CGPointMake(self.width/2, self.height/2-50);//只能设置中心，不能设置大小
        testActivityIndicator.color = [UIColor redColor]; // 改变圈圈的颜色为红色； iOS5引入
        [testActivityIndicator startAnimating]; // 开始旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        _testActivityIndicator=testActivityIndicator;
        
    }
    return _testActivityIndicator;
}

- (void)setXj_imgUrlStr:(NSString *)xj_imgUrlStr {
    _xj_imgUrlStr = xj_imgUrlStr;
    //判断路径的结尾是不是 .mp4
    [self addSubview:self.testActivityIndicator];
    [self sendSubviewToBack:self.testActivityIndicator];
    
    if([xj_imgUrlStr hasSuffix:@".mp4"]){
        self.topicImageV.hidden = YES;
        self.topicPlayView.isXunHuan=YES;
        
        self.topicPlayView.hidden = NO;
        self.topicPlayView.videoURLStr = xj_imgUrlStr;
        [self.topicPlayView.player play];
        
    } else {
        self.topicImageV.hidden = NO;
        self.topicPlayView.hidden = YES;
        self.topicPlayView.isXunHuan = NO;

        __weak typeof(self) weakSelf = self;
        FL_Log(@"test value in  pick success = %@",xj_imgUrlStr);
        
        [self.topicImageV sd_setImageWithURL:[NSURL URLWithString:xj_imgUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf xj_addImgAnimation];
            [_testActivityIndicator stopAnimating]; // 结束旋转
            
        }];
    }
}

- (void)setKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)dealloc{
    [self removeKeyboard];
}
-(void)removeKeyboard{
    [[NSNotificationCenter defaultCenter] self];
}
#pragma -mark 键盘弹出时调用
- (void)kbWillShow:(NSNotification *)noti
{
    //获取键盘移动后的最高Y值
    CGFloat kbY = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeTranslation(0,kbY-DEVICE_HEIGHT);
        
    } completion:^(BOOL finished) {
    }];

}
#pragma -mark 键盘回去时调用

- (void)kbWillHide:(NSNotification *)noti
{
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        
    }completion:^(BOOL finished) {
    }];
}

- (UIView *)firstResp{
    if ([_reviewView.textView isFirstResponder]) {
        return _reviewView;
    }
    
    return [UIView new];
    
}

-(WMPlayer *)topicPlayView{
    if (!_topicPlayView) {
        CGRect playerFrame = self.topicImageV.frame;

        _topicPlayView = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:@""];
        _topicPlayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self bringSubviewToFront:_topicPlayView];
        [self addSubview:_topicPlayView];
    }
    return _topicPlayView;

}
-(void)xjxjtesttagtag{
    [self.reviewView.textView resignFirstResponder];
}
-(void)createUI{
    self.frame=CGRectMake(0, 0, FLUISCREENBOUNDS.width , FLUISCREENBOUNDS.height);
    self.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer* tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjxjtesttagtag)];
    [self addGestureRecognizer:tapg];

    _reviewView = [[BGReview alloc]initWithSuperView:self];
    //    [self.toolBar removeFromSuperview];
    _reviewView.deletage = self;

    //礼包title

    titleBackgroundImageV=[[UIView alloc]init];
    titleBackgroundImageV.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    titleBackgroundImageV.layer.cornerRadius=5;
    titleBackgroundImageV.layer.masksToBounds=YES;
    [self addSubview:titleBackgroundImageV];
    [titleBackgroundImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    self.topicLabel=({
        UILabel * label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor whiteColor];
        
        
        label;
    });
    [titleBackgroundImageV addSubview:self.topicLabel];
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(titleBackgroundImageV).with.insets(UIEdgeInsetsMake(2.5, 4, 2.5, 4))
        make.left.equalTo(titleBackgroundImageV).offset(7+4);
        make.right.equalTo(titleBackgroundImageV).offset(-11);
        make.centerY.equalTo(titleBackgroundImageV);



    }];

    //礼包图
    self.topicImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.frame=CGRectMake(0, DEVICE_HEIGHT, DEF_I6_SIZE(255), DEF_I6_SIZE(255));
        imageV.centerX=DEVICE_WIDTH*0.5;
        imageV.contentMode=UIViewContentModeScaleAspectFit;
        imageV;
    });
    [self addSubview:self.topicImageV];

    //发布者
    UIImageView*fabu_view=[[UIImageView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEF_I6_SIZE(320), 45+14)];
    fabu_view.centerX=DEVICE_WIDTH*0.5;
    fabu_view.image=[UIImage imageNamed:@"shiYongShuoMing_beiJing-1"];
    fabu_view.contentMode=UIViewContentModeScaleToFill;
    fabu_view.userInteractionEnabled=YES;
    self.fabu_view=fabu_view;
    [self addSubview:fabu_view];
    self.headerImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=15;
        imageV.layer.borderColor=[UIColor whiteColor].CGColor;
        imageV.layer.borderWidth=0.5;
        imageV;
    });
    [fabu_view addSubview:self.headerImageV];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(7+8.5);
        make.centerY.equalTo(fabu_view.mas_centerY);
    }];
    self.nickNameL=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor redColor];
        label.font=[UIFont systemFontOfSize:14];
        label;
    });
    [fabu_view addSubview:self.nickNameL];
    [self.nickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageV.mas_right).offset(7.5);
        make.top.equalTo(self.headerImageV);
    }];
    self.timeLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:12];
        label;
    });
    [fabu_view addSubview:self.timeLabel ];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameL);
        make.top.equalTo(self.nickNameL.mas_bottom).offset(3);
    }];
    self.zanLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor whiteColor];
        label;
    });
    [fabu_view addSubview:self.zanLabel];
    [self.zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fabu_view);
        make.right.equalTo(fabu_view).offset(-17);
    }];
    self.zanImageV=({
        UIImageView*ImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yiDianZanXing_hui"]];
        ImageV.highlightedImage=[UIImage imageNamed:@"yiDianZanXing"];
        ImageV;
    });
    [fabu_view addSubview:self.zanImageV];
    [self.zanImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 15));
        make.right.equalTo(self.zanLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.zanLabel);
    }];

    self.zanBtn=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:@"yiDianZanXing_hui"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"yiDianZanXing"] forState:UIControlStateSelected];

        //top left bottom right
        [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 13, 12,20)];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 0)];
        [btn addTarget:self action:@selector(dianZanAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [fabu_view addSubview:self.zanBtn];
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.centerY.equalTo(fabu_view);
        make.right.equalTo(fabu_view).offset(-8);
    }];

    
//    self.zanLabel=({
//        UILabel*label=[[UILabel alloc]init];
//        label.font=[UIFont systemFontOfSize:12];
//        label.textColor=[UIColor whiteColor];
//        label;
//    });
//    [fabu_view addSubview:self.zanLabel];
//    [self.zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(fabu_view.mas_right).offset(-14.5);
//        make.centerY.equalTo(fabu_view);
//    }];
//    
//    UIImageView*zanImageV=[[UIImageView alloc]init];
//    zanImageV.image=[UIImage imageNamed:@"yiDianZanXing"];
//    [fabu_view addSubview:zanImageV];
//    [zanImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(13.5, 12));
//        make.right.equalTo(self.zanLabel.mas_left).offset(-3);
//        make.centerY.equalTo(self.zanLabel);
//    }];
    
    
    
    
    
    UIImageView*backgroundImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shiYongShuoMing_beiJing-1"]];
    backgroundImageV.frame=CGRectMake(0,DEVICE_HEIGHT, DEF_I6_SIZE(320), 133+20);
    backgroundImageV.userInteractionEnabled=YES;
    backgroundImageV.centerX=DEVICE_WIDTH*0.5;
    self.myTabelView=({
        UITableView*table=[[UITableView alloc]init];
        table.backgroundColor=[UIColor clearColor];
        table.dataSource = self;
        table.delegate = self;
        table.estimatedRowHeight=44;

        table.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [table registerClass:XJVersionTPickSuccess2TableViewCell.self forCellReuseIdentifier:@"XJVersionTPickSuccess2TableViewCellider"];
        [table registerClass:XJVersionTPickSuccessmoreTableViewCell.self forCellReuseIdentifier:@"XJVersionTPickSuccessmoreTableViewCellider"];

        
        table.showsHorizontalScrollIndicator=NO;
        table.showsVerticalScrollIndicator=NO;
//        table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewPLList)];
//        MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataInTableViePLList)];
//        table.mj_footer = footer;
//
        table;
    });
    self.myTabelView.frame=CGRectMake(10,10, DEF_I6_SIZE(300), 133);
    [backgroundImageV addSubview:self.myTabelView];
    [self addSubview:backgroundImageV];
    self.backgroundImageV=backgroundImageV;

    UIButton*chaKanPiaoQuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.chaKanPiaoQuanBtn=chaKanPiaoQuanBtn;
    chaKanPiaoQuanBtn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:66.0/255.0 alpha:1];
    chaKanPiaoQuanBtn.layer.cornerRadius=17.5;
    chaKanPiaoQuanBtn.layer.masksToBounds=YES;
    chaKanPiaoQuanBtn.frame=CGRectMake(0, DEVICE_HEIGHT, 180, 35);
    chaKanPiaoQuanBtn.centerX=DEVICE_WIDTH*0.5;
    [chaKanPiaoQuanBtn setTitle:@"查看票券" forState:UIControlStateNormal];
    [chaKanPiaoQuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [chaKanPiaoQuanBtn addTarget:self action:@selector(xj_clickDone) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:chaKanPiaoQuanBtn];
    [self addSubview:self.flGoBackBtn];

}

-(void)dianZanAction{
    if (self.zanBtn.isSelected) {
        return;
    }
    //添加收藏
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"topicId":self.flmyReceiveMineModel.flMineIssueTopicIdStr,
                           @"userId":FL_USERDEFAULTS_USERID_NEW};
    [FLNetTool flAddcollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is add collection result=%@",dic);
        if ([dic[@"success"] boolValue]) {
            self.zanBtn.selected=YES;
            self.zanImageV.highlighted=YES;
            NSInteger num=[self.flmyReceiveMineModel.flMineIssueNumbersCollectStr integerValue];
            self.zanLabel.text=[NSString stringWithFormat:@"%ld",num+1];
            
        }
    } failure:^(NSError *error) {
        
    }];

}
- (void)xj_clickDone {
    [self.topicPlayView.player pause];
    if (self.block != nil) {
        self.block();
        
    }
}

- (void)xj_findGiftSuccessDone:(xjPickSucessDoneAction)block {
    _block = block;
}

- (void)loadNewDataWithTableViewPLList
{
    _flPartInCurrentPage = 1;
    [_flMyTopicPartInArray removeAllObjects];
    FL_Log(@"'loadNewDataWithTableViewPLListkkkkkkkkk");
    [self getJudgeListPLinMyIssueControlVC];
}

- (void)loadMoreDataInTableViePLList
{
    _flPartInCurrentPage ++;
    FL_Log(@"'loadMoreDataInTableViePLLissssssst");
    [self getJudgeListPLinMyIssueControlVC];
}
-(void)isdianzan{
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"topicId":self.flmyReceiveMineModel.flMineIssueTopicIdStr};
    [FLNetTool flIscollectionTopicBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is my test with is collection =%@",dic);
        if ([dic[@"success"] boolValue]) {
            self.zanBtn.selected=YES;
            self.zanImageV.highlighted=YES;
        }else{
            self.zanBtn.selected=NO;
            self.zanImageV.highlighted=NO;

        }
    } failure:^(NSError *error) {
        
    }];

}
- (void)getJudgeListPLinMyIssueControlVC {
    NSDictionary* detail = @{@"businessId":self.flmyReceiveMineModel.flMineIssueTopicIdStr ? self.flmyReceiveMineModel.flMineIssueTopicIdStr :@"",
                             @"commentType":@"0", //1为评价  0为评论
                             }; //分页
    NSDictionary* parm = @{@"commentPara":[FLTool returnDictionaryToJson:detail],
                           @"page.currentPage":[NSNumber numberWithInteger:_flPartInCurrentPage],
                           @"isFlush":@"true"};
    [FLNetTool htmlListCommentInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in html with PL listwith type 0 =%@",data);
        if (data) {
            _fltotal = [data[@"total"] integerValue];
            if (!_fltotal) {
                self.reviewView.sendLabel.text=@"";
            }else{
                self.reviewView.sendLabel.text=[NSString stringWithFormat:@"%ld",_fltotal];
            }
            NSArray* array = [FLMineTools returnJudgePLModelWithDic:data[FL_NET_DATA_KEY]];
            [self.flMyTopicPartInArray addObjectsFromArray:array];
            if (!self.flMyTopicPartInArray.count) {
                self.backgroundImageV.hidden=YES;
                self.chaKanPiaoQuanBtn.cy_y=self.fabu_view.cy_bottom+self.fabu_view.cy_height;

            }else{
                self.backgroundImageV.hidden=NO;
                self.chaKanPiaoQuanBtn.cy_y=self.backgroundImageV.cy_bottom+15;


            }
            [self.myTabelView reloadData];
            
//            CGFloat sumHeigh=0;
//            for (FLMyIssueJudgePlModel* flmodel in self.flMyTopicPartInArray) {
//                XJVersionTPickSuccess2TableViewCell*cell;
//                
//                cell =[[XJVersionTPickSuccess2TableViewCell alloc] init];
//                cell.flmodel = flmodel;
//                sumHeigh=sumHeigh+cell.cellHeight;
//                if (sumHeigh>133) {
//                    break;
//                }
//            }
//            if (sumHeigh<133) {
//                self.backgroundImageV.height=sumHeigh+20;
//            }else{
//                self.backgroundImageV.height=133+20;
//
//            }
            

//            [self endRefreshInTableViewPLList];
        }
    } failure:^(NSError *error) {
//        [self endRefreshInTableViewPLList];
    }];
}
- (void)endRefreshInTableViewPLList
{
    [self.myTabelView.mj_header endRefreshing];
    if (_fltotal == _flMyTopicPartInArray.count) {
        [self.myTabelView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.myTabelView.mj_footer endRefreshing];
    }
}

#pragma mark-- ReViewProtocol
-(void)sendBtnAction{
    //插入评论记录
    NSDictionary* dic = @{@"businessId":self.flmyReceiveMineModel.flMineIssueTopicIdStr,
                          @"commentType":@"0",   //0代表评论
                          @"content":self.reviewView.textView.text,
                          @"parentId":@"0"};
    NSDictionary* parm = @{ @"commentPara":[FLTool returnDictionaryToJson:dic],
                            @"userType": XJ_USERTYPE_WITHTYPE,
                            @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"insert comment in html judge = %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self loadNewDataWithTableViewPLList];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in insert comment html =%@",error);
    }];
}

#pragma mark--tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _flMyTopicPartInArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_fltotal>_flMyTopicPartInArray.count&&indexPath.row==_flMyTopicPartInArray.count-1) {
        XJVersionTPickSuccessmoreTableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:@"XJVersionTPickSuccessmoreTableViewCellider"];
        cell.block=^(){
            [self loadMoreDataInTableViePLList];

        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        XJVersionTPickSuccess2TableViewCell*cell;

        cell =[tableView dequeueReusableCellWithIdentifier:@"XJVersionTPickSuccess2TableViewCellider"];
        cell.flmodel = _flMyTopicPartInArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==_flMyTopicPartInArray.count-1&&_fltotal==_flMyTopicPartInArray.count) {
            cell.lineView.hidden=YES;
        }else{
            cell.lineView.hidden=NO;

        }
        return cell;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}



-(void)popUp{
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=0.2;
        self.topicImageV.cy_y=60;
        self.fabu_view.cy_y=DEF_I6_SIZE(322);
        self.backgroundImageV.cy_y=self.fabu_view.cy_bottom;
        self.chaKanPiaoQuanBtn.cy_y=self.backgroundImageV.cy_bottom+15;
    }completion:^(BOOL finished)
     {
         
     }];
    
}
-(void)popDown{
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=0.0;
        self.topicImageV.cy_y=DEVICE_HEIGHT;
        self.fabu_view.cy_y=DEVICE_HEIGHT;
        self.backgroundImageV.cy_y=DEVICE_HEIGHT;
        self.chaKanPiaoQuanBtn.cy_y=DEVICE_HEIGHT;
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview ];
        [self.maskView removeFromSuperview];

    }];
    
}
- (void)xj_addImgAnimation{
    
    CABasicAnimation * scaleAnimationBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimationBig.fromValue = @0.1;
    scaleAnimationBig.toValue = @1.0;
    scaleAnimationBig.duration = 1;
    scaleAnimationBig.repeatCount = 1;
    scaleAnimationBig.removedOnCompletion = YES;
    
    [self.topicImageV.layer addAnimation:scaleAnimationBig forKey:@"plulsing"];
}

@end
