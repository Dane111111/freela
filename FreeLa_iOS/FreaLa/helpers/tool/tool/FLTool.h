//
//  FLTool.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//
#import <AssetsLibrary/ALAsset.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FLUserInfoModel.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <Reachability/Reachability.h>
#import "FLAppDelegate.h"
#import "FLBusAccountInfoModel.h"
#import "HexColors.h"
#import "UINavigationBar+Awesome.h"
#import "FLAppDelegate.h"
#import <Masonry/Masonry.h>
#import "MJRefresh.h"
#import "FLNetTool.h"
#import "UIView+EasyFrame.h"
#import "FLHeader.h"
#import <UIImageView+WebCache.h>
#import "FLBusinessApplyInfoModel.h"
#import "XJTableView.h"



@interface FLTool : NSObject
/**
 *添加手机号输入框 、
 */
+ (UIView*)setPhoneTextWithAreaText:(UITextField*)areaText phoneText:(UITextField*)phoneText;

/**
 *添加密码输入框
 */
+ (UIView*)setNewPWDTextWithpwdImage:(NSString*)pwdImage pwdText:(UITextField*)pwdText;

/**
 *关闭键盘
 */
+ (void)closeKeyBoardByTextField:(UITextField*)textField;

/**
 *获取验证码
 */
//+ (void)getSMSCodeWithAreaText:(NSString*)areaText AndPhoneNumber:(NSString*)PhoneNumber;

/**
 *判断手机号是否正确
 */
+ (BOOL)isPhoneNumberTure:(NSString*)phoneNumber;

/**
 *(放弃API)获取用户的信息
 */
+ (FLUserInfoModel*)getUserInfoModel;
/**
 *data转dic
 */
+ (NSDictionary* )returnDictionaryWithData:(NSData*)data;
/**
 *dic转data
 */
+ (NSData* )returnDataWithDictioary:(NSDictionary*)dic;
/**
 *邮箱格式验证
 */
+(BOOL)isValidateEmail:(NSString *)email;
/**
 *密码字符限制
 */
+ (BOOL)isTrueSecretCode:(NSString*)code;

/**
 *创建hud
 */
+ (MBProgressHUD *)createHUD;
/**
 *网络是否可用
 */
+ (BOOL) isNetworkEnabled;
/**
 *16进制颜色转rgb
 */
+ (CGColorRef*)colorRefByColorString:(NSString*)value;
/**
 *校验长度
 */
+ (BOOL)checkLengthWithString:(NSString*)string length:(NSInteger)lengthMIN lengthM:(NSInteger)lengthMAX view:(UIView*)view who:(NSString*)who;
/**
 *转为商家数据模型
 */
+ (FLBusAccountInfoModel*)GetBusAccountInfoModel;
/**
 *error
 */
+ (NSString*)returnStrWithErrorCode:(NSError*)error;
/**
 *json转字典
 */
+ (NSDictionary*)returnDictionaryWithJSONString:(NSString*)jsonString;
/**
 *json转数组
 */
+ (NSArray*)returnArrayWithJSONString:(NSString*)jsonString;
/**
 *dic转json字符串
 */
+ (NSString*)returnDictionaryToJson:(NSDictionary *)dic;
/**
 * obj 转json字符串
 */
+ (NSString*)xj_returnJsonWithObj:(id)xj_obj;
/**
 *发布缓存值
 */
+ (void)setIssueInfoDataWithDic:(NSDictionary*)data;
/**
 *发布取出值
 */
+ (NSString*)getIssueInfoDataWithDic:(NSString*)stringKey;
/**
 *照片多选返回照片
 */
+ (UIImage*)returnPhotoWithPhotos:(NSMutableArray*)photosArray AndIndex:(NSInteger)index;
/**
 *通过key找value
 *@parm  dic
 *@Parm  value
 */
+ (NSString* )returnKeyFromDic:(NSDictionary*)dic WithValue:(NSString*)value;

/**
 *照片选完返回地址
 */
+ (NSString*)returnPhotoAddressWithResult:(NSString*)result ;
/**
 *数组返回字符串
 */
+ (NSString*)returnStrWithArr:(NSArray*)Array ;
/**
 *NSDate转 string
 */
+ (NSString*)returnStrWithNSDate:(NSDate*)selectedDate AndDateFormat:(NSString*)dateFormat;
/**
 *和当前时间相减得到的值(几天)
 */
+ (NSArray*)returnNumberWithCreatTime:(NSString*)creatTime;
/**
 *和当前时间相减得到的值(是否比现在大)
 * xjxjtime  如果有则为比较时间，没有为本地时间
 */
+ (BOOL)returnBoolNumberWithCreatTime:(NSString*)creatTime xjxjTime:(NSString*)xjxjTime;
/**
 *和当前时间相减得到的值(几岁、简单版)
 */
+ (NSInteger)returnNumberWithBirthdayTime:(NSString*)BirthdayTime;
/**
 *保存图片长宽比，生成需要的尺寸图片
 */
+ (UIImage* )thumbnailWithImageWithoutScale:(UIImage*)image size:(CGSize)asize;

