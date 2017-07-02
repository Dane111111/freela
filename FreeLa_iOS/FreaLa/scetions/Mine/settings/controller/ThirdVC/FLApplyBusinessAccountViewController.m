//
//  FLApplyBusinessAccountViewController.m
//  FreeLa
//
//  Created by Leon on 15/11/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLApplyBusinessAccountViewController.h"
#import "FLConst.h"


@interface FLApplyBusinessAccountViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ZHPickViewDelegate>
@property (nonatomic , retain)UIView* footerView;
/**全称*/
@property (nonatomic , strong)NSString*  fullNameText;
/**简称*/
@property (nonatomic , strong)NSString*  simpleNameText;
/**营业执照号*/
@property (nonatomic , strong)NSString*  liceneNameText;
/**邮箱*/
@property (nonatomic , strong)NSString* emailText;
/**选完后的执照照片*/
@property (nonatomic  ,strong)UIImage* liceneImage;
/**选完后头像照片*/
@property (nonatomic  ,strong)UIImage* flheaderImage;

/**section1指针*/
//@property (nonatomic , strong)FLBusinessApplyNameTableViewCell* cellname;
/**提交按钮*/
@property (nonatomic , strong)UIButton* submitBtn;

/**行业*/
@property (nonatomic , strong)NSDictionary* flindustryArray;
/**选完的行业*/
@property (nonatomic , strong)NSString* flindustryStr;

@property (nonatomic , strong) FLBusinessApplyNameTableViewCell* cellname;
/**用来标记选择哪个图片的值*/
@property (nonatomic , assign) NSInteger flSelectedBtnIndex;


/**行业模型数组*/
@property (nonatomic , strong) NSArray* flbusIndustryModelArr;



/**模型*/
//@property (nonatomic , strong)FLBusinessApplyInfoModel* busApplyInfoModel;

/**userId*/
@property (nonatomic , assign) NSInteger flBusAccountUserId;
@end

@implementation FLApplyBusinessAccountViewController
{
    BOOL _beizhushow;
    UITextField* _xjContentTf;//联系人
    UITextField* _xjTjrtf;//推荐人
    UITextField* _xjTjdwtf;//推荐单位
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _beizhushow = NO;
    [self initSubmitButton];
    [self setUpDIYNavi];
    // self.clearsSelectionOnViewWillAppear = NO;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self getSomeInfoFromService];
    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
}

