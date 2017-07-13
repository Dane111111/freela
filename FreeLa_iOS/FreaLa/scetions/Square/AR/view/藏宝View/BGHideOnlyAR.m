//
//  BGHideOnlyAR.m
//  FreeLa
//
//  Created by MBP on 17/7/11.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "BGHideOnlyAR.h"
@interface BGHideOnlyAR ()<UITextFieldDelegate,FLChooseMapViewControllerDelegate>
@property (nonatomic , strong) UILabel* xj_title_label;

//各个元素内容/
/**title*/
@property (nonatomic , strong) UITextField* xj_titleTf;
/**
 *number
 */
@property (nonatomic , strong) UITextField* xj_numberTf;
/**地址*/
@property (nonatomic , strong) UIButton* xj_LocationL;
/**线索*/
@property (nonatomic , strong) UITextField* xj_xiansuoTf;
/**领取人群*/
@property (nonatomic , strong) NSString* xj_TopicRangerStr;
/**领取信息*/
@property (nonatomic , assign) BOOL xj_TopicPartInfo;
/**LBS或LBS+AR*/

@property(nonatomic,assign)NSInteger LBSorAR;

@property(nonatomic,strong)UIImageView*backImageV;


@end

@implementation BGHideOnlyAR
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
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

-(void)createView{
    //    self.frame=[UIScreen mainScreen].bounds;
    //    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popDown)];
    //    tap.numberOfTapsRequired=1;
    //    self.userInteractionEnabled=YES;
    //    [self addGestureRecognizer:tap];
    self.backImageV=({
        UIImageView*imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        imageV.center=self.center;
        imageV.image=[UIImage imageNamed:@"tianxinxi_beijingtu"];
        imageV.userInteractionEnabled=YES;
        [self addSubview:imageV];
        imageV;
        
    });
    [self xj_createBaseView];
    
    _xjIssueModel = [[FLIssueInfoModel alloc] init];
    _xjIssueModel.flactivityTopicRangeStr = FLFLXJSquareIssueOVERTPick;
    self.xj_TopicPartInfo = NO;
    self.xj_TopicRangerStr = FLFLXJSquareIssueOVERTPick;
    
}
- (UILabel *)xj_title_label {
    if (!_xj_title_label) {
        UIImageView*imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-3"]];
        imageV.frame=CGRectMake(10, -15, 90, 32);
        [self addSubview:imageV];

        _xj_title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, -15, 90, 30)];
        _xj_title_label.layer.cornerRadius=5;
        _xj_title_label.layer.masksToBounds=YES;
        _xj_title_label.font = [UIFont fontWithName:FL_FONT_NAME size:16];
        _xj_title_label.textAlignment = NSTextAlignmentCenter;
        _xj_title_label.textColor = [UIColor whiteColor];
        [self addSubview:_xj_title_label];
    }
    return _xj_title_label;
}

- (void)xj_createBaseView {
    //title
    self.xj_title_label.text = @"本地藏宝";
    [self xj_createMainViewForHide];
}

