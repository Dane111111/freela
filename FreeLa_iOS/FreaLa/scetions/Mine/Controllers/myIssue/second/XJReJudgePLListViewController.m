//
//  XJReJudgePLListViewController.m
//  FreeLa
//
//  Created by Leon on 16/3/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJReJudgePLListViewController.h"
#import "XJJudgeBackModel.h"
#import "XJJudgeBackListTableViewCell.h"
#import "XJMainJudgeTableViewCell.h"

@interface XJReJudgePLListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) UITableView* xjTableView;
@property (nonatomic , strong) NSArray* xjModelArr;
/**弹出层*/
@property (nonatomic , strong) FLPopBaseView* popView;


/**我发布的模型*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmyIssueInMineModel;
@end

@implementation XJReJudgePLListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self allocTableView];//tableview
    [self getRejudgeListInJudgeBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark init tableview
- (void)allocTableView
{
    self.xjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.xjTableView];
    self.xjTableView.delegate = self;
    self.xjTableView.dataSource = self;
    [self.xjTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.xjTableView registerNib:[UINib nibWithNibName:@"XJJudgeBackListTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJJudgeBackListTableViewCell"];
    [self.xjTableView registerNib:[UINib nibWithNibName:@"XJMainJudgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJMainJudgeTableViewCell"];
    
}

#pragma mark  -------- datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        XJMainJudgeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"XJMainJudgeTableViewCell" forIndexPath:indexPath];
        cell.xjPLModel = self.flPLModel;
        [cell.xjReJudgeBtn addTarget:self action:@selector(xjReJudgeBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        XJJudgeBackListTableViewCell* celly = [tableView dequeueReusableCellWithIdentifier:@"XJJudgeBackListTableViewCell" forIndexPath:indexPath];
        celly.xjModel = self.xjModelArr[indexPath.row];
        return celly;
    }
    
}
#pragma mark  -------- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 && self.xjModelArr) {
        return self.xjModelArr.count;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark --------- 回复
- (void)xjReJudgeBtnClickAction
{
    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写回复内容" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 40 lengthType:FLLengthTypeLength originalStr:nil];
    [_popView.flInputTextField becomeFirstResponder];
    _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_popView];
        
        //    flReJudgegetInfoInHTML
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

#pragma mark -- ---- --request

#pragma mark 得到回评列表
- (void)getRejudgeListInJudgeBack
{
    NSDictionary*  commentPara = @{@"parentId":self.flPLModel.commentId};
    NSDictionary*  parm  = @{@"userId":XJ_USERID_WITHTYPE,
                             @"userType":XJ_USERTYPE_WITHTYPE,
                             @"commentPara":[FLTool returnDictionaryToJson:commentPara]};
    
    [FLNetTool HTMLRejudgeListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"rejudge li1st in html =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
           _xjModelArr = [XJJudgeBackModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
            [self xjReturnCellHWithArr:_xjModelArr];
        }
    } failure:^(NSError *error) {
        FL_Log(@"eeeerroeer =%@",error);
    }];
}

- (void)xjReturnCellHWithArr:(NSArray*)xjarr {
    NSMutableArray* xjMuarr = @[].mutableCopy;
    CGFloat xjFloat ;
    for (XJJudgeBackModel* xjModel in xjarr) {
        xjFloat = [FLTool xjReturnCellHWithWidth:FLUISCREENBOUNDS.width - 60 text:xjModel.content fontSize:12];
        xjModel.xjAddCellHeight = xjFloat * 12;
        [xjMuarr addObject:xjModel];
    }
    _xjModelArr = xjMuarr.mutableCopy;
    [self.xjTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    if (_xjModelArr.count > indexPath.row) {
         XJJudgeBackModel* xjModel = _xjModelArr[indexPath.row];
        return  80 + xjModel.xjAddCellHeight;
    }
    return 80;
}



- (void) entrueBtnClickWithStr:(NSString *)result {
    
    if (!FLFLIsPersonalAccountType) {
        [FLTool showWith:@"当前版本暂不支持商家回评"];
        return;
    }
    
    //插入回评记录
    NSDictionary* dic = @{@"businessId":_xjTopicIdStr ,
                          @"commentType":@"2",   //2代表回复
                          @"content":_popView.flInputTextField.text,
                          @"parentId":self.flPLModel.commentId};
    NSDictionary* parm =@{@"commentPara":[FLTool returnDictionaryToJson:dic],
                          @"userType":XJ_USERTYPE_WITHTYPE,
                          @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"insert comment in html rejudge in xjthml = %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self getRejudgeListInJudgeBack];//请求新数据
        } else {
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in insert comment html =%@",error);
    }];
}

@end









