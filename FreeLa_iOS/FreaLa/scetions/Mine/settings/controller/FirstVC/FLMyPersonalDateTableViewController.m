//
//  FLMyPersonalDateTableViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLMyPersonalDateTableViewController.h"

#import <Masonry/Masonry.h>
#import "FLHeader.h"
#import "HexColors.h"
#import "UIViewController+MJPopupViewController.h"
#import "FLDetialViewController.h"
#import "FLChangePhoneNumberTableViewController.h"
//#import "FLDatePickerViewController.h"
#import "FLDateAndTimePickerViewController.h"
#import "FLUserInfoModel.h"
#import "FLSexChoiceTableViewController.h"
#import "FLDiscribeMyselfViewController.h"
#import "FLChangeMyAccountTableViewController.h"
#import "FLChangeNameViewController.h"
#import "FLConst.h"
#import "FLPopBaseView.h"

#import "JFTagListView.h"
#import "YYKit.h"


typedef NS_ENUM (NSUInteger, FLPortrainImageType) {
    FLPortrainImageTypeImage = 1,
    FLPortrainImageTypeUrl   = 2,
};

@interface FLMyPersonalDateTableViewController ()
<UITableViewDelegate,
UITableViewDataSource,                                            //添加tag
FLDetialViewControllerDelegate,                             //pop view
FLDateAndTimePickerViewControllerDelegate,                  //时间选择器
FLChangePhoneNumberTableViewControllerDelegate,             //手机号协议
FLSexChoiceTableViewControllerDelegate,                     //性别选择
UIImagePickerControllerDelegate,                            //头像选择
UINavigationControllerDelegate,
UIActionSheetDelegate,
FLDiscribeMyselfViewControllerDelegate,
FLChangeNameViewControllerDelegate,
FLPopBaseViewDelegate,
FLBlindWithThirdTableViewControllerDelegate,
FLChangeAddressViewControllerDelegate,JFTagListDelegate
>

@property (nonatomic , strong)UIView* myHeaderView;
@property (nonatomic , strong)UIImageView *backgroundImageView;//背景
@property (nonatomic , strong)UIImageView* portraitImageView; //肖像
@property (nonatomic , strong)UIButton*    portraitBtn;//头像button
@property (nonatomic , strong)UIImageView* tipImageView;//提示图片
/**名称的button*/
@property (nonatomic , strong)UIButton* myNameButton;
@property (nonatomic , strong)UIButton* changeAccountBtn; // 改变账户
//@property (nonatomic , assign)CGFloat cellHeight;
@property (nonatomic , strong)FLUserInfoModel* userInfoModel; // 用户信息

//标签栏
@property (nonatomic , strong)UIView* tagView;

//手机号等tableView
@property (nonatomic , strong)UITableView* simpleLibView; //搭载资料的view

//cell
@property (nonatomic , strong)UILabel* phoneLabel;
@property (nonatomic , strong)UILabel* ageLabel;
@property (nonatomic , strong)UILabel* sexLabel;
/**tagsCell*/
@property (nonatomic , strong)FLAddTagsTableViewCell* addTagsCell;
//for  test

@property (nonatomic , strong)UILabel* testLabelPhone;
@property (nonatomic , strong)UILabel* testLabelBirthday;
@property (nonatomic , strong)UILabel* testLabelSex;
@property (nonatomic , strong)UILabel* testLabelDiscription;
@property (nonatomic , strong)UILabel* testLabelAdress;
@property (nonatomic , strong)UILabel* testLabelIndustry;
/**商家修改联系人*/
@property (nonatomic , strong)UILabel* testLabelContectName;
@property (nonatomic , strong)NSDictionary* userInfoDic; // 缓存中用户的个人信息

@property (nonatomic , strong)NSString* imagesFilePath; //头像路径

@property (nonatomic , strong)UIImage* selfPhoto;
@property (nonatomic , strong)NSArray* tagsArray;   //标签集合
/**tags的高度改变cell高度*/
@property (nonatomic , assign)CGFloat tagsCellHeight;
@property (nonatomic , assign) BOOL isUnderNetWork;
@property (nonatomic , assign) BOOL isMySelfLogIn; //是不是以前的用户登录

/**行业的字典*/
@property (nonatomic , strong)NSDictionary* flIndustryDic;
/**生日选择器*/
@property (strong, nonatomic) KTSelectDatePicker *selectPick;

/**popView*/
@property (nonatomic, strong) FLPopBaseView* popView;

/**商家的模型*/
@property (nonatomic , strong)FLBusAccountInfoModel* busAccountModel;
/**处理标签的mutagblear*/
@property (nonatomic , strong) NSMutableArray* flTagsMuArrNew;
/**行业模型数组*/
@property (nonatomic , strong) NSArray* flBusIndustryModelArr;
@end

