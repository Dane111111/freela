//
//  HJOUI.m
//  FreeLa
//
//  Created by Leon on 16/7/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMyTicketView.h"
//#import <ZXingObjC/ZXingObjC.h>
#import "FLMineTools.h"

#define xj_bac_image_top_h              (xj_base_view_w * 57/960)
#define xj_bac_image_bottom_h           (xj_base_view_w * 57/960)
#define xj_bac_image_middle_h           (xj_base_view_w * 110/960)
//#define xj_bac_image_white_h            (40)

#define xj_base_view_w              (FLUISCREENBOUNDS.width - 40)
#define xj_base_view_h              (FLUISCREENBOUNDS.height * 0.6)

#define xj_header_image_w           50
#define xj_state_image_w            60
#define xj_left_right_margin        20

@interface XJMyTicketView ()
{
    UIView* _xjExplainView;    // 使用说明view
    FLGrayLabel* _xjExplainLabel; //使用说明label
    UIImageView*  _xjHeaderImageView; //头像
    UIImageView*  _xjStateImageView; //使用状态imageView
    FLGrayLabel* _xjNickLabel;      //昵称
    FLGrayLabel* _xjDescribeLabel;   //描述
    UILabel*   _xjTimeLabelUse;  // 使用时间&领取时间
    UILabel*   _xjTimeLabelGQ;  //  过期时间
    UIButton*  _xjUseBtn;//直接使用
    UIImageView* _xjEWMImageView;;//二维码view
    UILabel* _xjTikcketNumLabel;//券码
    UIButton* _xjCopyBtn;//复制
}

@end

@implementation XJMyTicketView

- (instancetype)initWithFrame:(CGRect)frame userId:(NSString*)xjUserId
{
    self = [super init];
    if (self) {
        [self xjInitPage];
    }
    return self;
}
- (instancetype)initWithUserId:(NSString*)xjUserId {
    self = [super init];
    if (self) {
        [self xjInitPage];
    }
    return self;
}

- (void)xjInitPage {
    //ding
    UIImageView* xjTopBase = [[UIImageView alloc] init];
    xjTopBase.image = [UIImage imageNamed:@"tuoyuanbg_top"];
    [self addSubview:xjTopBase];
    [xjTopBase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(xj_base_view_w, xj_bac_image_top_h));
    }];
    
    //中间白底
    UIView* xjWhiteView = [[UIView alloc] init];
    [self addSubview:xjWhiteView];
    xjWhiteView.backgroundColor = [UIColor whiteColor];
    [xjWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@xj_bac_image_top_h);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(xj_base_view_w, xj_base_view_h));
    }];
    //中偶见圆弧
    UIImageView * xjMiddleImageBase = [[UIImageView alloc] init];
    xjMiddleImageBase.image = [UIImage imageNamed:@"tuoyuanbg_middle"];
    [self addSubview:xjMiddleImageBase];
    [xjMiddleImageBase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xjWhiteView.mas_bottom).offset(0);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(xj_base_view_w, xj_bac_image_middle_h));
    }];
    //灰线
    UIView* xjLine  = [[UIView alloc] init];
    [xjMiddleImageBase addSubview:xjLine];
    xjLine.frame = CGRectMake(xj_left_right_margin, xj_bac_image_middle_h/2, xj_base_view_w - 2*xj_left_right_margin, 1);
    xjLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    //使用说明view
    _xjExplainView = [[UIView alloc] init];
    _xjExplainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_xjExplainView];
    [_xjExplainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xjMiddleImageBase.mas_bottom).offset(0);
        make.left.equalTo(@0);
        //size 随后再说
    }];
    
    //底部image
    UIImageView * xjBottomImageBase = [[UIImageView alloc] init];
    xjBottomImageBase.image = [UIImage imageNamed:@"tuoyuanbg_bottom"];
    [self addSubview:xjBottomImageBase];
    [xjBottomImageBase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_xjExplainView.mas_bottom).offset(0);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(xj_base_view_w, xj_bac_image_bottom_h));
    }];
    
     //头像
    _xjHeaderImageView = [[UIImageView alloc] init];
    _xjHeaderImageView.layer.cornerRadius = xj_header_image_w /2;
    _xjHeaderImageView.layer.masksToBounds = YES;
    [xjWhiteView addSubview:_xjHeaderImageView];
    _xjHeaderImageView.frame = CGRectMake(xj_left_right_margin, 0, xj_header_image_w, xj_header_image_w);
