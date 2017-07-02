//
//  FLIssueChoiceModelViewController.m
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLIssueChoiceModelViewController.h"

@interface FLIssueChoiceModelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/**collectionView*/
@property (nonatomic , strong)UICollectionView* flchoiceModelCollectionView;
/**下一步按钮*/
@property (nonatomic , strong)UIButton* flNextButton;
@end

@implementation FLIssueChoiceModelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择发布类型";
//    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
   
    [self setUpUIInFlIssueChoiceModelVC];
    [self addHeaderAndFoorterInchoiceModelVC];
    
    self.flNextButton = [FLSquareTools retutnNextBtnWithTitle:@"下一步"];
    [self.flNextButton addTarget:self action:@selector(goToNextIssueStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flNextButton];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
   
}

#pragma mark ---get model
- (void)setFlissueInfoModel:(FLIssueInfoModel *)flissueInfoModel
{
    _flissueInfoModel = flissueInfoModel;
}

#pragma mark -----Actions
- (void)goToNextIssueStep
{
    //发布简洁版
    FLIssueNewActivityTableViewController* simpleVC   = [[FLIssueNewActivityTableViewController alloc] init];
    simpleVC.flissueInfoModel = self.flissueInfoModel;
    simpleVC.flPartInfoDeliverToThirdVCStr = self.flPartInfoDeliverToThirdVCStr;
    [self.navigationController pushViewController:simpleVC animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma  mark ----init UI
- (void)setUpUIInFlIssueChoiceModelVC
{
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    self.flchoiceModelCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) collectionViewLayout:flowLayout];
    [self.flchoiceModelCollectionView registerNib:[UINib nibWithNibName:@"FLIssueChoiceModelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FLIssueChoiceModelCollectionViewCell"];
    self.flchoiceModelCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.flchoiceModelCollectionView.delegate =self;
    self.flchoiceModelCollectionView.dataSource = self;
    flowLayout.itemSize = CGSizeMake(90, 90);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.headerReferenceSize = CGSizeMake(FLUISCREENBOUNDS.width, 30);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.view addSubview:self.flchoiceModelCollectionView];
    
}

- (void)addHeaderAndFoorterInchoiceModelVC
{
    [self.flchoiceModelCollectionView registerClass:[FLIssueChoiceModelSectionOneView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FLIssueChoiceModelSectionOneView"];
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLIssueChoiceModelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FLIssueChoiceModelCollectionViewCell" forIndexPath:indexPath];
    if(indexPath.section==0)
    {
        if (indexPath.row == 0)
        {
            if (indexPath.item == 0)
            {
                cell.flIssueChoiceModelName.text = @"简洁版";
            }
            
        }
        cell.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    }
    else if(indexPath.section==1)
    {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.myArray removeObjectAtIndex:indexPath.row];
    
//    [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if (indexPath.item == 0)
            {
                //发布简洁版
                [self goToNextIssueStep];
            }
        }
    }
    
    
    FL_Log(@"index path in choice model =%@",indexPath);
    

}

#pragma mark -----headerview

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    if (section == 0) {
        size = CGSizeMake(240, 60);//{240,60};
    }
    else
    {
        size = CGSizeMake(240, 30);
    }
    
    return size;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FLIssueChoiceModelSectionOneView* headerViewOne;
    if ([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headerViewOne = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FLIssueChoiceModelSectionOneView" forIndexPath:indexPath];
        if (indexPath.section == 0)
        {
             
            return headerViewOne;
        }
        else
        {
            [headerViewOne setDownLabel:nil];
            return headerViewOne;
        }
        
    }
    else if([kind isEqual:UICollectionElementKindSectionFooter])
    {
         return headerViewOne;
    }
    else
    {
        return headerViewOne;
    }
}



@end












