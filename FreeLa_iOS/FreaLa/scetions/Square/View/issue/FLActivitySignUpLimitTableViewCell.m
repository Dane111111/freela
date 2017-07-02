//
//  FLActivitySignUpLimitTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLActivitySignUpLimitTableViewCell.h"
#import "FLHeader.h"
#import <Masonry/Masonry.h>
#import "FLIssueNewActivityTableViewController.h"
//设备屏幕尺寸
#define JF_Screen_Height       ([UIScreen mainScreen].bounds.size.height)
#define JF_Screen_Width        ([UIScreen mainScreen].bounds.size.width)



@interface FLActivitySignUpLimitTableViewCell()<JFTagListDelegate>
@property (strong, nonatomic) JFTagListView    *tagList;     //自定义标签Viwe

@property (assign, nonatomic) XjTagStateType     tagStateType; //标签的模式状态（显示、选择、编辑）


@end
@implementation FLActivitySignUpLimitTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         _tagsMuArray = @[].mutableCopy;
        _flPartInfoMuArr = @[].mutableCopy;
        _tagsMuArrNew = @[].mutableCopy;
        _tagsKeyMuArrNew = @[].mutableCopy;
        
         [self resetRandomTagsName];
        
    }
    return self;
}

//- (void)setTagsMuArray:(NSMutableArray *)tagsMuArray
//{
//    _tagsMuArray = tagsMuArray;
////    [self resetRandomTagsName];
//}
//
//- (void)setTagsMuDic:(NSMutableDictionary *)tagsMuDic
//{
//    _tagsMuDic = tagsMuDic;
////    [self resetRandomTagsName];
//}

- (void)setTagsMuArrNew:(NSMutableArray *)tagsMuArrNew{
    _tagsMuArrNew = tagsMuArrNew;
    if (_tagsMuArray.count == 0) {
        _tagsMuArray = tagsMuArrNew;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_tagsBackMuArrNew) {
//                self.tagList.flArr = _tagsBackMuArrNew;
                [self.tagList reloadData:_tagsMuArray andTime:0 flselectedArr:_tagsBackMuArrNew];
            } else {
                [self.tagList reloadData:_tagsMuArray andTime:0 flselectedArr:nil];
            }
        });
    } else {
        
    }
//     [self.tagList reloadData:_tagsMuArrNew andTime:0];
}

- (void)setFlacceptStr:(NSString *)flacceptStr
{
   
    if (_flacceptStr) {
        
    }
    else
    {
        _flacceptStr = flacceptStr;
    NSDictionary* dic = [FLTool returnDictionaryWithJSONString:_flacceptStr];
    NSArray* array  = [dic allValues];
    FL_Log(@"array  in fuck cell =%@",array);
   
    for (NSString* str in array) {
        [_tagsMuArray addObject:str];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tagList reloadData:_tagsMuArray andTime:0 flselectedArr:nil];
    });
   [self.tagList reloadData:_tagsMuArray andTime:0 flselectedArr:nil];
    }
}

- (void)resetRandomTagsName
{
//    self.tagsMuArray = [NSMutableArray arrayWithArray:@[@"姓名",@"手机号码",@"性别",@"地址"]];
     self.tagStateType = XjTagStateTypeChoiceMore;//选择模式
    CGRect frame = self.contentView.frame;
    frame.origin.y = 10;
    frame.size.width = FLUISCREENBOUNDS.width;
    frame.size.height = 140;
    //TagView
    self.tagList = [[JFTagListView alloc] initWithFrame:frame];
    self.tagList.is_can_addTag = YES;
    self.tagList.delegate = self;
    self.tagList.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
   
    [self addSubview:self.tagList];
//    self.tagList.tagBackgroundColor = [UIColor blueColor];
//    self.tagList.tagTextColor = [UIColor whiteColor];
    //以下属性是可选的
    self.tagList.tagArrkey = @"name";   //如果传的是字典的话，那么key为必传得
    self.tagList.is_can_addTag = YES;    //如果是要有最后一个按钮是添加按钮的情况，那么为Yes
    self.tagList.tagCornerRadius = 12;  //标签圆角的大小，默认10
    self.tagList.tagStateType = self.tagStateType;  //标签模式，默认显示模式
    
    //刷新数据
//    [self.tagList reloadData:_tagsMuArray andTime:0];
}

