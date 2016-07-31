//
//  XCListModel.h
//  TingBa
//
//  Created by 筱超 on 16/7/21.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCListModel : NSObject
@property (nonatomic,strong) NSString *listCoverImage;
@property (nonatomic,strong) NSString *listTitle;
@property (nonatomic,strong) NSString *listCreatedTime;
@property (nonatomic,strong) NSString *listAudioURL;
- (instancetype) initWithDictionary:(NSDictionary *)dict;
+ (instancetype) listModelWithDictionary:(NSDictionary *)dict;
@end
