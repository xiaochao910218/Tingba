//
//  XCSearchModel.h
//  TingBa
//
//  Created by 筱超 on 16/7/25.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCSearchModel : NSObject
@property(nonatomic,strong)NSString *keyword;
- (instancetype) initWithDictionary:(NSDictionary *)dict;
+ (instancetype) keywordModelWithDictionary:(NSDictionary *)dict;
@end
