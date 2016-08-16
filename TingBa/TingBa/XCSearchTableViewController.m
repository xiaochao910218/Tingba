//
//  XCSearchTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/8/16.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCSearchTableViewController.h"
#import "XCCommon.h"
#import "XCFrontTableViewCell.h"
#import "XCListTableViewController.h"

#define BASEURL @"http://api.iting360.com:8080/audible-book/service/audioBooks/findBooksByPageV2?market=k-app360&pageSize=20&imsi=460013184202204&ver=2.5.1&type=book&pageIndex=1&appKey=audibleBook&"
@interface XCSearchTableViewController ()
@property(nonatomic,strong)NSString *searchUrl;
@property(nonatomic,strong)NSString *issearchUrl;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableArray *searchArr;
@property (nonatomic) NSInteger pageIndex;
@end

@implementation XCSearchTableViewController
-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr=[NSMutableArray array];
    }
    return _searchArr;
}
-(AFHTTPSessionManager *)manager {
    if (!_manager) {
        //创建manager对象
        _manager=[AFHTTPSessionManager manager];
        //设置网络监听
        _manager.reachabilityManager=[AFNetworkReachabilityManager sharedManager];
        //启动监听
        [_manager.reachabilityManager startMonitoring];
    }
    return _manager;
    
}

-(void)getRequst{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    NSString *url=[NSString stringWithFormat:@"%@&keyword=%@",BASEURL,_searchUrl];
    __weak XCSearchTableViewController *vc=self;
    url=[url stringByReplacingOccurrencesOfString:@"pageIndex=1" withString:[NSString stringWithFormat:@"pageIndex=%ld",(long)self.pageIndex]];
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSArray *array=dict[@"book"];
        for (NSDictionary *listdict in array) {
            XCFrontModel *front=[XCFrontModel frontModelWithDictionary:listdict];
            [vc.searchArr addObject:front];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc.tableView reloadData];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"亲 网速不好"];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex=1;
    _searchUrl=[self.searchStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  characterSetWithCharactersInString:self.searchStr]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCFrontTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"morecell"];
    self.tableView.rowHeight=105;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.navigationItem.title=@"搜索目录";
    [self getRequst];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   return self.searchArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XCFrontModel *model=self.searchArr[indexPath.row];
    XCFrontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"morecell" forIndexPath:indexPath];
    cell.model=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XCListTableViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"listtablevc"];
    XCFrontModel *model=self.searchArr[indexPath.row];
    view.listUrl=[NSString stringWithFormat: @"http://api.iting360.com:8080/audible-book/service/audioBooksV2/getBookChaptersByPage?market=k-app360&dir=ASC&pageSize=20&bookId=%@&imsi=460013184202204&ver=2.5.1&pageIndex=1&appKey=audibleBook",model.coverId];
    view.listchapter=model.chapterCount;
    view.listTitle=model.name;
    view.listImage=model.coverImage;
    view.listplayCount=model.playCount;
    view.listanchor=model.anchor;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [self loadMoreData];
    }
}
- (void)loadMoreData{
    _issearchUrl=_searchUrl;
    _pageIndex += 1;
    [self getRequst];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
