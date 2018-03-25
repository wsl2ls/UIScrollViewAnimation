//
//  WSLAnimationView.h
//  UIScrollView
//
//  Created by 王双龙 on 2018/3/22.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSLAnimationView : UIView

@property (nonatomic, strong) UIImageView * imageView;

/**
 imageView的横坐标 用于拖拽过程中的动画
 */
@property (nonatomic, assign) CGFloat contentX;

@end