- (FLApplyBusRegistModel *)flBusRegistModelNew
{
    if (!_flBusRegistModelNew) {
        _flBusRegistModelNew = [[FLApplyBusRegistModel alloc] init];
    }
    
    return _flBusRegistModelNew;
}
- (FLApplyBusCheckModel *)flBusCheckModelNew
{
    if (!_flBusCheckModelNew) {
        _flBusCheckModelNew = [[FLApplyBusCheckModel alloc] init];
    }
    FL_Log(@"this sis my test test=%@ ==%@",_flBusCheckModelNew.userId, _flBusCheckModelNew.authId);
    return _flBusCheckModelNew;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {
        return _beizhushow?1:0;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == 0)
    {
        _cellname = [self.tableView  dequeueReusableCellWithIdentifier:@"FLBusinessApplyNameTableViewCell" forIndexPath:indexPath];
        self.cellname.applyVC = self;
        self.cellname.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!FLFLXJISApplyBusOrRevokeMyAccount) {
            self.cellname.flmyFullNameText.text   = self.flBusCheckModelNew.compName;
            self.cellname.flmySimpleNameText.text =self.flBusCheckModelNew.shortName;
            self.cellname.flmyLiceneNameText.text = self.flBusCheckModelNew.businessLicenseNum;
            [self.cellname.xjCoverBtn addTarget:self action:@selector(FLFLpopViewShowInBusApplyCountCell) forControlEvents:UIControlEventTouchUpInside];
            if (self.flindustryStr) {
                self.cellname.flindustryText.text = self.flindustryStr;
            } else {
                self.cellname.flindustryText.text = self.flBusRegistModelNew.industry;
            }
        } else {
            self.cellname.flindustryText.text = self.flindustryStr;
        }
        return self.cellname;
    }
    else if (indexPath.section == 1)
    {
        self.cellContect = [self.tableView  dequeueReusableCellWithIdentifier:@"FLBusinessApplyContectTableViewCell" forIndexPath:indexPath];
        self.cellContect.selectionStyle = UITableViewCellSelectionStyleNone;
        _xjContentTf = self.cellContect.flmyNameText;
        self.cellContect.flmyNameText.text = self.flBusCheckModelNew.legalPerson;
        self.cellContect.flmyPhoneText.text = self.flBusRegistModelNew.phone;
        return self.cellContect;
    }
    else if (indexPath.section == 2)
    {
        self.cellemail= [self.tableView  dequeueReusableCellWithIdentifier:@"FLBusinessApplyEmailTableViewCell" forIndexPath:indexPath];
        if (!FLFLXJISApplyBusOrRevokeMyAccount) {
            self.cellemail.flemailText.enabled = NO;
            self.cellemail.flpasswordText.enabled = NO;
        }
        __weak typeof(self) weakSelf = self;
        self.cellemail.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellemail.flemailText.text = self.flBusRegistModelNew.email;
        [self.cellemail.flvirifityBtn addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
            //            self.cellemail = (FLBusinessApplyEmailTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
            //             self.emailText = self.cellemail.flemailText.text;
            if ( ![FLTool isValidateEmail:weakSelf.cellemail.flemailText.text]) {
                [[FLAppDelegate share] showHUDWithTitile:@"请输入正确的邮箱" view:weakSelf.view delay:1 offsetY:0];
            }
            else if(![FLTool isNetworkEnabled]){
                [[FLAppDelegate share] showHUDWithTitile:@"网络不可用" view:weakSelf.view delay:1 offsetY:0];
            }
            else
            {
                [weakSelf.cellemail.flvirifityBtn setBackgroundColor:[UIColor grayColor]];
                if (FLFLXJISApplyBusOrRevokeMyAccount) {
                    //检查邮箱注册数量
                    [weakSelf checkEmailNumber];
                }else
                {
                    //发送验证邮件
                    [weakSelf sendEmailToU];
                }
                sender.enabled = NO;
                [sender startWithSecond:60];
                [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                    NSString* title = [NSString stringWithFormat:@"%d秒",second];
                    return title;
                }];
            }
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                [weakSelf.cellemail.flvirifityBtn setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
                return @"重新获取";
            }];
        }];
        return self.cellemail;
    }  else if(indexPath.section == 4) {
        self.celllicene = [self.tableView  dequeueReusableCellWithIdentifier:@"FLLiceneImageTableViewCell" forIndexPath:indexPath];
        self.celllicene.selectionStyle = UITableViewCellSelectionStyleNone;
        NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:self.flBusCheckModelNew.businessLicensePic isSite:NO]]];
        NSURL * imageUrlH = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:self.flBusRegistModelNew.avatar isSite:NO]]];
        [self.celllicene.flheaderImageBtn sd_setBackgroundImageWithURL:imageUrlH forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"business_licene_img"]];
        [self.celllicene.flliceneImageBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"business_licene_img"]];
        [self.celllicene.flliceneImageBtn  addTarget:self action:@selector(pickImageToUpDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.celllicene.flheaderImageBtn addTarget:self action:@selector(pickImageToUpDate:) forControlEvents:UIControlEventTouchUpInside];
        self.cellemail.flpasswordText.text = self.flBusRegistModelNew.password ? self.flBusRegistModelNew.password : self.cellemail.flpasswordText.text;
        return self.celllicene;
    } else if(indexPath.section == 3) {
        self.cellAddInfo = [tableView dequeueReusableCellWithIdentifier:@"XJAddBzInfoCell" forIndexPath:indexPath];
        _xjTjrtf = self.cellAddInfo.xjTjrTextfield;
        _xjTjdwtf = self.cellAddInfo.xjTjdwTextfield;
        return  self.cellAddInfo;
    }
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel* titleLabel = [[UILabel alloc] init];
        [view addSubview:titleLabel];
        titleLabel.text = @"备注信息";
        titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.centerY.equalTo(view).offset(0);
        }];
        UISwitch * xjSwitch = [[UISwitch alloc] init];
        [view addSubview:xjSwitch];
        [xjSwitch setOn:_beizhushow];
        [xjSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-20);
            make.centerY.equalTo(view).offset(0);
        }];
        [xjSwitch addTarget:self action:@selector(xjBzInfoShow) forControlEvents:UIControlEventValueChanged];
        return view;
    }
    return  nil;
}



#pragma mark tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 2) {
        if (!FLFLXJISApplyBusOrRevokeMyAccount) {
            FL_Log(@"enbale 后还能不能用了===%@",self.cellContect.flmyNameText);
            [[FLAppDelegate share] showHUDWithTitile:@"如需修改，请重新注册" view:self.navigationController.view delay:1 offsetY:0];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 240;
    } else if (indexPath.section == 1){
        return 120;
    } else if (indexPath.section == 2) {
        return 120;
    }else if (indexPath.section == 3) {
        return 120;
    }
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return 44;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

#pragma mark ------actions
- (void)sendEmailToU
{
    
    [FLNetTool sendVerifityCodeWithEmail:_cellemail.flemailText.text success:^(NSDictionary *dic) {
        if ([[dic objectForKey:FL_NET_KEY]boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"已将邮件发送至%@",_cellemail.flemailText.text] view:self.view delay:1 offsetY:0];
        }
    } failure:^(NSError *error) {
        NSLog(@"send email is error = %@ , %@",error.description,error.debugDescription);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
    }];
}

