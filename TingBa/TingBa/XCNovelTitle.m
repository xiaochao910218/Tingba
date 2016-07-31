//
//  XCNovelTitle.m
//  TingBa
//
//  Created by 筱超 on 16/7/20.
//  Copyright © 2016年 筱超. All rights reserved.
//

#import "XCNovelTitle.h"
#import "Masonry.h"
@implementation XCNovelTitle

+(instancetype)titleScrollViewWithTitles:(NSArray *)titles
{
    XCNovelTitle *titleScrollView=[XCNovelTitle new];
    
    titleScrollView.showsHorizontalScrollIndicator=NO;
    for (int i=0; i<titles.count; i++) {
        UIButton *titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [titleScrollView addSubview:titleBtn];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [titleBtn setTitle:titles[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        titleBtn.tag = 1000 + i;
        
        [titleBtn addTarget:titleScrollView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@10);
                make.centerY.mas_equalTo(0);
            }];
        }else if(i==titles.count-1){
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                UIButton *previousBtn=(UIButton *)[titleScrollView viewWithTag:titleBtn.tag-1];
                make.left.equalTo(previousBtn.mas_right).with.offset(30);
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(0);
            }];
        }else
        {
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                UIButton *previousBtn=(UIButton *)[titleScrollView viewWithTag:titleBtn.tag-1];
                make.left.equalTo(previousBtn.mas_right).with.offset(30);
                make.centerY.mas_equalTo(0);
            }];
        }
    }
    titleScrollView.currentIndex=0;
    return titleScrollView;
}
-(void)btnClick:(UIButton *)sender{
    self.currentIndex = sender.tag - 1000;
    if (_changeContentVC) {
        _changeContentVC(self.currentIndex);
    }
}

-(void)setCurrentIndex:(NSUInteger)currentIndex
{
    //1.根据_currentIndex设置之前选中的栏目的标题为黑色
    UIButton *previousBtn = [self viewWithTag:1000 + _currentIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previousBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [previousBtn setBackgroundImage:nil forState:UIControlStateNormal];
    //2.根据currentIndex将要选中的栏目的标题为红色
    UIButton *willSelectedBtn = [self viewWithTag:1000 + currentIndex];
    [willSelectedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    willSelectedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [willSelectedBtn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    willSelectedBtn.layer.cornerRadius=10;
    willSelectedBtn.layer.masksToBounds=YES;
    //3.保存选中的栏目的索引
    _currentIndex = currentIndex;
    //4.计算偏移量
    CGFloat detalValue = willSelectedBtn.center.x - self.center.x;
    if (detalValue < 0) {
        detalValue = 0;
    }else if (detalValue > self.contentSize.width - self.frame.size.width){
        detalValue = self.contentSize.width - self.frame.size.width;
    }
    //5.设置偏移量
    [self setContentOffset:CGPointMake(detalValue, 0) animated:YES];
    
}



@end
