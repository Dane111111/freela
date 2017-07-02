//
//  XJJudgeTopicPJView.m
//  FreeLa
//
//  Created by Leon on 16/3/21.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJJudgeTopicPJView.h"
#import "FLStartChoiceView.h"
#import "LocalPhotoViewController.h"
#import "XJRejudgePJBcakViewController.h"

#define xj_view_top_H               70
#define xj_image_middle_margin      5
#define xj_max_image_num            3
#define xj_image_with               (FLUISCREENBOUNDS.width -20 - 5 * xj_image_middle_margin) / 4

@interface XJJudgeTopicPJView ()<UIGestureRecognizerDelegate,SelectPhotoDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    FLGrayLabel* xjPlaceholderLabel;
}
/**顶部view*/
@property (nonatomic , strong) UIView* xjTopicBaseView;
@property (nonatomic , strong) UIImageView* xjAvatorImageView;
/**星星数组*/
@property (nonatomic , strong) NSMutableArray* xjBtnsArr;
/**点了第几颗星*/
@property (nonatomic , assign) NSInteger xjBtnIndex;
/**下方view*/
@property (nonatomic , strong) UIView* xjBottomBaseView;
/**image数组 +(选前)*/
@property (nonatomic , strong) NSMutableArray* xjImagesArr;

/**closeBtn数组*/
@property (nonatomic , strong) NSMutableArray* xjCloseBtnsArr;

@end
static CGRect  xjTopViewFrame;
@implementation XJJudgeTopicPJView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.xjBtnsArr = [NSMutableArray array];
        self.xjImagesArr = [NSMutableArray array];
        self.xjCloseBtnsArr = [NSMutableArray array];
        self.xjImagesImageArr = [NSMutableArray array];
        [self xjInitPageInJudgeView];
      
    }
    return self;
}

- (void)setXjUserModel:(FLMineInfoModel *)xjUserModel {
    _xjUserModel = xjUserModel ;
    [self xjSetInfoWithModel];
}
- (void)xjSetInfoWithModel {
    [self.xjAvatorImageView sd_setImageWithURL:[NSURL URLWithString:_xjUserModel.avatar]];
}

- (void)setXjImagesStrArray:(NSMutableArray *)xjImagesStrArray {
    _xjImagesStrArray = xjImagesStrArray;
    [self xjSetImagesWithArr];
}

- (void)setXjImagesImageArr:(NSMutableArray *)xjImagesImageArr {
    _xjImagesImageArr = xjImagesImageArr;
    [self xjSetImagesWithImageArr];
    
}
- (void)xjSetImagesWithImageArr {
    NSInteger xjIndex = _xjImagesImageArr.count >= xj_max_image_num ? xj_max_image_num -1 : _xjImagesImageArr.count ;
    for (NSInteger i = 0; i < _xjImagesImageArr.count; i++) {
        UIButton* btn = self.xjImagesArr[xjIndex];
        btn.hidden = NO;
        if (self.xjImagesArr.count >i ) {
            UIImageView* image =   self.xjImagesArr[i];
            [image setImage:  _xjImagesImageArr[i] ];
        }
    }
}

- (void)xjReloadImageViewWithImageArr {
     NSInteger xjIndex = _xjImagesImageArr.count >= xj_max_image_num ? xj_max_image_num -1 : _xjImagesImageArr.count ;
     for (NSInteger i = 0; i < _xjImagesArr.count; i++) {
          UIButton* btn = self.xjImagesArr[xjIndex];
         UIImageView* image = self.xjImagesArr[i];
         if (i < _xjImagesImageArr.count) {
             btn.hidden = NO;
             [image setImage:_xjImagesImageArr[i]];
         } else {
             if (i == xjIndex) {
                 btn.hidden = NO;
                 image.hidden = NO;
                 image.image = [UIImage imageNamed:@"issue_interface_image_big"];
             } else {
//                 btn.hidden = YES;
                 image.hidden = YES;
             }
         }
  
     }
}

- (void)xjSetImagesWithArr {
    NSInteger xjIndex = _xjImagesStrArray.count >= xj_max_image_num ? xj_max_image_num -1 : _xjImagesStrArray.count ;
    for (NSInteger i = 0; i < _xjImagesStrArray.count; i++) {
        UIButton* btn = self.xjImagesArr[xjIndex];
        btn.hidden = NO;
//        UIImageView* image = self.xjImagesArr[i];
//        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FLBaseUrl,_xjImagesStrArray[i]]]];
    }
}
- (void)xjReloadImage {
    NSInteger xjIndex = _xjImagesStrArray.count >= xj_max_image_num ? xj_max_image_num -1 : _xjImagesStrArray.count ;
    for (NSInteger i = 0; i < _xjImagesArr.count; i++) {
        UIImageView* image = self.xjImagesArr[i];
        UIButton* closebtn = self.xjCloseBtnsArr[i];
        if (i < _xjImagesStrArray.count) {
            image.hidden = NO;
//            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FLBaseUrl,_xjImagesStrArray[i]]]];
        } else {
            if (i == xjIndex) {
                closebtn.hidden = YES;
                [closebtn setHidden:YES];
                image.hidden = NO;
                image.image = [UIImage imageNamed:@"issue_interface_image_big"];
                
            } else {
                image.hidden = YES;
            }
        }
        
    }
}