- (void)pickImageToUpDate:(UIButton*)sender
{
    [self closeKeyBoard];
    if (sender == self.celllicene.flliceneImageBtn) {
        _flSelectedBtnIndex = 1;  //营业执照
    } else if (sender == self.celllicene.flheaderImageBtn){
        _flSelectedBtnIndex  = 2;  //头像
    }
    if (![FLTool isNetworkEnabled]) {
        [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view  delay:1 offsetY:-80];
    }
    else
    {
        UIActionSheet* actionSheet  = [[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"从相册选取", nil];
        [actionSheet showInView:self.view];
    }
    
}
#pragma  mark 校验邮箱、
- (void)checkEmailNumber
{
    NSDictionary* dic = @{@"email":self.cellemail.flemailText.text};
    [FLNetTool howManyAccountWithEmailBilndparm:dic success:^(NSDictionary *data) {
        FL_Log(@"how many ahow many = %@",data);
        NSInteger number = [[data objectForKey:@"count"]integerValue];
        if ( number == 0 ) {
            //发送验证邮件
            //            [self sendEmailToU];
            //            _canSubMit = YES;
            [self testforNew];
            
        } else {
            [[FLAppDelegate share] showHUDWithTitile:@"该邮箱已注册,请更换邮箱" view:self.view delay:1 offsetY:0];
            FLBusinessApplyEmailTableViewCell* cellemail = (FLBusinessApplyEmailTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
            [cellemail.flvirifityBtn stop];
            return ;
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"how many = %@",error.debugDescription);
    }];
}

#pragma mark 校验简称
- (void)checkNickName
{
    //校验唯一性
    if (!FLFLXJISApplyBusOrRevokeMyAccount) {
        //如果没有改过名字，不需要校验
        if ( [self.cellname.flmySimpleNameText.text isEqualToString:_flBusCheckModelNew.shortName]) {
            [self testforNew];
            return;
        }
    }
    
    NSDictionary* dic = @{@"nikeName":self.cellname.flmySimpleNameText.text};
    [FLNetTool checkNickNameWithParm:dic success:^(NSDictionary *data) {
        FL_Log(@"datatesttttt = %@",data);
        if ([data[@"count"] integerValue] != 0) {
            FL_Log(@"data count =%@",data[@"count"]);
            [[FLAppDelegate share] showHUDWithTitile:@"用户名已存在" view:self.navigationController.view delay:1 offsetY:0];
            return ;
        } else {
            //             _canSubMit = YES;
            //检查邮箱注册数量
            if (!FLFLXJISApplyBusOrRevokeMyAccount) {   //如果是 重新提交数据
                [self testforNew];
            } else {
                [self checkEmailNumber];
            }
            
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"datatesttttt = %@",error.description);
    }];
    
    
}

#pragma mark -----ActionSheetDelegate
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
        picker.allowsEditing = _flSelectedBtnIndex == 2 ? YES : NO;
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
        if (editedImage)
        {
            imageToUse = editedImage;
        }else
        {
            imageToUse = orginalIma;
        }
    }
    
    switch (_flSelectedBtnIndex) {    //1 营业执照   2头像
        case 1:
        {
            self.liceneImage = [self thumbnailWithImageWithoutScale:imageToUse size:CGSizeMake(480, 480)];
            [picker dismissViewControllerAnimated:YES completion:nil];
//            [self.celllicene.flliceneImageBtn setBackgroundImage:self.liceneImage forState:UIControlStateNormal];
          
            [self upLoadHeadImagewithImage:self.liceneImage WithIndex:1];
            
        }
            break;
        case 2:
        {
            self.flheaderImage = [self thumbnailWithImageWithoutScale:imageToUse size:CGSizeMake(480, 480)];
            [picker dismissViewControllerAnimated:YES completion:nil];
//            [self.celllicene.flheaderImageBtn setBackgroundImage:self.flheaderImage forState:UIControlStateNormal];
            [self upLoadHeadImagewithImage:self.flheaderImage WithIndex:2];
            //提交用户头像
            if (!FLFLXJISApplyBusOrRevokeMyAccount) {
                [self flupDateMyBusHeaderImageInApplyBus];
            }
            
        }
            break;
        default:
            break;
    }
    
}
//保存到本地的回调方法
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
        [[FLAppDelegate share] showHUDWithTitile:@"保存成功" view:self.view delay:1 offsetY:0];
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
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
//上传营业执照
- (void)upLoadHeadImagewithImage:(UIImage*)useImage WithIndex:(NSInteger)flindex {
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"请稍后" view:FL_KEYWINDOW_VIEW_NEW];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [FLNetTool xjUploadYYZZImage:useImage parm:nil success:^(NSDictionary *data) {
            FL_Log(@"成功222222 = %@",data);
            [[FLAppDelegate share] hideHUD];
            if ([[data objectForKey:@"message"] isEqualToString:@"OK"]) {
                //成功，拼接图片url地址
                switch (flindex) {
                    case 1:
                    {
                        self.flBusCheckModelNew.businessLicensePic = [NSString stringWithFormat:@"%@",[data objectForKey:@"result"]];
                        NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:self.flBusCheckModelNew.businessLicensePic isSite:NO]]];
                        [self.celllicene.flliceneImageBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal];
                    }
                        break;
                    case 2:
                    {
                        self.flBusRegistModelNew.avatar = [NSString stringWithFormat:@"%@",[data objectForKey:@"result"]];
                        NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:self.flBusRegistModelNew.avatar isSite:NO]]];
                        [self.celllicene.flheaderImageBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal];
                    }
                        break;
                    default:
                        break;
                }
                FL_Log(@"my image url is this:%@ =====%@",self.flBusCheckModelNew.businessLicensePic,self.flBusRegistModelNew.avatar);
                NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:3];
                [self.tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationNone];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
             [[FLAppDelegate share] hideHUD];
        }];
    });
}
//}


