//
//  UIView+cyExtension.m
//

#import "UIView+CYExtension.h"

@implementation UIView (CYExtension)

- (CGSize)cy_size
{
    return self.frame.size;
}

- (void)setCy_size:(CGSize)cy_size
{
    CGRect frame = self.frame;
    frame.size = cy_size;
    self.frame = frame;
}

- (CGFloat)cy_width
{
    return self.frame.size.width;
}

- (CGFloat)cy_height
{
    return self.frame.size.height;
}

- (void)setCy_width:(CGFloat)cy_width
{
    CGRect frame = self.frame;
    frame.size.width = cy_width;
    self.frame = frame;
}

- (void)setCy_height:(CGFloat)cy_height
{
    CGRect frame = self.frame;
    frame.size.height = cy_height;
    self.frame = frame;
}

- (CGFloat)cy_x
{
    return self.frame.origin.x;
}

- (void)setCy_x:(CGFloat)cy_x
{
    CGRect frame = self.frame;
    frame.origin.x = cy_x;
    self.frame = frame;
}

- (CGFloat)cy_y
{
    return self.frame.origin.y;
}

- (void)setCy_y:(CGFloat)cy_y
{
    CGRect frame = self.frame;
    frame.origin.y = cy_y;
    self.frame = frame;
}

- (CGFloat)cy_centerX
{
    return self.center.x;
}

- (void)setCy_centerX:(CGFloat)cy_centerX
{
    CGPoint center = self.center;
    center.x = cy_centerX;
    self.center = center;
}

- (CGFloat)cy_centerY
{
    return self.center.y;
}

- (void)setCy_centerY:(CGFloat)cy_centerY
{
    CGPoint center = self.center;
    center.y = cy_centerY;
    self.center = center;
}

- (CGFloat)cy_right
{
//    return self.cy_x + self.cy_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)cy_bottom
{
//    return self.cy_y + self.cy_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setCy_right:(CGFloat)cy_right
{
    self.cy_x = cy_right - self.cy_width;
}

- (void)setCy_bottom:(CGFloat)cy_bottom
{
    self.cy_y = cy_bottom - self.cy_height;
}
@end
