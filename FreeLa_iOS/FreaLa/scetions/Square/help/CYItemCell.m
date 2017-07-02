//
//  CYItemCell.m
//  FreeLa
//
//  Created by cy on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYItemCell.h"
#import "UIImageView+WebCache.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CYItemCell()


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressCount;

@property (weak, nonatomic) IBOutlet UIView *flProgressBaseView;
@property (weak, nonatomic) IBOutlet UILabel *flniciName;

@property (weak, nonatomic) IBOutlet UIImageView *flHeaderImage;

@property (weak, nonatomic) IBOutlet UILabel *flTimeStr;

/**progress*/
@property (nonatomic , strong) FLPerProgressView* flPerProgressView;
/**发布类型view*/
@property (weak, nonatomic) IBOutlet UIView *xjTopicTypeView;
@property (weak, nonatomic) IBOutlet UIImageView *xjFireHotImage;

@end

@implementation CYItemCell

- (void)awakeFromNib {
    self.progressView.tintColor = [UIColor colorWithHexString:XJ_FCOLOR_REDFONT];
    //    self.flniciName.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.flTimeStr.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.readCountLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.publishTypeLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.flniciName.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.progressCount.textColor  = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.flHeaderImage.layer.cornerRadius = 18;
    self.flHeaderImage.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.xjTopicTypeView.layer.cornerRadius = 10;
    self.xjTopicTypeView.layer.masksToBounds = YES;
    self.xjTopicTypeView.layer.borderColor = [UIColor colorWithHexString:@"#f3a630"].CGColor;
    self.xjTopicTypeView.layer.borderWidth = 1;
    self.publishTypeLabel.textColor = [UIColor colorWithHexString:@"#f3a630"];
    [self initPerProgressInCell];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds =  YES;
    
}

- (void)initPerProgressInCell
{
    CGRect frame = self.flProgressBaseView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _flPerProgressView =  [[FLPerProgressView alloc] initWithFrame:frame];
    _flPerProgressView.arcUnfinishColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    _flPerProgressView.arcBackColor = XJ_COLORSTR(XJ_FCOLOR_REDFONT);
    _flPerProgressView.width = 2;
    [self.flProgressBaseView addSubview:self.flPerProgressView];
}

- (void)setItemModel:(ItemModel *)itemModel{
    _itemModel = itemModel;
    
    NSString *imgUrlString = _itemModel.imageUrl;
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"business_licene_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            if (!CGSizeEqualToSize(_itemModel.imageSize, image.size)) {
                _itemModel.imageSize = image.size;
            }
            
        }
    }];
}

// 重写set方法，并给子控件赋值
- (void)setFlsquarePersonalModel:(FLSquarePersonalIssueModel *)flsquarePersonalModel{
    _flsquarePersonalModel = flsquarePersonalModel;
    
    self.categoryLabel.text       = _flsquarePersonalModel.flcateGoryStr;
    self.readCountLabel.text  = _flsquarePersonalModel.flReadNumber;
    self.titleLabel.text          = _flsquarePersonalModel.fltitle;
    self.publishTypeLabel.text      = _flsquarePersonalModel.flIssueType;
    self.flniciName.text = _flsquarePersonalModel.flNickName;
    self.progressCount.text = [NSString stringWithFormat:@"%@/%@",_flsquarePersonalModel.flTakeNumber,_flsquarePersonalModel.flPickToalNumber];
    [self.flHeaderImage sd_setImageWithURL:[NSURL URLWithString:_flsquarePersonalModel.flHeaderImageStr]];
    
    CGFloat ss                      = [_flsquarePersonalModel.flTakeNumber floatValue] / [_flsquarePersonalModel.flPickToalNumber floatValue];
    self.flPerProgressView.percent = ss;
    self.flTimeStr.text = _flsquarePersonalModel.flTimeLeftStr;
}

- (void)setXjPersonalModel:(XJVersionTwoPersonalModel *)xjPersonalModel {
    _xjPersonalModel = xjPersonalModel;
    
    self.categoryLabel.text       = _xjPersonalModel.topicTag;
    self.readCountLabel.text  = [NSString stringWithFormat:@"%ld",_xjPersonalModel.pv];
    self.titleLabel.text          = _xjPersonalModel.topicTheme;
    self.flniciName.text = _xjPersonalModel.nickName;
    self.progressCount.text = [NSString stringWithFormat:@"%ld/%ld",_xjPersonalModel.receiveNum,_xjPersonalModel.topicNum];
    [self.flHeaderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjPersonalModel.avatar isSite:NO]]] placeholderImage:[UIImage imageNamed:@"image_defaullt_wait"]];
    
    CGFloat ss                      =  _xjPersonalModel.receiveNum   / _xjPersonalModel.topicNum   ;
    self.flPerProgressView.percent = ss;
    //剩余时间  先不弄吧？？
    self.flTimeStr.text = [FLTool xjReturnHowLongOfIssue:_xjPersonalModel.createTime serviceTime:_xjPersonalModel.xjServiceTime]; //_xjPersonalModel.startTime;
    //助力抢？、
    self.publishTypeLabel.text      = [FLSquareTools returnConditionStrValueWithKey:_xjPersonalModel.topicConditionKey]  ;
    
    NSString* xjImageStr = [XJFinalTool xjReturnBigPhotoURLWithStr:_xjPersonalModel.thumbnail with: XJ_IMAGE_PUBULIU_ADD];
    if (![FLTool returnBoolWithIsHasHTTP:xjImageStr includeStr:@"http://"]&&xjImageStr) {
        xjImageStr = [FLBaseUrl stringByAppendingString:xjImageStr];
    }
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",xjImageStr]] placeholderImage:[UIImage imageNamed:@"image_defaullt_wait"]];
    if (ss ==1 || ![FLTool returnBoolNumberWithCreatTime:_xjPersonalModel.endTime xjxjTime:_xjPersonalModel.xjServiceTime]) { //||
        FL_Log(@"111111111[%@]--------2222222[%@]",_xjPersonalModel.endTime,_xjPersonalModel.xjServiceTime);
        self.xjFireHotImage.image = [UIImage imageNamed:@"icon_fire_gray_new"];
    } else {
        self.xjFireHotImage.image = [UIImage imageNamed:@"icon_fire_red_new"];
    }
    
}
+ (CGFloat)xj_bottom_h:(XJVersionTwoPersonalModel*)xjmodel   {
    //返回主题高度
    CGFloat ss = [FLTool xjReturnCellHWithWidth:(FLUISCREENBOUNDS.width / 2)-40 text:xjmodel.topicTheme fontSize:12];
    
    return ss;
}

//// 自定义Layout
//-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    _backgroundImageView.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height);
//
//}



@end











