//
//  XJEmptyViewController.m
//  FreeLa
//
//  Created by Leon on 16/6/29.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJEmptyViewController.h"

@interface XJEmptyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *xjContentLabel;

@end

@implementation XJEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.xjContentLabel.text= _xjContentStr;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setXjContentStr:(NSString *)xjContentStr {
    _xjContentStr = xjContentStr;
    self.xjContentLabel.text= xjContentStr;
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
