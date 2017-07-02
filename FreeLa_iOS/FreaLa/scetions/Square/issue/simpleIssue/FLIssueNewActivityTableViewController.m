//
//  FLIssueNewActivityTableViewController.m
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLIssueNewActivityTableViewController.h"
#import "FLMoreTextPageViewController.h"
//#import "XJImageCropperViewController.h"
#import "PECropViewController.h"
#import "XJTagListModel.h"
#import "UIImage+xjFixOrientation.h"

#define FL_headerViewWith   (FLUISCREENBOUNDS.width - 40)
#define FL_headerViewHeigh  200
#define FL_MarginBig    20
#define FL_MargibSmall  10
#define FL_halfWith   ((FL_headerViewWith) / 2)


@interface FLIssueNewActivityTableViewController ()<UIGestureRecognizerDelegate,SelectPhotoDelegate,FLMoreTextPageViewControllerDelegate,PECropViewControllerDelegate>
/**提交信息按钮*/
@property (nonatomic , strong)UIButton* flsubmitBtn;
/**封面图str*/
@property (nonatomic , strong)NSString* flimageInterfaceStr;
/**封面图image*/
@property (nonatomic , strong)UIImage* flimageInterfaceImage;

/**轮播图*/
@property (nonatomic , strong)NSString* flimageThreeStr;
/**轮播图image*/
@property (nonatomic , strong)UIImageView* flimageThreeStrImageView;
/**headerView*/
@property (nonatomic , strong)UIView* flheaderView;
/**轮播图的数组*/
//@property (nonatomic , strong)NSMutableArray* flimageThreeArray;
/**轮播图的数组 str*/
@property (nonatomic , strong)NSMutableArray* flimageThreeStrArray;
/**轮播图的数组 fileNmae*/
@property (nonatomic , strong)NSMutableArray* flimageThreeFileNameArray;

@property (nonatomic , strong)ZHPickView* pickview; //delete

@property (nonatomic , assign) NSInteger flselectedImageIndex;

@property (nonatomic , strong)UIButton* nextBtn;

@end
static NSInteger popViewTag ,listViewTag; //弹出层10，下拉列表层 40
@implementation FLIssueNewActivityTableViewController
{
    BOOL _isSignUpLimitOn;  //用户报名限制
    BOOL _isConditionOn;   //领取条件
    BOOL _isRulesOn;        //领取规则
    BOOL _canSubMitIssue; //能否发布
    BOOL _flisInterfaceImage; //选中的是不是缩略图
    BOOL _flIsHelpParmShow;   //助力抢参数有没有的值(助力数，助力规则等)
    BOOL _flIsRulesParmShow;  //领取规则参数有么有
    BOOL _flISMorePicChoose;  //是否照片多选
    
    NSInteger _flupdateImageOneStrat; //多图上传顺序
    
    
    NSString* _conditionsCellString; // 领取条件
    NSString* _rulesCellString; //领取规则
    NSString* _rulesSecCellString; //先到先得。。。
    NSString* _heigherCellRangeStr; //领取人群
    
    NSArray* _arrayConditionsKey;   //领取条件的key
    NSArray* _arrayConditionsValue; //领取条件的value
    NSArray* _arrayRulesKey;   //领取规则的key
    NSArray* _arrayRulesValue; //领取规则的valu
    
    NSString* _flPartInfoString; //需要填写的领取信息
    NSString* _flPartInfoKeyToService; //传给服务器的参，限制领取信息
    
    
    NSDictionary* _fldicForHeigherCellRange;   //领取高级选项下拉的字典(领取人群)
    NSString* _flStrForHeigherCellRangeSelected;  //选中的领取人群的key
    FLPopBaseView* _popView;
    
    
    NSMutableArray* _flimagesURLarray;   //轮播图数组 (展示)
    BOOL _flImageIsFull; //4张是不是选满
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableViewInSimpleIssue];
    [self setUpAlloc];
    _isSignUpLimitOn = YES;
    _isConditionOn = NO;
    _isRulesOn      =NO;
    _flIsHelpParmShow = NO;
    _flIsRulesParmShow = NO;
    _flISMorePicChoose = NO;
    _flImageIsFull = NO;
    _flupdateImageOneStrat = 0;
    _flselectedImageIndex = -1;
    //    if (_flimageThreeArray) {
    //
    //    } else {
    //        _flimageThreeArray  = [NSMutableArray array];
    //    }
    //    [self getSomeConditionsAndRules]; //请求接口
    //    [self setIssueInfoDataConditionsAndRules];// 给cell赋值
    //    [self setUpMyHeaderViewForInputImage]; //头部视图
    [self registerMyTableViewCell];//注册cell
    self.title = @"简洁版";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self initSubMitButton];
    
    //    [self scrollViewDidScroll:self.tableView];
    
    //添加一个Tap手势用来点击空白区域关闭键盘
    UITapGestureRecognizer* tapGertureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardWithSwip)];
    tapGertureRecognizer.numberOfTapsRequired = 1 ;
    tapGertureRecognizer.numberOfTouchesRequired = 1;
    tapGertureRecognizer.delegate = self;
    //    [self.view addGestureRecognizer:tapGertureRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAddTagViewInSquare) name:@"FLShowAddTagViewInSquare" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    [self.tableView reloadData];
