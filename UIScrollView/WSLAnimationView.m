//
//  WSLAnimationView.m
//  UIScrollView
//
//  Created by 王双龙 on 2018/3/22.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLAnimationView.h"

@interface WSLAnimationView ()

@end

@implementation WSLAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
        
    }
    return self;
}

- (void)setContentX:(CGFloat)contentX{
    
    _contentX = contentX;
    _imageView.frame = CGRectMake(contentX, 0, self.frame.size.width, self.frame.size.height);
    
}

@end
