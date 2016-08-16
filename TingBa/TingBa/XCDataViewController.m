//
//  XCDataViewController.m
//  TingBa
//
//  Created by 筱超 on 16/7/18.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCDataViewController.h"
#import "XCCommon.h"
#import "XCListTableViewController.h"
#import "XCListModel.h"
#import "XCDataBaseTool.h"
#import "XCPlayerViewController.h"
#import "CBAutoScrollLabel.h"
#import "XCRotatingView.h"
@interface XCDataViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableArray *frontArr;
@property (nonatomic,strong) NSArray *radioArr;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic)BOOL isRefresh;
@property (nonatomic)BOOL isPlay;


//播放
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *underImageView;

@property (strong, nonatomic)  UIImageView *iconImg;
@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic)  UIButton *playerBtn;


@property (strong, nonatomic) XCRotatingView *rotatingView;

@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *titleVieew;


@property (weak, nonatomic) IBOutlet UIButton *xcbtn;


@end

@implementation XCDataViewController
static XCDataViewController *datavc;
static int isHe=0;
+(XCDataViewController *)canclePicture
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datavc=[[XCDataViewController alloc]init];
    });
    return datavc;
}
-(void)changeIT{
    isHe=1;
//    [self.collectionView reloadData];
}
-(void)backIT{
    isHe=0;
//    [self.collectionView reloadData];
}
static NSInteger tag=1;
static NSString *itemIdentifier = @"item";
static NSString *itemIdentifier1 = @"item1";
static NSString *headerIdentifier = @"header";

-(NSMutableArray *)frontArr{
    if (!_frontArr) {
        _frontArr=[NSMutableArray array];
    }
    return _frontArr;
}
-(NSArray *)radioArr{
    if (!_radioArr) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"live" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *muArr=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            XCRadioModel *model = [XCRadioModel radioModelWithDictionary:dict];
            [muArr addObject:model];
        }
        _radioArr =muArr;
    }
    return _radioArr;
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