//}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 6;
    }
    else
    {
        return  _isSignUpLimitOn? 1: 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
    if (indexPath.section == 0 )
    {
        if (indexPath.row == 0)
        {
            self.flactivityImageCell = [self.tableView dequeueReusableCellWithIdentifier:@"FLActivityImageTableViewCell" forIndexPath:indexPath];
            [self addActionPickImageWithCell];
            //1 为数据回填进入  0为新发布
            if (FLFLXJIssueWithDataOrNot)
            {
                
                //                [_flimageThreeFileNameArray removeAllObjects];
                [self.flactivityImageCell.flinterfaceImageView sd_setImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:_flissueInfoModel.flactivitytopicThumbnailStr isSite:NO]] placeholderImage:[UIImage imageNamed:@"issue_interface_image_big"]];
                //                [self.flimageThreeArray removeAllObjects];
                for (NSInteger i = 0;  i < _flimagesURLarray.count; i++)
                {
                    if (_flimagesURLarray.count > 4) {
                        NSLog(@"数组溢出了，这是多少张照片啊");
                    } else {
                        [self.flactivityImageCell.flimageArray[i]  sd_setImageWithURL:[NSURL URLWithString:_flimagesURLarray[i]] placeholderImage:[UIImage imageNamed:@"issue_interface_image_big"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                                //                            [self.flimageThreeArray addObject:image];
                            }
                        }];
                    }
                    
                }
            } else {
                //                self.flactivityImageCell.flinterfaceImageView.image = self.flimageInterfaceImage ? self.flimageInterfaceImage :[UIImage imageNamed:@"issue_interface_image_big"];   //读取相册图
                [self.flactivityImageCell.flinterfaceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flissueInfoModel.flactivitytopicThumbnailStr isSite:NO]]] placeholderImage:[UIImage imageNamed:@"issue_interface_image_big"]];
                //                for (NSInteger i = 0;  i< self.flimageThreeArray.count; i++)
                //                {
                //                    [self.flactivityImageCell.flimageArray[i] setImage:self.flimageThreeArray[i]];
                //                }
                for (NSInteger i = 0;  i < _flimagesURLarray.count; i++)
                {
                    [self.flactivityImageCell.flimageArray[i]  sd_setImageWithURL:[NSURL URLWithString:_flimagesURLarray[i]] placeholderImage:[UIImage imageNamed:@"issue_interface_image_big"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (image) {
                            //                            [self.flimageThreeArray addObject:image];
                        }
                    }];
                }
                
            }
            [self.flactivityImageCell flViewShowWithInteger:_flimagesURLarray.count];
            return self.flactivityImageCell;
        }
        else if (indexPath.row == 1)
        {
            if (self.flissueInfoModel.flactivityTopicSubjectStr) {
                cell.textLabel.text = self.flissueInfoModel.flactivityTopicSubjectStr;
            }else
            {
                cell.textLabel.text = @"请输入活动主题，建议18字以内";
            }
            //            cell.textLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 2)
        {
            self.flactivityDeatilCell = [self.tableView dequeueReusableCellWithIdentifier:@"FLActivityDetailTableViewCell" forIndexPath:indexPath];
            //            FLRichTextViewController* richVC = [[FLRichTextViewController alloc] init];
            //            richVC.view.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, 300);
            //            [self addChildViewController:richVC];
            //            [self.flactivityDeatilCell addSubview:richVC.view];
            return self.flactivityDeatilCell;
        }
        else if (indexPath.row == 3)
        {
            self.flactivityDeailInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"FLAvtivityCustomTableViewCell" forIndexPath:indexPath];
            self.flactivityDeailInfoCell.flAvtivityDisCribeLabel.text = @"活动地点";
            self.flactivityDeailInfoCell.flAvtivityDiscribeInfoLabel.text = self.flissueInfoModel.flactivityAdress;
            
            return self.flactivityDeailInfoCell;
        }
        else if (indexPath.row == 4)
        {
            self.flactivityDeailHeighterInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"FLActivityHeighterInfoTableViewCell" forIndexPath:indexPath];
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text = self.flissueInfoModel.flactivityValueOnMarket;
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterLabel.text = @"市面价值";
            return self.flactivityDeailHeighterInfoCell;
        }
        else if (indexPath.row == 5 )
        {
            self.flactivityDeailHeighterInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"FLActivityHeighterInfoTableViewCell" forIndexPath:indexPath];
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text = self.flissueInfoModel.flactivityTopicIntroduceStr;
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterLabel.text = @"使用说明";
            return self.flactivityDeailHeighterInfoCell;
        }
        else
        {
            return cell;
            
        }
        
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            self.flactivitySignUpLimitCell = [self.tableView dequeueReusableCellWithIdentifier:@"FLActivitySignUpLimitTableViewCell" forIndexPath:indexPath];
            //            self.flactivitySignUpLimitCell.flacceptStr = self.flPartInfoDeliverToThirdVCStr;
            self.flactivitySignUpLimitCell.tagsMuArrNew = [self selfToolsReturnValueArrayWithData:_flissueInfoModel.flPartInfoKeyValueArray].mutableCopy;
            self.flactivitySignUpLimitCell.tagsKeyMuArrNew = [self selfToolsReturnKeyArrayWithData:_flissueInfoModel.flPartInfoKeyValueArray].mutableCopy;
            self.flactivitySignUpLimitCell.tagsBackMuArrNew = [self returnMuArrWithStr:_flissueInfoModel.flactivitytopicLimitTags];
            self.flactivitySignUpLimitCell.flVC = self;
            return  self.flactivitySignUpLimitCell;
        }
        else{return nil;}
    }
    else
    {
        
        cell.textLabel.text = @"12";
        
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0)  {
        if (indexPath.row == 1)  {
            FL_Log(@"点了0");
            _popView = [[FLPopBaseView alloc] initWithTitle:@"活动主题" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 18 lengthType:FLLengthTypeLength originalStr:_flissueInfoModel.flactivityTopicSubjectStr ? _flissueInfoModel.flactivityTopicSubjectStr : @""];
            _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
            [_popView.flInputTextField becomeFirstResponder];
            popViewTag = 12;
            [self.navigationController.view addSubview:_popView];
        }  else if (indexPath.row == 2)  {
            FL_Log(@"点了0-2");
            FLRichTextViewController* richVC = [[FLRichTextViewController alloc] init];
            richVC.flissueInfoModel = self.flissueInfoModel;
            [self.navigationController pushViewController:richVC animated:YES];
        }  else if (indexPath.row == 3)  {
            FL_Log(@"点了地图");
            FLChooseMapViewController* chooseMapVC   = [[FLChooseMapViewController alloc] init];
            chooseMapVC.delegate = self;
            //            [self presentViewController:chooseMapVC animated:YES completion:nil];
            [self.navigationController pushViewController:chooseMapVC animated:YES];
        } else if (indexPath.row == 4 )  {
            FL_Log(@"点了市面价值");
            _popView = nil;
            _popView = [[FLPopBaseView alloc] initWithTitle:@"市面价值(元)" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 1000000 lengthType:FLLengthTypeInteger originalStr:_flissueInfoModel.flactivityValueOnMarket ? _flissueInfoModel.flactivityValueOnMarket : @""];
            [_popView.flInputTextField becomeFirstResponder];
            popViewTag = 10;
            [FL_KEYWINDOW_VIEW_NEW addSubview:_popView];
        }  else if (indexPath.row == 5)  {
            FL_Log(@"点了 使用说明");
            //            _popView = [[FLPopBaseView alloc] initWithTitle:@"使用说明" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 100 lengthType:FLLengthTypeLength originalStr:nil];
            //            [_popView.flInputTextField becomeFirstResponder];
            //            popViewTag = 13;
            //            [self.navigationController.view addSubview:_popView];
            FLMoreTextPageViewController* helpVC = [[FLMoreTextPageViewController alloc] initWithNibName:@"FLMoreTextPageViewController" bundle:nil];
            helpVC.XJtitle = @"使用说明";
            helpVC.XJMaxLimit = 200;
            helpVC.XJStr = _flissueInfoModel.flactivityTopicIntroduceStr ?  _flissueInfoModel.flactivityTopicIntroduceStr:@"";
            helpVC.delegate = self;
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        
    }  else if (indexPath.section == 1) {
        FL_Log(@"点了标签限制");
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 200;
        }
        else if (indexPath.row == 2)
        {
            return 44;
        }
        else
        {
            return  44 ;
        }
        
    }
    else if (indexPath.section == 1 )
    {
        if (indexPath.row == 0)
        {
            return 140 ;
        }
        else
        {
            return 44;
        }
    }
    else
    {
        return 44;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        [self.flSignUpBaseView.flopenSwitch addTarget:self action:@selector(changeSwitchActionLimit) forControlEvents:UIControlEventValueChanged];
        return self.flSignUpBaseView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 )
    {
        return 44;
    }
    
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}




