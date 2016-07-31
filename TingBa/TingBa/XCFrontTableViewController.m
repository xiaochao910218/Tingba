//
//  XCFrontTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/7/19.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCFrontTableViewController.h"
#import "XCCommon.h"
static NSString  *KFileName=@"XCHistoryNovel.plist";
@interface XCFrontTableViewController ()
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property(nonatomic)NSInteger pageindex;
@property (nonatomic,strong) NSArray *titlesArr;
@property (nonatomic) NSArray *chaId;
@property (nonatomic,strong) NSMutableArray *frontArr;
@property (nonatomic,strong) XCNovelTitle *titleScrollView;
@property (nonatomic) NSInteger lableId;
@property (nonatomic,strong) NSString *strUrl;
@property (nonatomic,strong) NSString *audioImg;
@property (nonatomic,strong) NSString *audioUrl;
@property(nonatomic,strong) NSMutableArray *listArr;
@property (nonatomic)BOOL isRefresh;
@property(nonatomic,strong)NSString *filePath;

@end

@implementation XCFrontTableViewController
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr=[NSMutableArray array];
    }
    return _listArr;
}
-(NSArray *)chaId{
    if (!_chaId) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"titles" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *muArr=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            XCTitlesModel *model=[XCTitlesModel titlesModelWithDictionary:dict];
            [muArr addObject:model.lableId];
        }
        _chaId=muArr;
    }
    return _chaId;
}

-(NSArray *)titlesArr{
    if (!_titlesArr) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"titles" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *muArr=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            XCTitlesModel *model=[XCTitlesModel titlesModelWithDictionary:dict];
            [muArr addObject:model.title];
            
        }
        _titlesArr=muArr;
    }
    return _titlesArr;
}

-(NSMutableArray *)frontArr{
    if (!_frontArr) {
        _frontArr=[NSMutableArray array];
    }
    return _frontArr;
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
    if (_pageindex==2){
        _pageindex=4;
    }
    __weak XCFrontTableViewController *vc=self;
    if ([self.channelId integerValue] == 35) {
        _strUrl=[_url stringByReplacingOccurrencesOfString:@"ver=2.5.1&pageIndex=1" withString:[NSString stringWithFormat:@"ver=2.5.1&labelId=%ld&pageIndex=%ld",self.lableId,_pageindex]];
        if (self.lableId==140||self.lableId==141||self.lableId==9) {
            _strUrl=[_strUrl stringByReplacingOccurrencesOfString:@"bookSort=playCount" withString:@"bookSort=updatedTime"];
        }
    }
    else{
        _strUrl=[_url stringByReplacingOccurrencesOfString:@"pageIndex=1" withString:[NSString stringWithFormat:@"pageIndex=%ld",_pageindex]];
    }
    
    [self.manager GET:_strUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if (self.page==1) {
            NSArray *arr=dict[XCFrontPage];
            for (NSDictionary *dic in arr) {
                NSDictionary *frDic=dic[@"book"];
                XCFrontModel *front=[XCFrontModel frontModelWithDictionary:frDic];
                BOOL isit;
                NSString *str=@"很纯很暧昧";
                NSString *str1=@"校花的贴身高手";
                if ([front.name isEqualToString:str]||[front.name isEqualToString:str1]) {
                    isit=YES;
                }
                if (isit==NO) {
                    [vc.frontArr addObject:front];
                }
                isit=NO;
                
            }
        }
        if (self.page==2) {
            NSArray *arr =dict[@"book"];
            for (NSDictionary *chanDict in arr) {
                XCFrontModel *front=[XCFrontModel frontModelWithDictionary:chanDict];
                [vc.frontArr addObject:front];
            }
            
        }
        if(self.page==3){
            NSArray *arr=dict[XCNovelRadioAudioRadio];
            for (NSDictionary *chanDict in arr) {
                XCRDataModel *front=[XCRDataModel rDataModelWithDictionary:chanDict];
                [vc.frontArr addObject:front];
            }

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc.tableView reloadData];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--------%@-------",error);
        [SVProgressHUD showErrorWithStatus:@"没网哦"];
    }];
}

