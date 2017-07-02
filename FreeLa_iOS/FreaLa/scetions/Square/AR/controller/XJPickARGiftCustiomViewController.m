//
//  XJPickARGiftCustiomViewController.m
//  FreeLa
//
//  Created by Leon on 2017/1/23.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJPickARGiftCustiomViewController.h"
#import "XJGiftGifModel.h"
#import "XJHideCustomARGiftCell.h"
/** 礼包固定库
 */
@interface XJPickARGiftCustiomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView* xjtableView;
/**缩略图的 路径*/
@property (nonatomic , strong) NSArray* dataSource;
/**线索图的路径*/
@property (nonatomic , strong) NSArray* detailSource;
/**线索图的路径*/
@property (nonatomic , strong) NSArray* xjImgPathSource;
//代理结果
/**缩略图路径*/
@property (nonatomic , strong) NSString*  flactivitytopicThumbnailStr;
/**缩略图名称*/
@property (nonatomic , strong) NSString*  flactivitytopicThumbnailFileName;
/**使用说明*/
@property (nonatomic , strong) NSString*  flactivityTopicIntroduceStr;
@end

@implementation XJPickARGiftCustiomViewController

- (instancetype)initWithDelegate:(id<XJPickARGiftCustiomViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.view.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem* sssssss = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(xjClickCancle)];
//        self.navigationController.navigationItem.leftBarButtonItem = sssssss;
        
        [self.navigationItem setLeftBarButtonItem:sssssss];
    }
    return self;
}
- (void) xjClickCancle{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"汽车超人优惠券",@"欲购优惠券",@"星舰基因",@"微赛体育"];
    self.xjImgPathSource = @[@"qiche_thumbnail",@"yugou_thumbnail",@"xingjian_thumbnaiil",@"weisai_thunbnail"];
    self.title = @"礼包库";
    [self.view addSubview:self.xjtableView];
    //self.xjtableView.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self. navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}
- (UITableView *)xjtableView {
    if (!_xjtableView) {
        _xjtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
        _xjtableView.delegate = self;
        _xjtableView.dataSource = self;
        [_xjtableView registerNib:[UINib nibWithNibName:@"XJHideCustomARGiftCell" bundle:nil] forCellReuseIdentifier:@"XJHideCustomARGiftCell"];
    }
    return _xjtableView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* ss  = self.xjImgPathSource[indexPath.item];
    UIImage* xjImage = [UIImage imageNamed:ss];
    if([XJFinalTool xjStringSafe:ss] && xjImage) {
        if ([self.delegate respondsToSelector:@selector(xjPickARGiftCustiomViewController:img:introduce:url:)]) {
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate xjPickARGiftCustiomViewController:self img:xjImage introduce:[self xj_returnIntroduceStrWithIndex:indexPath.row] url:[self xj_return_explainWithIndex:indexPath.row]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJHideCustomARGiftCell* cell = [tableView dequeueReusableCellWithIdentifier:@"XJHideCustomARGiftCell" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[XJHideCustomARGiftCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"XJHideCustomARGiftCell"];
    }
//    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.xjImgView.image = [UIImage imageNamed:self.xjImgPathSource[indexPath.row]];
    cell.xjLabel.text = self.dataSource[indexPath.row];
//    cell.detailTextLabel.text = self.detailSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(20, 0, FLUISCREENBOUNDS.width-40, 60)];
    UILabel* la = [[UILabel alloc] initWithFrame:view.frame];
    [view addSubview:la];
    la.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    la.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    la.text = @"此礼包库中的礼包为“免费啦”合作伙伴提供的新年限量版，发完即止。每人每次只能选取1个礼包送给1名好友。所有礼包使用有效期为即日起至2017.2.28";
    la.textAlignment = NSTextAlignmentCenter;
    la.numberOfLines = 4;
    return view;
}

//返回使用说明
- (NSString*)xj_returnIntroduceStrWithIndex:(NSInteger)index {
    return @[@"口令红包兑换码使用流程：\n1、输入手机号，即可领取保养券，兑换后30天内有效。\n2、选择保养，选择门店付款下单，支付订单后收到核销码短信，验证成功后提供相应服务。满299元立减100元,满199立减50元。\n3、每个用户只能使用一次。\n4、活动期间若用户发生退款，仅退还实际支付金额（不包含立减优惠金额），优惠机会不予退还或补偿；\n5、如有任何问题，请联系汽车超人客服：400-699-0000",
             @"1、线索说明：我们的Logo\n\n2、活动开始时间、结束时间、失效时间  即日起至2017年2月28日\n3、使用说明\n  a、京东旗舰店价值169元日本法藤健身运动项环，欲购券后0元，付10元邮费领取。券码兑换成功后自动生成满减券，券后用户支付10元即可。\n  b、春节假期暂停发货，期间可正常下单，2.4号恢复发货，客服电话400-8585-365。\n  c、全国发货，偏远地区需补邮费差价（偏远地区包括西藏、青海、内蒙、新疆四地） 。\n  d、领取兑换码后下载欲购APP输入兑换码下单即可。详细兑换流程见领券页面。",
             @"1、关注“星舰基因健康”微信公众号\n2、对话窗口回复“AR”，弹出领取链接\n3、每人仅限一账，且单笔仅能使用一账，不能累计使用\n4、特价商品除外。有任何问题请拨打客服电话：400-0870-521",
             @"点击链接，输入手机号和验证码，领取优惠券即可。\n红包查看：登陆微赛体育APP（新用户需下载），点击右下角“我的” 点击“我的红包”查看，\n红包使用：登陆微赛体育APP（新用户需下载）或者打开手机qq钱包—娱乐赛事票—赛事票，选择想看的比赛，支付时自动选择红包抵扣。还可以打开微信--钱包--电影演出赛事--赛事，支付时自动选择红包抵扣。\n\n特殊说明：1，红包仅限在微赛体育app（新用需下载注册）和手机qq钱包端、微信钱包端购买体育赛事票使用。\n2，每个用户限领取一张，不可与其他优惠同时使用；\n3，红包面值大于票价时，最低支付0.01元\n4，优惠券有效期截止至2017年2月28日"
    ][index];
}
//返回url
- (NSString*)xj_return_explainWithIndex:(NSInteger)index {
    return @[@"http://www.qccr.com/semsale/20160629/NewOldUserHundred/index.shtml?redbagcode=9eda95e50d034809ad29b96746cc15cb",
             @"http://h5.glela.com/act/activity_code.htm",
             @"",
             @"https://redbox.wepiao.com/index.html?pid=82a5f5681ea2440b&channelid=4&chid=2023"][index];
}


@end





