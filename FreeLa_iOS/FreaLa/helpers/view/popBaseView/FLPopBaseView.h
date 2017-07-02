//
//  FLPopBaseView.h
//  FreeLa
//
//  Created by Leon on 15/12/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FLPopBaseViewDelegate.h"
typedef NS_ENUM(NSInteger,FLLengthType) {
    FLLengthTypeInteger = 0,  //限制数字
    FLLengthTypeLength,        //限制长度
};
@interface FLPopBaseView : UIView
///**自定义的label*/
//@property (nonatomic , strong) UILabel* flTitlelabel;
///**关闭*/
//@property (nonatomic , strong) UIButton* flCloseBtn;
///**确定*/
//@property (nonatomic , strong) UIButton* flSureBtn;
/**textfield or textview*/
@property (nonatomic , assign) BOOL isTextField;
/**文本框*/
@property (nonatomic , strong) UITextField* flInputTextField;
//委托对象
@property (nonatomic,assign) id<FLPopBaseViewDelegate>delegate;


/**textView*/
@property (nonatomic , strong) UITextView* xjTextView;


//创建视图
- (id)initWithTitle:(NSString *)title
           delegate:(id)delegate
  andCancleBtnTitle:(NSString *)
cancleTitle andEnsureBtnTitle:(NSString *)ensureTitle
    textFieldLength:(NSInteger)fllength
         lengthType:(FLLengthType)flLengthType
        originalStr:(NSString*)flOriginalStr;


//创建textView
- (id)initWithTitle:(NSString*)xjtitle
           delegate:(id)delegate
             length:(NSInteger)xjlength
         lengthType:(FLLengthType)xjLengthType
        originalStr:(NSString*)xjoriginalStr;

@end










