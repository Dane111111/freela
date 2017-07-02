//
//  CustomCalloutView.m
//  iOS_3D_ClusterAnnotation
//
//  Created by PC on 15/7/9.
//  Copyright (c) 2015年 FENGSHENG. All rights reserved.
//

#import "CustomCalloutView.h"
#import "ClusterTableViewCell.h"

#import "XJClusterTableViewCell.h"


const NSInteger kArrorHeight = 10;
const NSInteger kCornerRadius = 6;

const NSInteger kWidth = 260;
const NSInteger kMaxHeight = 240;

const NSInteger kTableViewMargin = 4;
const NSInteger kCellHeight = 60;


@interface CustomCalloutView()

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic , strong) UIImageView* xjBaseImgView;

@end

@implementation CustomCalloutView

- (void)setPoiArray:(NSArray *)poiArrayy
{
    _poiArray = [NSArray arrayWithArray:poiArrayy];
    CGFloat totalHeight = kCellHeight * self.poiArray.count + kArrorHeight + 2 *kTableViewMargin + 60;
    CGFloat height = MIN(totalHeight, kMaxHeight);

    self.frame = CGRectMake(0, 0, kWidth, height);
    
    self.tableview.frame = CGRectMake(10, 30, kWidth -20 , height - 50);
    self.xjBaseImgView.frame = CGRectMake(-10,-10, kWidth+10,height);
    [self setNeedsDisplay];
    [self.tableview reloadData];
}

- (void)dismissCalloutView
{
    self.poiArray = nil;
    [self removeFromSuperview];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"XJClusterTableViewCell";
    XJClusterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell  == nil)
    {
        cell = [[XJClusterTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:identifier];
    }

    AMapCloudPOI *poi = [self.poiArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = poi.name;
//    cell.detailTextLabel.text = poi.address;
    cell.xjTitleLaebl.text = poi.name;
    if ([XJFinalTool xjStringSafe:poi.address]) {
        cell.xjDetailLabel.text = poi.address;
        if ([poi.address rangeOfString:@"区"].location != NSNotFound) {//去掉区之前的字
            NSInteger xj_i = [poi.address rangeOfString:@"区"].location;
            if (poi.address.length>xj_i+1) {
                NSString* ss = [poi.address substringFromIndex:xj_i+1];
                cell.xjDetailLabel.text = ss;
            }
        }
    }
    NSString* header =  [XJFinalTool xjReturnImageURLWithStr:[NSString stringWithFormat:@"%@",poi.customFields[@"topicPublisherIcon"]] isSite:NO];
    [cell.xjHeaderImgView sd_setImageWithURL:[NSURL URLWithString:header] placeholderImage:[UIImage imageNamed:@"xj_default_avator"]];
    
    [cell.tapBtn addTarget:self action:@selector(detailBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    cell.tapBtn.tag = indexPath.row;
    
    return cell;
}

#pragma mark - TapGesture

- (void)detailBtnTap:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didDetailButtonTapped:)])
    {
        [self.delegate didDetailButtonTapped:button.tag];
    }
}

#pragma mark - draw rect

//- (void)drawRect:(CGRect)rect
//{
//    [self drawInContext:UIGraphicsGetCurrentContext()];
//    
//    self.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//}

//- (void)drawInContext:(CGContextRef)context
//{
//    CGContextSetLineWidth(context, 3.0);
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor);
//    
//    [self drawPath:context];
//    CGContextFillPath(context);
//}

//- (void)drawPath:(CGContextRef)context
//{
//    CGRect rrect = self.bounds;
//    CGFloat radius = kCornerRadius;
//    CGFloat minx = CGRectGetMinX(rrect),
//    midx = CGRectGetMidX(rrect),
//    maxx = CGRectGetMaxX(rrect);
//    CGFloat miny = CGRectGetMinY(rrect),
//    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
//    
//    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
//    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
//    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
//
//    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
//    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx+kArrorHeight, maxy, radius);
//    CGContextClosePath(context);
//}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        self.xjBaseImgView = [[UIImageView alloc] init];
        self.xjBaseImgView.image = [UIImage imageNamed:@"ar_bg"];
        [self addSubview:self.xjBaseImgView];
        
        
        self.tableview = [[UITableView alloc] init];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        self.tableview.backgroundColor =  [UIColor clearColor];
        [self addSubview:self.tableview];
         self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.tableview registerNib:[UINib nibWithNibName:@"XJClusterTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJClusterTableViewCell"];
        
    }
    return self;
}



@end
