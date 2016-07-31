//
//  XCChannelModel.h
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCChannelModel : NSObject
@property(nonatomic,strong) NSString *chanelName;
@property(nonatomic,strong) NSString *channelImage;
@property(nonatomic,strong) NSString *channnelId;
+(instancetype)channelModelWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
