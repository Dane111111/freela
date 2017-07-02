//
//  FLMyCustomTableViewCell.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/19.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLMyCustomTableViewCell.h"
//#define FLNameFont 

@interface FLMyCustomTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *myPortraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAccountNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *myStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myChoiceImageView;    //选中状态


@end



@implementation FLMyCustomTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //添加头像
        
    }
    return  self;
}
////重写set方法
//- (void)setUserInfoModel:(FLUserInfoModel *)userInfoModel
//{
//    //传递进来的模型
//    _userInfoModel = userInfoModel;
//    //给控件赋值
//    [self settingData];
//}
//重写set方法
- (void)setUserCellModel:(FLUserCellModel *)userCellModel
{
    //传递进来的模型
    _userCellModel = userCellModel;
    //给控件赋值
    [self settingData];
}
//设置数据
- (void)settingData
{
    //头像
//    self.myPortraitImageView.image =
    //选中
    if (_userCellModel.isSelected)
    {
         self.myChoiceImageView.image = [UIImage imageNamed:@"mypublish_icon_confirm"];
    }
    else
    {
        self.myChoiceImageView.hidden = YES;
    }
   //设置昵称
    self.myNameLabel.text = _userCellModel.nikeName;
    //设置id
    self.myAccountNumberLabel.text = _userCellModel.userID;
    
    
    
}


@end










