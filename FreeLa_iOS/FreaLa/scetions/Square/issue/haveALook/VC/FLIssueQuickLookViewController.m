//
//  FLIssueQuickLookViewController.m
//  FreeLa
//
//  Created by Leon on 15/12/24.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLIssueQuickLookViewController.h"

@interface FLIssueQuickLookViewController ()<JFTagListDelegate,FLPopBaseViewDelegate>
{
    NSString* flIssueType;  //state 0 :保存 , 1：发布, 2:修改/再发
}
@property (strong, nonatomic) JFTagListView    *tagList;     //自定义标签Viwe

@property (assign, nonatomic) XjTagStateType     tagStateType; //标签的模式状态（显示、选择、编辑）
/**弹出层*/
@property (nonatomic , strong) FLPopBaseView* popView;
@end

@implementation FLIssueQuickLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPageInQuickLook];
    self.fltagText.userInteractionEnabled = NO;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  ------- model
- (void)setFlissueInfoModel:(FLIssueInfoModel *)flissueInfoModel
{
    _flissueInfoModel = flissueInfoModel;
    
}

#pragma mark ------UI
- (void)initPageInQuickLook
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title  = @"发布";
    [self.flthumbnailImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flissueInfoModel.flactivitytopicThumbnailStr isSite:NO]]]];
    self.flchangeTitleText.text = _flissueInfoModel.flactivityTopicSubjectStr;
    self.fltagText.text = _flissueInfoModel.flactivitytopicCategoryStr;
    //右上角
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickMakeSureToSaveTopic)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //tagView
    self.tagStateType = XjTagStateTypeChoiceOne;//选择模式
    CGRect frame = self.flTagBaseViewNew.frame;
    frame.origin.y = 10;
    frame.size.width = FLUISCREENBOUNDS.width;
    frame.size.height =  150;
    //TagView
    self.tagList = [[JFTagListView alloc] initWithFrame:frame];
    self.tagList.is_can_addTag = YES;
    self.tagList.delegate = self;
    
    [self.flTagBaseViewNew addSubview:self.tagList];
    //    self.tagList.tagBackgroundColor = [UIColor blueColor];
    //    self.tagList.tagTextColor = [UIColor whiteColor];
    //以下属性是可选的
    self.tagList.is_can_addTag = YES;    //如果是要有最后一个按钮是添加按钮的情况，那么为Yes
    self.tagList.tagCornerRadius = 12;  //标签圆角的大小，默认10
    self.tagList.tagStateType = self.tagStateType;  //标签模式，默认显示模式
    self.tagList.xjCanNotDeleteArr = _flissueInfoModel.flLastPageBQTagCanNotDeleteArray.mutableCopy;
    [self relodTagsMuarrayWithArr:_flissueInfoModel.flLastPageBQArray.mutableCopy];
    
}

- (void)clickMakeSureToSaveTopic {
    flIssueType = @"0";
    if (_flissueInfoModel.flactivitytopicCategoryStr){
        [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.view];
    }
    [self testForSubMit];
}

- (IBAction)clickToSubMit:(id)sender {
    flIssueType = @"1";
    if (_flissueInfoModel.flactivitytopicCategoryStr){
        [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.view];
    }
    [self testForSubMit];
}

- (void)submitInFinalVC
{
    
}

