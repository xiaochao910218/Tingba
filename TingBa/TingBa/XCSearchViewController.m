//
//  XCSearchViewController.m
//  TingBa
//
//  Created by 筱超 on 16/8/16.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCSearchViewController.h"
#import "XLSphereView.h"
#import "XCSearchTableViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kClearButtonWidth 160

@interface XCSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong , nonatomic) UITableView * tableView;
@property (strong,nonatomic) UISearchBar *searchBar;
@property NSMutableArray *dataSource;
@property NSMutableArray * SearchArray;
@property (nonatomic, strong) NSArray *searchNameArray;
@property (nonatomic,strong) XLSphereView *sphereView;
@end
int pn=0;
@implementation XCSearchViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView  reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"搜索"];
    
    CGRect  frame=self.navigationController.navigationBar.frame;
    frame.origin.y=0;
    UIView *titleView=[[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor clearColor]];
    frame.size.width-=80;
    _searchBar=[[UISearchBar alloc]initWithFrame:frame];
    _searchBar.backgroundColor=[UIColor clearColor];
    [_searchBar setTintColor:[UIColor grayColor]];
    [_searchBar setPlaceholder:@"菜谱搜索"];
    _searchBar.delegate=self;
    _searchBar.layer.cornerRadius=2;
    _searchBar.layer.masksToBounds=YES;
    [titleView addSubview:_searchBar];
    self.navigationItem.titleView=titleView;
    self.view.backgroundColor=[UIColor blackColor];
    [self gainData];
    //self.view.backgroundColor = [UIColor grayColor];
    CGFloat sphereViewW = self.view.frame.size.width - 30 * 2;
    CGFloat sphereViewH = sphereViewW;
    _sphereView = [[XLSphereView alloc] initWithFrame:CGRectMake(30, 40, sphereViewW, sphereViewH)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 28; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        //[btn setTitle:[NSString stringWithFormat:@"🍎%ld", i] forState:UIControlStateNormal];
        //[btn setTitle:_searchNameArray[arc4random()% 28] forState:UIControlStateNormal];
        [btn setTitle:_searchNameArray[i * 4 + arc4random()% 4] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:24.];
        btn.frame = CGRectMake(0, 0, 100, 30);
        btn.layer.cornerRadius = 3;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [_sphereView addSubview:btn];
    }
    //[_sphereView setCloudTags:array];
    [_sphereView setItems:array];
    [self.view addSubview:_sphereView];
    //TableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, sphereViewH+45, kScreenWidth, self.view.frame.size.height-sphereViewH-45)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_tableView];
    [self getData];
    
    //清除历史记录按钮
    UIButton *btn_clear=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-kClearButtonWidth)/2, self.view.frame.size.height-108, kClearButtonWidth, 30)];
    [btn_clear setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [btn_clear setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn_clear.layer.borderColor=[UIColor orangeColor].CGColor;
    btn_clear.layer.borderWidth=1;
    btn_clear.layer.cornerRadius=5;
    
    [btn_clear addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_clear];

}
- (void)gainData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"biaoqian" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    
    NSString *string = dict[@"keyword"];
    
    _searchNameArray = [string componentsSeparatedByString:@","];
}

- (void)buttonPressed:(UIButton *)btn
{
    XCSearchTableViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"searchtab"];;
    vc.searchStr=btn.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)clearHistory:(UIButton *)button{
   
    _SearchArray =[NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setObject:_SearchArray forKey:@"search"];
    [_tableView reloadData];
}

-(void)getData{
    //加载搜索历史记录
    NSArray * arry= [[NSUserDefaults standardUserDefaults] arrayForKey:@"search"];
    if (_SearchArray==nil) {
        _SearchArray=[NSMutableArray array];
    }
    _SearchArray= [NSMutableArray arrayWithArray:arry];
    [_tableView reloadData];
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   
    if ([_SearchArray containsObject:searchBar.text]) {
        NSUInteger index=[_SearchArray indexOfObject:searchBar.text];
        [_SearchArray removeObjectAtIndex:index];
    }
    
    [_SearchArray insertObject:searchBar.text atIndex:0];
    [_tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:_SearchArray forKey:@"search"];
    XCSearchTableViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"searchtab"];
    vc.searchStr=searchBar.text;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark - UITableView
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [_SearchArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSUserDefaults standardUserDefaults] setObject:_SearchArray forKey:@"search"];
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//点击历史记录直接搜索
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _searchBar.text=[_SearchArray objectAtIndex:indexPath.row];
    [self searchBarSearchButtonClicked:_searchBar];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _SearchArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    
    //    if (indexPath.row<8) {
    //        cell.textLabel.text=nil;
    //    }else{
    cell.textLabel.text=[_SearchArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:22];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //    }
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
