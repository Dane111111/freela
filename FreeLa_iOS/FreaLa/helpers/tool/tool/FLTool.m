//
//  FLTool.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLTool.h"
#import "FLHeader.h"
#import "HexColors.h"
#import <Masonry/Masonry.h>
//#import <SMS_SDK/SMSSDK.h>
#import "FLConst.h"
#import "AssetHelper.h"
#import "UIImage+xjFixOrientation.h"
#import <Photos/PHImageManager.h>
#import "JPUSHService.h"
#import "XJMineInfoModel.h"
//#import <SMS_SDK/CountryAndAreaCode.h>
/**返回一个userinfo的路径*/
#define FL_UserinfoModelPath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Preferences/com.hibang.FreaLa.plist"]


@implementation FLTool

// 添加手机号输入框及约束
+ (UIView*)setPhoneTextWithAreaText:(UITextField*)areaText phoneText:(UITextField*)phoneText
{
    UIView * view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.cornerRadius = 20;
    
    
    areaText.text = @"+86";
    areaText.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
    areaText.textColor = [UIColor colorWithHexString:@"#6c6c6c"];
    areaText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    [view addSubview:areaText];
    
    //手机号输入
    phoneText.layer.cornerRadius = 5.0;
    phoneText.borderStyle = UITextBorderStyleRoundedRect;//关于光标过于靠前的解决方法
    phoneText.clearButtonMode = UITextFieldViewModeAlways;//关于输入框 X号 问题
    phoneText.clearsOnBeginEditing = YES;//再次编辑清空
    phoneText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    [phoneText setBackgroundColor:[UIColor whiteColor]];
    phoneText.placeholder = @"请输入手机号";
    phoneText.borderStyle = UITextBorderStyleNone; //边框样式
    [view addSubview: phoneText];
    
    
    //约束
    //    [view mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(view).with.offset(0);
    //        make.top.equalTo(view).with.offset((200 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
    //        make.height.equalTo(@((80 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
    //        make.width.equalTo(@((470 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
    //
    //    }];
    
    [areaText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).with.offset(0);
        make.left.equalTo(view).with.offset(10);
        make.height.equalTo(@((30 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((80 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
        
    }];
    
    [phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).with.offset(0);
        make.left.equalTo(areaText.mas_right).with.offset(2);
        make.height.equalTo(@((50 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((350 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
        
    }];
    
    
    return view;
    
}

//请输入密码
+ (UIView*)setNewPWDTextWithpwdImage:(NSString*)pwdImage pwdText:(UITextField*)pwdText
{
    UIView* view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.cornerRadius = 20;
    //小锁
    UIImageView* pwdimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:pwdImage]];
    [view addSubview:pwdimageView];
    //输入密码框
    pwdText.layer.cornerRadius = 5.0;
    [KeyboardToolBar registerKeyboardToolBar:pwdText];
    pwdText.borderStyle = UITextBorderStyleRoundedRect;//关于光标过于靠前的解决方法
    pwdText.clearButtonMode = UITextFieldViewModeAlways;//关于输入框 X号 问题
    pwdText.clearsOnBeginEditing = YES;//再次编辑清空
    pwdText.keyboardType = UIKeyboardTypeASCIICapable;//键盘式样
    [pwdText setBackgroundColor:[UIColor whiteColor]];
    pwdText.placeholder = @"请输入6位到16位的新密码";
    pwdText.borderStyle = UITextBorderStyleNone; //边框样式
    [view addSubview: pwdText];
    //    约束
    [pwdimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).with.offset(0);
        make.left.equalTo(view).with.offset(5);
        make.height.equalTo(@((80 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((80 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
        
    }];
    
    return view;
}


//关闭键盘
+ (void)closeKeyBoardByTextField:(UITextField*)textField
{
    [textField resignFirstResponder];
}

+ (BOOL)isPhoneNumberTure:(NSString*)phoneNumber
{
    if (phoneNumber.length != 11) {
        return NO;
    } else {
        NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isMatch = [pred evaluateWithObject:phoneNumber];
        if (phoneNumber.length==11&&[phoneNumber hasPrefix:@"170"]) {
            return YES;
        }
        if (phoneNumber.length==11&&[phoneNumber hasPrefix:@"173"]) {
            return YES;
        }
        if (!isMatch) {
            return NO;
            
        }
    }
    
    return YES;
}

+ (FLUserInfoModel*)getUserInfoModel
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:FL_UserinfoModelPath];
}

+ (NSDictionary* )returnDictionaryWithData:(NSData*)data
{
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary* dic = [unarchiver decodeObjectForKey:@"someKeyValue"];
    [unarchiver finishDecoding];
    return dic;
}

+ (NSData* )returnDataWithDictioary:(NSDictionary*)dic
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver decodeObjectForKey:@"someKeyValue"];
    [archiver finishEncoding];
    return data;
    
    
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isTrueSecretCode:(NSString*)code
{
    NSString * regex = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:code];
    return isMatch;
}

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}

+(BOOL) isNetworkEnabled
{
    BOOL bEnabled = FALSE;
    NSString *url = @"www.freela.com.cn";
    Reachability *r = [Reachability reachabilityWithHostName:url];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
        {
            return  NO;
        }
            // 没有网络连接
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    
    bEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    
    CFRelease(ref);
    if (bEnabled) {
        //        kSCNetworkReachabilityFlagsReachable：能够连接网络
        //        kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
        //        kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接。
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        bEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
    }
    
    return bEnabled;
}

//+ (BOOL)isNuLL
//{
//    if (!self || [self isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    if ([self isKindOfClass:[NSString class]]) {
//
//        NSString *string = (NSString *)self;
//        if ([string isEqualToString:@""] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
//            return YES;
//        }
//    }
//    return NO;
//}

+ (CGColorRef)colorRefByColorString:(NSString*)value
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    return colorref;
}

+ (BOOL)checkLengthWithString:(NSString*)string length:(NSInteger)lengthMIN lengthM:(NSInteger)lengthMAX view:(UIView*)view who:(NSString*)who
{
    if (string.length < lengthMIN)
    {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@长度不能低于%ld位",who,(long)lengthMIN] view:view delay:1 offsetY:0];
        return NO;
    }
    else if (string.length > lengthMAX)
    {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@长度不能多于%ld位",who,(long)lengthMAX] view:view delay:1 offsetY:0];
        return NO;
    }
    return YES;
    
}

+ (FLBusAccountInfoModel*)GetBusAccountInfoModel
{
    FLBusAccountInfoModel* userInfoModel =[[FLBusAccountInfoModel alloc] init];
    
    NSDictionary* parm =@{@"token":FLFLIsPersonalAccountType?FL_ALL_SESSIONID :FLFLBusSesssionID,
                          @"accountType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey};
    FL_Log(@"see info :sesssionId = %@ ",parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"see info in getusermodel tool success=%@, avatar = %@",data,[data objectForKey:@"avatar"]);
        if (data)
        {
            //更新用户数据
            userInfoModel.busEmail = [data objectForKey:@"email"];
            userInfoModel.busfullName = [data objectForKey:@"username"];
            userInfoModel.busSimpleName = [data objectForKey:@"shortName"];
            //        userInfoModel.busCreatTime = [[selectedDic objectForKey:@"createTime"] substringToIndex:9];
            userInfoModel.busUserId   = [[data objectForKey:@"userId"] stringValue];
            userInfoModel.busSimpleIntroduce = [data objectForKey:@"description"];
            NSString * xxxx= data[@"avatar"];
            
            userInfoModel.busHeaderImageStr  = [XJFinalTool xjReturnImageURLWithStr:xxxx isSite:NO];
            
            userInfoModel.busRefuseReason   = [data objectForKey:@"reason"];
            userInfoModel.busliceneNumber = [data objectForKey:@"businessLicenseNum"];
            userInfoModel.busliceneImageStr = [data objectForKey:@"businessLicensePic"];
            userInfoModel.buscreator       = [data objectForKey:@"creator"];
            userInfoModel.busphoneNumber    = [data objectForKey:@"phone"];
            userInfoModel.busUserId         =[[data objectForKey:@"userId"]stringValue];
            userInfoModel.busIndustry      =[data objectForKey:@"industry"];
        }
        
    } failure:^(NSError *error) {
        FL_Log(@"see info in mine failure=%@,%@",error.description,error.debugDescription);
    }];
    
    return userInfoModel;
}