#pragma mark -----init

- (void)initSubmitButton
{
    //1.初始化Button
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //2.设置文字和文字颜色
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    //3.设置圆角幅度
    self.submitBtn.layer.borderWidth = 1.0;
    //    button.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor redColor]);
    self.submitBtn.layer.masksToBounds = YES;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [self.submitBtn.layer setBorderColor:colorref];//边框颜色
    //4.设置frame
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(100, 40);
    frame.origin = CGPointMake(0, 0);
    //    button.frame = CGRectMake(0, 100, 60, 44);
    self.submitBtn.frame = frame;
    //5.设置背景色
    self.submitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.submitBtn.layer.cornerRadius = 20;
    //6.设置触发事件
    //省略
    [self.submitBtn addTarget:self action:@selector(submitMyBusinessApply) forControlEvents:UIControlEventTouchUpInside];
    //7.添加到tableView tableFooterView中
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake((FLUISCREENBOUNDS.width / 2) - 50, 10,60 , 60)];
    [view addSubview:self.submitBtn];
    self.tableView.tableFooterView=view;
    
}

- (void)submitMyBusinessApply
{
    //    [[FLAppDelegate share] showdimBackHUDWithTitle:nil view:self.view];
    BOOL isYes = YES;
    
    //    FLLiceneImageTableViewCell* celllicene = (FLLiceneImageTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3]];
    [self closeKeyBoard];
    
    if (!FLFLXJISApplyBusOrRevokeMyAccount) {
        if ([_cellemail.flpasswordText.text isEqualToString:@""] || !_cellemail.flpasswordText)
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"请输入6到16位密码" view:self.view delay:1 offsetY:0];
            });
            isYes = NO;
            return;
        }
        else if (![FLTool  isTrueSecretCode:_cellemail.flpasswordText.text])
        {
            if (!FLFLXJISApplyBusOrRevokeMyAccount) {
                
            } else {
                [self endHud];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:@"请输入6到16位密码" view:self.view delay:1 offsetY:0];
                });
                isYes = NO;
                return;
            }
        }
    }
    else
    {
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,0,0,1 });
        
        if ( [self.cellname.flmyFullNameText.text isEqualToString:@""] ) {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"全称不能为空" view:self.view delay:1 offsetY:0];
            });
            [_cellname.fullnameView.layer setBorderColor:colorref];
            isYes = NO;
            return;
        }
        if (  [self.cellname.flmySimpleNameText.text isEqualToString:@""]  )
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"简称还是起一个吧" view:self.view delay:1 offsetY:0];
            });
            
            [_cellname.simplenameView.layer setBorderColor:colorref];
            FL_Log(@"cellname.fluuname = %@",_cellname.flmyFullNameText.text);
            isYes = NO;
            return;
        }
        if (  [self.cellname.flmyLiceneNameText.text isEqualToString:@""] )
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"营业执照号不能为空" view:self.view delay:1 offsetY:0];
                [_cellname.licenenameView.layer setBorderColor:colorref];
            });
            isYes = NO;
            return;
        }
        if ( !(self.cellname.flmyLiceneNameText.text.length == 15 || self.cellname.flmyLiceneNameText.text.length == 18))
{
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"请输入15或18位营业执照号" view:self.view delay:1 offsetY:0];
                [_cellname.licenenameView.layer setBorderColor:colorref];
            });
            isYes = NO;
            return;
        }
        if (  [self.cellContect.flmyNameText.text isEqualToString:@""]  )
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"联系人不能为空" view:self.view delay:1 offsetY:0];
                [_cellContect.flmyNameTextView.layer setBorderColor:colorref];
            });
            
            isYes = NO;
            return;
        }
        if ( [self.cellContect.flmyPhoneText.text isEqualToString:@""])
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"联系电话不能为空" view:self.view delay:1 offsetY:0];
                [_cellContect.flmyPhoneView.layer setBorderColor:colorref];
            });
            isYes = NO;
            return;
        }
        if (![FLTool isPhoneNumberTure:self.cellContect.flmyPhoneText.text]  )
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [FLTool showWith:@"电话号码错误"];
                [_cellContect.flmyPhoneView.layer setBorderColor:colorref];
            });
            
            isYes = NO;
            return;
        }
        if (  [self.cellemail.flemailText.text isEqualToString:@""])
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[FLAppDelegate share] showHUDWithTitile:@"邮箱不能为空" view:self.view delay:1 offsetY:0];
                [FLTool showWith:@"邮箱不能为空"];
                [_cellemail.flemailText.layer setBorderColor:colorref];
                
            });
            isYes = NO;
            return;
        }
        if ( ![FLTool isValidateEmail:_cellemail.flemailText.text])
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"请输入正确的邮箱" view:self.view delay:1 offsetY:0];
            });
            
            isYes = NO;
            return;
        }
        //        else if ([_cellemail.flverifityText.text isEqualToString: @""] || !_cellemail.flverifityText)
        //        {
        //            [[FLAppDelegate share] showHUDWithTitile:@"验证码不能为空" view:self.view delay:1 offsetY:0];
        //            [_cellemail.flverifityText.layer setBorderColor:colorref];
        //            _canSubMit = NO;
        //        }
        if ([_cellemail.flpasswordText.text isEqualToString:@""] || !_cellemail.flpasswordText)
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"请输入6到16位密码" view:self.view delay:1 offsetY:0];
                [_cellemail.flpasswordText.layer setBorderColor:colorref];
            });
            
            isYes = NO;
            return;
        }
        if (![FLTool isTrueSecretCode:_cellemail.flpasswordText.text])
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"请输入6到16位密码(不能包含特殊字符)" view:self.view delay:1 offsetY:0];
                [_cellemail.flpasswordText.layer setBorderColor:colorref];
            });
            
            isYes = NO;
            return;
        }
        
        if (!self.liceneImage )
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"营业执照还没有上传" view:self.view delay:1 offsetY:0];
                [_cellemail.flvirifityBtn.layer setBorderColor:colorref];
            });
            
            isYes = NO;
            return;
        }
        if (!self.flBusCheckModelNew.businessLicensePic)
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share]showHUDWithTitile:@"图片未上传成功" view:self.view delay:1 offsetY:0];
            });
            
            isYes = NO;
            return;
        }
        if (!self.flBusRegistModelNew.avatar)
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share]showHUDWithTitile:@"头像未上传" view:self.view delay:1 offsetY:0];
            });
            isYes = NO;
            return;
        }
        
        //        if (!FLFLXJISApplyBusOrRevokeMyAccount) {
        //            _canSubMit = YES;
        //        }
        
    }
    
    if (_beizhushow) {
        if (![XJFinalTool xjStringSafe:_xjTjrtf.text]) {
            [FLTool showWith:@"联系人不能为空"];
            return;
        }
    }
    
    if (isYes) {
        [self checkInfo];
        [self subMitActionDone];
    } else {
        [self endHud];
    }
    
    
    
}
- (void)checkInfo
{
    //校验简称
    [self checkNickName];
}