static CGFloat kImageOriginHight;
@implementation FLMyPersonalDateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] setValue:@"40" forKey:FL_TAGS_HEIGHT_KEY];
    });
    kImageOriginHight = FLUISCREENBOUNDS.height * 0.33;
    [self seeUserInfo];
    //     self.clearsSelectionOnViewWillAppear = NO;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setUpMySettingsBtn]; //设置按钮
    [self setUpMyHeaderView];  //头部视图
    //    [self initTagView];//
    self.tableView.showsVerticalScrollIndicator = NO;
    
    NSString* myCell = @"mySettingsCell";
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.tableView dequeueReusableCellWithIdentifier:myCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"FLDiscribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLDiscribeTableViewCell"];
    [self.tableView registerClass:[FLAddTagsTableViewCell class] forCellReuseIdentifier:@"FLAddTagsTableViewCell"];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.tagsCellHeight = 120;
    //    [self.navigationController.navigationController ];
    self.flTagsMuArrNew = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLShowAddtagPopViewInMine) name:@"FLShowAddtagPopViewInMine" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = FLFLIsPersonalAccountType? @"个人信息" : @"商家信息";
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;//去掉滚动视图自适应
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_reset];
    UIColor* color = [UIColor whiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString* documentDirectory = [paths objectAtIndex:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    //商家账号，取出值
    //    if (!FLFLIsPersonalAccountType) {
    [self pickBusInfoFromData];
    //    }
    
    //    [self reloadMyNewSettings];
    [self.changeAccountBtn setTitle:[NSString stringWithFormat:@"%@",FLFLIsPersonalAccountType?@"我的商家号":@"我的账号"] forState:UIControlStateNormal];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //     [self changeTagsHeight];
    //    [self.tableView reloadData];
    
}



#pragma mark ---------Actions
- (void)GoToPersonalSettings
{
    if (![XJFinalTool xj_is_phoneNumberBlind]) {
        [self xj_alertNumberBind];
        return;
    }
    self.isUnderNetWork = [FLTool isNetworkEnabled];
    if (!_isUnderNetWork) {
        MBProgressHUD *HUD = [FLTool createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_hud_error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"网络连接不正常"];
        [HUD hide:YES afterDelay:1];//$$$$
    }
    else{
        UIActionSheet* actionSheet  = [[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"从相册选取", nil];
        [actionSheet showInView:self.view];
        NSLog(@"设置界面");
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentDirectory = [paths objectAtIndex:0];
        NSString* imagesFilePath = [documentDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
        NSLog(@"alalalallalalall= === = == ==%@",imagesFilePath);
        //    UIImage* selfPhoto = [UIImage imageWithContentsOfFile:imagesFilePath];
        //    [self.portraitBtn setBackgroundImage:selfPhoto forState:UIControlStateNormal];
        
    }
}

- (void)addTargetBtn{
    
    self.isUnderNetWork = [FLTool isNetworkEnabled];
    if (_isUnderNetWork) {
        //改变view的高度
        //        UIWindow* window = [UIWindow alloc]
        FL_Log(@"加一个sds ，再加一个");
        //    FLDetialViewController = nil;
        FLDetialViewController *detailViewController = [[FLDetialViewController alloc] initWithNibName:@"FLDetialViewController" bundle:nil];
        detailViewController.delegate = self;
        [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomTop];
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

- (void)cancelButtonClicked:(FLDetialViewController *)aSecondDetailViewController
{
    
    [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
    
}

- (void)changeMyAccount
{
    FL_Log(@"??????????? mode=%@",_userInfoModel);
    if (!_userInfoModel.flloginNumber) {
        FLBlindWithThirdTableViewController* addPhoneVC = [[FLBlindWithThirdTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:addPhoneVC animated:YES];
        
    } else {
        if (FLFLIsPersonalAccountType)
        {
            FLAboutBusAccountViewController* aboutVC = [[FLAboutBusAccountViewController alloc] init];
            aboutVC.flPhone = self.userInfoModel.flloginNumber;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        else
        {
            FLChangeMyAccountTableViewController* changeVC = [[FLChangeMyAccountTableViewController alloc] init];
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }
}

- (void)GoToMySettings
{
    FLMySettingsTableViewController* settingsVC = [[FLMySettingsTableViewController alloc]init];
    settingsVC.flUserInfoModel = self.userInfoModel;
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)changeMynickname
{
    FL_Log(@"this is a enter to change name");
    FLFLXJIsChangeNickNameType = 1;  //全局属性变量，修改昵称
    if (!FLFLIsPersonalAccountType) {
        [[FLAppDelegate share] showHUDWithTitile:@"商家修改昵称请到PC端进行操作" view:self.navigationController.view delay:1 offsetY:0];
        return;
    }
    _popView = [[FLPopBaseView alloc] initWithTitle:FLFLXJIsChangeNickNameType ? @"请填写您的昵称,最长不超过六个字":@"请填写新的联系人,最长不超过四个字"
                                           delegate:self
                                  andCancleBtnTitle:@"取消"
                                  andEnsureBtnTitle:@"确定"
                                    textFieldLength:FLFLXJIsChangeNickNameType ? 6:4 lengthType:FLLengthTypeLength
                                        originalStr:self.userInfoModel.flnickName ? self.userInfoModel.flnickName:@""];
    _popViewTag = 62;
    _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_popView];
    
}
#pragma mark 修改联系人&商家接口
- (void)sendNameToService:(NSString*)msg {
    if (FLFLIsPersonalAccountType)
    {
        NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"nickname\":\"%@\",\"userId\":\"%@\"}",XJ_USER_SESSION,msg,XJ_USERID_WITHTYPE];;
        NSLog(@"parmdic= %@",parmDic);
        NSDictionary* parm = @{@"peruser":parmDic};
        [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"send my name success data = %@",data);
        } failure:^(NSError *error) {
            FL_Log(@"send my name error = %@, == %@",error.description,error.debugDescription);
        }];
    }
    else
    {
        //商家修改昵称
        if (FLFLXJIsChangeNickNameType)
        {
            NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"shortName\":\"%@\",\"userId\":\"%@\"}",FLFLBusSesssionID,msg,FLFLXJBusinessUserID];
            NSDictionary* parm = @{@"compuser":parmDic};
            NSLog(@"parmdicbus= %@",parmDic);
            [FLNetTool updateCompInfoWithParm:parm success:^(NSDictionary *data) {
                FL_Log(@"send my name success data bus nick  = %@",[data objectForKey:@"info"]);
            } failure:^(NSError *error) {
                FL_Log(@"send my name error = %@ = %@",error.description,error.debugDescription);
            }];
        }
        else
        {
            //商家修改联系人
            NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"legalPerson\":\"%@\",\"userId\":\"%@\"}",FLFLBusSesssionID,msg,FLFLXJBusinessUserID];
            NSDictionary* parm = @{@"compuser":parmDic};
            NSLog(@"parmdicbus= %@",parmDic);
            [FLNetTool updateCompInfoWithParm:parm success:^(NSDictionary *data) {
                NSLog(@"send my name success data bus name = %@",[data objectForKey:@"info"]);
                if ([[data objectForKey:@"info"] isEqualToString:@"success"]) {
                    
                }
            } failure:^(NSError *error) {
                NSLog(@"send my name error = %@ = %@",error.description,error.debugDescription);
            }];
        }
        
    }
    
    
}
#pragma mark 改改改改改改改改改改改改
- (void)getMaxCellHeight
{
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return FLFLIsPersonalAccountType?3:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (FLFLIsPersonalAccountType ){
        if (section == 0) {
            return 1;
        }else if (section == 1)
        {
            return 4;
        }else if (section == 2)
        {
            return 1;
        }
    }else
    {
        if (section == 0) {
            return 4;
        }else if(section == 1)
        {
            return 1;
        }
    }
    //    if (section == 0)
    //    {
    //        return FLFLIsPersonalAccountType?1:3;
    //    }
    //    if (section == 1)
    //    {
    //        return FLFLIsPersonalAccountType?3:1;
    //    }
    //    if (section == 2)
    //    {
    //        return FLFLIsPersonalAccountType?1:0;
    //    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
    cell.textLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
    NSInteger section = indexPath.section;
    if (FLFLIsPersonalAccountType)
    {
        if (section == 0)
        {
            self.addTagsCell = [tableView dequeueReusableCellWithIdentifier:@"FLAddTagsTableViewCell" forIndexPath:indexPath];
            self.addTagsCell.selectionStyle = UITableViewCellSelectionStyleNone; //选中状态,为没有状态
            self.addTagsCell.vvvc = self;
            self.addTagsCell.fltagsArrMu = self.flTagsMuArrNew;
            //            self.addTagsCell.useriN = self.userInfoModel;
            //            self.addTagsCell.fltagsArrMu = self.userInfoModel.fltagsArray.mutableCopy;
            self.addTagsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.addTagsCell;
            
        }
        else if (section == 1)
        {
            
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"手机号";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (!self.testLabelPhone.text)
                {
                    cell.detailTextLabel.text =  self.userInfoModel.flloginNumber;
                }
                else
                {
                    cell.detailTextLabel.text  = self.testLabelPhone.text;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.text =  @"生日" ;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (!self.testLabelBirthday) {
                    if ([self.userInfoModel.flbirthday isEqual:[NSNull null]]) {
                        cell.detailTextLabel.text = @"" ;
                    }else{
                        cell.detailTextLabel.text =  self.userInfoModel.flbirthday ;
                    }
                }
                else
                {
                    cell.detailTextLabel.text =  self.testLabelBirthday.text ;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else if(indexPath.row == 2)
            {
                if (!self.testLabelSex) {
                    cell.detailTextLabel.text =  self.userInfoModel.flsex  ;
                }
                else
                {
                    cell.detailTextLabel.text =   self.testLabelSex.text ;
                }
                cell.textLabel.text =  @"性别" ;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if (indexPath.row == 3)
            {
                cell.textLabel.text = @"地址";
                if (!self.testLabelAdress) {
                    cell.detailTextLabel.text = self.userInfoModel.fladdress;
                }
                else
                {
                    cell.detailTextLabel.text = self.testLabelAdress.text;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return  cell;
            }
            
        }
        else if (section == 2)
        {
            self.testLabelDiscription .font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
            cell.textLabel.text = @"签名";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (!self.testLabelDiscription)
            {
                cell.detailTextLabel.text =   self.userInfoModel.fldescription;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                cell.detailTextLabel.text =   self.testLabelDiscription.text;
                
                return cell;
            }
        }
    }
    else
    {
        
        if (section == 0)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text =  @"企业邮箱";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (!self.testLabelPhone.text)
                {
                    cell.detailTextLabel.text =  self.busAccountModel.busEmail;
                }
                else
                {
                    cell.detailTextLabel.text  = self.testLabelPhone.text;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.text =  @"联系人";
                //                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (!self.testLabelContectName) {
                    cell.detailTextLabel.text =  self.busAccountModel.buscreator;
                }
                else
                {
                    cell.detailTextLabel.text =  self.testLabelContectName.text;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else if (indexPath.row == 2)
            {
                cell.detailTextLabel.text =  self.busAccountModel.busphoneNumber;
                cell.textLabel.text =  @"联系电话";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if (indexPath.row == 3)
            {
                cell.textLabel.text = @"行业";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (!self.testLabelIndustry) {
                    cell.detailTextLabel.text = self.busAccountModel.busIndustry;
                }
                else
                {
                    cell.detailTextLabel.text = self.testLabelIndustry.text;
                }
                //TODO
            }
        }
        else if (section == 1)
        {
            
            self.testLabelDiscription .font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
            cell.textLabel.text = @"签名";
            if (!self.testLabelDiscription) {
                cell.detailTextLabel.text =   self.busAccountModel.busSimpleIntroduce ? self.busAccountModel.busSimpleIntroduce :@"";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else {
                cell.detailTextLabel.text =   self.testLabelDiscription.text ? self.testLabelDiscription.text :@"";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tagList:(JFTagListView *)taglist heightForView:(float)listHeight {
    FLFLXJUserTagHFloatValue =listHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.tableView reloadData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        //        JFTagListView    *tagList = [[JFTagListView alloc]initWithFrame:self.view.frame];
        //        tagList.tagStateType = XjTagStateTypeOnlyShow;
        //        tagList.delegate = self;
        //        if (self.flTagsMuArrNew.count !=0) {
        //             [tagList reloadData:self.flTagsMuArrNew];
        //
        //        }
        //
        //        NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
        //        self.tagsCellHeight = [[userdefaults objectForKey:FL_TAGS_HEIGHT_KEY]floatValue];
        //        FL_Log(@"hhhhhhhhhhhhhh=%f =====%f",self.tagsCellHeight ,  self.addTagsCell.tagList.xjTagViewH);
        //        if (FLFLIsPersonalAccountType) {
        //            if (FLFLXJUserTagHFloatValue  != 0) {
        //                FL_Log(@"-=-=-=-=-=-=ww=-=-%f", FLFLXJUserTagHFloatValueIsAddOne ? FLFLXJUserTagHFloatValue +  80 :FLFLXJUserTagHFloatValue + 40);
        //                return FLFLXJUserTagHFloatValueIsAddOne ? FLFLXJUserTagHFloatValue +  60 :FLFLXJUserTagHFloatValue + 40;
        //            } else {
        //                FL_Log(@"-=-=-=-=-=-=ss=-=-%f", self.tagsCellHeight + 40);
        //                return  self.tagsCellHeight + 80;
        //            }
        //        }
        //        CGFloat jj = FLUISCREENBOUNDS.width;
        
        if (FLFLIsPersonalAccountType) {
            if (FLUISCREENBOUNDS.width <=320) {
                return 100;
            } else {
                return 80;
            }
        }
    }
    else if (indexPath.section == 2) {
        return FLFLIsPersonalAccountType?44:0;
    } else if (indexPath.section ==1) {
        return FLFLIsPersonalAccountType?44:44;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 && FLFLIsPersonalAccountType) {
        return 30;
    } else if (section == 1 && !FLFLIsPersonalAccountType) {
        return 5;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

/**
 *为cell添加约束
 */
- (UILabel*) makeContainatslabel:(UILabel*)label ByUIView:(UIView*)cell {
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell).with.offset(0);
        make.centerX.equalTo(cell).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(160, 44));
    }];
    return label;
}


#pragma mark - Table view delegate ---------------------------

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _isUnderNetWork = [FLTool isNetworkEnabled];
    if (FLFLIsPersonalAccountType) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                if (!_userInfoModel.flloginNumber) {
                    FLBlindWithThirdTableViewController* addPhoneNumber = [[FLBlindWithThirdTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    addPhoneNumber.delegate = self;
                    [self.navigationController pushViewController:addPhoneNumber animated:YES];
                } else {
                    FLChangePhoneNumberTableViewController *detailViewController = [[FLChangePhoneNumberTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    detailViewController.delegate = self;
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }
            } else if (indexPath.row == 1) {
                if (![XJFinalTool xj_is_phoneNumberBlind]) {
                    [self xj_alertNumberBind];
                    return;
                }
                if (_isUnderNetWork) {
                    self.testLabelBirthday = [[UILabel alloc]init];
                    _selectPick = [[KTSelectDatePicker alloc] init];
                    _selectPick.isBeforeTime = YES;
                    _selectPick.datePickerMode = UIDatePickerModeDate;
                    _selectPick.xjCanLaterTime = NO;
                    __weak typeof(self) weakSelf = self;
                    [_selectPick didFinishSelectedDate:^(NSDate *selectedDate) {
                        FL_Log(@"selectedate time =%@",selectedDate);
                        NSString* dateStr = [FLTool returnStrWithNSDate: selectedDate AndDateFormat:@"yyyy-MM-dd"];
                        //                       NSInteger birthday= [FLTool returnNumberWithBirthdayTime:dateStr];
                        //                        if (birthday > 0) {
                        weakSelf.testLabelBirthday.text = dateStr;
                        [weakSelf sendBirthdayToServiceAndUserdefaultsWithbirthday:dateStr];
                        [weakSelf.tableView reloadData];
                        //                        } else {
                        //                            [[FLAppDelegate share] showHUDWithTitile:@"需小于当前时间" view:self.view delay:1 offsetY:0];
                        //                        }
                    }];
                }
                else{
                    [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:0];
                }
            }   else if (indexPath.row == 2)  {
                if (![XJFinalTool xj_is_phoneNumberBlind]) {
                    [self xj_alertNumberBind];
                    return;
                }
                if (_isUnderNetWork) {
                    FLSexChoiceTableViewController* sexChoiceVC = [[FLSexChoiceTableViewController alloc]init];
                    sexChoiceVC.delegate = self;
                    [self.navigationController pushViewController:sexChoiceVC animated:YES];
                } else  {
                    [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:0];
                }
            }   else if (indexPath.row == 3)  {
                FL_Log(@"点了地址");
                if (![XJFinalTool xj_is_phoneNumberBlind]) {
                    [self xj_alertNumberBind];
                    return;
                }
                FLChangeAddressViewController* adressVC = [[FLChangeAddressViewController alloc] initWithNibName:@"FLChangeAddressViewController" bundle:nil];
                adressVC.delegate =self;
                adressVC.flStr = self.userInfoModel.fladdress ? self.userInfoModel.fladdress : @"";
                [self.navigationController pushViewController:adressVC animated:YES];
            }
        }  if (indexPath.section == 2) {
            if (![XJFinalTool xj_is_phoneNumberBlind]) {
                [self xj_alertNumberBind];
                return;
            }
            if (_isUnderNetWork) {
                FLDiscribeMyselfViewController * discribeMyselfVC = [[FLDiscribeMyselfViewController alloc]init];
                discribeMyselfVC.delegate = self;
                discribeMyselfVC.flStr=self.userInfoModel.fldescription;
                [self.navigationController pushViewController:discribeMyselfVC animated:YES];
            }  else  {
                [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:0];
            }
        }
        
    } else {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                //TODO
                if (_isUnderNetWork)
                {
                    FLChangePhoneNumberTableViewController *detailViewController = [[FLChangePhoneNumberTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    detailViewController.delegate = self;
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }
                else
                {
                    [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:0];
                }
                
            }
            else if (indexPath.row == 1)
            {
                //                //修改联系人
                //                if (_isUnderNetWork)
                //                {
                //                    //切换全局属性为修改联系人
                //                    FLFLXJIsChangeNickNameType = 0;
                //                    FLChangeNameViewController* changeNameVC = [[FLChangeNameViewController alloc] init];
                //                    changeNameVC.delegate = self;
                //                    [self presentPopupViewController:changeNameVC animationType:MJPopupViewAnimationSlideBottomTop];
                //                }
                //                else
                //                {
                //                    [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:0];
                //                }
            }
            else if (indexPath.row == 3)
            {
                //请求接口得到数组
                [self changeIndustryInMineWithData:self.flIndustryDic];
            }
        }
        else if (indexPath.section == 1)
        {
            FLDiscribeMyselfViewController* disVC = [[FLDiscribeMyselfViewController alloc ]init];
            disVC.delegate = self ;
            disVC.flStr =  self.busAccountModel.busSimpleIntroduce;
            [self.navigationController pushViewController:disVC animated:YES];
            
        }
    }
    
}




#pragma mark-------initView
-(void)setUpMyHeaderView
{
    self.myHeaderView = [[UIView alloc]init];
    CGRect frame = self.myHeaderView.frame;
    //    [self.view addSubview:self.myHeaderView];
    [self.myHeaderView setFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, kImageOriginHight)];
    self.backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_back"]];
    self.backgroundImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.backgroundImageView.frame = frame;
    [self.myHeaderView addSubview:self.backgroundImageView];
    self.tableView.tableHeaderView = self.myHeaderView;
    
    //头像按钮，点击进入设置
    self.portraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.portraitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.portraitBtn.layer.cornerRadius = 70 * FL_SCREEN_PROPORTION_width;
    self.portraitBtn.backgroundColor = [UIColor whiteColor];
    [self.portraitBtn addTarget:self action:@selector(GoToPersonalSettings) forControlEvents:UIControlEventTouchUpInside];
    self.portraitBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.portraitBtn];
    //头像的约束
    [self.portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView).with.offset(0);
        make.centerY.equalTo(self.backgroundImageView).with.offset(40* FL_SCREEN_PROPORTION_height);
        make.size.mas_equalTo(CGSizeMake(140 * FL_SCREEN_PROPORTION_width, 140 * FL_SCREEN_PROPORTION_width));
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.myHeaderView).with.offset(0);
        make.size.equalTo(self.myHeaderView).with.offset(0);
    }];
    
    //头像下方名字btn
    self.myNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.myNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.myNameButton.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    [self.myNameButton addTarget:self action:@selector(changeMynickname) forControlEvents:UIControlEventTouchUpInside];
    [self.myHeaderView addSubview:self.myNameButton];
    [self.myNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitBtn.mas_bottom).with.offset(-5 * FL_SCREEN_PROPORTION_height);
        make.centerX.equalTo(self.myHeaderView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width / 2, 40));
    }];
    
    
    
    
    self.changeAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.changeAccountBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    [self.changeAccountBtn setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    self.changeAccountBtn.layer.cornerRadius = 10;
    [self.changeAccountBtn addTarget:self action:@selector(changeMyAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.myHeaderView addSubview:self.changeAccountBtn];
    //搭载btn 的view是footerview
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0,FLUISCREENBOUNDS.width,44)];
    //    self.changeAccountBtn.frame = view.frame;
    [view addSubview:self.changeAccountBtn];
    self.tableView.tableFooterView=view;
    
    [self.changeAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.myHeaderView.mas_bottom).with.offset(-10);
        make.center.equalTo(view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width - 60, 40));
    }];
    //设置头像
    
    NSLog(@"没有本地缓存的头像selfphotto = %@,str = %@",self.selfPhoto,self.portraitImageUrlWithOutTapStr);
    
    
    //背景色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
}