- (BOOL)isCanSubMiteInfoInIssueVC
{
    BOOL isYes ;
    if (!_flissueInfoModel.flactivitytopicCategoryStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FLAppDelegate share] hideHUD];
        });
        [[FLAppDelegate share] showHUDWithTitile:@"请选择一个分类" view:self.view delay:5 offsetY:0];
        isYes = NO;
        return isYes;
    }
    //新主题
    _flissueInfoModel.flactivityTopicSubjectStr = self.flchangeTitleText.text;
    FL_Log(@"缺哪个。。。。\n 1=%@  \n 2=%@ \n 3=%@ ,\n 4=%@ , \n 5=%@ ,\n 6=%@ ,\n 7=%@, \n 8=%@  ,\n9=%@ ",
           _flissueInfoModel.flactivitytopicCategoryStr ,
           self.flissueInfoModel.flactivitytopicThumbnailFileName ,
           self.flissueInfoModel.flactivitytopicDetailchartFileName,
           self.flissueInfoModel.flactivityTopicSubjectStr ,
           self.flissueInfoModel.flactivityTimeDiedline,
           self.flissueInfoModel.flactivityMaxNumberLimit,
           self.flissueInfoModel.flactivityTopicRangeStr,
           self.flissueInfoModel.flactivityPickConditionKey,
           self.flissueInfoModel.flactivityPickRulesKey);
    //分类
    //    _flissueInfoModel.flactivitytopicCategoryStr = self.fltagText.text;
    if (_flissueInfoModel.flissueActivityFromType && FL_USERDEFAULTS_USERID_NEW && _flissueInfoModel.flactivitytopicCategoryStr && self.flissueInfoModel.flactivitytopicThumbnailFileName && self.flissueInfoModel.flactivitytopicDetailchartFileName && self.flissueInfoModel.flactivityTopicSubjectStr && self.flissueInfoModel.flactivityTimeDiedline  && self.flissueInfoModel.flactivityMaxNumberLimit && self.flissueInfoModel.flactivityTopicRangeStr && self.flissueInfoModel.flactivityPickConditionKey && self.flissueInfoModel.flactivityPickRulesKey) {
        isYes = YES;
    } else {
        isYes = NO;
    }
    return isYes;
}

#pragma  mark 提交数据
- (void)testForSubMit
{
    if (![self isCanSubMiteInfoInIssueVC]) {
        return;
    }
    
    NSDictionary* dic = @{@"state": flIssueType,
                          @"topicType":_flissueInfoModel.flissueActivityFromType,
                          @"userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                          @"creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                          @"userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                          @"topicTag":_flissueInfoModel.flactivitytopicCategoryStr,
                          FLFLXJIssueInfoStartTimeKey:self.flissueInfoModel.flactivityTimeBegin, //开始时间 starttime
                          @"thumbnail":self.flissueInfoModel.flactivitytopicThumbnailFileName?self.flissueInfoModel.flactivitytopicThumbnailFileName:@"",
                          @"detailchart":self.flissueInfoModel.flactivitytopicDetailchartFileName?self.flissueInfoModel.flactivitytopicDetailchartFileName:@"",
                          @"topicTheme":self.flissueInfoModel.flactivityTopicSubjectStr ? self.flissueInfoModel.flactivityTopicSubjectStr:@"",
                          @"details":self.flissueInfoModel.flactivitytopicDetailStr?self.flissueInfoModel.flactivitytopicDetailStr:@"",
                          @"endTime":self.flissueInfoModel.flactivityTimeDiedline ? self.flissueInfoModel.flactivityTimeDiedline:@"", //截止时间
                          @"invalidTime":self.flissueInfoModel.flactivityTimeUnderLine ? self.flissueInfoModel.flactivityTimeUnderLine:@"",//self.flissueInfoModel.flactivityTimeDiedline, //失效时间
                          @"topicPrice":[NSNumber numberWithDouble:[self.flissueInfoModel.flactivityValueOnMarket doubleValue]],
                          @"topicNum":self.flissueInfoModel.flactivityMaxNumberLimit ? self.flissueInfoModel.flactivityMaxNumberLimit:@"",
                          @"topicRange":self.flissueInfoModel.flactivityTopicRangeStr ?self.flissueInfoModel.flactivityTopicRangeStr:@"",
                          @"partInfo":self.flissueInfoModel.flactivitytopicLimitTags?self.flissueInfoModel.flactivitytopicLimitTags:@"",   //使用者提交的信息
                          @"topicExplain":self.flissueInfoModel.flactivityTopicIntroduceStr?self.flissueInfoModel.flactivityTopicIntroduceStr:@"",
                          @"topicCondition":self.flissueInfoModel.flactivityPickConditionKey,
                          @"lowestNum": self.flissueInfoModel.flIsHelpParmShow?@([self.flissueInfoModel.flactivityPickRulesLimitNumberStr integerValue]):@"",
                          @"rule":self.flissueInfoModel.flactivityPickRulesKey,
                          @"ruleTimes":self.flissueInfoModel.flIsDAYPerTimes? @([self.flissueInfoModel.flactivityPickRulesHowNumberStr integerValue]):@"",
                          @"zlqRule": self.flissueInfoModel.flIsHelpParmShow ? self.flissueInfoModel.flactivityPickRulesStr:@"",
                          @"longitude":self.flissueInfoModel.flactivityAdressJD?self.flissueInfoModel.flactivityAdressJD:@"",
                          @"latitude":self.flissueInfoModel.flactivityAdressWD?self.flissueInfoModel.flactivityAdressWD:@"",
                          @"address":self.flissueInfoModel.flactivityAdress?self.flissueInfoModel.flactivityAdress:@"",
                          @"ranges" : self.flissueInfoModel.xjChoiceRangStr?self.flissueInfoModel.xjChoiceRangStr:@"",
                          @"hideGift":@"2"
                          };
    NSMutableArray* xjMuDic = dic.mutableCopy;
    if (self.flissueInfoModel.xjTopicId) {
        [xjMuDic setValue:[NSString stringWithFormat:@"%ld",self.flissueInfoModel.xjTopicId] forKey:@"topicId"];
        if (self.flissueInfoModel.xjIssueState==0) {
            [xjMuDic setValue:@"0" forKey:@"operType"];
        } else{
            [xjMuDic setValue:@"1" forKey:@"operType"];
        }
    }
    NSString* str = [FLTool returnDictionaryToJson:xjMuDic.mutableCopy];
    NSDictionary* parm = @{@"topicPara":str,
                           @"token":FLFLIsPersonalAccountType ? FL_ALL_SESSIONID : FLFLBusSesssionID};
    [FLNetTool issueANewActivityWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in issue =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:self.navigationController.view delay:1 offsetY:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] setUpTabBar];
                [[FLAppDelegate share] hideHUD];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] hideHUD];
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]] view:self.navigationController.view delay:1 offsetY:0];
            });
           
           
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"tamdde=%@",error.description);
        [[FLAppDelegate share] hideHUD];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark ----------- tag