+ (FLBusAccountInfoModel*)flNewGetBusAccountInfoModelWithDic:(NSDictionary*)data
{
    FLBusAccountInfoModel* userInfoModel =[[FLBusAccountInfoModel alloc] init];
    userInfoModel.busEmail = [data objectForKey:@"email"];
    userInfoModel.busfullName = [data objectForKey:@"username"];
    userInfoModel.busSimpleName = [data objectForKey:@"shortName"];
    //        userInfoModel.busCreatTime = [[selectedDic objectForKey:@"createTime"] substringToIndex:9];
    userInfoModel.busUserId   = [[data objectForKey:@"userId"] stringValue];
    userInfoModel.busSimpleIntroduce = [data objectForKey:@"description"];
    userInfoModel.busRefuseReason   = [data objectForKey:@"reason"];
    userInfoModel.busliceneNumber = [data objectForKey:@"businessLicenseNum"];
    userInfoModel.busliceneImageStr = [data objectForKey:@"businessLicensePic"];
    userInfoModel.buscreator       = [data objectForKey:@"legalPerson"];
    userInfoModel.busphoneNumber    = [data objectForKey:@"phone"];
    userInfoModel.busUserId         =[[data objectForKey:@"userId"]stringValue];
    userInfoModel.busIndustry      =[data objectForKey:@"industry"];
    
    userInfoModel.busHeaderImageStr  = data[@"avatar"];
    
    return userInfoModel;
}


+ (NSString*)returnStrWithErrorCode:(NSError*)error
{
    if (error.code == -1004)
        return @"不能连接到服务器";
    if (error.code == -1009)
        return @"没有连接网络";
    if (error.code == -1001) {
        return @"请求超时";
    }
    if (error.code == -1011) {
        return @"找不到服务器";
    }
    if (error.code == 3840) {
        return @"参数错误";
    }
    if (error.code == 1005) {
        return @"网络开小差，请稍后重试";
    }
    
    return @"网络开小差，请稍后重试";
}

