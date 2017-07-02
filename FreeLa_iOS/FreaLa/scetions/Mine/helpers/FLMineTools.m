//
//  FLMineTools.m
//  FreeLa
//
//  Created by Leon on 15/12/24.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLMineTools.h"
#import "FLTool.h"

//评价列表的宏
//#import "FLMyIssueJudgePJTableViewCell.h"
#define view_left_Margin        25
#define view_middle_Margin      5
#define view_header_width_H     60
#define view_top_Margin         5
#define view_image_how_N        3

#define label_size_font_M       12
#define label_size_font_S       10
#define startView_size_H        15 
#define startView_size_W        80

#define fl_image_size_W         ((FLUISCREENBOUNDS.width - 2 * view_left_Margin - (view_image_how_N -1) * view_middle_Margin) / view_image_how_N)

#define view_total_H           view_header_width_H +



@implementation FLMineTools
+ (NSArray* )returnMyIssueInMineModelsWithDictionary:(NSDictionary*)dic type:(NSInteger)indexPage
{
    NSArray* array = dic[FL_NET_DATA_KEY];
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:array.count];
    
    switch (indexPage) {
        case 1:
        {
            for (NSInteger i = 0; i < array.count; i ++ )
            {
                FLMyIssueInMineModel* model = [self returnMyIssueInMineModelsWithDictionary:dic  Andindex:i];
                [models addObject:model];
            }
        }
        break;
        case 2:
        {
            for (NSInteger i = 0; i < array.count; i ++ )
            {
                FLMyReceiveListModel* model = [self returnMyReceiveInMineModelsWithDictionary:dic  Andindex:i];
                [models addObject:model];
            }
        }
        break;
        case 3:
        {
            for (NSInteger i = 0; i < array.count; i ++ )
            {
                XJMyPartInInfoModel* model = [self returnMyPartInInfoModelsWithDictionary:dic andIndex:i];
                [models addObject:model];
            }
        }
            break;
        case 4:
        {
            for (NSInteger i = 0; i < array.count; i ++ )
            {
                XJMyWeaitPJModel* model = [self returnMyXJMyWeaitPJModelsWithDictionary:dic andIndex:i];
                [models addObject:model];
            }
        }
            break;
        default:
        break;
    }
    
    array = [models mutableCopy];
    return array;
}
//我发布的
+ (FLMyIssueInMineModel*)returnMyIssueInMineModelsWithDictionary:(NSDictionary*)data Andindex:(NSInteger)index
{
    FLMyIssueInMineModel* model = [[FLMyIssueInMineModel alloc] init];
    NSDictionary* dic =  data[FL_NET_DATA_KEY][index];
    model.flMineIssueBackGroundImageStr = [self returnBigPhotoURLWithStr:dic[@"thumbnail"] ];//dic[@"thumbnail"];
    model.flMineIssueNumbersTotalPickStr = [dic[@"topicNum"] stringValue];
    model.flMineIssueDayStr    = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:1];
    model.flMineIssueMonthStr  = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:2];
    model.flMineIssueNumbersAlreadyPickStr = [dic[@"receiveNum"] stringValue]?[dic[@"receiveNum"] stringValue]:@"0";
    model.flMineIssueNumbersReadStr = [dic[@"pv"] stringValue];
    model.flMineIssueNumbersRelayStr = [dic[@"transformNum"]stringValue ];
    model.flMineIssueTopicIdStr =  dic[@"topicId"];
    model.flMineTopicThemStr = dic[@"topicTheme"];
    model.flMineTopicAddressStr = dic[@"address"];
    model.flTimeBegan = dic[@"startTime"];
    model.flTimeEnd   = dic[@"endTime"];
    model.flTimeService = dic[@"newDate"];
    model.flMineIssueTopicConditionStr = dic[@"topicCondition"];
    CGFloat ff = [model.flMineIssueNumbersAlreadyPickStr floatValue] / [model.flMineIssueNumbersTotalPickStr floatValue];
    model.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
    model.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
    model.flMineIssueNumbersJudgeStr = [dic[@"commentCount"] stringValue];
    model.flStateInt = [dic[@"state"] integerValue];
    model.xjTopicExplain = dic[@"topicExplain"];
    model.xjPartInNumber = [dic[@"partNum"] integerValue];
    model.xjTopicTagStr =  dic[@"topicTag"];
    model.xjTempId = dic[@"tempId"];
    
    return model;
}
//我领取的
+ (FLMyReceiveListModel*)returnMyReceiveInMineModelsWithDictionary:(NSDictionary*)data Andindex:(NSInteger)index
{
    FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
    NSDictionary* dic =  data[FL_NET_DATA_KEY][index];
    model.flMineIssueBackGroundImageStr =  [self returnBigPhotoURLWithStr:dic[@"thumbnail"] ];//  dic[@"thumbnail"];
    model.flMineIssueDayStr    = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:1];
    model.flMineIssueMonthStr  = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:2];
    model.flMineIssueNumbersAlreadyPickStr = [dic[@"receiveNum"] stringValue];
    model.flMineIssueNumbersReadStr = [dic[@"pv"] stringValue];
    model.flMineIssueNumbersRelayStr = [dic[@"transformNum"]stringValue ];
    model.flMineIssueTopicIdStr =  dic[@"topicId"];
    model.flMineIssueNumbersTotalPickStr = dic[@"topicNum"];
    model.flMineIssueTopicIdStr = dic[@"topicId"];
    model.flMineIssueNumbersJudgeStr = [dic[@"commentCount"] stringValue];
    model.flMineTopicThemStr = dic[@"topicTheme"];
    model.flTimeBegan = dic[@"createTime"];
    model.flTimeEnd   = dic[@"endTime"];
    model.flTimeService = dic[@"newDate"];
    model.flMineIssueTopicConditionStr = dic[@"topicCondition"];
    CGFloat ff = [model.flMineIssueNumbersAlreadyPickStr floatValue] / [model.flMineIssueNumbersTotalPickStr floatValue];
    model.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
    model.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
    model.flMineTopicAddressStr = dic[@"address"];
    model.flIntroduceStr = dic[@"topicExplain"];
    model.flDetailsIdStr = dic[@"detailsid"];
    model.flStateInt = [dic[@"state"] integerValue];
    model.xjCreator = [dic[@"publisherId"] integerValue];
    model.xjUserId = [dic[@"publisherId"] integerValue];
    model.xjUrl = dic[@"url"];
    model.xjinvalidTime = dic[@"invalidTime"];
    model.xjUseTime = dic[@"useTime"];
    model.xjUserType = dic[@"userType"];
    model.xjTopicTagStr = dic[@"topicTag"];
    model.xjPublishName = dic[@"publishName"];
    model.xjTopicType = dic[@"topicType"];
    model.xjPublisherType = dic[@"userType"];
    return model;
}

