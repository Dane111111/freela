//
//  FLRichTextViewController.h
//  FreeLa
//
//  Created by Leon on 15/12/22.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "ZSSRichTextEditor.h"
#import <UIKit/UIKit.h>
#import "FLIssueInfoModel.h"
#import "FLTool.h"

@interface FLRichTextViewController : ZSSRichTextEditor
/**发布模型*/
@property (nonatomic , weak)FLIssueInfoModel* flissueInfoModel;
@end
