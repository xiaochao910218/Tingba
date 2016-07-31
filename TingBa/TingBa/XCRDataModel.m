//
//  XCRDataModel.m
//  TingBa
//
//  Created by 筱超 on 16/7/20.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCRDataModel.h"
#import "XCCommon.h"
@implementation XCRDataModel
+(instancetype)rDataModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        _radioId=dict[XCNovelID];
        _radioName=dict[XCNovelName];
        _radioImage=dict[XCNovelCoverImage];
        _radioCurrentBroadcast=dict[XCNovelRadioCurrentBroadcast];
    }
    return self;
}
@end