- (void)xjInitPageInJudgeView {
    xjTopViewFrame = CGRectMake(0, 20, FLUISCREENBOUNDS.width, xj_view_top_H);
    self.xjTopicBaseView = [[UIView alloc] initWithFrame:xjTopViewFrame];
    [self addSubview:self.xjTopicBaseView];
    self.xjAvatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, xj_view_top_H - 10, xj_view_top_H - 10)];
    [self.xjTopicBaseView addSubview:self.xjAvatorImageView];
    self.xjAvatorImageView.layer.cornerRadius = (xj_view_top_H - 10 )/ 2;
    self.xjAvatorImageView.layer.masksToBounds = YES;
    //label
    UILabel* xjlable = [[UILabel alloc] initWithFrame:CGRectMake(xj_view_top_H + 10, 5, 40, 20)];
    xjlable.text = @"评分";
    xjlable.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [self.xjTopicBaseView addSubview:xjlable];
    //btnview
    UIView* btnsView = [[UIView alloc] initWithFrame:CGRectMake(xj_view_top_H + 10, 30, 140, 20)];
    [self.xjTopicBaseView addSubview:btnsView];
     
    for (NSInteger i = 0; i < 5; i ++) {
        UIButton * image = [UIButton buttonWithType:UIButtonTypeCustom];// [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_gray"]];
        [image setBackgroundImage:[UIImage imageNamed:@"start_selected"] forState:UIControlStateNormal];
        CGFloat  imageX =  0 + i * (140 / 5) + i * 1;
        CGFloat  imageY =  0;
        CGFloat  imageW =  (140 - 1 * 4) / 5;
        CGFloat  imageH =  imageW - 3;
        image.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [btnsView addSubview:image];
//        image.backgroundColor = [UIColor redColor];
        [self.xjBtnsArr addObject:image];
        image.tag = i;
        [image addTarget:self action:@selector(clickToChooseStart:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //bottom
    self.xjBottomBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, xj_view_top_H +20, FLUISCREENBOUNDS.width -20 , 400 - xj_view_top_H -40 )];
    self.xjBottomBaseView.layer.borderWidth = 1.0f;
    self.xjBottomBaseView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self addSubview:self.xjBottomBaseView];
    //添加图片btn
    for (NSInteger i = 0 ; i< 4; i ++) {
        CGFloat xjX = xj_image_middle_margin * (i + 1) + i * xj_image_with;
        UIImageView* xjImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"issue_interface_image_big"]];
        xjImage.frame = CGRectMake(xjX, 5, xj_image_with, xj_image_with);
        [self.xjBottomBaseView addSubview:xjImage];
        [self.xjImagesArr addObject:xjImage];
        xjImage.tag = i;
        UITapGestureRecognizer* xjTapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToChooseImage:)];
        xjTapGr.delegate = self;
        xjImage.userInteractionEnabled = YES;
        [xjImage addGestureRecognizer:xjTapGr];
        if (i > 0) {
            xjImage.hidden = YES;
        }
    }
    
    //textview
    self.xjTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,xj_image_with + 10, self.xjBottomBaseView.width - 20 , self.xjBottomBaseView.height - xj_view_top_H - 20)];
    [self.xjBottomBaseView addSubview:self.xjTextView];
    self.xjTextView.delegate  =  self ;
    self.xjTextView.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    //提示信息label
    xjPlaceholderLabel = [[FLGrayLabel alloc] initWithFrame:CGRectMake(10, xj_image_with + 10, self.xjBottomBaseView.width - 20, 20)];
    xjPlaceholderLabel.userInteractionEnabled = NO;
    xjPlaceholderLabel.text = @"想说什么在这里填写吧....";
    xjPlaceholderLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [self.xjBottomBaseView addSubview:xjPlaceholderLabel];
}