//    _xjHeaderImageView.backgroundColor = [UIColor redColor];
    //nicheng
    _xjNickLabel = [[FLGrayLabel alloc] init];
    [xjWhiteView addSubview:_xjNickLabel];
    _xjNickLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    _xjNickLabel.frame = CGRectMake(xj_left_right_margin+xj_header_image_w + 10, xj_header_image_w/2 -15, 200, 20);
    //使用状态
    _xjStateImageView = [[UIImageView alloc] init];
    _xjStateImageView.frame = CGRectMake(xj_base_view_w - xj_state_image_w -10, 0, xj_state_image_w, xj_state_image_w);
//    _xjStateImageView.backgroundColor = [UIColor redColor];
    _xjStateImageView.layer.cornerRadius = xj_state_image_w /2;
    _xjStateImageView.layer.masksToBounds = YES;
    _xjStateImageView.hidden = YES;
    _xjStateImageView.image = [UIImage imageNamed:@"ticket_already"];
    [xjWhiteView addSubview:_xjStateImageView];
    
    //个性说明
    _xjDescribeLabel = [[FLGrayLabel alloc] init];
//    [xjWhiteView addSubview:_xjDescribeLabel];
    _xjDescribeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    
    _xjDescribeLabel.frame = CGRectMake(xj_left_right_margin, xj_header_image_w+5, 200, 20);
  
    //使用时间&领取时间
    _xjTimeLabelUse = [[UILabel alloc] init];
    [xjWhiteView addSubview:_xjTimeLabelUse];
    _xjTimeLabelUse.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    _xjTimeLabelUse.frame = CGRectMake(xj_left_right_margin, xj_header_image_w+10, 300, 20);
    [xjWhiteView addSubview:_xjTimeLabelUse];
    UIView* xjLineUp = [[UIView alloc] init];
    xjLineUp.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    [xjWhiteView addSubview:xjLineUp];
    [xjLineUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_xjTimeLabelUse.mas_bottom).offset(10);
        make.left.equalTo(xjWhiteView).offset(0);
        make.size.mas_equalTo(CGSizeMake(xj_base_view_w, 1));
    }];
    
    //直接使用按钮
    _xjUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xjUseBtn.layer.cornerRadius = 6;
    _xjUseBtn.layer.masksToBounds = YES;
    _xjUseBtn.hidden = YES;
    [xjWhiteView addSubview:_xjUseBtn];
    [_xjUseBtn setTitle:@"直接使用" forState:UIControlStateNormal];
    [_xjUseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _xjUseBtn.frame = CGRectMake(xj_base_view_w * 0.2, xj_header_image_w+10+45 , xj_base_view_w * 0.6, 34);
    _xjUseBtn.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    [_xjUseBtn addTarget:self action:@selector(xjClickToJumpStafari) forControlEvents:UIControlEventTouchUpInside];
    //二维码view
    CGFloat xjEWMH = xj_base_view_h - (_xjUseBtn.frame.origin.y + _xjUseBtn.frame.size.height);
    UIView* xjewmView=  [[UIView alloc] initWithFrame:CGRectMake(0, (_xjUseBtn.frame.origin.y + _xjUseBtn.frame.size.height), xj_base_view_w, xjEWMH)];
    [xjWhiteView addSubview:xjewmView];
   
    //erweima
    CGRect xjEWMFrame = xjewmView.frame;
    _xjEWMImageView = [[UIImageView alloc] init];
    _xjEWMImageView.frame = CGRectMake(xjEWMFrame.size.width*0.2,10, xjEWMFrame.size.width*0.6, xjEWMFrame.size.height - 58);
//    _xjEWMImageView.backgroundColor = [UIColor blueColor];
    [xjewmView addSubview:_xjEWMImageView];
    //过期时间
    _xjTimeLabelGQ = [[UILabel alloc] init];
    [xjWhiteView addSubview:_xjTimeLabelGQ];
    [_xjTimeLabelGQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_xjEWMImageView).offset(0);
        make.top.equalTo(_xjEWMImageView.mas_bottom).offset(5);
//        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    _xjTimeLabelGQ.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    
    //券码
    _xjTikcketNumLabel = [[UILabel alloc] init];
    [xjewmView addSubview:_xjTikcketNumLabel];
    [_xjTikcketNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_xjCopyBtn).offset(0);
        make.top.equalTo(_xjTimeLabelGQ.mas_bottom).offset(5);
//        make.right.equalTo(_xjCopyBtn.mas_left).offset(10);
        make.centerX.equalTo(_xjUseBtn).offset(-24);
    }];
    _xjTikcketNumLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    
    //复制按钮
    _xjCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xjewmView addSubview:_xjCopyBtn];
    _xjCopyBtn.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    [_xjCopyBtn setTitle:@"复制" forState:UIWindowLevelNormal];
    [_xjCopyBtn addTarget:self action:@selector(xjClickToCopyStr) forControlEvents:UIControlEventTouchUpInside];
    _xjCopyBtn.layer.cornerRadius = 4;
    _xjCopyBtn.layer.masksToBounds = YES;
    _xjCopyBtn.hidden = YES;
    [_xjCopyBtn setTitleColor:[UIColor whiteColor] forState:UIWindowLevelNormal];
    _xjCopyBtn.titleLabel.font =[UIFont fontWithName:FL_FONT_NAME size:12];
    [_xjCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_xjUseBtn.mas_right).offset(-10);
        make.top.equalTo(_xjTimeLabelGQ.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.left.equalTo(_xjTikcketNumLabel.mas_right).offset(4);
    }];
    
    
    //使用说明
    _xjExplainLabel = [[FLGrayLabel alloc] init];
    _xjExplainLabel.numberOfLines = 0;
    _xjExplainLabel.frame = CGRectMake(xj_left_right_margin, 4, xj_base_view_w - 2 * xj_left_right_margin , 30);
    _xjExplainLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    [_xjExplainView addSubview:_xjExplainLabel];
    
}