#pragma mark ----- registerCell
- (void)registerMyTableViewCell
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.tableView registerClass:[FLActivityDetailTableViewCell class] forCellReuseIdentifier:@"FLActivityDetailTableViewCell"];
    [self.tableView registerClass:[FLAvtivityCustomTableViewCell class] forCellReuseIdentifier:@"FLAvtivityCustomTableViewCell"];
    [self.tableView registerClass:[FLActivityHeighterChooseTableViewCell class] forCellReuseIdentifier:@"FLActivityHeighterChooseTableViewCell"];
    [self.tableView registerClass:[FLActivityHeighterInfoTableViewCell class] forCellReuseIdentifier:@"FLActivityHeighterInfoTableViewCell"];
    [self.tableView registerClass:[FLActivitySignUpLimitTableViewCell class] forCellReuseIdentifier:@"FLActivitySignUpLimitTableViewCell"];
    [self.tableView registerClass:[FLTakeRulesTableViewCell class] forCellReuseIdentifier:@"FLTakeRulesTableViewCell"];
    [self.tableView registerClass:[FLTakeConditionTableViewCell class] forCellReuseIdentifier:@"FLTakeConditionTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FLActivityImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLActivityImageTableViewCell"];
    
    self.flactivitySignUpLimitCell = [[FLActivitySignUpLimitTableViewCell alloc] init];
    self.flactivityDeailHeighterCell = [[FLActivityHeighterChooseTableViewCell alloc] init];
    self.flactivityImageCell = [[FLActivityImageTableViewCell alloc] init];
    self.flactivityDeailInfoCell = [[FLAvtivityCustomTableViewCell alloc] init];
}

#pragma mark------actions
- (void)changeSwitchActionLimit
{
    FL_Log(@"刷新之前");
    _isSignUpLimitOn = !_isSignUpLimitOn;
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationFade];
    FL_Log(@"刷新之后");
}

- (void)changeSwitchActionCondition
{
    _isConditionOn = !_isConditionOn;
    
    [self.tableView reloadData];
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:6];
    [self.tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationFade];
}

- (void)changeSwitchActionRules
{
    _isRulesOn = !_isRulesOn;
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:7];
    [self.tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationFade];
}


- (void)getInfoAndPassToNextWithData:(NSDictionary*)data
{
    //所有标签
    //    _flPartInfoString = data[FL_NET_DATA_KEY][@"partInfo"];
    //    FL_Log(@"dictag in issue part info = %@",_flPartInfoString);
    
    NSDictionary* dic1 = data[FL_NET_DATA_KEY][@"PARTINFO"];
    _flPartInfoString = [FLTool returnDictionaryToJson:dic1];
    //    _flPartInfoString = data[FL_NET_DATA_KEY][@"PARTINFO"];
    FL_Log(@"dictag in issue part info = %@",_flPartInfoString);
    
    
}