- (void)subMitActionDone
{
    self.flBusCheckModelNew.compName   = self.cellname.flmyFullNameText.text;
    self.flBusCheckModelNew.shortName= self.cellname.flmySimpleNameText.text;
    self.flBusRegistModelNew.password   = self.cellemail.flpasswordText.text;
    self.flBusCheckModelNew.businessLicenseNum = self.cellname.flmyLiceneNameText.text;
    self.flBusRegistModelNew.email  = self.cellemail.flemailText.text;
    self.flBusRegistModelNew.phone  = self.cellContect.flmyPhoneText.text;
    self.flBusCheckModelNew.legalPerson = _xjContentTf.text;
    
    NSString* parmDic = [NSString stringWithFormat:@"{\"username\":\"%@\",\"shortName\":\"%@\",\"password\":\"%@\",\"businessLicenseNum\":\"%@\",\"businessLicensePic\":\"%@\",\"email\":\"%@\",\"phone\":\"%@\"}",self.flBusCheckModelNew.compName,self.flBusCheckModelNew.shortName,self.flBusRegistModelNew.password,self.flBusCheckModelNew.businessLicenseNum,self.flBusCheckModelNew.businessLicensePic,self.flBusRegistModelNew.email,self.flBusRegistModelNew.phone];
    FL_Log(@"parmdic= 新 in bues apply %@",parmDic);
    
    /*
     //验证邮箱验证码
     dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_async(globalQuene, ^{
     NSDictionary* parmVerifity = [NSDictionary dictionaryWithObjectsAndKeys:
     FL_sessionId, @"token",
     self.cellemail.flemailText.text,@"account",
     self.cellemail.flverifityText.text,@"checkCode",
     nil];//$$
     NSLog(@"verifity in bus apply parm = %@",parmVerifity);
     [FLNetTool checkEmailVerifityParm:parmVerifity success:^(NSDictionary *data) {
     NSLog(@"verifity compare success %@, %@",data, [data objectForKey:@"msg"]);
     if ([[data objectForKey:FL_NET_KEY]boolValue])
     {
     [self testforNew];
     }
     else
     {
     NSLog(@"yan zheng shibai le ");
     [[FLAppDelegate share] showHUDWithTitile:@"验证失败" view:self.view delay:1 offsetY:0];
     }
     } failure:^(NSError *error) {
     NSLog(@"verifity forget message error= %@",error.debugDescription);
     }];
     });
     */
    
}

