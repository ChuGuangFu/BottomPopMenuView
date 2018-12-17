//
//  YLBottomMenuView.h
//  BottomMenuDemo
//
//  Created by 梁羽 on 2018/4/23.
//  Copyright © 2018年 梁羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLBottomMenuViewClickDelagete <NSObject>
@optional
/** 底部栏的点击事件 - 只在没有子菜单栏的情况下触发 */
-(void)bottomMenuViewClickWithIndex:(NSInteger)index;
/** 子菜单栏的点击事件 */
-(void)subMenuViewClickWithBottomIndex:(NSInteger)bottomIndex subIndex:(NSInteger)subIndex;
@end

@interface YLBottomMenuView : UIView

@property (nonatomic, weak) id<YLBottomMenuViewClickDelagete> delegate;

/**
 初始化底部菜单栏

 @param frame frame
 @param menuArray 一级菜单数组
 @param subMenuArray 二级菜单数组
 */
-(instancetype)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray subMenuArray:(NSArray *)subMenuArray;

@end
