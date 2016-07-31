//
//  XCRadioCVCStyle1.m
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCRadioCVCStyle1.h"
#import "XCRadioModel.h"
@interface XCRadioCVCStyle1 ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation XCRadioCVCStyle1

-(void)setRadioModel:(XCRadioModel *)radioModel{
    _radioModel=radioModel;
    _iconImg.image=[UIImage imageNamed:radioModel.icon];
    _title.text=radioModel.title;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
