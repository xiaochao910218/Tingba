//
//  XCSearchTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/7/23.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCSearchTableViewController.h"
#import "XCCommon.h"
#import "XCFrontTableViewCell.h"
#import "XCListTableViewController.h"

#define BASEURL @"http://api.iting360.com:8080/audible-book/service/audioBooks/findBooksByPageV2?market=k-app360&pageSize=20&imsi=460013184202204&ver=2.5.1&type=book&pageIndex=1&appKey=audibleBook&"

@interface XCSearchTableViewController ()<UISearchBarDelegate>
{
    
    __weak UISearchBar *_searchBar;
}
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
    NSString *url=[NSString stringWithFormat:@"%@&keyword=%@",BASEURL,_searchUrl];
    __weak XCSearchTableViewController *vc=self;
    url=[url stringByReplacingOccurrencesOfString:@"pageIndex=1" withString:[NSString stringWithFormat:@"pageIndex=%ld",(long)self.pageIndex]];
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if (_searchUrl!=_issearchUrl) {
            [vc.searchArr removeAllObjects];
        }
        NSArray *array=dict[@"book"];
        for (NSDictionary *listdict in array) {
            XCFrontModel *front=[XCFrontModel frontModelWithDictionary:listdict];
            [vc.searchArr addObject:front];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"亲 网速不好"];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex=1;
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.placeholder = @"请输入关键字";
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 0, WIDTH, 44);
    self.navigationItem.titleView=searchBar;
    _searchBar = searchBar;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCFrontTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"morecell"];
    self.tableView.rowHeight=105;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    
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

// 当SearchBar的内容发生变化的时候就会调用这个方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchUrl=[searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  characterSetWithCharactersInString:searchText]];
    [self getRequst];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
     [_searchBar resignFirstResponder];
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [self loadMoreData];
    }
}
- (void)loadMoreData{
    _issearchUrl=_searchUrl;
    _pageIndex += 1;
    [self getRequst];
    
}

@end