+ (NSDictionary*)returnDictionaryWithJSONString:(NSString*)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSString*)xj_returnJsonWithObj:(id)xj_obj {
    if (!xj_obj) {
        return @"";
    }
    if(xj_obj==nil){
        return @"";
    }
    if (xj_obj==NULL) {
         return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:xj_obj options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str?str:@"";
}

+ (NSArray*)returnArrayWithJSONString:(NSString*)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)returnDictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}


+ (void)setIssueInfoDataWithDic:(NSDictionary*)data
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSData * dataSave = [NSKeyedArchiver archivedDataWithRootObject:data];
    [user setObject:dataSave forKey:@"myIssueInfoData"];
    [user synchronize];
}

+ (NSString*)getIssueInfoDataWithDic:(NSString*)stringKey
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSData* middleData = [user objectForKey:@"myIssueInfoData"];
    NSDictionary* data = [NSKeyedUnarchiver unarchiveObjectWithData:middleData];
    //所有标签
    NSString* dicTag = data[FL_NET_DATA_KEY][stringKey];
    FL_Log(@"issue dictag in fltool is  = %@",dicTag);
    return dicTag;
}

+ (UIImage*)returnPhotoWithPhotos:(NSMutableArray*)photosArray AndIndex:(NSInteger)index {
    if (index < photosArray.count) {
        FL_Log(@"this is my testtesttest index photos=%@",photosArray[index]);
        
        
        
        ALAsset *asset=[photosArray objectAtIndex:index];
        ALAssetRepresentation *image_representation = [asset defaultRepresentation];
        CGImageRef posterImageRef=  [image_representation fullScreenImage];
        //        CGImageRef posterImageRef=  [image_representation fullResolutionImage];
        NSDictionary* xjxj = [image_representation metadata];
        NSInteger  xjxjxjxj = [xjxj[@"Orientation"] integerValue];
        UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
        //        UIImage* xjimage     = [self fixOrientationss:posterImage withInteger:xjxjxjxj];r
        
        return posterImage;
    }
    else{
        return nil;
    }
}

