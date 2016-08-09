//
//  XClearCacheTool.m
//  TingBa
//
//  Created by 筱超 on 16/8/3.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCClearCacheTool.h"

#define fileManager [NSFileManager defaultManager]

@implementation XCClearCacheTool


//获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path
{

//调试
#ifdef DEBUG
    BOOL isDirectory = NO;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isExist || !isDirectory)
    {
        NSException *exception = [NSException exceptionWithName:@"fileError" reason:@"please check your filePath!" userInfo:nil];
        [exception raise];

    }
#endif

    //获取“path”文件夹下面的所有文件
    NSArray *subpathArray= [fileManager subpathsAtPath:path];

    NSString *filePath = nil;
    NSInteger totleSize=0;

    for (NSString *subpath in subpathArray)
    {
        //拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subpath];

        //isDirectory，是否是文件夹，默认不是
        BOOL isDirectory = NO;

        //isExist，判断文件是否存在
        BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory ) continue;
            NSDictionary *dict=   [fileManager attributesOfItemAtPath:filePath error:nil];
            NSInteger size=[dict[@"NSFileSize"] integerValue];
            totleSize+=size;
     }
        NSString *totleStr = nil;

        if (totleSize > 1000 * 1000)
        {
          totleStr = [NSString stringWithFormat:@"%.1fM",totleSize / 1000.0f /1000.0f];
        }else if (totleSize > 1000)
        {
          totleStr = [NSString stringWithFormat:@"%.1fKB",totleSize / 1000.0f ];

        }else
        {
          totleStr = [NSString stringWithFormat:@"%.1fB",totleSize / 1.0f];
        }

        return totleStr;


}
+ (BOOL)clearCacheWithFilePath:(NSString *)path
{
    NSArray *subpathArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
    NSString *message = nil;
    NSError *error = nil;
    NSString *filePath = nil;

    for (NSString *subpath in subpathArray)
    {
        filePath =[path stringByAppendingPathComponent:subpath];
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            message = [NSString stringWithFormat:@"%@这个路径的文件夹删除失败了，请检查后重新再试",filePath];
            return NO;

        }else {
            message = @"成功了";
        }

    }
    NSLog(@"%@",message);

    return YES;

}
@end