/**
 *和当前时间相减得到的值(几天简单版\重要版)
 */
+ (NSString*)returnNumberWithStartTime:(NSString*)startTime serviceTime:(NSString*)serviceTime;
/**
 *和当前时间相减得到 多久之前发的
 */
+ (NSString*)xjReturnHowLongOfIssue:(NSString*)startTime serviceTime:(NSString*)serviceTime;

/**
 *输入时间，返回  yy月dd号hh:mm格式字符
 */
+ (NSString*)returnYYDDHHMMWithTime:(NSString*)fltime;
/**
 *用于回填商家注册信息模型
 */
+ (FLBusinessApplyInfoModel*)returnBusApplyInfoModel:(NSDictionary*)fldic;
/**
 *返回小数点后两位字符串
 */
+ (NSString*)getTheCorrectNum:(NSString*)tempString;

/**
 *返回小数点后两位字符串
 */
+ (BOOL)returnBoolWithPrice:(NSString*)tempString;
/**
 *返回是否是数字
 */
+ (BOOL)returnBoolWithNumber:(NSString*)tempString;

/**
 *转为商家数据模型(新)
 */
+ (FLBusAccountInfoModel*)flNewGetBusAccountInfoModelWithDic:(NSDictionary*)data;

/**
 *判断是否带 http：//域名 (开始)
 */
+ (BOOL)returnBoolWithIsHasHTTP:(NSString*)tempString includeStr:(NSString*)flStr;
/**
 *判断是否带 http：//域名 (开始)
 */
+ (BOOL)returnBoolWithIsHasStringInclude:(NSString*)tempString includeStr:(NSString*)flStr;
/**
 *判断是否含有汉字
 */
+ (BOOL)returnBoolWithHasChinese:(NSString*)str;
/**
 *判断是否含有字母
 */
+ (BOOL)returnBoolWithHasEnglish:(NSString*)tempString;
/**
 * 几位到几位同时包含数字和字母（4位）
 */
+(BOOL)returnBoolNumberAndEnglish:(NSString *)pass;

/**
 * 返回字典（头像问题）
 */
+(NSDictionary*)returnDictionaryWithDictionary:(NSDictionary *)oldDic;
/**
 * 返回字典数组（头像问题）
 */
+(NSArray*)returnArrayWithArr:(NSArray *)oldArr;
/**
 *判断标签格式 不能纯只要有数字和字母就可以
 */
+ (BOOL)returnBQBoolWithStr:(NSString*)flstr;
/**
 *返回头像
 */
+ (NSString*)returnHeaderURLWithStr:(NSString*)flstr;
/**
 *show
 */
+ (void)showWith:(NSString*)flstr;
/**
 *Hide
 */
+ (void)hideHUD;

/**
 *返回大图url
 */
+ (NSString*)returnBigPhotoURLWithStr:(NSString*)flstr;
/**
 *返回 翻转翻转
 */

+ (UIImage* )fixOrientationss:(UIImage *)aImage;
/**
 *计算当前页,返回应传的Currentpange
 * total  总数
 * xjArrLength 当前数组的长度
 * xjSize  单位长度  default is 10
 * xjCurrentPage   当前页数
 */

+ (NSNumber* )xjRetuenCurrentWithArrLength:(NSInteger)xjArrLength andTotal:(NSInteger )xjTotal xjSize:(NSInteger)xjSize ;

/**
 *设置极光别名
 */

+ (void)xjSetJpushAlias;


/**
 *设置阅读数等
 */

+ (NSString*)xjSetNumberByStr:(NSString*)xjStr;

/**
 *数组去重
 */

+ (NSArray*)xjReturnArrWithoutRepeat:(NSArray*)xjArr;
/**
 *返回行高
 *@parma width  view.witdh
 *@parma text text
 *@parma fontsize
 */
+ (CGFloat)xjReturnCellHWithWidth:(CGFloat)xjViewW text:(NSString*)xjText fontSize:(NSInteger)xjFontSize;
/**
 *结束刷新
 *@parma tableview
 *@parma total
 */
+ (void)xjEndRefreshWithView:(UITableView*)xjTableView total:(NSInteger)xjTotal modelsCount:(NSInteger)xjModelsCount;
/**
 *登出环信
 */
+ (void)xjSingUpHuanxin;

/**
 * 设置空白状态(仅自定义的view)
 * @parma    xjTotal
 * @parma    xjTableView   自定义 的tableview
 */
+ (void)xjSetEmptyStateWithTotal:(NSInteger)xjTotal with:(XJTableView*)xjTableView;
/**
 *登 环信
 */
+ (void) xjLogInHuanXin;
/**
 *保存 环信的 username
 */
+ (void)xjSaveLastLoginUsernameInTool;
/**
 *随机返回一个假头像
 */
+ (NSString*)xj_returnJiaAvatarStr;


/**存入一组topicid 和 detailsid*/
+ (void)xjSaveUserPickTopicModelWithtopicid:(NSString*)xjTopicId detailsId:(NSString*)detailsId;
/**获取topicid 和 detailsid*/
+ (NSString*)xjReturnTopicIdAndModel:(NSInteger)xjTopicId;
@end














