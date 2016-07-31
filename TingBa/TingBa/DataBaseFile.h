//
//  DataBaseFile.h
//  01-数据持久化作业
//
//  Created by qingyun on 16/6/20.
//  Copyright © 2016年 QingYun. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef DataBaseFile_h
#define DataBaseFile_h





//数据库名称
#define BaseFileName @"Novel.db"
//创建表

#define createTabel @"create table if not exists NovelHome(name text,overview text,playCount text, coverImage blob,id text,author text,anchor text,chapterCount text);"
//插入数据
#define INSERT_HOMELIST_SQL @"insert into NovelHome values(:name,:overview,:playCount,:coverImage,:id,:author,:anchor,:chapterCount)"
//查询所有的数据
#define SELECT_HOMELIST_ALL @"select * from NovelHome"

//删除数据
#define Delete_HOMELIST @"delete from NovelHome"

#endif /* DataBaseFile_h */
