//
//  FLUserCellModel.h
//  FreeLa
//
//  Created by Leon on 15/11/2.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLUserCellModel : NSObject


@property (nonatomic , copy)NSString* nikeName;
@property (nonatomic , copy)NSString* userID;
/**头像*/
@property (nonatomic , copy)NSString* portrait;
//@property (nonatomic , assign)BOO
/**选中的图片*/
@property (nonatomic , copy)NSString* icon;
/**是否选中*/
@property (nonatomic , assign)BOOL isSelected; //是否选中
@property (nonatomic , assign)BOOL isManager;  //是不是管理员

- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)userModelWithDict:(NSDictionary*)dict;



@end
