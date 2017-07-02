//
//  XJFinalTool.m
//  FreeLa
//
//  Created by Leon on 16/5/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJFinalTool.h"


@implementation XJFinalTool

+ (void)xjChangeViewColorByOffsety:(CGFloat)offsetY view:(UIView*)xjView color:(UIColor*)xjColor trigger:(NSInteger)xjTrigger {
    if (!xjView) {return;}
    if (!xjColor) {xjColor = [UIColor whiteColor];}
    if (xjTrigger==0) {xjTrigger = 50;}
    dispatch_async(dispatch_get_main_queue(), ^{
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [xjView setBackgroundColor:[xjColor colorWithAlphaComponent:alpha]];
        } else {
            [xjView setBackgroundColor:[xjColor colorWithAlphaComponent:0]];
        }
    });
    
}
+ (void)xjChangeNaviTitleColorByColor:(UIColor*)xjColor view:(UINavigationController*)xjVC{
    if (!xjColor) {xjColor = [UIColor whiteColor];}
    [xjVC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:xjColor forKey:NSForegroundColorAttributeName]];
}
+ (void)xjSaveUserInfoInUserdefaultsValue:(NSString*)xjValue key:(NSString*)xjKey {
    [[NSUserDefaults standardUserDefaults] setObject:xjValue?xjValue :@"" forKey:xjKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)xjRemoveUserInfoInUserdefaultskey:(NSString*)xjKey{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:xjKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString*)xjTackUserInfoInUserdefaultskey:(NSString*)xjKey {
    NSString*xjStr = [[NSUserDefaults standardUserDefaults] objectForKey:xjKey];
    return xjStr?xjStr:@"";
}
+ (NSString*)xjReturnBigPhotoURLWithStr:(NSString*)xjstr with:(NSString*)xjAddStr{
    NSString* xjReplaceStr = xjstr;
    NSInteger xjFirst;
    //    FL_Log(@"this is the last/ 111= %@",flstr);
    if ([xjReplaceStr rangeOfString:@"/" options:NSBackwardsSearch].location != NSNotFound) {
        xjFirst = [xjReplaceStr rangeOfString:@"/" options:NSBackwardsSearch].location;
        xjReplaceStr = [xjReplaceStr substringFromIndex:xjFirst + 1];
        //        FL_Log(@"this is the last/ 222= %@",xjReplaceStr);
        if ([xjReplaceStr rangeOfString:@"." options:NSBackwardsSearch].location != NSNotFound) {
            xjstr = [xjstr stringByReplacingOccurrencesOfString:xjReplaceStr withString:[NSString stringWithFormat:@"%@%@",xjAddStr,xjReplaceStr]];
        }
    }
    FL_Log(@"this is the last/55444= %@",xjstr);
    return xjstr;
}
+ (CGSize)xjReturnStrSizeWithStr:(NSString*)xjStr fontSize:(NSInteger)xjStrSize {
    CGSize sizeM = [xjStr sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:xjStrSize]}];
    return sizeM;
}
+ (NSString*)xjReturnImageURLWithStr:(NSString*)xjStr isSite:(BOOL)isSite {
    NSString* str = xjStr;
    if (!xjStr || [xjStr isEqualToString:@""]) {
        return nil;
    }
    if (isSite) {
        str = [self xjReturnBigPhotoURLWithStr:xjStr with:XJ_IMAGE_PUBULIU_ADD];
    }
    if (![FLTool returnBoolWithIsHasHTTP:str includeStr:@"http://"]) {
        str = [FLBaseUrl stringByAppendingString:str];
    }
    return str;
}