+ (NSData*)returnImageWithImage:(UIImage*)xjImage {
    CGFloat maxW = 1028;
    CGFloat minW = FLUISCREENBOUNDS.width;
    CGSize imageSize = xjImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scale = 0.7;
    NSData* xjImageData;
    do {
        xjImageData = UIImageJPEGRepresentation(xjImage, scale);
        scale -= 0.1;
    } while (xjImageData.length > 300000);
    
    xjImage = [UIImage imageWithData:xjImageData];
    
    CGFloat targetWidth;
    if (width >= maxW) {
        targetWidth = maxW;
    } else if (width >= minW) {
        targetWidth = width;
    } else  {
        targetWidth = minW;
    }
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [xjImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGFloat scaleT = 0.7;
    do {
        xjImageData = UIImageJPEGRepresentation(newImage, scaleT);
        scaleT -= 0.1;
    } while (xjImageData.length > 300000);
    
    newImage = [UIImage imageWithData:xjImageData];
    return  xjImageData;
}

+ (NSString* )returnKeyFromDic:(NSDictionary*)dic WithValue:(NSString*)value
{
    NSString * str = nil;
    for (NSString* strKey in [dic allKeys])
    {
        if ([dic[strKey] isEqualToString:value])
        {
            str = strKey;
        }
    }
    return str;
}
+ (NSString*)returnPhotoAddressWithResult:(NSString*)result
{
    NSString* str = nil;
    str = [NSString stringWithFormat:@"%@%@",FLBaseUrl,result];
    
    return str;
}
+ (void)hideHUD {
    [[FLAppDelegate share] hideHUD];
}
+ (NSString*)returnStrWithArr:(NSArray*)Array
{
    NSString* str = [Array componentsJoinedByString:@","];
    
    return str;
}
+ (NSString*)returnStrWithNSDate:(NSDate*)selectedDate AndDateFormat:(NSString*)dateFormat;
{
    NSString* str = nil;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    str = [df stringFromDate:selectedDate];
    //    str=  [NSString stringWithFormat:@"%@:00",str];
    return str;
}
+ (NSArray*)returnNumberWithCreatTime:(NSString*)creatTime
{
    //    NSInteger days = 0;
    //    NSDate* now = [NSDate date];
    //    //实例化一个NSDateFormatter对象
    //    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //    //设定时间格式
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate* date = [dateFormatter dateFromString:creatTime];
    //    NSCalendar*  gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSInteger unitflags = NSDayCalendarUnit;
    //    NSDateComponents* comps = [gregorian components:unitflags fromDate:now toDate:date options:0];
    //    days = [comps day];
    //    NSInteger hours = ([comps hour] / 3600 );
    //    NSInteger mintuies = (([comps minute] / 60) % 60 );
    //    FL_Log(@"creattime = %@，day = %ld ,hour = %ld , mintiue =%ld",creatTime, days,[comps hour],[comps minute]);
    //    NSArray* array = @[[NSNumber numberWithInteger:days],[NSNumber numberWithInteger:hours],[NSNumber numberWithInteger:mintuies]];
    //
    //
    //
    NSArray* array = nil;
    
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:creatTime];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    //    NSLog(@"fromdate=%@",fromDate);
    
    //获取当前时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //    NSLog(@"enddate=%@",localeDate);
    
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    NSInteger iSeconds = lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = (lTime / 3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth = lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    
    //    FL_Log(@" creat============%@,,,相差M%ld年%ld月 或者 %ld日%ld时%ld分%ld秒",creatTime, (long)iYears,(long)iMonth,(long)iDays,(long)iHours,(long)iMinutes,(long)iSeconds);
    array = @[[NSNumber numberWithInteger:iDays],[NSNumber numberWithInteger:iHours],[NSNumber numberWithInteger:iMinutes],[NSNumber numberWithInteger:iSeconds]];
    if (iSeconds > 0) {
        return array;
    }
    else
    {
        return nil;
    }
    
}
+ (BOOL)returnBoolNumberWithCreatTime:(NSString*)creatTime xjxjTime:(NSString*)xjxjTime
{
    BOOL isYes ;
    //将传入时间转化成需要的格式  //被减数
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:creatTime];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    //    NSLog(@"fromdate=%@",fromDate);
    
    //获取当前时间（比较时间） //减数
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //    NSLog(@"enddate=%@",localeDate);
    if (xjxjTime) {
        NSDateFormatter *sformat=[[NSDateFormatter alloc] init];
        [sformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *sfromdate=[sformat dateFromString:xjxjTime];
        NSTimeZone *sfromzone = [NSTimeZone systemTimeZone];
        NSInteger sfrominterval = [sfromzone secondsFromGMTForDate: sfromdate];
        localeDate = [sfromdate  dateByAddingTimeInterval: sfrominterval];
    }
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    if (lTime > 0) {
        isYes = YES;
    } else {
        isYes = NO;
    }
    
    return isYes;
}

+ (NSInteger)returnNumberWithBirthdayTime:(NSString*)BirthdayTime
{
    NSInteger birthday ;
    //当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    FL_Log(@"locationString:%@",locationString);
    //传进来的时间
    NSString* testStr = [NSString stringWithFormat:@"%@",BirthdayTime];//[BirthdayTime substringFromIndex:2];
    testStr = [testStr substringToIndex:4];
    FL_Log(@"stessss= %@",testStr);
    
    birthday = [locationString integerValue] - [testStr integerValue];
    
    
    return birthday;
}

+ (UIImage* )thumbnailWithImageWithoutScale:(UIImage*)image size:(CGSize)asize
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
+ (NSString*)returnNumberWithStartTime:(NSString*)startTime serviceTime:(NSString*)serviceTime
{
    NSString* str = nil;
    
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:startTime];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    //    FL_Log(@"fromdate=%@",fromDate);
    
    NSDate* localeDate = [NSDate date];
    if (serviceTime)  {
        NSDateFormatter *formatS=[[NSDateFormatter alloc] init];
        [formatS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fromdateS=[formatS dateFromString:serviceTime];
        NSTimeZone *fromzoneS = [NSTimeZone systemTimeZone];
        NSInteger fromintervalS = [fromzoneS secondsFromGMTForDate: fromdateS];
        localeDate = [fromdateS  dateByAddingTimeInterval: fromintervalS];
        //        FL_Log(@"localeDate=%@",localeDate);
    }  else  {
        //获取当前时间
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        localeDate = [date  dateByAddingTimeInterval: interval];
        //        FL_Log(@"enddate=%@",localeDate);
    }
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    NSInteger iSeconds = lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = (lTime / 3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth = lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    
    //    FL_Log(@" creat============%@,,,相差M%ld年%ld月 或者 %ld日%ld时%ld分%ld秒",startTime, (long)iYears,(long)iMonth,(long)iDays,(long)iHours,(long)iMinutes,(long)iSeconds);
    if (iYears > 0) {
        str=  [NSString stringWithFormat:@"%ld年",iYears];
    } else if (iDays > 0) {
        str=  [NSString stringWithFormat:@"%ldDay",iDays];
    }  else if (iMinutes > 0)  {
        str=  [NSString stringWithFormat:@"%ld时%ld分",iHours,iMinutes];
    } else {
        str = @"活动已结束";
    }
    return str;
}
+ (NSString*)xjReturnHowLongOfIssue:(NSString*)startTime serviceTime:(NSString*)serviceTime {
    NSString* str = nil;
    
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:startTime];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    //    FL_Log(@"fromdate=%@",fromDate);
    
    NSDate* localeDate = [NSDate date];
    if (serviceTime)  {
        NSDateFormatter *formatS=[[NSDateFormatter alloc] init];
        [formatS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fromdateS=[formatS dateFromString:serviceTime];
        NSTimeZone *fromzoneS = [NSTimeZone systemTimeZone];
        NSInteger fromintervalS = [fromzoneS secondsFromGMTForDate: fromdateS];
        localeDate = [fromdateS  dateByAddingTimeInterval: fromintervalS];
        //        FL_Log(@"localeDate=%@",localeDate);
    }  else  {
        //获取当前时间
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        localeDate = [date  dateByAddingTimeInterval: interval];
        //        FL_Log(@"enddate=%@",localeDate);
    }
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    NSInteger iSeconds = lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = (lTime / 3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth = lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    
    //    FL_Log(@" creat============%@,,,相差M%ld年%ld月 或者 %ld日%ld时%ld分%ld秒",startTime, (long)iYears,(long)iMonth,(long)iDays,(long)iHours,(long)iMinutes,(long)iSeconds);
    if (iYears > 0) {
        str=  [NSString stringWithFormat:@"%ld年前",iYears];
    } else if (iMonth > 0) {
        str=  [NSString stringWithFormat:@"%ld月前",iMonth];
    } else if (iDays > 0) {
        str=  [NSString stringWithFormat:@"%ld天前",iDays];
    }  else if (iHours > 0) {
        str=  [NSString stringWithFormat:@"%ld小时前",iHours];
    } else if (iMinutes > 0)  {
        str=  [NSString stringWithFormat:@"%ld分钟前",iMinutes];
        if (iMinutes == 1) {
            str = @"刚刚";
        }
    } else if (iSeconds > 0) {
        str = @"刚刚";
    }
    return str;
}
+ (NSString*)returnYYDDHHMMWithTime:(NSString*)fltime
{
    
    //    fltime =  2016-01-20 14:57:17
    NSString* timeYY = [fltime substringWithRange:NSMakeRange(5,2)];
    NSString* timeDD = [fltime substringWithRange:NSMakeRange(8,2)];
    NSString* timeHHmm = [fltime substringWithRange:NSMakeRange(11,5)];
    //    NSString* timemm = [fltime substringWithRange:NSMakeRange(8,2)];
    return [NSString stringWithFormat:@"%@月%@日%@",timeYY,timeDD,timeHHmm];
}

+ (FLBusinessApplyInfoModel*)returnBusApplyInfoModel:(NSDictionary*)fldic
{
    FLBusinessApplyInfoModel* flmodel = [[FLBusinessApplyInfoModel alloc] init];
    flmodel.busFullName         = fldic[@"username"];
    flmodel.bussimpleName       = fldic[@"shortName"];
    flmodel.busliceneNumber     = fldic[@"businessLicenseNum"];
    flmodel.bussContectPerName  = fldic[@"legalPerson"];
    flmodel.busPhoneNumber      = fldic[@"phone"];
    flmodel.busemailNumber      = fldic[@"email"];
    flmodel.busPhoneNumber      = fldic[@"phone"];
    flmodel.busLiceneImageStr   = fldic[@"businessLicensePic"];
    flmodel.busPassword         = fldic[@"password"];
    flmodel.busUserID           = fldic[@"userId"];
    flmodel.busIndustryStr      = fldic[@"industry"];
    
    return flmodel;
}

/**返回小数点后两位字符串*/
+ (NSString*)getTheCorrectNum:(NSString*)tempString
{
    //先判断第一位是不是 . ,是 . 补0
    if ([tempString hasPrefix:@"."]) {
        tempString = [NSString stringWithFormat:@"0%@",tempString];
    }
    //计算截取的长度
    NSUInteger endLength = tempString.length;
    //判断字符串是否包含 .
    if ([tempString containsString:@"."]) {
        //取得 . 的位置
        NSRange pointRange = [tempString rangeOfString:@"."];
        NSLog(@"%lu",pointRange.location);
        //判断 . 后面有几位
        NSUInteger f = tempString.length - 1 - pointRange.location;
        //如果大于2位就截取字符串保留两位,如果小于两位,直接截取
        if (f > 2) {
            endLength = pointRange.location + 3;
        }
    }
    //先将tempString转换成char型数组
    NSUInteger start = 0;
    const char *tempChar = [tempString UTF8String];
    //遍历,去除取得第一位不是0的位置
    for (int i = 0; i < tempString.length; i++) {
        if (tempChar[i] == '0') {
            start++;
        }else {
            break;
        }
    }
    //如果第一个字母为 . start后退一位
    if (tempChar[start] == '.') {
        start--;
    }
    //根据最终的开始位置,计算长度,并截取
    NSRange range = {start,endLength-start};
    tempString = [tempString substringWithRange:range];
    return tempString;
}

+ (BOOL)returnBoolWithPrice:(NSString*)tempString
{
    
    
    //表达式  ^[0-9]+(.[0-9]{n})?$以^[0-9]+(.[0-9]{2})?$为例
    //描述  匹配n位小数的正实数
    //匹配的例子  2.22
    //不匹配的例子  2.222,-2.22,
    
    NSString * regex = @"^[0-9]+(.[0-9]{2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:tempString];
    return isMatch;
    
}

+ (BOOL)returnBoolWithNumber:(NSString*)tempString
{
    
    NSString * regex = @"^[0-9]{0}([0-9]|[.])+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:tempString];
    return isMatch;
}

+ (BOOL)returnBoolWithIsHasHTTP:(NSString*)tempString includeStr:(NSString*)flStr {
    BOOL isYes;
    //    //字条串是否包含有某字符串
    //    if ([tempString rangeOfString:@"http://"].location == NSNotFound) {
    //        NSLog(@"string 不存在 martin");
    //    } else {
    //        NSLog(@"string 包含 martin");
    //    }
    //
    //字条串开始包含有某字符串
    if ([tempString hasPrefix:flStr]) {
        //        FL_Log(@"string 包含 in tools===%@",flStr);
        isYes = YES;
    } else {
        //        FL_Log(@"string 不存在in tools==== %@",flStr);
        isYes = NO;
    }
    //
    //    //字符串末尾有某字符串；
    //    if ([string hasSuffix:@"martin"]) {
    //        NSLog(@"string 包含 martin");
    //    } else {
    //        NSLog(@"string 不存在 martin");
    //    }
    
    return  isYes;
}
+ (BOOL)returnBoolWithIsHasStringInclude:(NSString*)tempString includeStr:(NSString*)flStr {
    BOOL isYes;
    //字条串是否包含有某字符串
    if ([tempString rangeOfString:flStr].location == NSNotFound) {
        //            NSLog(@"string 不存在 martin");
        isYes = NO;
    } else {
        //            NSLog(@"string 包含 martin");
        isYes = YES;
    }
    return isYes;
    
}
+ (BOOL)returnBoolWithHasChinese:(NSString*)str
{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}
+ (BOOL)returnBoolWithHasEnglish:(NSString*)tempString
{
    BOOL result = false;
    if ([tempString length] >= 1){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^[A-Za-z]+$";  //[A-Za-z]+$
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:tempString];
    }
    return result;
}

+(BOOL)returnBoolNumberAndEnglish:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 1){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{1,4}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

+(NSDictionary*)returnDictionaryWithDictionary:(NSDictionary *)oldDic
{
    NSMutableDictionary* newDic = oldDic.mutableCopy;
    NSString* avatar = newDic[@"avatar"] ;
    
    if (avatar) {
        [newDic setValue:[XJFinalTool xjReturnImageURLWithStr:avatar isSite:NO] forKey:@"avatar"];
    }
    
    
    return newDic.mutableCopy;
}

+(NSArray*)returnArrayWithArr:(NSArray *)oldArr
{
    NSMutableArray* arrMu = @[].mutableCopy;
    for (NSInteger i = 0; i < oldArr.count; i++) {
        NSDictionary* dic = oldArr[i];
        dic = [self returnDictionaryWithDictionary:dic];
        [arrMu addObject:dic];
    }
    return arrMu.mutableCopy;
}
+ (BOOL)returnBQBoolWithStr:(NSString*)flstr
{
    BOOL isYes = false ;
    for(NSInteger i = 0; i < [flstr length]; ++i) {
        NSString* a = [flstr substringWithRange:NSMakeRange(i, 1)];
        FL_Log(@"this is AaaAaAa =%@",a);
        //判断有没有汉字
        NSString * regex = @"^[\u4e00-\u9fa5]$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isChinese = [pred evaluateWithObject:a];
        if (isChinese) {
            FL_Log(@"发现汉字");
            return YES;
        }
        //判断字母  [A-Za-z]
        NSString * regexE = @"^[A-Za-z]$";
        NSPredicate *predE = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexE];
        BOOL isEnglish = [predE evaluateWithObject:a];
        if (isEnglish) {
            FL_Log(@"发现英文");
            return YES;
        }
    }
    [[FLAppDelegate share] showHUDWithTitile:@"不能纯数字或纯字符" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
    return isYes;
}
+ (NSString*)returnHeaderURLWithStr:(NSString*)flstr
{
    if (![self returnBoolWithIsHasHTTP:flstr includeStr:FLBaseUrl]) {
        flstr = [NSString stringWithFormat:@"%@%@",FLBaseUrl,flstr];
    }
    return flstr;
}
+ (void)showWith:(NSString*)flstr {
    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",flstr] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
}

+ (NSString*)returnBigPhotoURLWithStr:(NSString*)flstr {
    NSString* xjReplaceStr = flstr;
    NSInteger xjFirst ,xjSecond;
    //    FL_Log(@"this is the last/ 111= %@",flstr);
    if ([xjReplaceStr rangeOfString:@"/" options:NSBackwardsSearch].location != NSNotFound) {
        xjFirst = [xjReplaceStr rangeOfString:@"/" options:NSBackwardsSearch].location;
        xjReplaceStr = [xjReplaceStr substringFromIndex:xjFirst + 1];
        //        FL_Log(@"this is the last/ 222= %@",xjReplaceStr);
        if ([xjReplaceStr rangeOfString:@"_" options:NSBackwardsSearch].location != NSNotFound) {
            xjSecond = [xjReplaceStr rangeOfString:@"_" options:NSBackwardsSearch].location;
            xjReplaceStr = [xjReplaceStr substringToIndex:xjSecond + 1];
            //            FL_Log(@"this is the last/ 333= %@",xjReplaceStr);
            flstr = [flstr stringByReplacingOccurrencesOfString:xjReplaceStr withString:@"little_app_"];
        }
    }
    FL_Log(@"this is the last/ 333= %@",flstr);
    return flstr;
}


+ (UIImage* )fixOrientationss:(UIImage *)aImage withInteger:(NSInteger)xjOrientation{
    if (xjOrientation == UIImageOrientationUp)
        
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (xjOrientation) {
            
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (xjOrientation) {
            
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (NSNumber* )xjRetuenCurrentWithArrLength:(NSInteger)xjArrLength andTotal:(NSInteger )xjTotal xjSize:(NSInteger)xjSize {
    
    if (!xjSize) {
        xjSize = 10;
    }
    if (!xjTotal || xjTotal == 0) {
        return [NSNumber numberWithInteger:1];
    }
    if (xjArrLength==0) {
        return [NSNumber numberWithInteger:1];
    } else if (xjArrLength < xjSize) {
        return [NSNumber numberWithInteger:1];
    } else  {
        NSInteger xj = xjArrLength / xjSize;
        if (xj * xjSize < xjTotal) {
            //            FL_Log(@"this is xxjxjxjj+%ld",xj);
            return [NSNumber numberWithInteger:xj+1];
        }
    }
    return nil;
}
+ (void)xjSetJpushAlias {
    NSString* xjUserId = [NSString stringWithFormat:@"%@", XJ_USERID_WITHTYPE];
    NSString* xjToken = [NSString stringWithFormat:@"%@", FL_ALL_SESSIONID];
    NSString* xjUserType = [NSString stringWithFormat:@"%@", XJ_USERID_WITHTYPE];
    if (!xjUserId || xjUserId.length==0 || !xjToken ||!xjUserType || [xjUserType isEqualToString:@"(null)"]) {
        return;
    }
    //上传到极光
    NSString* xjxj = [NSString stringWithFormat:@"%@_%@_2",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE];  //2代表 ios 1代表安卓
    [JPUSHService setTags:nil alias:xjxj fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        FL_Log(@"this is the call back for alias-=-=-=-=-%@",xjxj);
    }];
    //上传至服务器
    if (FLFLIsPersonalAccountType) {
        FL_Log(@"nagemeiyou a ???=%@ 111 =%@222 =%@",FL_ALL_SESSIONID,XJ_USERID_WITHTYPE,xjxj);
        NSDictionary* parmDic = @{@"token":FL_ALL_SESSIONID,
                                  @"userId":XJ_USERID_WITHTYPE,
                                  @"alias":xjxj};
        NSDictionary* parm = @{@"peruser":[FLTool returnDictionaryToJson:parmDic]};
        [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"send my tags success data = %@",data);
        } failure:^(NSError *error) {
            FL_Log(@"send my tags error = %@, == %@",error.description,error.debugDescription);
        }];
    } else {
        NSDictionary* parmDic = @{@"userId":XJ_USERID_WITHTYPE,
                                  @"alias":xjxj,
                                  @"token":FLFLBusSesssionID};
        NSDictionary* parmUpdate = @{@"compuser":[FLTool returnDictionaryToJson:parmDic]};
        [FLNetTool updateCompInfoWithParm:parmUpdate success:^(NSDictionary *data) {
            FL_Log(@"update bus success = %@ ,",data );
        } failure:^(NSError *error) {
            FL_Log(@"update bus error = %@ , %@",error.description , error.debugDescription);
        }];
    }
    if ([[EaseMob sharedInstance].chatManager  isLoggedIn]) {  //当前是否有登陆
        //    登出环信
        //        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        //            if (!error && info) {
        //                NSLog(@"退出成功");
        //                [self xjLogInHuanXin];
        //            }
        //        } onQueue:nil];
    } else {
        [self xjLogInHuanXin];
    }
    
}
+ (void)xjSingUpHuanxin {
    if ([[EaseMob sharedInstance].chatManager  isLoggedIn]) {  //当前是否有登陆
        //            登出环信//
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (!error && info) {
                NSLog(@"退出成功");
                [self xjLogInHuanXin];
            }
        } onQueue:nil];
    }
}
+ (void) xjLogInHuanXin {
    //自动登录环信
    NSString *userName = [NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE];
    NSLog(@"cyuserid %@",FL_USERDEFAULTS_USERID_NEW);
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:@"123456" completion:^
     (NSDictionary *loginInfo, EMError *error) {
         if (!error && loginInfo) {
             FL_Log(@"登录成功With s222 环信%@",userName);
         }
     } onQueue:nil];
    // 设置自动登录
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
    [self xjSaveLastLoginUsernameInTool]; // 保存一下，以后会用得到
    
    //    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //保存自己的 头像和昵称，
    [self xjRequestAndSaveUserNameAndAvatar];
    [self xjSetApns];
}

