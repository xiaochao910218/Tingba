//
//  XCListOneTableViewCell.m
//  TingBa
//
//  Created by 筱超 on 16/7/26.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCListOneTableViewCell.h"
#import "XCListModel.h"
@interface XCListOneTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@end

@implementation XCListOneTableViewCell

-(void)setListModel:(XCListModel *)listModel{
    _listModel=listModel;
    _nameLable.text=listModel.listTitle;
    _timeLable.text=[NSString stringWithFormat:@"更新时间: %@",[[listModel.listCreatedTime substringToIndex:19] stringByReplacingOccurrencesOfString:@"T" withString:@" "] ];
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
