//
//  FLCellImageView.m
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLCellImageView.h"
#define  view_middle_margin     5
#define  view_image_size_H      (viewFrame.size.width - view_middle_margin * 2) / 3
#define  view_top_Margin    5
@interface FLCellImageView ()
/**有几排*/
@property (nonatomic , assign) NSInteger flimageLineCount;
@end


static CGRect viewFrame;
@implementation FLCellImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        viewFrame = frame;
    }
    return self;
}

- (void)setFlimagesArray:(NSArray *)flimagesArray{
    _flimagesArray = flimagesArray;
    if (_flimagesArray.count == 0) {
        _flimageLineCount = 0;
    } else if (_flimagesArray.count <=3) {
        _flimageLineCount = 1;
    } else if (_flimagesArray.count <=6) {
        _flimageLineCount = 2;
    }
    [self allocInMineSelfCell];
}

- (void) allocInMineSelfCell
{
    //    for (NSInteger i = 0; i < _flimagesArray.count;  i++)
    //    {
    //        if (_flimagesArray.count <=3)
    //        {
    //            UIImageView* image = [UIImageView new];
    //            CGFloat  imageX =  0 + i * view_size_w + i * view_middle_margin;
    //            CGFloat  imageY =  0;
    //            CGFloat  imageW =  (viewFrame.size.width - view_middle_margin * (_flimagesArray.count - 1)) / _flimagesArray.count;
    //            CGFloat  imageH =  imageW;
    //            image.frame = CGRectMake(imageX, imageY, imageW, imageH);
    //            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FLBaseUrl,_flimagesArray[i]]]];
    //            [self addSubview:image];
    //        }
    //        else
    //        {
    //            UIImageView* image = [UIImageView new];
    //            CGFloat  imageX =  0 + (i - 3) * view_size_w + (i - 3) * view_middle_margin;
    //            CGFloat  imageY =  (viewFrame.size.width - view_middle_margin * (_flimagesArray.count - 1)) / _flimagesArray.count;
    //            CGFloat  imageW =  (viewFrame.size.width - view_middle_margin * (_flimagesArray.count - 1)) / _flimagesArray.count;
    //            CGFloat  imageH =  imageW;
    //            image.frame = CGRectMake(imageX, imageY, imageW, imageH);
    //            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FLBaseUrl,_flimagesArray[i]]]];
    //            [self addSubview:image];
    //
    //        }
    ////    }
    
    if (_flimagesArray.count <= 3)
    {
        for (NSInteger i = 0; i < _flimagesArray.count;  i++)
        {
            UIImageView* image = [UIImageView new];
            CGFloat  imageX =  0 + i * view_image_size_H + i * view_middle_margin;
            CGFloat  imageY =  0;
            CGFloat  imageW =  view_image_size_H;
            CGFloat  imageH =  imageW;
            image.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flimagesArray[i] isSite:NO]]]];
            [self addSubview:image];
        }
    }
    else if(_flimagesArray.count > 3)
    {
        for (NSInteger i = 0; i < 3; i++)
        {
            UIImageView* image = [UIImageView new];
            CGFloat  imageX =  0 + i * view_image_size_H + i * view_middle_margin;
            CGFloat  imageY =  0;
            CGFloat  imageW =  view_image_size_H;
            CGFloat  imageH =  imageW;
            image.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flimagesArray[i] isSite:NO]]]];
            [self addSubview:image];
        }
        for (NSInteger j = 3; j < _flimagesArray.count; j++)
        {
            UIImageView* image = [UIImageView new];
            CGFloat  imageX =  0 + (j - 3) * view_image_size_H + (j - 3) * view_middle_margin;
            CGFloat  imageY =  view_image_size_H + view_top_Margin;
            CGFloat  imageW =  view_image_size_H;
            CGFloat  imageH =  imageW;
            image.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flimagesArray[j] isSite:NO]]]];
            [self addSubview:image];
        }
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}
@end
