//
//  XCRadioModel.h
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCRadioModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *channelId;
+(instancetype)radioModelWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