- (void)setUpMySettingsBtn {
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barbtn_settings"] style:UIBarButtonItemStylePlain target:self action:@selector(GoToMySettings)];
    self.navigationItem.rightBarButtonItem = item;
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_icon_goback_white"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = item2;

}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goBackToMenu {
    
}

- (void)sendTagToService
{
    NSMutableArray* muarr = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.tagsArray.count; i ++) {
        if (![self.tagsArray[i] isEqualToString:@""] && ![self.tagsArray[i] isEqualToString:@"(null)"]) {
            [muarr addObject:self.tagsArray[i]];
        }
    }
    FL_Log(@"parmdic= this is my test tags arr= %@",muarr);
    for (NSInteger i = 0; i < muarr.count; i++) {
        if ([muarr[i] isEqualToString:@""]) {
            [muarr removeObject:@""];
        }
    }
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"tags\":\"%@\",\"userId\":\"%@\"}",FL_ALL_SESSIONID,[muarr.mutableCopy componentsJoinedByString:@","],FL_USERDEFAULTS_USERID_NEW];
    FL_Log(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"send my tags success data1 1 = %@",data);
        //        [self.tableView reloadData];
    } failure:^(NSError *error) {
        FL_Log(@"send my tags error = %@, == %@",error.description,error.debugDescription);
    }];
}

