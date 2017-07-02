//
//  FLIssueBaseInfoViewController.m
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLIssueBaseInfoViewController.h"
#import "FLBaseInfoCategoryCell.h"
#import "FLIssueChoiceModelViewController.h"
#import "FLTakeConditionTableViewCell.h"
#import "FLTakeRulesTableViewCell.h"
#import "YYKit.h"
#import "ContactSelectionViewController.h"
#import "XJChooseFriendToIssueVC.h"
#import "XJChooseFriendVersionToIssueVC.h"
@interface FLIssueBaseInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate,FLPopBaseViewDelegate,XJChooseFriendVersionToIssueVCDelegate>

/**下一步按钮*/
@property (nonatomic , strong)UIButton* flNextButton;


/**pickerView*/
@property (nonatomic , strong)KTSelectDatePicker *flmyFuckDatetPicker;
@property (nonatomic , strong)ZHPickView* pickview; //delete

@end
static NSInteger popViewTag ,listViewTag; //弹出层10，下拉列表层 40
@implementation FLIssueBaseInfoViewController
{
    
    BOOL _isConditionOn;   //领取条件
    BOOL _isRulesOn;        //领取规则
    BOOL _canGoNextIssue;   //能否下一步
    
    //用来显示的时间格式
    NSString* _fldateForShowBegan; //开始时间
    NSString* _fldateForShowEnd ;// 截止时间
    NSString* _fldateForShowGoOff;//失效时间
    
    //用来相减的时间
    NSDate*  _fldateForCompareBegan; //用来比较的开始时间
    NSDate*  _fldateForCompareEnd;   //用来比较的截止时间
    NSDate*  _fldateForCompareGoOff; //用来比较的失效时间
    
    
    //服务器获取的json
    NSString* _flPartInfoString; //需要填写的领取信息
    NSString* _conditionsCellString; // 领取条件
    NSString* _heigherCellRangeStr; //领取人群
    NSString* _rulesSecCellString; //先到先得。。。
    NSString* _rulesCellString; //领取规则
    
    //领取条件和领取规则  （Cell） 的 key 和value
    NSArray* _arrayConditionsKey;   //领取条件的key
    NSArray* _arrayConditionsValue; //领取条件的value
    NSArray* _arrayRulesKey;   //领取规则的key
    NSArray* _arrayRulesValue; //领取规则的valu
    
    //下拉列表
    NSDictionary* _testDicForRulesList ;     //领取规则下拉的字典(先到先得)
    NSDictionary* _fldicForHeigherCellRange;   //领取高级选项下拉的字典(领取人群)
    
    //选择完毕的key
    NSString* _flStrForHeigherCellRangeSelected;  //选中的领取人群的key
    
    
    NSString* _fltestStrForRulesSelected;     //(助力抢)选完的领取规则的key：先到先得
    
    
    //弹出层
    FLPopBaseView* _popView;
    
}

//@synthesize flissueInfoModel = _flissueInfoModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initInSquareIssueBaseInfoVC];
    [self creatTableViewInBaseInfoView];
    self.flNextButton = [FLSquareTools retutnNextBtnWithTitle:@"下一步"];
    [self.flNextButton addTarget:self action:@selector(giveInfoFirstInBaseIssue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flNextButton];
    
    [self getSomeConditionsAndRules]; //请求接口
    self.flBaseInfoTableView.showsVerticalScrollIndicator = NO;
    [self getUerTypeAndCagteGory];//获取分类，在第四页使用
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [_pickview remove];
}
#pragma mark ---- -  init
- (void)creatTableViewInBaseInfoView
{
    
    self.flBaseInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - 49) style:UITableViewStyleGrouped];
    self.flBaseInfoTableView.delegate = self;
    self.flBaseInfoTableView.dataSource = self;
    [self.view addSubview:self.flBaseInfoTableView];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.flBaseInfoTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
    [self.flBaseInfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.flBaseInfoTableView registerClass:[FLBaseInfoCategoryCell class] forCellReuseIdentifier:@"FLBaseInfoCategoryCell"];
    [self.flBaseInfoTableView registerClass:[FLAvtivityCustomTableViewCell class] forCellReuseIdentifier:@"FLAvtivityCustomTableViewCell"];
    [self.flBaseInfoTableView registerClass:[FLActivityHeighterInfoTableViewCell class] forCellReuseIdentifier:@"FLActivityHeighterInfoTableViewCell"];
    [self.flBaseInfoTableView registerClass:[FLTakeConditionTableViewCell class] forCellReuseIdentifier:@"FLTakeConditionTableViewCell"];
    [self.flBaseInfoTableView registerClass:[FLTakeRulesTableViewCell class] forCellReuseIdentifier:@"FLTakeRulesTableViewCell"];
    
    //    self.flbaseInfoCategoryCell = [[FLBaseInfoCategoryCell alloc] init];
    //    self.flactivityDeailInfoCell = [[FLAvtivityCustomTableViewCell alloc] init];
    //    self.fltakeConditionCell = [[FLTakeConditionTableViewCell alloc] init];
}

- (void)setFlissueInfoModel:(FLIssueInfoModel *)flissueInfoModel {
    _flissueInfoModel = flissueInfoModel;
    _flissueInfoModel.flactivityTimeBegin = nil;
    _flissueInfoModel.flactivityTimeDiedline = nil;
    _flissueInfoModel.flactivityTimeUnderLine = nil;
    FL_Log(@"----s3-----%@,,,",_flissueInfoModel.flactivityPickRulesStr);
    //    _testDicForRulesList
    //    [self.flBaseInfoTableView reloadData];
    [self setUpUIWithModelKey];
    
}

- (void)setUpUIWithModelKey {
    //    _fldateForShowEnd =
    //    [self creatTableViewInBaseInfoView];
}

