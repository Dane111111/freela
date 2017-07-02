//
//  FLStartChoiceView.m
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLStartChoiceView.h"
#define  view_size_w            viewFrame.size.width / 5
#define  view_middle_margin     1

@interface FLStartChoiceView ()
/**muarray*/
@property (nonatomic , strong) NSMutableArray* flstartArr;
@end

static CGRect viewFrame;
@implementation FLStartChoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        viewFrame = frame;
        self.flstartArr = [NSMutableArray array];
        [self allocInMineSelf];
    }
    return self;
}

- (void) allocInMineSelf
{
    for (NSInteger i = 0; i < 5;  i++)
    {
        UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_gray"]];
        CGFloat  imageX =  0 + i * view_size_w + i * view_middle_margin;
        CGFloat  imageY =  0;
        CGFloat  imageW =  (viewFrame.size.width - view_middle_margin * 4) / 5;
        CGFloat  imageH =  imageW;
        image.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self addSubview:image];
        [self.flstartArr addObject:image];
    }
}

//重写set rank
- (void)setFlrank:(NSInteger)flrank
{
    _flrank = flrank;
    for (NSInteger i = 0; i < _flrank; i++) {
        UIImageView* image = self.flstartArr[i];
        image.image = [UIImage imageNamed:@"start_selected"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}

- (void)setXjIsCanBeChoice:(BOOL)xjIsCanBeChoice {
    _xjIsCanBeChoice = xjIsCanBeChoice;
    if (!_xjIsCanBeChoice) {
        self.userInteractionEnabled = NO;
    }
}

@end









