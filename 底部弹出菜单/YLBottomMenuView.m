//
//  YLBottomMenuView.m
//  BottomMenuDemo
//
//  Created by 梁羽 on 2018/4/23.
//  Copyright © 2018年 梁羽. All rights reserved.
//

#import "YLBottomMenuView.h"

static CGFloat const DurationAnimatedTime = 0.2;

@interface YLBottomMenuView ()
@property (nonatomic, strong) NSMutableArray<UIImageView *> *subViewArray; //子视图数据
@property (nonatomic, strong) NSMutableArray<NSArray *> *subBtnArray; //每个子视图上的按钮数组
@property (nonatomic, strong) UIView *backView; //透明背景图
@property (nonatomic, assign) NSInteger lastBtnTag; //上次点击的一级菜单的tag值
@property (nonatomic, strong) UIView *xBottomCoverView; //iPhone X上菜单栏悬空后底部对二级菜单的覆盖图
@property (nonatomic, strong) NSArray *subMenuArray;
@end

@implementation YLBottomMenuView

-(instancetype)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray subMenuArray:(NSArray *)subMenuArray {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.subMenuArray = subMenuArray;
        [self creatSubViewWithMenuArray:menuArray subMenuArray:subMenuArray];
    }
    return self;
}

-(void)creatSubViewWithMenuArray:(NSArray *)menuArray subMenuArray:(NSArray *)subMenuArray {
    
    NSInteger menuDataArrayCount; //底部分类数组count
    menuDataArrayCount = menuArray.count;
    
    //手势点击消失的视图
    self.backView = ({
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self addSubview:backView];
        
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [backView addGestureRecognizer:backTap];
        
        backView;
    });
    
    for (int i = 0; i < menuDataArrayCount; i++) {
        //底部菜单btn的创建
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.frame = CGRectMake((self.bounds.size.width / menuDataArrayCount) * i, 0, self.bounds.size.width / menuDataArrayCount, self.bounds.size.height);
        [bottomBtn setTitle:menuArray[i] forState:UIControlStateNormal];
        [bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottomBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        bottomBtn.backgroundColor = [UIColor whiteColor];
        bottomBtn.tag = i;
        
        NSArray *subArray = subMenuArray[i]; //二级菜单数组
        NSInteger subMenuDataArrayCount; //二级菜单数组count
        subMenuDataArrayCount = subArray.count;
        
        if (subMenuDataArrayCount > 0) {
            //如果有子菜单则显示底部菜单按钮上的图片
            [bottomBtn setImage:[UIImage imageNamed:@"yl_bottom_menu_list_nav"] forState:UIControlStateNormal];
            bottomBtn.adjustsImageWhenHighlighted = NO;
            [bottomBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        }
        
        //设置子菜单的横坐标
        CGFloat bottomBtnX, bottomBtnWidth = menuDataArrayCount > 3 ? (self.frame.size.width / menuDataArrayCount) :(self.frame.size.width / 3.0);
        if (menuDataArrayCount == 1) {
            bottomBtnX = (bottomBtn.frame.size.width - bottomBtnWidth) / 2.0;
        }else if (menuDataArrayCount == 2) {
            bottomBtnX = bottomBtn.frame.origin.x + (bottomBtn.frame.size.width - bottomBtnWidth) / 2.0;
        }else if (menuDataArrayCount == 3) {
            bottomBtnX = i == 0 ? 8 : (i == 1 ? bottomBtn.frame.origin.x : bottomBtn.frame.origin.x - 8);
        }else {
            bottomBtnX = bottomBtn.frame.origin.x;
        }
        
        //创建子菜单栏
        UIImageView *subView = [[UIImageView alloc] initWithFrame:CGRectMake(bottomBtnX, 0, bottomBtnWidth, subMenuDataArrayCount * 40 + 5)]; //高度中最后+5是因为背景图底部箭头的高度为5
        subView.image = [[UIImage imageNamed:@"yuquan_brand_bottom_menu"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        subView.tag = bottomBtn.tag;
        subView.userInteractionEnabled = YES;
        [self insertSubview:subView atIndex:0];
        [self.subViewArray addObject:subView];
        
        //创建子菜单上的btn子视图
        NSMutableArray *marr = [NSMutableArray array];
        for (int j = 0; j < subMenuDataArrayCount; j++) {
            UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            subBtn.frame = CGRectMake(0, 40 * j, subView.frame.size.width, 40);
            [subBtn setTitle:subArray[j] forState:UIControlStateNormal];
            subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            subBtn.tag = j;
            [subView addSubview:subBtn];
            [marr addObject:subBtn];
            
            if (j != 0) {
                //添加子菜单块之间的分割线
                CALayer *subHLine = [CALayer layer];
                subHLine.frame = CGRectMake(0, subBtn.frame.size.height * j, subBtn.frame.size.width, 0.5);
                subHLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
                [subView.layer addSublayer:subHLine];
            }
        }
        [self.subBtnArray addObject:marr];
        
        
        if (!self.xBottomCoverView && i == menuDataArrayCount - 1) {
            self.xBottomCoverView = ({
                UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 40)];
                coverView.backgroundColor = [UIColor whiteColor];
                [self addSubview:coverView];
                coverView;
            });
        }
        
        [self addSubview:bottomBtn];
        
        if (i != 0) {
            //主菜单之间的垂直分割线
            CALayer *vLine = [[CALayer alloc] init];
            vLine.frame = CGRectMake(bottomBtn.frame.size.width * i, 0, 0.5, self.frame.size.height);
            vLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
            [self.layer addSublayer:vLine];
        }
    }
    
    //主菜单顶部的横线
    CALayer *topLine = [CALayer layer];
    topLine.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    topLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
    [self.layer addSublayer:topLine];
}

#pragma mark 弹起的二级视图的点击事件
-(void)subBtnClick:(UIButton *)subBtn {
    //有子分类的点击
    [self judgeSubView:self.subViewArray[self.lastBtnTag]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(subMenuViewClickWithBottomIndex:subIndex:)]) {
        [self.delegate subMenuViewClickWithBottomIndex:self.lastBtnTag subIndex:subBtn.tag];
    }
}

