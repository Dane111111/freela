//
//  FLAboutUsViewController.m
//  FreeLa
//
//  Created by Leon on 16/2/2.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLAboutUsViewController.h"

@interface FLAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView* tableView;


@end

@implementation FLAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"关于我们";
    [self xjInitPage];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (void)xjInitPage {
    self.tableView.delegate = self;
    self.tableView. dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    UIView* xjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 160)];
    UIImageView* xjImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"official"]];
    [xjView addSubview:xjImage];
    [xjImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    UILabel* xjName = [[UILabel alloc] init];
        [xjView addSubview:xjName];
        xjName.text = @"免费啦";
    xjName.font = [UIFont fontWithName:FL_FONT_NAME size:16];
        [xjName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(xjImage.mas_bottom).offset(10);
            make.centerX.equalTo(xjImage).offset(0);
        }];
    
    self.tableView.tableHeaderView = xjView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xjCell"];
    NSArray* xjTitleArr = @[@"微信公众号",@"新浪微博",@"商务合作",@"客户服务",@"客服QQ"];
    NSArray* xjDetailArr = @[@"freela100",@"免费啦",@"biz@freela.com.cn",@"service@freela.com.cn",@"2975665107"];
    cell.detailTextLabel.text = xjDetailArr[indexPath.row];
    cell.textLabel.text = xjTitleArr[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* xjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 160)];
    UIImageView* xjImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"official"]];
    [xjView addSubview:xjImage];
    [xjImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    UILabel* xjName = [[UILabel alloc] init];
//    [xjView addSubview:xjName];
//    xjName.text = @"免费啦";
//    [xjName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(xjImage.mas_bottom).offset(0);
//        make.center.equalTo(xjImage).offset(0);
//    }];
    return xjView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end






