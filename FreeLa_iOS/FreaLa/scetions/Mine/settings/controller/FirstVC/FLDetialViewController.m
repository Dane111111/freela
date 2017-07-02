//
//  FLDetialViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/13.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLDetialViewController.h"
#import "FLHeader.h"

@interface FLDetialViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inPutText;


@end

@implementation FLDetialViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.inPutText becomeFirstResponder];
    self.inPutText.returnKeyType = UIReturnKeyDefault;
    self.inPutText.delegate = self;
   
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.view.frame = CGRectMake(20, 30, 300, 140);
    }
    return self;
}

- (IBAction)goBack:(id)sender
{
    
    if (![FLTool checkLengthWithString:self.inPutText.text length:1 lengthM:4 view:self.view who:@"标签"]) {}
    else
    {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)])
    {
        NSLog(@"准备回推");
        [self.inPutText resignFirstResponder];
        [self.delegate FLDetialViewController:self didInputReturnMessage:self.inPutText.text];
        NSLog(@"回推");

        [self.delegate cancelButtonClicked:self];
    }
    }
}

- (IBAction)closeBtn:(id)sender
{
    [self.inPutText resignFirstResponder];
      if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)])
      {
          [self.delegate cancelButtonClicked:self];
      }
}
- (void)sendTagToService{
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"tags\":\"%@\",\"userId\":\"%@\"}",XJ_USER_SESSION,self.inPutText.text,XJ_USERID_WITHTYPE];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        NSLog(@"上传成功data 7= %@",data);
        
    } failure:^(NSError *error) {
        NSLog(@"上传失败error = %@, == %@",error.description,error.debugDescription);
    }];
}


@end










