//
//  FLActivityImageTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/12/4.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLActivityImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flinterfaceImageView;

/**image数组*/
@property (nonatomic , strong)NSArray* flimageArray;

/**imageUrl*/
@property (nonatomic , strong) NSMutableArray* flimageUrlArr;

@property (weak, nonatomic) IBOutlet UIImageView *flOnebyOneFirst;

@property (weak, nonatomic) IBOutlet UIImageView *flOnebyOneSecond;

@property (weak, nonatomic) IBOutlet UIImageView *flOnebyOneThird;
@property (weak, nonatomic) IBOutlet UIImageView *flOnebyOneFourth;

@property (weak, nonatomic) IBOutlet UIScrollView *flScrollView;
@property (weak, nonatomic) IBOutlet UILabel *xjTipsLabel;



@property (weak, nonatomic) IBOutlet UIView *flviewOne;
@property (weak, nonatomic) IBOutlet UIView *flviewTwo;
@property (weak, nonatomic) IBOutlet UIView *flviewThree;
@property (weak, nonatomic) IBOutlet UIView *flviewFour;



/**选中哪一个*/
@property (nonatomic , assign) NSInteger flselectedIndex;
/**关闭按钮*/
@property (weak, nonatomic) IBOutlet UIButton *flCloseBtnOne;
@property (weak, nonatomic) IBOutlet UIButton *flCloseBtnTwo;
@property (weak, nonatomic) IBOutlet UIButton *flCloseBtnThree;
@property (weak, nonatomic) IBOutlet UIButton *flCloseBtnFour;

/**关闭按钮*/
- (void) flCloseBtnSetHidden:(BOOL)hidden withInteger:(NSInteger)flinteger;

/**显示添加按钮*/
- (void) flViewShowWithInteger:(NSInteger)flinteger;

@end












