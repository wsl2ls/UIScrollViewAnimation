//
//  ViewController.m
//  UIScrollView
//
//  Created by China Daily on 2018/3/21.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "ViewController.h"
#import "WSLAnimationView.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCROLLVIEW_WIDTH SCREEN_WIDTH

#define BaseTag 10

/**
 动画偏移量 是指rightView相对于leftView的偏移量
 */
#define AnimationOffset 100

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < 4 ; i++) {
        WSLAnimationView * view = [[WSLAnimationView alloc] initWithFrame:CGRectMake(i * SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, self.view.frame.size.height)];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        view.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [_scrollView addSubview:view];
        view.tag = BaseTag + i;
    }
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat x = scrollView.contentOffset.x;

    NSInteger leftIndex = x/SCROLLVIEW_WIDTH;
//    NSLog(@"%ld",leftIndex);

    //这里的left和right是区分拖动中可见的两个视图
    WSLAnimationView * leftView = [scrollView viewWithTag:(leftIndex + BaseTag)];
    WSLAnimationView * rightView = [scrollView viewWithTag:(leftIndex + 1 + BaseTag)];
    
    
//    leftView.contentX = -(SCROLLVIEW_WIDTH - x + (leftIndex * SCROLLVIEW_WIDTH));
//    rightView.contentX = (SCROLLVIEW_WIDTH + x - ((leftIndex + 1) * SCROLLVIEW_WIDTH));


    rightView.contentX = -(SCROLLVIEW_WIDTH - AnimationOffset) + (x - (leftIndex * SCROLLVIEW_WIDTH))/SCROLLVIEW_WIDTH * (SCROLLVIEW_WIDTH - AnimationOffset);
    leftView.contentX = ((SCROLLVIEW_WIDTH - AnimationOffset) + (x - ((leftIndex + 1) * SCROLLVIEW_WIDTH))/SCROLLVIEW_WIDTH * (SCROLLVIEW_WIDTH - AnimationOffset));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
