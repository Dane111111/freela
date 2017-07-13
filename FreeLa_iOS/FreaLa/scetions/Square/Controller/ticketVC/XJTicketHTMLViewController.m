//
//  XJTicketHTMLViewController.m
//  FreeLa
//
//  Created by Leon on 16/3/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJTicketHTMLViewController.h"
#import "FLMyReceiveTicketView.h"
#import "FLMineInfoModel.h"
#import "XJTicketNumberModel.h"
#import "XJMyTicketView.h"
@interface XJTicketHTMLViewController ()<XJMyTicketViewDelegate>
/**票券页*/
@property (nonatomic , strong) FLMyReceiveTicketView* flMyTicketView;
@property (nonatomic , strong) XJMyTicketView* xjMyTicketView;
@property (nonatomic , strong) UIScrollView* xjScrollView;

/**我的信息*/
@property (nonatomic  , strong) FLMineInfoModel* flMineInfoModel;
/**model for ticket*/
@property (nonatomic , strong) XJTicketNumberModel* xjTicketNumberModel;
@end

@implementation XJTicketHTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"票券";
    [self xjGetTicketNum];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"票券" withColor:[UIColor blackColor]];

//    [self.navigationController.navigationBar setHidden:NO];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self seeInfoInHtmlVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.leftBtn setImage:[UIImage imageNamed:@"return_x"] forState:UIControlStateNormal];

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
         
            [self creatrUIInReceiveTicketsVC];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (FLMyReceiveTicketView *)flMyTicketView{
    if (!_flMyTicketView) {
         _flMyTicketView = [[FLMyReceiveTicketView alloc] init];
    }
    return _flMyTicketView;
}
- (XJMyTicketView *)xjMyTicketView {
    if (!_xjMyTicketView) {
        _xjMyTicketView = [[XJMyTicketView alloc] initWithUserId:nil];
    }
    return _xjMyTicketView;
}
- (UIScrollView *)xjScrollView {
    if (!_xjScrollView) {
        _xjScrollView  = [[UIScrollView alloc] init];
        _xjScrollView.frame = CGRectMake(0,  StatusBar_NaviHeight, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
    }
    return _xjScrollView;
}


#pragma mark UI
- (void)creatrUIInReceiveTicketsVC
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.xjScrollView];
//    self.flMyTicketView = [[FLMyReceiveTicketView alloc] init];
    self.flMyTicketView.flMineInfoModel = self.flMineInfoModel;
    self.xjMyTicketView.xjMineInfoModel = self.flMineInfoModel;
    self.flmyReceiveMineModel.flStateInt = 0;
    self.xjMyTicketView.delegate = self;
    [self.xjScrollView addSubview:self.xjMyTicketView];
    self.flMyTicketView.flMyReceiveInMineModel = self.flmyReceiveMineModel;
    self.xjMyTicketView.xjMyReceiveInMineModel = self.flmyReceiveMineModel;
//    [self.view addSubview:self.flMyTicketView];
    [self.flMyTicketView.xjUseBtn addTarget:self action:@selector(testUserTickets) forControlEvents:UIControlEventTouchUpInside];
    //使用btn
    //    UIButton* testUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    testUseBtn = self.flMyTicketView.xjUseBtn ;
    //    testUseBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:14];
    //    [testUseBtn setTitle:@"使用" forState:UIControlStateNormal];
    //    [testUseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    ////    testUseBtn.frame = CGRectMake(300, 100, 100, 30);
    //    [self.view addSubview:testUseBtn];
    //    [testUseBtn addTarget:self action:@selector(testUserTickets) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger flstate = _flmyReceiveMineModel.flStateInt;
    if ( _flmyReceiveMineModel.xjUrl.length!=0) {
        FL_Log(@"ticket has already used");
        self.flMyTicketView.xjUseBtn.hidden = NO;
    } else {
        FL_Log(@"ticket has not  already used");
        self.flMyTicketView.xjUseBtn.hidden = YES;
    }
}
- (void)xjClickUsrNoewInMyTicketView {
    [self testUserTickets];
}


- (void)testUserTickets
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSInteger flstate = _flmyReceiveMineModel.flStateInt;
    if (flstate !=1 ) {
        //这里是扫码接口
        NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                               @"participateDetailes.detailsid":_flmyReceiveMineModel.flDetailsIdStr,
                               @"participateDetailes.topicId":_flmyReceiveMineModel.flMineIssueTopicIdStr,
                               @"participateDetailes.userId":[NSNumber numberWithInteger:_flmyReceiveMineModel.xjUserId],
                               @"participateDetailes.creator":[NSNumber numberWithInteger:_flmyReceiveMineModel.xjCreator],
                               @"participateDetailes.userType":_flmyReceiveMineModel.xjUserType,
                               @"participateDetailes.checkUser":@""
                               };
        [FLNetTool fluseDetailesByIDWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"thisi is my test useticket with html=%@",data);
            if ([data[FL_NET_KEY_NEW] boolValue]) {
                [[FLAppDelegate share] showHUDWithTitile:@"使用成功" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                _flmyReceiveMineModel.flStateInt = 1;
//                [self creatrUIInReceiveTicketsVC];
            } else {
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    //跳转至url
    NSString* xjStr = [[NSString stringWithFormat:@"%@", _flmyReceiveMineModel.xjUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString* xjMu = [NSMutableString stringWithString:xjStr];
    xjStr = [xjMu stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:xjStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:xjStr]];
    } else {
        [FLTool showWith:@"链接不可用"];
    }
}

- (void)xjGetTicketNum {
    if (!_flmyReceiveMineModel) {
        return;
    }
    NSDictionary* parm = @{@"topicId":_flmyReceiveMineModel.flMineIssueTopicIdStr,
                           @"detailsId":_flmyReceiveMineModel.flDetailsIdStr,
                           @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool xjGetTicketNumber:parm success:^(NSDictionary *data) {
        FL_Log(@"this istthe ticket 111number =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjTicketNumberModel = [XJTicketNumberModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
            self.flMyTicketView.xjTicketNumberModel = self.xjTicketNumberModel;
            self.xjMyTicketView.xjTicketNumberModel = self.xjTicketNumberModel;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjRefreshViewFrameWithTickHeight:(CGFloat)xjTicketFloatH {
    self.xjMyTicketView.frame = CGRectMake(20, 20, FLUISCREENBOUNDS.width-40, xjTicketFloatH);
    self.xjScrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width,  xjTicketFloatH  + 40);
    [self.xjScrollView addSubview:self.xjMyTicketView];
}



@end