- (BOOL)canSubMitWithUserInput
{
    BOOL isYes ;
    FL_Log(@"zheshiceshi shuju aaaaa11=%@,=22===%@,++33+%@,44%@,55%@,66%@,77%@,88%@,99%@,1010%@",self.cellname.flmyFullNameText.text,self.cellname.flmySimpleNameText.text,self.cellname.flmyLiceneNameText.text,self.cellname.flindustryText.text,self.cellContect.flmyNameText.text,self.cellContect.flmyPhoneText.text,self.cellemail.flemailText.text,self.cellemail.flpasswordText.text,self.flBusCheckModelNew.businessLicensePic,self.flBusRegistModelNew.avatar);
    if (self.cellname.flmyFullNameText.text && self.cellname.flmySimpleNameText.text && self.cellname.flmyLiceneNameText.text && self.cellname.flindustryText.text && self.cellContect.flmyNameText.text && self.cellContect.flmyPhoneText.text && self.cellemail.flemailText.text && self.cellemail.flpasswordText.text && self.flBusCheckModelNew.businessLicensePic && self.flBusRegistModelNew.avatar) {
        
        isYes = YES;
    }
    else {
        isYes = NO;
    }
    
    return isYes;
}

#pragma  mark  注册商家号
- (void)testforNew
{
    [[FLAppDelegate share] showdimBackHUDWithTitle:nil view:FL_KEYWINDOW_VIEW_NEW];
    BOOL _canContinue = [self canSubMitWithUserInput];
    if (!_canContinue) {
        return;
    }
    
    // 1 为注册进入 0为已有商家号进入
    if (!FLFLXJISApplyBusOrRevokeMyAccount) {
        //进入此接口 应有userid 还需区分是否有审核信息
        [self flUpDateBusinessApplyInfo];
        
    } else {
        NSDictionary* parmDic = @{@"username":@"",
                                  @"shortName":@"",
                                  @"password":self.cellemail.flpasswordText.text,
                                  @"businessLicenseNum":@"",
                                  @"businessLicensePic":@"",
                                  @"email":self.cellemail.flemailText.text,
                                  @"phone":self.cellContect.flmyPhoneText.text,
                                  @"userId":FLFLXJISApplyBusOrRevokeMyUserID ? FLFLXJISApplyBusOrRevokeMyUserID :@"",
                                  @"industry":self.flindustryStr,
                                  @"avatar":self.flBusRegistModelNew.avatar,
                                  @"grade":@"0",
                                  @"recommendUnit":_xjTjrtf.text?_xjTjrtf.text:@"" ,  // 推荐人和 推荐单位 命名反了
                                  @"recommendPeople": _xjTjdwtf.text?_xjTjdwtf.text:@""
                                  };
        NSDictionary* parm = @{@"compuser":[FLTool returnDictionaryToJson:parmDic],
                               @"token":FL_ALL_SESSIONID,
                               };
        self.flBusCheckModelNew.compName   = self.cellname.flmyFullNameText.text;
        self.flBusCheckModelNew.shortName= self.cellname.flmySimpleNameText.text;
        self.flBusRegistModelNew.password   = self.cellemail.flpasswordText.text;
        self.flBusCheckModelNew.businessLicenseNum = self.cellname.flmyLiceneNameText.text;
        self.flBusRegistModelNew.email  = self.cellemail.flemailText.text;
        self.flBusRegistModelNew.phone  = self.cellContect.flmyPhoneText.text;
        self.flBusCheckModelNew.legalPerson = self.cellContect.flmyNameText.text;
        
        [FLNetTool registerBusinessAccountWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"this is my test new code=%@",data);
            if ([data[@"info"] boolValue]) {
                FLFLXJISApplyBusOrRevokeMyUserID = data[@"userId"];
                self.flBusRegistModelNew.userId = data[@"userId"];
                if (data[@"userId"]) {
                    [self flUpDateBusinessApplyInfo];
                } else {
                    FL_Log(@"caocaocao nidaye zhegetamade shi shenme dongxi=%@",data[@"msg"]);
                    [self endHud];
                }
            } else {
                [self endHud];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                });
            }
        } failure:^(NSError *error) {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            });
        }];
    }
    
}
#pragma  mark  提交信息
- (void)flUpDateBusinessApplyInfo
{
    NSDictionary* parm = @{};
    if (!self.flIsRenZheng) {
        parm = @{@"token":FL_ALL_SESSIONID,
                 @"compAuth.userId":FLFLXJISApplyBusOrRevokeMyAccount ? FLFLXJISApplyBusOrRevokeMyUserID :self.flBusRegistModelNew.userId,
                 @"compAuth.authId": FLFLXJISApplyBusOrRevokeMyAccount ? @"": @"",
                 @"compAuth.userType": FLFLXJUserTypeCompStrKey, //FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey :flΩ
                 @"compAuth.creator":FL_USERDEFAULTS_USERID_NEW,
                 @"compAuth.compName": self.cellname.flmyFullNameText.text,
                 @"compAuth.shortName":self.cellname.flmySimpleNameText.text,
                 @"compAuth.legalPerson": FLFLXJISApplyBusOrRevokeMyAccount ? self.cellContect.flmyNameText.text :self.flBusCheckModelNew.legalPerson,
                 @"compAuth.businessLicenseNum":self.cellname.flmyLiceneNameText.text,
                 @"compAuth.businessLicensePic":self.flBusCheckModelNew.businessLicensePic,
                 };
    } else {
        parm = @{@"token":FL_ALL_SESSIONID,
                 @"compAuth.userId":FLFLXJISApplyBusOrRevokeMyAccount ? FLFLXJISApplyBusOrRevokeMyUserID :self.flBusCheckModelNew.userId,
                 @"compAuth.authId": FLFLXJISApplyBusOrRevokeMyAccount ? @"": self.flBusCheckModelNew.authId,
                 @"compAuth.userType": FLFLXJUserTypeCompStrKey,//FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey :
                 @"compAuth.creator":FL_USERDEFAULTS_USERID_NEW,
                 @"compAuth.compName": self.cellname.flmyFullNameText.text,
                 @"compAuth.shortName":self.cellname.flmySimpleNameText.text,
                 @"compAuth.legalPerson": FLFLXJISApplyBusOrRevokeMyAccount ? self.cellContect.flmyNameText.text :self.flBusCheckModelNew.legalPerson ? self.flBusCheckModelNew.legalPerson : @"",
                 @"compAuth.businessLicenseNum":self.cellname.flmyLiceneNameText.text,
                 @"compAuth.businessLicensePic":self.flBusCheckModelNew.businessLicensePic,
                 };
    }
    [FLNetTool flUpDateBusinessInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my test in bus apply new code=%@",data);
        if (data) {
            if ([data[FL_NET_KEY_NEW] boolValue]) {
                [self endHud];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:@"成功，请到已有商家号查看" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                    //跳转 至
                    
                    //                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                });
                if (!FLFLXJISApplyBusOrRevokeMyAccount) {
                    NSDictionary* parm = @{
                                           @"password":self.flBusRegistModelNew.password,
                                           @"email":self.flBusRegistModelNew.email,
                                           @"phone":self.flBusRegistModelNew.phone,
                                           @"userId":self.flBusRegistModelNew.userId,
                                           @"industry": self.flbusIndustryModelArr ? [self returnIndustryWithResaultStr:self.flBusRegistModelNew.industry] : self.flBusRegistModelNew.industry ? self.flBusRegistModelNew.industry :@"",
                                           @"avatar":self.flBusRegistModelNew.avatar ? self.flBusRegistModelNew.avatar : @""
                                           };
                    NSDictionary* parmUp = @{@"token":FL_ALL_SESSIONID,
                                             @"compuser":[FLTool returnDictionaryToJson:parm]};
                    [self updateMyBusInfoWithParm:parmUp];
                    
                }
            } else {
                [self endHud];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                });
            }
        }
    } failure:^(NSError *error) {
        [self endHud];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        });
        
    }];
    
}
#pragma  mark should be delegate
- (void)submitMyBusinessApplyWithParm:(NSDictionary*)parmdic
{
    [FLNetTool registerBusinessAccountWithParm:parmdic success:^(NSDictionary *data) {
        if ([[data objectForKey:@"info"]boolValue]) {
            NSLog(@"submit bus success =%@",data);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]] view:self.view delay:1 offsetY:0];
            //跳转，此处应跳转 至 已有商家号界面
            dispatch_async(dispatch_get_main_queue(), ^{
                FLChangeMyAccountTableViewController* changeVC = [[FLChangeMyAccountTableViewController alloc] init];
                [self.navigationController pushViewController:changeVC animated:YES];
            });
        }
        else
        {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]] view:self.view delay:1 offsetY:0];
            });
        }
    } failure:^(NSError *error) {
        [self endHud];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        });
        
    }];
    
}

