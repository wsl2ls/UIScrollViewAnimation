
>前言：看到凤凰新闻 头条栏目的编辑推荐新闻是这个效果，觉得不错，就想着实现一下，以下就是我的实现过程，简书地址：https://www.jianshu.com/p/3b30b9cdd274 。

![总效果](https://upload-images.jianshu.io/upload_images/1708447-b9b1436cbe389dd2.gif?imageMogr2/auto-orient/strip)


#### 一、首先实现一个基本的图集浏览功能，如下图
>该功能太基础，直接先贴一个UIScrollView，然后几个UIImageView啪啪啪往UIScrollView上面一扔.......Over，不在此啰嗦咯。

![普通的浏览效果.gif](https://upload-images.jianshu.io/upload_images/1708447-b87e94dd842ccdbc.gif?imageMogr2/auto-orient/strip)

#### 二、分析动画效果，提出解决方案
注意：这里的left和right是区分拖动中可见的两个视图。
  * ##### 1. 分析效果
>    由总效果图和第一步的普通的浏览效果图对比可以看出，在拖拽过程中，第一步中的普通效果图是图片之间首尾相连，当前(**left**)的图片尾部连接下一个(**right**)的图片首部；而目标总效果图中的是图片之间首首相连，尾尾相连，且滑动过程中，当前可见的图片有渐进的裁剪效果；前者就像是平铺在一起的一行书，一块儿左右平移，而后者就像是翻书时看到的效果，当前页***left***内容由边到内逐渐消失，而下一页***right***内容由边缘到里逐渐显示。

* ##### 2. 解决思路
> 通过效果分析对比可知，我们需要在第一步的基础上把每一个图片视图ImageView包装在***WSLAnimationView***里，让WSLAnimationView去处理ImageView的动画效果，那问题来了，我们怎么处理呢？
 > * 我们可以在拖拽过程中相对应的改变**right/left**图片在父视图WSLAnimationView上的X坐标，把***right***图片的坐标位置放到***相对***于***left***图片的***正下/偏右方***位置，然后随着拖拽滑动逐渐改变**right以及left**图片的相对位置X坐标，直至复位，回到它们在WSLAnimationView上的初始位置X=0，超出父视图的部分裁剪掉，也是设置WSLAnimationView对象的clipsToBounds = YES。

![思路示意图](https://upload-images.jianshu.io/upload_images/1708447-a4efedcfe97280d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  #### 三、代码实现
   * ##### 1. 首先创建一个承载UIImageView的容器WSLAnimationView，用于渐进动画裁剪效果。
```
@interface WSLAnimationView ()
@property (nonatomic, strong) UIImageView * imageView;
/**
 imageView的横坐标 用于拖拽过程中的动画
 */
@property (nonatomic, assign) CGFloat contentX;
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
```
  
   * ##### 2. 在拖拽滑动过程中进行动画处理
```
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCROLLVIEW_WIDTH SCREEN_WIDTH
#define BaseTag 10
/**
 动画偏移量 是指rightView相对于leftView的偏移量
 */
#define AnimationOffset 100
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   CGFloat x = scrollView.contentOffset.x;
   NSInteger leftIndex = x/SCROLLVIEW_WIDTH;

   //这里的left和right是区分拖动中可见的两个视图
    WSLAnimationView * leftView = [scrollView viewWithTag:(leftIndex + BaseTag)];
    WSLAnimationView * rightView = [scrollView viewWithTag:(leftIndex + 1 + BaseTag)];

    leftView.contentX = ((SCROLLVIEW_WIDTH - AnimationOffset) + (x - ((leftIndex + 1) * SCROLLVIEW_WIDTH))/SCROLLVIEW_WIDTH * (SCROLLVIEW_WIDTH - AnimationOffset));
    rightView.contentX = -(SCROLLVIEW_WIDTH - AnimationOffset) + (x - (leftIndex * SCROLLVIEW_WIDTH))/SCROLLVIEW_WIDTH * (SCROLLVIEW_WIDTH - AnimationOffset);
}
```
 * ##### 3. 代码处理逻辑说明
> 动画偏移量AnimationOffset = 0 时 即***right***图片的坐标位置放到***相对***于***left***图片的***正下方***位置，此时的效果如下图所示；当AnimationOffset > 0 时就会出现目标总效果图了。

![AnimationOffset = 0时的效果图](https://upload-images.jianshu.io/upload_images/1708447-cb8d35f74ca147d5.gif?imageMogr2/auto-orient/strip)

>刚向左拖拽时的leftView和rightView视图结构示意图如下所示，
那么拖拽中，逐渐移动复位rightView上的RightImage的X坐标：
  rightView.contentX  = 需要移动距离长度 - 移动百分比 * 需要移动距离长度 ;  leftView.contentX 和这个类似，交由小伙伴们去思考。
```
需要移动距离长度 =  SCROLLVIEW_WIDTH - AnimationOffset；
移动百分比 = 拖拽距离 /  一页宽度即屏幕宽度
拖拽距离 =   (偏移量X - leftView横坐标)；
偏移量X = scrollView.contentOffset.x；
leftIndex = 偏移量X/SCROLLVIEW_WIDTH；
leftView横坐标 = leftIndex * SCROLLVIEW_WIDTH；
```
![刚向左拖拽时的结构示意图](https://upload-images.jianshu.io/upload_images/1708447-a4efedcfe97280d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> 以上就是我实现这个效果的过程，简书地址：https://www.jianshu.com/p/3b30b9cdd274 ；如果小伙伴们有其他的实现方法，欢迎再此留言交流😊😊😀😀🤗🤗

![赞个.gif](https://upload-images.jianshu.io/upload_images/1708447-f802919fa2832613.gif?imageMogr2/auto-orient/strip)

