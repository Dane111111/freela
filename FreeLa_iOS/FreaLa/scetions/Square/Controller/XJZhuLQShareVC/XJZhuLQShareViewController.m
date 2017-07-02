//
//  XJZhuLQShareViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJZhuLQShareViewController.h"
#import "YYTextView.h"
@interface XJZhuLQShareViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    NSString* xjTrans_base;
    NSString* xj_trans_temp_id;
}

@property (nonatomic  , strong) UIScrollView* xjScrollView;
@property (nonatomic , assign) CGFloat xjBottomDefaultY;

@property (nonatomic , strong) UIImageView* xjVersionBacImageView;
@property (nonatomic , strong) UIImageView* xjVersionImageView;
@end

@implementation XJZhuLQShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.xjTitleLabel = self.xjTopicDic[@"topicTheme"];
    self.xjTopicId = [NSString stringWithFormat:@"%@",self.xjTopicDic[@"topicId"]];
    self.title = self.xjTitleLabel ? self.xjTitleLabel: @"";
    self.xjTextView.delegate = self;
    self.xjDescribeView.layer.cornerRadius =  10;
    self.xjDescribeView.layer.masksToBounds = YES;
    //    self.xjTextView.
    [self xjSetScrollView];
    self.xjTextView.returnKeyType = UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjTextViewDidBeganToInput:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjTextViewDidEndToInput:) name:UIKeyboardWillHideNotification object:nil];
    [self.xjImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.xjTopicDic[@"thumbnail"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!image){
            image = [UIImage imageNamed:@""];
        }
        //        UIImage* imageTuUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
        //        self.view.image = imageTuUse;
    }];
    UITapGestureRecognizer* xjTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjEndInputEdit)];
    xjTap.delegate = self;
    [self.view addGestureRecognizer:xjTap];
    
//    self.xjLabelPartIn.text = self.xjstr;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    /*
     //test
    self.xjShareBackGroundImageView.hidden = YES;
    self.xjImageView.hidden = YES;
    
    [self.xjImageHelpBackGroundView addSubview:self.xjVersionImageView];
    [self.xjImageHelpBackGroundView addSubview:self.xjVersionBacImageView];
    CGRect frame ;
    frame.origin.y = self.xjImageHelpBackGroundView.height * 0.15;
    frame.size.height = self.xjImageHelpBackGroundView.height * 0.7;
    frame.size.width = frame.size.height* 1.2;
    frame.origin.x = (FLUISCREENBOUNDS.width -  (frame.size.height* 1.2)) / 2;
    self.xjVersionImageView.frame = frame ;
    [self.xjVersionImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.xjTopicDic[@"thumbnail"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!image){
            image = [UIImage imageNamed:@""];
        }
    }];
    frame.origin.x -=10;
    frame.origin.y -=16;
    frame.size.width +=20;
    frame.size.height += 32;
    self.xjVersionBacImageView.frame = frame;
    self.xjVersionBacImageView.image = [UIImage imageNamed:@"helpshare_background"];
    self.xjVersionBacImageView.contentMode = UIViewContentModeScaleToFill;
    */
    
    [self xj_getPlanByTopicId];//请求转发策略
}

- (UIImageView *)xjVersionBacImageView {
    if ((!_xjVersionBacImageView)) {
        _xjVersionBacImageView = [[UIImageView alloc] init];
    }
    return _xjVersionBacImageView;
}
- (UIImageView *)xjVersionImageView {
    if ((!_xjVersionImageView)) {
        _xjVersionImageView = [[UIImageView alloc] init];
    }
    return _xjVersionImageView;
}

- (void)setXjTopicDic:(NSDictionary *)xjTopicDic {
    _xjTopicDic = xjTopicDic ;
    xj_trans_temp_id = xjTopicDic[@"tempId"];
    xjTrans_base  = [XJFinalTool xjStringSafe:xj_trans_temp_id]? XJ_TRANS_HTML5 : XJ_TRANS_HTML;
}

- (void)xjEndInputEdit {
    [self.view endEditing:YES];
}

- (void)xjSetScrollView {
    //    self.xjScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setHidden: NO];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:36/255.0  green:35/255.0  blue:39/255.0 alpha:1]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    //    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:36/255.0  green:35/255.0  blue:39/255.0 alpha:1];
    [self.view setBackgroundColor:[UIColor colorWithRed:36/255.0  green:35/255.0  blue:39/255.0 alpha:1]];
    //     self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.xjImageHelpBackGroundView.backgroundColor = [UIColor colorWithRed:36/255.0  green:35/255.0  blue:39/255.0 alpha:1 ];
    
}

