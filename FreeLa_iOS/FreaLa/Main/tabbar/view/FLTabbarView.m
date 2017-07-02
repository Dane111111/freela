//
//  FLTabbarView.m
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLTabbarView.h"



#define TAB_BAR_HIGHT           (40 * DDTabbarMul)
#define TAB_BAR_TALL_HEIGHT     (49 * DDTabbarMul)
#define TAB_BAR_WIDTH           (60.0 * DDScreenWidth / 320.0)
#define TAB_BAR_BASE_BUTTON_TAG 2000
#define TAB_BAR_BASE_LABEL_TAG  3000
#define TAB_BAR_BASE_IMAGE_TAG  4000

@implementation FLTabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self setFrame:frame];
        [self layoutView];
        
    }
    return self;
}

-(void)layoutView
{
    //
    _tabbarView                    = [[UIView alloc] initWithFrame:CGRectMake(0, 9 * DDTabbarMul, self.frame.size.width, TAB_BAR_HIGHT)];
    _tabbarView.autoresizingMask   = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _tabbarView.backgroundColor    = [UIColor clearColor];
    
    CGFloat originX                = 0.f;
    
    UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(0, 9 * DDTabbarMul, self.frame.size.width, 40 * DDTabbarMul)];
    wView.backgroundColor = [UIColor whiteColor];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, self.frame.size.width, 0                                            )];
    bView.backgroundColor = DDColor(234, 235, 234, 1);
    
    
    /**
     *  广场的label 和 button
     */
    _squareButton                  = [self buttonWithFrame:CGRectMake(originX, 0
                                                                      
                                                                      , TAB_BAR_WIDTH, TAB_BAR_HIGHT) andIndex:0];
    _squareButton.backgroundColor = [UIColor clearColor];
    _squareImageview               = [self imageWithFrame:CGRectMake(originX+18 * DDTabbarMul, 1 * DDTabbarMul, 24 * DDTabbarMul, 24 * DDTabbarMul) andIndex:0];
    _squareImageview.centerX = _squareButton.x + _squareButton.width / 2;
    _squareLabel                   = [self labelwithFrame:CGRectMake(originX, CGRectGetMaxY(_squareImageview.frame), TAB_BAR_WIDTH, 14 * DDTabbarMul) withText:@"发现" withStyle:0 withIndex:0];
    originX                        += TAB_BAR_WIDTH;
    
    /**
     *  票夹的label 和 button
     */
    _voteColletionButton           = [self buttonWithFrame:CGRectMake(originX, 0, TAB_BAR_WIDTH, TAB_BAR_HIGHT) andIndex:1];
    _voteColletionButton.backgroundColor = [UIColor clearColor];
    _voteColletionImageview        = [self imageWithFrame:CGRectMake(originX+18 * DDTabbarMul, 1 * DDTabbarMul, 24 * DDTabbarMul, 24 * DDTabbarMul) andIndex:1];
    _voteColletionImageview.centerX = _voteColletionButton.x + _voteColletionButton.width / 2;
    _voteColletionLabel            = [self labelwithFrame:CGRectMake(originX, CGRectGetMaxY(_voteColletionImageview.frame), TAB_BAR_WIDTH, 14  * DDTabbarMul) withText:@"免费圈" withStyle:0 withIndex:1];
    originX                        += TAB_BAR_WIDTH;
    
    /**
     *  发起:加到最外面的view上 label 和 button
     */
    CGFloat centerViewWidth = DDScreenWidth - 4 * TAB_BAR_WIDTH;
    _tabbarViewCenter              = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, centerViewWidth, self.frame.size.height)];
    _tabbarViewCenter.backgroundColor = [UIColor clearColor];
    originX                        += centerViewWidth;
    
    
    
    _launchVoteButton              = [self buttonWithFrame:_tabbarViewCenter.bounds andIndex:2];
    
//    _plusBackImageview             = [[UIImageView alloc] initWithFrame:_tabbarViewCenter.bounds];
//    _plusBackImageview.image       = [UIImage imageNamed:@"ic_home BG"];
    
    CGRect frame                   = CGRectMake(26, 14, 28 * DDTabbarMul, 28 * DDTabbarMul );
    frame.origin.x = centerViewWidth / 2 - frame.size.width / 2;
    
//    _plusImageview                 = [[UIImageView alloc] initWithFrame:frame];
//    _plusImageview.image           = [UIImage imageNamed:@"ic_home"];
//    _plusImageview.centerX = _tabbarViewCenter.width / 2;
//    _plusImageview.centerY = self.height * 0.6;
    
