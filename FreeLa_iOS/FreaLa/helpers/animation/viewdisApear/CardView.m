//
//  CardView.m
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "CardView.h"
#import "FLSquareTools.h"
#define xj_Image_W          (self.frame.size.width - 20)

@interface CardView()
{
    UIImageView* _xjHotImageView;
}


//@property (nonatomic , strong)UILabel*
/**助力抢？随心领？*/
@property (nonatomic ,strong) UIImageView * xjTopicConditionImageView;

@end
static CGRect xjViewFrame;
@implementation CardView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        xjViewFrame = frame;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imageView = [[UIImageView alloc]init];
    //    _imageView.backgroundColor = [UIColor orangeColor];
    
    //    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8);
    _imageView.frame = CGRectMake(10, 10, xj_Image_W, xj_Image_W);
    [self addSubview:_imageView];
    
    
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
    
    _selectedView = [[UIView alloc]init];
    _selectedView.frame = _imageView.frame;
    _selectedView.backgroundColor = [UIColor clearColor];
    _selectedView.alpha = 0.0;
    [_imageView addSubview:_selectedView];
    [self xjInitPageView];
    _label = [[UILabel alloc]init];
    _label.backgroundColor = [UIColor clearColor];
    //    _label.frame = CGRectMake(10, self.frame.size.height * 0.8, self.frame.size.width - 20, self.frame.size.height * 0.2);
    _label.frame = CGRectMake(10, 10 + xj_Image_W, xj_Image_W, 30);
    _label.font = [UIFont fontWithName:@"Futura-Medium" size:14];
    //    _label.layer.borderWidth = 1;
    //    _label.layer.borderColor = [UIColor grayColor].CGColor;
    //    _label.layer.cornerRadius = _label.frame.size.height / 2;
    //    _label.layer.masksToBounds = YES;
    
    //    [self addSubview:_label];
    
    //condition
    //    self.xjTopicConditionViewLabel = [[XJTopicConditionView alloc] initWithFrame:CGRectMake(12, 12, 80, 24)];
    //    self.xjTopicConditionViewLabel.xjFontSize = 10;
    //    self.xjTopicConditionViewLabel.xjBackImage = [UIImage imageNamed:@"icon_square_tool_bac_condition"];
    //    self.xjTopicConditionViewLabel.xjContentStr = @"助力抢";
    //    self.xjTopicConditionViewLabel.xjTextColor = [UIColor whiteColor];
    //    [self addSubview:self.xjTopicConditionViewLabel];
    
    self.xjTopicConditionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 80, 30)];
    [self addSubview:self.xjTopicConditionImageView];
    
}

