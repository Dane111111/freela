//
//  FLCouponsTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLCouponsTableViewCell.h"
#import "XJCricleLabel.h"
//#define TabBarHeight            44
//#define StatusBar_NaviHeight    69
#define BigImageHeight           FLUISCREENBOUNDS.width  //(CellHeight) * 0.6
#define view_custom_H           (CellHeight - BigImageHeight)
#define CellHeight               ( FLUISCREENBOUNDS.width * 1.4 )
@interface FLCouponsTableViewCell  ()
{
    NSInteger flProgressValueLess; //剩余
}
/**搭载分类和图标的view*/
//@property (nonatomic , strong)UIView* categorySuperView;
/**优惠券的大图*/
@property (nonatomic , strong)UIImageView*      flIntroduceBigImageView;
/**搭载其他控件的view*/
@property (nonatomic , strong)UIView*           flSimpleView;
/**一句话介绍*/
@property (nonatomic , strong)UILabel *         flIntroduceLabel;
/**分类*/
@property (nonatomic , strong)UILabel*          flCategoayLabellll;
/**火的图标*/
@property (nonatomic , strong)UIImageView*      flCategorySmallImageView;
/**进度条*/
@property (nonatomic , strong)UIProgressView*   flProgressView;
/**进度条描述*/
@property (nonatomic , strong)UILabel*          flProgressIntroduceLabel;

/**f发布的分类(智能软件等)*/
@property (nonatomic , strong) XJCricleLabel* xjLabelTopicType;
/**f发布的分类(助力抢等)*/
@property (nonatomic , strong) XJCricleLabel* xjLabelTopicCondition;
@end

@implementation FLCouponsTableViewCell

- (void)awakeFromNib{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width,CellHeight);
        self.flIntroduceBigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, BigImageHeight)];
        self.flSimpleView  = [[UIView alloc] initWithFrame:CGRectMake(0, BigImageHeight , FLUISCREENBOUNDS.width, view_custom_H)];
        [self.flIntroduceBigImageView setBackgroundColor:[UIColor purpleColor]];
        //        [self.flSimpleView setBackgroundColor:[UIColor redColor]];
        //大标题
        [self.contentView addSubview:self.flIntroduceBigImageView];
        self.flIntroduceLabel = [[UILabel alloc] init];
        //        self.flIntroduceLabel.backgroundColor = [UIColor redColor];
        self.flIntroduceLabel.textAlignment = NSTextAlignmentCenter;
        self.flIntroduceLabel.font = [UIFont fontWithName:FL_FONT_NAME size:18];
        self.flIntroduceLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        [self.flSimpleView addSubview:self.flIntroduceLabel];
        [self.contentView addSubview:self.flSimpleView];
        
        //图标
        self.flCategorySmallImageView = [[UIImageView alloc] init];
        self.flCategorySmallImageView.image = [UIImage imageNamed:@"icon_fire_red_new"];//这是测试数据
        [self.flSimpleView addSubview:self.flCategorySmallImageView];
        //分类
        self.flCategoayLabellll = [[UILabel alloc] init];
        self.flCategoayLabellll.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        self.flCategoayLabellll.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        self.flCategoayLabellll.textAlignment = NSTextAlignmentLeft;
        [self.flSimpleView addSubview:self.flCategoayLabellll];
        //进度条
        self.flProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.flProgressView.layer.cornerRadius = XJ_PROGRESS_H/2;
        self.flProgressView.layer.masksToBounds = YES;
        self.flProgressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        self.flProgressView.progressTintColor = [UIColor colorWithHexString:XJ_FCOLOR_REDFONT];
        [self.contentView addSubview:self.flProgressView];
        //进度条描述
        self.flProgressIntroduceLabel = [[UILabel alloc] init];
        self.flProgressIntroduceLabel.textAlignment = NSTextAlignmentRight;
        self.flProgressIntroduceLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
        self.flProgressIntroduceLabel.textColor =  [[UIColor whiteColor] colorWithAlphaComponent:1];
        [self.flSimpleView addSubview:self.flProgressIntroduceLabel];
        
        //test
        //        [self testSomthing];
        //发布的分类：智能软件等
        self.xjLabelTopicType = [[XJCricleLabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
        //发布的分类：助力抢等
        self.xjLabelTopicCondition = [[XJCricleLabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
        self.xjLabelTopicCondition.xjTextColor = [UIColor whiteColor];
        self.xjLabelTopicType.xjTextColor = [UIColor whiteColor];
        self.xjLabelTopicType.xjBorderColor = [UIColor whiteColor];
        self.xjLabelTopicCondition.xjBackgroundColor = [UIColor colorWithHexString:@"ff5252"];
        [self.flSimpleView addSubview:self.xjLabelTopicType];
        [self.flSimpleView addSubview:self.xjLabelTopicCondition];
        
        [self makeConstraints];
        [self setUpData];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)makeConstraints
{
    //大标题
    [self.flIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flSimpleView).with.offset(view_custom_H * 0.14);
        make.centerX.equalTo(self.flSimpleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(0.9 * FLUISCREENBOUNDS.width, 30));
    }];
    //进度条
    [self.flProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flIntroduceLabel.mas_bottom).with.offset(view_custom_H * 0.3);
        make.centerX.equalTo(self.flSimpleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake( 0.68 * FLUISCREENBOUNDS.width - 35, XJ_PROGRESS_H));
    }];
    //热度的图标
    [self.flCategorySmallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flProgressView).with.offset(0);
        make.top.equalTo(self.flProgressView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    //热度的文本
    [self.flCategoayLabellll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flCategorySmallImageView.mas_right).with.offset(4);
        //        make.top.equalTo(self.flProgressView.mas_bottom).with.offset(10);
        make.centerY.equalTo(self.flCategorySmallImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 16));
    }];
    //进度条描述
    [self.flProgressIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flProgressView).with.offset(-12);
        make.centerX.equalTo(self.flSimpleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(0.68 * FLUISCREENBOUNDS.width- 35,12));
    }];
    //分类：助力抢等
    [self.xjLabelTopicCondition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.flProgressView.mas_right).with.offset(0);
        make.centerY.equalTo(self.flCategorySmallImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(50,14));
    }];
    //分类：智能软件等
    [self.xjLabelTopicType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xjLabelTopicCondition.mas_left).with.offset(-8);
        make.centerY.equalTo(self.flCategorySmallImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(50,14));
    }];
    
}

