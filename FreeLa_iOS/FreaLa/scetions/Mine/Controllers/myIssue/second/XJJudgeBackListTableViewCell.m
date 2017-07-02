//
//  XJJudgeBackListTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/3/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJJudgeBackListTableViewCell.h"

@interface XJJudgeBackListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *xjHeaderImgeVIew;
@property (weak, nonatomic) IBOutlet UILabel *xjPLNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjCreatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjContentLabel;

@end


@implementation XJJudgeBackListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.xjHeaderImgeVIew.layer.cornerRadius = 22;
    self.xjHeaderImgeVIew.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setXjModel:(XJJudgeBackModel *)xjModel {
    _xjModel = xjModel;
    [self setInfoInJudgeBackCell];
}

- (void)setInfoInJudgeBackCell{
    if ([_xjModel.replyObj rangeOfString:@"回复了"].location  != NSNotFound) {
        NSInteger index = [_xjModel.replyObj rangeOfString:@"回复了"].location;
        NSString* nameOne = [_xjModel.replyObj substringToIndex:index];
        NSString* nameTwo = [_xjModel.replyObj substringFromIndex:index + 3];
//        FL_Log(@"怎么可能会没有？====%@？  %@",nameOne,nameTwo);
        self.xjPLNickNameLabel.text = nameOne;
//        self.xjSecondName.text= nameTwo;
        self.xjContentLabel.text = _xjModel.content;
        self.xjCreatTimeLabel.text = _xjModel.createTime;
        [self.xjHeaderImgeVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjModel.avatar isSite:NO]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
    } else {
        FL_Log(@"怎么可能会没有？？");
    }
    
    
    
}

@end
