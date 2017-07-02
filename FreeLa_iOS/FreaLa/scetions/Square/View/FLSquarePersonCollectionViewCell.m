//
//  FLSquarePersonCollectionViewCell.m
//  FreeLa
//
//  Created by Leon on 15/12/18.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLSquarePersonCollectionViewCell.h"

@implementation FLSquarePersonCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initUIInpersonalIssueCell];
    }
    return self;
}

- (UIImageView *)flimageViewBackGround
{
    if (!_flimageViewBackGround) {
        _flimageViewBackGround = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _flimageViewBackGround.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _flimageViewBackGround.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview: _flimageViewBackGround];
    }
    return _flimageViewBackGround;
}

- (void)initUIInpersonalIssueCell
{
   
}

//重写set方法 传进来的模型
- (void)setFlsquarePersonIssueModel:(FLSquarePersonalIssueModel *)flsquarePersonIssueModel
{
    _flsquarePersonIssueModel = flsquarePersonIssueModel;
    [self settingDataInPersonalIssueCell];
}

- (void)settingDataInPersonalIssueCell
{
    
//    [self.flimageViewBackGround sd_setImageWithURL:[NSURL URLWithString:_flsquarePersonIssueModel.flStrBackGroundImageUrl] placeholderImage:[UIImage imageNamed:@"logo_freela"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            if (!CGSizeEqualToSize(_flsquarePersonIssueModel.flSizeBackGroundImageSize, image.size)) {
////                _flsquarePersonIssueModel.flSizeBackGroundImageSize = [self returnWarterPullImageSizeWithImageSize:image.size];
//                 _flsquarePersonIssueModel.flSizeBackGroundImageSize =   image.size;
//                 FL_Log(@"selfincellsize=%f , %f",self.flsquarePersonIssueModel.flSizeBackGroundImageSize.width,self.flsquarePersonIssueModel.flSizeBackGroundImageSize.height);
//                //通知更新
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"FLFLSquarePersonalCellSdwebImageDone" object:nil];
//            }
//        }
//    }];

}

- (CGSize)returnWarterPullImageSizeWithImageSize:(CGSize)imageSize
{
    CGSize smallSize = CGSizeZero;
    
    CGFloat proportionW =  (FLUISCREENBOUNDS.width / 2) / imageSize.width;
    FL_Log(@"sizewithtestincell=%f",proportionW);
//    CGFloat proportionH = imageSize.height /
//    smallSize.width = FLUISCREENBOUNDS.width;
//    smallSize.height = imageSize.height * proportionW;
    return smallSize;
}

@end
