-(void)getAudioList{
    __weak XCFrontTableViewController *vc=self;
    
    [self.manager GET:self.audioUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        [vc.listArr removeAllObjects];
        NSArray *array=dict[@"chapter"];
        for (NSDictionary *listdict in array) {
            XCListModel *model=[XCListModel listModelWithDictionary:listdict];
            model.listCoverImage=_audioImg;
            [vc.listArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self gotoss];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"亲 网速不好"];
    }];
}

-(XCNovelTitle *)titleScrollView{
    if (_titleScrollView == nil) {
        _titleScrollView = [XCNovelTitle titleScrollViewWithTitles:self.titlesArr];
        __weak XCFrontTableViewController *weakSelf = self;
        _titleScrollView.changeContentVC = ^(NSUInteger index){
            weakSelf.lableId=[weakSelf.chaId[index] integerValue];
            [weakSelf.frontArr removeAllObjects];
            [weakSelf getRequest];
            
        };
    }
    return _titleScrollView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor redColor];
    self.navigationItem.title=self.fronttitle;
    
    
    _pageindex=1;
    _lableId=9;
    self.tableView.showsVerticalScrollIndicator=NO;
    [self getRequest];
    if (self.page==1||self.page==2) {
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCFrontTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"morecell"];
        self.tableView.rowHeight=105;
    }if (self.page==3) {
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCRDataTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"morecell1"];
        self.tableView.rowHeight=76;
        self.navigationItem.title=@"广播";
    }
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-44, 44)];
    [view addSubview:self.titleScrollView];
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.equalTo(view);
        make.height.equalTo(view);
        make.top.mas_equalTo(0);
    }];
    if (self.page==2&&[self.channelId integerValue]==35) {
        self.navigationItem.titleView=view;
    }
    
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.frontArr.count;
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.page==1||self.page==2) {
   
    XCFrontModel *model=self.frontArr[indexPath.row];
    XCFrontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"morecell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor clearColor];
    cell.model=model;
    return cell;
    }
    if (self.page==3) {
        
        XCRDataModel *model=self.frontArr[indexPath.row];
        XCRDataTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"morecell1" forIndexPath:indexPath];
         cell.dataModel=model;
       
         cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.page!=3) {
        XCListTableViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"listtablevc"];
        XCFrontModel *model=self.frontArr[indexPath.row];

        view.listUrl=[NSString stringWithFormat: @"http://api.iting360.com:8080/audible-book/service/audioBooksV2/getBookChaptersByPage?market=k-app360&dir=ASC&pageSize=20&bookId=%@&imsi=460013184202204&ver=2.5.1&pageIndex=1&appKey=audibleBook",model.coverId];
        view.listchapter=model.chapterCount;
        view.listTitle=model.name;
        view.listImage=model.coverImage;
        view.listplayCount=model.playCount;
        view.listanchor=model.anchor;
        [self.navigationController pushViewController:view animated:YES];
    }if (self.page==3) {
        XCRDataModel *model=self.frontArr[indexPath.row];
        _audioUrl=[NSString stringWithFormat:@"http://api.iting360.com:8080/audible-book/service/audioBooks/getChapterPreBySort?preType=BEFORE&market=k-app360&bookId=%@&number=1&imsi=460013184202204&ver=2.5.1&size=20&appKey=audibleBook",model.radioId];
        _audioImg=model.radioImage;
        [self getAudioList];
    }
    
    
}
-(void)gotoss{
    XCPlayerViewController *audio=[XCPlayerViewController audioPlayerController];
    [audio initWithArray:self.listArr index:0];
    
    [self.navigationController pushViewController:audio animated:YES];
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
- (IBAction)playerClick:(UIBarButtonItem *)sender {
    XCPlayerViewController *vc=[XCPlayerViewController audioPlayerController];
    if (vc.isPlaying) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIAlertController *alertCV=[UIAlertController alertControllerWithTitle:@"提示" message:@"没有正在播放的书籍或电台" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {}];
        [alertCV addAction:action1];
        [alertCV addAction:action2];
        [self presentViewController:alertCV animated:YES completion:nil];
    }

}


@end