- (void)updateMyBusInfoWithParm:(NSDictionary*)parmDic
{
    FL_Log(@"this is my update parm=%@",parmDic);
    [FLNetTool updateCompInfoWithParm:parmDic success:^(NSDictionary *data) {
        FL_Log(@"update bus success 啊啊啊= %@ ,  ",data );
        if ([[data objectForKey:@"info"]isEqualToString:@"success"]) {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"更新成功" view:self.view delay:1 offsetY:0];
                
            });
        } else {
            [self endHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"失败，请检查网络" view:self.view delay:1 offsetY:0];
                
            });
        }
    } failure:^(NSError *error) {
        [self endHud];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        });
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    
    //    self.cellname = (FLBusinessApplyNameTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    //    self.cellContect = (FLBusinessApplyContectTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    //    self.cellemail = (FLBusinessApplyEmailTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
    //    self.celllicene = (FLLiceneImageTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3]];
    
}


- (void)setUpDIYNavi
{
    self.title = @"商家认证";
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FLBusinessApplyNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLBusinessApplyNameTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FLBusinessApplyContectTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLBusinessApplyContectTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FLBusinessApplyEmailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLBusinessApplyEmailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FLLiceneImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLLiceneImageTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XJAddBzInfoCell" bundle:nil] forCellReuseIdentifier:@"XJAddBzInfoCell"];
    self.cellname = [[FLBusinessApplyNameTableViewCell alloc]init];
    self.cellContect = [[FLBusinessApplyContectTableViewCell alloc] init];
    self.cellemail = [[FLBusinessApplyEmailTableViewCell alloc] init];
    self.celllicene = [[FLLiceneImageTableViewCell alloc] init];
    //键盘格式
    
    _cellname.flmyLiceneNameText.keyboardType = UIKeyboardTypeNumberPad;
    _cellemail.flemailText.keyboardType = UIKeyboardTypeEmailAddress;
    _cellContect.flmyPhoneText.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)closeKeyBoard
{
    //移动scrollow
    dispatch_async(dispatch_get_main_queue(), ^{
        [FL_KEYWINDOW_VIEW_NEW endEditing:YES];
    });
    [_cellemail.flverifityText resignFirstResponder];
    [_cellemail.flemailText resignFirstResponder];
    [_cellname.flmyFullNameText resignFirstResponder];
    [_cellname.flmyLiceneNameText resignFirstResponder];
    [_cellname.flmySimpleNameText resignFirstResponder];
    [_cellContect.flmyNameText resignFirstResponder];
    [_cellContect.flmyPhoneText resignFirstResponder];
    [_cellemail.flpasswordText resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    FLFLXJISApplyBusOrRevokeMyUserID = @"";
    [self endHud];
}

- (void)getSomeInfoFromService
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FLFLpopViewShowInBusApplyCountCell) name:@"FLFLpopViewShowInBusApplyCountCell" object:nil];
    //获取行业列表
    NSDictionary* parm = @{@"token":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID]]};
    FL_Log(@"tiken in change industry=%@",parm);
    [FLNetTool chooseIndustryWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in industry in mine = %@ ,",data);
        self.flindustryArray = data;
    } failure:^(NSError *error) {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
    }];
}

