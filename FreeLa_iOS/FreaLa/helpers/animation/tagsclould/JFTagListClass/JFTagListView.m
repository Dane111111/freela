//
//  JFTagListView.m
//  JFTagListView
//
//  Created by 张剑锋 on 15/11/30.
//  Copyright © 2015年 张剑锋. All rights reserved.
//

#import "JFTagListView.h"
#import "UIView+JFExtension.h"

#define K_Tag_Title_H_Marin         10.0f
#define K_Tag_Title_V_Marin         5.0f

#define K_Tag_Left_Margin     10.0f
#define K_Tag_Right_Margin    K_Tag_Left_Margin
#define K_Tag_Top_Margin      10.0f
#define K_Tag_Bottom_Margin   K_Tag_Top_Margin

#define Image_Width  10
#define Image_Height  Image_Width

#define KTapLabelTag       10086
#define KButtonTag         12580

#define KTagCornerWidth    10.0f
#define KTagFont           15.0f

#define flUnClickColor @"#c9c9c9"


//设备屏幕尺寸
#define JF_Screen_Height       ([UIScreen mainScreen].bounds.size.height)
#define JF_Screen_Width        ([UIScreen mainScreen].bounds.size.width - 20)


@interface JFTagListView ()<UIAlertViewDelegate>{
    
      CGRect  previousFrame ;
      float   tagView_height;
      NSInteger tagIndex;
      BOOL   xjIsCloseBtnShow;
   
}

@end

@implementation JFTagListView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (NSMutableArray *)xjBackTagArr {
      NSMutableArray* arr = self.tagArr.mutableCopy;
      [arr removeLastObject];
      return arr;
}

#pragma  mark 懒加载 不可删除数组
- (void)setXjCanNotDeleteArr:(NSMutableArray *)xjCanNotDeleteArr{
      _xjCanNotDeleteArr = xjCanNotDeleteArr ;
      //    [self reloadData:self.tagArr andTime:0 xjSelectedArr:self.xjSelectedtagArr];
}
- (void)setXjIsCanBeDeleted:(BOOL)xjIsCanBeDeleted {
      _xjIsCanBeDeleted = xjIsCanBeDeleted;
      xjIsCloseBtnShow = xjIsCanBeDeleted;
      if (!xjIsCanBeDeleted) {
            [self reloadData:self.tagArr andTime:0 flselectedArr:self.xjSelectedtagArr];
      }
}

#pragma mark- 初始化UI

