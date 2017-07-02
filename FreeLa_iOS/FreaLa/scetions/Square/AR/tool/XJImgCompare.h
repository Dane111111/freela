//
//  XJImgCompare.h
//  FreeLa
//
//  Created by Leon on 2017/2/6.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>


using namespace cv;
using namespace std;

@interface XJImgCompare : NSObject

/**返回图片比对值，值越小越相似*/
+ (double)xjCompareImg:(UIImage*)img1 andImg:(UIImage*)img2;
/**返回图片比对值，值越小越相似
 * @parma url 还不能用。。。。
 */
+ (double)xjCompareImg:(UIImage*)img1 andImgurl:(NSString*)img2url;

@end