- (void)xjSetExplainInfoWith {
    if (![XJFinalTool xjStringSafe:_xjMyReceiveInMineModel.flIntroduceStr]) {
        _xjMyReceiveInMineModel.flIntroduceStr = @"使用说明:\n暂无";
    } else {
       _xjExplainLabel.text = [NSString stringWithFormat:@"使用说明:\n%@",_xjMyReceiveInMineModel.flIntroduceStr];
    }
    
    [_xjExplainLabel sizeToFit];
    [_xjExplainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(xj_base_view_w ,_xjExplainLabel.height +40));
    }];
    if([_xjMyReceiveInMineModel.flIntroduceStr isEqualToString:@""] || !_xjMyReceiveInMineModel.flIntroduceStr) {
        _xjExplainLabel.text = @"";
    }
    //更新外部frame
    CGFloat xjViewTotalH = xj_base_view_h + xj_bac_image_top_h + xj_bac_image_bottom_h + xj_bac_image_middle_h + _xjExplainLabel.height +20 ;
    
    if ([self.delegate respondsToSelector:@selector(xjRefreshViewFrameWithTickHeight:)]) {
        [self.delegate xjRefreshViewFrameWithTickHeight:xjViewTotalH];
    }
}

- (void)xjClickToJumpStafari {
    FL_Log(@"this its the action =======");
    if ([self.delegate respondsToSelector:@selector(xjClickUsrNoewInMyTicketView)]) {
        [self.delegate xjClickUsrNoewInMyTicketView];
    }
}

#pragma makr -----------------------------[我的模型]

