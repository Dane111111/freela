//
//  FLMyReceiveTicketView.m
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyReceiveTicketView.h"

#import "FLMineTools.h"

#define flViewframe_W           FLUISCREENBOUNDS.width * 0.8
#define flViewframe_H           (FLUISCREENBOUNDS.height - StatusBar_NaviHeight - FL_TopColumnView_Height_S)* 0.9


@interface FLMyReceiveTicketView ()
{
    UIView* _firstLine;
    UIView* _secondLine;
}


/**头像imageView*/
@property (nonatomic , strong) UIImageView* flheadImageView;
/**使用状态imageView*/
@property (nonatomic , strong) UIImageView* flStateImageView;
/**昵称*/
@property (nonatomic , strong) FLGrayLabel* flnickLabel;
/**描述*/
@property (nonatomic , strong) FLGrayLabel* flDescribeLabel;
/**使用说明*/
@property (nonatomic , strong) FLGrayLabel* flIntroduceLabel;

/**开始时间(拼错，sorry)*/
@property (nonatomic , strong) FLGrayLabel* flEndTimeLabel;
/**过期时间 ) */
@property (nonatomic , strong) FLGrayLabel* xjEndTimeLabel;
/**二维码*/
@property (nonatomic , strong) UIImageView* flEWMImageView;
/**使用说明label*/
@property (nonatomic , strong) FLGrayLabel* xjuseLabel;

/**啊啊啊*/
@property (nonnull , strong) UITextView* xjTextView;


@property (nonatomic , strong) FLGrayLabel* xjTicketNumberLabel;

@end



static CGRect Viewframe ,baseViewFrame,detailFrame,headImageFrame,xjIntroduceLabelFreme;
@implementation FLMyReceiveTicketView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        Viewframe = CGRectZero;
        Viewframe.origin.x = 0;
        Viewframe.origin.y =  10 ;
        Viewframe.size.width = FLUISCREENBOUNDS.width;
        Viewframe.size.height = FLUISCREENBOUNDS.height - StatusBar_NaviHeight  ;
        self.frame = Viewframe;
        self.flCheckDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imagesURLStrings = [NSMutableArray array];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self creatBaseUIInReceiveTicketView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donNotShowKeyBoard) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}
//券码
- (void)setXjTicketNumberModel:(XJTicketNumberModel *)xjTicketNumberModel {
    _xjTicketNumberModel = xjTicketNumberModel;
    [self setInfoInMyReceiveView];
}

