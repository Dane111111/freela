//
//  FLActivityDetailTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLActivityDetailTableViewCell.h"
#import "FLIssueNewActivityTableViewController.h"
#import "FLHeader.h"
@implementation FLActivityDetailTableViewCell

- (void)awakeFromNib
{
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.flActivitylabel = [[UILabel alloc] init];
        self.flActivitylabel.frame = CGRectMake(10, 0, 100, 30);
//        self.flActivitylabel.text = @"活动详情";
//        self.flActivitylabel.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:self.flActivitylabel];
        
//        UITextField* te = [[UITextField alloc] init];
        self.fltestTextView = [[UITextView alloc] init];
        self.fltestTextView.frame = CGRectMake(10, 30,FLUISCREENBOUNDS.width , 30);
//        self.fltestTextView.backgroundColor = [UIColor blueColor];
        self.fltestTextView.text = @"这里是富文本编辑区域、暂未完成";
//        [self.contentView addSubview:self.fltestTextView];
        self.textLabel.text = @"活动详情";
        self.textLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
     
         self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.webView = [[UIWebView alloc] initWithFrame:self.contentView.frame];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
        NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        NSString *source = [[NSBundle mainBundle] pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
        NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
        
//        [self.webView loadHTMLString:htmlString baseURL:self.baseURL];

        
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

 
}

@end