#pragma mark ----------delegate
//date picker delegate
- (void)FLChangeAddressViewController:(FLChangeAddressViewController *)address myAddress:(NSString *)adress
{
    FL_Log(@"此处为代理方法，具体提交数据已经在自控制器中实现");
    self.testLabelAdress = [[UILabel alloc ]init];
    self.testLabelAdress.text = adress;
    //        [self sendAddressToServiceWithAddress:adress];
    [self.tableView reloadData];
}
//date picker delegate
- (void)FLDateAndTimePickerViewController:(FLDateAndTimePickerViewController *)myPersonalvc didInputReturnMessage:(NSString *)msg
{
    self.testLabelBirthday = [[UILabel alloc]init];
    NSArray* array = [msg componentsSeparatedByString:@"--"];
    self.testLabelBirthday.text = array[0];
    [self.tableView reloadData];
}
//change phone number delegate
- (void)FLChangePhoneNumberTableViewController:(FLChangePhoneNumberTableViewController *)changePhone passValue:(NSString *)msg
{
    self.testLabelPhone = [[UILabel alloc]init];
    self.testLabelPhone.text = msg;
    [self.tableView reloadData];
}
//choice sex delegate
- (void)FLSexChoiceTableViewController:(FLSexChoiceTableViewController *)sexChoice myChoice:(NSString *)msg
{
    self.testLabelSex = [[UILabel alloc]init];
    self.testLabelSex.text = msg;
    [self.tableView reloadData];
}
//change name delegate  ----- changeNickname ------ changeContanctPerson
- (void)FLChangeNameViewController:(FLChangeNameViewController *)myPersonalvc didInputReturnMessage:(NSString *)msg
{
    [self.myNameButton setTitle:msg forState:UIControlStateNormal];
    //发送给服务器
    [self sendNameToService:msg];
}
//------ changeContanctPerson
- (void)FLChangeContectNameViewController:(FLChangeNameViewController *)myPersonalvc didInputReturnMessage:(NSString *)msg
{
    self.testLabelContectName = [[UILabel alloc] init];
    self.testLabelContectName.text = msg;
    //发送给服务器
    [self sendNameToService:msg];
    [self.tableView reloadData];
}

