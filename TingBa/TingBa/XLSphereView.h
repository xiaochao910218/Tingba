//
//  XLSphereView.h
//  XLSphereView
//  shaoshuaiCooker
//
//  Created by qingyun on 16/7/4.
//  Copyright © 2016年 qindongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSphereView : UIView

@property(nonatomic,assign) BOOL isTimerStart;

- (void)setItems:(NSArray *)items;

- (void)timerStart;

- (void)timerStop;


@end
