//
//  XCNovelTitle.h
//  TingBa
//
//  Created by 筱超 on 16/7/20.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCNovelTitle : UIScrollView
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, copy) void (^changeContentVC) (NSUInteger index);
+(instancetype) titleScrollViewWithTitles:(NSArray *)titles;
@end