- (void)relodTagsMuarrayWithArr:(NSMutableArray*)array
{
    if (_flissueInfoModel.flactivitytopicCategoryStr) {
        [self.tagList reloadData:array andTime:0 flselectedArr:@[_flissueInfoModel.flactivitytopicCategoryStr].mutableCopy];
    } else {
        [self.tagList reloadData:array andTime:0 flselectedArr:nil];
    }
    
}
//标签选择完毕后的数组
- (void)tagList:(JFTagListView *)tagList choiceDoneWithArray:(NSArray *)flArray addObj:(NSArray*)flObjArr
{
    NSMutableArray* arr = @[].mutableCopy;
    
    
    FL_Log(@"this is my final part info =%@",arr);
    
}

- (void)showAddTagView
{
    if (self.tagList.tagArr.count >= 12) {
        [[FLAppDelegate share] showHUDWithTitile:@"最多为11个" view:self.navigationController.view delay:1 offsetY:0];
        return;
    }
    FL_Log(@"this is the action to add tag view in quick look");
    _popView = [[FLPopBaseView alloc] initWithTitle:@"请填写分类内容" delegate:self andCancleBtnTitle:@"取消" andEnsureBtnTitle:@"确定" textFieldLength: 4 lengthType:FLLengthTypeLength originalStr:nil] ;
    [_popView.flInputTextField becomeFirstResponder];
    _popView.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    //    _popView.isTextField = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_popView];
        
        //    flReJudgegetInfoInHTML
    });
    
}

