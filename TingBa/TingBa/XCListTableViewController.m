//
//  XCListTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/7/21.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCListTableViewController.h"
#import "XCCommon.h"
#import "XCListTableViewCell.h"
#import "XCListModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "XCPlayerViewController.h"
#import "XMShareView.h"
@interface XCListTableViewController ()
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) XMShareView *shareView;
@property(nonatomic) NSInteger pageindex;
@property(nonatomic)        BOOL px;
@end

@implementation XCListTableViewController
static NSString *isAsc;
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
    __weak XCListTableViewController *vc=self;
    NSString *xcstr=[self.listUrl stringByReplacingOccurrencesOfString:@"pageIndex=1" withString:[NSString stringWithFormat:@"pageIndex=%ld",(long)_pageindex]];
    NSString *str=[xcstr stringByReplacingOccurrencesOfString:@"dir=ASC" withString:[NSString stringWithFormat:@"dir=%@",isAsc]];
    [self.manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
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
    _pageindex=1;
    isAsc=@"ASC";
    self.navigationItem.title=@"目录";
    [self getRequest];
    self.tableView.rowHeight=50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.tintColor=[UIColor redColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"listcell"];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    NSString *str=self.listImage;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://ec4.images-amazon.com/images/I/51jurMyudRL._SL500_AA300_.jpg";
    }
    [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"yushe"]];
    UIImageView *backimage=[[UIImageView alloc]initWithFrame:self.view.frame];
    backimage.image=[image.image applyExtraLightEffect];
    self.tableView.backgroundView=backimage;
   
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XCListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcell" forIndexPath:indexPath];
    XCListModel *model=self.listArr[indexPath.row];
    NSString *str=self.listImage;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://ec4.images-amazon.com/images/I/51jurMyudRL._SL500_AA300_.jpg";
    }

    model.listCoverImage=str;
    cell.backgroundColor=[UIColor clearColor];
    cell.listModel=model;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XCPlayerViewController *audio=[XCPlayerViewController audioPlayerController];
    [audio initWithArray:self.listArr index:indexPath.row];
    audio.menuUrl=self.listUrl;
    audio.menuImg=self.listImage;
    audio.overview=self.listDes;
    [self.navigationController pushViewController:audio animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 135)];