+ (BOOL)xjStringSafe:(NSString*)xjStr {
    if (xjStr==nil) {
        return NO;
    }
    if (![xjStr isKindOfClass:[NSString class]]) {
        xjStr = [NSString stringWithFormat:@"%@",xjStr];
    }
    if ([xjStr isEqualToString:@""]) {
        return NO;
    }
    NSMutableString* xjm = [NSMutableString stringWithString:xjStr];
    NSString* xjs = [xjm stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([xjs isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+ (BOOL)xj_is_superAccount {
    NSString* xjUserId = XJ_USERID_WITHTYPE;
    NSInteger userId = [xjUserId integerValue];
    if ([XJFinalTool xjStringSafe:xjUserId]) {
        return (userId==100006 || userId==100011 || userId==100007 || userId==100008 || userId==100042||userId==100001);
    } else {
        return NO;
    }
}

+ (BOOL)xj_is_phoneNumberBlind {
    NSString* xjNumber = [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION2_PHONE];
    if ([self xjStringSafe:xjNumber]) {
       return YES;
    } else {
        return NO;
    }
}
+ (BOOL)xj_is_forbidden {
    NSString* xx = [[XJUserAccountTool share] xj_getUserState];
    if (![xx isEqualToString:@"1"]) {
        return NO;
    } else {
        return YES;
    }
}

+ (void )mmm {
    
}

#pragma  mark ----------------------- 图片对比功能
//1.缩小图片8*8
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//2.将图片转换成灰度图片
+ (UIImage*)xj_getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}
//3.计算出图片平均灰度，然后每一点灰度与平均灰度比较，大于平均值是1，小于平均值是0
+ (NSString *)pHashValueWithImage:(UIImage *)image{
    NSMutableString * pHashString = [NSMutableString string];
    CGImageRef imageRef = [image CGImage];
    unsigned long width = CGImageGetWidth(imageRef);
    unsigned long height = CGImageGetHeight(imageRef);
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    //    NSLog(@"data = %@",data);
    const  char * heightData = (char*)data.bytes;
    int sum = 0;
    
    for (int i = 0; i < width * height; i++)
    {
        printf("%d ",heightData[i]);
        if (heightData[i] != 0)
        {
            sum += heightData[i];
        }
    }
    int avr = sum / (width * height);
    NSLog(@"%d",avr);
    for (int i = 0; i < width * height; i++)
    {
        if (heightData[i] >= avr) {
            [pHashString appendString:@"1"];
        }
        else {
            [pHashString appendString:@"0"];
        }
    }
    FL_Log(@"pHashString = %@,pHashStringLength = %lu",pHashString,(unsigned long)pHashString.length);
    return pHashString;
}
//4.得到两个hashValue不同点数
+ (NSInteger)getDifferentValueCountWithString:(NSString *)str1 andString:(NSString *)str2{
    NSInteger diff = 0;
    const char * s1 = [str1 UTF8String];
    const char * s2 = [str2 UTF8String];
    for (int i = 0 ; i < str1.length ;i++){
        if(s1[i] != s2[i]){
            diff++;
        }
    }
    return diff;
}
/**通过已有的图片识别码和 图片对比*/
+ (NSInteger)xj_compareWithString:(NSString*)xjStr andImg:(UIImage*)img{
    if (img==nil) {
        return 60;
    }
    if (![self xjStringSafe:xjStr]) {
        return 0;
    }
    if ([xjStr isEqualToString:@"1111111111111111111111111111111111111111111111111111111111111111"]) {
        return 60;
    }
    NSInteger diff = 0;
    const char * s1 = [xjStr UTF8String];
//    img = [self getSubImage:CGRectMake((FLUISCREENBOUNDS.width)/2 - 100, (FLUISCREENBOUNDS.height)/2 - 100, 200, 200) img:img];
    const char * s2 = [[self pHashValueWithImage:[self xj_getGrayImage:[self scaleToSize: img size:CGSizeMake(8, 8)]]] UTF8String];
    for (int i = 0 ; i < xjStr.length ;i++){
        if(s1[i] != s2[i]){
            diff++;
        }
    }
    return diff;
}

+ (UIImage*)getSubImage:(CGRect)rect img:(UIImage*)img
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}
+ (NSString*)xj_getCompareCodeWithImg:(UIImage*)img {
//    img = [self getSubImage:CGRectMake((FLUISCREENBOUNDS.width)/2 - 100, (FLUISCREENBOUNDS.height)/2 - 100, 200, 200) img:img];
    NSString * ss = [self pHashValueWithImage:[self xj_getGrayImage:[self scaleToSize: img size:CGSizeMake(8, 8)]]];
    if (ss.length!=64) {
         return @"";
    }
    return ss;
}

+ (UIImage *)xj_fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
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
    
    switch (aImage.imageOrientation) {
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
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
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
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end








