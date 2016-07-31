//
//  XCCommon.h
//  TingBa
//
//  Created by 筱超 on 16/7/18.
//  Copyright © 2016年 筱超. All rights reserved.
//

#ifndef XCCommon_h
#define XCCommon_h
#import "XCMenuModel.h"
#import "XCMenuTableViewCell.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UIViewController+RESideMenu.h"
#import "XCFrontModel.h"
#import "XCFrontCollectionViewCell.h"
#import "XCFrontTableViewController.h"
#import "XCChannelModel.h"
#import "XCChannelCVC.h"
#import "XCRadioModel.h"
#import "XCRadioCVCStyle1.h"
#import "XCRadioStyle2.h"
#import "XCPlayerViewController.h"
#import "XCFrontTableViewCell.h"
#import "XCRDataTableViewCell.h"
#import "XCRDataModel.h"
#import "RESideMenu.h"
#import "XCNovelTitle.h"
#import "XCTitlesModel.h"
#import "XCListTableViewController.h"

#define JINGXUANURL @"http://api.iting360.com:8080/audible-book/service/audioBooks/getFrontPage?pageSize=1000&imsi=460013184202204&market=k-app360&ver=2.5.1&channelId=44&pageIndex=1&appKey=audibleBook"
#define FEILEIURL @"http://api.iting360.com:8080/audible-book/service/audioBooks/getChannels?interf=v2&imsi=460013184202204&market=k-app360&ver=2.5.1&channelId=32&appKey=audibleBook"
#define TITLESURL @"http://api.iting360.com:8080/audible-book/service/audioBooks/getChannelLabels?imsi=460013184202204&market=k-app360&ver=2.5.1&channelId=35&appKey=audibleBook"

//精选
static NSString * const XCFrontPage =@"frontPage";//标示
static NSString * const XCNovelID =@"id";//id
static NSString * const XCNovelName=@"name";//标题
static NSString * const XCNovelCoverImage=@"coverImage";//图片
static NSString * const XCNovelCoverview=@"overview";//描述
static NSString * const XCNovelAnchor=@"anchor";//主播
static NSString * const XCNovelAuthor=@"author";//作者
static NSString * const XCNovelPlayCount=@"playCount";//播放次数
static NSString * const XCNovelCommentCount=@"commentCount";//评论数
static NSString * const XCNovelUpdatedTime=@"updatedTime";//更新时间
static NSString * const XCNovelChapterCount=@"chapterCount";//集数
static NSString * const XCNovelNovelFavoriteCount=@"favoriteCount";


//分类
static NSString * const XCNovelChannelImage=@"channelImage";

static NSString * const XCNovelRadioAudioRadio=@"audioRadio";
static NSString * const XCNovelRadioCurrentBroadcast=@"currentBroadcast";


//目录
static NSString * const XCListTitle=@"title";
static NSString * const XCListAudioURL=@"audioURL";
static NSString * const XCListcreatedTime=@"createdTime";


#define WIDTH self.view.frame.size.width
#define HEIGTH self.view.frame.size.height

#endif /* XCCommon_h */
