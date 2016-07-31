//
//  XCCollectTableViewCell.m
//  TingBa
//
//  Created by 筱超 on 16/7/28.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCCollectTableViewCell.h"
#import "XCFrontModel.h"
#import "UIImageView+WebCache.h"

static NSString  *KFileName=@"XCCollectionNovel.plist";
@interface XCCollectTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLable;
@property (nonatomic)                BOOL    isCollection;
@property (weak, nonatomic) IBOutlet UILabel *descLable;
@property(nonatomic,strong)NSMutableArray *collectionArr;
@property(nonatomic,strong)NSString *filePath;
@end

@implementation XCCollectTableViewCell
-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr=[NSMutableArray array];
    }
    return _collectionArr;
}
-(NSString *)filePath
{
    if (_filePath) {
        return _filePath;
    }
    NSString *documentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    _filePath=[documentsPath stringByAppendingPathComponent:KFileName];
    return _filePath;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(XCFrontModel *)model{
    _model=model;
    NSString *str=model.coverImage;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://ec4.images-amazon.com/images/I/51jurMyudRL._SL500_AA300_.jpg";
    }
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"yushe"]];
    _nameLable.text=model.name;
    _authorLable.text=model.author;
    _createTimeLable.text=[model.updatedTime substringToIndex:10];
    _descLable.text=model.coverview;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)collectionAction:(UIButton *)sender {
    _model.iscancle=YES;
   
    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [patharray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"XCCollectionNovel.plist"];
    self.collectionArr=[NSMutableArray arrayWithContentsOfFile:filepath];
    for (int i=0; i<self.collectionArr.count; i++) {
        NSDictionary *dict=self.collectionArr[i];
        if ([dict[@"author"] isEqualToString:_model.author]) {
            [self.collectionArr removeObject:dict];
        }
    }
    
    [self.collectionArr writeToFile:self.filePath atomically:YES];

}

@end