-(void)creatUI:(NSMutableArray *)tagArr selectedArr:(NSMutableArray*)flselectedArr{
     
      NSString* xjAddStr = @" +          ";
      NSString* xjTemoStr = [tagArr componentsJoinedByString:@","];
      for (NSString* xjstr in flselectedArr) {
            if ([xjTemoStr rangeOfString:xjstr].location == NSNotFound) {
                  [tagArr addObject:xjstr];
            }
      }
      
      self.tagArr = [NSMutableArray arrayWithArray:[tagArr mutableCopy]];
      if (self.is_can_addTag) {//如果可以添加标签，那么数组就多一个添加标签按钮
            for (NSString* xjS in tagArr) {
                  if ([xjS isEqualToString:xjAddStr]) {
                        [self.tagArr removeObject:xjS];
                  }
            }
            [self.tagArr addObject:self.addTagStr.length>0?self.addTagStr:xjAddStr];
      }
      
      [self.tagArr removeObject:@""];
      [self.tagArr removeObject:@"(null)"];
      
      tagView_height = 0;
      
      self.backgroundColor = self.tagViewBackgroundColor?self.tagViewBackgroundColor:[UIColor whiteColor];
      
      previousFrame = CGRectZero;
      
      [self.tagArr enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
            
            //Tag标题（看传入的是字典还是字符串）
            NSMutableString *titleStr = [NSMutableString stringWithString:self.tagStateType==1?@"":@""];
            if ([value isKindOfClass:[NSString class]]) {
                  [titleStr appendString:value];
            }else if([value isKindOfClass:[NSDictionary class]]){
                  if (!self.tagArrkey) {
                        //获取不到Value，因为没传入Key
                        NSLog(@"获取不到Value，因为没传入Key");
                        return ;
                  }
                  [titleStr appendString:[value valueForKey:self.tagArrkey]];
            }
            
            FLSelectedLabel *tagLabel = [[FLSelectedLabel alloc]initWithFrame:CGRectZero selected:NO];
            tagLabel.text = titleStr;
            tagLabel.tag = KTapLabelTag+idx;
            
            if (self.xjCanNotDeleteArr && self.xjCanNotDeleteArr.count ==0) {
                  tagLabel.xjIsCanBeDeleted = YES;
            } else {
                  if (self.xjCanNotDeleteArr.count > idx) {
                        tagLabel.xjIsCanBeDeleted = NO;
                  } else {
                        tagLabel.xjIsCanBeDeleted = YES;
                  }
            }
            
            for (NSString* str in flselectedArr) {
                  if ([str isEqualToString:tagLabel.text] && self.tagStateType != XjTagStateTypeOnlyShow) {
                        tagLabel.flselected = YES;
                  } else {
                        
                  }
            }
            //          tagLabel.flselected = NO;
            if (idx < self.tagArr.count -1) {
                  if (tagLabel.flselected) {
                        [self creatTagUI:tagLabel backcolor:[UIColor colorWithHexString:XJ_FCOLOR_REDBACK] titleColor:[UIColor whiteColor]];
                  } else {
                        [self creatTagUI:tagLabel backcolor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:flUnClickColor]];
                  }
            } else {
                  [self creatTagUI:tagLabel backcolor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:flUnClickColor]];
            }
            
            //计算label的大小
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:self.tagFont?self.tagFont:KTagFont]};
            CGSize Size_str = [titleStr sizeWithAttributes:attrs];
            Size_str.width += K_Tag_Title_H_Marin*2;
            Size_str.height += K_Tag_Title_V_Marin*2;
            
            CGRect newRect = CGRectZero;
            CGFloat si = previousFrame.origin.x + previousFrame.size.width + Size_str.width + K_Tag_Right_Margin;
            CGFloat sii = JF_Screen_Width - 40 ;
            //          FL_Log(@"thsi is my test si - sii =%f ,,, ,,,si=%f ,,,,sii =%f",si - sii ,si ,sii);
            if (si > sii) {
                              FLFLXJUserTagHFloatValueIsAddOne = YES;  //tag H add 35
            } else  if (si < sii) {
                              FLFLXJUserTagHFloatValueIsAddOne = NO;
            }
            
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + K_Tag_Right_Margin > JF_Screen_Width) {
                  
                  newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + K_Tag_Bottom_Margin);
                  tagView_height += Size_str.height + K_Tag_Bottom_Margin;
            }
            else {
                  newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + K_Tag_Right_Margin, previousFrame.origin.y);
                  
            }
            newRect.size = Size_str;
            [tagLabel setFrame:newRect];
            previousFrame=tagLabel.frame;
            
            //改变控件高度
            if (idx==self.tagArr.count-1 && self.tagStateType == XjTagStateTypeOnlyShow) {
                  NSLog(@"this is bottom height with tag=%f",tagView_height+Size_str.height + K_Tag_Bottom_Margin);
                  FL_Log(@"this is bottom height with tag=%f",tagView_height+Size_str.height + K_Tag_Bottom_Margin);
                  FLFLXJUserTagHFloatValue = tagView_height+Size_str.height + K_Tag_Bottom_Margin ;
                  NSString * hhh = [NSString stringWithFormat:@"%f",tagView_height+Size_str.height + K_Tag_Bottom_Margin];
                  [[NSUserDefaults standardUserDefaults] setObject:hhh forKey:FL_TAGS_HEIGHT_KEY];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  [self setHight:self andHight:tagView_height+Size_str.height + K_Tag_Bottom_Margin];
                  if ([self.delegate respondsToSelector:@selector(tagList:heightForView:)]) {
                        [self.delegate tagList:self heightForView:hhh.floatValue];
                  }
                  if ([hhh rangeOfString:@"."].location != NSNotFound) {
                        NSInteger i = [hhh rangeOfString:@"."].location;
                        hhh = [hhh substringToIndex:i];
                        self.xjTagViewH = [hhh floatValue];
                  } else {
                     self.xjTagViewH = [hhh floatValue];
                  }
            }
            tagLabel.userInteractionEnabled = YES;
            [self addSubview:tagLabel];
            
            //新增删除、添加功能
            if (self.is_can_addTag&&idx==self.tagArr.count-1) {//能添加状态&&最后一个-->(进入添加tag界面不用显示删除图片)
                  
            } else {//if(_xjIsCanBeDeleted){
                  //            if (tagLabel.xjIsCanBeDeleted) {
                  /**
                   * 长安手势
                   */
                  UILongPressGestureRecognizer* loongGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showCloseBtn:)];
                  loongGr.minimumPressDuration = 1.0;
                  [self addGestureRecognizer:loongGr];
                  //            }
            }
            //点击按钮
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tagLabel.frame.origin.x, tagLabel.frame.origin.y, tagLabel.frame.size.width, tagLabel.frame.size.height)];
            [button setTag:KButtonTag+idx];
            [button addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
      }];
      self.xjSelectedtagArr = [self xjReturnSelectedArrWithTagArr];
}