// my discription
- (void)FLDiscribeMyselfViewController:(FLDiscribeMyselfViewController *)discribe myDiscription:(NSString *)msg
{
    self.testLabelDiscription= [[UILabel alloc]init];
    self.testLabelDiscription.text = msg;
    [self.tableView reloadData];
}
#pragma mark POPViewDelegate ------------------------
- (void)entrueBtnClickWithStr:(NSString *)result
{
    switch (_popViewTag) {
        case 62: //姓名
        {
            [self.myNameButton setTitle:result forState:UIControlStateNormal];
            //发送给服务器
            [self sendNameToService:result];
        }
            break;
        case 63: //添加tag
        {
            BOOL _canAdd = NO;
            for (NSString* str in self.flTagsMuArrNew) {
                if ([str isEqualToString:result]) {
                    [[FLAppDelegate share] showHUDWithTitile:@"标签重复啦亲" delay:1 offsetY:0];
                    _canAdd = NO;
                    return;
                } else if ([result isEqualToString:@""]) {
                    [[FLAppDelegate share] showHUDWithTitile:@"标签不能为空" delay:1 offsetY:0];
                    _canAdd = NO;
                    return;
                } else {
                    _canAdd = YES;
                }
            }
            if (self.flTagsMuArrNew.count ==0) {
                _canAdd = YES;
            }
            if (_canAdd) {
                [self.flTagsMuArrNew addObject:result];
                [self.addTagsCell.tagList reloadData:self.flTagsMuArrNew andTime:0 flselectedArr:nil];
                self.tagsArray = self.flTagsMuArrNew.mutableCopy;
                [self changeTagsHeight];
            }
            //传参给服务器
            [self sendTagToService];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 传参(更改个人信息)
- (void)sendAddressToServiceWithAddress:(NSString*)myAddress
{
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"address\":\"%@\",\"userId\":\"%@\"}",FL_ALL_SESSIONID,myAddress,FL_USERDEFAULTS_USERID_NEW];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"上传成功dizhidata = %@",data);
    } failure:^(NSError *error) {
        FL_Log(@"上传失败error = %@, == %@",error.description,error.debugDescription);
    }];
}