- (void)initInSquareIssueBaseInfoVC
{
    _isConditionOn= YES; //$$$$$
    _isRulesOn = YES;
    self.flTakeConditionView = [[FLTakeConditionView alloc] init];
    self.flTakeRulesView = [[FLTakeRulesView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

#pragma mark ---- -  Actions
- (void)giveInfoFirstInBaseIssue
{
    self.flissueInfoModel.flactivityPickRulesKey = self.flTakeRulesChoiceStr ? self.flTakeRulesChoiceStr: self.flissueInfoModel.flactivityPickRulesKey;  //领取规则(cell)当没有model时给cell值，当有model时，取model
    self.flissueInfoModel.flactivityPickConditionKey = self.flTakeConditionsChoiceStr ? self.flTakeConditionsChoiceStr: self.flissueInfoModel.flactivityPickConditionKey ;  //领取条件(cell)
    self.flissueInfoModel.flactivityTopicRangeStr = self.flissueInfoModel.flactivityTopicRangeStr ? self.flissueInfoModel.flactivityTopicRangeStr : @"OVERT";
    if ([self.flissueInfoModel.flactivityPickConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
        //是助力抢
        self.flissueInfoModel.flIsHelpParmShow  = YES;
        self.flissueInfoModel.flactivityPickRulesLimitNumberStr  = self.fltakeConditionCell.fltextfieldLimitNumber.text;//最低助力数
        self.flissueInfoModel.flactivityPickRulesKey = @"ONCE";
    }
    else
    {
        self.flissueInfoModel.flIsHelpParmShow  = NO;
    }
    
    if (!self.flissueInfoModel.flactivityPickConditionKey)
    {
        self.flissueInfoModel.flactivityPickConditionKey = FLFLXJSquareIssueNonePick;
    }
    if (!self.flissueInfoModel.flactivityPickRulesKey)
    {
        self.flissueInfoModel.flactivityPickRulesKey = @"UNLIMITED";
    }
    //是否每人每天
    if ([self.flissueInfoModel.flactivityPickRulesKey isEqualToString:FLFLXJSquareIssuePerOneDay]) {
        self.flissueInfoModel.flIsDAYPerTimes = YES;
        if ([self.fltakeRulesCell.flTextFieldHow.text integerValue]) {
            self.flissueInfoModel.flactivityPickRulesHowNumberStr = self.fltakeRulesCell.flTextFieldHow.text;
            _canGoNextIssue = YES;
        }else
        {
            //            [[FLAppDelegate share] showHUDWithTitile:@"请确次数" view:self.self.navigationController.view delay:1 offsetY:0];
            _canGoNextIssue = NO;
            
        }
        
    }
    else
    {
        self.flissueInfoModel.flIsDAYPerTimes = NO;
    }
    //商家类别下选择的类型
    if (FLFLIsPersonalAccountType) {
        self.flissueInfoModel.flissueActivityFromType =  FLFLXJSquarePersonStrKey; //个人状态下 只能是个人发布传给服务器key
    }
    else
    {
        self.flissueInfoModel.flissueActivityFromType =  self.flbaseInfoCategoryCell.flIssueType;
        FL_Log(@"拿到的type为====%@",self.flissueInfoModel.flissueActivityFromType);
    }
    
    [self checkInfoFirstInBaseIssue];
}

- (void)checkInfoFirstInBaseIssue
{
    if (!FLFLIsPersonalAccountType) {
        if (!self.flbaseInfoCategoryCell.flIssueType)
        {
            [[FLAppDelegate share] showHUDWithTitile:@"请确定发布类型" view:self.self.navigationController.view delay:1 offsetY:0];
            _canGoNextIssue = NO;
            return;
        }
    }
    if (!self.flissueInfoModel.flactivityTimeBegin) {
        [[FLAppDelegate share] showHUDWithTitile:@"请确定活动开始时间" view:self.self.navigationController.view delay:1 offsetY:0];
        _canGoNextIssue = NO;
        return;
    }
    else if (!self.flissueInfoModel.flactivityTimeDiedline)
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请确定活动截止时间" view:self.self.navigationController.view delay:1 offsetY:0];
        _canGoNextIssue = NO;
        return;
    }
    else if (!self.flissueInfoModel.flactivityTimeUnderLine)
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请确定活动失效时间" view:self.self.navigationController.view delay:1 offsetY:0];
        _canGoNextIssue = NO;
        return;
    }
    else if (!self.flissueInfoModel.flactivityMaxNumberLimit)
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请确定数量上限" view:self.self.navigationController.view delay:1 offsetY:0];
        _canGoNextIssue = NO;
        return;
    }
    else if ([self.flTakeConditionsChoiceStr isEqualToString:FLFLXJSquareIssueHelpPick])
    {
        if (![self.fltakeConditionCell.fltextfieldLimitNumber.text integerValue] )
        {
            FL_Log(@"sds");
            [[FLAppDelegate share] showHUDWithTitile:@"请确定助力数" view:self.navigationController.view delay:1 offsetY:0];
            _canGoNextIssue = NO;
            return;
        }
        else  if(self.fltakeConditionCell.flRulesBtn.titleLabel.text ==nil)
        {
            [[FLAppDelegate share] showHUDWithTitile:@"请确定助力规则" view:self.navigationController.view delay:1 offsetY:0];
            _canGoNextIssue = NO;
            return;
        }
    }
    
    if ([self.flissueInfoModel.flactivityPickRulesKey isEqualToString:FLFLXJSquareIssuePerOneDay]) {
        self.flissueInfoModel.flIsDAYPerTimes = YES;
        if ([self.fltakeRulesCell.flTextFieldHow.text integerValue]) {
            if ([self.fltakeRulesCell.flTextFieldHow.text integerValue] >= 99) {
                [[FLAppDelegate share] showHUDWithTitile:@"次数不能超过99" view:self.self.navigationController.view delay:1 offsetY:0];
                _canGoNextIssue = NO;
            } else if ([self.fltakeRulesCell.flTextFieldHow.text integerValue] == 0) {
                [[FLAppDelegate share] showHUDWithTitile:@"次数不能等于0" view:self.self.navigationController.view delay:1 offsetY:0];
                _canGoNextIssue = NO;
            } else {
                self.flissueInfoModel.flactivityPickRulesHowNumberStr = self.fltakeRulesCell.flTextFieldHow.text;
                _canGoNextIssue = YES;
            }
        } else {
            [[FLAppDelegate share] showHUDWithTitile:@"请确认次数" view:self.self.navigationController.view delay:1 offsetY:0];
            _canGoNextIssue = NO;
            
        }
        
    }
    else
    {
        self.flissueInfoModel.flIsDAYPerTimes = NO;
        _canGoNextIssue = YES;
    }
    //    if (FLFLXJIssueWithDataOrNot) {
    //        //校验开始时间、截止时间、失效时间
    //        if (![FLTool  returnBoolNumberWithCreatTime:_flissueInfoModel.flactivityTimeBegin]) {
    //            [[FLAppDelegate share] showHUDWithTitile:@"请重新选择时间" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
    //            return;
    //        }
    //    } else {
    //
    //    }
    
    if (_canGoNextIssue) {
        [self goToChoiceModelIssueStep];
    }
    
}
#pragma mark 下一步
- (void)goToChoiceModelIssueStep
{
    //下一步
    FLIssueChoiceModelViewController* choiceModelVC = [[FLIssueChoiceModelViewController alloc] init];
    choiceModelVC.flissueInfoModel = self.flissueInfoModel;
    choiceModelVC.flPartInfoDeliverToThirdVCStr = _flPartInfoString;
    FL_Log(@"领取规则tam d  =%@",self.flTakeConditionsChoiceStr);
    
    [self.navigationController pushViewController:choiceModelVC animated:YES];
}

- (void)changeSwitchActionCondition
{
    _isConditionOn = !_isConditionOn;
    
    [self.flBaseInfoTableView reloadData];
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:1];
    [self.flBaseInfoTableView reloadSections:nd withRowAnimation:UITableViewRowAnimationFade];
}

