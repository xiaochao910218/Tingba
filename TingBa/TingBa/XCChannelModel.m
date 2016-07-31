//
//  XCChannelModel.m
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCChannelModel.h"
#import "XCCommon.h"
@implementation XCChannelModel
+(instancetype)channelModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        _chanelName=dict[XCNovelName];
        _channnelId=dict[XCNovelID];
        _channelImage=dict[XCNovelChannelImage];
    }
    return self;
}
@end