-(void)getRequest{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    __weak XCDataViewController *vc=self;
    [self.manager GET:_urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSMutableArray *muArr=[NSMutableArray array];
        if (tag==1) {
            NSArray *arr=dict[XCFrontPage];
            for (NSDictionary *dic in arr) {
                NSDictionary *frDic=dic[@"book"];
                NSMutableDictionary *xdic=[NSMutableDictionary dictionaryWithDictionary:frDic];
                NSArray *keyArr=@[@"name",@"overview",@"playCount",@"coverImage",@"id",@"author",@"anchor",@"chapterCount"];
                NSArray *keys=[frDic allKeys];
                for (NSString *key in keys) {
                    if (![keyArr containsObject:key]) {
                        [xdic removeObjectForKey:key];
                    }
                }
                NSMutableDictionary *dictr=xdic;
                 NSString *str=@"很纯很暧昧";
                NSString *str1=@"校花的贴身高手";
                BOOL isdic;
                if ([dictr[@"name"] isEqualToString:str]||[dictr[@"name"] isEqualToString:str1]) {
                    isdic=YES;
                }
                if (isdic==NO) {
                    [XCDataBaseTool updateStatementsSql: INSERT_HOMELIST_SQL withParsmeters:dictr block:^(BOOL isOk, NSString *errorMsg) {
                        if (isOk) {
                            
                        }
                    }];
                }
                
                isdic=NO;
                XCFrontModel *front=[XCFrontModel frontModelWithDictionary:frDic];
                BOOL isit;
                
                if ([front.name isEqualToString:str]||[front.name isEqualToString:str1]) {
                    isit=YES;
                }
                if (isit==NO) {
                    [muArr addObject:front];
                }
                isit=NO;
                
          }
            NSArray *temp=[muArr subarrayWithRange:NSMakeRange(0, 8)];
            
            [vc.frontArr addObjectsFromArray:temp];
        }
        if(tag==2){
            NSDictionary *channelDict=dict[@"channel"];
            NSArray *chaArr=channelDict[@"channel"];
            for (NSDictionary *cdict in chaArr) {
                XCChannelModel *model =[XCChannelModel channelModelWithDictionary:cdict];
                [muArr addObject:model];
            }
            NSArray *temp=[muArr subarrayWithRange:NSMakeRange(1, muArr.count-1)];
            [vc.frontArr addObjectsFromArray:temp];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--------%@-------",error);
        [SVProgressHUD showErrorWithStatus:@"没网哦"];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    XCPlayerViewController *vc=[XCPlayerViewController audioPlayerController];
       [self creatViews];
    self.titleVieew.text=vc.playingModel.listTitle;
    self.titleVieew.labelSpacing=30;
    self.titleVieew.pauseInterval=1.8f;
    self.titleVieew.scrollSpeed=30;
    self.titleVieew.fadeLength=12.f;
    self.titleVieew.font=[UIFont systemFontOfSize:12];
    if (vc.isPlaying==NO) {
        [self.rotatingView pauseLayer];
        [self.xcbtn setImage:[UIImage imageNamed:@"MusicPlayer_暂停"] forState:UIControlStateNormal];
    }else if(vc.isPlaying==YES){
        [self.rotatingView resumeLayer];
        
        [self.xcbtn setImage:[UIImage imageNamed:@"MusicPlayer_播放"] forState:UIControlStateNormal];
    }
    
}
- (void)creatViews{
    XCPlayerViewController *vc=[XCPlayerViewController audioPlayerController];
    self.rotatingView = [[XCRotatingView alloc] init];
    self.rotatingView.imageView.image = [UIImage imageNamed:@"yushe"];
    [self.playerView addSubview:self.rotatingView];
    self.rotatingView.frame = CGRectMake(10, 0, 44, 44);
    self.rotatingView.center = CGPointMake(34,22);
    [self.rotatingView setRotatingViewLayoutWithFrame:self.rotatingView.frame];
    
    [self.rotatingView addAnimation];
    self.underImageView.image = [UIImage imageNamed:@"音乐_播放器_默认模糊背景"];
    [self.rotatingView.imageView sd_setImageWithURL:[NSURL URLWithString:vc.playingModel.listCoverImage] placeholderImage:[UIImage imageNamed:@"yushe"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.underImageView.image = [image applyDarkEffect];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    //    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.671 green:0.749 blue:0.176 alpha:0.6]];
    self.navigationItem.title=@"首页";
    self.playerBtn.layer.cornerRadius=20;
    self.playerBtn.layer.masksToBounds=YES;
    [self addsubview];
    _urlStr=JINGXUANURL;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextInfo:) name:@"send" object:nil];
    [self getUrl];
    if (tag==1) {
        __weak XCDataViewController *dataVC=self;
        [XCDataBaseTool selectStatementsSql:SELECT_HOMELIST_ALL withParsmeters:nil forMode:nil block:^(NSMutableArray *resposeOjbc, NSString *errorMsg) {
            if (resposeOjbc.count!=0) {
                NSMutableArray *muarr=[NSMutableArray array];
                for (NSMutableDictionary *dDict in resposeOjbc) {
                    XCFrontModel *md=[XCFrontModel frontModelWithDictionary:dDict];
                    [muarr addObject:md];
                }
                NSArray *temp=[muarr subarrayWithRange:NSMakeRange(0, 8)];
                [dataVC.frontArr addObjectsFromArray:temp];
            }
            else{
                [self getRequest];
            }
            
        }];
        
    }
    if (tag==2) {
        [self getRequest];
    }
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置属性
    //行间距
    _flowLayout.minimumLineSpacing = 8;
    //item间距
    
    //设置section头视图悬浮
    _flowLayout.sectionHeadersPinToVisibleBounds = NO;
    //创建并添加collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGTH-108) collectionViewLayout:_flowLayout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    //设置数据源和代理
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    //注册UICollectionViewCell
    if (tag == 1) {
        CGFloat width=(WIDTH-276)/4;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XCFrontCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:itemIdentifier];
        _flowLayout.minimumInteritemSpacing = width;
        _flowLayout.headerReferenceSize = CGSizeMake(40, 40);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,width, 0,width);
    }
    //注册SupplementaryView
    if (tag==2) {
        CGFloat width=(WIDTH-264)/5;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XCChannelCVC class]) bundle:nil] forCellWithReuseIdentifier:itemIdentifier];
        _flowLayout.minimumInteritemSpacing = width;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,width, 0,width);
        _flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    }
    if (tag==3) {
        CGFloat width=(WIDTH-200)/5;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XCRadioCVCStyle1 class]) bundle:nil] forCellWithReuseIdentifier:itemIdentifier];
        _flowLayout.minimumInteritemSpacing = width;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XCRadioStyle2 class]) bundle:nil] forCellWithReuseIdentifier:itemIdentifier1];
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,width, 0,width);
    }
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    
}
-(void)addsubview{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.titleLabel.font=[UIFont systemFontOfSize:16];
    btn1.tag=1;
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"icon_ios_search"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"footer"] forState:UIControlStateNormal];
    [btn2 setTintColor:[UIColor redColor]];
    btn2.titleLabel.font=[UIFont systemFontOfSize:16];
    btn2.tag=2;
    [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    [view addSubview:btn2];
    CGFloat width=(view.frame.size.width-192)/3;
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(width);
        make.centerY.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1.mas_right).with.offset(width);
        make.centerY.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    self.navigationItem.titleView=view;
}

