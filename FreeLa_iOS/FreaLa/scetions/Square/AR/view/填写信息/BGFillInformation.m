//
//  BGFillInformation.m
//  FreeLa
//
//  Created by MBP on 17/7/7.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "BGFillInformation.h"
#import "BGFillInformationTableViewCell.h"

@interface BGFillInformation ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView*backgroundView;
@property(nonatomic,strong)UIImageView*backImageV;
@property(nonatomic,strong)UITableView*myTableView;
@property(nonatomic,strong)UIButton*tijiaoBtn;
@property(nonatomic,strong)NSArray*dataArr;
@property(nonatomic,strong)UIImageView*headerImageV;
//@property(nonatomic,strong)UIView*toolBar;

@end
@implementation BGFillInformation
-(instancetype)init{
    if (self=[super init]) {
        [self createView];
        [self setKeyboard];

    }
    return self;
}
-(instancetype)initWithPartInfoStr:(NSString *)partInfoStr{
    if (self=[super init]){
        _partInfostr=partInfoStr;
        [self createView];
        [self setKeyboard];
//        [self toolBar];
        
    }
    return self;
}
#pragma mark 键盘通知
- (void)setKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)kbWillShow:(NSNotification *)noti
{
    NSLog(@"%@", noti);
    //获取键盘移动后的最高Y值
    CGFloat kbY = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
//    [self firstResp].inputAccessoryView=self.toolBar;
//    UIView *firstTF = [self firstResp];
    UIView *firstTF = self.myTableView;

    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[firstTF convertRect: firstTF.bounds toView:window];
    
    CGFloat maxTextfieldY = CGRectGetMaxY(rect) + self.frame.origin.y;
    
    //计算高度差
    CGFloat delta = kbY - maxTextfieldY;
    
    if (delta < 0) {
        [UIView animateWithDuration:0.25f animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, delta);
        }];
    }
}
//-(UIView*)toolBar{
//    if (!_toolBar) {
//        UIView*toolBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
//        toolBarView.backgroundColor=[UIColor colorWithHexString:@"#ECECEC"];
//        toolBarView.layer.borderColor=[UIColor colorWithHexString:@"DCDCDC"].CGColor;
//        toolBarView.layer.borderWidth=1;
//        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.titleLabel.font=[UIFont systemFontOfSize:14];
//        [btn addTarget:self action:@selector(tijiaoAction) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [btn setTitle:@"提交" forState:UIControlStateNormal];
//        [toolBarView addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(toolBarView.mas_right).offset(-25);
//            make.centerY.equalTo(toolBarView);
//            make.size.mas_equalTo(CGSizeMake(50, 45));
//        }];
//        _toolBar=toolBarView;
//        
//    }
//    return _toolBar;
//    
//}

- (void)kbWillHide:(NSNotification *)noti
{
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark 获取第一响应者
- (UITextField *)firstResp{
    for (BGFillInformationTableViewCell*cell in [self.cellDic allValues]) {
        if ([cell.valueFiled isFirstResponder]) {
            return cell.valueFiled;
        }
    }
    return [UITextField new];

}

-(void)setPartInfostr:(NSString *)partInfostr{
    _partInfostr=partInfostr;
    _dataArr=[partInfostr componentsSeparatedByString:@","];
    [self.myTableView reloadData];
}
-(NSMutableDictionary *)cellDic{
    if (!_cellDic) {
        _cellDic=@{}.mutableCopy;
    }
    return _cellDic;
}
-(NSArray*)dataArr{
    if (!_dataArr) {
        if (self.partInfostr) {
            _dataArr=[self.partInfostr componentsSeparatedByString:@","];

        }else{
            _dataArr=@[];
        }

            
    }
    return _dataArr;
}
-(void)createView{
    self.frame=[UIScreen mainScreen].bounds;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popDown)];
    tap.numberOfTapsRequired=1;
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];
    self.backgroundView=({
        UIView*backview=[[UIView alloc]init];
        backview.frame=CGRectMake(0, 0, 255, 460);
        backview.centerX=self.centerX;
        backview.cy_y=self.cy_bottom;
        [self addSubview:backview];
        backview;
    });
    self.backImageV=({
        UIImageView*imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 85, 255, 370)];
        imageV.image=[UIImage imageNamed:@"tianxinxi_beijingtu"];
        imageV.userInteractionEnabled=YES;
        [self.backgroundView addSubview:imageV];
        imageV;
    });
    UITapGestureRecognizer* tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjxjtesttagtag)];
    [self.backImageV addGestureRecognizer:tapg];

    UIImageView*shengImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diaosheng"]];
    [self.backgroundView addSubview:shengImageV];
    [shengImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 49));
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(self.backImageV.mas_top).offset(15);
    }];
    self.headerImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.backgroundColor=[UIColor redColor];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=25;
        imageV.layer.borderColor=[UIColor colorWithRed:255/255.0 green:60/255.0 blue:66/255.0 alpha:1].CGColor;
        imageV.layer.borderWidth=3;
        imageV;
    });
    [self.backgroundView addSubview:self.headerImageV];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.equalTo(shengImageV);
        make.top.mas_equalTo(0);
    }];
    UILabel*titleLabel=[[UILabel alloc]init];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.text=@"填写相关信息";
    [self.backImageV addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageV);
        make.top.equalTo(@20);
    }];
    self.myTableView=({
        UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, 255, 240) style:UITableViewStylePlain ];
