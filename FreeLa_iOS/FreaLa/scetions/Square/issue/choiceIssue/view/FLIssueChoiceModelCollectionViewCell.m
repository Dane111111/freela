//
//  FLIssueChoiceModelCollectionViewCell.m
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLIssueChoiceModelCollectionViewCell.h"

@implementation FLIssueChoiceModelCollectionViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.flcoverView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
    self.flIssueChoiceModelName.text = @"nihao";
}

@end
