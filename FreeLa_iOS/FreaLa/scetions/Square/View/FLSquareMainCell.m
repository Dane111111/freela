//
//  FLSquareMainCell.m
//  FreeLa
//
//  Created by Leon on 15/10/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLSquareMainCell.h"
@interface FLSquareMainCell()
{
    NSString* days,*hours,*mintiues;
    CGFloat flProgressValue;
}
@property (weak, nonatomic) IBOutlet UIView *flcoverView;
@property (weak, nonatomic) IBOutlet UIImageView *flcoverSview;

@end

@implementation FLSquareMainCell

- (void)awakeFromNib
{
    // Initialization code
    self.flTopicThemeLabel.textColor = [UIColor whiteColor];
    self.flProgressView.progressTintColor = XJ_COLORSTR(XJ_FCOLOR_REDFONT);
    self.flProgressLabel.textColor = [UIColor whiteColor];
    self.flProgressView.tintColor = [UIColor blackColor];
    self.flcoverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.flcoverSview.image = [UIImage imageNamed:@"jianbian-bg20"];
//    self.flcoverSview.contentMode = UIViewContentModeScaleAspectFill;
    
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//重写set方法 赋值给cell
- (void)setFlsquareAllFreeModel:(FLSquareAllFreeModel *)flsquareAllFreeModel
{
    //传进来的模型
    _flsquareAllFreeModel = flsquareAllFreeModel;
    
    [self settingDataInSquareMainCell];
    
    
}

- (void)settingDataInSquareMainCell
{
    self.flTopicThemeLabel.text = _flsquareAllFreeModel.flTopicThemeStr;
    self.flNumberLabel.text = _flsquareAllFreeModel.flNumberStr;
    self.flPickupStyleLabel.text = [FLSquareTools returnConditionStrValueWithKey:_flsquareAllFreeModel.flPickupStyleStr];
    self.flBackGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.flBackGroundImageView sd_setImageWithURL:[NSURL URLWithString:_flsquareAllFreeModel.flBackGroundImageStr ] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        FL_Log(@"this is my update image=%@",image);
       
    }];
   
    self.flBackGroundImageView.layer.masksToBounds = YES;
    
    
    self.flNumberLogoImageView.image = [UIImage imageNamed:@"iconfont_p_praise_gray"];
    self.flCategoryImageView.image = [UIImage imageNamed:@"iconfont_shouji_gray"];
    self.flCategoryLabel.text = _flsquareAllFreeModel.flCategoryStr;
    self.flProgressLabel.text = [NSString stringWithFormat:@"%@/%@",_flsquareAllFreeModel.flProgressStrSmall,_flsquareAllFreeModel.flProgressStrBig];
    self.flNumberLabel.text = _flsquareAllFreeModel.flNumberStr;
    flProgressValue = [_flsquareAllFreeModel.flProgressStrSmall floatValue] / [_flsquareAllFreeModel.flProgressStrBig floatValue];
    [self.flProgressView setProgress:flProgressValue];
    //时间相减,此处变更为剩余时间
    NSArray* dateOffArr =[FLTool returnNumberWithCreatTime:_flsquareAllFreeModel.flinvalidTimeStr];
    if (!dateOffArr)
    {
        self.flCreatTimeLabel.text = @"活动已过期";
    }
    else
    {
        if ([dateOffArr[0] integerValue] >= 1)
        {
            days = [dateOffArr[0] stringValue];
            self.flCreatTimeLabel.text = [NSString  stringWithFormat:@"%@DAY",days];
        }
        else
        {
            hours    =  [dateOffArr[1] stringValue];
            mintiues =  [dateOffArr[2] stringValue];
            self.flCreatTimeLabel.text  = [NSString stringWithFormat:@"%@时%@分",hours,mintiues];
        }
    }
    
    
//    FL_Log(@"caocaocoaco=%@",self.flTopicThemeLabel.text);
    
    
//     FL_Log(@"caocaocoaco=%ld",[FLTool returnNumberWithCreatTime:_flsquareAllFreeModel.flCreatTimeStr]);
}

#pragma mark  popViewDelegate




@end










