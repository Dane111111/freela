//
//  XJRejudgePJBcakViewController.m
//  FreeLa
//
//  Created by Leon on 16/3/14.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJRejudgePJBcakViewController.h"
#import "XJJudgeTopicPJView.h"
#import "LocalPhotoViewController.h"
#import <Foundation/NSObject.h>

@interface XJRejudgePJBcakViewController ()<SelectPhotoDelegate>
{
    NSInteger _flupdateImageOneStrat;
}
/**imageArr*/
@property (nonatomic , strong) NSMutableArray* xjImagesArr;
/**imageArr*/
@property (nonatomic , strong) NSMutableArray* xjImagesFileNameArr;
/**imageStrArr*/
@property (nonatomic , strong) NSMutableArray* xjImagesStrArr;
@property (nonatomic , strong)  XJJudgeTopicPJView*  xjJudgeView;
@end

@implementation XJRejudgePJBcakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setNaViPage];
    [self xjInitPageInPJView];
    self.xjImagesArr = [NSMutableArray array];
    self.xjImagesStrArr = [NSMutableArray array];
    self.xjImagesFileNameArr = [NSMutableArray array];
    _flupdateImageOneStrat = 0;
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clickdone:)];
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickdone:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                                           target:self
//                                                                                           action:@selector(clickdone:)];
}

- (void)clickdone:(UIButton*)xjSender {
    
    if (![self xjCheckInfoInJudgeVC]) return; //checkInfo
    if (self.xjImagesArr.count != 0) {
        [[FLAppDelegate share] showSimplleHUDWithTitle:@"请稍后" view:FL_KEYWINDOW_VIEW_NEW];
        if (self.xjImagesArr.count > 3) {
            NSArray* xjArr = [self.xjImagesArr subarrayWithRange:NSMakeRange(0, 3)];
            self.xjImagesArr = xjArr.mutableCopy;
        }
        [self xjupdateMorePicWithArr:self.xjImagesArr];
    } else {
        [self xjUpDateMyPJInfo];
    }
    
}

- (void)xjUpDateMyPJInfo {
    FL_Log(@"this is the action to save pj");
    NSArray* xjArr = self.xjImagesStrArr.mutableCopy;
    NSArray* testArr = self.xjImagesFileNameArr.mutableCopy;
    NSString* xjImagesStr = [xjArr componentsJoinedByString:@","];
    NSString* test = [testArr componentsJoinedByString:@","];
    
    NSString* parmDic = [NSString stringWithFormat:@"{\"businessId\":\"%@\",\"commentType\":\"%@\",\"content\":\"%@\",\"parentId\":\"%@\",\"imgUrls\":\"%@\",\"rank\":\"%ld\"}",_xjWeaiPJModel.flMineIssueTopicIdStr,@"1",self.xjJudgeView.xjTextView.text ? self.xjJudgeView.xjTextView.text : @"",_xjWeaiPJModel.flDetailsIdStr ? _xjWeaiPJModel.flDetailsIdStr : @"0",testArr.count == 0 ? @"":test,(long)self.xjJudgeView.xjChoiceBtnIndex];
    
    //插入评论记录
//    NSDictionary* dic = @{@"businessId":_xjWeaiPJModel.flMineIssueTopicIdStr,
//                          @"commentType":@"1",   //1代表评价
//                          @"content":self.xjJudgeView.xjTextView.text ? self.xjJudgeView.xjTextView.text : @"",
//                          @"parentId":_xjWeaiPJModel.flDetailsIdStr ? _xjWeaiPJModel.flDetailsIdStr : @"0",
//                          @"imgUrls":xjArr.count == 0 ? @"":xjImagesStr};
    NSDictionary* parm = @{ @"commentPara":parmDic,
                            @"userType": XJ_USERTYPE_WITHTYPE,
                            @"userId":XJ_USERID_WITHTYPE};
    [FLNetTool HTMLinsertCommentByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result with pjdata=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            if ([self.delegate performSelector:@selector(xjRefreshWeatPJListController)]) {
                [self.delegate xjRefreshWeatPJListController];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)xjCheckInfoInJudgeVC {
    if (!self.xjJudgeView.xjTextView.text || [self.xjJudgeView.xjTextView.text isEqualToString:@""]) {
        [FLTool showWith:@"请填写评论内容"];
        return NO;
    } else if (!self.xjJudgeView.xjChoiceBtnIndex ) {
//        [FLTool showWith:@"请选择评分"];
        self.xjJudgeView.xjChoiceBtnIndex = 5;
        return YES;
    } else {
        return YES;
    }
}

- (void)setNaViPage {
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.title = @"评价";
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
}

- (void)xjInitPageInPJView {
    self.xjJudgeView = [[XJJudgeTopicPJView alloc] initWithFrame:CGRectMake(0, StatusBar_NaviHeight + 5 , FLUISCREENBOUNDS.width, 400)];
     __weak typeof(self) weakSelf = self;
    self.xjJudgeView.xjVC = weakSelf;
    self.xjJudgeView.xjUserModel = self.xjUserModel;
    [self.view addSubview:self.xjJudgeView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self setNaViPage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNaViPage];
}
- (void)getSelectedPhoto:(NSMutableArray *)photos {
    if (photos.count != 0) {
        
         dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQuene, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showSimplleHUDWithTitle:@"请稍后" view:FL_KEYWINDOW_VIEW_NEW];
                for (NSInteger i = 0; i < photos.count; i++) {
                    UIImage*image = [FLTool returnPhotoWithPhotos:photos AndIndex:i];
                    [self.xjImagesArr addObject:image];
                    self.xjJudgeView.xjImagesImageArr = self.xjImagesArr;
                    dispatch_async(dispatch_get_main_queue(), ^{
                    if (i == photos.count - 1) {
                        [[FLAppDelegate share] hideHUD];
                    }
                         });
                }
            });
           
        });
//        [self xjupdateMorePicWithArr:self.xjImagesArr];
//        self.xjJudgeView.xjImagesImageArr = self.xjImagesArr;
    }
}

- (void)xjupdateMorePicWithArr:(NSMutableArray* )flmuarr {
    NSDictionary* parm = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID],
                           @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:FL_USERDEFAULTS_USERID_KEY],
                           
                           };
    if (_flupdateImageOneStrat == flmuarr.count) {
        FL_Log(@"上传从这里停止2");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FLAppDelegate share] hideHUD];
            [self xjUpDateMyPJInfo]; //上传
        });
        return;
    } else {
        [FLNetTool xjUploadPJCommentsImage:flmuarr[_flupdateImageOneStrat] parm:parm success:^(NSDictionary *data) {
            FL_Log(@"成功nnnnnnnnnn = %@",data);
            if ([[data objectForKey:@"message"] isEqualToString:@"OK"]) {
                _flupdateImageOneStrat ++;
                NSString* str = data[@"result"];
                NSString* fileNaem = data[@"filename"];
                [self.xjImagesStrArr addObject:str];
                self.xjJudgeView.xjImagesStrArray = self.xjImagesStrArr;
                [self.xjImagesFileNameArr addObject:fileNaem];
                [self xjupdateMorePicWithArr:self.xjImagesArr];
            }
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] hideHUD];
            });
        }];
    }
}


@end









