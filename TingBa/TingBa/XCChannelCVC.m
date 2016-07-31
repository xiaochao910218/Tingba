//
//  XCChannelCVC.m
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCChannelCVC.h"
#import "XCChannelModel.h"
#import "UIImageView+WebCache.h"
@interface XCChannelCVC ()
@property (weak, nonatomic) IBOutlet UIImageView *channelImg;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation XCChannelCVC


-(void)setChannelModel:(XCChannelModel *)channelModel{
    _channelModel=channelModel;
    [_channelImg sd_setImageWithURL:[NSURL URLWithString:channelModel.channelImage] placeholderImage:[UIImage imageNamed:@"yushe"]];
    _name.text=channelModel.chanelName;
    _channelImg.layer.cornerRadius=25;
    _channelImg.layer.masksToBounds=YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