#pragma mark 底部一级菜单的点击事件
-(void)bottomButtonClick:(UIButton *)btn {
    //这里需要判断有没有子分类
    NSArray *subArray = self.subMenuArray[btn.tag];
    if (subArray.count > 0) {
        //有子分类
        self.lastBtnTag = btn.tag;
        [self judgeSubView:self.subViewArray[btn.tag]];
    }else {
        //没有子分类，直接跳转 - 跳转前需要将已经弹起来的视图给弹下去
        __weak typeof(self) weakSelf = self;
        [self.subViewArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (obj.frame.origin.y != 0) {
                [strongSelf changeSubViewFrame:obj];
            }
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(bottomMenuViewClickWithIndex:)]) {
            [self.delegate bottomMenuViewClickWithIndex:btn.tag];
        }
    }
}

-(void)judgeSubView:(UIImageView *)subView {
    __weak typeof(self) weakSelf = self;
    [self.subViewArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (subView && subView != obj && obj.frame.origin.y != 0) {
            [strongSelf changeSubViewFrame:obj];
        }
    }];
    [self changeSubViewFrame:subView];
}

#pragma mark 改变子视图的frame
-(void)changeSubViewFrame:(UIImageView *)subView {
    if (subView.frame.origin.y == 0) {
        
        CGRect tempR = self.backView.frame;
        tempR.origin.y = -[UIScreen mainScreen].bounds.size.height + self.frame.size.height;
        self.backView.frame = tempR;
        
        [UIView animateWithDuration:DurationAnimatedTime animations:^{
            CGRect temp = subView.frame;
            temp.origin.y = -subView.frame.size.height;
            subView.frame = temp;
        }];
    }else {
        
        CGRect tempR = self.backView.frame;
        tempR.origin.y = 0;
        self.backView.frame = tempR;
        
        [UIView animateWithDuration:DurationAnimatedTime animations:^{
            CGRect temp = subView.frame;
            temp.origin.y = 0;
            subView.frame = temp;
        }];
    }
}

#pragma mark 背景透明视图的手势点击
-(void)tapClick:(UITapGestureRecognizer *)tap {
    if(self.subViewArray.count > 0){
         [self judgeSubView:self.subViewArray[self.lastBtnTag]];
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    __block UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempP = [self.backView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.backView.bounds, tempP)) {
            view = self.backView;
        }
        if (self.subBtnArray.count > 0) {
            [self.subBtnArray[self.lastBtnTag] enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGPoint temp = [obj convertPoint:point fromView:self];
                if (CGRectContainsPoint(obj.bounds, temp)) {
                    view = obj;
                }
            }];
        }
    }
    return view;
}

-(NSMutableArray<UIImageView *> *)subViewArray {
    if (!_subViewArray) {
        _subViewArray = [[NSMutableArray alloc] init];
    }
    return _subViewArray;
}

-(NSMutableArray<NSArray *> *)subBtnArray {
    if (!_subBtnArray) {
        _subBtnArray = [[NSMutableArray alloc] init];
    }
    return _subBtnArray;
}

-(void)dealloc {
    NSLog(@"菜单释放了");
}

@end
