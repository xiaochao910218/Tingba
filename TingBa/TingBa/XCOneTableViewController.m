//
//  XCOneTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/7/26.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCOneTableViewController.h"
#import "XCCommon.h"
#import "XCListOneTableViewCell.h"
#import "XCListModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

@interface XCOneTableViewController ()
@property(nonatomic) NSInteger pageindex;
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property(nonatomic,strong) NSMutableArray *listArr;
@end

@implementation XCOneTableViewController
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr=[NSMutableArray array];
    }
    return _listArr;
}
-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager=[AFHTTPSessionManager manager];
        _manager.reachabilityManager=[AFNetworkReachabilityManager sharedManager];
        [_manager.reachabilityManager startMonitoring];
    }
    return _manager;
}

-(void)getRequest{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    __weak XCOneTableViewController *vc=self;
    NSString *xcstr=[self.url stringByReplacingOccurrencesOfString:@"pageIndex=1" withString:[NSString stringWithFormat:@"pageIndex=%ld",(long)_pageindex]];
    [self.manager GET:xcstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSArray *array=dict[@"chapter"];
        for (NSDictionary *listdict in array) {
            XCListModel *model=[XCListModel listModelWithDictionary:listdict];
            [vc.listArr addObject:model];
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
    self.tableView.showsVerticalScrollIndicator=NO;
    _pageindex=1;
    [self getRequest];
    self.tableView.rowHeight=48;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCListOneTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"listcell"];
   
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

    return self.listArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XCListOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcell" forIndexPath:indexPath];
    XCListModel *model=self.listArr[indexPath.row];
    NSString *str=self.img;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://ec4.images-amazon.com/images/I/51jurMyudRL._SL500_AA300_.jpg";
    }
    model.listCoverImage=str;
    cell.backgroundColor=[UIColor clearColor];
    cell.listModel=model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    view.backgroundColor=[UIColor orangeColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *lab=[UILabel new];
    lab.text=@"目录";
    [btn setImage:[UIImage imageNamed:@"MusicPlayer_后退"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(xbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    lab.font=[UIFont systemFontOfSize:15];
    lab.textColor=[UIColor purpleColor];
    [view addSubview:btn];
    [view addSubview:lab];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.centerY.equalTo(btn.mas_centerY);
        
    }];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XCPlayerViewController *audio=[XCPlayerViewController audioPlayerController];
    [audio initWithArray:self.listArr index:indexPath.row];
    audio.menuUrl=self.url;
    audio.menuImg=self.img;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)xbtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        [self loadMoreData];
    }
}
- (void)loadMoreData{
    _pageindex += 1;
    [self getRequest];
    
}

@end