- (void)xjInitPageView {
    //    UIView* xjBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 0.8, self.frame.size.width,self.frame.size.height * 0.2)];
    UIView* xjBottomView = [[UIView alloc] initWithFrame:CGRectMake(10, xj_Image_W -10, xj_Image_W,self.frame.size.height - xj_Image_W )];
    NSLog(@"sadadasdsada=%f == == =%f",self.frame.size.width,self.frame.size.height* 0.8);
    [self addSubview:xjBottomView];
    xjBottomView.backgroundColor = [UIColor whiteColor];
    self.xjTopicThemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, xjBottomView.width, 20)];
    //    self.xjTopicThemLabel.text = @"税务三，一把不是的晴雨伞";
    self.xjTopicThemLabel.font = [UIFont fontWithName:FL_FONT_NUMBER_NAME size:XJ_LABEL_SIZE_BIG];
    self.xjTopicThemLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [xjBottomView addSubview:self.xjTopicThemLabel];
    //进度条
    //    self.xjProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, xjBottomView.height - 15, self.frame.size.width * 0.3, 10)];
    self.xjProgressView = [[UIProgressView alloc] init];
    //    [self.xjProgressView setProgress:0.4];
    self.xjProgressView.trackTintColor = [UIColor groupTableViewBackgroundColor];
    self.xjProgressView.layer.cornerRadius = XJ_PROGRESS_H/2;
    self.xjProgressView.layer.masksToBounds = YES;
    self.xjProgressView.progressTintColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    [xjBottomView addSubview:self.xjProgressView];
    [self.xjProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(xjBottomView.height - 8));
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width * 0.3, XJ_PROGRESS_H));
    }];
    
    //进度 fengzhuang
    CGRect xjProgressSelfFrame = CGRectMake(12 + self.frame.size.width * 0.3, xjBottomView.height - 20, 30, 14);
    self.xjProgressLabelTotal = [[XJProGressLabel alloc] initWithFrame:xjProgressSelfFrame ProgressColor:[UIColor colorWithHexString:XJ_FCOLOR_REDFONT] BackColor:[UIColor colorWithHexString:@"999999"]];
    [xjBottomView addSubview:self.xjProgressLabelTotal];
    [self.xjProgressLabelTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xjProgressView.mas_right).with.offset(4);
        make.bottom.equalTo(xjBottomView);
        make.size.mas_equalTo(CGSizeMake(40, 14));
    }];
    
    
    
    //进度
    //    self.xjProgressLabel = [ [FLGrayLabel alloc] init ];
    //    self.xjProgressLabel.frame = CGRectMake(12 + self.frame.size.width * 0.3, xjBottomView.height - 20, 100, 14);
    //    self.xjProgressLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    //    self.xjProgressLabel.font = [UIFont fontWithName:FL_FONT_NUMBER_NAME size:XJ_LABEL_SIZE_SMALL];
    //    self.xjProgressLabel.text= @"11/100";
    //    [xjBottomView addSubview:self.xjProgressLabel];
    
    //分类
    CGFloat labelX = xjBottomView.width *0.6-10;
    CGFloat labelY = xjBottomView.height - 20 ;
    CGFloat labelW = xjBottomView.width *0.2;
    UIView* xjTypeView = [[UIView alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, 20)];
    [xjBottomView addSubview:xjTypeView];
    
    self.xjTopicTypeLabel = [[XJCricleLabel alloc] initWithFrame:CGRectMake(0, 0, 10,10)];
    self.xjTopicTypeLabel.xjTextColor =  [UIColor colorWithHexString:@"#999999"];
    self.xjTopicTypeLabel.xjBorderColor = [UIColor colorWithHexString:@"#999999"];
    self.xjTopicTypeLabel.xjFontSize = 12;
    //    self.xjTopicTypeLabel.xjContentStr = @"生活健康";
    [xjTypeView addSubview:self.xjTopicTypeLabel];
    
    //火
    UIView* xiHotView = [[UIView alloc]initWithFrame:CGRectMake(xjBottomView.width *0.8, labelY, xjBottomView.width * 0.2, 20)];
    [xjBottomView addSubview:xiHotView];
    _xjHotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_fire_red_new"]];//icon_fire_gray_new
    [xiHotView addSubview:_xjHotImageView];
    _xjHotImageView.frame = CGRectMake(0, 2, 16, 16);
    
    //热度
    self.xjHotLabel = [[FLGrayLabel alloc] initWithFrame:CGRectMake(22, 0, xiHotView.width - 22, 20)];
    self.xjHotLabel.text = @"123";
    self.xjHotLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [xiHotView addSubview:self.xjHotLabel];
}

- (void)setXjModel:(XJRecommendTopicListModel *)xjModel {
    _xjModel = xjModel;
    self.xjTopicThemLabel.text = self.xjModel.topicTheme; //主题
    CGFloat ff = [[NSString stringWithFormat:@"%ld",xjModel.receiveNum] floatValue] / [[NSString stringWithFormat:@"%ld",xjModel.topicNum] floatValue];
    NSString* xj = [FLTool getTheCorrectNum:[NSString stringWithFormat:@"%f",ff]];
    [self.xjProgressView  setProgress:[xj floatValue]];       //进度t条
    //    self.xjProgressLabelRed.text =[NSString stringWithFormat:@"%ld",xjModel.receiveNum];
    self.xjProgressLabel.text = [NSString stringWithFormat:@"%ld/%ld",xjModel.receiveNum,xjModel.topicNum];//  进度
    self.xjProgressLabelTotal.xjContent  = [NSString stringWithFormat:@"%ld/%ld",xjModel.receiveNum,xjModel.topicNum];//  进度
    
    self.xjTopicTypeLabel.xjContentStr  = self.xjModel.topicTag;// 分类
    self.xjHotLabel.text   = [NSString stringWithFormat:@"%ld",self.xjModel.pv];  // 热度
    //    self.xjTopicConditionViewLabel.xjContentStr = [FLSquareTools returnConditionStrValueWithKey:self.xjModel.topicCondition];  //condition之前的版本
    [self.xjTopicConditionImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_image",self.xjModel.topicCondition]]];
    
    if (ff==1 || ![FLTool returnBoolNumberWithCreatTime:self.xjModel.endTime xjxjTime:nil]) { //|| self.xjModel.endTime
         _xjHotImageView.image = [UIImage imageNamed:@"icon_fire_gray_new"];
    }
    
    
    if (xjModel.filePath2 &&xjModel.filePath2.length!=0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjModel.filePath2 isSite:NO]]]];
    } else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjModel.thumbnail isSite:NO]]]];
    }
}

- (void)xjSetEmptyImage:(UIImage*)xjImage {
    self.imageView.image = xjImage;
    self.imageView.frame = CGRectMake(0, 0, 140, 80);  //0, 0, self.frame.size.width, self.frame.size.height * 0.8
    self.imageView.center = CGPointMake(self.center.x, self.frame.size.height * 0.5 -40);
    self.xjProgressView.hidden = YES;
    self.xjHotLabel.hidden = YES;
    
}

@end




















