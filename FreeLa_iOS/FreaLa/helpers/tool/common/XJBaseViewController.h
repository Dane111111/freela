//
//  XJBaseViewController.h
//  FreeLa
//
//  Created by Leon on 2016/10/17.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJBaseViewController : UIViewController
/**弹出 提示 绑定手机号*/
- (void)xj_alertNumberBind;
/**直接跳转半丁手机号*/
- (void)xj_presentNumberBind;
/**上传版本号*/
- (void)xj_uploadVersionNumber;
@end
