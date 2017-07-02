//
//  JFTagListView.h
//  JFTagListView
//
//  Created by 张剑锋 on 15/11/30.
//  Copyright © 2015年 张剑锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLSelectedLabel.h"

@class JFTagListView;

//typedef enum{
//    
//    //正常状态（不可点击，单单显示）
//    TagStateNormal = 0,
//    
//    //编辑转态
//    TagStateEdit,
//    
//    //选择状态
//    TagStateSelect,
//    
//    //选择一个的状态，只能选一个变红
//    TagStateSelectOne
//
//    
//}TagStateType;
typedef enum{
    //只显示用(长按删除)
    XjTagStateTypeOnlyShow,
    // 单选
    XjTagStateTypeChoiceOne,
    // 多选
    XjTagStateTypeChoiceMore,
}XjTagStateType;


@protocol JFTagListDelegate <NSObject>

@optional

/**
 *  TagList View的高度
 *
 *  @param taglist
 *  @param listHeight 高度
 */
-(void)tagList:(JFTagListView *)taglist heightForView:(float)listHeight;

/**
 *  显示添加tag视图
 */
-(void)showAddTagView;

@required

/**
 *  点击第几个按钮
 *
 *  @param taglist
 *  @param buttonIndex 点击按钮的Index
 *  @Parm  type 1为更改颜色 2为删除
 */
-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex WithType:(NSInteger)fltype;

/**
 *  选择完毕后的数组
 */
- (void)tagList:(JFTagListView*)tagList choiceDoneWithArray:(NSArray*)flArray;


@end


@interface JFTagListView : UIView


/**
 *  背景颜色
 */
@property (nonatomic, strong) UIColor *tagViewBackgroundColor;

/**
 *  传入的Tag数组
 */
@property (nonatomic, strong) NSMutableArray *tagArr;
/**
 *  返回的Tag数组
 */
@property (nonatomic, strong) NSMutableArray *xjBackTagArr;
/**
 *  如果有选中的tag数组
 */
@property (nonatomic, strong) NSMutableArray *xjSelectedtagArr;

/**
 *  如果传入的数组的tag里包含的是字典的话，那么key是必传得，不然获取不到Value
 */
@property (nonatomic, strong) NSString *tagArrkey;

/**
 *  标签文字大小
 */
@property (nonatomic, assign) float tagFont;

/**
 *  标签文字颜色
 */
@property (nonatomic, strong) UIColor *tagTextColor;

/**
 *  标签背景颜色
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;

/**
 *  标签对齐方式
 */
@property (nonatomic) NSTextAlignment tagTextAlignment;

/**
 *  圆角的值
 */
@property (nonatomic, assign) float tagCornerRadius;

/**
 *  边框的宽度
 */
@property (nonatomic, assign) float tagBorderWidth;

/**
 *  边框的颜色
 */
@property (nonatomic, strong) UIColor *tagBorderColor;

/**
 *  状态（编辑状态下可以点击删除和选择）
 */
@property (nonatomic, assign) XjTagStateType tagStateType;
/**
 *  状态（是否可删除）
 */
@property (nonatomic, assign) BOOL xjIsCanBeDeleted;

/**
 *  是否可以添加标签（yes的时候最后一个按钮为添加按钮）
 */
@property (nonatomic, assign) BOOL is_can_addTag;

/**
 *  如果可以添加标签，那么最后一个添加按钮的title
 */
@property (nonatomic, strong) NSString *addTagStr;
/**
 *  如果删除数组，不可以删除的数组有哪些
 *  default is empty
 */
@property (nonatomic, strong) NSMutableArray *xjCanNotDeleteArr;

@property (nonatomic , assign ) CGFloat xjTagViewH;


@property (nonatomic, strong) id<JFTagListDelegate>delegate;

/**
 *  初始话UI
 *
 *  @param tagArr Tag数组
 */
-(void)creatUI:(NSMutableArray *)tagArr selectedArr:(NSMutableArray*)flselectedArr;

/**
 *  刷新数据
 *
 *  @param newTagArr 新的Tag数组
 */
- (void)reloadData:(NSMutableArray *)newTagArr;

/**
 *  刷新数据
 *
 *  @param newTagArr 新的Tag数组
 *  @param time      动画时间
 */
- (void)reloadData:(NSMutableArray *)newTagArr andTime:(float)time flselectedArr:(NSMutableArray*)flselectedArr;


@end

