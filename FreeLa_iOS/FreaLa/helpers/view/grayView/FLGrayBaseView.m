//
//  FLGrayBaseView.m
//  FreeLa
//
//  Created by Leon on 16/1/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLGrayBaseView.h"


#define fl_view_image_W             FLUISCREENBOUNDS.width - FLUISCREENBOUNDS.width* 0.45
#define fl_view_btn_left_Margin     FLUISCREENBOUNDS.width * 0.2

/***********************************************************dsds*************************************************/
#define fl_viewT_top_MarginL        15    //大
#define fl_viewT_topMarginM         10   //小
#define fl_viewT_top_headerW        50
#define fl_viewT_nicklabel_H            21
#define fl_viewT_left_Margin         10
//字体大小
#define fl_label_size_L             12
#define fl_label_size_M             10
//基本view总高度
#define fl_viewT_total_customViewH   (fl_viewT_top_MarginL + fl_viewT_topMarginM  + fl_viewT_nicklabel_H + fl_viewT_top_headerW)
//左边label宽
#define fl_perView_label_Left_W     80
#define fl_view_total_H          _flPersonalViewTotalH + fl_viewT_total_customViewH    //除button 高度
#define fl_bottom_btn_H         44


@interface FLGrayBaseView ()<UIGestureRecognizerDelegate>

/**返回按钮*/
@property (nonatomic , strong) UIButton* flGoBackBtn;
/**保存到本地按钮*/
@property (nonatomic , strong) UIButton* flSaveBtn;
/**转发按钮*/
@property (nonatomic , strong) UIButton* flRelayBtn;

/***********************************************************dsds*************************************************/

/**浮层*/
@property (nonatomic , strong) UIView* flbackView;
/**头像*/
@property (nonatomic , strong) UIImageView* flHeaderImageView;
/**昵称*/
@property (nonatomic , strong) UILabel* flnickNameLabel;
/**自定义view的高度*/
@property (nonatomic , assign) CGFloat flPersonalViewTotalH;
/**关闭按钮*/
@property (nonatomic , strong) UIButton* flCloseBtn;
@end
static CGRect viewTFrame,viewTTopFrame,viewBottomFrame;  //整体、top 、底部按钮     frame
@implementation FLGrayBaseView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setFlTopicId:(NSString *)flTopicId{
    _flTopicId = flTopicId;
    //    [self createErWeiMaInGrayView];
    
    
}

- (void)createErWeiMaInGrayViewWithStr:(NSString*)str
{
    
    NSString* xjbaseUrl = @"www.freela.com.cn";
    NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@/transpond/transpond!isTranspond.action?topic.topicId=%@",FLBaseUrl,str];
    //生成text.text二维码
    NSError* error = nil;
//    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
//    ZXEncodeHints* hints = [ZXEncodeHints hints];
//    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];
//    hints.encoding = NSUTF8StringEncoding;//使用中文
//    str = [NSString stringWithFormat:@"%@",str];
//    ZXBitMatrix* result = [writer encode:xjRelayContentStr format:kBarcodeFormatQRCode width:800 height:800 hints:hints error:&error];
    [self xj_yuanshengerweima:str];
//    if (result) {
//        CGImageRef image    =    [[ZXImage imageWithMatrix:result]cgimage];
//        UIImage   *image1   =    [UIImage imageWithCGImage:image];//二维码原图
//        UIImage   *subImage =    [UIImage imageNamed:@"icon_erweima_middle"];
//        UIImage   *image2   =    [self addSubImage:image1 sub:subImage];//给二维码里加图标，长款最好为原图的1/4,这样不妨碍二维码识别
//        self.flErWeiMaImageView.image = image2;
//        
//        self.flErWeiMaImageView.contentMode = UIViewContentModeScaleToFill;
//        //This CGImageRef image can be placed in a UIImage,NSImage,or written to a file.
//        
//    }else{
//        NSString* errorMessage = [error localizedDescription];
//        FL_Log(@"error message in gray view erweima =%@",errorMessage);
//    }
    
}