#pragma mark 长按手势
- (void) showCloseBtn:(UILongPressGestureRecognizer* )longGr {
      //    self.tagStateType = XjTagStateTypeDelete;
      self.xjIsCanBeDeleted = YES;
      NSMutableArray* labelMu = @[].mutableCopy;
      for (NSInteger i = 0; i < _tagArr.count - 1; i++) {
            FLSelectedLabel* tagLabel= [self viewWithTag:i  + KTapLabelTag];
            if (tagLabel.xjIsCanBeDeleted) {
                  [labelMu addObject:tagLabel];
                  UIImageView *removeImage = [[UIImageView alloc] initWithFrame:CGRectMake(tagLabel.jf_right-Image_Width*1.5, tagLabel.jf_top+(tagLabel.jf_height-Image_Height)/2, Image_Width, Image_Height)];
                  //删除图片可以换成自己的图片
                  removeImage.image = [UIImage imageNamed:@"btn_removeTag"];
                  [self addSubview:removeImage];
            }
      }
}


//初始化Tag的UI
-(void)creatTagUI:(UILabel *)tagLabel backcolor:(UIColor*)flbackcolor titleColor:(UIColor*)fltitlecolor{
    
      tagLabel.backgroundColor = flbackcolor ;
    
      tagLabel.textAlignment = NSTextAlignmentCenter;//self.tagStateType==1?NSTextAlignmentLeft:NSTextAlignmentCenter;
    
      tagLabel.textColor = fltitlecolor ?fltitlecolor:[UIColor blackColor];
    
      tagLabel.font = [UIFont systemFontOfSize:self.tagFont?self.tagFont:KTagFont];
    
      tagLabel.layer.cornerRadius = self.tagCornerRadius?self.tagCornerRadius:KTagCornerWidth;
      tagLabel.layer.masksToBounds = YES;
    
      tagLabel.layer.borderColor = [fltitlecolor CGColor];
    
      tagLabel.layer.borderWidth = self.tagBorderWidth?self.tagBorderWidth:1;

      tagLabel.clipsToBounds = YES;
//      FL_Log(@"s什么鬼UI啊什么股i");
}

#pragma mark- 改变控件高度

- (void)setHight:(UIView *)view andHight:(CGFloat)height
{
    [UIView animateWithDuration:0.0 animations:^{
        CGRect tempFrame = view.frame;
        tempFrame.size.height = height;
        view.frame = tempFrame;
        if ([self.delegate respondsToSelector:@selector(tagList:heightForView:)]) {
            [self.delegate tagList:self heightForView:height];
        }
    }];
}

#pragma mark- 刷新数据

//刷新数据（默认时间0.5秒）
- (void)reloadData:(NSMutableArray *)newTagArr{
    
    [self reloadData:newTagArr andTime:0.5 flselectedArr:nil];
}

//刷新数据（时间为time）
- (void)reloadData:(NSMutableArray *)newTagArr andTime:(float)time flselectedArr:(NSMutableArray*)flselectedArr{
    
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [UIView animateWithDuration:time animations:^{
            self.alpha = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [self creatUI:newTagArr selectedArr:flselectedArr];
            });
        }];
    }];
}

