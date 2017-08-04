//
//  BGReview.h
//  Love500m
//
//  Created by 灵韬致胜 on 16/8/6.
//  Copyright © 2016年 LTZS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReViewProtocol
-(void)sendBtnAction;
@end
@interface BGReview : UIView
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)UIButton * sendBtn;
@property(nonatomic,strong)UILabel*sendLabel;
@property(nonatomic,strong)UIImageView*sendImageV;
@property(nonatomic,strong)id<ReViewProtocol>deletage;
@property(nonatomic,strong)UILabel * paLabel;
@property(nonatomic,strong)NSString*flFuckTopicId;
@property(nonatomic,assign)BOOL isReply;
@property(nonatomic,strong)void(^BeginEditingblock)();
-(instancetype)initWithSuperView:(UIView*)superView;
-(void)CreatUI;
@end
