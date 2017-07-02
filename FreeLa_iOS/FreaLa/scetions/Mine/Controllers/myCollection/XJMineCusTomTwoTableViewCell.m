//
//  XJMineCusTomTwoTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/3/9.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMineCusTomTwoTableViewCell.h"

@implementation XJMineCusTomTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.xjPJBtn.layer.cornerRadius = 4;
    self.xjPJBtn.layer.masksToBounds=YES;
    self.xjPJBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.xjPJBtn.layer.borderWidth =.5f;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.xjimageView.layer.cornerRadius = 6;
    self.xjimageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setXjWeaitPJModel:(XJMyWeaitPJModel *)xjWeaitPJModel
{
    _xjWeaitPJModel = xjWeaitPJModel;
    [self setInfoInCustomTwoWithIndex:4]; // 4为待评价的
}

-(void)setInfoInCustomTwoWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            FL_Log(@"这儿什么也没有");
        }
            break;
        case 4:
        {
            FL_Log(@"这儿是待评价的");
            [self.xjimageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjWeaitPJModel.flMineIssueBackGroundImageStr isSite:NO]]]];
            self.xjNameLabel.text = _xjWeaitPJModel.flMineTopicThemStr;
            self.xjTimeLabel.text =  [NSString stringWithFormat:@"参与时间:%@",_xjWeaitPJModel.flTimeBegan ? _xjWeaitPJModel.flTimeBegan :@"服务器没有返回"];
        }
            break;
            
        default:
            break;
    }
    
}





@end
