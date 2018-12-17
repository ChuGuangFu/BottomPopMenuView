//
//  ViewController.m
//  底部弹出菜单
//
//  Created by 处光夫 on 2018/12/17.
//  Copyright © 2018 处光夫. All rights reserved.
//

#import "ViewController.h"
#import "YLBottomMenuView.h"

@interface ViewController ()<YLBottomMenuViewClickDelagete>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLBottomMenuView *bottomMenuView = [[YLBottomMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 45, CGRectGetWidth(self.view.frame), 45) menuArray:@[@"1",@"2",@"3",@"4"] subMenuArray:@[@[@"1-1",@"1-2",@"1-3"],@[@"2-1",@"2-2",@"2-3",@"2-4"],@[@"3-1",@"3-2",@"3-3",@"3-4",@"3-5"],@[@"4-1"]]];
    bottomMenuView.delegate = self;
    [self.view addSubview:bottomMenuView];
    
}

/** 底部栏的点击事件 - 只在没有子菜单栏的情况下触发 */
-(void)bottomMenuViewClickWithIndex:(NSInteger)index {
    NSLog(@"主菜单的index：%ld",index);
}

/** 子菜单栏的点击事件 */
-(void)subMenuViewClickWithBottomIndex:(NSInteger)bottomIndex subIndex:(NSInteger)subIndex {
    NSLog(@"主菜单的index：%ld -- 子菜单的index：%ld",bottomIndex + 1,subIndex + 1);
}

@end