//我参与的
+ (XJMyPartInInfoModel*)returnMyPartInInfoModelsWithDictionary:(NSDictionary*)data andIndex:(NSInteger)index
{
    XJMyPartInInfoModel* model = [[XJMyPartInInfoModel alloc] init];
    NSDictionary* dic =  data[FL_NET_DATA_KEY][index];
    model.flMineIssueBackGroundImageStr =[self returnBigPhotoURLWithStr:dic[@"thumbnail"] ];// dic[@"thumbnail"];
    model.flMineIssueDayStr    = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:1];
    model.flMineIssueMonthStr  = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:2];
    model.flMineIssueNumbersAlreadyPickStr = [NSString stringWithFormat:@"%@",dic[@"receiveNum"]];
    model.flMineIssueNumbersReadStr = [dic[@"pv"] stringValue];
    model.flMineIssueNumbersRelayStr = [NSString stringWithFormat:@"%@",dic[@"transformNum"]];
    model.flMineIssueTopicIdStr =  dic[@"topicId"];
    model.flMineIssueNumbersTotalPickStr = [NSString stringWithFormat:@"%@",dic[@"topicNum"]];
    model.flMineIssueTopicIdStr = dic[@"topicId"];
    model.flMineIssueNumbersJudgeStr = [NSString stringWithFormat:@"%@",dic[@"commentCount"]];
    model.flMineTopicThemStr = dic[@"topicTheme"];
    model.flTimeBegan = dic[@"createTime"];
    model.flTimeEnd   = dic[@"endTime"];
    model.flTimeService = dic[@"newDate"];
    model.flMineIssueTopicConditionStr = dic[@"topicCondition"];
    CGFloat ff = [model.flMineIssueNumbersAlreadyPickStr floatValue] / [model.flMineIssueNumbersTotalPickStr floatValue];
    model.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
    model.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
    model.flMineTopicAddressStr = dic[@"address"];
    model.flIntroduceStr = dic[@"topicExplain"];
    model.flDetailsIdStr = dic[@"detailsid"];
    model.flStateInt = [dic[@"state"] integerValue];
    model.xjCreator = [dic[@"creator"] integerValue];
    model.xjUserId = [dic[@"userId"] integerValue];
    model.xjState = [dic[@"state"] integerValue];
    return model;
}
//待评价的
+ (XJMyWeaitPJModel*)returnMyXJMyWeaitPJModelsWithDictionary:(NSDictionary*)data andIndex:(NSInteger)index
{
    XJMyWeaitPJModel* model = [[XJMyWeaitPJModel alloc] init];
    NSDictionary* dic =  data[FL_NET_DATA_KEY][index];
    model.flMineIssueBackGroundImageStr = [self returnBigPhotoURLWithStr:dic[@"thumbnail"] ];//dic[@"thumbnail"];
//    model.flMineIssueDayStr    = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:1];
//    model.flMineIssueMonthStr  = [self returnDateStrWithDateStr:dic[@"createTime"] ForType:2];
    model.flMineIssueNumbersAlreadyPickStr = [dic[@"receiveNum"] stringValue];
    model.flMineIssueNumbersReadStr = [dic[@"pv"] stringValue];
    model.flMineIssueNumbersRelayStr = [dic[@"transformNum"]stringValue ];
    model.flMineIssueTopicIdStr =  dic[@"topicId"];
    model.flMineIssueNumbersTotalPickStr = dic[@"topicNum"] ? dic[@"topicNum"] : @"0";
    model.flMineIssueTopicIdStr = dic[@"topicId"];
    model.flMineIssueNumbersJudgeStr = [dic[@"rankCount"] stringValue];
    model.flMineTopicThemStr = dic[@"topicTheme"];
    model.flTimeBegan = dic[@"useTime"];
    model.flTimeEnd   = dic[@"endTime"];
    model.flTimeService = dic[@"newDate"];
    model.flMineIssueTopicConditionStr = dic[@"topicCondition"];
    CGFloat ff = [model.flMineIssueNumbersAlreadyPickStr floatValue] / [model.flMineIssueNumbersTotalPickStr floatValue];
    model.flfloatNumberStr = [NSString stringWithFormat:@"%f",ff];
    model.flfloatStr = [NSString stringWithFormat:@"%.0f%@",ff * 100,@"%"];
    model.flMineTopicAddressStr = dic[@"address"];
    model.flIntroduceStr = dic[@"topicExplain"];
    model.flDetailsIdStr = dic[@"detailsid"];
    model.flStateInt = [dic[@"state"] integerValue];
    model.xjCreator = [dic[@"creator"] integerValue];
    model.xjUserId = [dic[@"userId"] integerValue];
    
    return model;
}

