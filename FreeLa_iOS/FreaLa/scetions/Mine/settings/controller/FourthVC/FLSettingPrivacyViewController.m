//
//  FLSettingPrivacyViewController.m
//  FreeLa
//
//  Created by Leon on 16/2/2.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLSettingPrivacyViewController.h"

@interface FLSettingPrivacyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArr;
}

@property (nonatomic , strong) UITableView* fltableView;
@end

@implementation FLSettingPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私设置";
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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.flcell =  [tableView dequeueReusableCellWithIdentifier:@"FLSetMessageTableViewCell" forIndexPath:indexPath];
//    self.flcell.fltitleLabel.text = _titleArr[indexPath.row];
//    self.flcell.flStateSwitch.tag = indexPath.row + 10;
//    [self.flcell.flStateSwitch addTarget:self action:@selector(flMyMessageSetting:) forControlEvents:UIControlEventValueChanged];
//    return self.flcell;
}
*/
@end