#pragma mark- 点击事件
- (void)clickTag:(UIButton *)sender{
      
      if (![XJFinalTool xj_is_phoneNumberBlind]) {
            [FLTool showWith:@"请先绑定手机号"];
            return;
      }
      tagIndex = sender.tag - KButtonTag;
      FLSelectedLabel* label= [self viewWithTag:tagIndex + KTapLabelTag];
      NSLog(@"this is the function to click the tag %ld",tagIndex);
      if (self.is_can_addTag) {
            if (tagIndex == self.tagArr.count-1) {
                  //进入添加Tag的界面
                  if ([self.delegate respondsToSelector:@selector(showAddTagView)]) {
                        if (self.xjIsCanBeDeleted) {
                              self.xjIsCanBeDeleted = NO;
                        }
                        if (self.tagStateType == XjTagStateTypeChoiceOne) {
                              //单选模式，设置数组为空
                              self.xjSelectedtagArr = [self xjReturnSelectedArrWithTagArr];
                              if (self.xjSelectedtagArr.count!=0) {
                                    [self.xjSelectedtagArr removeAllObjects];
                                    [self reloadData:self.tagArr andTime:0 flselectedArr:self.xjSelectedtagArr];
                              }
                        }
                        [self.delegate showAddTagView];
                  }else{
                        FL_Log(@"没有实现这个代理方法");
                  }
                  return;
            }
      }
      
      if (xjIsCloseBtnShow) {
            if ([self.delegate respondsToSelector:@selector(tagList:clickedButtonAtIndex:WithType:)]) {
                  [self creatTagUI:label backcolor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:flUnClickColor]];
                  NSMutableArray* xjTempArr=self.tagArr.mutableCopy;
                  for (NSInteger i = 0; i < xjTempArr.count; i++) {
                        if ([label.text isEqualToString:xjTempArr[i]]) {
                              [self.tagArr removeObjectAtIndex:i];
                              [self.delegate tagList:self clickedButtonAtIndex:tagIndex WithType:2];
                        }
                  }
                  self.xjIsCanBeDeleted = NO;
                  [self reloadData:self.tagArr andTime:0 flselectedArr:self.xjSelectedtagArr];
            }
      } else {
            if ([self.delegate respondsToSelector:@selector(tagList:clickedButtonAtIndex:WithType:)]) {
                  if (self.tagStateType == XjTagStateTypeOnlyShow) {
                        NSLog(@"个性标签");
                  } else if (self.tagStateType == XjTagStateTypeChoiceOne) {
                        NSLog(@"单选");
                        NSMutableArray* labelMu = @[].mutableCopy;
                        if ([self.delegate respondsToSelector:@selector(tagList:clickedButtonAtIndex:WithType:)]){
                              for (NSInteger i = 0; i < _tagArr.count - 1; i++) {
                                    FLSelectedLabel* labels= [self viewWithTag:i + KTapLabelTag];
                                    [labelMu addObject:labels];
                              }
                              for (NSInteger i = 0; i < labelMu.count; i ++) {
                                    FLSelectedLabel* label= labelMu[i];
                                    if (i == tagIndex) {
                                          if (label.flselected) {
                                                [self creatTagUI:label backcolor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:flUnClickColor]];
                                                label.flselected = NO;
                                                [self.delegate tagList:self clickedButtonAtIndex:tagIndex WithType:1];
                                          } else {
                                                [self creatTagUI:label backcolor:[UIColor colorWithHexString:XJ_FCOLOR_REDBACK] titleColor:[UIColor whiteColor]];
                                                label.flselected = YES;
                                                [self.delegate tagList:self clickedButtonAtIndex:tagIndex WithType:1];
                                          }
                                    } else {
                                          [self creatTagUI:label backcolor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:flUnClickColor]];
                                          label.flselected = NO;
                                    }
                              }
                              self.xjSelectedtagArr = [self xjReturnSelectedArrWithTagArr];
                              [self.delegate tagList:self clickedButtonAtIndex:tagIndex WithType:1];
                        }
                        
                  } else if (self.tagStateType == XjTagStateTypeChoiceMore) {
                        NSLog(@"多选");
                        if (label.flselected) {
                              [self creatTagUI:label backcolor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:flUnClickColor]];
                              for (NSInteger i = 0; i < self.tagArr.count; i++) {
                                    if ([label.text isEqualToString:self.tagArr[i]]) {
                                          label.flselected = NO;
                                          self.xjSelectedtagArr = [self xjReturnSelectedArrWithTagArr];
                                          [self.delegate tagList:self clickedButtonAtIndex:tagIndex WithType:1];
                                    }
                              }
                        } else {
                              [self creatTagUI:label backcolor:[UIColor colorWithHexString:XJ_FCOLOR_REDBACK] titleColor:[UIColor whiteColor]];
                              label.flselected = YES;
                              self.xjSelectedtagArr = [self xjReturnSelectedArrWithTagArr];
                              [self.delegate tagList:self clickedButtonAtIndex:tagIndex WithType:1];
                        }
                         NSLog(@"多选送达大厦打打算打的阿斯顿按时===%@",self.xjSelectedtagArr);
                  }
            }
      }
}

- (NSMutableArray*)xjReturnSelectedArrWithTagArr {
      NSMutableArray* xjSelectedMuArr = @[].mutableCopy;
      for (NSInteger i =0; i < self.tagArr.count; i++) {
            FLSelectedLabel* label= [self viewWithTag:i + KTapLabelTag];
            if (label.flselected) {
                  [xjSelectedMuArr addObject:label.text];
            }
      }
      return xjSelectedMuArr;
}

#pragma mark- AlertView 代理

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        //删除tag
        [self.delegate tagList:self clickedButtonAtIndex:tagIndex WithType:2]; //2 为删除
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