//标签的点击事件
-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex WithType:(NSInteger)fltype
{
    FL_Log(@"tagindex =%ld",buttonIndex);
//    type   1为选择  2为删除
//    switch (fltype) {
//        case 1:
//        {
//              [self changeTagColor:buttonIndex];
//        }
//            break;
//        case 2:
//        {
//            [self deleteTagRequest:buttonIndex]; //删除tag    
//        }
//            break;
//        default:
//            break;
//    }
    FL_Log(@"this is the result in the end=%@",self.tagList.tagArr);
    FL_Log(@"this is the selected result in the end =%@",self.tagList.xjSelectedtagArr);
    self.tagsMuArray = self.tagList.tagArr;
    self.tagsBackMuArrNew = self.tagList.xjSelectedtagArr;
//    self.xjTagListAllArr = self.tagList.tagArr ;
//    self.xjTagListAllSelected = self.tagList.xjSelectedtagArr;
}

#pragma mark- 删除Tag

-(void)deleteTagRequest:(NSInteger)index{
    
    FL_Log(@"代理事件3，点击第%ld个",index);
    [self.tagsMuArray removeObjectAtIndex:index];
    [self.tagList reloadData:self.tagsMuArray andTime:0  flselectedArr:nil];
}

#pragma mark 改变tag颜色
- (void)changeTagColor:(NSInteger)index{
   FL_Log(@"代理事件2，点击第%ld个",index);
//    FL_Log(@"my test biaoqian=%@",self.tagList.flArr);
//    _flPartInfoMuArr = self.tagList.flArr;
    [self.flVC.tableView reloadData];
}

-(void)showAddTagView{
    FL_Log(@"tagindex-=-=-==");
    if (self.tagList.tagArr.count >= 12) {
        [[FLAppDelegate share] showHUDWithTitile:@"最多为11项" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FLShowAddTagViewInSquare" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)relodTagsMuarray
{
//    FL_Log(@"shenme gu a adsaf=%@",self.tagList.flArr);
    NSMutableArray* arrMu = @[self.tagsMuArray.lastObject].mutableCopy;
    [arrMu addObjectsFromArray:self.tagList.xjSelectedtagArr];
    FL_Log(@"shenme gu a adsaf=%@",self.tagList.xjSelectedtagArr);
     [self.tagList reloadData:self.tagsMuArray andTime:0 flselectedArr:arrMu];
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//标签选择完毕后的数组
- (void)tagList:(JFTagListView *)tagList choiceDoneWithArray:(NSArray *)flArray addObj:(NSArray*)flObjArr
{
    NSMutableArray* arr = @[].mutableCopy;
    for (NSInteger i = 0; i < flArray.count; i++) {
        if (_tagsKeyMuArrNew.count != 0) {
           NSInteger index =  [flObjArr[i] integerValue];
            if (index >= _tagsKeyMuArrNew.count) {
                FL_Log(@"这是多的");
                [arr addObject:self.tagsMuArray[index]];
            } else {
                NSString* str = _tagsKeyMuArrNew[index];
                [arr addObject:str];
            }
        }
    }
    
    FL_Log(@"this is my final part info =%@",arr);
    NSArray* upDateArr = arr.mutableCopy;
    
    self.flVC.flissueInfoModel.flactivitytopicLimitTags = [upDateArr componentsJoinedByString:@","];
    
}

- (NSArray*)xjGetFinalSelectedArr {
    NSArray* xjarr = @[];
    xjarr = self.tagList.xjSelectedtagArr.mutableCopy;
    
    return xjarr;
}

@end












