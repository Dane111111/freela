//
//  FLAddTagsTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLAddTagsTableViewCell.h"
#import "FLMyPersonalDateTableViewController.h"
#import "UIViewController+MJPopupViewController.h"


@interface FLAddTagsTableViewCell()<FLDetialViewControllerDelegate,JFTagListDelegate>


@property (assign, nonatomic) XjTagStateType     tagStateType; //标签的模式状态（显示、选择、编辑）

/**popView*/
@property (nonatomic , strong) FLPopBaseView* popView;
@end

@implementation FLAddTagsTableViewCell

- (void)awakeFromNib
{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.tagView = [[UIView alloc] init];

        [self.contentView addSubview:self.tagView];
        //label
        self.flSingleLabel = [[UILabel alloc] init];
        self.flSingleLabel.text = @"个性标签";
        self.flSingleLabel.textAlignment = NSTextAlignmentCenter;
        self.flSingleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
        [self.contentView addSubview:self.flSingleLabel];
        self.fltagsArrMu = [NSMutableArray array];
        [self allocSomeThingInCell];
        [self makeConstraints];
    }
    return self;
}

- (void)allocSomeThingInCell
{
    //    self.tagsMuArray = [NSMutableArray arrayWithArray:@[@"姓名",@"手机号码",@"性别",@"地址"]];
    self.tagStateType = XjTagStateTypeOnlyShow;//选择模式
    CGRect frame = self.contentView.frame;
    frame.origin.y = 30;
    frame.size.width = FLUISCREENBOUNDS.width ;
    //TagView
    self.tagList = [[JFTagListView alloc] initWithFrame:frame];
    self.tagList.is_can_addTag = YES;
    self.tagList.delegate = self;
    
    [self.tagView addSubview:self.tagList];
    //    self.tagList.tagBackgroundColor = [UIColor blueColor];
    //    self.tagList.tagTextColor = [UIColor whiteColor];
    //以下属性是可选的
    self.tagList.is_can_addTag = YES;    //如果是要有最后一个按钮是添加按钮的情况，那么为Yes
    self.tagList.tagCornerRadius = 13;  //标签圆角的大小，默认10
    self.tagList.tagStateType = self.tagStateType;  //标签模式，默认显示模式
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeConstraints
{
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.tagView.backgroundColor = [UIColor redColor];
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    [_flSingleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        _flSingleLabel.textAlignment = NSTextAlignmentLeft;
        make.top.equalTo(self.tagView).with.offset(1 * FL_SCREEN_PROPORTION_height);
        make.left.equalTo(self.tagView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(180 * FL_SCREEN_PROPORTION_width, 30 * FL_SCREEN_PROPORTION_height));
    }];
   

}

- (void)addTargetBtn
{
    
    BOOL isUnderNetWork = [FLTool isNetworkEnabled];
    if (isUnderNetWork)
    {
        
        if (self.tagsArray.count >= 10)
        {
            FL_Log(@"ssssss");
            [[FLAppDelegate share] showHUDWithTitile:@"最多添加十个标签" view:self.vvvc.view delay:1 offsetY:-20];
        }
        else
        {
            
            FL_Log(@"加一个 ，再加一个incell");
            FLPopBaseView* popView = [[FLPopBaseView alloc] initWithTitle:@"请填写标签" delegate:self.vvvc andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 6 lengthType:FLLengthTypeLength originalStr:nil];
            popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
            self.vvvc.popViewTag = 60;
            [self.vvvc.view addSubview:popView];
        }
    }
    else
    {
        MBProgressHUD *HUD = [FLTool createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_hud_error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"网络连接不正常"];
        [HUD hide:YES afterDelay:1];//$$$$
    }
    
}

//- (void)setUseriN:(FLUserInfoModel *)useriN
//{
//    _useriN = useriN;
//    self.tagsArray = _useriN.fltagsArray;
//    [self getTagsFromUser];
//}

- (void)setFltagsArrMu:(NSMutableArray *)fltagsArrMu{
    _fltagsArrMu = fltagsArrMu;
    if (fltagsArrMu.count == 0 ||!fltagsArrMu) {
        
    } else {
        [self.tagList reloadData:self.fltagsArrMu andTime:0 flselectedArr:nil];
    }
}

- (void)getTagsFromUser
{
    [self.fltagsArrMu removeAllObjects];
    for (NSString* str in self.tagsArray) {
        [self.fltagsArrMu addObject:str];
    }
    
    [self.tagList reloadData:self.fltagsArrMu andTime:0 flselectedArr:nil];

}


//标签的点击事件
-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex WithType:(NSInteger)fltype
{
    FL_Log(@"tagindex =%ld",buttonIndex);
    //    type   1为选择  2为删除
    
    switch (fltype) {
        case 1:
        {
//            [self changeTagColor:buttonIndex];
        }
            break;
        case 2:
        {
            [self deleteTagRequest:buttonIndex]; //删除tag
        }
            break;
        default:
            break;
    }
    
}

#pragma mark- 删除Tag

-(void)deleteTagRequest:(NSInteger)index{
    
    FL_Log(@"代理事件1，点击第%ld个",index);
    [self.fltagsArrMu removeObjectAtIndex:index];
    [self.tagList reloadData:self.fltagsArrMu andTime:0 flselectedArr:nil];
    self.tagsArray = self.fltagsArrMu.mutableCopy;
    [self sendTagToService];
    [self.vvvc.tableView reloadData];
}


- (void)showAddTagView
{
    for (NSString*xjStr in self.fltagsArrMu) {
        if ([xjStr isEqualToString:@""]) {
            [self.fltagsArrMu removeObject:@""];
        }
    }
    FL_Log(@"this is thr delegate to show add tag view");
    if (self.fltagsArrMu.count >= 3) {
        [[FLAppDelegate share] showHUDWithTitile:@"标签当前最多为3个" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FLShowAddtagPopViewInMine" object:nil];
    }
   
}

- (void)sendTagToService
{
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"tags\":\"%@\",\"userId\":\"%@\"}",FL_ALL_SESSIONID,[self.tagsArray componentsJoinedByString:@","],FL_USERDEFAULTS_USERID_NEW];
    FL_Log(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"send my tags success data = %@",data);
    } failure:^(NSError *error) {
        FL_Log(@"send my tags error = %@, == %@",error.description,error.debugDescription);
    }];
}

- (void)tagList:(JFTagListView *)taglist heightForView:(float)listHeight{
    FL_Log(@"this is the hhhh=%lf",listHeight);
    self.xjTagH = listHeight;
}

@end