//    view.backgroundColor=[UIColor cyanColor];
    UIImageView *icon=[UIImageView new];
    UILabel *title=[UILabel new];
    UILabel *anchorLab=[UILabel new];
    UILabel *anchor=[UILabel new];
    UILabel *countLab=[UILabel new];
    UILabel *count =[UILabel new];
    UILabel *btnLab=[UILabel new];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *sectionLab=[UILabel new];
    UIView *backView=[UIView new];
    UILabel *listLab=[UILabel new];
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    icon.backgroundColor=[UIColor orangeColor];
    anchorLab.text=@"主 播:";
    anchorLab.font=[UIFont systemFontOfSize:12];
    countLab.text= @"点击量:";
    countLab.font=[UIFont systemFontOfSize:12];
    sectionLab.text=@"章节列表";
    sectionLab.font=[UIFont systemFontOfSize:14];
    title.font=[UIFont systemFontOfSize:15];
    count.font=[UIFont systemFontOfSize:13];
    anchor.font=[UIFont systemFontOfSize:13];
    btnLab.font=[UIFont systemFontOfSize:12];
    
    if ([isAsc isEqualToString:@"ASC"]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"view-sort-descending"] forState:UIControlStateNormal];
        btnLab.text=@"正序";
    }else if([isAsc isEqualToString:@"DESC"]){
        [btn setBackgroundImage:[UIImage imageNamed:@"view-sort-ascending"] forState:UIControlStateNormal];
        btnLab.text=@"倒序";
    }

    [btn addTarget:self action:@selector(changeAsc:) forControlEvents:UIControlEventTouchUpInside];
    backView.backgroundColor=[UIColor redColor];
    NSString *str=self.listImage;
    if ([[NSNull null] isEqual:str]) {
        str=@"http://ec4.images-amazon.com/images/I/51jurMyudRL._SL500_AA300_.jpg";
    }
    [icon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"yushe"]];
    NSString *anchorStr=self.listanchor;
    if ([[NSNull null] isEqual:anchorStr]) {
        anchorStr=@"蜘蛛";
    }
    anchor.text=anchorStr;
    title.text=self.listTitle;
    listLab.text=[NSString stringWithFormat:@"(共 %@ 章)",self.listchapter];
    listLab.font=[UIFont systemFontOfSize:13];
    CGFloat play=[self.listplayCount integerValue];
    NSString *playsall;
    if (play>10000) {
        playsall=[NSString stringWithFormat:@"%.1f万",play/10000];
    }else{
        playsall=[NSString stringWithFormat:@"%.0f",play];
    }
    count.text=playsall;
    [shareBtn setImage:[UIImage imageNamed:@"fx.jpg"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.cornerRadius=8;
    shareBtn.layer.masksToBounds=YES;
    [view addSubview:shareBtn];
    [view addSubview:icon];
    [view addSubview:title];
    [view addSubview:anchor];
    [view addSubview:anchorLab];
    [view addSubview:countLab];
    [view addSubview:count];
    [view addSubview:btn];
    [view addSubview:btnLab];
    [view addSubview:sectionLab];
    [view addSubview:backView];
    [view addSubview:listLab];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(8);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(90);
    }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon);
        make.left.equalTo(icon.mas_right).with.offset(5);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(17);
    }];
    [anchorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.left.equalTo(title);
        make.size.mas_equalTo(CGSizeMake(48, 17));
    }];
    [anchor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(anchorLab);
        make.left.equalTo(anchorLab.mas_right).with.offset(5);
        make.width.equalTo(@(120));
        make.height.equalTo(anchorLab);
    }];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(anchor);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(62, 30));
    }];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(icon);
        make.size.left.equalTo(anchorLab);
    }];
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(countLab);
        make.left.equalTo(countLab.mas_right).with.offset(5);
        make.width.equalTo(@(120));
        make.width.equalTo(countLab);
    }];
    [sectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(icon);
        make.top.equalTo(icon.mas_bottom).with.offset(6);
        make.width.mas_equalTo(62);
        make.height.equalTo(@(21));
    }];
    [listLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(sectionLab);
        make.left.equalTo(sectionLab.mas_right).with.offset(3);
        make.width.mas_equalTo(90);
    }];
    [btnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionLab);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(30);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 24));
        make.centerY.equalTo(btnLab);
        make.right.equalTo(btnLab.mas_left).with.offset(-3);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionLab);
        make.height.mas_equalTo(2);
        make.width.equalTo(sectionLab.mas_width).with.offset(-3);
        make.top.equalTo(sectionLab.mas_bottom).with.offset(0);
    }];
    return view;
}
-(void)changeAsc:(UIButton *)sender{
    [self.listArr removeAllObjects];
    _px=!_px;
    if (_px==YES) {
        isAsc=@"DESC";
    }else{
        isAsc=@"ASC";
    }
    [self getRequest];
    
}
-(void)shareAction:(UIButton *)sender{
    if(!self.shareView){
        self.shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
        self.shareView.alpha = 0.0;
        self.shareView.shareTitle = NSLocalizedString(@"听吧分享", nil);
        NSString *str=[NSString stringWithFormat:@"我在听<<%@>>",self.listTitle];
        self.shareView.shareText = NSLocalizedString(str, nil);
        self.shareView.shareUrl = @"http://blog.sina.com.cn/s/blog_151a38d710102w4sj.html";
        
        [self.view addSubview:self.shareView];
        
        [UIView animateWithDuration:1 animations:^{
            self.shareView.alpha = 1.0;
        }];
        
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.shareView.alpha = 1.0;
        }];
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 135;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
- (IBAction)playerAction:(UIBarButtonItem *)sender {
    XCPlayerViewController *vc=[XCPlayerViewController audioPlayerController];
    if (vc.isPlaying) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIAlertController *alertCV=[UIAlertController alertControllerWithTitle:@"提示" message:@"没有正在播放的书籍或电台" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//             [self presentViewController:vc animated:YES completion:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {}];
        [alertCV addAction:action1];
        [alertCV addAction:action2];
        [self presentViewController:alertCV animated:YES completion:nil];
    }
   
}

@end
