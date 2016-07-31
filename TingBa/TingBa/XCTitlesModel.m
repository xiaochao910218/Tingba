//
//  XCTitlesModel.m
//  TingBa
//
//  Created by 筱超 on 16/7/20.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCTitlesModel.h"

@implementation XCTitlesModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)titlesModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}
@end
