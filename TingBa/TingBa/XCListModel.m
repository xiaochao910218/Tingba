//
//  XCListModel.m
//  TingBa
//
//  Created by 筱超 on 16/7/21.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCListModel.h"
#import "XCCommon.h"

@implementation XCListModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        NSString *strUrl=dict[XCListAudioURL];
        
        if ([strUrl containsString:@"\n"]) {
            NSString *str=[strUrl substringToIndex:strUrl.length-1];
            _listAudioURL=str;
        }else{
            _listAudioURL=strUrl;
        }
        _listCoverImage=dict[XCNovelCoverImage];
        _listTitle=dict[XCListTitle];
        _listCreatedTime=dict[XCListcreatedTime];
    }
    return self;
}

+ (instancetype)listModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}
@end
