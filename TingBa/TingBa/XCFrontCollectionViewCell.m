//
//  XCFrontCollectionViewCell.m
//  TingBa
//
//  Created by 筱超 on 16/7/18.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCFrontCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XCFrontModel.h"
@interface XCFrontCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverview;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *auchor;

@end


@implementation XCFrontCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrontModel:(XCFrontModel *)frontModel{
    _frontModel=frontModel;
    [_coverview sd_setImageWithURL:[NSURL URLWithString:frontModel.coverImage] placeholderImage:[UIImage imageNamed:@"yushe"]];
    _name.text=frontModel.name;
    _auchor.text=frontModel.anchor;
}

@end