+ (NSString*)returnDateStrWithDateStr:(NSString*)dateStr ForType:(NSInteger)needType
{
    //转来转去 拿不到具体的 日
    NSString* str = nil;
    NSDateComponents*comps;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [[NSDate alloc] init];
    date = [formatter dateFromString:dateStr];
//    str = [formatter stringFromDate:date];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    // 年月日获得
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
            
                       fromDate:date];
//    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
//    FL_Log(@"fuck in mine toolesyear:%ld month: %ld, day: %ld", year, month, day);
    switch (needType) {
        case 1:
            str = [NSString stringWithFormat:@"%ld",day];
            break;
        case 2:
            str = [NSString stringWithFormat:@"%ld月",month];
            break;
        default:
            break;
    }
    return str;
}


+ (NSArray*)returnJudgePLModelWithDic:(NSDictionary*)dicData
{
    NSArray* array = [FLMyIssueJudgePlModel mj_objectArrayWithKeyValuesArray:dicData];
    return array;
}
+ (NSArray*)returnJudgePJModelWithDic:(NSDictionary*)dicData
{
    NSArray* array = [FLMyIssueJudgePJModel mj_objectArrayWithKeyValuesArray:dicData];
    return array;
}
//返回评价列表模型高度
+ (CGFloat)returnJudgePJCellHWithPJModel:(FLMyIssueJudgePJModel*)model
{
    CGFloat cellH = 400;
    
    CGFloat flexpalinLabelH = [self returnLabelSizeWithString:model.content viewWidth:FLUISCREENBOUNDS.width - 2 * view_left_Margin ].height;
    NSInteger imageLineNumber = [self returnNumberImageLineInSelfWithArray:model.listImgURL line:view_image_how_N]; // 返回有几列
    CGFloat flimageH = imageLineNumber * fl_image_size_W;
    
    cellH = view_header_width_H + flexpalinLabelH + flimageH + view_top_Margin * 4;
    
    return cellH;
}
//返回有几列
+ (NSInteger)returnNumberImageLineInSelfWithArray:(NSArray*)arrayCount line:(NSInteger)how
{
    
    CGFloat ff = (float)arrayCount.count / (float)how;
    NSInteger ii = arrayCount.count / how;
    
    if (arrayCount.count == 0) {
        return  0;
    }
    else
    {
        if (ff == ii) {
           return  ii;
        } else if (ff > ii) {
            return  ii += 1;
        } else {
            return ii;
        }
    }
}