//        [tableView registerClass:BGFillInformationTableViewCell.self forCellReuseIdentifier:@"BGFillInformationTableViewCellIdentifier"];
        tableView.dataSource=self;
        tableView.delegate=self;
        tableView.backgroundColor=[UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;

        tableView;
    });
    UITapGestureRecognizer* tapgg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjxjtesttagtag)];
    [self.myTableView addGestureRecognizer:tapgg];

    [self.backImageV addSubview:self.myTableView];
    UILabel*label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:10];
    label.textColor=[UIColor whiteColor];
    label.text=@"发布者需要您填写相关信息,完善后可进入下一步";
    [self.backImageV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-7);
        make.centerX.equalTo(self.backImageV);
    }];
    
    self.tijiaoBtn=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.backgroundColor=[UIColor colorWithRed:255/255.0 green:60/255.0 blue:66/255.0 alpha:1];
        [btn addTarget:self action:@selector(tijiaoAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius=5;
        btn.layer.masksToBounds=YES;
        btn;
    });
    [self.backImageV addSubview:self.tijiaoBtn];
    [self.tijiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(135, 30));
        make.centerX.mas_equalTo(self.backImageV);
        make.bottom.mas_equalTo(label.mas_top).offset(-10);
    }];
    

}
-(void)xjxjtesttagtag{
    for (BGFillInformationTableViewCell*cell in [self.cellDic allValues]) {
        [cell.valueFiled resignFirstResponder];
        [self endEditing:YES];

}

}
-(void)setHearderImageStr:(NSString *)hearderImageStr{
    _hearderImageStr=hearderImageStr;
    [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:hearderImageStr]];
}
-(void)tijiaoAction{
    if(![self nengtijiao]){
        [[FLAppDelegate share] showHUDWithTitile:@"信息填写不全,请继续填写" view:self delay:1 offsetY:0];

    }else{
        NSMutableDictionary*dic=@{}.mutableCopy;
        for (BGFillInformationTableViewCell*cell in [self.cellDic allValues]) {
            dic[cell.keyStr]=cell.valueFiled.text;
        }
        [self setInfoAndSaveTopic:dic];
    }
}
-(BOOL)nengtijiao{
    for (BGFillInformationTableViewCell*cell in [self.cellDic allValues]) {
        if (cell.valueFiled.text.length==0) {
            return NO;
        }
    }
    return YES;
}
- (void)setInfoAndSaveTopic:(id)xjDic {
    FL_Log(@"this is my dicccc=%@",xjDic);
    NSString* str = [FLTool returnDictionaryToJson:xjDic];
    NSDictionary* parm = @{@"participateDetailes.topicId":_xj_topicId ? _xj_topicId :@"",
                           @"participateDetailes.userId":FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID,
                           @"participateDetailes.userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"participateDetailes.creator":FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID,//FLFLIsPersonalAccountType ?_flsquareAllFreeModel[@"userId"] :_flsquareAllFreeModel[@"creator"],
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID],
                           @"participateDetailes.message": str};
    FL_Log(@"parm in why ? = %@",parm);
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in save topic info =%@",data[@"success"]);
        
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            
            [self xjSetPartInfoWithInfoUnderReceive:str];
            if (self.tiJiaoBlock) {
                self.tiJiaoBlock();
            }
            [self popDown];

//            //插入参与记录
//            if (![self.xjTopicDeatailModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
//                [self FLFLHTMLInsertParticipate];
//            }
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic info =%@",error);
    }];
    
}
#pragma mark  ------=-=-=-=======++++++++++++++++——+-=-=-=信息回填完毕提交数据
- (void)xjSetPartInfoWithInfoUnderReceive:(NSString*)xjStr {
    NSDictionary* parm =@{@"topic.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"topic.partInfo":xjStr};
    [FLNetTool HTMLGetPartInfoListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"get partisnfo successs =%@",data);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BGFillInformationTableViewCell *  cell=[[BGFillInformationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSString*key=[NSString stringWithFormat:@"%ld",indexPath.row];

    if (self.cellDic[key]) {
        return self.cellDic[key];
    }
//    NSArray*arr1=[self.dataArr[indexPath.row] componentsSeparatedByString:@":"];
//    
//    cell.valueFiled.text=arr1[1];
//    NSArray*arr2=[arr1[0] componentsSeparatedByString:@"#&#"];
//    cell.keyStr=arr2[1];
//    cell.keyLabel.text=arr2[0];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([self.dataArr[indexPath.row] isEqualToString:@"NAME"]) {
        cell.keyLabel.text=@"名字";
    }else if([self.dataArr[indexPath.row] isEqualToString:@"TEL"]){
        cell.keyLabel.text=@"电话";

    }else if([self.dataArr[indexPath.row] isEqualToString:@"ADDRESS"]){
        cell.keyLabel.text=@"地址";

    }else{
        cell.keyLabel.text=self.dataArr[indexPath.row];
 
    }
    cell.keyStr=self.dataArr[indexPath.row];
//    cell.valueFiled.inputAccessoryView=self.toolBar;
    self.cellDic[key]=cell;
    return cell;
    
};


-(UIToolbar *)maskView{
    if (!_maskView) {
        _maskView=[[UIToolbar alloc]init];
        _maskView.frame=CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        _maskView.barStyle=UIBarStyleBlackTranslucent;
        //        _maskView.backgroundColor=[UIColor blackColor];
        _maskView.alpha=0.0;
        
    }
    return _maskView;
}

-(void)popUp{
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=1;
        self.backgroundView.center=self.center;
        //        [self layoutIfNeeded];
    }completion:^(BOOL finished)
     {
         
     }];

}
-(void)popDown{
    self.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=0.0;
        self.backgroundView.cy_y=self.cy_bottom;
        //
        //        [self layoutIfNeeded];
        
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview ];
        [self.maskView removeFromSuperview];
    }];

}

@end