- (void)addActionPickImageWithCell
{
    
    //    self.flactivityImageCell.flinterfaceImageView.userInteractionEnabled = YES;
    [self.flactivityImageCell.flinterfaceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)]];
    [self.flactivityImageCell.flOnebyOneFirst addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)]];
    [self.flactivityImageCell.flOnebyOneSecond addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)]];
    [self.flactivityImageCell.flOnebyOneThird addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)]];
    [self.flactivityImageCell.flOnebyOneFourth addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)]];
    
    
    [self.flactivityImageCell.flOnebyOneFirst addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(UserClickedWithLongGr:)]];
    [self.flactivityImageCell.flOnebyOneSecond addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(UserClickedWithLongGr:)]];
    [self.flactivityImageCell.flOnebyOneThird addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(UserClickedWithLongGr:)]];
    [self.flactivityImageCell.flOnebyOneFourth addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(UserClickedWithLongGr:)]];
    
    [self.flactivityImageCell.flCloseBtnOne addTarget:self action:@selector(clickToCloseTheImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.flactivityImageCell.flCloseBtnTwo addTarget:self action:@selector(clickToCloseTheImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.flactivityImageCell.flCloseBtnThree addTarget:self action:@selector(clickToCloseTheImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.flactivityImageCell.flCloseBtnFour addTarget:self action:@selector(clickToCloseTheImage:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark-------pick photo
- (void)UesrClicked:(UITapGestureRecognizer*)gestureRecognizer
{
    [self.flactivityImageCell flCloseBtnSetHidden:YES withInteger:_flimagesURLarray.count];
    _flupdateImageOneStrat = 0;
    //选择照片
    LocalPhotoViewController* pick = [[LocalPhotoViewController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:nil action:nil];
    pick.selectPhotoDelegate = self;
    //    pick.selectPhotos = self.flimageThreeArray;
    pick.issueVC = self;
    UIView *viewClicked=[gestureRecognizer view];
    if (viewClicked==self.flactivityImageCell.flinterfaceImageView)
    {
        FL_Log(@"tou");
        //选择照片
        pick.isInterfaceImageType = YES;
        _flisInterfaceImage = YES;
        
    }
    else
    {
        pick.isInterfaceImageType = NO;
        _flisInterfaceImage = NO;
        //选择照片
        if(viewClicked==self.flactivityImageCell.flOnebyOneFirst)
        {
            FL_Log(@"imageView1");
            _flselectedImageIndex = 1;
        }
        else if(viewClicked==self.flactivityImageCell.flOnebyOneSecond)
        {
            FL_Log(@"imageView2");
            _flselectedImageIndex = 2;
        }
        else if(viewClicked==self.flactivityImageCell.flOnebyOneThird)
        {
            FL_Log(@"imageView3");
            _flselectedImageIndex = 3;
        }
        else if(viewClicked==self.flactivityImageCell.flOnebyOneFourth)
        {
            FL_Log(@"imageView4");
            _flselectedImageIndex = 4;
        }
        pick.flAlreadyImageInteger = _flselectedImageIndex - 1 ;
    }
    if (_flimagesURLarray.count == 4) {
        _flImageIsFull = YES;
    } else {
        _flImageIsFull = NO;
    }
    pick.flisFull = _flImageIsFull;
    [self.navigationController pushViewController:pick animated:YES];
    
}

#pragma mark delegate photo
- (void)UserClickedWithLongGr:(UILongPressGestureRecognizer*)longGr
{
    FL_Log(@"this is longergr delegate");
    [self.flactivityImageCell flCloseBtnSetHidden:NO withInteger:_flimagesURLarray.count];
}

#pragma mark removePhoto
- (void)clickToCloseTheImage:(UIButton*)sender
{
    NSInteger selectedIndex = -1;
    if (sender == self.flactivityImageCell.flCloseBtnOne) {
        FL_Log(@"this action is to remove the image 1");
        selectedIndex = 1;
    } else if (sender == self.flactivityImageCell.flCloseBtnTwo) {
        FL_Log(@"this action is to remove the image 2");
        selectedIndex = 2;
    } else if (sender == self.flactivityImageCell.flCloseBtnThree) {
        FL_Log(@"this action is to remove the image 3");
        selectedIndex = 3;
    } else if (sender == self.flactivityImageCell.flCloseBtnFour) {
        FL_Log(@"this action is to remove the image 4");
        selectedIndex = 4;
    }
    [self removeObjWithIndex:selectedIndex];
    FL_Log(@"this action is to remove the image end=%@",_flimagesURLarray);
}

- (void)removeObjWithIndex:(NSInteger)flindex
{
    
    [_flimagesURLarray removeObjectAtIndex:flindex - 1];
    [_flimageThreeFileNameArray removeObjectAtIndex:flindex - 1];
    [self.flactivityImageCell flViewShowWithInteger:_flimagesURLarray.count];
    [self.flactivityImageCell flCloseBtnSetHidden:NO withInteger:_flimagesURLarray.count];
    [self.tableView reloadData];
}
#pragma mark  - -- -- --- -- -- -- -- --- - - - - - - - -  -- -   选完照片的回调

-(void)getSelectedPhoto:(NSMutableArray *)photos {
    _flimageThreeStrArray = [NSMutableArray array];
    if (photos.count == 1) {
        _flISMorePicChoose = NO;
    } else {
        _flISMorePicChoose = YES;
    }
    FL_Log(@"供选择%lu张照片",(unsigned long)[photos count]);
    if (_flisInterfaceImage) {
        self.flimageInterfaceImage = [FLTool returnPhotoWithPhotos:photos AndIndex:0];
        
        if ([self.flissueInfoModel.flissueActivityFromType isEqualToString:FLFLXJSquareAllFreeStrKey]) {
            //            xjImageCropper.xjRatio = 3./2.;
            
            PECropViewController *controller = [[PECropViewController alloc] init];
            controller.delegate = self;
            controller.image = self.flimageInterfaceImage;
            controller.xjRatio = 1./1.;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navigationController animated:YES completion:NULL];
        } else if ([self.flissueInfoModel.flissueActivityFromType isEqualToString:FLFLXJSquareCouponseStrKey]) {
            PECropViewController *controller = [[PECropViewController alloc] init];
            controller.delegate = self;
            controller.image = self.flimageInterfaceImage;
            controller.xjRatio = 1./1.;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navigationController animated:YES completion:NULL];
        } else {
            //上传到服务器
            [self insertImageToServiceWithImage:self.flimageInterfaceImage IsInterFaceImage:_flisInterfaceImage];
        }
    } else {
        if (_flselectedImageIndex != -1 && photos.count != 0) {
            [self flreturnImageArrWithPhotos:photos];
        }
    }
    [self.tableView reloadData];
}

- (void)flreturnImageArrWithPhotos:(NSMutableArray*)photos
{
    //    self.flactivityImageCell.flselectedIndex = _flselectedImageIndex;  //那个隐藏
    //1 数据回填   0新发布
    if (photos.count==0) {
        return;
    }
    if (FLFLXJIssueWithDataOrNot) {
        NSMutableArray* testMorePicArr = [NSMutableArray array];
        for (NSInteger i  = 0; i <photos.count; i++)
        {
            UIImage*image = [FLTool returnPhotoWithPhotos:photos AndIndex:i];
            if (_flselectedImageIndex <= _flissueInfoModel.flactivitytopicDetailchartArr.count) {
                //                 [self.flimageThreeArray replaceObjectAtIndex:_flselectedImageIndex - 1 withObject:image];
            } else if (_flselectedImageIndex > _flissueInfoModel.flactivitytopicDetailchartArr.count) {
                //                 [self.flimageThreeArray addObject:image];
            }
            //             [NSThread sleepForTimeInterval:0.6];
            FL_Log(@"thisi is my photots to update =%@",photos);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                   [self insertImageToServiceWithImage:image IsInterFaceImage:_flisInterfaceImage];
            });
            //用于多图上传
            [testMorePicArr addObject:image];
            
        }
        [self testToUpdateMorePicWithArr:testMorePicArr];
        
    } else {
        NSMutableArray* muarr = [NSMutableArray array];
        for (NSInteger i  = 0; i <photos.count; i++) {
            UIImage*image = [FLTool returnPhotoWithPhotos:photos AndIndex:i];
            //             if (_flselectedImageIndex <= self.flimageThreeArray.count) {
            //                 [self.flimageThreeArray replaceObjectAtIndex:_flselectedImageIndex - 1 withObject:image];
            //             } else if (_flselectedImageIndex > self.flimageThreeArray.count) {
            //                 [self.flimageThreeArray addObject:image];
            //             }
            [muarr addObject:image];
            //             [self insertImageToServiceWithImage:image IsInterFaceImage:_flisInterfaceImage];
            
        }
        [self testToUpdateMorePicWithArr:muarr];
        
    }
    //     [self.tableView reloadData];
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"请稍侯" view:FL_KEYWINDOW_VIEW_NEW];
    
}
#pragma mark 多图上传上传
- (void)testToUpdateMorePicWithArr:(NSMutableArray* )flmuarr
{
    NSDictionary* parm = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID],
                           @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:FL_USERDEFAULTS_USERID_KEY],
                           @"picType":[NSNumber numberWithInteger:4]
                           };
    if (_flupdateImageOneStrat == flmuarr.count) {
        FL_Log(@"上传从这里停止");
        [[FLAppDelegate share] hideHUD];
        return;
    } else {
        UIImage* xjIImage = flmuarr[_flupdateImageOneStrat];
        //        xjIImage = [FLTool fixOrientationss:xjIImage];
        [FLNetTool setIssueDetailImage:flmuarr[_flupdateImageOneStrat] parm:parm success:^(NSDictionary *data) {
            FL_Log(@"成功nnnnnnnnnn = %@",data);
            if ([[data objectForKey:@"success"] boolValue]) {
                _flupdateImageOneStrat ++;
                [self testToUpdateMorePicWithArr:flmuarr];
                if (_flselectedImageIndex <= _flimagesURLarray.count && !_flISMorePicChoose) {
                    //成功，拼接图片url地址
                    NSString* imageUrlStr =  data[FL_NET_DATA_KEY][@"result"];
                    if (_flimagesURLarray.count == 4) {
                        
                    } else {
                        [_flimageThreeFileNameArray replaceObjectAtIndex:_flselectedImageIndex - 1 withObject:(data[FL_NET_DATA_KEY][@"filename"])];
                    }
                    //替换url 刷新界面
                    [_flimagesURLarray replaceObjectAtIndex:_flselectedImageIndex - 1 withObject:[FLTool returnPhotoAddressWithResult:imageUrlStr]];
                    //                    self.flissueInfoModel.flactivitytopicDetailchartArr =  [_flimageThreeStrArray mutableCopy]; //轮播图
                    //                    NSArray* arrayDetail = [_flimageThreeFileNameArray mutableCopy];
                    //                    self.flissueInfoModel.flactivitytopicDetailchartFileName = [arrayDetail componentsJoinedByString:@","];//轮播图的name
                    [self.tableView reloadData];
                } else  {
                    //成功，拼接图片url地址
                    NSString* imageUrlStr =  data[FL_NET_DATA_KEY][@"result"];
                    [_flimageThreeStrArray addObject:[FLTool returnPhotoAddressWithResult:imageUrlStr]];
                    if (!_flimageThreeFileNameArray) {
                        _flimageThreeFileNameArray = [NSMutableArray array];
                    }
                    [_flimageThreeFileNameArray addObject:(data[FL_NET_DATA_KEY][@"filename"])];
                    if (!_flimagesURLarray) {
                        _flimagesURLarray = [NSMutableArray array];
                    }
                    [_flimagesURLarray addObject:[FLTool returnPhotoAddressWithResult:imageUrlStr]];
                    //                    [_flimagesURLarray addObject:  imageUrlStr ];
                    FL_Log(@"this is my test image arr 1= %@",_flimagesURLarray);
                    [self.tableView reloadData];
                }
                
            }
        } failure:^(NSError *error) {
            [[FLAppDelegate share] hideHUD];
        }];
        
    }
}

