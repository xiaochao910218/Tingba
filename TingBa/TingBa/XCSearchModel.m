//
//  XCSearchModel.m
//  TingBa
//
//  Created by 筱超 on 16/7/25.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCSearchModel.h"

@implementation XCSearchModel
- (instancetype) initWithDictionary:(NSDictionary *)dict{
    if (self=[super init]) {
        _keyword=dict[@"keyword"];
    }
    return self;
}
+ (instancetype) keywordModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
@end
