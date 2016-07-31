//
//  XCListTableViewCell.m
//  TingBa
//
//  Created by 筱超 on 16/7/21.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCListTableViewCell.h"
#import "XCListModel.h"
#import "UIImageView+WebCache.h"
@interface XCListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@end

@implementation XCListTableViewCell

-(void)setListModel:(XCListModel *)listModel{
    _listModel=listModel;
    _coverImage.layer.cornerRadius=22;
    _coverImage.layer.masksToBounds=YES;
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:listModel.listCoverImage] placeholderImage:[UIImage imageNamed:@"yushe"]];
    _nameLable.text=listModel.listTitle;
    _createTime.text=[listModel.listCreatedTime substringToIndex:10];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