//返回label的size
+ (CGSize)returnLabelSizeWithString:(NSString*)str viewWidth:(CGFloat)flviewW
{
    CGSize sizeM = [str sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:label_size_font_M]}];
    if (sizeM.width < flviewW) {
        return sizeM;
    } else {
        CGFloat ff = (float)sizeM.width / flviewW;
        NSInteger ii = sizeM.width / flviewW;
        if (ff == ii) {
            return sizeM;
        } else if (ff > ii) {
            ii++;
            sizeM.width = flviewW;
            sizeM.height *= ii;
        }
    }
    return sizeM;
}

+ (FLUserInfoModel*)returnUserInfoModelWithModel:(NSDictionary*)data
{
    FLUserInfoModel* model = [[FLUserInfoModel alloc] init];
    model.flloginNumber = data[@"phone"];
    model.flbirthday    = data[@"birthday"]?data[@"birthday"]:@"";
    model.flnickName    = data[@"nickname"]?data[@"nickname"]:@"";
    model.fldescription = data[@"description"]?data[@"description"]:@"";
    model.fluserId      = data[@"userId"]?data[@"userId"]:@"";
    NSInteger flsex        = data[@"sex"]?[data[@"sex"] integerValue]:2;
    switch (flsex) {
        case 0:
            model.flsex = @"女";
            break;
        case 1:
            model.flsex = @"男";
            break;
        case 2:
            model.flsex = @"保密";
            break;
            
        default:
            break;
    }
    model.fladdress = data[@"address"]?data[@"address"]:@"";
    model.flavatar  = data[@"avatar"]?data[@"avatar"]:@"";
    NSString* tagStr = data[@"tags"]?data[@"tags"]:@"";
    model.fltagsArray = [tagStr componentsSeparatedByString:@","];
    model.flSource   = [data[@"source"] integerValue];
    model.flpassWord = data[@"password"];
    
    
    return model;
}

+ (NSString*)returnBigPhotoURLWithStr:(NSString*)flstr {
    NSString* xjReplaceStr = flstr;
    NSInteger xjFirst ,xjSecond;
    //    FL_Log(@"this is the last/ 111= %@",flstr);
    if ([xjReplaceStr rangeOfString:@"/" options:NSBackwardsSearch].location != NSNotFound) {
        xjFirst = [xjReplaceStr rangeOfString:@"/" options:NSBackwardsSearch].location;
        xjReplaceStr = [xjReplaceStr substringFromIndex:xjFirst + 1];
        //        FL_Log(@"this is the last/ 222= %@",xjReplaceStr);
        if ([xjReplaceStr rangeOfString:@"_" options:NSBackwardsSearch].location != NSNotFound) {
            xjSecond = [xjReplaceStr rangeOfString:@"_" options:NSBackwardsSearch].location;
            xjReplaceStr = [xjReplaceStr substringToIndex:xjSecond + 1];
            //            FL_Log(@"this is the last/ 333= %@",xjReplaceStr);
            flstr = [flstr stringByReplacingOccurrencesOfString:xjReplaceStr withString:@"little_app_"];
        }
    }
    FL_Log(@"this is the last/ 333= %@",flstr);
    return flstr;
}

@end












