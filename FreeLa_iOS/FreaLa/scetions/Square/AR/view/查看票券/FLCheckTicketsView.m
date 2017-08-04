//
//  FLCheckTicketsView.m
//  FreeLa
//
//  Created by MBP on 17/7/28.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "FLCheckTicketsView.h"
#import "NSDate+time.h"
@interface FLCheckTicketsView ()
@property(nonatomic,strong)UIScrollView*bgScrollView;
@property(nonatomic,strong)UIImageView*isUse;
@property(nonatomic,strong)UIImageView*codeImageV;
@property(nonatomic,strong)UIImageView*headerImageV;
@property(nonatomic,strong)UILabel*nameLabel;
@property(nonatomic,strong)UIButton*useBtn;
@property(nonatomic,strong)UILabel*linquLabel;
@property(nonatomic,strong)UILabel*guoqiLabel;
@property(nonatomic,strong)UILabel*codeLabel;
@property(nonatomic,strong)UIButton*codeCopyBtn;
@property(nonatomic,strong)UIImageView*instructionBackImageV;
@property(nonatomic,strong)UILabel*instructionLabel;
@property (strong, nonatomic) UIButton *flGoBackBtn;

@end
@implementation FLCheckTicketsView

-(instancetype)initWithSuperView:(UIView*)spView{
    
if (self=[super init]) {
    self.frame=CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.backgroundColor=[UIColor clearColor];

        [spView addSubview:self.maskView];
        [spView addSubview:self];
        [self create2UI];
    [self seeInfoInHtmlVC];

    }
    return self;
}
- (UIButton *)flGoBackBtn {
    if (!_flGoBackBtn) {
        _flGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flGoBackBtn.frame = CGRectMake(20, 20, 40, 40);
        [_flGoBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        [_flGoBackBtn addTarget:self action:@selector(chaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flGoBackBtn;
}

//券码
- (void)setXjTicketNumberModel:(XJTicketNumberModel *)xjTicketNumberModel {
    _xjTicketNumberModel = xjTicketNumberModel;
    if (!xjTicketNumberModel.cardnum||!xjTicketNumberModel.cardnum.length) {
        self.codeLabel.hidden=YES;
        self.codeCopyBtn.hidden=YES;
    }else{
        self.codeLabel.text = [NSString stringWithFormat:@"%@%@",_xjTicketNumberModel.cardnum ?@"券码:":@"",_xjTicketNumberModel.cardnum ? _xjTicketNumberModel.cardnum : @""];

    }
}
- (void)seeInfoInHtmlVC
{
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"accountType":@"per"};
    FL_Log(@"see info :sesssionId   parm = %@",parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my change account test info = %@",data);
        if (data) {
            self.flMineInfoModel =  [FLMineInfoModel mj_objectWithKeyValues:data];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setFlMineInfoModel:(FLMineInfoModel *)flMineInfoModel
{
    _flMineInfoModel = flMineInfoModel;
    NSString* xjAvatar = _flMineInfoModel.avatar;
    if (![FLTool returnBoolWithIsHasHTTP:xjAvatar includeStr:@"http://"] && xjAvatar) {
        xjAvatar = [FLBaseUrl stringByAppendingString:xjAvatar];
    }
    [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",xjAvatar]]];
    self.nameLabel.text = _flMineInfoModel.nickname;
}

- (void)setFlMyReceiveInMineModel:(FLMyReceiveListModel *)flMyReceiveInMineModel
{
    _flMyReceiveInMineModel = flMyReceiveInMineModel;
    [self xjGetlingqushijian];
    
}
- (void)xjGetTicketNum {
    if (!_flMyReceiveInMineModel) {
        return;
    }
    NSDictionary* parm = @{@"topicId":_flMyReceiveInMineModel.flMineIssueTopicIdStr,
                           @"detailsId":_flMyReceiveInMineModel.flDetailsIdStr,
                           @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool xjGetTicketNumber:parm success:^(NSDictionary *data) {
        FL_Log(@"this istthe ticket 111number =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjTicketNumberModel = [XJTicketNumberModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
        }else{
            self.xjTicketNumberModel = [XJTicketNumberModel new];

        }
    } failure:^(NSError *error) {
        
    }];
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
    self.codeImageV.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:self.codeImageV.size.width];
    self.codeImageV.contentMode = UIViewContentModeScaleToFill;
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

- (void)setInfoInMyReceiveView
{
    //使用状态 0 为未使用

    if (_flMyReceiveInMineModel.flStateInt == 0) {
        self.isUse.hidden = YES;
    } else {
        self.isUse.hidden = NO;
    }
    if (self.flMyReceiveInMineModel.createTime&&self.flMyReceiveInMineModel.createTime.length!=0) {
        NSDate*date=[NSDate dateWithStr:_flMyReceiveInMineModel.createTime];
        NSString*dateStr=[date nosTime];
        self.linquLabel.text = [NSString stringWithFormat:@"%@领取",dateStr];
    } else {
    }

    if (_flMyReceiveInMineModel.xjinvalidTime) {
        NSDate*date=[NSDate dateWithStr:_flMyReceiveInMineModel.xjinvalidTime];
        NSString*dateStr=[date nosTime];
        self.guoqiLabel.text= [NSString stringWithFormat:@"过期时间: %@",dateStr];
    }else{
      self.guoqiLabel.text=@"长期有效";
    }
    if([_flMyReceiveInMineModel.flIntroduceStr isEqualToString:@""] || !_flMyReceiveInMineModel.flIntroduceStr) {
        self.instructionBackImageV.hidden=YES;
    }else{
        self.instructionBackImageV.hidden=NO;

        self.instructionLabel.text = [NSString stringWithFormat:@"%@",_flMyReceiveInMineModel.flIntroduceStr];

    }
    if ( _flMyReceiveInMineModel.xjUrl.length!=0) {
        FL_Log(@"ticket has already used");
        self.useBtn.hidden = NO;
        self.useBtn.height=40 ;
    } else {
        FL_Log(@"ticket has not  already used");
        self.useBtn.height=0.1 ;

        self.useBtn.hidden = YES;
    }


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
-(void)create2UI{
    self.bgScrollView=({
        UIScrollView*sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [self addSubview:sc];
        sc;
    });
    /**✘*/
    UIButton*chaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chaBtn setImage:[UIImage imageNamed:@"chachachachacha"] forState:UIControlStateNormal];
    chaBtn.layer.cornerRadius=15;
    chaBtn.layer.masksToBounds=YES;
    chaBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    chaBtn.layer.borderWidth=1;
    chaBtn.frame=CGRectMake(0,DEF_I6_SIZE(50), 30, 30);
    chaBtn.centerX=DEVICE_WIDTH*0.5;
    [chaBtn addTarget:self action:@selector(chaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:chaBtn];
    /**白线*/
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=[UIColor whiteColor];
    line.frame=CGRectMake(0, DEF_I6_SIZE(50)+29.5, 1, 55);
    line.centerX=DEVICE_WIDTH*0.5;
    [self.bgScrollView addSubview:line];
    /**已使用标志*/
    self.isUse=({
        UIImageView*imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yiShiYong"]];
        imageV.frame=CGRectMake(DEVICE_WIDTH*0.5+131-80, line.cy_bottom-45, 55, 55);
        imageV;
    });
    [self.bgScrollView insertSubview:self.isUse belowSubview:line];
    /**红包*/
    UIImageView*hongbaoImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"piaoquan_hongbao"]];
    hongbaoImageV.frame=CGRectMake(0, line.cy_bottom-10, 262, 363.5);
    hongbaoImageV.centerX=DEVICE_WIDTH*0.5;
    hongbaoImageV.userInteractionEnabled=YES;
    [self.bgScrollView insertSubview:hongbaoImageV belowSubview:self.isUse];
    /**二维码*/
    self.codeImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.frame=CGRectMake(0, 30, 140, 140);
        imageV.centerX=hongbaoImageV.width*0.5-7;
        CGAffineTransform transform = CGAffineTransformMakeRotation(-3 * M_PI/180.0);
        [imageV setTransform:transform];
        [hongbaoImageV addSubview:imageV];
        imageV;
    });
    /**头像*/
    self.headerImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.frame=CGRectMake(0, 180, 35, 35);
        imageV.centerX=hongbaoImageV.width*0.5;
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=17.5;
        imageV.layer.borderWidth=0.5;
        imageV.layer.borderColor=[UIColor whiteColor].CGColor;
        [hongbaoImageV addSubview:imageV];
        imageV;
    });
    /**名字*/
    self.nameLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor colorWithHexString:@"#f3ee8a"];
        label.font=[UIFont systemFontOfSize:13];
        label;
    });
    [hongbaoImageV addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImageV.cy_bottom+7);
        make.centerX.equalTo(hongbaoImageV);
    }];
    /**领取时间*/
    self.linquLabel=({
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor whiteColor];
        label;
    });
    [hongbaoImageV addSubview:self.linquLabel];
    [self.linquLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.centerX.equalTo(hongbaoImageV);
    }];
    
    /**过期时间*/
    self.guoqiLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label;
    });
    [hongbaoImageV addSubview:self.guoqiLabel];
    [self.guoqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linquLabel.mas_bottom).offset(5);
        make.centerX.equalTo(hongbaoImageV);
    }];
    
    /**直接使用按钮*/
    self.useBtn=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"zhiJieShiYong_anNiu"] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn setTitle:@"直接使用" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ff3e3e"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(useBtnAction) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(0, self.headerImageV.cy_bottom+30+40, 145, 40);
        btn.centerX=hongbaoImageV.width*0.5;
        [hongbaoImageV addSubview:btn];
        btn;
    });
    /**券码*/
    self.codeLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label;
    });
    [hongbaoImageV addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useBtn);
        make.top.equalTo(self.useBtn.mas_bottom).offset(5);
    }];
    /**复制券码按钮*/
    self.codeCopyBtn=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:@"复制" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.layer.masksToBounds=YES;
        btn.titleLabel.font=[UIFont systemFontOfSize:13];
        btn.layer.cornerRadius=4;
        btn;
        
    });
    [self.codeCopyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [hongbaoImageV addSubview:self.codeCopyBtn];
    [self.codeCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.right.equalTo(self.useBtn.mas_right);
        make.centerY.equalTo(self.codeLabel);
        
    }];
    
    /**使用说明*/
    UIImageView*shuoMingImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    shuoMingImageV.layer.cornerRadius=6;
    shuoMingImageV.layer.masksToBounds=YES;
    shuoMingImageV.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    shuoMingImageV.userInteractionEnabled=YES;
    self.instructionBackImageV=shuoMingImageV;
    [self.bgScrollView addSubview:shuoMingImageV];
    [shuoMingImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hongbaoImageV.x+3);
        make.top.equalTo(hongbaoImageV.mas_bottom).offset(10);
        make.width.mas_equalTo(hongbaoImageV.width-6);
        make.bottom.equalTo(self.bgScrollView).offset(-80);
    }];
    
    UILabel*shiYongShuoMingLabel=[[UILabel alloc]init];
    shiYongShuoMingLabel.textColor=[UIColor redColor];
    shiYongShuoMingLabel.text=@"使用说明:";
    shiYongShuoMingLabel.font=[UIFont systemFontOfSize:14];
    [shuoMingImageV addSubview:shiYongShuoMingLabel];
    [shiYongShuoMingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@15);
    }];
    self.instructionLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label.numberOfLines=0;
        label;
    });
    [shuoMingImageV addSubview:self.instructionLabel];
    [self.instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shiYongShuoMingLabel);
        make.top.equalTo(shiYongShuoMingLabel.mas_bottom).offset(3.5);
        make.bottom.equalTo(shuoMingImageV.mas_bottom).offset(-15);
        make.width.mas_equalTo(hongbaoImageV.width-30);
        
        
    }];
    
    chaBtn.hidden=YES;
    line.hidden=YES;
    [self addSubview: self.flGoBackBtn ];
    hongbaoImageV.cy_y=hongbaoImageV.cy_y;

}
-(void)createUI{
    /**✘*/
    UIButton*chaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chaBtn setImage:[UIImage imageNamed:@"chachachachacha"] forState:UIControlStateNormal];
    chaBtn.layer.cornerRadius=15;
    chaBtn.layer.masksToBounds=YES;
    chaBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    chaBtn.layer.borderWidth=1;
    chaBtn.frame=CGRectMake(0,DEF_I6_SIZE(50), 30, 30);
    chaBtn.centerX=DEVICE_WIDTH*0.5;
    [chaBtn addTarget:self action:@selector(chaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chaBtn];
    /**白线*/
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=[UIColor whiteColor];
    line.frame=CGRectMake(0, DEF_I6_SIZE(50)+29.5, 1, 55);
    line.centerX=DEVICE_WIDTH*0.5;
    [self addSubview:line];
    /**已使用标志*/
    self.isUse=({
        UIImageView*imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yiShiYong"]];
        imageV.frame=CGRectMake(DEVICE_WIDTH*0.5+131-80, line.cy_bottom-45, 55, 55);
        imageV;
    });
    [self insertSubview:self.isUse belowSubview:line];
    /**红包*/
    UIImageView*hongbaoImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"piaoquan_hongbao"]];
    hongbaoImageV.frame=CGRectMake(0, line.cy_bottom-10, 262, 363.5);
    hongbaoImageV.centerX=DEVICE_WIDTH*0.5;
    hongbaoImageV.userInteractionEnabled=YES;
    [self insertSubview:hongbaoImageV belowSubview:self.isUse];
    /**二维码*/
    self.codeImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.frame=CGRectMake(0, 30, 140, 140);
        imageV.centerX=hongbaoImageV.width*0.5-7;
        CGAffineTransform transform = CGAffineTransformMakeRotation(-3 * M_PI/180.0);
        [imageV setTransform:transform];
        [hongbaoImageV addSubview:imageV];
        imageV;
    });
    /**头像*/
    self.headerImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.frame=CGRectMake(0, 180, 35, 35);
        imageV.centerX=hongbaoImageV.width*0.5;
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=17.5;
        imageV.layer.borderWidth=0.5;
        imageV.layer.borderColor=[UIColor whiteColor].CGColor;
        imageV.backgroundColor=[UIColor yellowColor];
        [hongbaoImageV addSubview:imageV];
        imageV;
    });
    /**名字*/
    self.nameLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor colorWithHexString:@"#f3ee8a"];
        label.font=[UIFont systemFontOfSize:13];
        label;
    });
    [hongbaoImageV addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImageV.cy_bottom+7);
        make.centerX.equalTo(hongbaoImageV);
    }];
    /**领取时间*/
    self.linquLabel=({
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor whiteColor];
        label;
    });
    [hongbaoImageV addSubview:self.linquLabel];
    [self.linquLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.centerX.equalTo(hongbaoImageV);
    }];

    /**过期时间*/
    self.guoqiLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label;
    });
    [hongbaoImageV addSubview:self.guoqiLabel];
    [self.guoqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linquLabel.mas_bottom).offset(5);
        make.centerX.equalTo(hongbaoImageV);
    }];

    /**直接使用按钮*/
    self.useBtn=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"zhiJieShiYong_anNiu"] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn setTitle:@"直接使用" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ff3e3e"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(useBtnAction) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(0, self.headerImageV.cy_bottom+30+40, 145, 40);
        btn.centerX=hongbaoImageV.width*0.5;
        [hongbaoImageV addSubview:btn];
        btn;
    });
    /**券码*/
    self.codeLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label;
    });
    [hongbaoImageV addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useBtn);
        make.top.equalTo(self.useBtn.mas_bottom).offset(5);
    }];
    /**复制券码按钮*/
    self.codeCopyBtn=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:@"复制" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.layer.masksToBounds=YES;
        btn.titleLabel.font=[UIFont systemFontOfSize:13];
        btn.layer.cornerRadius=4;
        btn;
        
    });
    [self.codeCopyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [hongbaoImageV addSubview:self.codeCopyBtn];
    [self.codeCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.right.equalTo(self.useBtn.mas_right);
        make.centerY.equalTo(self.codeLabel);
        
    }];

    /**使用说明*/
    UIImageView*shuoMingImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shiYongShuoMing_beiJing-1"]];
    shuoMingImageV.userInteractionEnabled=YES;
    shuoMingImageV.frame=CGRectMake( hongbaoImageV.x-5,hongbaoImageV.cy_bottom-23, hongbaoImageV.width+10, 144);
    self.instructionBackImageV=shuoMingImageV;
    [self addSubview:shuoMingImageV];

    UIScrollView*instructionSc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 12, hongbaoImageV.width+14, 120)];
    [shuoMingImageV addSubview:instructionSc];
    
    UILabel*shiYongShuoMingLabel=[[UILabel alloc]init];
    shiYongShuoMingLabel.textColor=[UIColor redColor];
    shiYongShuoMingLabel.text=@"使用说明:";
    shiYongShuoMingLabel.font=[UIFont systemFontOfSize:14];
    [instructionSc addSubview:shiYongShuoMingLabel];
    [shiYongShuoMingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.left.equalTo(@22);
    }];
    self.instructionLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label.numberOfLines=0;
        label;
    });
    [instructionSc addSubview:self.instructionLabel];
    [self.instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shiYongShuoMingLabel);
        make.top.equalTo(shiYongShuoMingLabel.mas_bottom).offset(3.5);
        make.bottom.equalTo(instructionSc.mas_bottom).offset(-23);
        make.width.mas_equalTo(hongbaoImageV.width-30);

        
    }];
    
    chaBtn.hidden=YES;
    line.hidden=YES;
    [self addSubview: self.flGoBackBtn ];
    hongbaoImageV.cy_y=hongbaoImageV.cy_y-20;

}
-(void)popUp{
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=0.2;
        self.y=0;
    }completion:^(BOOL finished)
     {
         
     }];
}
-(void)popDown{
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=0.0;
        self.y=DEVICE_HEIGHT;

    }completion:^(BOOL finished) {
        [self removeFromSuperview ];
        [self.maskView removeFromSuperview];
    }];
    if (self.popDownlock) {
        self.popDownlock();
    }
    
}