+ (void)xjSetApns{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    options.displayStyle = ePushNotificationDisplayStyle_simpleBanner;
    options.nickname = @"caocaocaocoacoao";
    
}

+ (void)xjRequestAndSaveUserNameAndAvatar {
    NSString* xj = XJ_USERID_WITHTYPE;
    if (![XJFinalTool xjStringSafe:xj]) {
        return;
    }
    NSDictionary* parmBus =@{@"userid": XJ_USERID_WITHTYPE,
                             @"accountType": XJ_USERTYPE_WITHTYPE};
    FL_Log(@"seeasd info :sessadssionId = %@ ",parmBus);
    [FLNetTool seeInfoWithParm:parmBus success:^(NSDictionary *data) {
        if (data) {
            XJMineInfoModel* xjModle = [XJMineInfoModel mj_objectWithKeyValues:data];
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjModle.avatar key:XJ_FOR_HUANXIN_AVATAR];
            if (FLFLIsPersonalAccountType) {
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjModle.nickname key:XJ_FOR_HUANXIN_USERNAME];
            } else {
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjModle.shortName?xjModle.shortName:xjModle.username key:XJ_FOR_HUANXIN_USERNAME];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)xjSaveLastLoginUsernameInTool {
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

+ (NSString*)xjSetNumberByStr:(NSString*)xjStr {
    NSString* sstr = nil;
    if (xjStr.length < 4) {
        return xjStr;
    }
    if (xjStr.length == 4) {
        sstr = [NSString stringWithFormat:@"%@k",[xjStr substringToIndex:1]];
    } else if (xjStr.length > 4) {
        sstr = [NSString stringWithFormat:@"%@k",[xjStr substringToIndex:xjStr.length - 3]];
    }
    return sstr;
}
+ (NSArray*)xjReturnArrWithoutRepeat:(NSArray*)xjArr {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSNumber *number in xjArr) {
        [dict setObject:number forKey:number];
    }
    //    NSLog(@"%@",[dict allValues]);
    return [dict allValues];
}

+ (CGFloat)xjReturnCellHWithWidth:(CGFloat)xjViewW text:(NSString*)xjText fontSize:(NSInteger)xjFontSize {
    CGSize sizeM = [xjText sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:xjFontSize]}];
    if (sizeM.width < xjViewW) {
        return 1;
    } else {
        CGFloat ff = (float)sizeM.width / xjViewW;
        NSInteger ii = sizeM.width / xjViewW;
        if (ff == ii) {
            return 1;
        } else if (ff > ii) {
            ii++;
            sizeM.width = xjViewW;
            sizeM.height *= ii;
            return ii;
        }
    }
    return 0;
}

