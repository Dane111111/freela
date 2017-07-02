//
//  FLSquareTools.m
//  FreeLa
//
//  Created by Leon on 15/12/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//
#define cuizhihuaurl   @"http://192.168.20.231:8888"
#import "FLSquareTools.h"


@implementation FLSquareTools
+ (FLSquareAllFreeModel* )returnFLSquareAllFreeModel:(NSDictionary*)data WithIndex:(NSInteger)index
{
    FLSquareAllFreeModel* model = [[FLSquareAllFreeModel alloc] init];
    NSDictionary* dic =  data[FL_NET_DATA_KEY][index];
    
    model.flTopicThemeStr = dic[@"topicTheme"];
    model.flCreatTimeStr  = dic[@"newDate"];
    NSString * xjxj = [FLTool returnBigPhotoURLWithStr:dic[@"thumbnail"]];
    model.flBackGroundImageStr = [NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjxj isSite:NO]];
    FL_Log(@"model in square model =%@",model.flBackGroundImageStr);
    model.flNumberStr = [dic[@"topicNum"]stringValue];
    model.flPickupStyleStr = dic[@"topicCondition"];
    model.flinvalidTimeStr = dic[@"endTime"];
    model.flProgressStrBig = dic[@"topicNum"];
    model.flProgressStrSmall = dic[@"receiveQuantity"];
    model.flNumberStr = [dic[@"pv"] stringValue];
    model.flCategoryStr = dic[@"topicTag"];
    model.flTopicTopicId =dic[@"topicId"];
    
    return model;
}


+ (FLSquareConcouponseModel*)returnFLSquareCouponseModel:(NSDictionary*)data WithIndex:(NSInteger)index
{
    FLSquareConcouponseModel* model = [[FLSquareConcouponseModel alloc] init];
    NSDictionary* dic =  data[FL_NET_DATA_KEY][index];
    
    model.flTopicThemeStr = dic[@"topicTheme"];
    model.flCreatTimeStr  = dic[@"newDate"];
    NSString * xjxj = [FLTool returnBigPhotoURLWithStr:dic[@"thumbnail"]];
    model.flBackGroundImageStr = [NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjxj isSite:NO]];
    //    FL_Log(@"model in square model =%@",model.flBackGroundImageStr);
    model.flNumberStr = [dic[@"topicNum"]stringValue];
    model.flProgressStrAlready = [dic[@"receiveQuantity"] stringValue];
    model.flPickupStyleStr = dic[@"topicType"];
    model.flfuckStr = dic[@"topicTag"];
    
    
    return model;
}

+ (FLSquarePersonalIssueModel*)returnFLSquarePersonalIssueModel:(NSDictionary*)data WithIndex:(NSInteger)index
{
    FLSquarePersonalIssueModel* model = [[FLSquarePersonalIssueModel alloc] init];
    NSDictionary* dic =  data[FL_NET_DATA_KEY][index];
    NSString * xjxj = [FLTool returnBigPhotoURLWithStr:dic[@"thumbnail"]];
    model.flStrBackGroundImageUrl = [NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjxj isSite:NO]];
    model.flcateGoryStr =  dic[@"topicTag"];
    model.flIssueType = dic[@"topicCondition"];
    model.flReadNumber = [dic[@"pv"] stringValue];
    model.flPickToalNumber = [dic[@"topicNum"] stringValue];
    model.flTakeNumber = [dic[@"receiveQuantity"] stringValue];
    model.fltitle = dic[@"topicTheme"];
    //    FL_Log(@"made mademade made made =%@",model.flStrBackGroundImageUrl);
    model.flTimeLeftStr = [FLTool returnNumberWithStartTime:dic[@"endTime"] serviceTime:dic[@"newDate"]];
    model.flNickName = [NSString stringWithFormat:@"%@",dic[@"nickName"]];
    model.flIssueType =  [self returnConditionStrValueWithKey:dic[@"topicCondition"]];
    NSString * xxxx =  dic[@"avatar"];
    model.flHeaderImageStr = [XJFinalTool xjReturnImageURLWithStr:xxxx isSite:NO];
    
    return model;
}

+ (NSArray* )returnFLSquareAllFreeModelArray:(NSDictionary*)data WithTopicType:(NSString*)type
{
    NSArray* array = nil;
    array = data[FL_NET_DATA_KEY];
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSInteger i = 0 ; i < array.count; i++)
    {
        if ([type isEqualToString:FLFLXJSquareAllFreeStrKey])
        {
            FLSquareAllFreeModel* model =[self returnFLSquareAllFreeModel:data WithIndex:i];
            [models addObject:model];
        }
        else if ([type isEqualToString:FLFLXJSquareCouponseStrKey])
        {
            FLSquareConcouponseModel* model = [self returnFLSquareCouponseModel:data WithIndex:i];
            [models addObject:model];
        }
        else if ([type isEqualToString:FLFLXJSquarePersonStrKey])
        {
            FLSquarePersonalIssueModel* model = [self returnFLSquarePersonalIssueModel:data WithIndex:i];
            [models addObject:model];
        }
    }
    
    
    array = [models copy];
    
    return array;
}

+ (UIButton*)retutnNextBtnWithTitle:(NSString*)title
{
    UIButton* flNextButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    flNextButton.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [flNextButton setTitle:title forState:UIControlStateNormal];
    [ flNextButton setBackgroundImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forState:UIControlStateNormal];
    flNextButton.frame = CGRectMake(0, FLUISCREENBOUNDS.height- 49, FLUISCREENBOUNDS.width, 49);
    return flNextButton;
}

