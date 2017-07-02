/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ApplyFriendCell.h"

@implementation ApplyFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        _headerImageView.backgroundColor = [UIColor clearColor];
        _headerImageView.clipsToBounds = YES;
        _headerImageView.layer.cornerRadius = 25;
        [self.contentView addSubview:_headerImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_contentLabel];
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 30, 15)];
        [_addButton setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:214 / 255.0 blue:167 / 255.0 alpha:1.0]];
        _addButton.layer.cornerRadius = 5;
        [_addButton setTitle:@"接受" forState:UIControlStateNormal];
        _addButton.clipsToBounds = YES;
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addButton];
        
        _refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 120, 0, 30, 15)];
        [_refuseButton setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:75 / 255.0 blue:64 / 255.0 alpha:1.0]];
        _refuseButton.layer.cornerRadius = 5;
        [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        _refuseButton.clipsToBounds = YES;
        [_refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refuseButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_refuseButton addTarget:self action:@selector(refuseFriend) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_refuseButton];
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 /255.0 blue:230 / 255.0 alpha:1];
        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _addButton.frame = CGRectMake(self.contentView.frame.size.width - 60, (self.contentView.frame.size.height - 30) / 2, 50, 30);
    _refuseButton.frame = CGRectMake(self.contentView.frame.size.width - 120, (self.contentView.frame.size.height - 30) / 2, 50, 30);
    _bottomLineView.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
    if (_contentLabel.text.length > 0) {
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 10, self.contentView.frame.size.width - 120 - (CGRectGetMaxX(_headerImageView.frame) + 10), 20);
        _contentLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), _titleLabel.frame.size.width, self.contentView.frame.size.height - 20 - _titleLabel.frame.size.height);
    }
    else{
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 10, self.contentView.frame.size.width - 120 - (CGRectGetMaxX(_headerImageView.frame) + 10), self.contentView.frame.size.height - 20);
        _contentLabel.frame = CGRectZero;
    }
}

- (void)addFriend
{
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellAddFriendAtIndexPath:)])
    {
        [_delegate applyCellAddFriendAtIndexPath:self.indexPath];
    }
}

- (void)refuseFriend
{
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellRefuseFriendAtIndexPath:)])
    {
        [_delegate applyCellRefuseFriendAtIndexPath:self.indexPath];
    }
}

+ (CGFloat)heightWithContent:(NSString *)content
{
    if (!content || content.length == 0) {
        return 60;
    }
    else{
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(320 - 60 - 120, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height > 20 ? (size.height + 40) : 60;
    }
}
- (void)setXjAdCellModel:(CYUserModel *)xjAdCellModel {
    _xjAdCellModel = xjAdCellModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjAdCellModel.avatar isSite:NO]]]];
    self.titleLabel.text = xjAdCellModel.nickname;
    if ([XJFinalTool xjStringSafe:xjAdCellModel.shortName] || [XJFinalTool xjStringSafe:xjAdCellModel.username]) {
        self.titleLabel.text = xjAdCellModel.shortName?xjAdCellModel.shortName:xjAdCellModel.username?xjAdCellModel.username:@"";
    }
    
}

- (void)setXjContentStr:(NSString *)xjContentStr {
    self.contentLabel.text =  xjContentStr;
}

@end









