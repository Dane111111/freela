//
//  FLSexChoiceTableViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/15.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLSexChoiceTableViewController.h"
#import "FLHeader.h"

#define sessionId   [userdefaults objectForKey:FL_NET_SESSIONID]
#define my_userId   [userdefaults objectForKey:FL_USERDEFAULTS_USERID_KEY]

@interface FLSexChoiceTableViewController ()
{
    NSInteger _selectedCell; // 选中了 谁
    NSArray  *_array;
}


@end

@implementation FLSexChoiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"女";
          
            break;
        case 1:
            cell.textLabel.text = @"男";
           
            break;
        case 2:
            cell.textLabel.text = @"保密";
            break;
        
        default:
            break;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 10;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
          _selectedCell = 0;
        NSLog(@"my sex is women %ld",_selectedCell);
        
    }
   else if (indexPath.row == 1)
    {
         _selectedCell = 1;
        NSLog(@"my sex is men");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   else
   {
       NSLog(@"can not tell u ");
           _selectedCell = 2;
       [self dismissViewControllerAnimated:YES completion:nil];
   }
    _array = [[NSArray alloc]initWithObjects:@"女",@"男",@"保密", nil];
    NSLog(@"%@    %@",_array,_array[indexPath.row] );
    [self.delegate FLSexChoiceTableViewController:self myChoice:_array[indexPath.row]];
    //传参给服务器
    [self sendToService];
    
    

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendToService
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"sex\":\"%ld\",\"userId\":\"%@\"}",sessionId,(long)_selectedCell,my_userId];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        NSLog(@"上传成功data 9= %@",data);
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












