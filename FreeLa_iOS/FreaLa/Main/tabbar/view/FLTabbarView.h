//
//  FLTabbarView.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLTestDDVote.h"
#import "UIView+EasyFrame.h"


@protocol FLTabbarViewDelegate <NSObject>

- (void)touchBtnAtIndex:(NSInteger)index;
- (void)launchButtonTapped:(UIButton *)btn withSelected:(BOOL)selectedState;

@end


@interface FLTabbarView : UIView

@property (nonatomic, strong) UIView   *tabbarView;
@property (nonatomic, strong) UIView   *tabbarViewCenter;

@property (nonatomic, strong) UILabel  *squareLabel;
@property (nonatomic, strong) UILabel  *voteColletionLabel;
@property (nonatomic, strong) UILabel  *launchVoteLabel;
@property (nonatomic, strong) UILabel  *friendsLabel;
@property (nonatomic, strong) UILabel  *mineLabel;

@property (nonatomic, strong) UIImageView  *squareImageview;
@property (nonatomic, strong) UIImageView  *voteColletionImageview;
@property (nonatomic, strong) UIImageView  *launchVoteImageview;
@property (nonatomic, strong) UIImageView  *friendsImageview;
@property (nonatomic, strong) UIImageView  *mineImageview;

@property (nonatomic, strong) UIButton *squareButton;
@property (nonatomic, strong) UIButton *voteColletionButton;
@property (nonatomic, strong) UIButton *launchVoteButton;
@property (nonatomic, strong) UIButton *friendsButton;
@property (nonatomic, strong) UIButton *mineButton;

- (void)btnClicked:(id)sender;

//@property (nonatomic, strong) UIImageView *plusImageview;       //发起的按钮
//@property (nonatomic, strong) UIImageView *plusBackImageview;   //发起按钮背景按钮
@property (nonatomic, assign) BOOL selectedState;           //是否选择了

@property (nonatomic, unsafe_unretained) id<FLTabbarViewDelegate> delegate;




@end





