#pragma mark --- action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //       拍照
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        picker.delegate   = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        //        相册
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        //设置图片源(相册)
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate   = self;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        //设置可以编辑
        picker.allowsEditing = YES;
        picker.view.backgroundColor = [UIColor whiteColor];
        //打开拾取界面
        [self presentViewController:picker animated:YES completion:nil];
    }
    //    else if(buttonIndex == 2)
    //    {
    //        NSLog(@"取消");
    //    }
}
//imagePicker did delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *editedImage, *orginalIma,*imageToUse;
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        editedImage = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        orginalIma =  (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = orginalIma;
        }
        
        //将该图像保存到媒体库中
        //        UIImageWriteToSavedPhotosAlbum(imageToUse, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        [self performSelector:@selector(saveImage:) withObject:imageToUse afterDelay:0.5];
        
    }
    FL_Log(@"消失之前");
    [picker dismissViewControllerAnimated:YES completion:nil];
    FL_Log(@"消失之后");
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* imagesFilePath = [documentDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    self.selfPhoto = [UIImage imageWithContentsOfFile:imagesFilePath];
    //    [self.portraitBtn setBackgroundImage:self.selfPhoto forState:UIControlStateNormal];
    //    [[picker parentViewController]dismissViewControllerAnimated:YES completion:nil];
    
}
//保存到本地的回调方法
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.in first");
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

- (void)saveImage:(UIImage*)image
{
#warning 上传图片到服务器
    //使用GCD串行队列来解决 写入文件缓慢导致网络请求没有路径的问题
    dispatch_queue_t write =dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(write, ^{
        //    //保存到本地
        NSLog(@"save the portrait");
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory =[paths objectAtIndex:0];
        self.imagesFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
        NSLog(@"imageFilePaht =  %@",self.imagesFilePath);
        UIImage* smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(380.0f, 380.0f)];
        [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:self.imagesFilePath atomically:YES];//写入文件
        UIImage* selfPhoto = [UIImage imageWithContentsOfFile:self.imagesFilePath];//读取图片文件
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.portraitBtn setBackgroundImage:selfPhoto forState:UIControlStateNormal];
        });
        //    //上传到服务器
        [self upLoadHeadImage];
    });
    
}
//改变图片尺寸，方便服务器上传
#warning 在哪儿还能遇到改变图片尺寸
//1.
-(UIImage* )scaleFromImage:(UIImage*)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#warning  回头一定要搞明白这个算法
//2.保存图片尺寸长款比，生成需要尺寸的图片
- (UIImage*)thumbnailWithImageWithoutScale:(UIImage*)image size:(CGSize)asize
{
    UIImage* newImage;
    if (nil == image)
    {
        image = nil;
    }
    else
    {
        CGSize oldSize = image.size;
        CGRect rect;
        if (asize.width / asize.height > oldSize.width / oldSize.height)
        {
            rect.size.width = asize.height * oldSize.width  / oldSize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }
        else
        {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldSize.height / oldSize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor]CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

#pragma mark ------net
- (void)seeUserInfo
{
    [self.flTagsMuArrNew removeAllObjects]; //赋值前先清空
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
        NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                               @"accountType":@"per",};
        
        [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@" see info is success in mine in mine: %@",data);
            self.userInfoModel = [FLMineTools returnUserInfoModelWithModel:data];
            self.flTagsMuArrNew = self.userInfoModel.fltagsArray.mutableCopy;
            
            if (self.userInfoModel.flnickName) {
                [self.myNameButton setTitle:self.userInfoModel.flnickName forState:UIControlStateNormal];
            }
            FL_Log(@"error=this is my test btn for ensure my lcick=%@",self.userInfoModel.flnickName);
            
            //            self.addTagsCell.fltagsArrMu = self.flTagsMuArrNew;
            //userInfo
            [[NSUserDefaults standardUserDefaults] setObject:self.userInfoModel.fluserId forKey:FL_USERDEFAULTS_USERID_KEY];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(NSError *error) {
            FL_Log(@"error= %@, %@",error.description,error.debugDescription);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        }];
    });
}
#pragma mark ------关于上传图片到服务器
- (void)upLoadHeadImage
{
    //     NSLog(@"图没有我就发%@",self.selfPhoto);
    //    if (self.selfPhoto) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"图片有了我才发%@",self.selfPhoto);
        NSString* path = NSHomeDirectory();
        NSLog(@"此APP的 根目录为------- %@",path);
        NSString *docPath = [path stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"selfPhoto.jpg"];
        UIImage* myGodImage = [UIImage imageWithContentsOfFile:filePath];
#warning TODO
        [FLNetTool uploadHeadImage:myGodImage parm:nil success:^(NSDictionary *data) {
            NSLog(@"成444444功 = %@",data);
            if ([[data objectForKey:@"message"] isEqualToString:@"OK"]) {
                //成功，拼接图片url地址
                
                NSString* imageUrlStr =  [data objectForKey:@"result"];
                NSLog(@"my image url is :%@",imageUrlStr);
                //将同样地址赋值给商家账户头像
                FLFLXJBusinessUserHeaderImageURLStr  = [NSString stringWithFormat:@"%@",imageUrlStr] ;
                //将url传给服务器
                //个人
                if (FLFLIsPersonalAccountType) {
                    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
                    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"avatar\":\"%@\",\"userId\":\"%@\"}",XJ_USER_SESSION,imageUrlStr,XJ_USERID_WITHTYPE];
                    NSLog(@"parmdic= %@",parmDic);
                    NSDictionary* parm = @{@"peruser":parmDic};
                    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
                        FL_Log(@"上传成功data111 = %@",data);
                        if ([[data objectForKey:FL_NET_KEY] boolValue]) {
                            [[FLAppDelegate share] showHUDWithTitile:@"上传头像成功" view:self.view delay:1 offsetY:0];
                            [self.portraitBtn setBackgroundImage:self.selfPhoto forState:UIControlStateNormal];
                            UIImage* imageTuUse = [self.selfPhoto imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
                            self.backgroundImageView.image = imageTuUse;
                            
                        }else
                        {
                            [[FLAppDelegate share] showHUDWithTitile:@"上传头像失败，请检查网络设置" view:self.view delay:1 offsetY:0];
                        }
                    } failure:^(NSError *error) {
                        NSLog(@"上传失败URLerror = %@, == %@",error.description,error.debugDescription);
                        MBProgressHUD *HUD = [FLTool createHUD];
                        HUD.mode = MBProgressHUDModeCustomView;
                        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_hud_error"]];
                        HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
                        [HUD hide:YES afterDelay:1];
                    }];
                }
                //商家
                else
                {
                    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"avatar\":\"%@\",\"userId\":\"%@\"}",FLFLBusSesssionID,imageUrlStr,FLFLXJBusinessUserID];
                    NSLog(@"parmdic bus = %@",parmDic);
                    NSDictionary* parm = @{@"compuser":parmDic};
                    [FLNetTool updateCompInfoWithParm:parm success:^(NSDictionary *data) {
                        NSLog(@"update my bus head image success = %@",data);
                        FLFLXJBusinessUserHeaderImageURLStr = imageUrlStr;
                        [[FLAppDelegate share] showHUDWithTitile:@"上传头像成功" view:self.view delay:1 offsetY:0];
                        [self.portraitBtn setBackgroundImage:self.selfPhoto forState:UIControlStateNormal];
                        UIImage* imageTuUse = [self.selfPhoto imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
                        self.backgroundImageView.image = imageTuUse;
                    } failure:^(NSError *error) {
                        NSLog(@"update my bus head image error = %@ , = %@",error.description,[FLTool returnStrWithErrorCode:error]);
                    }];
                }
            }
            
        } failure:^(NSError *error) {
            NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
            MBProgressHUD *HUD = [FLTool createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_hud_error"]];
            HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
            NSLog(@"hud detail = %@",error.userInfo[NSLocalizedDescriptionKey]);
            [HUD hide:YES afterDelay:1];
        }];
    });
}
//}

