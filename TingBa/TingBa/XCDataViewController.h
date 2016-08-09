//
//  XCDataViewController.h
//  TingBa
//
//  Created by 筱超 on 16/7/18.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCRotatingView.h"
@interface XCDataViewController : UIViewController

@property(nonatomic) BOOL isNoPicture;
@property (strong, nonatomic) XCRotatingView *rotatingIcon;
@property (strong, nonatomic) NSString *imgUrl;
+(XCDataViewController *)canclePicture;
-(void)changeIT;
-(void)backIT;
@end
