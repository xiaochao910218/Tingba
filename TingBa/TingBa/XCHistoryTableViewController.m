//
//  XCHistoryTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/8/1.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCHistoryTableViewController.h"
#import "XCCommon.h"

static NSString  *HistoryName=@"XCHistoryNovel.plist";
@interface XCHistoryTableViewController ()
@property(nonatomic,strong) NSMutableArray *historyArr;

@property(nonatomic,strong)NSString *filePath;

@end

@implementation XCHistoryTableViewController
static XCHistoryTableViewController *hisvc;
static int isHe=0;
+(XCHistoryTableViewController *)canclePicture
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hisvc=[[XCHistoryTableViewController alloc]init];
    });
    return hisvc;
}
-(void)noPicture{
    isHe=1;
}
-(void)hasPicture{
    isHe=0;
}
-(NSString *)filePath
{
    if (!_filePath) {
    NSString *documentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    _filePath=[documentsPath stringByAppendingPathComponent:HistoryName];
    }
    return _filePath;
}


-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr=[NSMutableArray array];
        NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path =  [patharray objectAtIndex:0];
        NSString *filepath=[path stringByAppendingPathComponent:@"XCHistoryNovel.plist"];
        NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:filepath];
       
        for (NSDictionary *dict in arr) {
            XCFrontModel *model=[XCFrontModel frontModelWithDictionary:dict];
            [_historyArr addObject:model];
        }
    }
    return _historyArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight=105;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCFrontTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"historycell"];
    if (self.historyArr.count==0) {
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-100)/2, (HEIGTH-84)/2, 100, 20)];
        lable.text=@"无数据";
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor=[UIColor blackColor];
        [self.view addSubview:lable];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XCFrontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historycell" forIndexPath:indexPath];
    XCFrontModel *model=self.historyArr[indexPath.row];
    if (isHe==1) {
        model.coverImage=nil;
    }
    cell.model=model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XCListTableViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"listtablevc"];
    XCFrontModel *model=self.historyArr[indexPath.row];
    view.listUrl=[NSString stringWithFormat: @"http://api.iting360.com:8080/audible-book/service/audioBooksV2/getBookChaptersByPage?market=k-app360&dir=ASC&pageSize=20&bookId=%@&imsi=460013184202204&ver=2.5.1&pageIndex=1&appKey=audibleBook",model.coverId];
    view.listchapter=model.chapterCount;
    view.listTitle=model.name;
    view.listImage=model.coverImage;
    view.listplayCount=model.playCount;
    view.listanchor=model.anchor;
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)clearHistoryAction:(UIBarButtonItem *)sender {
    
    [self.historyArr removeAllObjects];
    [self.historyArr writeToFile:self.filePath atomically:YES];
    [self.tableView reloadData];
    
}


@end