- (void)changeSwitchActionRules
{
    _isRulesOn = !_isRulesOn;
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:2];
    [self.flBaseInfoTableView reloadSections:nd withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark----- pick rules
- (void)clickToPickRules
{
    [self.fltakeConditionCell.fltextfieldLimitNumber resignFirstResponder];
    switch (listViewTag)
    {
        case 40:
        {
            _testDicForRulesList  = [FLTool returnDictionaryWithJSONString:_rulesSecCellString]; //_flissueInfoModel.flactivityPickRulesStr
            NSArray* arrayyyyy = [_testDicForRulesList allValues];
            FL_Log(@"arryyyy inin一心=%@",arrayyyyy);
            [_pickview remove];
            if (arrayyyyy) {
                _pickview=[[ZHPickView alloc] initPickviewWithArray:arrayyyyy isHaveNavControler:NO];
                _pickview.delegate =self ;
                [_pickview show];
                //                [self.fltakeConditionCell.fltextfieldLimitNumber resignFirstResponder]; // 领取条件cell
            }
        }
            break;
        case 41:
        {
            _fldicForHeigherCellRange  = [FLTool returnDictionaryWithJSONString:_heigherCellRangeStr];
            NSArray* arrayyyyy = [_fldicForHeigherCellRange allValues];
            FL_Log(@"arryyyy inhain=%@",arrayyyyy);
            [_pickview remove];
            if (arrayyyyy) {
                _pickview=[[ZHPickView alloc] initPickviewWithArray:arrayyyyy isHaveNavControler:NO];
                _pickview.delegate =self ;
                [_pickview show];
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    switch (listViewTag) {
        case 40:
        {
            [self.fltakeConditionCell.flRulesBtn setTitle:resultString forState:UIControlStateNormal];
            _fltestStrForRulesSelected = [FLTool returnKeyFromDic:_testDicForRulesList WithValue:resultString];
            self.flissueInfoModel.flactivityPickRulesStr = _fltestStrForRulesSelected;
            FL_Log(@"this is the list selected key ,also to service =%@",_fltestStrForRulesSelected);
            
        }
            break;
        case 41:
        {
            self.flissueInfoModel.flactivityTopicRangeStr = [FLTool returnKeyFromDic:_fldicForHeigherCellRange WithValue:resultString];
            _flStrForHeigherCellRangeSelected = resultString;
            [self.flBaseInfoTableView reloadData];
            FL_Log(@"this is the list selected key2 ,also to service =%@",self.flissueInfoModel.flactivityTopicRangeStr);
            if ([self.flissueInfoModel.flactivityTopicRangeStr isEqualToString:FLFLXJSquareIssueFRIENDPick]) { //如果是朋友，跳到 挑选朋友
                //                XJChooseFriendToIssueVC *selectionController = [[XJChooseFriendToIssueVC alloc] init]; //
                XJChooseFriendVersionToIssueVC *selectionController = [[XJChooseFriendVersionToIssueVC alloc] init];
                selectionController.delegate = self;
//                if (_flissueInfoModel.xjChoiceRangDic) {
//                    selectionController.
//                }
                [self.navigationController pushViewController:selectionController animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }
}





#pragma mark ---- - tableViewDatesource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 6;
    }
    else if (section ==1 )
    {
        return _isConditionOn?1:0;
    }
    else
    {
        return _isRulesOn?1:0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            self.flbaseInfoCategoryCell = [tableView dequeueReusableCellWithIdentifier:@"FLBaseInfoCategoryCell" forIndexPath:indexPath];
            return self.flbaseInfoCategoryCell;
        }
        else if (indexPath.row == 1)
        {
            self.flactivityDeailInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FLAvtivityCustomTableViewCell" forIndexPath:indexPath];
            self.flactivityDeailInfoCell.flAvtivityDisCribeLabel.text = @"活动开始时间";
            
            if (FLFLXJIssueWithDataOrNot && !_fldateForShowBegan)
            {
                //                self.flactivityDeailInfoCell.flAvtivityDiscribeInfoLabel.text = [self returnNeedTimeStrForshow:_flissueInfoModel.flactivityTimeBegin];
                //返回一个可以比较的时间
                //                _fldateForCompareBegan = _fldateForCompareBegan ? _fldateForCompareBegan: [self returnDateToCompare:_flissueInfoModel.flactivityTimeBegin];
            } else {
                self.flactivityDeailInfoCell.flAvtivityDiscribeInfoLabel.text = _fldateForShowBegan;
            }
            return self.flactivityDeailInfoCell;
        }
        else if (indexPath.row == 2)
        {
            self.flactivityDeailInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FLAvtivityCustomTableViewCell" forIndexPath:indexPath];
            self.flactivityDeailInfoCell.flAvtivityDisCribeLabel.text = @"活动截止时间";
            if (FLFLXJIssueWithDataOrNot && !_fldateForShowEnd)
            {
                //                self.flactivityDeailInfoCell.flAvtivityDiscribeInfoLabel.text = [self returnNeedTimeStrForshow:_flissueInfoModel.flactivityTimeDiedline];
                //返回一个可以比较的时间
                //                _fldateForCompareEnd = _fldateForCompareEnd ? _fldateForCompareEnd: [self returnDateToCompare:_flissueInfoModel.flactivityTimeDiedline];
                //                _flissueInfoModel.flactivityTimeDiedline = nil;
            } else
            {
                self.flactivityDeailInfoCell.flAvtivityDiscribeInfoLabel.text = _fldateForShowEnd;
            }
            return self.flactivityDeailInfoCell;
        }
        else if (indexPath.row == 3 )
        {
            self.flactivityDeailHeighterInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FLActivityHeighterInfoTableViewCell" forIndexPath:indexPath];
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text = self.flissueInfoModel.flactivityMaxNumberLimit;
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterLabel.text = @"数量上限";
            return self.flactivityDeailHeighterInfoCell;
        }
        else if (indexPath.row == 4 )
        {
            self.flactivityDeailHeighterInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FLActivityHeighterInfoTableViewCell" forIndexPath:indexPath];
            
            if (FLFLXJIssueWithDataOrNot && !_flStrForHeigherCellRangeSelected)
            {
                self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text =  [FLSquareTools returnRankValueWithKey:_flissueInfoModel.flactivityTopicRangeStr];     //_flissueInfoModel.flactivityTopicRangeStr ; //通过key 找value 字典: _fldicForHeigherCellRange
                NSString* str =  [_fldicForHeigherCellRange valueForKey:_flissueInfoModel.flactivityTopicRangeStr];
                FL_Log(@"ssssttttttrrr %@=%@===%@",_fldicForHeigherCellRange,_flissueInfoModel.flactivityTopicRangeStr,str);
                self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text = _flStrForHeigherCellRangeSelected ?_flStrForHeigherCellRangeSelected :@"公开";
            }
            else
            {
                self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text = _flStrForHeigherCellRangeSelected ?_flStrForHeigherCellRangeSelected :@"公开";
            }
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterLabel.text = @"人群选择";
            return self.flactivityDeailHeighterInfoCell;
        }
        else if (indexPath.row == 5)
        {
            self.flactivityDeailHeighterInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FLActivityHeighterInfoTableViewCell" forIndexPath:indexPath];
            
            self.flactivityDeailHeighterInfoCell.flAvtivityHeighterLabel.text = @"失效时间";
            if (FLFLXJIssueWithDataOrNot && !_fldateForShowGoOff)
            {
                //                self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text = [self returnNeedTimeStrForshow:_flissueInfoModel.flactivityTimeUnderLine];
                //                _flissueInfoModel.flactivityTimeUnderLine = nil;
            } else {
                self.flactivityDeailHeighterInfoCell.flAvtivityHeighterInfoLabel.text = _fldateForShowGoOff;
            }
            return self.flactivityDeailHeighterInfoCell;
        }
        else
        {
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            self.fltakeConditionCell = [tableView dequeueReusableCellWithIdentifier:@"FLTakeConditionTableViewCell" forIndexPath:indexPath];
            self.fltakeConditionCell.takeConditionsString = _conditionsCellString;
            self.fltakeConditionCell.arrayCount = _arrayConditionsKey;
            self.fltakeConditionCell.arrayCountValue = _arrayConditionsValue;
            
            self.fltakeConditionCell.issueVC = self;
            self.fltakeConditionCell.flBackStrKey = _flissueInfoModel.flactivityPickConditionKey;//用于回填的数据key
            self.fltakeConditionCell.flBackHelpNumberStr = _flissueInfoModel.flactivityPickRulesLimitNumberStr; //最低助力数
            self.fltakeConditionCell.flBackHelpRulesStr = _flissueInfoModel.flactivityPickRulesStr;           //助力抢规则
            [self.fltakeConditionCell.flRulesBtn setTitle:_testDicForRulesList[_flissueInfoModel.flactivityPickRulesStr] forState:UIControlStateNormal];              //设置标题
            //            self.fltakeConditionCell.selectedBtn = -1;
            listViewTag = 40 ;
            [self.fltakeConditionCell.flRulesBtn  addTarget:self action:@selector(clickToPickRules) forControlEvents:UIControlEventTouchUpInside];
            self.fltakeConditionCell.pickview.delegate = self;
            return  self.fltakeConditionCell;
        }
        else
        {
            return nil;
        }
    }
    else if (indexPath.section == 2)
    {
        self.fltakeRulesCell = [tableView dequeueReusableCellWithIdentifier:@"FLTakeRulesTableViewCell" forIndexPath:indexPath];
        self.fltakeRulesCell.takeRulesString= _rulesCellString;
        self.fltakeRulesCell.flConditionsKey = _flissueInfoModel.flactivityPickConditionKey ?_flissueInfoModel.flactivityPickConditionKey :self.flTakeConditionsChoiceStr ; //用来助力抢定位每人一次
        
        self.fltakeRulesCell.arrayCount = _arrayRulesKey;
        self.fltakeRulesCell.arrayCountValue = _arrayRulesValue;
        self.fltakeRulesCell.flBackStrKey = _flissueInfoModel.flactivityPickRulesKey;  //用于回填的数据key
        self.fltakeRulesCell.flBackPerNumberStr = _flissueInfoModel.flactivityPickRulesHowNumberStr ? _flissueInfoModel.flactivityPickRulesHowNumberStr :@""; //number(最低助力数)
        
        self.fltakeRulesCell.issueVC = self;
        return  self.fltakeRulesCell;
    }
    else
    {
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        [self.flTakeConditionView.flopenSwitch addTarget:self action:@selector(changeSwitchActionCondition) forControlEvents:UIControlEventValueChanged];
        return self.flTakeConditionView;
    }
    else if (section == 2)
    {
        [self.flTakeRulesView.flopenSwitch addTarget:self action:@selector(changeSwitchActionRules) forControlEvents:UIControlEventValueChanged];
        return self.flTakeRulesView;
    }
    else
    {
        return nil;
    }
}

#pragma mark ---- -  tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            FL_Log(@"点了开始时间");
            self.flmyFuckDatetPicker = [[KTSelectDatePicker alloc] init];
            [self.flmyFuckDatetPicker didFinishSelectedDate:^(NSDate *selectDataTime) {
                //此处需要比较开始时间和截止时间  开始时间和失效时间
                FL_Log(@"selectedate time =%@",selectDataTime);
                _fldateForShowBegan =  [self compareTimeToChoiceBeganTimeWithslectedTime:(NSDate*)selectDataTime];
                _flissueInfoModel.flactivityTimeBegin = [self returnNeedTimeStrForUp:_fldateForShowBegan];
                if (_fldateForShowBegan) {
                    _fldateForCompareBegan = selectDataTime;
                    [self.flBaseInfoTableView reloadData];
                }
                
            }];
        }
        else if (indexPath.row == 2)
        {
            FL_Log(@"点了截止时间");
            if (!_flissueInfoModel.flactivityTimeBegin) {
                [[FLAppDelegate share]showHUDWithTitile:@"请先选择开始时间" view:self.navigationController.view delay:1 offsetY:0];
                return;
            }
            self.flmyFuckDatetPicker = [[KTSelectDatePicker alloc] init];
            [self.flmyFuckDatetPicker didFinishSelectedDate:^(NSDate *selectDataTime) {
                FL_Log(@"selectedate time =%@",selectDataTime);
                _fldateForShowEnd = [self compareTimeToChoiceEndTimeWithSlectedTime:selectDataTime];
                _flissueInfoModel.flactivityTimeDiedline = [self returnNeedTimeStrForUp:_fldateForShowEnd];
                if (_fldateForShowEnd) {
                    _fldateForCompareEnd = selectDataTime;
                    [self.flBaseInfoTableView reloadData];
                }
            }];
        }
        else if (indexPath.row == 3)
        {
            FL_Log(@"点了数量上限");
            _popView = [[FLPopBaseView alloc] initWithTitle:@"数量上限(小于10000)" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 9999 lengthType:FLLengthTypeInteger originalStr:_flissueInfoModel.flactivityMaxNumberLimit ? _flissueInfoModel.flactivityMaxNumberLimit : @""];
            _popView.flInputTextField.keyboardType = UIKeyboardTypeNumberPad;
            [_popView.flInputTextField becomeFirstResponder];
            popViewTag = 11;
            [FL_KEYWINDOW_VIEW_NEW addSubview:_popView];
        }
        else if (indexPath.row == 4)
        {
            FL_Log(@"点了人群选择");
            listViewTag = 41 ;
            [self clickToPickRules];
        }
        else if (indexPath.row == 5)
        {
            FL_Log(@"点了 失效时间");
            if (!_flissueInfoModel.flactivityTimeBegin) {
                [[FLAppDelegate share]showHUDWithTitile:@"请先选择开始时间" view:self.navigationController.view delay:1 offsetY:0];
                return;
            }
            if (!_flissueInfoModel.flactivityTimeDiedline) {
                [[FLAppDelegate share]showHUDWithTitile:@"请先选择截止时间" view:self.navigationController.view delay:1 offsetY:0];
                return;
            }
            self.flmyFuckDatetPicker = [[KTSelectDatePicker alloc] init];
            [self.flmyFuckDatetPicker didFinishSelectedDate:^(NSDate *selectDataTime) {
                FL_Log(@"selectedate time  =%@",selectDataTime);
                _fldateForShowGoOff = [self compareTimeToChoiceGoOffWithSelectedTime:selectDataTime];
                if (_fldateForShowGoOff) {
                    _fldateForCompareGoOff = selectDataTime;
                    [self.flBaseInfoTableView reloadData];
                }
                
            }];
        }
        
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2  )
    {
        return 44;
    }else
    {
        return 5;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1)
    {
        return _isHelpTypeSelected?(( 40 * _arrayConditionsKey.count) + 80):( 40 * _arrayConditionsKey.count);
    }
    else if (indexPath.section == 2)
    {
        return (_arrayRulesKey.count * 40);
    }
    else
    {
        return 44;
    }
}


#pragma mark ----- pop delegate

- (void)entrueBtnClick
{
    FL_Log(@"确认 =%@",_popView.flInputTextField.text);
    switch (popViewTag) {
        case 10:
            self.flissueInfoModel.flactivityValueOnMarket = [NSString stringWithFormat:@"%@",_popView.flInputTextField.text];
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
            //        case 14:
            //            [self.flactivitySignUpLimitCell.tagsMuArray addObject: _popView.flInputTextField.text];
            //            [self.flactivitySignUpLimitCell relodTagsMuarray];
            //            break;
        default:
            break;
    }
    [self.flBaseInfoTableView reloadData];
    [_popView removeFromSuperview];
}


#pragma mark -------- 数据

- (void)getSomeConditionsAndRules
{
    //领取条件
    [FLNetTool getTakeConditionsWithParm:nil success:^(NSDictionary *data) {
        FL_Log(@"get conditions in issue data =%@",data);
        //获取值，传递给cell
        [self getInfoAndPassToNextWithData:data];
        //保存到userdefaults  issueInfoData
        [FLTool setIssueInfoDataWithDic:data];
        [self.flBaseInfoTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getInfoAndPassToNextWithData:(NSDictionary*)data
{
    /*
     //所有标签
     NSDictionary* dic1 = data[FL_NET_DATA_KEY][@"PARTINFO"];
     _flPartInfoString = [FLTool returnDictionaryToJson:dic1];
     //    _flPartInfoString = data[FL_NET_DATA_KEY][@"PARTINFO"];
     _flissueInfoModel.flfuckPartInfoServiceStr = _flPartInfoString ;
     FL_Log(@"dictag in issue part info = %@",_flPartInfoString);
     //条件
     NSDictionary* fuckdicCondition = data[FL_NET_DATA_KEY][@"TOPICCONDITION"];
     _conditionsCellString = [FLTool returnDictionaryToJson:fuckdicCondition];
     //    _conditionsCellString = data[FL_NET_DATA_KEY][@"TOPICCONDITION"];
     FL_Log(@"diconditions  in issue = %@",_conditionsCellString);
     
     //人群
     NSDictionary* dic3 = data[FL_NET_DATA_KEY][@"TOPICRANGE"];
     _heigherCellRangeStr =[FLTool returnDictionaryToJson:dic3];
     //    _heigherCellRangeStr = data[FL_NET_DATA_KEY][@"TOPICRANGE"];
     FL_Log(@"dicrange in issue = %@",_heigherCellRangeStr);
     //领取规则
     NSDictionary* fuckdicRules = data[FL_NET_DATA_KEY][@"TOPICRULE"];
     _rulesCellString = [FLTool returnDictionaryToJson:fuckdicRules];
     //    _rulesCellString = data[FL_NET_DATA_KEY][@"TOPICRULE"];
     FL_Log(@"dic inrule issue = %@",_rulesCellString);
     
     
     //助力规则
     NSDictionary* dic4 = data[FL_NET_DATA_KEY][@"ZHULIRULE"];
     _rulesSecCellString =[FLTool returnDictionaryToJson:dic4];
     //    _rulesSecCellString = data[FL_NET_DATA_KEY][@"ZHULIRULE"];
     FL_Log(@"dictype in ssssssissue = %@",_rulesSecCellString);
     NSArray* kesA = [dic4 allKeys];
     for (NSString* str in kesA) {
     if ([str isEqualToString: _flissueInfoModel.flactivityPickRulesStr]) {
     NSString* title = dic4[str];
     [self.fltakeConditionCell.flRulesBtn setTitle:title forState:UIControlStateNormal];
     [self.flBaseInfoTableView reloadData];
     }
     }
     
     
     NSDictionary* dic5 = data[FL_NET_DATA_KEY][@"TOPICTYPE"];
     FL_Log(@"dictype in issue = %@",dic5);
     
     //领取条件
     _arrayConditionsKey = [[FLTool returnDictionaryWithJSONString:_conditionsCellString] allKeys];
     _arrayConditionsValue =[[FLTool returnDictionaryWithJSONString:_conditionsCellString] allValues];
     
     
     
     //领取规则
     _arrayRulesKey = [[FLTool returnDictionaryWithJSONString:_rulesCellString] allKeys];
     _arrayRulesValue =[[FLTool returnDictionaryWithJSONString:_rulesCellString] allValues];
     
     */
    
    
    //领取条件
    NSArray* testArrwww = data[FL_NET_DATA_KEY][@"TOPICCONDITION"];
    _arrayConditionsKey = [self selfToolsReturnKeyArrayWithData:testArrwww];
    _arrayConditionsValue = [self selfToolsReturnValueArrayWithData:testArrwww];
    //领取规则
    NSArray* testArrrr = data[FL_NET_DATA_KEY][@"TOPICRULE"];
    _arrayRulesKey     = [self selfToolsReturnKeyArrayWithData:testArrrr];
    _arrayRulesValue = [self selfToolsReturnValueArrayWithData:testArrrr];
    
    //领取信息
    NSArray* dic1 = data[FL_NET_DATA_KEY][@"PARTINFO"];
    //    _flPartInfoString = data[FL_NET_DATA_KEY][@"PARTINFO"];
    _flissueInfoModel.flPartInfoKeyValueArray = dic1 ;
    
    //领取人群
    NSArray* arrPerple = data[FL_NET_DATA_KEY][@"TOPICRANGE"];
    _fldicForHeigherCellRange = [self selfToolsReturnDicKeyValueArrayWithData:arrPerple];
    _heigherCellRangeStr =[FLTool returnDictionaryToJson:_fldicForHeigherCellRange];
    
    
    //助力规则
    NSArray* arrRules = data[FL_NET_DATA_KEY][@"ZHULIRULE"];
    _testDicForRulesList = [self selfToolsReturnDicKeyValueArrayWithData:arrRules];
    _rulesSecCellString =[FLTool returnDictionaryToJson:_testDicForRulesList];
    
    
    
    
}

#pragma mark popViewDelegate
- (void)entrueBtnClickWithStr:(NSString *)result
{
    
    self.flissueInfoModel.flactivityMaxNumberLimit = result;
    [self.flBaseInfoTableView reloadData];
}



#pragma mark tools
#pragma mark time tools
- (NSString*)compareTimeToChoiceBeganTimeWithslectedTime:(NSDate*)selectDataTime
{
    __weak typeof(self) weakSelf = self;
    NSString* str = nil;
    NSString* dateStr = [FLTool returnStrWithNSDate: selectDataTime AndDateFormat:@"yyyy-MM-dd HH:mm"];
    dateStr = [NSString stringWithFormat:@"%@",dateStr];
    //    weakSelf.flissueInfoModel.flactivityTimeBegin = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:selectDataTime]];
    if (_fldateForCompareEnd) {
        //开始时间和截止时间
        double timeEnd = [_fldateForCompareEnd timeIntervalSinceReferenceDate];
        double timeSelected = [selectDataTime timeIntervalSinceReferenceDate];
        if (timeEnd - timeSelected  > 60 ) {
            str  = dateStr; //用来显示
        } else if (timeEnd == timeSelected ) {
            
            [[FLAppDelegate share]showHUDWithTitile:@"开始时间不能等于截止时间" view:self.navigationController.view delay:1 offsetY:0];
        }
        else {
            [[FLAppDelegate share]showHUDWithTitile:@"开始时间需要小于截止时间" view:self.navigationController.view delay:1 offsetY:0];
        }
        
    }
    if (_fldateForCompareGoOff) {
        //开始时间和失效时间
        double timeEnd = [_fldateForCompareGoOff timeIntervalSinceReferenceDate];
        double timeSelected = [selectDataTime timeIntervalSinceReferenceDate];
        if (timeEnd - timeSelected  > 60 ) {
            str  = dateStr; //用来显示
        } else if (timeEnd == timeSelected ) {
            [[FLAppDelegate share]showHUDWithTitile:@"开始时间不能等于失效时间" view:self.navigationController.view delay:1 offsetY:0];
        } else {
            [[FLAppDelegate share]showHUDWithTitile:@"开始时间需要小于失效时间" view:self.navigationController.view delay:1 offsetY:0];
        }
    }
    if (!_fldateForCompareEnd && !_fldateForCompareGoOff) {
        str = dateStr;
    }
    
    return str;
}

- (NSString*)compareTimeToChoiceEndTimeWithSlectedTime:(NSDate*)selectDataTime
{
    __weak typeof(self) weakSelf = self;
    NSString* str = nil;
    NSString* dateStr = [FLTool returnStrWithNSDate: selectDataTime AndDateFormat:@"yyyy-MM-dd HH:mm"];
    dateStr = [NSString stringWithFormat:@"%@",dateStr];
    weakSelf.flissueInfoModel.flactivityTimeDiedline = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:selectDataTime]];
    if (_fldateForCompareBegan)
    {
        if (_fldateForCompareGoOff)
        {
            //开始时间和截止时间
            double timeEnd = [_fldateForCompareBegan timeIntervalSinceReferenceDate];
            double timeSelected = [selectDataTime timeIntervalSinceReferenceDate];
            double timeOff = [_fldateForCompareGoOff timeIntervalSinceReferenceDate];
            if (timeEnd - timeSelected  > 60 ) {
                [[FLAppDelegate share]showHUDWithTitile:@"截止时间需要大于开始时间" view:self.navigationController.view delay:1 offsetY:0];
                return nil;
            } else if (timeOff < timeSelected - 60){
                [[FLAppDelegate share]showHUDWithTitile:@"截止时间需要小于失效时间" view:self.navigationController.view delay:1 offsetY:0];
                return nil;
            } else {
                str =dateStr;
            }
        } else {
            //开始时间和截止时间
            double timeEnd = [_fldateForCompareBegan timeIntervalSinceReferenceDate];
            double timeSelected = [selectDataTime timeIntervalSinceReferenceDate];
            FL_Log(@"time ------=%f",timeEnd - timeSelected);
            if ( timeSelected - timeEnd  >60 ) {
                str  = dateStr; //用来显示
            } else if (timeEnd == timeSelected ) {
                [[FLAppDelegate share]showHUDWithTitile:@"截止时间不能等于失效时间" view:self.navigationController.view delay:1 offsetY:0];
                return nil;
            } else {
                [[FLAppDelegate share]showHUDWithTitile:@"截止时间需要大于开始时间" view:self.navigationController.view delay:1 offsetY:0];
                return str;
            }
        }
        
    }
    else
    {
        double timeEnd = [_fldateForCompareGoOff timeIntervalSinceReferenceDate];
        double timeSelected = [selectDataTime timeIntervalSinceReferenceDate];
        FL_Log(@"---------s-=%ff",timeEnd - timeSelected);
        if (timeEnd - timeSelected > 0 ) {
            str  = dateStr; //用来显示
            return str;
        } else if (timeEnd == timeSelected ) {
            [[FLAppDelegate share]showHUDWithTitile:@"截止时间不能等于失效时间" view:self.navigationController.view delay:1 offsetY:0];
            return nil;
        } else {
            [[FLAppDelegate share]showHUDWithTitile:@"截止时间需要小于于失效时间" view:self.navigationController.view delay:1 offsetY:0];
            return nil;
        }
        
    }
    return str;
}

//失效时间
- (NSString*)compareTimeToChoiceGoOffWithSelectedTime:(NSDate*)selectDataTime
{
    __weak typeof(self) weakSelf = self;
    NSString* str = nil;
    NSString* dateStr = [FLTool returnStrWithNSDate: selectDataTime AndDateFormat:@"yyyy-MM-dd HH:mm"];
    dateStr = [NSString stringWithFormat:@"%@",dateStr];
    weakSelf.flissueInfoModel.flactivityTimeUnderLine = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:selectDataTime]];
    double timeBegin = [_fldateForCompareBegan timeIntervalSinceReferenceDate];
    double timeEnd = [_fldateForCompareEnd timeIntervalSinceReferenceDate];
    double timeSelected = [selectDataTime timeIntervalSinceReferenceDate];
    
    if (!_fldateForCompareBegan && !_fldateForCompareEnd)
    {
        str = dateStr;
        return str;
    }
    if (_fldateForCompareEnd)
    {
        if (timeSelected - timeEnd > 60) {
            str = dateStr;
            return str;
        }else if (timeEnd == timeSelected ) {
            [[FLAppDelegate share]showHUDWithTitile:@"截止时间不能等于失效时间" view:self.navigationController.view delay:1 offsetY:0];
            return nil;
        } else {
            [[FLAppDelegate share]showHUDWithTitile:@"失效时间需要大于截止时间" view:self.navigationController.view delay:1 offsetY:0];
            return nil;
        }
    }
    if (!_fldateForCompareEnd && _fldateForShowBegan) {
        if (timeSelected - timeBegin > 60) {
            str = dateStr;
            return str;
        } else {
            [[FLAppDelegate share]showHUDWithTitile:@"失效时间需要大于开始时间" view:self.navigationController.view delay:1 offsetY:0];
            return nil;
        }
    }
    
    return str;
}



//转变时间格式
//上传到服务器的格式
- (NSString*)returnNeedTimeStrForUp:(NSString*)flshowTimeStr
{
    NSString* str = nil;
    str = [NSString stringWithFormat:@"%@:00",flshowTimeStr];
    return str;
}
//转变时间格式
//显示的格式
- (NSString*)returnNeedTimeStrForshow:(NSString*)flSeverTimeStr
{
    
    //2016-02-20 15:18:00
    if (flSeverTimeStr.length > 16) {
        flSeverTimeStr = [flSeverTimeStr substringToIndex:16];
    } else {
        FL_Log(@"this is time for test =%@",flSeverTimeStr);
    }
    
    
    return flSeverTimeStr;
}

#pragma mark key/value tools
- (NSArray*)selfToolsReturnKeyArrayWithData:(NSArray*)testArray
{
    
    FL_Log(@"test test condition =%@",testArray);
    
    NSMutableArray* testMuArr = @[].mutableCopy;
    for (NSInteger i = 0; i < testArray.count; i++) {
        NSArray* arr = testArray[i];
        NSString* strKey = arr[0];
        //        NSString* strValue = arr[1];
        //        NSDictionary* testDic = @{strKey:strValue};
        [testMuArr addObject:strKey];
    }
    FL_Log(@"this is final dic test1 =%@",testMuArr);
    return testMuArr.mutableCopy;
}

- (NSArray*)selfToolsReturnValueArrayWithData:(NSArray*)testArray
{
    
    FL_Log(@"test test condition =%@",testArray);
    
    NSMutableArray* testMuArr = @[].mutableCopy;
    for (NSInteger i = 0; i < testArray.count; i++) {
        NSArray* arr = testArray[i];
        NSString* strKey = arr[1];
        //        NSString* strValue = arr[1];
        //        NSDictionary* testDic = @{strKey:strValue};
        [testMuArr addObject:strKey];
    }
    FL_Log(@"this is final dic test2 =%@",testMuArr);
    return testMuArr.mutableCopy;
}
//字典数组
- (NSArray*)selfToolsReturnKeyValueArrayWithData:(NSArray*)testArray
{
    
    FL_Log(@"test test condition =%@",testArray);
    
    NSMutableArray* testMuArr = @[].mutableCopy;
    for (NSInteger i = 0; i < testArray.count; i++) {
        NSArray* arr = testArray[i];
        NSString* strKey = arr[0];
        NSString* strValue = arr[1];
        NSDictionary* testDic = @{strKey:strValue};
        [testMuArr addObject:testDic];
    }
    FL_Log(@"this is final dic test 3=%@",testMuArr);
    return testMuArr.mutableCopy;
}
//字典数组(字典)
- (NSDictionary*)selfToolsReturnDicKeyValueArrayWithData:(NSArray*)testArray
{
    NSMutableDictionary* testMuDic = @{}.mutableCopy;
    for (NSInteger i = 0; i < testArray.count; i++) {
        NSArray* arr = testArray[i];
        NSString* strKey = arr[0];
        NSString* strValue = arr[1];
        [testMuDic setValue:strValue forKey:strKey];
        
    }
    FL_Log(@"this is final dic test 4=%@",testMuDic);
    return testMuDic.mutableCopy;
}

- (NSDate*)returnDateToCompare:(NSString*)flstr
{
    
    //2016-02-20 15:18:00
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:flstr];
    return date;
}

