//
//  FLActivitySignUpLimitTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTagListView.h"
@class FLIssueNewActivityTableViewController;
 
@interface FLActivitySignUpLimitTableViewCell : UITableViewCell
/**标签内容数组*/
@property (nonatomic , strong)NSMutableArray* tagsMuArray;
/**标签内容字典*/
@property (nonatomic , strong)NSMutableDictionary* tagsMuDic;

/**接收VC 的 str*/
@property (nonatomic , strong)NSString* flacceptStr;
/**VC*/
@property (nonatomic , weak) FLIssueNewActivityTableViewController* flVC;

/**partInfo*/
@property (nonatomic , strong) NSMutableArray* flPartInfoMuArr;

/**value 数组*/
@property (nonatomic , strong) NSMutableArray* tagsMuArrNew;
/**key 数组*/
@property (nonatomic , strong) NSMutableArray* tagsKeyMuArrNew;

/**回填 数组(选中的)*/
@property (nonatomic , strong) NSMutableArray* tagsBackMuArrNew;
 

- (void)relodTagsMuarray;

- (NSArray*)xjGetFinalSelectedArr;

@end
