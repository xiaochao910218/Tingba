//
//  XCCollectTableViewCell.h
//  TingBa
//
//  Created by 筱超 on 16/7/28.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCFrontModel;
@interface XCCollectTableViewCell : UITableViewCell
@property (nonatomic,strong) XCFrontModel *model;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@end
