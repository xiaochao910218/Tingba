//
//  XCTitlesModel.h
//  TingBa
//
//  Created by 筱超 on 16/7/20.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCTitlesModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *lableId;

- (instancetype) initWithDictionary:(NSDictionary *)dict;
+ (instancetype) titlesModelWithDictionary:(NSDictionary *)dict;
@end