- (void)xj_yuanshengerweima:(NSString*)mabi {
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSString *dataString = mabi;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    self.flErWeiMaImageView.image=[self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:fl_view_image_W];

//    self.flErWeiMaImageView.image = [UIImage imageWithCGImage:scaledImage];
    self.flErWeiMaImageView.contentMode = UIViewContentModeCenter;
}
- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(UIImage*)addSubImage:(UIImage*)img sub:(UIImage*)subImage{
    
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int subWidth = subImage.size.width;
    int subHeight = subImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //creat a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake((w - subWidth)/2, (h - subHeight)/2, subWidth, subHeight), [subImage CGImage]);
    CGImageRef imageMasked =  CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
}
//生成二维码界面
- (instancetype)initWithInfo:(NSString*)infoStr delegate:(id)delegate
{
    self = [[FLGrayBaseView alloc]initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    //增加屏幕点击手势按钮
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flGrayViewGoBack)];
    tapGR.delegate = self;
    [self addGestureRecognizer:tapGR];
    
    //图
    self.flErWeiMaImageView = [[UIImageView alloc] init];
    [self createErWeiMaInGrayViewWithStr:infoStr];
    //返回
    self.flGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flGoBackBtn.frame = CGRectMake(30, 50, 40, 40);
    [self.flGoBackBtn setImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
    [self.flGoBackBtn addTarget:self action:@selector(flGrayViewGoBack) forControlEvents:UIControlEventTouchUpInside];
    //保存到本地
    self.flSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flSaveBtn setTitle:@"保存到本地" forState:UIControlStateNormal];
    self.flSaveBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.flSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.flSaveBtn.layer.cornerRadius = 15;
    self.flSaveBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flSaveBtn.layer.masksToBounds = YES;
    [self.flSaveBtn addTarget:self action:@selector(flGrayViewSaveErWeiMaInLocation) forControlEvents:UIControlEventTouchUpInside];
    //转发
    self.flRelayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flRelayBtn setTitle:@"转发" forState:UIControlStateNormal];
    [self.flRelayBtn setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    self.flRelayBtn.layer.cornerRadius = 15;
    self.flRelayBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flRelayBtn.layer.masksToBounds = YES;
    [self.flRelayBtn addTarget:self action:@selector(flGrayViewRelayTopicAvtivityToFriends) forControlEvents:UIControlEventTouchUpInside];
    
    [self addViewInGrayView];
    self.delegate = delegate;
    return self;
}

- (void)addViewInGrayView
{
    [self addSubview:self.flErWeiMaImageView];  //图
    [self addSubview:self.flGoBackBtn];         //返回
    [self addSubview:self.flRelayBtn];     //转发
    [self addSubview:self.flSaveBtn];      //保存
    
    [self makeConstraintsInGrayView];
}

- (void)addViewInGrayViewWithSaoMiaoType
{
    //    [self addSubview:self.flErWeiMaImageView];
}

- (void)makeConstraintsInGrayView
{
    //图片
    [self.flErWeiMaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(0);
        make.centerY.equalTo(self).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(fl_view_image_W, fl_view_image_W));
    }];
    //保存
    [self.flSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flErWeiMaImageView.mas_bottom).with.offset(30);
        make.left.equalTo(self).with.offset(fl_view_btn_left_Margin);
        make.width.equalTo(self.flRelayBtn).with.offset(0);
        make.height.equalTo(self.flRelayBtn).with.offset(0);
    }];
    //转发
    [self.flRelayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flErWeiMaImageView.mas_bottom).with.offset(30);
        make.left.equalTo(self.flSaveBtn.mas_right).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-fl_view_btn_left_Margin);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma  mark  delegate
/**返回*/
- (void)flGrayViewGoBack
{
    [self removeFromSuperview];
}
/**保存到本地*/
- (void)flGrayViewSaveErWeiMaInLocation
{
    FL_Log(@"save erweima in delegate");
    [self.delegate flGrayViewSaveErWeiMaInLocationWithImage:self.flErWeiMaImageView.image];
}
/**转发*/
- (void)flGrayViewRelayTopicAvtivityToFriends
{
    FL_Log(@"relay erweima in delegate");
    [self.delegate flGrayViewRelayTopicAvtivityToFriendsWithImage:self.flErWeiMaImageView.image];
}

#pragma mark 扫描回调

/***********************************************************dsds*************************************************/
- (void)setFlmodel:(FLMyIssueReceiveModel *)flmodel{
    _flmodel = flmodel;
    [self setInfoInTViewGrayView];
}

- (void)setFlDataDic:(NSDictionary *)flDataDic{
    NSString* str = flDataDic[@"message"];
    NSDictionary* dic = [FLTool returnDictionaryWithJSONString:str];
    _flDataDic = dic;
    [self setPersonalUIInGrayView];
    
}

#pragma mark 创建tablview 点击参与浮层
- (instancetype)initWithFLMyIssueReceiveModeldelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self = [[FLGrayBaseView alloc]initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //增加屏幕点击手势按钮
        UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flGrayViewGoBack)];
        tapGR.delegate = self;
        [self addGestureRecognizer:tapGR];
        
        viewTFrame.origin.x = FLUISCREENBOUNDS.width * 0.15;
        viewTFrame.origin.y = FLUISCREENBOUNDS.height* 0.3;
        viewTFrame.size.width = FLUISCREENBOUNDS.width * 0.7;
        viewTFrame.size.height = FLUISCREENBOUNDS.height * 0.4;
        self.flbackView = [[UIView alloc] initWithFrame:viewTFrame];
        self.flbackView.center = self.center;
        self.flbackView.backgroundColor = [UIColor whiteColor];
        viewTFrame = self.flbackView.frame;
        viewBottomFrame = viewTFrame;
        //头像
        viewTTopFrame.origin.x = (viewTFrame.size.width / 2) - (fl_viewT_top_headerW / 2);
        viewTTopFrame.origin.y = fl_viewT_top_MarginL;
        viewTTopFrame.size.width = fl_viewT_top_headerW;
        viewTTopFrame.size.height = fl_viewT_top_headerW;
        self.flHeaderImageView = [[UIImageView alloc] initWithFrame:viewTTopFrame];
        
        self.flHeaderImageView.layer.cornerRadius = fl_viewT_top_headerW/2;
        self.flHeaderImageView.layer.masksToBounds = YES;
        //昵称
        viewTTopFrame.origin.x = fl_viewT_left_Margin;
        viewTTopFrame.origin.y += fl_viewT_top_headerW + fl_viewT_topMarginM;
        viewTTopFrame.size.width = viewTFrame.size.width - 2 * fl_viewT_left_Margin;
        viewTTopFrame.size.height = fl_viewT_nicklabel_H;
        self.flnickNameLabel = [[UILabel alloc] initWithFrame:viewTTopFrame];
        self.flnickNameLabel.font = [UIFont fontWithName:FL_FONT_NAME size:fl_label_size_L];
        self.flnickNameLabel.textAlignment = NSTextAlignmentCenter;
        self.flnickNameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addTViewInGrayView];
        
        
    }
    return self;
}