#pragma mark 选择行业
- (void)FLFLpopViewShowInBusApplyCountCell
{
    
    [self closeKeyBoard];
    if (self.flindustryArray)
    {
        [_pickview remove];
        
        //行业数组
        self.flbusIndustryModelArr = [FLBusIndustryModel mj_objectArrayWithKeyValuesArray:self.flindustryArray];
        NSMutableArray* muArr = [NSMutableArray array];
        for (NSDictionary* dic in self.flindustryArray)
        {
            NSString* str = [dic objectForKey:@"dicValue"];
            [muArr addObject:str];
        }
        FL_Log(@"muarray in bus to change industry =%@",muArr);
        [self closeKeyBoard];
        _pickview=[[ZHPickView alloc] initPickviewWithArray:muArr isHaveNavControler:NO];
        _pickview.delegate = self;
        [_pickview show];
    }
    else
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请检查网络" view:self.view delay:1 offsetY:0];
    }
}

#pragma mark -ZHPickerview delegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    for (NSInteger i = 0; i < self.flbusIndustryModelArr.count; i++) {
        FLBusIndustryModel* model = self.flbusIndustryModelArr[i];
        if ([model.dicValue isEqualToString:resultString]) {
            self.flBusRegistModelNew.industry = [NSString stringWithFormat:@"%ld",model.flid];
        }
    }
    self.flindustryStr = resultString;
    [self.tableView reloadData];
    
}

#pragma mark 提交头像
- (void)flupDateMyBusHeaderImageInApplyBus
{
    NSDictionary* parm = @{@"userId":self.flBusRegistModelNew.userId,
                           @"avatar":self.flBusRegistModelNew.avatar};
    FL_Log(@"parmdic= %@",parm);
    NSDictionary* parmUpdate = @{@"compuser":[FLTool returnDictionaryToJson:parm],
                                 @"token":FLFLBusSesssionID};
    
    [FLNetTool updateCompInfoWithParm:parmUpdate success:^(NSDictionary *data) {
        FL_Log(@"this is my update header image in =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flBusRegistModelNew.avatar = data[FL_NET_DATA_KEY][@"avatar"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSString*)returnIndustryWithResaultStr:(NSString*)resaultStr
{
    NSString* str = nil;
    for (NSInteger i = 0; i < self.flbusIndustryModelArr.count; i++) {
        FLBusIndustryModel* model = self.flbusIndustryModelArr[i];
        if (model.flid ==resaultStr.integerValue) {
            str = [NSString stringWithFormat:@"%@",model.dicName];
        }
    }
    FL_Log(@"zenmhui bengkui zai zher ne ?=%@",str);
    return str;
}

- (void)endHud
{
    [[FLAppDelegate share] hideHUD];
}

- (void)xjBzInfoShow {
    _beizhushow = !_beizhushow;
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:3];
    [self.tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationFade];
}


@end















