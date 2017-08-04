//
//  BGReview.m
//  Love500m
//
//  Created by 灵韬致胜 on 16/8/6.
//  Copyright © 2016年 LTZS. All rights reserved.
//

#import "BGReview.h"
#import "Masonry.h"
@interface BGReview ()<UITextViewDelegate>
@property(nonatomic,strong)UIImageView*headerImageV;
/**我的信息*/
@property (nonatomic  , strong) FLMineInfoModel* flMineInfoModel;

@end
@implementation BGReview
-(instancetype)initWithSuperView:(UIView*)superView{
    if (self = [super init]) {
        [self setAllView];
        self.isReply=NO;
        [self setupUIWithSuperView:superView];
        [self seeInfoInHtmlVC];
    }
    return self;

}
- (void)seeInfoInHtmlVC
{
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"accountType":@"per"};
    FL_Log(@"see info :sesssionId   parm = %@",parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my change account test info = %@",data);
        if (data) {
            self.flMineInfoModel =  [FLMineInfoModel mj_objectWithKeyValues:data];
            [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:    [XJFinalTool xjReturnImageURLWithStr:self.flMineInfoModel.avatar isSite:NO] ]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)setIsReply:(BOOL)isReply{
    _isReply=isReply;
    if (!isReply) {
        _paLabel.hidden=NO;
        _paLabel.text=@"说点什么吧...";
    }
}
-(void)setAllView{
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.headerImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=15;
        imageV.layer.borderColor=[UIColor whiteColor].CGColor;
        imageV.layer.borderWidth=0.5;
        imageV;
    });
    
    _textView = [[UITextView alloc]init];
    _textView.backgroundColor=[UIColor clearColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderWidth = 0.5;
    _textView.textColor=[UIColor whiteColor];
    _textView.layer.borderColor = [UIColor whiteColor].CGColor;
    _paLabel=[[UILabel alloc]initWithFrame:CGRectMake(12 , 7, 120, 20)];
    _paLabel.text=@"说点什么吧...";
    _paLabel.textColor=[UIColor lightGrayColor];;
    _paLabel.font=[UIFont boldSystemFontOfSize:13];
    [_textView addSubview:_paLabel];
    self.sendBtn=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:@"fabupinglun"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"fabupinglun"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:@"111" forState:UIControlStateNormal];
//        [btn setTitle:@"000" forState:UIControlStateSelected];

        btn.titleLabel.font = [UIFont systemFontOfSize:12];

        //top left bottom right
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(14, 10, 11,23)];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 0)];
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius=15;
        btn.layer.masksToBounds=YES;
        btn.backgroundColor=[UIColor colorWithHexString:@"#ff3e3e"];
        btn;
    });
    self.sendLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor redColor];
        label.font=[UIFont systemFontOfSize:12];
        label;
    });
    self.sendImageV=({
        UIImageView*imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fabupinglun"]];
        imageV;
    });
    self.sendLabel.hidden=YES;
    self.sendImageV.hidden=YES;
    
    


}
-(void)sendAction{
    if (!self.textView.text||self.textView.text.length==0) {
        [FLTool showWith:@"请输入内容"];
        return;
    }

    [self.deletage sendBtnAction];
    self.isReply=NO;
    self.textView.text=@"";
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_sendBtn.mas_left).offset(-10);
        make.left.equalTo(self.headerImageV.mas_right).offset(5);
        make.height.mas_equalTo(34);
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
    }];

}
-(void)CreatUI{
    [self addSubview:self.headerImageV];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(7);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addSubview:_sendLabel];
    [_sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addSubview: self.sendImageV ];
    [self.sendImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15*1.316, 15));
        make.right.equalTo(_sendLabel.mas_left).offset(-5);
        make.centerY.equalTo(_sendLabel);
    }];
    [self addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_sendBtn.mas_left).offset(-10);
        make.left.equalTo(self.headerImageV.mas_right).offset(5);
        make.height.mas_equalTo(34);
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
    }];

}
-(void)setupUIWithSuperView:(UIView*)superView{

    if (superView) {
        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];

    }else{
        self.frame=CGRectMake(0, 0, DEVICE_WIDTH, 44);
    }
    [self CreatUI];
//    self.frame=CGRectMake(0, 0,kMainBoundsWidth, 44);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text hasSuffix:@"\n"]) {
        NSInteger length=textView.text.length;
        textView.text=[textView.text substringToIndex:length-1];
        if (!self.textView.text||self.textView.text.length==0) {
            [FLTool showWith:@"请输入内容"];
            return;
        }

        [self.deletage sendBtnAction];
        self.isReply=NO;
        textView.text=@"";
        [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_sendBtn.mas_left).offset(-10);
            make.left.equalTo(self.headerImageV.mas_right).offset(5);
            make.height.mas_equalTo(34);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
        }];

        return;
        
    }

    if (textView.text.length>0) {
        _paLabel.hidden = YES;
    }else{
        _paLabel.hidden = NO;
    }
//    CGSize size = [_textView.text sizeWithAttributes:@{your, font}];
//    NSString *text = self.textView.text;
//    CGSize size = [text sizeWithAttributes:@{your font} constrainedToSize:textViewSize];
//    UIFont *font = your font;
//    NSInteger lines = (NSInteger)(size.height / font.lineHeight);
    CGSize size = [_textView.text sizeWithFont:[_textView font]];
    int length = size.height;
    int colomNumber = _textView.contentSize.height/length-2;
    if (colomNumber>3) {
        colomNumber = 3;
    }
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_sendBtn.mas_left).offset(-15);
        make.left.equalTo(self.headerImageV.mas_right).offset(5);
        make.height.mas_equalTo(30 + 16*colomNumber);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];

}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if (self.BeginEditingblock) {
//        self.BeginEditingblock();
//    }
//    
//    return YES;
//}
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    return YES;
//}



@end