- (void)xj_createMainViewForHide {
    
    //view
    UIScrollView* xjscroll = [[UIScrollView alloc] init];
    xjscroll.contentSize = CGSizeMake(self.backImageV.width, self.backImageV.height-20);
    xjscroll.frame = CGRectMake(0,30, self.backImageV.width, self.backImageV.height-90);
    [self.backImageV addSubview:xjscroll];
    
    NSArray* titleArr = @[@"藏宝主题",@"礼包数量",@"人群选择",@"地理位置",@"领取信息",@"AR展示"];
    
    CGFloat  xj_labelX = 5;
    CGFloat  xj_labelH = 40;
    CGFloat  xj_labelW = 60;
    self.LBSorAR=1;
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIView* baseView = [[UIView alloc] init];
        baseView.frame = CGRectMake(0,+ xj_labelH*i , self.width, xj_labelH);
        //        baseView.userInteractionEnabled = YES;
        [xjscroll addSubview:baseView];
        
        //label
        UILabel* xjlabel = [[UILabel alloc] init];
        xjlabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJFontSize];
        xjlabel.textColor = [UIColor whiteColor];
        xjlabel.textAlignment = NSTextAlignmentCenter;
        xjlabel.frame = CGRectMake( 7, 0, xj_labelW, xj_labelH);
        [baseView addSubview:xjlabel];
        xjlabel.text = titleArr[i];
        
        //右边的 view
        UIView* rv = [[UIView alloc] init];
        [baseView addSubview:rv];
        rv.frame = CGRectMake(xj_labelX*2 + xj_labelW, 0, self.width - xj_labelX*3 - xj_labelW-5, xj_labelH);
        if (i<2) {
            //text
            UITextField* xjtex = [[UITextField alloc] init];
            [rv  addSubview:xjtex];
            xjtex.font = [UIFont fontWithName:FL_FONT_NAME size:XJFontSize];
            xjtex.textColor = [UIColor whiteColor];
            xjtex.textAlignment = NSTextAlignmentLeft;
            xjtex.frame = CGRectMake(0, 3, rv.width, rv.height-2*3);
            xjtex.placeholder = titleArr[i];
            [xjtex setBackground:[UIImage imageNamed:@"libaoshuliang_juxing"]];
            xjtex.returnKeyType = UIReturnKeyDone;
            [KeyboardToolBar registerKeyboardToolBar:xjtex];
            if (i==0) {
                self.xj_titleTf = xjtex;
            } else if (i==1){
                self.xj_numberTf = xjtex;
                xjtex.keyboardType = UIKeyboardTypeNumberPad;
            } else if (i==2){
                self.xj_xiansuoTf = xjtex;
            }
        }
        //        if (i==2) {
        //            for (NSInteger i = 0;  i <2; i++) {
        //                UIButton* xj_choose = [UIButton buttonWithType:UIButtonTypeCustom];
        //                [rv addSubview:xj_choose];
        //                CGFloat xj_btnW = (rv.width - 10)/2;
        //                CGFloat xj_btnX =  i * (5 + xj_btnW);
        //                xj_choose.frame = CGRectMake(xj_btnX, 3 ,xj_btnW, rv.height-2*3);
        //                [xj_choose setBackgroundImage:[UIImage imageNamed:@"ar_sqare_bg_selected"] forState:UIControlStateNormal];
        //                [xj_choose setTitle:@[@"LBS活动",@"AR+LBS活动"][i] forState:UIControlStateNormal];
        //                [xj_choose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //                xj_choose.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJFontSize];
        //                xj_choose.tag = XJTopicARorLBS+i;
        //                [xj_choose addTarget:self action:@selector(xj_clickToChooseLBSAndARInfo:) forControlEvents:UIControlEventTouchUpInside];
        //                [xj_choose setBackgroundImage:[UIImage imageNamed:@"ar_publish_selectbg"] forState:UIControlStateSelected];
        //                if (i==1) {
        //                    xj_choose.selected = YES;
        //                }
        //            }
        //
        //        }
        //人群选择
        if (i==2) {
            for (NSInteger i = 0 ; i <3 ; i++) {
                UIButton* xj_choose = [UIButton buttonWithType:UIButtonTypeCustom];
                [rv addSubview:xj_choose];
                CGFloat xj_btnW = (rv.width - 10)/3;
                CGFloat xj_btnX =  i * (5 + xj_btnW);
                xj_choose.frame = CGRectMake(xj_btnX, 3 ,xj_btnW, rv.height-2*3);
                [xj_choose setBackgroundImage:[UIImage imageNamed:@"renqunxuanze_jixing2"] forState:UIControlStateNormal];//
                [xj_choose setTitle:@[@"任何人",@"陌生人",@"仅朋友"][i] forState:UIControlStateNormal];
                [xj_choose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                xj_choose.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJFontSize];
                xj_choose.tag = XJTopicRangeTag+i;
                [xj_choose addTarget:self action:@selector(xj_clickToChooseRange:) forControlEvents:UIControlEventTouchUpInside];
                [xj_choose setBackgroundImage:[UIImage imageNamed:@"renqunxuanze_juxing"] forState:UIControlStateSelected];
                if (i==0) {
                    xj_choose.selected = YES;
                }
            }
            
        }
        //填写信息
        if (i==4) {
            for (NSInteger i = 0;  i <2; i++) {
                UIButton* xj_choose = [UIButton buttonWithType:UIButtonTypeCustom];
                [rv addSubview:xj_choose];
                CGFloat xj_btnW = (rv.width - 10)/2;
                CGFloat xj_btnX =  i * (5 + xj_btnW);
                xj_choose.frame = CGRectMake(xj_btnX, 3 ,xj_btnW, rv.height-2*3);
                [xj_choose setBackgroundImage:[UIImage imageNamed:@"lingquxinxi_jixing2"] forState:UIControlStateNormal];
                [xj_choose setTitle:@[@"需填写",@"不需要"][i] forState:UIControlStateNormal];
                [xj_choose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                xj_choose.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJFontSize];
                xj_choose.tag = XJTopicPartInfoTag+i;
                [xj_choose addTarget:self action:@selector(xj_clickToChoosePartInfo:) forControlEvents:UIControlEventTouchUpInside];
                [xj_choose setBackgroundImage:[UIImage imageNamed:@"lingquxingxi_juxing"] forState:UIControlStateSelected];
                if (i==1) {
                    xj_choose.selected = YES;
                }
            }
        }
        //地理位置
        if (i==3) {
            UIButton* label = [UIButton buttonWithType:UIButtonTypeCustom];
            [rv addSubview:label];
            label.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJFontSize];
            label.titleLabel.textColor = [UIColor whiteColor];
            [label addTarget:self action:@selector(xj_clickToChooseMap) forControlEvents:UIControlEventTouchUpInside];
            label.frame = CGRectMake(0, 0, rv.width, rv.height);
            self.xj_LocationL = label;
            self.xj_LocationL.titleLabel.textAlignment = NSTextAlignmentLeft;
            //            self.xj_LocationL.backgroundColor = [UIColor redColor];
            [self.xj_LocationL setTitle:_xjLocationStr forState:UIControlStateNormal];
            if(![XJFinalTool xjStringSafe:_xjLocationStr]){
                [self.xj_LocationL setTitle:@"设定地址" forState:UIControlStateNormal];
            }
        }
        //缩略图
        if (i==5){
            baseView.frame = CGRectMake(0,20 + xj_labelH*i , self.width, xj_labelH*2);
            self.xj_topicThBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [baseView addSubview:self.xj_topicThBtn];
            [self.xj_topicThBtn addTarget:self action:@selector(xj_clickToChooseimg) forControlEvents:UIControlEventTouchUpInside];
            self.xj_topicThBtn.frame = CGRectMake(xj_labelX*2 + xj_labelW, 10,40, 40);
            [self.xj_topicThBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        }
    }
    UIButton* donebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    donebtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:donebtn];
    donebtn.frame = CGRectMake(self.width*0.2, self.height-55, self.width*0.6, 40);
    [donebtn setTitle:@"去吧礼包君" forState:UIControlStateNormal];
    [donebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    donebtn.backgroundColor=[UIColor redColor];
    donebtn.layer.cornerRadius=5;
    donebtn.layer.masksToBounds=YES;

//    [donebtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-3"] forState:UIControlStateNormal];
    [donebtn addTarget:self action:@selector(xj_clickToCheckInfo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)xj_clickToCheckInfo {
    if (![XJFinalTool xjStringSafe:self.xj_titleTf.text]) {
        [FLTool showWith:@"主题不能为空哟"];
    } else if (![XJFinalTool xjStringSafe:self.xj_numberTf.text]){
        [FLTool showWith:@"礼包个数不能为空哟"];
    }  else {
        if (self.block != nil) {
            self.block(self.xj_titleTf.text,self.xj_numberTf.text,self.xj_xiansuoTf.text,self.xj_TopicRangerStr,self.xj_TopicPartInfo,self.LBSorAR);
        }
    }
    
}
- (void)xjHideGiftBack:(xjHideGiftBlock)block {
    self.block = block;
}

- (void)xjClickToAddImg:(xjClickAddImg)block {
    self.xj_imgBlock = block;
}
- (void)xjClickToChooseMap:(xjClickChooseMap)block{
    self.xj_ChooseMapBlock = block;
}

#pragma  mark  Button_click
- (void)xj_clickToChooseRange:(UIButton*)sender{
    NSInteger xj = sender.tag-XJTopicRangeTag;
    if (xj==0) {
        self.xj_TopicRangerStr = FLFLXJSquareIssueOVERTPick;
    }else if (xj==1){
        self.xj_TopicRangerStr = FLFLXJSquareIssueSTRANGERPick;
    }else{
        self.xj_TopicRangerStr = FLFLXJSquareIssueFRIENDPick;
    }
    for (NSInteger i = 0; i < 3; i++) {
        if (sender.tag == XJTopicRangeTag+i) {
            sender.selected = YES;
            continue;
        }
        UIButton* btn = (UIButton*)[self viewWithTag:XJTopicRangeTag+i];
        btn.selected = NO;
    }
    
}
-(void)xj_clickToChooseLBSAndARInfo:(UIButton*)sender{
    NSInteger xj = sender.tag-XJTopicARorLBS;
    self.LBSorAR = xj+1;
    for (NSInteger i = 0; i < 3; i++) {
        if (sender.tag == XJTopicARorLBS+i) {
            sender.selected = YES;
            continue;
        }
        UIButton* btn = (UIButton*)[self viewWithTag:XJTopicARorLBS+i];
        btn.selected = NO;
    }
    
}
- (void)xj_clickToChoosePartInfo :(UIButton*)sender{
    NSInteger xj = sender.tag-XJTopicPartInfoTag;
    self.xj_TopicPartInfo = xj == 0 ? YES : NO;
    for (NSInteger i = 0; i < 3; i++) {
        if (sender.tag == XJTopicPartInfoTag+i) {
            sender.selected = YES;
            continue;
            
        }
        UIButton* btn = (UIButton*)[self viewWithTag:XJTopicPartInfoTag+i];
        btn.selected = NO;
    }
    
}

- (void)xj_clickToChooseMap {
    if(self.xj_ChooseMapBlock!=nil){
        self.xj_ChooseMapBlock();
    }
    
    //    FLChooseMapViewController* map = [[FLChooseMapViewController alloc] init];
    //    map.delegate = self.parentVC;
    ////    map.delegate = self;
    //    [self.parentVC.navigationController pushViewController:map animated:YES];
    //    [self.parentVC lew_dismissPopupView];
}
-(void)xj_clickToChooseimg{
    if (self.xj_imgBlock != nil) {
        self.xj_imgBlock();
    }
}


#pragma mark -----------------delegate

- (void)setXjLocationStr:(NSString *)xjLocationStr{
    _xjLocationStr = xjLocationStr;
    [self.xj_LocationL setTitle:xjLocationStr forState:UIControlStateNormal];
}
-(void)popUp{
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=1;
        self.backImageV.center=self.center;
        //        [self layoutIfNeeded];
    }completion:^(BOOL finished)
     {
         
     }];
    
}
-(void)popDown{
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=0.0;
        self.backImageV.cy_y=self.cy_bottom;
        //
        //        [self layoutIfNeeded];
        
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview ];
        [self.maskView removeFromSuperview];
    }];
    
}

@end