- (void)entrueBtnClickWithStr:(NSString *)result
{
    BOOL _isCanAdd = YES;
    NSMutableArray* arrMu = _flissueInfoModel.flLastPageBQArray.mutableCopy;
    for (NSString* str in _flissueInfoModel.flLastPageBQArray) {
        if ([str isEqualToString:result]) {
            [[FLAppDelegate share] showHUDWithTitile:@"填写信息重复" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            _isCanAdd = NO;
        }
    }
    if (![FLTool returnBQBoolWithStr:result]) {
        _isCanAdd = NO;
    }
    
    if (_isCanAdd) {
        [arrMu addObject:result];
        //添加标签
        [self addTagWithResult:result];
    }
    FL_Log(@"this is the result to add tag view in quick look=%@",arrMu);
    
    _flissueInfoModel.flactivitytopicCategoryStr = arrMu.lastObject;
    
    self.fltagText.text = arrMu.lastObject;
    _flissueInfoModel.flLastPageBQArray = arrMu.mutableCopy;
    NSMutableArray* arrSelected = @[arrMu.lastObject].mutableCopy ;
    [self.tagList reloadData:arrMu andTime:0 flselectedArr:arrSelected];
    
}
//标签的点击事件
-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex WithType:(NSInteger)fltype {
    FL_Log(@"tagindex in quick look =%ld",buttonIndex);
    //    type   1为选择  2为删除
    if (fltype == 1) {
        [self changeTagColor:buttonIndex];
        FL_Log(@"this is my test value for biaoqian =%@",_flissueInfoModel.flLastPageBQArray[buttonIndex]);
        self.fltagText.text = _flissueInfoModel.flLastPageBQArray[buttonIndex];
        _flissueInfoModel.flactivitytopicCategoryStr = _flissueInfoModel.flLastPageBQArray[buttonIndex];
    } else if (fltype == 2) {
        NSMutableArray* arr = _flissueInfoModel.flLastPageBQArray.mutableCopy;
        [self removeTagWithResult:arr[buttonIndex]];
        [arr removeObjectAtIndex:buttonIndex];
        _flissueInfoModel.flLastPageBQArray = arr.mutableCopy;
        [self.tagList reloadData:_flissueInfoModel.flLastPageBQArray.mutableCopy andTime:0 flselectedArr:nil];
        self.tagList.tagStateType = XjTagStateTypeChoiceOne;
    }
    
}

- (void)changeTagColor:(NSInteger)buttonIndex {
    FL_Log(@"tagindex in quick lookai =%ld",buttonIndex);
}

#pragma mark  -----网络请求
- (void)addTagWithResult:(NSString*)result {
    NSDictionary* parmDic = @{@"userId":FL_USERDEFAULTS_USERID_NEW,
                              @"creator":FLFLIsPersonalAccountType ?FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                              @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                              @"tagName":result};
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,@"topicTag":[FLTool returnDictionaryToJson:parmDic]};
    [FLNetTool flPubTopicListAddTagByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result to add tag in quick vc=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSMutableArray* arr = _flissueInfoModel.flLastPageBQTagIdArray.mutableCopy;
            NSString* str = data[FL_NET_DATA_KEY][@"id"];
            [arr addObject:str];
            _flissueInfoModel.flLastPageBQTagIdArray = arr.mutableCopy;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)removeTagWithResult:(NSString*)result {
    NSString* str = nil;
    for (NSInteger i = 0; i < _flissueInfoModel.flLastPageBQArray.count; i++) {
        if ([_flissueInfoModel.flLastPageBQArray[i] isEqualToString:result]) {
            if (i <= _flissueInfoModel.flLastPageBQTagIdArray.count) {
                str = _flissueInfoModel.flLastPageBQTagIdArray[i];
            } else {
                str =_flissueInfoModel.flLastPageBQArray[i];
            }
        }
    }
    
    NSDictionary* parm =  @{@"token":FL_ALL_SESSIONID,
                            @"userId":FL_USERDEFAULTS_USERID_NEW,
                            @"tag.id":str,
                            @"userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                            };
    [FLNetTool flPubTopicListRemoveTagByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result to remove tag in quick vc=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSMutableArray* arr = _flissueInfoModel.flLastPageBQTagIdArray.mutableCopy;
            [arr removeObject:str];
            _flissueInfoModel.flLastPageBQTagIdArray = arr.mutableCopy;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjChangeTopicStateWithDic:(NSDictionary*)xjDic {
    [FLNetTool flLeftTopicBackByParm:xjDic success:^(NSDictionary *dic) {
        FL_Log(@"this is the update topicState =%@",dic);
    } failure:^(NSError *error) {
        
    }];
    
}

@end





