//
//  XCFrontTableViewCell.m
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCFrontTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XCCommon.h"
static NSString  *KFileName=@"XCCollectionNovel.plist";
@interface XCFrontTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLable;
@property (nonatomic)                BOOL    isCollection;
@property (weak, nonatomic) IBOutlet UILabel *descLable;
@property(nonatomic,strong)NSMutableArray *collectionArr;
@property(nonatomic,strong)NSMutableArray *cancleCollectionArr;
@property(nonatomic,strong)NSString *filePath;
@end

@implementation XCFrontTableViewCell

-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr=[NSMutableArray array];
    }
    return _collectionArr;
}
-(NSMutableArray *)cancleCollectionArr{
    if (!_cancleCollectionArr) {
        _cancleCollectionArr=[NSMutableArray array];
    }
    return _cancleCollectionArr;
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
    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [patharray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"XCCollectionNovel.plist"];
    self.cancleCollectionArr =[NSMutableArray arrayWithContentsOfFile:filepath];
    for (int i=0; i<self.cancleCollectionArr.count; i++) {
        NSDictionary *dict=self.cancleCollectionArr[i];
        NSString *str=dict[@"name"];
        if ([str isEqualToString:model.name]) {
            [_collectionBtn setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
            [_collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            _isCollection=YES;
        }else{
            [_collectionBtn setImage:[UIImage imageNamed:@"iconpng"] forState:UIControlStateNormal];
            [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
            _isCollection=NO;
        }
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)collectionAction:(UIButton *)sender {
    _isCollection=!_isCollection;
    if (_isCollection == NO) {
        [_collectionBtn setImage:[UIImage imageNamed:@"iconpng"] forState:UIControlStateNormal];
        [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path =  [patharray objectAtIndex:0];
        NSString *filepath=[path stringByAppendingPathComponent:@"XCCollectionNovel.plist"];
        self.cancleCollectionArr =[NSMutableArray arrayWithContentsOfFile:filepath];
        for (int i=0; i<self.cancleCollectionArr.count; i++) {
            NSDictionary *dict=self.cancleCollectionArr[i];
            if ([dict[@"name"] isEqualToString:_model.name]) {
                [self.cancleCollectionArr removeObject:dict];
            }
        }
        
        [self.cancleCollectionArr writeToFile:self.filePath atomically:YES];
        
    }else if(_isCollection == YES){
        [_collectionBtn setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        [_collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [self saveDataTOLocation];
    }

}
-(BOOL)saveDataTOLocation
{
    NSMutableDictionary *pars=[NSMutableDictionary dictionary];
    NSString *name=_model.name;
    if (name) {
        [pars setObject:name forKey:XCNovelName];
    }
    NSString *coverImage=_model.coverImage;
    if (coverImage) {
        [pars setObject:coverImage forKey:XCNovelCoverImage];
    }
    NSString *author=_model.author;
    if (author) {
        [pars setObject:author forKey:XCNovelAuthor];
    }
    NSString *overview=_model.coverview;
    if (overview) {
        [pars setObject:overview forKey:XCNovelCoverview];
    }
    NSString *coverID=_model.coverId;
    if (coverID) {
        [pars setObject:coverID forKey:XCNovelID];
    }
    NSString *createdTime=_model.updatedTime;
    if (createdTime) {
        [pars setObject:createdTime forKey:XCNovelUpdatedTime];
    }
    NSString *chapterCount=_model.chapterCount;
    if (chapterCount) {
        [pars setObject:chapterCount forKey:XCNovelChapterCount];
    }
    NSString *anchor=_model.anchor;
    if (anchor) {
        [pars setObject:anchor forKey:XCNovelAnchor];
    }
    NSString *playCount=_model.playCount;
    if (playCount) {
        [pars setObject:playCount forKey:XCNovelPlayCount];
    }

    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [patharray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"XCCollectionNovel.plist"];
    self.collectionArr =[NSMutableArray arrayWithContentsOfFile:filepath];
    [self.collectionArr addObject:pars];
    return  [self.collectionArr writeToFile:self.filePath atomically:YES];
    
}


@end
