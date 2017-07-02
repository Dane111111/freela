//
//  XJTicketHTMLViewController.h
//  FreeLa
//
//  Created by Leon on 16/3/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJTicketHTMLViewController : UIViewController
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;
/**请求时间id*/

/**标记跳来的index*/
@property (nonatomic , assign) NSInteger xjIndexToPop;
@end
