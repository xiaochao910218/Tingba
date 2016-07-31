//
//  XCMenuModel.m
//  ListenNovel
//
//  Created by 筱超 on 16/6/30.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCMenuModel.h"

@implementation XCMenuModel
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
