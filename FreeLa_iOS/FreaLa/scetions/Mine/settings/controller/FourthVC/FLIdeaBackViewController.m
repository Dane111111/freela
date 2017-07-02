//
//  FLIdeaBackViewController.m
//  FreeLa
//
//  Created by Leon on 16/2/2.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLIdeaBackViewController.h"

@interface FLIdeaBackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *flDetailTextView;

@end

@implementation FLIdeaBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickActionDoneInIdeaBack)];
//    self.navigationItem.rightBarButtonItem = item;
    
    
    UIButton* xjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:xjBtn];
    [xjBtn addTarget:self action:@selector(clickActionDoneInIdeaBack) forControlEvents:UIControlEventTouchUpInside];
    [xjBtn setTitle:@"提交" forState:UIControlStateNormal];
    [xjBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xjBtn setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
    xjBtn.frame = CGRectMake(40, 280, FLUISCREENBOUNDS.width-80, 40);
    xjBtn.layer.cornerRadius = 20;
    xjBtn.layer.masksToBounds = YES;
}

- (void)clickActionDoneInIdeaBack
{
    
    if(![XJFinalTool xjStringSafe:self.flDetailTextView.text]){
        [FLTool showWith:@"内容不能为空"];
        return;
    }
    
    NSDictionary* parm =@{@"info.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                          @"info.type":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                          @"info.infoRemark":self.flDetailTextView.text,
                          @"token":FL_ALL_SESSIONID};
    [FLNetTool flideaBackByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"this my idea back=%@",dic);
        if ([dic[FL_NET_KEY_NEW] boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:@"提交成功" view:self.view delay:1 offsetY:0];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[FLAppDelegate share] showHUDWithTitile:@"网络忙，请稍后重试" view:self.view delay:1 offsetY:0];
        }
    } failure:^(NSError *error) {
        
    }];

}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
