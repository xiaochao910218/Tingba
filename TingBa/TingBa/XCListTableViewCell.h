//
//  XCListTableViewCell.h
//  TingBa
//
//  Created by 筱超 on 16/7/21.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCListModel;
@interface XCListTableViewCell : UITableViewCell
@property (nonatomic,strong) XCListModel *listModel;
@end