#pragma mark-----creatDIYNavi
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    UIColor* color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    } else {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
    }
    
    
    /**
     *  关键处理：通过滚动视图获取到滚动偏移量从而去改变图片的变化
     */
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    //    NSLog(@"yOffset===%f",yOffset);
    //    CGFloat xOffset = (yOffset +kImageOriginHight)/2;
    
    if(yOffset < 0) {
        CGRect f =self.backgroundImageView.frame;
        f.origin.y= yOffset  ;
        f.size.height=  -yOffset + kImageOriginHight;
        f.origin.x= yOffset;
        //int abs(int i); // 处理int类型的取绝对值
        //double fabs(double i); //处理double类型的取绝对值
        //float fabsf(float i); //处理float类型的取绝对值
        f.size.width=FLUISCREENBOUNDS.width + fabs(yOffset)*2;
        
        self.backgroundImageView.frame= f;
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)pickBusInfoFromData
{
    
    NSDictionary* parmBus =@{@"token":FLFLIsPersonalAccountType?FL_ALL_SESSIONID :FLFLBusSesssionID,
                             @"accountType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey};
    FL_Log(@"see info :sesssionId = %@ ",parmBus);
    [FLNetTool seeInfoWithParm:parmBus success:^(NSDictionary *data) {
        FL_Log(@"see info in getusermodel with businfo success=%@, avatar = %@",data,[data objectForKey:@"avatar"]);
        NSString* xjS = [NSString stringWithFormat:@"%@",[data objectForKey:@"state"]];
        [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjS key:XJ_xjBusAccountState];
        if (data)
        {
            self.busAccountModel = [FLTool flNewGetBusAccountInfoModelWithDic:data];
            //                FLFLXJBusinessUserHeaderImageURLStr = self.busAccountModel.busHeaderImageStr;
            FLFLXJBusinessUserHeaderImageURLStr = [NSString stringWithFormat:@"%@",self.busAccountModel.busHeaderImageStr];
            self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
            self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

            [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:self.busAccountModel.busHeaderImageStr isSite:NO]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                UIImage* imageToUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
                //                imageToUse = [self thumbnailWithImageWithoutScale:imageToUse size:CGSizeMake(FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height * 0.3)];
                self.backgroundImageView.image = imageToUse;
                self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
            }];
            
            if (FLFLIsPersonalAccountType) {
                self.userInfoModel = [FLMineTools returnUserInfoModelWithModel:data];
                if(self.userInfoModel) {
                    [self.myNameButton setTitle:[NSString stringWithFormat:@"%@",  self.userInfoModel.flnickName] forState:UIControlStateNormal];
                    
                }
            } else {
                if (data[@"phone"]) {
                    FLFLXJIsHasPhoneBlind = 1;
                } else {
                    FLFLXJIsHasPhoneBlind = 0;
                }
                if (self.busAccountModel) {
                    [self.myNameButton setTitle:[NSString stringWithFormat:@"%@", self.busAccountModel.busSimpleName] forState:UIControlStateNormal];
                } else {
                    [self.myNameButton setTitle:[NSString stringWithFormat:@"%@", FLFLXJBusinessNickNameStr] forState:UIControlStateNormal];
                }
                
                FLBusAccountInfoModel* xjBusAccountInfoModel = [FLBusAccountInfoModel mj_objectWithKeyValues:data];
                [self xjSetBusInfoModelWithModel:xjBusAccountInfoModel];
                [self.tableView reloadData];
            }
            
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"see info in mine failure=%@,%@",error.description,error.debugDescription);
        
    }];
    
    
    //使用SDWebimage来下载头像
    if (FLFLIsPersonalAccountType)
    {
        self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
        self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

        [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:self.portraitImageUrlWithOutTapStr isSite:NO]]forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage* imageTuUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
            self.backgroundImageView.image = imageTuUse;
        }];
        //        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.portraitImageUrlWithOutTapStr]];  //需要设置毛玻璃效果
    } else {
        self.portraitBtn.layer.borderColor=DE_headerBorderColor.CGColor;
        self.portraitBtn.layer.borderWidth=DE_headerBorderWidth;

        [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:FLFLXJBusinessUserHeaderImageURLStr isSite:NO]]forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage* imageTuUse = [image imageByBlurRadius:80 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
            self.backgroundImageView.image = imageTuUse;
        }];
    }
    
    //    FL_Log(@"this is head image =%@",[NSString stringWithFormat:@"%@",FLFLXJBusinessUserHeaderImageURLStr]);
    
    
    //获取行业列表
    NSDictionary* parm = @{@"token":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID]]};
    FL_Log(@"tiken in change industry=%@",parm);
    [FLNetTool chooseIndustryWithParm:parm success:^(NSDictionary *data) {
        //        FL_Log(@"data in industry in mine = %@ ,",data);
        self.flIndustryDic = data;
        self.flBusIndustryModelArr = [FLBusIndustryModel mj_objectArrayWithKeyValuesArray:data];
    } failure:^(NSError *error) {
        FL_Log(@"this is my error =%@",error);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
    }];
    
}

