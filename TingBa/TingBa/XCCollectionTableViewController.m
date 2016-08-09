//
//  XCCollectionTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/7/28.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCCollectionTableViewController.h"
#import "XCCommon.h"
#import "XCCollectTableViewCell.h"
#import "XCFrontModel.h"
#import "XCListTableViewController.h"
#import "RESideMenu.h"

static NSString  *KFileName=@"XCCollectionNovel.plist";
@interface XCCollectionTableViewController ()
@property (nonatomic,strong) NSMutableArray *colArr;
@property (nonatomic,strong) NSMutableArray *collectionArr;
@property (nonatomic,strong) NSString *novelAuthor;
@property(nonatomic,strong)NSString *filePath;
@property (nonatomic,strong) NSMutableArray *cancleCollectionArr;
@end

@implementation XCCollectionTableViewController
static XCCollectionTableViewController *colvc;
static int isHe=0;
+(XCCollectionTableViewController *)canclePicture
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colvc=[[XCCollectionTableViewController alloc]init];
    });
    return colvc;
}

-(void)canclePicture{
    isHe=1;
}
-(void)hasPicture{
    isHe=0;
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


-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr=[NSMutableArray array];
    }
    return _collectionArr;
}

-(NSMutableArray *)colArr{
    if (!_colArr) {
        _colArr=[NSMutableArray array];
        NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path =  [patharray objectAtIndex:0];
        NSString *filepath=[path stringByAppendingPathComponent:@"XCCollectionNovel.plist"];
        NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:filepath];
//        NSLog(@"------%ld--------",arr.count);
        for (NSDictionary *dict in arr) {
            XCFrontModel *model=[XCFrontModel frontModelWithDictionary:dict];
            [_colArr addObject:model];
        }
    }
    return _colArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"收藏";
    self.tableView.rowHeight=105;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.671 green:0.749 blue:0.176 alpha:0.6]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.colArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XCCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colcell" forIndexPath:indexPath];
    XCFrontModel *model=self.colArr[indexPath.row];
    if (isHe==1) {
        model.coverImage=nil;
    }
    cell.collectionBtn.tag=indexPath.row;
      [cell.collectionBtn addTarget:self action:@selector(deleteCollect:) forControlEvents:UIControlEventTouchUpInside];
    cell.model=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XCListTableViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"listtablevc"];
    XCFrontModel *model=self.colArr[indexPath.row];
    view.listUrl=[NSString stringWithFormat: @"http://api.iting360.com:8080/audible-book/service/audioBooksV2/getBookChaptersByPage?market=k-app360&dir=ASC&pageSize=20&bookId=%@&imsi=460013184202204&ver=2.5.1&pageIndex=1&appKey=audibleBook",model.coverId];
    view.listchapter=model.chapterCount;
    view.listTitle=model.name;
    view.listImage=model.coverImage;
    view.listplayCount=model.playCount;
    view.listanchor=model.anchor;
    self.novelAuthor=model.name;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)deleteCollect:(UIButton *)sender
{

    UIView* v=[sender superview];
    UITableViewCell* cell=(UITableViewCell*)[v superview];
    NSIndexPath* indexPath= [self.tableView indexPathForCell:cell];
    XCFrontModel *model=self.colArr[indexPath.row];
    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [patharray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"XCCollectionNovel.plist"];
    self.cancleCollectionArr =[NSMutableArray arrayWithContentsOfFile:filepath];
    for (int i=0; i<self.cancleCollectionArr.count; i++) {
        NSDictionary *dict=self.cancleCollectionArr[i];
        NSString *str=dict[@"name"];
        if ([str isEqualToString:model.name]) {
            [self.cancleCollectionArr removeObject:dict];
        }
    }
    
    [self.cancleCollectionArr writeToFile:self.filePath atomically:YES];
    [self.colArr removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    [self.tableView reloadData];
    


    
}


@end
