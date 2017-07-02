//
//  FLCheckVersionViewController.m
//  FreeLa
//
//  Created by Leon on 16/2/3.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLCheckVersionViewController.h"

@interface FLCheckVersionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArr;
    NSArray* _valueArr;
}

@property (nonatomic , strong) UITableView* fltableView;

/**image*/
@property (nonatomic , strong) UIImageView* flHeaderImageView;
@end

@implementation FLCheckVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"查看版本";
    [self creatUIInCheckVersion];
    NSString* versionLocal = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _titleArr = @[@"版本号"];
    _valueArr = @[[NSString stringWithFormat:@"%@",versionLocal]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatUIInCheckVersion{
    self.fltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStyleGrouped];
    [self.fltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xjcell"];
    self.fltableView.delegate = self;
    self.fltableView.dataSource = self;
    [self.view addSubview:self.fltableView];
    
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height * 0.4)];
    self.fltableView.tableHeaderView = backView;
    self.flHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake((FLUISCREENBOUNDS.width / 2) - 40, backView.height * 0.4, 80, 80)];
    [backView addSubview:self.flHeaderImageView];
    self.flHeaderImageView.image = [UIImage imageNamed:@"official"];
    self.flHeaderImageView.layer.cornerRadius = 40;
    self.flHeaderImageView.layer.masksToBounds = YES;
    
    
    //名字
    FLGrayLabel* nameLabel = [[FLGrayLabel alloc] init];
    [backView addSubview:nameLabel];
    nameLabel.text = @"免费啦";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithName:FL_FONT_NAME size:16];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flHeaderImageView.mas_bottom).with.offset(5);
        make.centerX.equalTo(backView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width, 20));
    }];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"xjcell" forIndexPath:indexPath];
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xjcell"];
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.detailTextLabel.text = _valueArr[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

 

@end









