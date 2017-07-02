//
//  XJAnnotationView.m
//  FreeLa
//
//  Created by Leon on 2017/1/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJAnnotationView.h"

@implementation XJAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        FL_Log(@"this is the resultwww=%f  hhh=%f",self.width,self.height);
    }
    return self;
}

- (UIImageView *)xjHeaderImageView {
    if (!_xjHeaderImageView) {
        _xjHeaderImageView   = [[UIImageView alloc] init];
    }
    return _xjHeaderImageView;
}

@end
