//
//  FLActivityDetailTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FLActivityDetailTableViewCell : UITableViewCell
/***/
@property(nonatomic , strong)UILabel* flActivitylabel;

/**textview*/
@property (nonatomic , strong)UITextView* fltestTextView;

/**webview*/
@property (nonatomic , strong)UIWebView* webView;
@end
