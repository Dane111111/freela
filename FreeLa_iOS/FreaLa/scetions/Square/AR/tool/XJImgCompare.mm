//
//  XJImgCompare.m
//  FreeLa
//
//  Created by Leon on 2017/2/6.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJImgCompare.h"
#import <mach/mach_time.h>

@implementation XJImgCompare
+ (double)xjCompareImg:(UIImage*)img1 andImg:(UIImage*)img2 {
    IplImage* image1 = [self CreateIplImageFromUIImage:img1];
    IplImage* image2 = [self CreateIplImageFromUIImage:img2];
    
    double ff = [self CompareHist:image1 withParam2:image2];
    [self ComparePPKHist:image1 withParam2:image2];
    FL_Log(@"fsadsasafsaf=【%f】",ff);
    return ff;
}

+ (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    CGImageRef imageRef = image.CGImage;
    
    //构造图像
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    IplImage *iplimage = cvCreateImage(cvSize(image.size.width,
                                              image.size.height),
                                       IPL_DEPTH_8U, 4);
    
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData,
                                                    iplimage->width,
                                                    iplimage->height,
                                                    iplimage->depth,
                                                    iplimage->widthStep,
                                                    colorSpace,
                                                    kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    
    //ret = cvCloneImage(iplimage);
    cvReleaseImage(&iplimage);
    
    return ret;
}
+ (void)ComparePPKHist:(IplImage*) srcIpl withParam2:(IplImage*)srcIpl1
{
    printf("匹配结果为:%f\n",[self CompareHist:srcIpl1 withParam2:srcIpl]);
}
+ (double)CompareHist:(IplImage*)image1 withParam2:(IplImage*)image2
{
    int hist_size = 256;
    float range[] = {0,255};
    
    IplImage *gray_plane = cvCreateImage(cvGetSize(image1), 8, 1);
    cvCvtColor(image1, gray_plane, CV_BGR2GRAY);
    CvHistogram *gray_hist = cvCreateHist(1, &hist_size, CV_HIST_ARRAY);
    cvCalcHist(&gray_plane, gray_hist);
    
    IplImage *gray_plane2 = cvCreateImage(cvGetSize(image2), 8, 1);
    cvCvtColor(image2, gray_plane2, CV_BGR2GRAY);
    CvHistogram *gray_hist2 = cvCreateHist(1, &hist_size, CV_HIST_ARRAY);
    cvCalcHist(&gray_plane2, gray_hist2);
    
    return cvCompareHist(gray_hist, gray_hist2, CV_COMP_BHATTACHARYYA);
}

+ (double)xjCompareImg:(UIImage*)img1 andImgurl:(NSString*)img2url {
    UIImageView* img = [[UIImageView alloc] init];
    __weak typeof(self) weakSelf = self;
    IplImage* image1 = [weakSelf CreateIplImageFromUIImage:img1];
    
    [img sd_setImageWithURL:[NSURL URLWithString:img2url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        IplImage* image2 = [weakSelf CreateIplImageFromUIImage:image];
        double ff = [weakSelf CompareHist:image1 withParam2:image2];
        [self ComparePPKHist:image1 withParam2:image2];
        FL_Log(@"fsadsasafsaf=【%f】",ff);
    }];
    return 0.1;
}


@end
