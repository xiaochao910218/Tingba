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
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    NSString *str=self.img;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://ec4.images-amazon.com/images/I/51jurMyudRL._SL500_AA300_.jpg";
    }
    [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"yushe"]];
    UIImageView *backimage=[[UIImageView alloc]initWithFrame:self.view.frame];
    backimage.image=[image.image applyExtraLightEffect];
    self.tableView.backgroundView=backimage;
   
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XCPlayerViewController *audio=[XCPlayerViewController audioPlayerController];
    [audio initWithArray:self.listArr index:indexPath.row];
    audio.menuUrl=self.url;
    audio.menuImg=self.img;
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 108;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 108)];
    view.backgroundColor=[UIColor clearColor];
    UIImageView *image =[UIImageView new];
    UILabel *lab =[UILabel new];
    NSString *str=self.img;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://ec4.images-amazon.com/images/I/51jurMyudRL._SL500_AA300_.jpg";
    }
    [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"yushe"]];

    lab.text=self.des;
    lab.font=[UIFont systemFontOfSize:15];
    lab.numberOfLines=0;
    [view addSubview:image];
    [view addSubview:lab];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(4);
        make.size.mas_equalTo(CGSizeMake(75,100));
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(3);
        make.top.equalTo(image);
        make.right.mas_equalTo(-8);
        make.height.mas_lessThanOrEqualTo(100);
    }];
    
    return view;
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
