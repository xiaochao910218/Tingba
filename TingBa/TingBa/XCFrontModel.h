//
//  XCFrontModel.h
//  TingBa
//
//  Created by 筱超 on 16/7/18.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCFrontModel : NSObject
@property (nonatomic, strong) NSString *coverId;
@property (nonatomic, strong) NSString *coverImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *anchor;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *updatedTime;
@property (nonatomic, strong) NSString *coverview;
@property (nonatomic, strong) NSString *chapterCount;
@property (nonatomic, strong) NSString *playCount;

+(instancetype)frontModelWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