#pragma mark --------上传照片，得到url
- (void)insertImageToServiceWithImage:(UIImage*)selectedImage IsInterFaceImage:(BOOL)IsInterFaceImage
{
    if (!selectedImage) {
        return;
    }
    NSInteger xjPicType;
    if (!IsInterFaceImage) {
        xjPicType = 4;
    } else if ([self.flissueInfoModel.flissueActivityFromType isEqualToString:FLFLXJSquareAllFreeStrKey]) {
        xjPicType = 1;
    } else if ([self.flissueInfoModel.flissueActivityFromType isEqualToString:FLFLXJSquareCouponseStrKey]) {
        xjPicType = 2;
    } else if ([self.flissueInfoModel.flissueActivityFromType isEqualToString:FLFLXJSquarePersonStrKey]) {
        xjPicType = 3;
    }
    NSDictionary* parm = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID],
                           @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:FL_USERDEFAULTS_USERID_KEY],
                           @"picType":[NSNumber numberWithInteger:xjPicType]   //1全免费2优惠券3个人免费4轮播详情图
                           };
    //处理图片旋转问题
    //    selectedImage = [selectedImage xjFixOrientation];
    
    if (_flisInterfaceImage)
    {
        [[FLAppDelegate share] showSimplleHUDWithTitle:@"请稍后" view:FL_KEYWINDOW_VIEW_NEW];
        [FLNetTool setIssueDetailImage:selectedImage parm:parm success:^(NSDictionary *data) {
            FL_Log(@"成功 in update my pic in issue  = %@",data);
            if ([[data objectForKey:@"success"] boolValue]) {
                //成功，拼接图片url地址
                NSString* imageUrlStr =  data[FL_NET_DATA_KEY][@"result"];
                self.flissueInfoModel.flactivitytopicThumbnailStr = imageUrlStr;//[FLTool returnPhotoAddressWithResult:imageUrlStr];  //^^^url^^^
                self.flissueInfoModel.flactivitytopicThumbnailFileName = data[FL_NET_DATA_KEY][@"filename"];
                self.flactivityImageCell.xjTipsLabel.hidden = YES;
                [self.tableView reloadData];
            }
            [[FLAppDelegate share] hideHUD];
        } failure:^(NSError *error) {
            [[FLAppDelegate share] hideHUD];
        }];
    } else {
        FL_Log(@"进来了进来了====image=%@",selectedImage);
        [FLNetTool setIssueDetailImage:selectedImage parm:parm success:^(NSDictionary *data) {
            FL_Log(@"成功nnnnnnnnnn = %@",data);
            if ([[data objectForKey:@"success"] boolValue]) {
                if (_flselectedImageIndex <= _flimagesURLarray.count && !_flISMorePicChoose) {
                    //成功，拼接图片url地址
                    NSString* imageUrlStr =  data[FL_NET_DATA_KEY][@"result"];
                    [_flimageThreeFileNameArray replaceObjectAtIndex:_flselectedImageIndex - 1 withObject:(data[FL_NET_DATA_KEY][@"filename"])];
                    //替换url 刷新界面
                    [_flimagesURLarray replaceObjectAtIndex:_flselectedImageIndex - 1 withObject:[FLTool returnPhotoAddressWithResult:imageUrlStr]];
                    
                    //                    self.flissueInfoModel.flactivitytopicDetailchartArr =  [_flimageThreeStrArray mutableCopy]; //轮播图
                    //                    NSArray* arrayDetail = [_flimageThreeFileNameArray mutableCopy];
                    //                    self.flissueInfoModel.flactivitytopicDetailchartFileName = [arrayDetail componentsJoinedByString:@","];//轮播图的name
                    [self.tableView reloadData];
                } else  {
                    //成功，拼接图片url地址
                    NSString* imageUrlStr =  data[FL_NET_DATA_KEY][@"result"];
                    [_flimageThreeStrArray addObject:[FLTool returnPhotoAddressWithResult:imageUrlStr]];
                    [_flimageThreeFileNameArray addObject:(data[FL_NET_DATA_KEY][@"filename"])];
                    [_flimagesURLarray addObject:[FLTool returnPhotoAddressWithResult:imageUrlStr]];
                    FL_Log(@"this is my test image arr 2= %@",_flimagesURLarray);
                    [self.tableView reloadData];
                }
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)closeKeyBoardWithSwip {
    FL_Log(@"sss");
    [self.tableView endEditing:YES];
    
}

#pragma mark -----init

- (void)setUpAlloc {
    self.flSignUpBaseView = [[FLActivitySignUpBaseView alloc] init];
    self.flSignUpBaseView.backgroundColor  = [UIColor whiteColor];
    
    self.flactivityImageCell = [[FLActivityImageTableViewCell alloc] init];
    _flimageThreeFileNameArray = @[].mutableCopy;
    _flimageThreeFileNameArray = [self.flissueInfoModel.flactivitytopicDetailchartFileName componentsSeparatedByString:@","].mutableCopy;
}

- (void)setFlissueInfoModel:(FLIssueInfoModel *)flissueInfoModel{
    _flissueInfoModel = flissueInfoModel;
    FL_Log(@"=======st===============%@ ++++==========%@",_flissueInfoModel.flactivitytopicDetailchartArr,_flissueInfoModel.flactivitytopicThumbnailStr);
    _flimagesURLarray = [NSMutableArray array];
    NSMutableArray* arrayImageURL = [NSMutableArray array];
    //    _flimageThreeArray = [NSMutableArray array];
    
    
    arrayImageURL  = [NSMutableArray arrayWithArray:_flissueInfoModel.flactivitytopicDetailchartArr];
    if ( _flissueInfoModel.flactivitytopicDetailchartArr.count > 4) {
        _flissueInfoModel.flactivitytopicDetailchartArr = [_flissueInfoModel.flactivitytopicDetailchartArr subarrayWithRange:NSMakeRange(0, 4)];
    }
    _flimagesURLarray = _flissueInfoModel.flactivitytopicDetailchartArr.mutableCopy;
    FL_Log(@"testetstestetstets=%@",arrayImageURL);
    
    //给 filename 赋值 和 url
    //    self.flimageThreeFileNameArray = [_flissueInfoModel.flactivitytopicDetailchartFileName componentsSeparatedByString:@","].mutableCopy;
    //    _flimageThreeFileNameArray     = [_flissueInfoModel.flactivitytopicDetailchartFileName componentsSeparatedByString:@","].mutableCopy;
    //更改市面价值的 格式
    if ([_flissueInfoModel.flactivityValueOnMarket rangeOfString:@"."].location != NSNotFound) {
        NSInteger location = [_flissueInfoModel.flactivityValueOnMarket rangeOfString:@"."].location ;
        FL_Log(@"thisi is locaion =%ld",location);
        if (_flissueInfoModel.flactivityValueOnMarket.length >= location + 3) {
            _flissueInfoModel.flactivityValueOnMarket = [_flissueInfoModel.flactivityValueOnMarket substringToIndex:location + 3];
        }
    }
    
}

- (void)initTableViewInSimpleIssue
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height ) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.view addSubview:self.tableView];
}