#pragma mark 第四页使用的标签
- (void)getUerTypeAndCagteGory
{
    NSString* xjStrToken = FL_ALL_SESSIONID;
    NSString* xjStrUserId = FL_USERDEFAULTS_USERID_NEW;
    NSString* xjStrUserType = XJ_USERTYPE_WITHTYPE;
    if (!xjStrToken || !xjStrUserId || !xjStrUserType) {
        return;
    }
    
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"userId":FL_USERDEFAULTS_USERID_NEW,
                           @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey};
    [FLNetTool flPubTopicListBackByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my test for biaoqian to publish=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self getPageFourBQWithDic:data[FL_NET_DATA_KEY]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getPageFourBQWithDic:(NSDictionary*)data {
    NSMutableArray* arrayMu = @[].mutableCopy;
    NSMutableArray* arrayId = @[].mutableCopy;
    NSMutableArray* arrayUserId = @[].mutableCopy;
    NSMutableArray* canNor = @[].mutableCopy;
    for (NSDictionary* keyDic in data) {
        [arrayMu addObject:keyDic[@"tagName"]];
        [arrayId addObject:keyDic[@"id"]];
        [arrayUserId addObject:keyDic[@"userId"]];
        NSInteger xj = [keyDic[@"authType"] integerValue];
        if (xj==1) {
            [canNor addObject:keyDic[@"tagName"]];
        }
    }
    FL_Log(@"this is my test arrmu in issue baseinfo==%@",arrayMu);
    _flissueInfoModel.flLastPageBQArray = arrayMu.mutableCopy;
    _flissueInfoModel.flLastPageBQTagIdArray = arrayId.mutableCopy;
    _flissueInfoModel.flLastPageBQTagUserIdArray = arrayUserId.mutableCopy;  //flLastPageBQTagCanNotDeleteArray
    _flissueInfoModel.flLastPageBQTagCanNotDeleteArray = canNor.mutableCopy;
    
}

#pragma mark ---------- ------ [选完好友的代理]
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources {
    
    if (([selectedSources count]) ==0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请最少选择一个好友" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *sourcef = [NSMutableArray array];
        NSMutableArray *sourceg = [NSMutableArray array];
        for (CYUserModel *buddy in selectedSources) {
            if ( buddy.xjUserType == CYUserModelUserTypeGroup) {
                [sourceg addObject:[NSString stringWithFormat:@"groupID\"%@\"",buddy.userId]];
            } else if(buddy.xjUserType == CYUserModelUserTypePerson){
                FL_Log(@"dsada%@",buddy.userId);
                [sourcef addObject:[NSString stringWithFormat:@"%@",buddy.userId?buddy.userId:@""]];
            }
            
        }
        FL_Log(@"this is the result of my choince for issue=[%@],,,,[%@]",sourcef,sourceg);
        NSArray* xjA = [sourcef arrayByAddingObjectsFromArray:sourceg.mutableCopy];
        NSString* sOs = [xjA componentsJoinedByString:@","];
        self.flissueInfoModel.xjChoiceRangStr = sOs;
        
    });
    return YES;
}




@end











