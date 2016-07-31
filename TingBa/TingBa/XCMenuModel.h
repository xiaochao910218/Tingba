//
//  XCMenuModel.h
//  ListenNovel
//
//  Created by 筱超 on 16/6/30.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCMenuModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *tag;
- (instancetype) initWithDictionary:(NSDictionary *)dict;
+ (instancetype) titlesModelWithDictionary:(NSDictionary *)dict;
@end
