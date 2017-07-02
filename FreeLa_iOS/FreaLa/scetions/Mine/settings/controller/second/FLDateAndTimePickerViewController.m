//
//  FLDateAndTimePickerViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/15.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLHeader.h"
#import <Masonry/Masonry.h>
#import "FLDateAndTimePickerViewController.h"
#define currentMonth [currentMonthString integerValue]
#import "FLUserInfoModel.h"


@interface FLDateAndTimePickerViewController ()
<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic , strong)NSString* choiceDateText;
@property (nonatomic , strong)UIPickerView* customPicker;
//@property (nonatomic , strong)UIToolbar* toolbarCancelDone;

@end

@implementation FLDateAndTimePickerViewController
{
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    //改
//    NSArray* DaysArray;
    NSArray *amPmArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpUI];
    CGRect frame = CGRectZero;
    frame.size.width = FLUISCREENBOUNDS.width;
    frame.size.height = 249;
    self.view.frame = frame;
    firstTimeLoad = YES;
    self.customPicker.hidden = YES;
//    self.toolbarCancelDone.hidden = YES;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self.customPicker reloadAllComponents];
        
    }
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
        
        NSLog(@"这个方法进来了%@ ,  %@",pickerLabel.text,[yearArray objectAtIndex:row]);
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
//        pickerLabel.text = currentMonthString;
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    else if (component == 3)
    {
        pickerLabel.text =  [hoursArray objectAtIndex:row]; // Hours
    }
    else if (component == 4)
    {
        pickerLabel.text =  [minutesArray objectAtIndex:row]; // Mins
    }
    else
    {
        pickerLabel.text =  [amPmArray objectAtIndex:row]; // AM/PM
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    { // day
        
        if (!firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        else
        {
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
    }
    else if (component == 3)
    { // hour
        
        return 12;
        
    }
    else if (component == 4)
    { // min
        return 60;
    }
    else
    { // am/pm
        return 2;
        
    }
}

- (IBAction)actionCancel:(id)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
//                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}

- (IBAction)actionDone:(id)sender
{
    
    
    self.choiceDateText = [NSString stringWithFormat:@"%@/%@/%@ -- %@ : %@ - %@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]],[hoursArray objectAtIndex:[self.customPicker selectedRowInComponent:3]],[minutesArray objectAtIndex:[self.customPicker selectedRowInComponent:4]],[amPmArray objectAtIndex:[self.customPicker selectedRowInComponent:5]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
//                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = NO;
//                         self.toolbarCancelDone.hidden = NO;
                         self.choiceDateText = @"";
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    self.customPicker.hidden = NO;
//    self.toolbarCancelDone.hidden = NO;
    self.choiceDateText = @"";
    
    
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
    
}

#pragma mark -------initUI
- (void)setUpUI
{
  
    self.choiceDateText = [NSString stringWithFormat:@"%@/%@/%@ -- %@ : %@ - %@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]],[hoursArray objectAtIndex:[self.customPicker selectedRowInComponent:3]],[minutesArray objectAtIndex:[self.customPicker selectedRowInComponent:4]],[amPmArray objectAtIndex:[self.customPicker selectedRowInComponent:5]]];
  
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView* btnAddView = [[UIView alloc]init];
    btnAddView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:btnAddView];
    [btnAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 40));
    }];
    
    UIButton* makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.userInteractionEnabled = YES;
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makeSureBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    [makeSureBtn addTarget:self action:@selector(makeSureAge) forControlEvents:UIControlEventTouchUpInside];
    [btnAddView addSubview:makeSureBtn];
    [makeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.customPicker = [[UIPickerView alloc]init];
    self.customPicker.delegate = self;
    self.customPicker.dataSource = self;
    [self.view addSubview:self.customPicker];
    [self.customPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.centerY.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width, 200));
    }];
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = NO;
                         //                         self.toolbarCancelDone.hidden = NO;
                         self.choiceDateText = @"";
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    self.customPicker.hidden = NO;
    //    self.toolbarCancelDone.hidden = NO;
    self.choiceDateText = @"";
    
    
    NSDate *date = [NSDate date];
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    FL_Log(@"year = %@   ",currentyearString);
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    // Get Current  Hour
    [formatter setDateFormat:@"h"];
    NSString *currentHourStringWithSHI = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    NSString* currentHourString = [currentHourStringWithSHI substringToIndex:1];
    // Get Current  Minutes
    [formatter setDateFormat:@"mm"];
    NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    // Get Current  AM PM
    [formatter setDateFormat:@"a"];
    NSString *currentTimeAMPMString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
#warning ------for test
    NSLog(@"ssssssssssss%@",date);
    FL_Log(@"sdadsad%@,%@,%@,%@,%@,%@",currentyearString,currentMonthString,currentDateString, currentHourString,currentMinutesString,currentTimeAMPMString);
    
    // PickerView -  Years data
#warning for test
    yearArray = [[NSMutableArray alloc]init];
    //    yearArray = [NSMutableArray array];
    for (int i = 1950; i <= 2015 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        //        NSLog(@"%@",yearArray);
    }
    
    NSArray* myYearArray = [yearArray copy];
    monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    hoursArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    // PickerView -  Hours data
    minutesArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 60; i++)
    {
        
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    // PickerView -  AM PM data
    amPmArray = @[@"AM",@"PM"];
    // PickerView -  days data
    
    DaysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 10; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"0%d",i]];
        
    }
    for (int i = 10; i <= 31; i ++) {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    // PickerView - Default Selection as per current Date
    
//        [self.customPicker selectRow:[myYearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    //    NSLog(@"sssssssssssssssssssssssssssssssssssssssssss%ld,%ld,%@,%@",(long)selectedYearRow,(long)selectedMonthRow,currentyearString);
#warning 数组返回值为-1，如何解决
    NSLog(@"ngng;sgrn= = %lu",[myYearArray indexOfObject:@"1970"]);
    NSLog(@"ssssdafgge%@",myYearArray);
   [self.customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    //
    [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    //
    [self.customPicker selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    
//    [self.customPicker selectRow:[hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
    
//    [self.customPicker selectRow:[minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
    
//    [self.customPicker selectRow:[amPmArray indexOfObject:currentTimeAMPMString] inComponent:5 animated:YES];

    
}

#pragma mark ------Actions
/**
 * view  dismiss
 */
- (void)makeSureAge
{
    NSLog(@"什么鬼");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)])
    {
        NSLog(@"准备回推");
        self.choiceDateText = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
        [self.delegate FLDateAndTimePickerViewController:self didInputReturnMessage:self.choiceDateText];
        //传参给服务器
        [self sendToService];
        NSLog(@"回推%@",self.choiceDateText);
        [self.delegate cancelButtonClicked:self];
    }
}

- (void)sendToService
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [userdefaults objectForKey:FL_USERDEFAULTS_USERID_KEY];
    NSString* sessionId = [userdefaults objectForKey:FL_NET_SESSIONID];
    NSString* parmStr = [NSString stringWithFormat:@"{\"userId\":\"%@\",\"birthday\":\"%@\",\"token\":\"%@\"}",userId,self.choiceDateText,sessionId];
    NSDictionary* parm = @{@"peruser":parmStr};
    NSLog(@"parm%@",parm);
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        NSLog(@"上传成功data 6= %@",data);
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




















