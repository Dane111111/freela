//
//  FLChangeNameViewController.m
//  FreeLa
//
//  Created by Leon on 15/11/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLChangeNameViewController.h"
#import "FLHeader.h"

@interface FLChangeNameViewController ()<FLChangeNameViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myNameText;

@end

@implementation FLChangeNameViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myNameText becomeFirstResponder];
    self.myNameText.returnKeyType = UIReturnKeyDefault;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.view.frame = CGRectMake(20, 30, 300, 140);
        if (FLFLXJIsChangeNickNameType) {
             self.flnickNameAndContactName.text = @"请填写您的昵称,最长不超过六个字";
        }
        else
        {
            self.flnickNameAndContactName.text = @"请填写新的联系人,最长不超过四个字";
        }
    }
    return self;
}

- (IBAction)clickCancle:(id)sender
{
    [self.myNameText resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)])
        [self.delegate cancelButtonClicked:self];
}
- (IBAction)makeSure:(id)sender
{
    if (!FLFLXJIsChangeNickNameType)
    {
        if (![FLTool checkLengthWithString:self.myNameText.text length:1 lengthM:8 view:self.view who:@"联系人"]) {}
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)])
            {
                NSLog(@"准备回推");
                [self.delegate FLChangeContectNameViewController:self didInputReturnMessage:self.myNameText.text];
                NSLog(@"回推");
                
                [self.delegate cancelButtonClicked:self];
            }
        }
    }
    else
    {
        if (![FLTool checkLengthWithString:self.myNameText.text length:1 lengthM:8 view:self.view who:@"昵称"]) {}
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)])
            {
                NSLog(@"准备回推");
                 [self.delegate FLChangeNameViewController:self didInputReturnMessage:self.myNameText.text];
                NSLog(@"回推");
                
                [self.delegate cancelButtonClicked:self];
            }
        }
    }
}

- (void)sendTagToService {
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"nickname\":\"%@\",\"userId\":\"%@\"}",XJ_USER_SESSION,self.myNameText.text,XJ_USERID_WITHTYPE];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        NSLog(@"上传成功data 4= %@",data);
        
    } failure:^(NSError *error) {
        NSLog(@"上传失败error = %@, == %@",error.description,error.debugDescription);
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
