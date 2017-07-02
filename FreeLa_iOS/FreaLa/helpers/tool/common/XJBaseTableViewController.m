//
//  XJBaseTableViewController.m
//  FreeLa
//
//  Created by Leon on 2016/10/17.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJBaseTableViewController.h"

@interface XJBaseTableViewController ()

@end

@implementation XJBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)xj_alertNumberBind {
    UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:@"操作失败" message:@"您还没有绑定手机号，不能进行此操作" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        FL_Log(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    UIAlertAction *flSureAction = [UIAlertAction actionWithTitle:@"马上去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        FL_Log(@"go to blind phone number now.");
        FLBlindWithThirdTableViewController * blindVC = [[FLBlindWithThirdTableViewController alloc] init];
        [weakSelf.navigationController pushViewController:blindVC animated:YES];
    }];
    [flAlertViewController addAction:flCancleAction];
    [flAlertViewController addAction:flSureAction];
    [self presentViewController:flAlertViewController animated:YES completion:nil];
}
- (void)xj_presentNumberBind {
    FLBlindWithThirdTableViewController * blindVC = [[FLBlindWithThirdTableViewController alloc] init];
    //    [self presentViewController:blindVC animated:YES completion:nil];
    [self.navigationController pushViewController:blindVC animated:YES];
    
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
