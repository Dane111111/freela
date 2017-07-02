//
//  XJPushMessageListViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJPushMessageListViewController.h"
#import "XJPushMessageListTableViewCell.h"
#import "XJPushMessageListModel.h"
#import "XJPushDetailMessageViewController.h"
@interface XJPushMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString* _xjMessageTypeStr;
}
@property (nonatomic , strong) UITableView* xjTableView;
/**messageArr*/
@property (nonatomic , strong) NSArray* xjMessageArr;
/**model arr*/
@property (nonatomic , strong) NSArray* xjMessageModelArr;

@end

@implementation XJPushMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.xjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStylePlain];
    self.xjTableView.delegate = self;
    self.xjTableView.dataSource = self;
    self.xjTableView.tableFooterView = [[UIView alloc] init];
    [self.xjTableView registerNib:[UINib nibWithNibName:@"XJPushMessageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJPushMessageListTableViewCell"];
    self.xjMessageArr = @[@"系统消息",@"审批认证消息",@"授权消息",@"商家推送消息"];
    [self.view addSubview:self.xjTableView];
    self.xjTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _xjMessageTypeStr = @"1,6,7,8";
//    self.xjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self xjGetPushMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.title =@"我的消息";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationController.navigationItem.leftBarButtonItem=right;
}

-(void)pop{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)xjGetPushMessage {
    NSDictionary* parm = @{@"msgPush.targetUserId":XJ_USERID_WITHTYPE,
                           @"msgPush.targetUserType":XJ_USERTYPE_WITHTYPE,
                           @"types":_xjMessageTypeStr};
    [FLNetTool xjGetPushMessagesByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the pu4sh message that i don't read =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            XJPushMessageListModel* xjxj = [XJPushMessageListModel mj_objectWithKeyValues:data];
            self.xjMessageModelArr = @[[NSString stringWithFormat:@"%ld",xjxj.count1],[NSString stringWithFormat:@"%ld",xjxj.count6],[NSString stringWithFormat:@"%ld",xjxj.count7],[NSString stringWithFormat:@"%ld",xjxj.count8]];
//            FL_Log(@"this is the pu5sh message that i don't read =%@",self.xjMessageModelArr);
            [self.xjTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)xjGetPushDetailMessages {
    NSDictionary* parm = @{@"msgPush.targetUserId":XJ_USERID_WITHTYPE,
                           @"msgPush.targetUserType":XJ_USERTYPE_WITHTYPE,
                           @"msgPush.msgType":@"1",
                           @"page.currentPage":@"1",
                           @"page.pageSize":@"10"};
    [FLNetTool xjGetDetailPushMessagesByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the detail push3 messages=%@",data);
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.xjMessageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJPushMessageListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XJPushMessageListTableViewCell" forIndexPath:indexPath];
    cell.xjTitleLabel.text = self.xjMessageArr[indexPath.row];
    cell.xjInfo = self.xjMessageModelArr[indexPath.row];
    cell.xjHeaderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_pushMessage_%ld",indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self test:indexPath.row];
    XJPushDetailMessageViewController* xjVc = [[XJPushDetailMessageViewController alloc]init];
    NSArray* jj = [_xjMessageTypeStr componentsSeparatedByString:@","];
    xjVc.title = self.xjMessageArr[indexPath.row];
    xjVc.xjMessageType = [jj[indexPath.row] integerValue];
    [self.navigationController pushViewController:xjVc animated:YES];
}

- (void)test:(NSInteger)xjInt {
    NSMutableArray* xjMuArr = self.xjMessageModelArr.mutableCopy;
    NSString* xjStr = self.xjMessageModelArr[xjInt];
    xjStr = @"0";
    [xjMuArr replaceObjectAtIndex:xjInt withObject:xjStr];
    self.xjMessageModelArr = xjMuArr.mutableCopy;
    [self.xjTableView reloadData];
    
}

@end













