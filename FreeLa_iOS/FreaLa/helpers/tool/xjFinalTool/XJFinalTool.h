//
//  XJFinalTool.h
//  FreeLa
//
//  Created by Leon on 16/5/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJFinalTool : NSObject
/**
 * 使view 颜色跟随ScrollView渐变
 * @parma   offsetY 滑动距离
 * @parma   color   最终颜色 default is white
 * @parma   trigger 触发条件 default is 50
 * @parma   view    navibar 可以自定义
 */
+ (void)xjChangeViewColorByOffsety:(CGFloat)offsetY view:(UIView*)xjView
                             color:(UIColor*)xjColor
                           trigger:(NSInteger)xjTrigger;

/**
 * 设置导航栏的 标题颜色(ios 7+ 系统自带导航栏)
 * @parma   color  颜色
 * @parma   xjVC   导航栏
 */
+ (void)xjChangeNaviTitleColorByColor:(UIColor*)xjColor
                                 view:(UINavigationController*)xjVC;
/**
 * 保存用户的token 在userdefaults
 * @parma   xjValue
 * @parma    xjKey   xjKey
 */
+ (void)xjSaveUserInfoInUserdefaultsValue:(NSString*)xjValue
                                      key:(NSString*)xjKey;
/**
 * 删除的token 在userdefaults
 * @parma    xjValue
 * @parma    xjKey
 */
+ (void)xjRemoveUserInfoInUserdefaultskey:(NSString*)xjKey;
/**
 * 取出 在userdefaults
 * @parma    xjKey
 */
+ (NSString*)xjTackUserInfoInUserdefaultskey:(NSString*)xjKey;
/**
 * 替换图片路径为
 * @parma    xjstr      原路径
 * @parma    xjAddStr   增加的路径
 */
+ (NSString*)xjReturnBigPhotoURLWithStr:(NSString*)xjstr
                                   with:(NSString*)xjAddStr;

/**
 * 返回字符串size
 * @parma   string
 * @parma   sizefont
 */
+ (CGSize)xjReturnStrSizeWithStr:(NSString*)xjStr fontSize:(NSInteger)xjStrSize;

/**
 * 返回imageURL
 * @parma   string
 * @parma   isSite   是否是 个人发布的图
 */
+ (NSString*)xjReturnImageURLWithStr:(NSString*)xjStr isSite:(BOOL)isSite;

/**
 * 返回bool string(ture 为非空)
 * @parma   string
 */
+ (BOOL)xjStringSafe:(NSString*)xjStr;

/**
 * 是不是超级账号
 */
+ (BOOL)xj_is_superAccount;
/**
 * 是不是有手机号
 */
+ (BOOL)xj_is_phoneNumberBlind;

/**
 * 是否被禁用
 */
+ (BOOL)xj_is_forbidden;
/**
 * 返回一个 居中截取的图
 */
+ (UIImage*)getSubImage:(CGRect)rect img:(UIImage*)img;

/**
 * 通过一张图 和 一个码对比得到相似度
 */
+ (NSInteger)xj_compareWithString:(NSString*)xjStr andImg:(UIImage*)img;

/**
 * 通过一张图 获得64 位识别码
 */
+ (NSString*)xj_getCompareCodeWithImg:(UIImage*)img;
/**
 * 返回一个 方向正确的图
 */
+ (UIImage *)xj_fixOrientation:(UIImage *)aImage;
@end




