- (void)clickToChooseStart:(UIButton*)xjSender {
    FL_Log(@"this is to choice bt事实上n sender=%ld",xjSender.tag);
    NSInteger xjIndex = xjSender.tag + 1;
    for (NSInteger i = 0; i < 5; i++) {
        UIButton* image = self.xjBtnsArr[i];
        if (i < xjIndex) {
            [image setBackgroundImage:[UIImage imageNamed:@"start_selected"] forState:UIControlStateNormal];
        } else {
            [image setBackgroundImage:[UIImage imageNamed:@"start_gray"] forState:UIControlStateNormal];
        }
    }
    self.xjChoiceBtnIndex = xjIndex;
}
#pragma mark 选择
- (void)clickToChooseImage:(UITapGestureRecognizer*)xjTapGr {
     LocalPhotoViewController* pick = [[LocalPhotoViewController alloc] init];
    UIImageView* xjImageView = (UIImageView*)xjTapGr.view;
    NSInteger xjSelectedTag = xjImageView.tag;
    pick.selectPhotoDelegate = self.xjVC;
    pick.isInterfaceImageType = NO;
    pick.xjMaxSelected = 3;
    pick.flisFull = self.xjImagesImageArr.count == 4 ? YES: NO;
    UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        FL_Log(@"The OkaysdaCancel alert's cancel action occured.");
    }];
    UIAlertAction *flPhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        FL_Log(@"The  copy afaction occured.");
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        picker.delegate   = self;
        picker.allowsEditing = NO;
        [self.xjVC presentViewController:picker animated:YES completion:nil];
     
    }];
    UIAlertAction *flSendAction = [UIAlertAction actionWithTitle:@"从照片中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        FL_Log(@"The  alsert's send action occured.");
        [weakSelf.xjVC.navigationController pushViewController:pick animated:YES];
    }];
    
    if (self.xjImagesImageArr.count != 0) {
        if (xjSelectedTag < self.xjImagesImageArr.count) {
            UIAlertAction *flDeleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                FL_Log(@"The  alsert's send action occured.");
                [self xjRemoveImageWithIndex:xjSelectedTag];
            }];
            [flAlertViewController addAction:flCancleAction];
            [flAlertViewController addAction:flDeleteAction];
        } else {
            FL_Log(@"???????");
            [flAlertViewController addAction:flCancleAction];
            [flAlertViewController addAction:flPhotoAction];
            [flAlertViewController addAction:flSendAction];
        }
    } else {
        [flAlertViewController addAction:flCancleAction];
        [flAlertViewController addAction:flPhotoAction];
        [flAlertViewController addAction:flSendAction];
    }
     [self.xjVC presentViewController:flAlertViewController animated:YES completion:nil];
    
    
    FL_Log(@"this is to choice btn sender=dsaf   --=-=-   imagePicker");
   
   
//    self.xjVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
}
#pragma mark 删除

- (void)actionToRemoveImage:(UIButton*)xjSender {
    [self.xjImagesStrArray removeObjectAtIndex:xjSender.tag - 10086];
//    [self.xjCloseBtnsArr removeObjectAtIndex:xjSender.tag - 10086];
    for (NSInteger i = 0 ; i < _xjImagesArr.count; i++) {
        UIImageView* btn = _xjImagesArr[i];
        [btn setHidden: YES];
    }
    [self xjReloadImage];
}

- (void)xjRemoveImageWithIndex:(NSInteger)xjIndex {
    [self.xjImagesImageArr removeObjectAtIndex:xjIndex];
    [self xjReloadImageViewWithImageArr];
}
#pragma mark 替换
- (void)clickToReplaceImage {
    
}
#pragma mark textView delegate
- (void)textViewDidChange:(UITextView *)textView {
//    self.xjTextView.text =  textView.text;
    if (textView.text.length == 0) {
        xjPlaceholderLabel.text = @"想说什么在这里填写吧....";
    }else{
        xjPlaceholderLabel.text = @"";
        
    }
}

//imagePicker did delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *editedImage, *orginalIma,*imageToUse;
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)  {
        editedImage = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        orginalIma =  (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage)  {
            imageToUse = editedImage;
        } else  {
            imageToUse = orginalIma;
        }
    }
    [self.xjImagesImageArr addObject:imageToUse];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self xjReloadImageViewWithImageArr];
    
}
//保存到本地的回调方法
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
        [[FLAppDelegate share] showHUDWithTitile:@"保存成功" view:FL_KEYWINDOW_VIEW_NEW  delay:1 offsetY:0];
    }  else  {
        NSLog(@"error occured while saving the picture%@", error);
    }
}
//改变图片尺寸，方便服务器上传
#warning 在哪儿还能遇到改变图片尺寸
//1.
-(UIImage* )scaleFromImage:(UIImage*)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#warning  回头一定要搞明白这个算法
//2.保存图片尺寸长款比，生成需要尺寸的图片
- (UIImage*)thumbnailWithImageWithoutScale:(UIImage*)image size:(CGSize)asize
{
    UIImage* newImage;
    if (nil == image)
    {
        image = nil;
    }
    else
    {
        CGSize oldSize = image.size;
        CGRect rect;
        if (asize.width / asize.height > oldSize.width / oldSize.height)
        {
            rect.size.width = asize.height * oldSize.width  / oldSize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }
        else
        {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldSize.height / oldSize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor]CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

@end