-(void)btnAction:(UIButton *)sender{
    if (sender.tag==1) {
        UIViewController *searchVC=[self.storyboard instantiateViewControllerWithIdentifier:@"searchvc"];
        [self.navigationController pushViewController:searchVC animated:YES];
    }if (sender.tag==2) {
        UIViewController *searchVC=[self.storyboard instantiateViewControllerWithIdentifier:@"historyvc"];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

-(void)getUrl{
    switch (tag) {
        case 1:
            _urlStr=JINGXUANURL;
            break;
        case 2:
            _urlStr=FEILEIURL;
            break;
        default:
            break;
    }
}

-(void)changeTextInfo:(NSNotification *)notifition
{
    NSDictionary *dict =notifition.userInfo;
    
    tag=[dict[@"tag"] integerValue];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    switch (tag) {
        case 1:
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        default:
            break;
    }
    return 1;
}
//section中的item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (tag) {
        case 1:
        case 2:
            return self.frontArr.count;
            break;
        case 3:{
            if (section==0) {
                _flowLayout.headerReferenceSize = CGSizeMake(0, 0);
                return [self.radioArr subarrayWithRange:NSMakeRange(0, 4)].count;
                
            }else if(section ==1){
                _flowLayout.headerReferenceSize = CGSizeMake(40, 40);
                return [self.radioArr subarrayWithRange:NSMakeRange(3, self.radioArr.count-4)].count;
            }
            
        }
            break;
        default:
            break;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (tag==1) {
        XCFrontCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
        //获取cell对应的模型
        XCFrontModel *model = self.frontArr[indexPath.item];
        if (isHe==1) {
            model.coverImage=nil;
        }
        item.frontModel=model;
        return item;
    }else if(tag==2){
        XCChannelCVC *item=[collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
        XCChannelModel *model = self.frontArr[indexPath.item];
        item.channelModel=model;
        return item;
    }
    if (tag==3) {
        
        if (indexPath.section==0) {
            XCRadioModel *model=[self.radioArr subarrayWithRange:NSMakeRange(0, 4)][indexPath.row];
            XCRadioCVCStyle1 *item=[collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
            item.radioModel=model;
            return item;
        }else if(indexPath.section==1){
            XCRadioModel *model=[self.radioArr subarrayWithRange:NSMakeRange(4, self.radioArr.count-4)][indexPath.row];
            XCRadioStyle2 *item=[collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier1 forIndexPath:indexPath];
            item.radioModel= model;
            return item;
        }
        
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XCListTableViewController *listVC=[self.storyboard instantiateViewControllerWithIdentifier:@"listtablevc"];
    
    XCFrontTableViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"fronttableview"];
    [self.xcbtn setImage:nil forState:UIControlStateNormal];
    if (tag==1) {
        XCFrontModel *model=self.frontArr[indexPath.row];
//        listVC.listTag=1;
        listVC.listImage=model.coverImage;
        listVC.listTitle=model.name;
        listVC.listchapter=model.chapterCount;
        listVC.listanchor=model.anchor;
        listVC.listplayCount=model.playCount;
        listVC.listDes=model.coverview;
        listVC.listUrl=[NSString stringWithFormat: @"http://api.iting360.com:8080/audible-book/service/audioBooksV2/getBookChaptersByPage?market=k-app360&dir=ASC&pageSize=20&bookId=%@&imsi=460013184202204&ver=2.5.1&pageIndex=1&appKey=audibleBook",model.coverId];
        
        [self.navigationController pushViewController:listVC animated:YES];
    }
    if (tag==2) {
        XCChannelModel *model = self.frontArr[indexPath.row];
        view.url=[NSString stringWithFormat:@"http://api.iting360.com:8080/audible-book/service/audioBooks/getBooksByPage?market=k-app360&channelId=%@&bookSort=playCount&pageSize=20&imsi=460013184202204&ver=2.5.1&pageIndex=1&appKey=audibleBook",model.channnelId];
        view.page=tag;
        view.fronttitle=model.chanelName;
        view.channelId=model.channnelId;
        [self.navigationController pushViewController:view animated:YES];
    }
    if (tag==3) {
        if(indexPath.section==0){
            XCRadioModel *model=[self.radioArr subarrayWithRange:NSMakeRange(0, 4)][indexPath.row];
            view.url=[NSString stringWithFormat:@"http://api.iting360.com:8080/audible-book/service/audioBooks/getRadioByPage?pageSize=20&imsi=460013184202204&market=k-app360&ver=2.5.1&channelId=%@&pageIndex=1&appKey=audibleBook",model.channelId];
        }
        else if(indexPath.section==1){
            XCRadioModel *model=[self.radioArr subarrayWithRange:NSMakeRange(4, self.radioArr.count-4)][indexPath.row];
            view.url=[NSString stringWithFormat:@"http://api.iting360.com:8080/audible-book/service/audioBooks/getRadioByPage?pageSize=20&imsi=460013184202204&market=k-app360&ver=2.5.1&channelId=%@&pageIndex=1&appKey=audibleBook",model.channelId];
        }
        
        view.page=tag;
        [self.navigationController pushViewController:view animated:YES];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    if(tag==1){
        UILabel *lab=[UILabel new];
        lab.text=@"听友推荐";
        lab.textColor=[UIColor redColor];
        lab.font=[UIFont systemFontOfSize:16];
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"全部 >>" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoMore:) forControlEvents:UIControlEventTouchUpInside];
        [reusableView addSubview:lab];
        [reusableView addSubview:btn];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.mas_equalTo(reusableView);
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-10);
            make.centerY.equalTo(reusableView);
            make.size.mas_equalTo(CGSizeMake(50, 44));
        }];
    }
    if(tag==3){
        if (indexPath.section==1) {
            UILabel *lab=[UILabel new];
            lab.text=@"主题";
            lab.textColor=[UIColor blackColor];
            lab.font=[UIFont systemFontOfSize:16];
            [reusableView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(8);
                make.centerY.mas_equalTo(reusableView);
            }];
        }
    }
    return reusableView;
}
-(void)gotoMore:(UIButton *)sender{
    XCFrontTableViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"fronttableview"];
    view.page=tag;
    view.url=JINGXUANURL;
    view.fronttitle=@"好友推荐";
    [self.navigationController pushViewController:view animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(tag==1){
        return CGSizeMake(92, 126);
    }
    if (tag==2) {
        return CGSizeMake(66 , 87);
    }
    if (tag==3) {
        if (indexPath.section==0) {
            return CGSizeMake(50, 80);
        }else if(indexPath.section==1){
            int width=(WIDTH-200)/5;
            NSInteger width1=100+width;
            return CGSizeMake(width1, 34);
        }
    }
    return CGSizeZero;
}

- (IBAction)xcplayer:(UIButton *)sender {
    XCPlayerViewController *vc=[XCPlayerViewController audioPlayerController];
    [vc playerStatus];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];//动画移动的目标
    animation.duration = 5;//时间
    animation.repeatCount = MAXFLOAT;//循环次数
    animation.cumulative = NO;//动画结束复位;
    if (vc.playingModel.listTitle==nil) {
        UIAlertController *alertCV=[UIAlertController alertControllerWithTitle:@"提示" message:@"没有正在播放的书籍或电台" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {}];
        [alertCV addAction:action1];
        [alertCV addAction:action2];
        [self presentViewController:alertCV animated:YES completion:nil];
    }else{
        if (vc.isPlaying==NO) {
            [self.rotatingView pauseLayer];
            
            [self.xcbtn setImage:[UIImage imageNamed:@"MusicPlayer_暂停"] forState:UIControlStateNormal];
        }else{
            [self.rotatingView resumeLayer];
            [self.xcbtn setImage:[UIImage imageNamed:@"MusicPlayer_播放"] forState:UIControlStateNormal];
        }
    }
    
}


@end