+ (void)xjEndRefreshWithView:(UITableView*)xjTableView total:(NSInteger)xjTotal modelsCount:(NSInteger)xjModelsCount {
    [xjTableView.mj_header endRefreshing];
    if (xjTotal > xjModelsCount) {
        [xjTableView.mj_footer endRefreshing];
    } else {
        [xjTableView.mj_footer endRefreshingWithNoMoreData];
    }
}
+ (void)xjSetEmptyStateWithTotal:(NSInteger)xjTotal with:(XJTableView*)xjTableView {
    //首先检查网络状态
    if (![self isNetworkEnabled]) {
        xjTableView.mj_footer.hidden = YES;
        [xjTableView xjSetHidden:NO state:XJImageStateNoInterNet];
    } else {
        if (xjTotal==0 || !xjTotal) {
            xjTableView.mj_footer.hidden = YES;
            [xjTableView xjSetHidden:NO state:XJImageStateNoResult];
        } else {
            xjTableView.mj_footer.hidden = NO;
            [xjTableView xjSetHidden:YES state:XJImageStateNoResult];
        }
    }
}
+ (NSString*)xj_returnJiaAvatarStr {
    NSString* ss    ;
//    NSArray *arr = @[@"http://a.hiphotos.baidu.com/image/pic/item/d1160924ab18972be4b49efde3cd7b899e510a7e.jpg",
//                     @"http://img5.duitang.com/uploads/item/201503/02/20150302204525_RHsWn.jpeg",
//                     ];
    ss = @"";
    int num = arc4random()%33+10;
    if (num < 43) {
        ss = [NSString stringWithFormat:@"xjJiaAvatar%d.jpg",num];
    }
    return ss;
}