- (void)setPersonalUIInGrayView
{
    //循环添加值
    NSArray* dicValueArray =   [_flDataDic allValues];
    NSArray* dicKeyArray   =  [_flDataDic allKeys];
    
    
    CGFloat labelLX = fl_viewT_left_Margin;
    CGFloat labelLY = fl_viewT_total_customViewH - fl_viewT_topMarginM;
    CGFloat labelLH = fl_viewT_nicklabel_H;
    CGFloat labelLW = fl_perView_label_Left_W;
    
    CGFloat labelRX = 2 * fl_viewT_left_Margin + fl_perView_label_Left_W;
    CGFloat labelRW = viewTFrame.size.width - 3 * fl_viewT_left_Margin -  fl_perView_label_Left_W ;
    CGFloat labelRY = fl_viewT_total_customViewH - fl_viewT_topMarginM;
    for (NSInteger i = 0; i < dicValueArray.count; i++)
    {
        //左
        labelLY +=  fl_viewT_topMarginM + fl_viewT_nicklabel_H;
        
        FLGrayLabel * labelLeft = [[FLGrayLabel alloc] initWithFrame:CGRectMake(labelLX, labelLY, labelLW, labelLH)];
        labelLeft.text = dicKeyArray[i];
        labelLeft.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        [self.flbackView addSubview:labelLeft];
        
        //右
        //        labelRY +=  fl_viewT_topMarginM + fl_viewT_nicklabel_H;
        FLGrayLabel* labelRight = [[FLGrayLabel alloc] initWithFrame:CGRectMake(labelRX, labelLY, labelRW, labelLH)];
        labelRight.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        if ([[dicValueArray[i] class] isSubclassOfClass:[NSNumber class]]) {
            NSString* fuck = [dicValueArray[i] stringValue];
            labelRight.text = fuck;
        } else {
            labelRight.text = dicValueArray[i];
            [self.flbackView addSubview:labelRight];
            
        }
    }
    _flPersonalViewTotalH = fl_viewT_topMarginM * (dicValueArray.count + 2) + fl_viewT_nicklabel_H *  dicValueArray.count;
    viewTFrame.size.height = fl_view_total_H + fl_bottom_btn_H + fl_viewT_topMarginM;
    self.flbackView.frame = viewTFrame;
    self.flbackView.center = self.center;
    
    //关闭按钮
    viewBottomFrame.origin.x = 0;
    viewBottomFrame.origin.y = fl_view_total_H + fl_viewT_topMarginM;
    viewBottomFrame.size.height = fl_bottom_btn_H;
    self.flCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flCloseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.flCloseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.flCloseBtn.frame = viewBottomFrame;
    //    [self.flCloseBtn setBackgroundImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forState:UIControlStateNormal];
    self.flCloseBtn.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDFONT);
    [self.flCloseBtn addTarget:self action:@selector(flGrayViewGoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.flbackView addSubview:self.flCloseBtn];
    [self setInfoInTViewGrayView];
    
}

- (void) addTViewInGrayView {
    [self addSubview:self.flbackView];
    [self.flbackView addSubview:self.flHeaderImageView];
    [self.flbackView addSubview:self.flnickNameLabel];
}

- (void)setInfoInTViewGrayView {
    [self.flHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_flmodel.avatar]]]; //头像
    self.flnickNameLabel.text = _flmodel.nickname;
}

- (NSArray*)xjKeyArrayWithArr:(NSArray*)xjarr {
    NSMutableArray* arr = @[].mutableCopy;
    for (NSInteger i = 0; i < xjarr.count; i++) {
        NSDictionary* dic = xjarr[i];
        [arr.mutableCopy addObject:dic.allKeys];
    }
    
    return arr.mutableCopy;
}


- (NSArray*)xjValueArrayWithArr:(NSArray*)xjarr
{
    NSMutableArray* arr = @[].mutableCopy;
    for (NSInteger i = 0; i < xjarr.count; i++) {
        NSDictionary* dic = xjarr[i];
        [arr.mutableCopy addObject:dic.allValues];
    }
    
    return arr.mutableCopy;
}


@end