- (void)setUpData
{
    
    
}


- (void)setFlsquareConcouponseModel:(FLSquareConcouponseModel *)flsquareConcouponseModel {
    _flsquareConcouponseModel = flsquareConcouponseModel;
    [self settingDataInSquareCouponsCell];
}
//重写set 方法 赋值给cell
- (void)setXjCellModel:(XJVersionTwoCouponsModel *)xjCellModel {
    _xjCellModel = xjCellModel;
    if (xjCellModel) {
        [self xjSetInfoInCouponCell];
    }
    
}
//$$$$$$优惠券模型
- (void)settingDataInSquareCouponsCell {
    __weak typeof(self) weakSelf = self;
    self.flIntroduceBigImageView.contentMode = UIViewContentModeScaleToFill;
    self.flIntroduceLabel.text = _flsquareConcouponseModel.flTopicThemeStr;
    self.flCategoayLabellll.text  = _flsquareConcouponseModel.flfuckStr;
    flProgressValueLess = [_flsquareConcouponseModel.flNumberStr integerValue] - [_flsquareConcouponseModel.flProgressStrAlready integerValue];
    self.flProgressIntroduceLabel.text = [NSString stringWithFormat:@"已领%@张，剩余%ld张",_flsquareConcouponseModel.flProgressStrAlready,(long)flProgressValueLess];
    //    FL_Log(@"11111 = %@   ",_flsquareConcouponseModel.flfuckStr);
    CGFloat ss =  [_flsquareConcouponseModel.flProgressStrAlready floatValue] / [_flsquareConcouponseModel.flNumberStr floatValue];
    [self.flProgressView setProgress:ss];
    
    [self.flIntroduceBigImageView sd_setImageWithURL:[NSURL URLWithString:_flsquareConcouponseModel.flBackGroundImageStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.flSimpleView.backgroundColor = [FLSquareTools flMainColorWithImage:image];
    }];
}

- (void)xjSetInfoInCouponCell {
    __weak typeof(self) weakSelf = self;
    self.flIntroduceBigImageView.contentMode = UIViewContentModeScaleToFill;
    self.flIntroduceLabel.text = _xjCellModel.topicTheme;
    self.xjLabelTopicCondition.xjContentStr = [FLSquareTools returnConditionStrValueWithKey:_xjCellModel.topicConditionKey];  //获取助力抢等
    if (![XJFinalTool xjStringSafe:[FLSquareTools returnConditionStrValueWithKey:_xjCellModel.topicConditionKey]]) {
        self.xjLabelTopicCondition.hidden = YES;
    }
    self.flCategoayLabellll.text = [NSString stringWithFormat:@"%ld",_xjCellModel.pv];
    flProgressValueLess = _xjCellModel.topicNum- _xjCellModel.receiveNum;
    self.flProgressIntroduceLabel.text = [NSString stringWithFormat:@"%ld/%ld",_xjCellModel.receiveNum,_xjCellModel.topicNum];
    //    FL_Log(@"11111 = %@   ",_flsquareConcouponseModel.flfuckStr);
    CGFloat xjFloat =  [[NSString stringWithFormat:@"%ld",_xjCellModel.receiveNum] floatValue] / [[NSString stringWithFormat:@"%ld",_xjCellModel.topicNum] floatValue] ;
    [self.flProgressView setProgress:xjFloat];
    self.xjLabelTopicType.xjContentStr = _xjCellModel.topicTag;
    
    NSString* xjImageStr = _xjCellModel.thumbnail;
    if (![FLTool returnBoolWithIsHasHTTP:xjImageStr includeStr:@"http://"]&&xjImageStr) {
        xjImageStr = [FLBaseUrl stringByAppendingString:xjImageStr];
    }
    [self.flIntroduceBigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",xjImageStr]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.flSimpleView.backgroundColor = [FLSquareTools flMainColorWithImage:image];
    }];
    if (xjFloat==1 || ![FLTool returnBoolNumberWithCreatTime:_xjCellModel.endTime xjxjTime:_xjCellModel.xjServiceTime]) { //|| self.xjModel.endTime
        self.flCategorySmallImageView.image  = [UIImage imageNamed:@"icon_fire_gray_new"];
    } else {
        self.flCategorySmallImageView.image  = [UIImage imageNamed:@"icon_fire_red_new"];
    }
    
}


@end




















