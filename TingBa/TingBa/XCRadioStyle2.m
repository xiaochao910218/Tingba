//
//  XCRadioStyle2.m
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCRadioStyle2.h"

#import "XCRadioModel.h"
@interface XCRadioStyle2 ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation XCRadioStyle2

-(void)setRadioModel:(XCRadioModel *)radioModel{
    _radioModel=radioModel;
    _icon.image=[UIImage imageNamed:radioModel.icon];
    _title.text=radioModel.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
