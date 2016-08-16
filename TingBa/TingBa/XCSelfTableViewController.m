//
//  XCSelfTableViewController.m
//  TingBa
//
//  Created by 筱超 on 16/8/3.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCSelfTableViewController.h"
#import "XCCommon.h"
#import "XCDataViewController.h"
#import "XCFrontTableViewController.h"
#import "XCCollectionTableViewController.h"
#import "XCHistoryTableViewController.h"
#import "XCClearCacheTool.h"
#import "MBProgressHUD.h"
@interface XCSelfTableViewController ()

@end

@implementation XCSelfTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *image=[[UIImageView alloc]initWithFrame:self.view.frame];
    image.image=[UIImage imageNamed:@"screen.jpg"];
    self.tableView.backgroundView=image;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.671 green:0.749 blue:0.176 alpha:0.6]];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
//        case 1:
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginvc"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//            
//            break;

        case 4:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"firstViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 6:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"collectvc"]]
                                                         animated:YES];
             [self.sideMenuViewController hideMenuViewController];
            
            break;
        case 10:
            [self clickClearMemory];
            break;
        default:
            break;
    }
}

- (IBAction)cancleSwitch:(UISwitch *)sender {
    if (sender.on==1) {
        [[XCDataViewController canclePicture] changeIT];
        [[XCFrontTableViewController canclePicture] noPic];
        [[XCHistoryTableViewController canclePicture] noPicture];
        [[XCCollectionTableViewController canclePicture] canclePicture];
    }else if(sender.on==0){
        [[XCDataViewController canclePicture] backIT];
        [[XCFrontTableViewController canclePicture] hasPic];
        [[XCHistoryTableViewController canclePicture] hasPicture];
        [[XCCollectionTableViewController canclePicture] hasPicture];
    }
    
}
- (void)clickClearMemory{
    
    NSString *path = [XCClearCacheTool getCacheSizeWithFilePath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定清除%@缓存吗?",path] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建一个取消和一个确定按钮
    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
    UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //清楚缓存
        BOOL isSuccess = [XCClearCacheTool clearCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        if (isSuccess) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            });
        }
        
    }];
    //将取消和确定按钮添加进弹框控制器
    [alert addAction:actionCancle];
    [alert addAction:actionOk];
    //添加一个文本框到弹框控制器
    //显示弹框控制器
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)loginIn:(UIButton *)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginvc"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}


@end
