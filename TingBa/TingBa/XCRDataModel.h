//
//  XCRDataModel.h
//  TingBa
//
//  Created by 筱超 on 16/7/20.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCRDataModel : NSObject
@property(nonatomic,strong) NSString *radioName;
@property(nonatomic,strong) NSString *radioImage;
@property(nonatomic,strong) NSString *radioId;
@property(nonatomic,strong) NSString *radioCurrentBroadcast;
+(instancetype)rDataModelWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
