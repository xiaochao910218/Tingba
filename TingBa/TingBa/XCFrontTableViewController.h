//
//  XCFrontTableViewController.h
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCFrontTableViewController : UITableViewController
@property (nonatomic,strong) NSString *url;
@property (nonatomic)        NSInteger page;
@property (nonatomic,strong) NSString *channelId;
@property (nonatomic,strong) NSString *fronttitle;
@end
