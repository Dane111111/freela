//
//  FLAddTagsTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/23.
//  Copyright © 2015年 FreeLa. All rights reserved.



//

#import <UIKit/UIKit.h>
#import "FLHeader.h"
#import <Masonry/Masonry.h>
#import "FLTool.h"
#import "JFTagListView.h"
#import "HexColors.h"
#import "FLDetialViewController.h"
@class FLMyPersonalDateTableViewController;

@interface FLAddTagsTableViewCell : UITableViewCell 
@property (nonatomic , strong)UILabel* flSingleLabel;
 
@property (nonatomic , strong)UIView*  tagView;

@property (nonatomic , strong)NSArray* tagsArray;
//@property (nonatomic  ,strong)FLUserInfoModel* useriN;
/**用于接收controller*/
@property (nonatomic , weak)FLMyPersonalDateTableViewController*  vvvc ;
/**tagviewlist*/
@property (strong, nonatomic) JFTagListView    *tagList;     //自定义标签Viwe

@property (nonatomic , assign) float xjTagH;

/**需要的muarr*/
@property (nonatomic , strong) NSMutableArray* fltagsArrMu;
@end