- (void)setXjMineInfoModel:(FLMineInfoModel *)xjMineInfoModel {
    _xjMineInfoModel = xjMineInfoModel;
    _xjHeaderImageView.layer.borderColor=DE_headerBorderColor.CGColor;
    _xjHeaderImageView.layer.borderWidth=DE_headerBorderWidth;

    [_xjHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjMineInfoModel.avatar isSite:NO]]]placeholderImage:[UIImage imageNamed:@"xj_default_avator"]];
    _xjNickLabel.text = _xjMineInfoModel.nickname;
    _xjDescribeLabel.text = _xjMineInfoModel.fldescription;
}
//券码
- (void)setXjTicketNumberModel:(XJTicketNumberModel *)xjTicketNumberModel {
    _xjTicketNumberModel = xjTicketNumberModel;
    _xjTikcketNumLabel.text = [NSString stringWithFormat:@"%@%@",_xjTicketNumberModel.cardnum ?@"券 码: ":@"",_xjTicketNumberModel.cardnum ? _xjTicketNumberModel.cardnum : @""];
    [_xjTikcketNumLabel sizeToFit];
    _xjCopyBtn.hidden = ![XJFinalTool xjStringSafe:xjTicketNumberModel.cardnum];
    _xjTikcketNumLabel.hidden = ![XJFinalTool xjStringSafe:xjTicketNumberModel.cardnum];
    [_xjTikcketNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_xjCopyBtn.mas_left).offset(-20);
    }];
}
                               
#pragma makr -----------------------------[我领取的模型]
- (void)setXjMyReceiveInMineModel:(FLMyReceiveListModel *)xjMyReceiveInMineModel {
    _xjMyReceiveInMineModel = xjMyReceiveInMineModel;
    [self setInfoInMyReceiveView];
    [self createEWMUIInMyReceiveVCWithInfo:_xjMyReceiveInMineModel.flDetailsIdStr];
}

- (void)setInfoInMyReceiveView
{
    //    _flMyReceiveInMineModel
    //使用状态 0 为未使用
    if (_xjMyReceiveInMineModel.flStateInt == 0) {
        _xjStateImageView.hidden = YES;
    } else {
        _xjStateImageView.hidden = NO;
    }
    _xjTimeLabelGQ.text = [NSString stringWithFormat:@"过期时间: %@",_xjMyReceiveInMineModel.xjinvalidTime ? _xjMyReceiveInMineModel.xjinvalidTime :@"长期"];
    [_xjTimeLabelGQ sizeToFit];
    if ([XJFinalTool xjStringSafe:self.xjMyReceiveInMineModel.xjUseTime]) {
       _xjTimeLabelUse.text = [NSString stringWithFormat:@"使用时间: %@",_xjMyReceiveInMineModel.xjUseTime];
    } else if ([XJFinalTool xjStringSafe:self.xjMyReceiveInMineModel.createTime]) {
        _xjTimeLabelUse.text = [NSString stringWithFormat:@"领取时间: %@",_xjMyReceiveInMineModel.createTime];
    }
    
    _xjUseBtn.hidden =![XJFinalTool xjStringSafe:_xjMyReceiveInMineModel.xjUrl];
    
//    [_xjTimeLabelGQ mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self).offset(0);
//    }];
  
    [self xjSetExplainInfoWith];
    
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
//        _xjEWMImageView.image = image2;
//        _xjEWMImageView.contentMode = UIViewContentModeScaleToFill;
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
    NSString *string = [NSString stringWithFormat:@"%@", mabi];
    
    //将NSString格式转化成NSData格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    
    //将获取到的二维码添加到imageview上
//    _xjEWMImageView.image = [UIImage imageWithCIImage:image];
    _xjEWMImageView.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:200];
    _xjEWMImageView.contentMode = UIViewContentModeScaleToFill;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
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

- (void) xjClickToCopyStr{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _xjTicketNumberModel.cardnum ? _xjTicketNumberModel.cardnum : @"";//_xjTikcketNumLabel.text; //[NSString stringWithFormat:@"%@%@",_xjTicketNumberModel.cardnum ?@"券 码: ":@"",_xjTicketNumberModel.cardnum ? _xjTicketNumberModel.cardnum : @""];
    [FLTool showWith:@"已成功将券码复制到剪切板"];
}

@end


