- (void)setFlMineInfoModel:(FLMineInfoModel *)flMineInfoModel
{
    _flMineInfoModel = flMineInfoModel;
    NSString* xjAvatar = _flMineInfoModel.avatar;
    if (![FLTool returnBoolWithIsHasHTTP:xjAvatar includeStr:@"http://"] && xjAvatar) {
        xjAvatar = [FLBaseUrl stringByAppendingString:xjAvatar];
    }
    [self.flheadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",xjAvatar]]];
    self.flnickLabel.text = _flMineInfoModel.nickname;
    self.flDescribeLabel.text = _flMineInfoModel.fldescription;
}

- (void)setFlMyReceiveInMineModel:(FLMyReceiveListModel *)flMyReceiveInMineModel
{
    _flMyReceiveInMineModel = flMyReceiveInMineModel;
    [self setInfoInMyReceiveView];
    [self createEWMUIInMyReceiveVCWithInfo:_flMyReceiveInMineModel.flDetailsIdStr];
}

#pragma mark Base UI
- (void)creatBaseUIInReceiveTicketView
{
    baseViewFrame.origin.x = FLUISCREENBOUNDS.width * 0.1;
    baseViewFrame.origin.y = (FLUISCREENBOUNDS.height - StatusBar_NaviHeight - FL_TopColumnView_Height_S)* 0.05;
    baseViewFrame.size.width = flViewframe_W;
    baseViewFrame.size.height = flViewframe_H;
    xjIntroduceLabelFreme = baseViewFrame;
    self.flBaseImageView = [[UIImageView alloc] initWithFrame:baseViewFrame];
    self.flBaseImageView.backgroundColor = [UIColor whiteColor];
//    self.flBaseImageView.image = [UIImage imageNamed:@"imageView_piaoquan_white"];
    
    //头像
    detailFrame.origin.x = flViewframe_W * 0.1;
    detailFrame.origin.y = flViewframe_H * 0.1;
    detailFrame.size.width = flViewframe_W * 0.2;
    detailFrame.size.height = flViewframe_W* 0.2;
    headImageFrame = detailFrame;
    self.flheadImageView = [[UIImageView alloc] initWithFrame:detailFrame];
    self.flheadImageView.layer.cornerRadius = flViewframe_W * 0.1;
    self.flheadImageView.layer.masksToBounds = YES;
    
    //使用状态图标
    CGRect frameState = CGRectZero;
    frameState.origin.x = flViewframe_W * 0.7;
    frameState.origin.y = flViewframe_H * 0.1;
    frameState.size.width = flViewframe_W * 0.2;
    frameState.size.height = flViewframe_W * 0.2;
    self.flStateImageView = [[UIImageView alloc] initWithFrame:frameState];
    self.flStateImageView.hidden = YES;
    
    //昵称
    detailFrame.origin.x  += detailFrame.size.width + 10;
    detailFrame.origin.y  += 10;
    detailFrame.size.width = 200;
    detailFrame.size.height = 21;
    self.flnickLabel = [[FLGrayLabel alloc] initWithFrame:detailFrame];
    self.flnickLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    //一句话描述
    detailFrame.origin.y += detailFrame.size.height + 5;
    detailFrame.size.width = flViewframe_W * 0.6 ;
    detailFrame.size.height = 40;
    self.flDescribeLabel = [[FLGrayLabel alloc] initWithFrame:detailFrame];
    self.flDescribeLabel.numberOfLines = 2;
    self.flDescribeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    
    //开始时间
    detailFrame.origin.x = flViewframe_W * 0.1;
    detailFrame.origin.y += 40;
    detailFrame.size.width = 200;
    self.flEndTimeLabel = [[FLGrayLabel alloc] initWithFrame:detailFrame];
    self.flEndTimeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    
    //分割线
    detailFrame.origin.y += detailFrame.size.height;
    detailFrame.origin.x = 10;
    detailFrame.size.width = flViewframe_W - 20;
    detailFrame.size.height = 1;
    _firstLine = [[UIView alloc] initWithFrame:detailFrame];
    _firstLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    
    //二维码
    detailFrame.origin.x = flViewframe_W * 0.2;
    detailFrame.origin.y += 15;
    detailFrame.size.width = flViewframe_W * 0.6;
    detailFrame.size.height = flViewframe_W * 0.6;
    self.flEWMImageView = [[UIImageView alloc] initWithFrame:detailFrame];
    self.flEWMImageView.backgroundColor = [UIColor redColor];

   
    //过期时间
    detailFrame.origin.x = 0;
    detailFrame.origin.y += detailFrame.size.height ;
    detailFrame.size.width = flViewframe_W ;
    detailFrame.size.height = 16;
    self.xjEndTimeLabel = [[FLGrayLabel alloc] initWithFrame:detailFrame];
    self.xjEndTimeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.xjEndTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    //券码
    CGRect xjTicketFrame = detailFrame;
    xjTicketFrame.origin.y -= 16;
    self.xjTicketNumberLabel = [[FLGrayLabel alloc] initWithFrame:xjTicketFrame];
    self.xjTicketNumberLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.xjTicketNumberLabel.textAlignment = NSTextAlignmentCenter;
    
    //分割线
    detailFrame.origin.x = 20;
    detailFrame.origin.y += detailFrame.size.height + 10;
    detailFrame.size.width = flViewframe_W - 40;
    detailFrame.size.height = 1;
    _secondLine = [[UIView alloc] initWithFrame:detailFrame ];
    _secondLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    
    //使用按钮
    detailFrame.origin.x = flViewframe_W * 0.1;
    detailFrame.origin.y += 10;
    detailFrame.size.width = 60;
    detailFrame.size.height = 16;
    self.xjUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjUseBtn.frame = detailFrame;
    [self.xjUseBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    self.xjUseBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.xjUseBtn.layer.cornerRadius = 8;
    self.xjUseBtn.layer.masksToBounds = YES;
    [self.xjUseBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    self.xjUseBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
 
    
    //使用说明label
    detailFrame.origin.y += 5 + 16;
    detailFrame.size.width = 60;
    detailFrame.size.height = 16;
    _xjuseLabel = [[FLGrayLabel alloc] initWithFrame:detailFrame];
    _xjuseLabel.text = @"使用说明:";
    _xjuseLabel.layer.cornerRadius = 8;
    _xjuseLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    _xjuseLabel.layer.masksToBounds = YES;
    
    
    //使用说明
    detailFrame.origin.x = flViewframe_W * 0.1;
    detailFrame.origin.y += 10 + 16;
    detailFrame.size.width = flViewframe_W * 0.8;
    detailFrame.size.height = flViewframe_H * 0.2 - 15;
    self.flIntroduceLabel = [[FLGrayLabel alloc] initWithFrame:detailFrame];
//    self.flIntroduceLabel.backgroundColor = [UIColor redColor];
    self.flIntroduceLabel.textAlignment = NSTextAlignmentLeft;
    self.flIntroduceLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flIntroduceLabel.numberOfLines = 0;

    
    self.xjTextView = [[UITextView alloc] initWithFrame:detailFrame];
    self.xjTextView.textAlignment = NSTextAlignmentLeft;
    self.xjTextView.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
//    self.xjTextView.userInteractionEnabled = NO;
    self.xjTextView.showsVerticalScrollIndicator = NO;
    
    [self addViewInMyReceiveView];
}

- (void)addViewInMyReceiveView
{
    [self addSubview:self.flBaseImageView];
    self.flBaseImageView.userInteractionEnabled = YES;
    [self.flBaseImageView addSubview:self.flheadImageView];
    [self.flBaseImageView addSubview:self.flStateImageView];
    [self.flBaseImageView addSubview:self.flnickLabel];
    [self.flBaseImageView addSubview:self.flDescribeLabel];
    [self.flBaseImageView addSubview:self.flEndTimeLabel];
    [self.flBaseImageView addSubview:_firstLine];
    [self.flBaseImageView addSubview:self.flEWMImageView];
    [self.flBaseImageView addSubview:_secondLine];
    [self.flBaseImageView addSubview:self.flIntroduceLabel];
    [self.flBaseImageView addSubview:_xjuseLabel];
    [self.flBaseImageView addSubview:_xjUseBtn];
    [self.flBaseImageView addSubview:self.xjEndTimeLabel];
    [self.flBaseImageView addSubview:self.xjTicketNumberLabel];
    
//    [self.flBaseImageView addSubview:self.xjTextView];
    
    
    [self setInfoInMyReceiveView];
}


- (void)setInfoInMyReceiveView
{
//    _flMyReceiveInMineModel
    //使用状态 0 为未使用
    if (_flMyReceiveInMineModel.flStateInt == 0) {
        self.flStateImageView.hidden = YES;
    } else {
        self.flStateImageView.hidden = NO;
         self.flStateImageView.image = [UIImage imageNamed:@"ticket_already"];
    }
    if (self.flMyReceiveInMineModel.xjUseTime&&self.flMyReceiveInMineModel.xjUseTime.length!=0) {
         self.flEndTimeLabel.text = [NSString stringWithFormat:@"使用时间: %@",_flMyReceiveInMineModel.xjUseTime];
    } else {
//       self.flEndTimeLabel.text = [NSString stringWithFormat:@"领取时间: %@",_flMyReceiveInMineModel.flTimeBegan];
    }
   
  
    self.xjEndTimeLabel.text = [NSString stringWithFormat:@"过期时间: %@",_flMyReceiveInMineModel.xjinvalidTime ? _flMyReceiveInMineModel.xjinvalidTime :@"长期"];
   
    self.flIntroduceLabel.text = [NSString stringWithFormat:@"%@",_flMyReceiveInMineModel.flIntroduceStr];
    if([_flMyReceiveInMineModel.flIntroduceStr isEqualToString:@""] || !_flMyReceiveInMineModel.flIntroduceStr) {
        _xjuseLabel.text = @"";
    }
//    self.xjTextView.text = [NSString stringWithFormat:@"%@",_flMyReceiveInMineModel.flIntroduceStr];
    self.flIntroduceLabel.text = [NSString stringWithFormat:@"%@",_flMyReceiveInMineModel.flIntroduceStr];
    CGSize flsize = [FLMineTools returnLabelSizeWithString:self.flIntroduceLabel.text viewWidth:flViewframe_W * 0.8];
    self.flIntroduceLabel.size = flsize;
//    CGRect xjframe = self.flBaseImageView.frame;
    xjIntroduceLabelFreme.size.height += flsize.height;
    self.flBaseImageView.frame = xjIntroduceLabelFreme;
    
    self.xjTicketNumberLabel.text = [NSString stringWithFormat:@"%@%@",_xjTicketNumberModel.cardnum ?@"券      码: ":@"",_xjTicketNumberModel.cardnum ? _xjTicketNumberModel.cardnum : @""];
    
}


- (void)createEWMUIInMyReceiveVCWithInfo:(NSString*)str
{
//    //生成text.text二维码
//    NSError* error = nil;
//    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
//    ZXEncodeHints* hints = [ZXEncodeHints hints];
//    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];
//    hints.encoding = NSUTF8StringEncoding;//使用中文
//    str = [NSString stringWithFormat:@"%@",str];
//    ZXBitMatrix* result = [writer encode:str format:kBarcodeFormatQRCode width:800 height:800 hints:hints error:&error];
//    if (result) {
//        CGImageRef image    =    [[ZXImage imageWithMatrix:result]cgimage];
//        UIImage   *image1   =    [UIImage imageWithCGImage:image];//二维码原图
//        UIImage   *subImage =    [UIImage imageNamed:@"icon_erweima_middle"];
//        UIImage   *image2   =    [self addSubImage:image1 sub:subImage];//给二维码里加图标，长款最好为原图的1/4,这样不妨碍二维码识别
//        self.flEWMImageView.image = image2;
//        self.flEWMImageView.contentMode = UIViewContentModeScaleToFill;
//        
//    }else{
//        NSString* errorMessage = [error localizedDescription];
//        FL_Log(@"error message in gray view erweima =%@",errorMessage);
//    }
   [self xj_yuanshengerweima:str];
    
}

- (void)xj_yuanshengerweima:(NSString*)mabi {
    
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //过滤器恢复默认
    [filter setDefaults];
    
    //给过滤器添加数据
    NSString *string = [NSString stringWithFormat:@"%@",mabi];
    
    //将NSString格式转化成NSData格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    
    //将获取到的二维码添加到imageview上
    self.flEWMImageView.image = [UIImage imageWithCIImage:image];
    self.flEWMImageView.contentMode = UIViewContentModeScaleToFill;
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

- (void)donNotShowKeyBoard {
    [self endEditing:YES];
    [self.xjTextView resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}


@end























