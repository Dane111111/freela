//
//  FLMessageSettingSViewController.m
//  FreeLa
//
//  Created by Leon on 16/2/2.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMessageSettingSViewController.h"

@interface FLMessageSettingSViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArr;
}

@property (nonatomic , strong) UITableView* fltableView;
@property (nonatomic , strong) FLSetMessageTableViewCell* flcell;
@end

@implementation FLMessageSettingSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息设置";
    self.fltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStyleGrouped];
    self.fltableView.delegate = self;
    self.fltableView.dataSource = self;
    [self.view addSubview:self.fltableView];
    [self.fltableView registerNib:[UINib nibWithNibName:@"FLSetMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLSetMessageTableViewCell"];
    _titleArr = @[@"声音",@"震动"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.flcell =  [tableView dequeueReusableCellWithIdentifier:@"FLSetMessageTableViewCell" forIndexPath:indexPath];
    self.flcell.fltitleLabel.text = _titleArr[indexPath.row];
    self.flcell.flStateSwitch.tag = indexPath.row + 10;
    [self.flcell.flStateSwitch addTarget:self action:@selector(flMyMessageSetting:) forControlEvents:UIControlEventValueChanged];
    self.flcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.flcell;
}

- (void)flMyMessageSetting:(UISwitch*)flswitch
{
    NSInteger switchSelect = flswitch.tag;
    switch (switchSelect) {
        case 10:
            FL_Log(@"10101001010010101001switch");
            break;
        case 11:
            FL_Log(@"111111111111111switch");
            break;
        default:
            break;
    }
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
