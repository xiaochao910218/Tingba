//
//  XCListTableViewController.h
//  TingBa
//
//  Created by 筱超 on 16/7/21.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
@interface XCListTableViewController : UITableViewController<WXApiDelegate>
@property (nonatomic,strong) NSString *listUrl;
//@property (nonatomic) NSInteger listTag;
@property (nonatomic,strong) NSString *listImage;
@property (nonatomic,strong) NSString *listTitle;
@property (nonatomic,strong) NSString *listchapter;
@property (nonatomic,strong) NSString *listanchor;
@property (nonatomic,strong) NSString *listplayCount;
@property(nonatomic,strong) NSMutableArray *listArr;

@end