#pragma mark ✘点击事件
-(void)chaBtnAction{
    [self popDown];
}
#pragma mark 直接使用事件
-(void)useBtnAction{
//    if (self.useVlock) {
//        self.useVlock();
//    }
    [self testUserTickets];
    [self popDown];
}
#pragma mark 复制事件
-(void)copyAction{
    NSArray*arr=[self.codeLabel.text componentsSeparatedByString:@":"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = arr[1];
    [FLTool showWith:@"复制成功"];

}
#pragma mark 领取时间
- (void)xjGetlingqushijian {
    if(!self.flMyReceiveInMineModel.flDetailsIdStr){
        return;
    }
    NSDictionary* parm = @{@"participateDetailes.detailsid":self.flMyReceiveInMineModel.flDetailsIdStr};
    [FLNetTool xjgetParticipateDetailesByIdWithParma:parm success:^(NSDictionary *dic) {
        FL_Log(@"this is the function for balabala ==%@",dic);
        if ([dic[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* data = dic[@"data"];
            self.flMyReceiveInMineModel.flStateInt = [data[@"state"] integerValue];
            self.flMyReceiveInMineModel.xjUseTime = data[@"useTime"] ;
            self.flMyReceiveInMineModel.flDetailsIdStr = [data[@"detailsid"] stringValue];
            self.flMyReceiveInMineModel.createTime = data[@"createTime"];
            [self setInfoInMyReceiveView];
            [self xj_yuanshengerweima:_flMyReceiveInMineModel.flDetailsIdStr];
            [self xjGetTicketNum];


        }
        
    } failure:^(NSError *error) {
    }];
}

- (void)testUserTickets
{
    
    
    NSInteger flstate = _flMyReceiveInMineModel.flStateInt;
    if (flstate !=1 ) {
        //这里是扫码接口
        NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                               @"participateDetailes.detailsid":_flMyReceiveInMineModel.flDetailsIdStr,
                               @"participateDetailes.topicId":_flMyReceiveInMineModel.flMineIssueTopicIdStr,
                               @"participateDetailes.userId":[NSNumber numberWithInteger:_flMyReceiveInMineModel.xjUserId],
                               @"participateDetailes.creator":[NSNumber numberWithInteger:_flMyReceiveInMineModel.xjCreator],
                               @"participateDetailes.userType":_flMyReceiveInMineModel.xjUserType,
                               @"participateDetailes.checkUser":@""
                               };
        [FLNetTool fluseDetailesByIDWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"thisi is my test useticket with html=%@",data);
            if ([data[FL_NET_KEY_NEW] boolValue]) {
                [[FLAppDelegate share] showHUDWithTitile:@"使用成功" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                _flMyReceiveInMineModel.flStateInt = 1;
                //                [self creatrUIInReceiveTicketsVC];
            } else {
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    //跳转至url
    NSString* xjStr = [[NSString stringWithFormat:@"%@", _flMyReceiveInMineModel.xjUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString* xjMu = [NSMutableString stringWithString:xjStr];
    xjStr = [xjMu stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:xjStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:xjStr]];
    } else {
        [FLTool showWith:@"链接不可用"];
    }
}

@end
