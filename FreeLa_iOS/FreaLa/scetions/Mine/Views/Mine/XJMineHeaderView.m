//
//  XJMineHeaderView.m
//  FreeLa
//
//  Created by Leon on 16/5/25.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMineHeaderView.h"
#import "XJPushMessagesBtn.h"
@interface XJMineHeaderView ()
@property (nonatomic,  strong)UIImageView *backgroundImageView; //背景
//@property (nonatomic , strong)UIImageView* portraitImageView; //肖像
/**头像button*/
@property (nonatomic , strong)UIButton*    portraitBtn;//头像button
/**headerVIew*/
@property (nonatomic , strong)UIView* headerVIew;
/**名称的button*/
@property (nonatomic , strong) UIButton* myNameButton;
/**收藏的button*/
@property (nonatomic , strong) UIButton* xjCollectionBtn;
/**消息列表View*/
@property (nonatomic , strong) XJPushMessagesBtn* xjHeaderMessageBtn;
/**顶部分栏*/
@property (nonatomic , strong)UIView* topView;
@end



@implementation XJMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame topArr:(NSArray*)xjTopArr {
    self = [super initWithFrame:frame];
    if (self) {
        [self xjInitPageWithFrame:frame arr:xjTopArr];
    }
    return self;
}

- (void)xjInitPageWithFrame:(CGRect)freame arr:(NSArray*)xjTopicArr {
     if (!xjTopicArr) return;
    //头视图
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height * 0.33)];
    self.backgroundImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"mine_back"];
    self.headerVIew = [[UIView alloc] initWithFrame:self.backgroundImageView.frame];
    [self.headerVIew addSubview:self.backgroundImageView];
    //    [self.headerVIew addSubview:self.portraitBtn];
    [self addSubview:self.headerVIew];
    
    
    //头像按钮，点击进入设置
    self.portraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.portraitBtn setBackgroundImage:[UIImage imageNamed:@"logo_freela"] forState:UIControlStateNormal];
    self.portraitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.portraitBtn.layer.cornerRadius = 70 * FL_SCREEN_PROPORTION_width;
    self.portraitBtn.backgroundColor = [UIColor whiteColor];
    self.portraitBtn.layer.masksToBounds = YES;  //解决圆形button 添加图片溢出后的问题
    [self.portraitBtn addTarget:self action:@selector(GoToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
    [self.headerVIew addSubview:self.portraitBtn];
    [self.portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.center.equalTo(self.backgroundImageView).with.offset(0);
        make.centerX.equalTo(self.backgroundImageView).with.offset(0);
        make.centerY.equalTo(self.backgroundImageView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(140 * FL_SCREEN_PROPORTION_width, 140 * FL_SCREEN_PROPORTION_width));
    }];
    
    //头像下方名字btn
    self.myNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.myNameButton setTitle:@"nickName" forState:UIControlStateNormal];
    [self.myNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.myNameButton.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    [self.myNameButton addTarget:self action:@selector(GoToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
    [self.headerVIew addSubview:self.myNameButton];
    [self.myNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitBtn.mas_bottom).with.offset(-5 * FL_SCREEN_PROPORTION_height);
        make.centerX.equalTo(self.headerVIew).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width / 2, 40));
    }];
    // 收藏按钮
    self.xjCollectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xjCollectionBtn setImage:[UIImage imageNamed:@"addGroup"] forState:UIControlStateNormal];
    [self.xjCollectionBtn addTarget:self action:@selector(clickGoToCollectionPage) forControlEvents:UIControlEventTouchUpInside];
    [self.headerVIew addSubview:self.xjCollectionBtn];
    [self.xjCollectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerVIew.mas_right).with.offset(-35);
        make.centerY.equalTo(self.myNameButton).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(40 , 40));
    }];
    
    // 消息列表按钮
    self.xjHeaderMessageBtn = [[XJPushMessagesBtn alloc ] initWithFrame:CGRectMake(35, 80, 50, 50)];
    [self.headerVIew addSubview:self.xjHeaderMessageBtn];
    [self.xjHeaderMessageBtn.xjBtn addTarget:self action:@selector(clickToGoToPushMessagePage) forControlEvents:UIControlEventTouchUpInside];
    [self.xjHeaderMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerVIew).with.offset(35);
        make.centerY.equalTo(self.myNameButton).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(40 , 40));
    }];
    
    
    //顶部分栏
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerVIew.size.height, FLUISCREENBOUNDS.width, FL_TopColumnView_Height)];
    //创建顶部分栏下面的细线
    UIView* viewUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0, FL_TopColumnView_Height-1, FLUISCREENBOUNDS.width, 1)];
    viewUnderLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.topView addSubview:viewUnderLine];
    FL_Log(@"test heigh =%f",FL_TopColumnView_Height);
   
//    NSArray* array = @[@"我发布的",@"我领取的",@"我参与的",@"待评价的"];
    NSMutableArray* xjBtnMuArr = @[].mutableCopy;
    for (NSInteger i = 0; i < [xjTopicArr count]; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0 + self.topView.frame.size.width / 4 * i, 0, self.topView.frame.size.width / 4, 80* FL_SCREEN_PROPORTION_height);
        btn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        [btn setTitle:[xjTopicArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#545454"] forState:UIControlStateNormal];
        btn.tag = 40 + i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topView addSubview:btn];
        [xjBtnMuArr addObject:btn];
    }
    self.xjTopBtnArr = xjBtnMuArr.mutableCopy;  //设置btn
    //    中间分割线
    for (NSInteger i  = 0; i < 4 ; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topView.frame.size.width / 4 * (i + 1), 6, 0.5, 50* FL_SCREEN_PROPORTION_height)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.alpha = 0.7;
        [self.topView addSubview:imageView];
    }
    self.topView.backgroundColor = [UIColor whiteColor];
    [self  addSubview:self.topView];
}


@end














