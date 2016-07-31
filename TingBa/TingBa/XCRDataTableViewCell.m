//
//  XCRDataTableViewCell.m
//  TingBa
//
//  Created by 筱超 on 16/7/20.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCRDataTableViewCell.h"
#import "XCRDataModel.h"
#import "UIImageView+WebCache.h"
@interface XCRDataTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentLable;
@property (nonatomic)                BOOL    isCollection;
@end

@implementation XCRDataTableViewCell

-(void)setDataModel:(XCRDataModel *)dataModel{
    _dataModel=dataModel;
    if ([[NSNull null] isEqual:dataModel.radioImage]) {
        _coverImage.image=[UIImage imageNamed:@"yushe"];
    }
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:dataModel.radioImage] placeholderImage:[UIImage imageNamed:@"yushe"]];
    _nameLable.text=dataModel.radioName;
    _currentLable.text=dataModel.radioCurrentBroadcast;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionBtn.hidden=YES;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