#pragma mark 下一步
- (void)initSubMitButton
{
    //右上角
    //    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(clickMakeSureToSubmit)];
    //
    //        self.navigationItem.rightBarButtonItem = rightItem;
    //下一步
    self.nextBtn = [FLSquareTools retutnNextBtnWithTitle:@"下一步"];
    [self.nextBtn addTarget:self action:@selector(clickMakeSureToSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
}


#pragma mark--- actions
- (void)ClickToHaveALook
{
    //预览
    FLIssueQuickLookViewController* quickVC = [[FLIssueQuickLookViewController alloc] init];
    quickVC.flissueInfoModel = self.flissueInfoModel;
    [self.navigationController pushViewController:quickVC animated:YES];
}
#pragma mark ZhpickVIewDelegate


- (void)clickMakeSureToSubmit {
    
    _flPartInfoKeyToService = [[self xjReturnFinalKeyToSever] componentsJoinedByString:@","];
    //    FL_Log(@"caocaonidayede delegate=%@",_flPartInfoKeyToService);
    self.flissueInfoModel.flactivitytopicDetailchartArr =  [_flimagesURLarray mutableCopy]; //轮播图
    NSArray* arrayDetail = [_flimageThreeFileNameArray mutableCopy];
    self.flissueInfoModel.flactivitytopicDetailchartFileName = [arrayDetail componentsJoinedByString:@","];//轮播图的name
    //得到partInfo
    self.flissueInfoModel.flactivitytopicLimitTags = _flPartInfoKeyToService;   //没有改动之前
    [self checkInfoFirst];
    
}

- (void)checkInfoFirst
{
    
    if (!self.flissueInfoModel.flactivitytopicThumbnailStr) {
        [[FLAppDelegate share] showHUDWithTitile:@"请选择一张缩略图" view:self.navigationController.view delay:1 offsetY:0];
        _canSubMitIssue = NO;
    }
    else if (![FLTool returnStrWithArr:self.flissueInfoModel.flactivitytopicDetailchartArr])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请选择详情轮播图" view:self.self.navigationController.view delay:1 offsetY:0];
        _canSubMitIssue = NO;
    }
    else  if (!self.flissueInfoModel.flactivityTopicSubjectStr)
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请填写活动主题" view:self.self.navigationController.view delay:1 offsetY:0];
        _canSubMitIssue = NO;
    }
    else if ([self.flissueInfoModel.flactivitytopicDetailStr isEqualToString:@"<p></p>"] || self.flissueInfoModel.flactivitytopicDetailStr == nil)
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请填写活动详情" view:self.self.navigationController.view delay:1 offsetY:0];
        _canSubMitIssue = NO;
    }
    else
    {
        _canSubMitIssue = YES;
        
    }
    if (_canSubMitIssue) {
        [self ClickToHaveALook];
    }
    
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark-----delegate

