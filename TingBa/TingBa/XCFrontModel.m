//
//  XCFrontModel.m
//  TingBa
//
//  Created by 筱超 on 16/7/18.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCFrontModel.h"
#import "XCCommon.h"
@implementation XCFrontModel
+(instancetype)frontModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        _coverImage=dict[XCNovelCoverImage];
        _name=dict[XCNovelName];
        _anchor=dict[XCNovelAnchor];
        _author=dict[XCNovelAuthor];
        _updatedTime=dict[XCNovelUpdatedTime];
        _coverview=dict[XCNovelCoverview];
        _coverId=dict[XCNovelID];
        _chapterCount=dict[XCNovelChapterCount];
        _playCount=dict[XCNovelPlayCount];
    }
    return self;
}
@end
