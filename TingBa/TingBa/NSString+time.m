//
//  
//  ListenNovel
//
//  Created by 筱超 on 16/7/5.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "NSString+time.h"

@implementation NSString (time)

+ (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

@end