+ (FLIssueInfoModel*)retutnIssueInfoModelWithDic:(NSDictionary*)dic WithModel:(FLIssueInfoModel*)model;
{
    //    FLIssueInfoModel* model = [[FLIssueInfoModel alloc] init];
    NSDictionary* data = dic[@"data"];
    model.flissueActivityFromType = data[@"topicType"];
    model.flactivityMaxNumberLimit = [data[@"topicNum"] stringValue];
    model.flactivityTopicRangeStr = data[@"topicRange"];
    model.flactivityPickConditionKey = data[@"topicCondition"];
    model.flactivityTimeDiedline = data[@"endTime"];
    model.flactivityTimeBegin =  data[@"startTime"];
    model.flactivityTimeDiedline = data[@"endTime"];
    model.flactivityTimeUnderLine = data[@"invalidTime"];
    //    model.flactivitytopicThumbnailStr =
    model.flactivityTopicSubjectStr =  data[@"topicTheme"];
    model.flactivityValueOnMarket = [data[@"topicPrice"] stringValue];
    model.flactivityTopicIntroduceStr = data[@"topicExplain"];
    //    model.flactivitytopicLimitTags  = data[@""];
    model.flactivitytopicDetailStr = data[@"details"];
    model.flactivitytopicCategoryStr = data[@"topicTag"];
    model.flactivityPickRulesKey = data[@"rule"];
    model.flactivityPickRulesLimitNumberStr = data[@"lowestNum"];
    model.flactivityPickRulesStr = data[@"zlqRule"];
    model.flactivityAdress = data[@"address"];
    model.flactivityPickRulesHowNumberStr = data[@"ruleTimes"];
    model.flactivitytopicLimitTags = data[@"partInfo"];
    model.xjIssueState = [data[@"state"] integerValue];
    model.xjTopicId = [data[@"topicId"] integerValue];
    model.detailId = data[@"detailId"];
    model.hideGift = [data[@"hideGift"] integerValue];
    NSString* xjxj = data[@"tempVariate"];
    NSDictionary* xjD = [FLTool returnDictionaryWithJSONString:xjxj];
    model.xjChoiceRangDic = xjD;
 
    
    
    return model;
}



+ (NSString*)returnConditionStrValueWithKey:(NSString*)key
{
    NSString* str = nil;
    if ([key isEqualToString:FLFLXJSquareIssueHelpPick]) {
        str =  FLFLXJSquareIssueHelpPickVlaue;
    } else if ([key isEqualToString:FLFLXJSquareIssueCarePick]) {
        str =  FLFLXJSquareIssueCarePickVlaue;
    } else if ([key isEqualToString:FLFLXJSquareIssueRelayPick]) {
        str =  FLFLXJSquareIssueRelayPickVlaue;
    } else if ([key isEqualToString:FLFLXJSquareIssueNonePick]) {
        str =  FLFLXJSquareIssueNonePickVlaue;
    } else {
        if ([key rangeOfString:@"-"].location != NSNotFound) {
            NSInteger location = [key rangeOfString:@"-"].location;
            str = [key substringToIndex:location];
        } else {
            str = key;
        }
    }
    return str;
}

+(NSString* )xjReturnTypeStrWithStr:(NSString*)key {
    NSString* str = nil;
    if ([key isEqualToString:FLFLXJSquareAllFreeStrKey]) {
        str =  FLFLXJSquareAllFreeStr;
    } else if ([key isEqualToString:FLFLXJSquareCouponseStrKey]) {
        str =  FLFLXJSquareCouponseStr;
    } else if ([key isEqualToString:FLFLXJSquarePersonStrKey]) {
        str =  FLFLXJSquarePersonStr;
    } else {
        if ([key rangeOfString:@"-"].location != NSNotFound) {  //自定义
            NSInteger location = [key rangeOfString:@"-"].location;
            str = [key substringToIndex:location];
        } else {
            str = key;
        }
    }
    return str;
}
+ (NSString*)returnRankValueWithKey:(NSString*)key
{
    NSString* str = nil;
    if ([key isEqualToString:FLFLXJSquareIssueSTRANGERPick]) {
        str =  FLFLXJSquareIssueSTRANGERPickVlaue;
    } else if ([key isEqualToString:FLFLXJSquareIssueAROUNDPick]) {
        str =  FLFLXJSquareIssueAROUNDPickVlaue;
    } else if ([key isEqualToString:FLFLXJSquareIssueFRIENDPick]) {
        str =  FLFLXJSquareIssueFRIENDPickVlaue;
    } else if ([key isEqualToString:FLFLXJSquareIssueOVERTPick]) {
        str =  FLFLXJSquareIssueOVERPickVlaue;
    } else {
        str = key;
    }
    return str;
}


+ (UIColor*)flMainColorWithImage:(UIImage*)flimage{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(30, 30);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, flimage.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    CGContextRelease(context);
    
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil ) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    
    
    if ([MaxColor[0] intValue]> 230 && [MaxColor[2] intValue]> 230 && [MaxColor[3] intValue]> 230) {
        FL_Log(@"MaxColor[0]=%@=MaxColor[1]=%@=MaxColor[2]%@",MaxColor[0],MaxColor[1],MaxColor[3]);
        return [UIColor colorWithRed:(113/255.0f) green:(113/255.0f) blue:(113/255.0f) alpha:(113/255.0f)];
    } else {
        return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
    }
    //     return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}
+(BOOL)xjReturn_is_forstWithStr:(NSString*)key {
    if (!key || [key isEqualToString:@""]) {
        return NO;
    } else if ([key isEqualToString:@"FIRST"]) {
        return YES;
    }
    return NO;
}

+(NSString*)xjReturnStr_is_forstWithStr:(NSString*)key {
    if (!key || [key isEqualToString:@""]) {
        return @"什么鬼";
    } else if ([key isEqualToString:@"FIRST"]) {
        return @"先到先得";
    }
    return @"TOP* 领取";
    
}

@end







