//
//  FLNaviBaseViewInSquare.m
//  FreeLa
//
//  Created by Leon on 15/12/15.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLNaviBaseViewInSquare.h"
#define fl_status_heigh_square              20
#define fl_navi_insquare_corlsH             fl_status_heigh_square + 10
#define fl_navi_width_margin_square         10

#define fl_address_width_square             50
#define fl_sharp_width_square               16
#define fl_issue_width_square               25
#define fl_search_bar_width_square          FLUISCREENBOUNDS.width - fl_address_width_square - fl_sharp_width_square - fl_issue_width_square - fl_navi_width_margin_square - fl_navi_width_margin_square - fl_issue_width_square
 
@interface FLNaviBaseViewInSquare()
/**旋转的尖角*/
@property (nonatomic , strong)UIImageView* flimageSharpView;
@end

@implementation FLNaviBaseViewInSquare

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self allocNaviInSquare];
        self.backgroundColor = [UIColor whiteColor];
        

        
    }
    return self;
}

- (void)changedViewColorWithAlpha:(float)alpha
{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
}

- (void)setViewHiddenWithBool:(BOOL)isUp
{
    [self setHidden:isUp];
}

- (void)allocNaviInSquare
{
    self.flAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flIssueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flimageSharpView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.flSearchBar = [[UISearchBar alloc ]init];
    self.flIssueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flsaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:self.flAddressBtn];
    [self addSubview:self.flIssueBtn];
    [self addSubview:self.flimageSharpView];
    [self addSubview:self.flSearchBar];
    [self addSubview:self.flIssueBtn];
    [self addSubview:self.flsaoBtn];
    
    [self setUpUiInSqare];
    
}

- (void)setUpUiInSqare
{
    self.flAddressBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
//    [self.flAddressBtn setBackgroundColor:[UIColor redColor]];
    [self.flAddressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.flimageSharpView.backgroundColor = [UIColor blueColor];
    self.flSearchBar.placeholder = @"搜索...";
    self.flSearchBar.backgroundColor = [UIColor whiteColor];
    self.flSearchBar.tintColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK); //光标
    self.flSearchBar.barTintColor = [UIColor whiteColor];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    self.flSearchBar.layer.borderWidth = 1;
    [self.flSearchBar.layer setBorderColor:colorref];
//    [self.flIssueBtn setImage:[UIImage imageNamed:@"bar_item_sqare_edit"] forState:UIControlStateNormal];
   
//    [self.flIssueBtn setTitle:@"发布" forState:UIControlStateNormal];
//    [self.flIssueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.flIssueBtn setImage:[UIImage imageNamed:@"icon_issue_square"] forState:UIControlStateNormal];
    self.flIssueBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [self.flsaoBtn setImage:[UIImage imageNamed:@"bar_item_sqare_saomiao"] forState:UIControlStateNormal];
       
    
    [self makeConstraintsInSquare];
}

- (void)makeConstraintsInSquare
{
    [self.flAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(fl_navi_insquare_corlsH);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(fl_address_width_square, 21));
    }];
    //sharp
    [self.flimageSharpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flAddressBtn).with.offset(0);
        make.left.equalTo(self.flAddressBtn.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(fl_sharp_width_square,fl_sharp_width_square));
    }];
    //search
    [self.flSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flAddressBtn).with.offset(0);
        make.left.equalTo(self.flimageSharpView.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(fl_search_bar_width_square,30));
    }];
    //扫描
    [self.flsaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flAddressBtn).with.offset(0);
        make.left.equalTo(self.flSearchBar.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(fl_issue_width_square,fl_issue_width_square));
    }];
    //issue
    [self.flIssueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flsaoBtn).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-fl_navi_width_margin_square);
        make.size.mas_equalTo(CGSizeMake(fl_issue_width_square,fl_issue_width_square));
    }];
    
}






@end
