//
//  FLActivityImageTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/12/4.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLActivityImageTableViewCell.h"

@implementation FLActivityImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.flinterfaceImageView.userInteractionEnabled = YES;
    self.flOnebyOneFirst.userInteractionEnabled = YES;
    self.flOnebyOneSecond.userInteractionEnabled = YES;
    self.flOnebyOneThird.userInteractionEnabled = YES;
    self.flOnebyOneFourth.userInteractionEnabled = YES;
//    self.flScrollView.backgroundColor = [UIColor redColor];
    self.flselectedIndex = -1 ;
//    [self setImageHiddenWithIndex];
    
    self.flimageArray = @[self.flOnebyOneFirst,self.flOnebyOneSecond, self.flOnebyOneThird,self.flOnebyOneFourth];
    [self flCloseBtnSetHidden:YES withInteger:-1] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
/*
    // Configure the view for the selected state
    
    self.flheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 200)];
    self.flimageInterfaceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"issue_interface_image_big"]];
    self.flimageInterfaceImageView.frame = CGRectMake(10, 10,FL_halfWith, FL_headerViewHeigh - FL_MarginBig);
    [self.flheaderView addSubview:self.flimageInterfaceImageView];
    UILabel* labelInterface = [[UILabel alloc] initWithFrame:CGRectMake(5, FL_headerViewHeigh - 45, FL_halfWith - 10, 21)];
    labelInterface.text = @"请插入封面图(首页图片)";
    labelInterface.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    labelInterface.textAlignment = NSTextAlignmentCenter;
    labelInterface.textColor = [UIColor grayColor];
    [self.flimageInterfaceImageView addSubview:labelInterface];
    UILabel* labelThree = [[UILabel alloc] initWithFrame:CGRectMake(20 + FL_halfWith ,10, FL_halfWith - 10, 20)];
    labelThree.textColor = [UIColor grayColor];
    labelThree.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    labelThree.text = @"请插入3张详情轮播图";
    [self.flheaderView addSubview:labelThree];
    NSMutableArray* muImageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++)
    {
        UIImageView* imageView = [UIImageView new];
        [self.flheaderView addSubview:imageView];
        imageView.backgroundColor = [UIColor redColor];
        [muImageArray addObject:imageView];
    }
    self.flimageThreeArray = muImageArray.mutableCopy;
    CGRect flframeImage = labelThree.frame;
    flframeImage.origin.y += 25;
    flframeImage.size.width  = (FL_halfWith / 2) - FL_MarginBig;
    flframeImage.size.height = (FL_headerViewHeigh - 50 ) / 2;
    [self.flimageThreeArray[0] setFrame:flframeImage];
    flframeImage.origin.x = (FL_halfWith / 2) + FL_MarginBig;
    //    [self.flimageThreeArray[1] setFrame:flframeImage];
 
    
    self.tableView.tableHeaderView = self.flheaderView;
    
     */


}

 
- (void)setFlselectedIndex:(NSInteger)flselectedIndex {
    _flselectedIndex =  flselectedIndex;
//    [self setImageHiddenWithIndex];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    return self;
}

- (void) flCloseBtnSetHidden:(BOOL)hidden withInteger:(NSInteger)flinteger
{
    if (hidden) {
        [self.flCloseBtnOne setHidden:hidden];
        [self.flCloseBtnTwo setHidden:hidden];
        [self.flCloseBtnThree setHidden:hidden];
        [self.flCloseBtnFour setHidden:hidden];
    } else {
        if (flinteger == 1) {
           [self.flCloseBtnOne setHidden:hidden];
            [self.flCloseBtnTwo setHidden:!hidden];
            [self.flCloseBtnThree setHidden:!hidden];
            [self.flCloseBtnFour setHidden:!hidden];
        } else if (flinteger == 0) {
            [self.flCloseBtnOne setHidden:!hidden];
            [self.flCloseBtnTwo setHidden:!hidden];
            [self.flCloseBtnThree setHidden:!hidden];
            [self.flCloseBtnFour setHidden:!hidden];
        }else if (flinteger == 2) {
            [self.flCloseBtnOne setHidden:hidden];
            [self.flCloseBtnTwo setHidden:hidden];
            [self.flCloseBtnThree setHidden:!hidden];
            [self.flCloseBtnFour setHidden:!hidden];
        } else if (flinteger == 3) {
            [self.flCloseBtnOne setHidden:hidden];
            [self.flCloseBtnTwo setHidden:hidden];
            [self.flCloseBtnThree setHidden:hidden];
            [self.flCloseBtnFour setHidden:!hidden];
        } else if (flinteger == 4) {
            [self.flCloseBtnOne setHidden:hidden];
            [self.flCloseBtnTwo setHidden:hidden];
            [self.flCloseBtnThree setHidden:hidden];
            [self.flCloseBtnFour setHidden:hidden];
        }
    }
    
    
    
}
- (void) flViewShowWithInteger:(NSInteger)flinteger
{
    switch (flinteger) {
        case  -1:
        {
            self.flviewFour.hidden = YES;
            self.flviewThree.hidden = YES;
            self.flviewTwo.hidden = YES;
            self.flviewOne.hidden =NO;
            self.flOnebyOneFirst.image = [UIImage imageNamed:@"issue_interface_image_big"];
        }
            break;
        case  0:
        {
            self.flviewFour.hidden = YES;
            self.flviewThree.hidden = YES;
            self.flviewTwo.hidden = YES;
            self.flviewOne.hidden =NO;
            self.flOnebyOneFirst.image = [UIImage imageNamed:@"issue_interface_image_big"];
        }
            break;
        case  1:
        {
            self.flviewFour.hidden = YES;
            self.flviewThree.hidden = YES;
            self.flviewTwo.hidden = NO;
            self.flviewOne.hidden =NO;
            self.flOnebyOneSecond.image = [UIImage imageNamed:@"issue_interface_image_big"];
        }
            break;
        case  2:
        {
            self.flviewFour.hidden = YES;
            self.flviewThree.hidden = NO;
            self.flviewTwo.hidden = NO;
            self.flviewOne.hidden =NO;
            self.flOnebyOneThird.image = [UIImage imageNamed:@"issue_interface_image_big"];
        }
            break;
        case  3:
        {
            self.flviewFour.hidden = NO;
            self.flviewThree.hidden = NO;
            self.flviewTwo.hidden = NO;
            self.flviewOne.hidden =NO;
            self.flOnebyOneFourth.image = [UIImage imageNamed:@"issue_interface_image_big"];
        }
            break;
        case  4:
        {
            self.flviewFour.hidden = NO;
            self.flviewThree.hidden = NO;
            self.flviewTwo.hidden = NO;
            self.flviewOne.hidden =NO;
        }
            break;
            
        default:
            break;
    }

}

@end

