- (IBAction)xjShareQQ:(id)sender {
    NSString* xjRelayContentStr;
    if (xj_trans_temp_id) {
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=1&perUserId=%@&topic.tempId=%@" ,FLBaseUrl,XJ_TRANS_HTML5,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE,xj_trans_temp_id];
    } else{
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=1&perUserId=%@" ,FLBaseUrl,XJ_TRANS_HTML,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    }
    [UMSocialData defaultData].extConfig.qqData.url = xjRelayContentStr;
    [self xjShareWithType:UMShareToQQ content:self.xjTopicDic[@"topicExplain"]];
}

- (IBAction)xjShareQZone:(id)sender {
    
    NSString* xjRelayContentStr;
    if (xj_trans_temp_id) {
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=2&perUserId=%@&topic.tempId=%@" ,FLBaseUrl,XJ_TRANS_HTML5,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE,xj_trans_temp_id];
    } else{
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=2&perUserId=%@" ,FLBaseUrl,XJ_TRANS_HTML,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    }
//    NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=2&perUserId=%@",FLBaseUrl,xjTrans_base,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    [UMSocialData defaultData].extConfig.qzoneData.url = xjRelayContentStr;
    [self xjShareWithType:UMShareToQzone content:self.xjTopicDic[@"topicExplain"]];
}

- (IBAction)xjShareWeChat:(id)sender {
    NSString* xjRelayContentStr;
    if (xj_trans_temp_id) {
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=3&perUserId=%@&topic.tempId=%@" ,FLBaseUrl,XJ_TRANS_HTML5,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE,xj_trans_temp_id];
    } else{
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=3&perUserId=%@" ,FLBaseUrl,XJ_TRANS_HTML,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    }
//    NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=3&perUserId=%@",FLBaseUrl,xjTrans_base,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = xjRelayContentStr;
    [self xjShareWithType:UMShareToWechatSession content:self.xjTopicDic[@"topicExplain"]];
}

- (IBAction)xjShareWechatTimeline:(id)sender {
    NSString* xjRelayContentStr;
    if (xj_trans_temp_id) {
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=4&perUserId=%@&topic.tempId=%@" ,FLBaseUrl,XJ_TRANS_HTML5,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE,xj_trans_temp_id];
    } else{
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=4&perUserId=%@" ,FLBaseUrl,XJ_TRANS_HTML,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    }
//    NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=4&perUserId=%@",FLBaseUrl,xjTrans_base,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = xjRelayContentStr;
    [self xjShareWithType:UMShareToWechatTimeline content:self.xjTopicDic[@"topicExplain"]];
}

- (IBAction)xjShareSina:(id)sender {
    NSString* xjRelayContentStr;
    if (xj_trans_temp_id) {
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=5&perUserId=%@&topic.tempId=%@" ,FLBaseUrl,XJ_TRANS_HTML5,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE,xj_trans_temp_id];
    } else{
        xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=5&perUserId=%@" ,FLBaseUrl,XJ_TRANS_HTML,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    }
//    NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@%@topic.topicId=%@&type=5&perUserId=%@",FLBaseUrl,xjTrans_base,self.xjTopicId ? self.xjTopicId : @"",XJ_USERID_WITHTYPE];
    [UMSocialData defaultData].extConfig.sinaData.urlResource = [UMSocialData defaultData].urlResource;
    NSString* xjweiboStr =  [NSString stringWithFormat:@"%@%@",self.xjTitleLabel,xjRelayContentStr];
    [self xjShareWithType:UMShareToSina content:xjweiboStr];
}
- (IBAction)xjShareFreela:(id)sender {
    [FLTool showWith:@"暂未开通，敬请期待"];
}


- (void)xjShareWithType:(id)type content:(id)xjContent {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",XJImageBaseUrl,self.xjTopicDic[@"thumbnail"]]];
    [UMSocialData defaultData].extConfig.title = self.xjTitleLabel;
    if ([XJFinalTool xjStringSafe:self.xjTextView.text]) {
        if (![type isEqualToString:UMShareToSina] ) {
            NSString* xxx = self.xjTextView.text;
            xjContent = self.xjTextView.text;
        } else {
        }
    } else {
        xjContent = @"我在这里发现了免费的好东东，来一起玩耍吧，嘎嘎";
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:xjContent image:nil location:nil urlResource:[UMSocialData defaultData].urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            FL_Log(@"分享成功！");
        }
    }];
}

- (CGFloat)xjBottomDefaultY{
    if (!_xjBottomDefaultY) {
        _xjBottomDefaultY = self.xjBottomView.frame.origin.y;
    }
    return _xjBottomDefaultY;
}

- (void)xjTextViewDidBeganToInput:(NSNotification*)xjNoti{
    self.xjPlaceHolderLabel.hidden = YES;
    NSDictionary *userInfo = [xjNoti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘呵呵高度22是  %d",height);
    NSLog(@"键一样盘宽度22是  %d",width);
    
    CGRect frame = self.xjBottomView.frame;
    if (frame.origin.y >= self.xjBottomDefaultY) {
        frame.origin.y -= height;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            
            self.xjBottomView.frame = frame;
            //            [self.view addSubview:self.xjBottomView];
            [self.view.layer addSublayer:self.xjBottomView.layer];
            
        }];
    });
}

- (void)xjTextViewDidEndToInput:(NSNotification*)xjNoti{
    NSDictionary *userInfo = [xjNoti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度11是  %d",height);
    NSLog(@"键盘宽度11是  %d",width);
    CGRect frame = self.xjBottomView.frame;
    if (frame.origin.y < self.xjBottomDefaultY) {
        frame.origin.y += height;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.xjBottomView.frame = frame;
            //            [self.view addSubview:self.xjBottomView];
            [self.view.layer addSublayer:self.xjBottomView.layer];
        }];
    });
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.xjTextView resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)xj_getPlanByTopicId {
    [FLNetTool xj_getPlanByTopicId:_xjTopicId success:^(NSDictionary *data) {
        FL_Log(@"this is the result of relay paln===[%@]",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end