+ (void)xjSaveUserPickTopicModelWithtopicid:(NSString*)xjTopicId detailsId:(NSString*)detailsId {
    
    
    NSDictionary* dic = [self xjxjxjxjdic:xjTopicId];
    NSArray* arr = [dic allKeys];
    NSMutableDictionary* muDic = dic.mutableCopy;
    if (arr.count==0) {
        muDic = @{}.mutableCopy;
    }
    [muDic setObject:detailsId forKey:xjTopicId];
    [[NSUserDefaults standardUserDefaults] setObject:muDic forKey:@"XJXJ_SAVE_TOPICID_DETAILS_KEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDictionary*)xjxjxjxjdic:(NSString*)xjTopicid {
    NSDictionary* arr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"XJXJ_SAVE_TOPICID_DETAILS_KEY"];
    return arr;
}

+ (NSString*)xjReturnTopicIdAndModel:(NSInteger)xjTopicId {
    NSDictionary* arr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"XJXJ_SAVE_TOPICID_DETAILS_KEY"];
//    if (arr.count!=0) {
        NSString* dddd = arr[@(xjTopicId)];
//    }
    return dddd?dddd:@"0";
}


@end

////**userID*/
/// @property (nonatomic , strong)NSString* busUserID;
////**行业*/
//@property (nonatomic , strong)NSString* busIndustryStr;
//*/
//


















