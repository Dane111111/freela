//
//  FLRichTextViewController.m
//  FreeLa
//
//  Created by Leon on 15/12/22.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLRichTextViewController.h"

@interface FLRichTextViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation FLRichTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"请填写活动详情";
    //    self.view.frame = CGRectMake(0, 400, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - StatusBar_NaviHeight);
    //    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
    // HTML Content to set in the editor
    //    NSString *html = @"<!-- This is an HTML comment -->"
    //    "<p>This is a test of the <strong>ZSSRichTextEditor</strong> by <a title=\"Zed Said\" href=\"http://www.zedsaid.com\">Zed Said Studio</a></p>";
    if (_flissueInfoModel.flactivitytopicDetailStr) {
        //        NSString* html = [NSString stringWithFormat:@"<!-- This is an HTML comment -->"
        //                          "<p> %@</p>",_flissueInfoModel.flactivitytopicDetailStr];
        
        
        NSString* html = [NSString stringWithFormat:@"<p>%@</p>",_flissueInfoModel.flactivitytopicDetailStr];
        [self setHTML:html];
    }
    //
    //    // Set the base URL if you would like to use relative links, such as to images.,
    //
    //    // Set the HTML contents of the editor
    
    self.baseURL = [NSURL URLWithString:@"http://www.zedsaid.com"];
    self.shouldShowKeyboard = NO;
    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarInsertImage, ZSSRichTextEditorToolbarH1,ZSSRichTextEditorToolbarH2,ZSSRichTextEditorToolbarH3,ZSSRichTextEditorToolbarBold,ZSSRichTextEditorToolbarJustifyLeft,ZSSRichTextEditorToolbarJustifyCenter,ZSSRichTextEditorToolbarJustifyRight,ZSSRichTextEditorToolbarTextColor,ZSSRichTextEditorToolbarUnderline,ZSSRichTextEditorToolbarItalic,ZSSRichTextEditorToolbarViewSource];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showInsertImageAlternatePicker {
    
    [self dismissAlertView];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"我直接牛逼了" );
    UIActionSheet* actionSheet  = [[UIActionSheet alloc]initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"从相册选取", nil];
    [actionSheet showInView:self.view];
    
}

- (void)setFlissueInfoModel:(FLIssueInfoModel *)flissueInfoModel
{
    _flissueInfoModel = flissueInfoModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//保存html
- (void)exportHTML
{
    [self.view endEditing:YES];
    FL_Log(@"%@", [self getHTML]);
    NSString* xjStr = [self getHTML];
    if(!xjStr || [xjStr isEqualToString:@"<p></p>"]||[xjStr isEqualToString:@"<p> </p>"] || [xjStr isEqualToString:@""]) {
        [FLTool showWith:@"图文详情不能为空"];
        return;
    }
    
    if ([xjStr rangeOfString:FLBaseUrl].location != NSNotFound) {
        NSMutableString* xjMu = [NSMutableString stringWithString:xjStr];
        xjStr = [xjMu stringByReplacingOccurrencesOfString:FLBaseUrl withString:@""];
    }
    
    self.flissueInfoModel.flactivitytopicDetailStr = xjStr;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //       拍照
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        picker.delegate   = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        //        相册
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        //设置图片源(相册)
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate   = self;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        //设置可以编辑
        picker.allowsEditing = NO;
        //打开拾取界面
        [self presentViewController:picker animated:YES completion:nil];
    }
    //    else if(buttonIndex == 2)
    //    {
    //        NSLog(@"取消");
    //    }
}

//imagePicker did delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *editedImage, *orginalIma,*imageToUse ,*imageToLook;
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        editedImage = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        orginalIma =  (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage)
        {
            imageToUse = editedImage;
        }else
        {
            imageToUse = orginalIma;
        }
        CGSize imageSize = CGSizeZero;
        if (imageToUse.size.width/imageToUse.size.height > 1) {
            imageSize = CGSizeMake(250, 200);
        }
        else
        {
            imageSize = CGSizeMake(200, 250);
        }
        
        //更改image大小
        imageToUse = [self returnNeedImageSize:imageToUse ];
        //用户看到的图
        CGFloat ff = imageToUse.size.width / imageToUse.size.height;
        NSString* str = [NSString stringWithFormat:@"%f",ff];
        [self sendImageToService: imageToUse wAndH:str];
        
    }
    NSLog(@"消失之前");
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"消失之后");
    
}

- (void)sendImageToService:(UIImage*)imagetouse wAndH:(NSString*)xjStr {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [FLNetTool xjUploadTWDetailImage:imagetouse  success:^(NSDictionary *data) {
            if ([[data objectForKey:@"message"] isEqualToString:@"OK"]) {
                //成功，拼接图片url地址
                NSString* str = [NSString stringWithFormat:@"%@%@",FLBaseUrl,data[@"result"]];
                FL_Log(@"image str in richtext =%@",str);
                //调用inset方法
                [self insertImage:str alt:@"" xjWandH:xjStr];
            }
        } failure:^(NSError *error) {
            
        }];
    });
}

- (UIImage*)returnNeedImageSize:(UIImage*)flimage
{
    CGFloat ff ;
    CGSize flsize ;
    
    if (flimage.size.width > FLUISCREENBOUNDS.width) {
        ff =    flimage.size.width / FLUISCREENBOUNDS.width ;
        flsize  = CGSizeMake(FLUISCREENBOUNDS.width, flimage.size.height / ff);
    } else if (flimage.size.width < FLUISCREENBOUNDS.width) {
        ff =    FLUISCREENBOUNDS.width /flimage.size.width;
        flsize  = CGSizeMake(FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height * ff);
    } else if (flimage.size.width == FLUISCREENBOUNDS.width) {
        
    }
    flimage = [FLTool thumbnailWithImageWithoutScale:flimage size:flsize];
    return flimage;
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










