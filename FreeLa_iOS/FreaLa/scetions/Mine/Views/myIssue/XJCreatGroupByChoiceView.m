//
//  XJCreatGroupByChoiceView.m
//  FreeLa
//
//  Created by Leon on 16/6/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJCreatGroupByChoiceView.h"
#define xj_tableview_h      50
#define xj_view_w           FLUISCREENBOUNDS.width* 0.8

@interface XJCreatGroupCell : UITableViewCell
@property (nonatomic , strong) NSString* xjContent;
@end

@implementation XJCreatGroupCell
{
    UILabel* xjLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xjCreatViewView];
    }
    return self;
}

- (void)xjCreatViewView {
    xjLabel = [[UILabel alloc] init];
    xjLabel.frame = CGRectMake(0, 0, xj_view_w, xj_tableview_h);
    [self.contentView addSubview:xjLabel];
    xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    xjLabel.textAlignment = NSTextAlignmentCenter;
//    xjLabel.backgroundColor = [UIColor redColor];
}
- (void)setXjContent:(NSString *)xjContent {
    xjLabel.text = xjContent;
 
}

@end



@interface XJCreatGroupByChoiceView ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation XJCreatGroupByChoiceView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xjInitPaage];
    }
    return self;
}

- (void)xjInitPaage {
    self.sframe.frame = CGRectMake(FLUISCREENBOUNDS.width*0.1, 0, xj_view_w, xj_tableview_h*3);
    UITableView* xjTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.sframe.width, self.sframe.height)];
    [self.sframe addSubview:xjTabView];
    xjTabView.delegate = self;
    xjTabView.dataSource = self;
    xjTabView.rowHeight = xj_tableview_h;
    [self show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJCreatGroupCell* cell = [[XJCreatGroupCell alloc] init];
    cell.xjContent = @[@"全选",@"已领取",@"已参与未领取"][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        self.xjType = XJCreatGroupTypeAll;
    } else if (indexPath.row==1) {
        self.xjType = XJCreatGroupTypePickList;
    } else if (indexPath.row==2) {
        self.xjType = XJCreatGroupTypePartWithOutPick;
    }

    if ([self.delegate respondsToSelector:@selector(xjTouchIndexRowWithIndex:)]) {
        [self hide];
        [self.delegate xjTouchIndexRowWithIndex:self.xjType];
    }
}

@end