#pragma mark 改改改改改改改改改改改改
- (void)changeTagsHeight
{
    FL_Log(@"this is my tags Array  =,%@" ,self.userInfoModel.fltagsArray);
    //    self.addTagsCell
    [self.addTagsCell.tagList reloadData:self.tagsArray.mutableCopy andTime:0 flselectedArr:nil];
    [self.tableView reloadData];
}

- (void)changeIndustryInMineWithData:(NSDictionary*)data
{
    if (data)
    {
        [_pickview remove];
        //拿到数组
        NSMutableArray* muArray = [[NSMutableArray alloc] init];
        for (NSDictionary* dic in data)
        {
            NSString* str = [dic objectForKey:@"dicValue"];
            [muArray addObject:str];
        }
        FL_Log(@"muarray in mine to change industry =%@",muArray);
        _pickview=[[ZHPickView alloc] initPickviewWithArray:muArray isHaveNavControler:NO];
        _pickview.delegate = self;
        [_pickview show];
    }
    else
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请检查网络" view:self.view delay:1 offsetY:0];
    }
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    cell.detailTextLabel.text=resultString;
    NSString* upDateStr = @"";
    for (NSInteger i = 0; i < [_flBusIndustryModelArr count]; i++) {
        FLBusIndustryModel* model = self.flBusIndustryModelArr[i];
        if ([resultString isEqualToString:model.dicValue]) {
            //            FL_Log(@"model value= %@ ====%@",model.dicValue , model.dicName);
            upDateStr = [NSString stringWithFormat:@"%@",model.dicName];
        }
    }
    FL_Log(@"dasagasaf=%@",upDateStr);
    
    NSDictionary* parmDic = @{@"industry":upDateStr,
                              @"userId":FLFLXJBusinessUserID,
                              @"token":FLFLBusSesssionID};
    NSDictionary* parmUpdate = @{@"compuser":[FLTool returnDictionaryToJson:parmDic]};
    
    [FLNetTool updateCompInfoWithParm:parmUpdate success:^(NSDictionary *data) {
        FL_Log(@"update bus success with industry= %@ ,",data );
        if ([[data objectForKey:@"info"]isEqualToString:@"success"]) {
            [[FLAppDelegate share] showHUDWithTitile:@"更新成功" view:self.view delay:1 offsetY:0];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"update bus error = %@ , %@",error.description , error.debugDescription);
        [[FLAppDelegate share] showHUDWithTitile:[FLTool returnStrWithErrorCode:error] view:self.view delay:1 offsetY:0];
    }];
    
}
#pragma mark ----birthday
- (void)sendBirthdayToServiceAndUserdefaultsWithbirthday:(NSString*)birthday
{
    //service
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [userdefaults objectForKey:FL_USERDEFAULTS_USERID_KEY];
    NSString* sessionId = [userdefaults objectForKey:FL_NET_SESSIONID];
    NSString* parmStr = [NSString stringWithFormat:@"{\"userId\":\"%@\",\"birthday\":\"%@\",\"token\":\"%@\"}",userId,birthday,sessionId];
    NSDictionary* parm = @{@"peruser":parmStr};
    NSLog(@"parm%@",parm);
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        NSLog(@"上传成功data 8= %@",data);
        if ([data[@"isSuccess"] boolValue]) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"上传失败error = %@, == %@",error.description,error.debugDescription);
    }];
}





#pragma mark 添加标签
- (void)FLShowAddtagPopViewInMine
{
    [_popView removeFromSuperview];
    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写标签(4字内)"
                                           delegate:self
                                  andCancleBtnTitle:@"取消"
                                  andEnsureBtnTitle:@"确定"
                                    textFieldLength:4
                                         lengthType:FLLengthTypeLength
                                        originalStr:nil];
    _popViewTag = 63;
    [self.view addSubview:_popView];
}

#pragma mark 设置headerImage
/**
 *type :1代表image 2代表url
 *
 */
- (void)setHeaderImageInMyInfoViewType:(FLPortrainImageType)imageType image:(UIImage*)flimage url:(NSString*)flurlStr
{
    
}

/**
 *新增手机号代理
 *
 */
- (void)FLBlindWithThirdTableViewController:(FLBlindWithThirdTableViewController *)flvc blindPhoneNumber:(NSString *)phoneNumber
{
    self.testLabelPhone = [[UILabel alloc]init];
    self.testLabelPhone.text = phoneNumber;
    [self.tableView reloadData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)xjSetBusInfoModelWithModel:(FLBusAccountInfoModel*) xjBusAccountModel{
    [FLBusAccountInfoModel share].busEmail = xjBusAccountModel.busEmail;
    [FLBusAccountInfoModel share].busHeaderImageStr = xjBusAccountModel.busHeaderImageStr;
    [FLBusAccountInfoModel share].busUserId = xjBusAccountModel.busUserId;
    [FLBusAccountInfoModel share].busfullName = xjBusAccountModel.busfullName;
    [FLBusAccountInfoModel share].busSimpleName = xjBusAccountModel.busSimpleName;
    [FLBusAccountInfoModel share].busSimpleIntroduce = xjBusAccountModel.busSimpleIntroduce;
    [FLBusAccountInfoModel share].busCreatTime = xjBusAccountModel.busCreatTime;
    [FLBusAccountInfoModel share].busliceneNumber = xjBusAccountModel.busliceneNumber;
    [FLBusAccountInfoModel share].busStateInt = xjBusAccountModel.busStateInt;
    [FLBusAccountInfoModel share].busphoneNumber = xjBusAccountModel.busphoneNumber;
}


@end