- (void)FLChooseMapViewController:(FLChooseMapViewController *)chooseMapvc didInputReturnLocation:(NSString *)chooseLocation title:(NSString *)title subtitle:(NSString *)subtitle
{
    NSString* str  = [NSString stringWithFormat:@"%@   %@",title,subtitle];
    self.flissueInfoModel.flactivityAdress = str;
    FL_Log(@"addressssssssss111 = %@    == %@ ==== %@",chooseLocation,title,subtitle);
    
    [self.tableView reloadData];
}

- (void)FLChooseMapViewController:(FLChooseMapViewController *)chooseMapvc didInputReturnLocation:(NSString *)chooseLocationJ Location:(NSString *)chooseLocationW title:(NSString *)title subtitle:(NSString *)subtitle
{
    NSString* str  = [NSString stringWithFormat:@"%@   %@",title,subtitle];
    self.flissueInfoModel.flactivityAdress = str;
    self.flissueInfoModel.flactivityAdressJD = chooseLocationJ;
    self.flissueInfoModel.flactivityAdressWD = chooseLocationW;
    FL_Log(@"addressssssssss222 = %@    == %@ ==== %@",chooseLocationJ,title,subtitle);
    
    [self.tableView reloadData];
}

#pragma mark ----- pop delegate

- (void)entrueBtnClickWithStr:(NSString *)result
{
    FL_Log(@"确认 新baseinfo=%@",_popView.flInputTextField.text);
    NSUInteger x = [_popView.flInputTextField.text rangeOfString:@"."].location + 1;
    if ( x  == _popView.flInputTextField.text.length) {
        _popView.flInputTextField.text = [_popView.flInputTextField.text substringToIndex:_popView.flInputTextField.text.length - 1];
    }
    switch (popViewTag) {
        case 10:
        {
            if ([FLTool returnBoolWithNumber:_popView.flInputTextField.text]) {
                self.flissueInfoModel.flactivityValueOnMarket = [FLTool getTheCorrectNum:[NSString stringWithFormat:@"%@",_popView.flInputTextField.text]];
            } else if ([_popView.flInputTextField.text isEqualToString:@""]) {
                self.flissueInfoModel.flactivityValueOnMarket = @"";
            } else {
                [[FLAppDelegate share] showHUDWithTitile:@"请输入数字" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            }
        }
            break;
        case 11:
            self.flissueInfoModel.flactivityMaxNumberLimit = _popView.flInputTextField.text;
            break;
        case 12:
            self.flissueInfoModel.flactivityTopicSubjectStr = _popView.flInputTextField.text;
            break;
        case 13:
            self.flissueInfoModel.flactivityTopicIntroduceStr = _popView.flInputTextField.text;
            break;
        case 14:
        {
            BOOL _isCanAdd = YES;
            for (NSString* str in self.flactivitySignUpLimitCell.tagsMuArray) {
                if ([str isEqualToString:_popView.flInputTextField.text]) {
                    [[FLAppDelegate share] showHUDWithTitile:@"标签重复" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                    _isCanAdd = NO;
                    break;
                }
            }
            if (_isCanAdd) {
                [self.flactivitySignUpLimitCell.tagsMuArray addObject: _popView.flInputTextField.text];
                [self.flactivitySignUpLimitCell.tagsBackMuArrNew addObject:_popView.flInputTextField.text];
            }
            [self.flactivitySignUpLimitCell relodTagsMuarray];
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    //    [_popView removeFromSuperview];
}

#pragma mark -----scrllview did scroll

#pragma mark 使用说明的回调
- (void)FLMoreTextPageViewController:(FLMoreTextPageViewController *)flVC message:(NSString *)flmessage
{
    self.flissueInfoModel.flactivityTopicIntroduceStr = flmessage;
    [self.tableView reloadData];
}


#pragma mark ---noti
- (void)showAddTagViewInSquare
{
    _popView = nil;
    _popView = [[FLPopBaseView alloc] initWithTitle:@"添加限制内容" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 8 lengthType:FLLengthTypeLength originalStr: nil];
    [_popView.flInputTextField becomeFirstResponder];
    popViewTag = 14;
    [FL_KEYWINDOW_VIEW_NEW addSubview:_popView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark key/value tools
- (NSArray*)selfToolsReturnKeyArrayWithData:(NSArray*)testArray
{
    
    //    FL_Log(@"test test condition =%@",testArray);
    NSMutableArray* testMuArr = @[].mutableCopy;
    for (NSInteger i = 0; i < testArray.count; i++) {
        NSArray* arr = testArray[i];
        NSString* strKey = arr[0];
        //        NSString* strValue = arr[1];
        //        NSDictionary* testDic = @{strKey:strValue};
        [testMuArr addObject:strKey];
    }
    FL_Log(@"this is final dic test 5= third%@",testMuArr);
    return testMuArr.mutableCopy;
}

- (NSArray*)selfToolsReturnValueArrayWithData:(NSArray*)testArray
{
    
    //    FL_Log(@"test test condition =%@",testArray);
    NSMutableArray* testMuArr = @[].mutableCopy;
    for (NSInteger i = 0; i < testArray.count; i++) {
        NSArray* arr = testArray[i];
        NSString* strKey = arr[1];
        //        NSString* strValue = arr[1];
        //        NSDictionary* testDic = @{strKey:strValue};
        [testMuArr addObject:strKey];
    }
    FL_Log(@"this is final dic test fourth =%@",testMuArr);
    return testMuArr.mutableCopy;
}

- (NSMutableArray*)returnMuArrWithStr:(NSString*)flstr
{
    NSMutableArray* arrMu = @[].mutableCopy;
    NSArray* arr = [flstr componentsSeparatedByString:@","];
    NSArray* valueArr = [self selfToolsReturnValueArrayWithData:_flissueInfoModel.flPartInfoKeyValueArray];
    NSArray* keyArr   = [self selfToolsReturnKeyArrayWithData:_flissueInfoModel.flPartInfoKeyValueArray];
    for (NSInteger i = 0; i < arr.count;  i++) {
        NSString* str = arr[i];
        if (str) {
            NSInteger ff = [keyArr indexOfObject:str];
            if (ff <= valueArr.count) {
                NSString* value = valueArr[ff] ? valueArr[ff] : str;
                [arrMu addObject:value];
            } else {
                [arrMu addObject:str];
            }
        }
    }
    return arrMu;
}
//返回tag模型
- (NSArray*)xjReturnTagListModelWithArr:(NSArray*)testArray {
    //    XJTagListModel
    NSMutableArray* testMuArr = @[].mutableCopy;
    for (NSInteger i = 0; i < testArray.count; i++) {
        NSArray* arr = testArray[i];
        NSString* strKey = arr[0];
        NSString* strValue = arr[1];
        XJTagListModel* model = [[XJTagListModel alloc] init];
        model.xjKey = strKey;
        model.xjValue = strValue;
        [testMuArr addObject:model];
    }
    FL_Log(@"this is final dic test 5= third%@",testMuArr);
    return testMuArr.mutableCopy;
}

- (NSString*)selfToolsReturnPartInfoKeyStrWith:(NSString*)flselectedArr {
    NSString * str = nil;
    return str;
}
#pragma mark xjImageCropperDelegate
//- (void)XJImageCropperViewController:(XJImageCropperViewController *)xjVC passImage:(UIImage *)xjImage {
//    FL_Log(@"this ist the selected iamge= %@",xjImage);
//    //上传到服务器
//    self.flimageInterfaceImage = xjImage;
//    [self insertImageToServiceWithImage:self.flimageInterfaceImage IsInterFaceImage:_flisInterfaceImage];
//}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    FL_Log(@"this ist the selected iamge= %@",croppedImage);
    //上传到服务器
    self.flimageInterfaceImage = croppedImage;
    NSData* iamgeData = UIImageJPEGRepresentation(croppedImage, 1);
    [self insertImageToServiceWithImage:self.flimageInterfaceImage IsInterFaceImage:_flisInterfaceImage];
}

//将用户报名限制转换为key
- (NSArray*)xjReturnFinalKeyToSever {
    NSMutableArray* xjArr = @[].mutableCopy;
    NSArray* xjTestArr = [self xjReturnTagListModelWithArr:_flissueInfoModel.flPartInfoKeyValueArray];
    NSArray* xjNameArr = [self.flactivitySignUpLimitCell xjGetFinalSelectedArr];
    NSArray* xjAllNameArr = [self selfToolsReturnValueArrayWithData:_flissueInfoModel.flPartInfoKeyValueArray];
    for (NSInteger i = 0; i < xjTestArr.count; i++) {
        XJTagListModel* xjModel = xjTestArr[i];
        for (NSInteger j = 0; j < xjNameArr.count; j++) {
            if ([xjModel.xjValue isEqualToString:xjNameArr[j]]) {
                [xjArr addObject:xjModel.xjKey];
            }
        }
    }
    NSString* xjAllNameStr = [xjAllNameArr componentsJoinedByString:@","];
    for (NSString* xjxj in xjNameArr) {
        if ([xjAllNameStr rangeOfString:xjxj].location == NSNotFound) {
            [xjArr addObject:xjxj];
        }
    }
    
    NSLog(@"caocaocao =%@",xjArr);
    return xjArr.mutableCopy;
}

@end






