//    [_tabbarViewCenter addSubview:_plusBackImageview];
//    [_tabbarViewCenter addSubview:_plusImageview];
    [_tabbarViewCenter addSubview:_launchVoteButton];
    
    /**
     *  票友的label 和 button
     */
    _friendsButton                 = [self buttonWithFrame:CGRectMake(originX, 0, TAB_BAR_WIDTH, TAB_BAR_HIGHT) andIndex:3];
    _friendsButton.backgroundColor = [UIColor clearColor];
    _friendsImageview              = [self imageWithFrame:CGRectMake(originX+18 * DDTabbarMul, 1 * DDTabbarMul, 24* DDTabbarMul, 24 * DDTabbarMul) andIndex:3];
    _friendsImageview.centerX = _friendsButton.x + _friendsButton.width / 2;
    _friendsLabel                  = [self labelwithFrame:CGRectMake(originX, CGRectGetMaxY(_friendsImageview.frame), TAB_BAR_WIDTH, 14 * DDTabbarMul) withText:@"朋友圈" withStyle:0 withIndex:3];
    originX                        += TAB_BAR_WIDTH;
    
    /**
     *  我的的label 和 button
     */
    _mineButton                    = [self buttonWithFrame:CGRectMake(originX, 0, TAB_BAR_WIDTH, TAB_BAR_HIGHT) andIndex:4];
    _mineButton.backgroundColor = [UIColor clearColor];
    _mineImageview                 = [self imageWithFrame:CGRectMake(originX+18 * DDTabbarMul, 1 * DDTabbarMul, 24 * DDTabbarMul, 24 * DDTabbarMul) andIndex:4];
    _mineImageview.centerX = _mineButton.x + _mineButton.width /2 ;
    _mineLabel                     = [self labelwithFrame:CGRectMake(originX, CGRectGetMaxY(_mineImageview.frame), TAB_BAR_WIDTH, 14 * DDTabbarMul) withText:@"我的" withStyle:0 withIndex:4];
    
    [_tabbarView addSubview:_squareLabel];
    [_tabbarView addSubview:_squareImageview];
    [_tabbarView addSubview:_squareButton];
    
    [_tabbarView addSubview:_voteColletionLabel];
    [_tabbarView addSubview:_voteColletionImageview];
    [_tabbarView addSubview:_voteColletionButton];
    
    [_tabbarView addSubview:_friendsLabel];
    [_tabbarView addSubview:_friendsImageview];
    [_tabbarView addSubview:_friendsButton];
    
    [_tabbarView addSubview:_mineLabel];
    [_tabbarView addSubview:_mineImageview];
    [_tabbarView addSubview:_mineButton];
    
    [self addSubview:bView];
    [self addSubview:wView];
    [self addSubview:_tabbarView];
    [self addSubview:_tabbarViewCenter];
    
    [self setTextColorOfIndex:0];
}

/**
 *  点击不同的按钮去显示不同的ViewController
 *
 *  @param sender 不同的按钮
 */
-(void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag - TAB_BAR_BASE_BUTTON_TAG) {
        case 0:
            [self removeMask];
            [self.delegate touchBtnAtIndex:0];
            [self setTextColorOfIndex:0];
            break;
        case 1:
            [self removeMask];
            [self.delegate touchBtnAtIndex:1];
            [self setTextColorOfIndex:1];
            break;
        case 2:
            if (self.delegate && [self.delegate respondsToSelector:@selector(launchButtonTapped:withSelected:)]) {
                [self.delegate launchButtonTapped:_launchVoteButton withSelected:_selectedState];
            }
            _selectedState = !_selectedState;
            break;
        case 3:
            [self removeMask];
            [self.delegate touchBtnAtIndex:3];
            [self setTextColorOfIndex:3];
            break;
        case 4:
            [self removeMask];
            [self.delegate touchBtnAtIndex:4];
            [self setTextColorOfIndex:4];
            break;
        default:
            break;
    }
}

- (void)removeMask {
    if (_selectedState) {
        [self btnClicked:_launchVoteButton];
    }
}

/**
 *  显示5个不同的tabbar的文字
 *
 *  @param frame 出现的位置
 *  @param title 显示的文字
 *  @param style style == 1 为中间的类型, style == 0 为其他的类型
 *
 *  @return 显示的label
 */
- (UILabel *)labelwithFrame:(CGRect)frame withText:(NSString *)title withStyle:(int)style withIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.tag = TAB_BAR_BASE_LABEL_TAG + index;
    label.font = [UIFont boldSystemFontOfSize:(12 * DDTabbarMul)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = DDColor(160, 171, 176, 1);
    return label;
}

- (void)setTextColorOfIndex:(NSInteger)index {
    for (int i = 0; i < 5; i ++) {
        UILabel *label = (UILabel *)[self viewWithTag:TAB_BAR_BASE_LABEL_TAG+i];
        UIImageView *iv = (UIImageView *)[self viewWithTag:TAB_BAR_BASE_IMAGE_TAG + i];
        if (i == index) {
            label.textColor = [UIColor colorWithRed:91/255. green:203/255. blue:184/255. alpha:1];
            iv.image = [self imageSelectedWIthIndex:i];
        } else {
            label.textColor = [UIColor lightGrayColor];
            iv.image = [self imageWIthIndex:i];
        }
    }
}

/**
 *  显示5个不同的tabbar的不透明按钮
 *
 *  @param frame 出现的位置
 *  @param index 序号, 体现在 tag上
 *
 *  @return Button
 */
- (UIButton *)buttonWithFrame:(CGRect)frame andIndex:(NSInteger)index {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = frame;
    btn.tag = TAB_BAR_BASE_BUTTON_TAG + index;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIImageView *)imageWithFrame:(CGRect)frame andIndex:(NSInteger)index
{
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
    iv.image = [self imageWIthIndex:index];
    iv.tag = TAB_BAR_BASE_IMAGE_TAG + index;
    return iv;
}

- (UIImage *)imageWIthIndex:(NSInteger)index
{
    UIImage *image = nil;
    switch (index) {
        case 0:
            image = [UIImage imageNamed:@"ic_piazza"];
            break;
        case 1:
            image = [UIImage imageNamed:@"ic_coupon booklet"];
            break;
        case 3:
            image = [UIImage imageNamed:@"ic_users"];
            break;
        case 4:
            image = [UIImage imageNamed:@"ic_user"];
            break;
        default:
            break;
    }
    return image;
}

- (UIImage *)imageSelectedWIthIndex:(NSInteger)index
{
    UIImage *image = nil;
    switch (index) {
        case 0:
            image = [UIImage imageNamed:@"ic_piazza select"];
            break;
        case 1:
            image = [UIImage imageNamed:@"ic_coupon booklet select"];
            break;
        case 3:
            image = [UIImage imageNamed:@"ic_users select"];
            break;
        case 4:
            image = [UIImage imageNamed:@"ic_user select"];
            break;
        default:
            break;
    }
    return image;
}




@end




















