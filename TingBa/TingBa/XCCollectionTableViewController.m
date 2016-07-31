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
@interface XCCollectionTableViewController ()
@property (nonatomic,strong) NSMutableArray *colArr;
@end

@implementation XCCollectionTableViewController

-(NSMutableArray *)colArr{
    if (!_colArr) {
        _colArr=[NSMutableArray array];
        NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path =  [patharray objectAtIndex:0];
        NSString *filepath=[path stringByAppendingPathComponent:@"XCCollectionNovel.plist"];
        NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:filepath];
        NSLog(@"------%ld--------",arr.count);
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCCollectTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"colcell"];
    self.tableView.rowHeight=105;
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
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    [self.tableView reloadData];
    [self.navigationController pushViewController:view animated:YES];
}


@end
