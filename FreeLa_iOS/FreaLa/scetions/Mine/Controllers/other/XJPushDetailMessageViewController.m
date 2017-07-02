//
//  XJPushDetailMessageViewController.m
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
//   获取当前页  fltool xjRetuenCurrentWithArrLength

#import "XJPushDetailMessageViewController.h"
#import "XJPushDetailsMessagesTableViewCell.h"
#import "XJPushDetailModel.h"
@interface XJPushDetailMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _xjtotal;  //总个数
    NSInteger _xjCurrentPage; //当前页
    NSArray* _xjCellH;//cell高度
}
@property (nonatomic , strong) XJTableView* xjTableView;

/**model arr*/
@property (nonatomic , strong) NSMutableArray* xjMessageModelArr;

@end

@implementation XJPushDetailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.xjTableView = [[XJTableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStylePlain];
    self.xjTableView.delegate = self;
    self.xjTableView.dataSource = self;
    self.xjTableView.tableFooterView = [[UIView alloc] init];
    //    self.view.backgroundColor = [UIColor whiteColor];
    [self.xjTableView registerNib:[UINib nibWithNibName:@"XJPushDetailsMessagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJPushDetailsMessagesTableViewCell"];
    [self.view addSubview:self.xjTableView];
    self.xjTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.xjTableView.mj_header =  [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataWithTableViewPushMessage)];
    self.xjTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataInTableViewPushMessage)];
    [self.xjTableView.mj_header beginRefreshing];
    [self xjChangeState]; //改变状态 为已读
}

- (XJTableView *)xjTableView{
    if (!_xjTableView) {
        _xjTableView = [[XJTableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStylePlain];
    }
    return _xjTableView;
}

- (void)loadNewDataWithTableViewPushMessage {
    [self.xjMessageModelArr removeAllObjects];
    [self xjGetPushDetailMessagesWithCurrentPage:[NSNumber numberWithInteger:1]];
}

- (void)loadMoreDataInTableViewPushMessage{
    NSNumber* xjInt = [FLTool xjRetuenCurrentWithArrLength:self.xjMessageModelArr.count andTotal:_xjtotal xjSize:10];
    [self xjGetPushDetailMessagesWithCurrentPage:xjInt];
}

- (void)xjEndRefreshWithXJTotal:(NSInteger)xjTotal {
    [self.xjTableView.mj_header endRefreshing];
    if (self.xjMessageModelArr.count >= xjTotal) {
        [self.xjTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.xjTableView.mj_footer endRefreshing];
    }
    
}

- (NSMutableArray *)xjMessageModelArr {
    if (!_xjMessageModelArr) {
        _xjMessageModelArr = [NSMutableArray array];
    }
    return _xjMessageModelArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    
}


- (void)xjGetPushDetailMessagesWithCurrentPage:(NSNumber*)xjCPage {
    NSDictionary* parm = @{@"msgPush.targetUserId":XJ_USERID_WITHTYPE,
                           @"msgPush.targetUserType":XJ_USERTYPE_WITHTYPE,
                           @"msgPush.msgType":[NSString stringWithFormat:@"%ld",self.xjMessageType],
                           @"page.currentPage":xjCPage,
                           @"page.pageSize":@"10"};
    [FLNetTool xjGetDetailPushMessagesByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the detail push1 messages=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSMutableArray* xjMuArr = @[].mutableCopy;
            xjMuArr = [XJPushDetailModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            [self.xjMessageModelArr addObjectsFromArray:xjMuArr];
            //            FL_Log(@"this is the detail push2 messages=%@",self.xjMessageModelArr);
            _xjtotal = [data[@"total"] integerValue];
            [self xjSetInfoHeigthArrWithDic:self.xjMessageModelArr];
            
            [FLTool xjSetEmptyStateWithTotal:_xjtotal with:self.xjTableView]; //设置空白状态
        }
        [self xjEndRefreshWithXJTotal:[data[@"total"] integerValue]];
    } failure:^(NSError *error) {
        [self xjEndRefreshWithXJTotal:0];
    }];
}
- (void)xjSetInfoHeigthArrWithDic:(NSArray*)xjArr{
    NSMutableArray*xjMuarr = @[].mutableCopy;
    //    xjCellHeight
    CGFloat xjHow;
    for (XJPushDetailModel* xjModel in xjArr) {
        xjHow = [FLTool xjReturnCellHWithWidth:FLUISCREENBOUNDS.width - 50 text:xjModel.msgContent fontSize:12];
        xjModel.xjCellHeight =xjHow*12;
        if ([xjModel.msgContent rangeOfString:@"\n"].location!=NSNotFound) {
            NSArray* xjArr = [xjModel.msgContent componentsSeparatedByString:@"\n"];
            xjModel.xjCellHeight = (xjHow + xjArr.count ) *12;
        }
        [xjMuarr addObject:xjModel];
    }
    self.xjMessageModelArr = xjMuarr;
    [self.xjTableView reloadData];
}

#pragma mark 改变状态
- (void)xjChangeState {
    NSDictionary* parm = @{@"msgPush.targetUserId":XJ_USERID_WITHTYPE,
                           @"msgPush.targetUserType":XJ_USERTYPE_WITHTYPE,
                           @"msgPush.msgType":[NSString stringWithFormat:@"%ld",self.xjMessageType]};
    [FLNetTool xjChangePushMessageState:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result to change the message state =%@",data);
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.xjMessageModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.xjMessageModelArr.count > indexPath.row) {
        XJPushDetailModel* xjModel = self.xjMessageModelArr[indexPath.row];
        return 100 + xjModel.xjCellHeight;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJPushDetailsMessagesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XJPushDetailsMessagesTableViewCell" forIndexPath:indexPath];
    if (self.xjMessageModelArr.count >= indexPath.row ) {
        cell.xjModel = self.xjMessageModelArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end



