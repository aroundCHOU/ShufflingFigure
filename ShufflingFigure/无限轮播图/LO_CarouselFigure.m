//
//  LO_CarouselFigure.m
//  无限轮播图
//
//  Created by ZhouWei on 16/1/8.
//  Copyright © 2016年 周围. All rights reserved.
//
#define LO_CFWidth  self.frame.size.width
#define LO_CFHeight  self.frame.size.height
#define LO_CFY self.frame.origin.y
#import "LO_CarouselFigure.h"

@interface LO_CarouselFigure ()<UIScrollViewDelegate>
@property (retain ,nonatomic,readonly) UIPageControl * pageControl;
@property (retain ,nonatomic) UIImageView * leftImageView;
@property (retain ,nonatomic) UIImageView * centerImageView;
@property (retain ,nonatomic) UIImageView * rightImageView;
@property (nonatomic, assign)NSInteger imageArrayIndex;
@property (nonatomic, assign)BOOL isTwoImage;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL isTimeUp;
@property (nonatomic, strong)void (^block)();
@property (nonatomic, assign)BOOL isSDWebImage;
@property (nonatomic, assign)BOOL isADecoder;
@end
@implementation LO_CarouselFigure
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self aDecoderAction];
    }
    return self;
}
//从写initWithFrame方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonAction];
    }
    return self;
}
- (void)aDecoderAction{
    _isADecoder = YES;
    self.imageArrayIndex = 1;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    //设置初始值
    _isTimeUp = NO;
    _isTwoImage = NO;
    _isSDWebImage = NO;
}
- (void)frameAction{
    [self layoutIfNeeded];
    self.contentOffset = CGPointMake(LO_CFWidth, 0);
    self.contentSize = CGSizeMake(LO_CFWidth * 3, LO_CFHeight);
    //初始化3个imageView
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LO_CFWidth, LO_CFHeight)];
    [self addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LO_CFWidth, 0, LO_CFWidth, LO_CFHeight)];
    [self addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LO_CFWidth*2, 0, LO_CFWidth, LO_CFHeight)];
    [self addSubview:_rightImageView];
}

- (void)commonAction{
    _isADecoder = NO;
    self.imageArrayIndex = 1;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentOffset = CGPointMake(LO_CFWidth, 0);
    self.contentSize = CGSizeMake(LO_CFWidth * 3, LO_CFHeight);
    self.delegate = self;
    //初始化3个imageView
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LO_CFWidth, LO_CFHeight)];
    [self addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LO_CFWidth, 0, LO_CFWidth, LO_CFHeight)];
    [self addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LO_CFWidth*2, 0, LO_CFWidth, LO_CFHeight)];
    [self addSubview:_rightImageView];
    //设置初始值
    _isTimeUp = NO;
    _isTwoImage = NO;
    _isSDWebImage = NO;
}
- (void)setCarouselTime:(CGFloat)carouselTime{
    //设置轮播时间
    _carouselTime = carouselTime;
    _timer = [NSTimer scheduledTimerWithTimeInterval:carouselTime target:self selector:@selector(andTimeAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
//时间方法
- (void)andTimeAction{
    [self setContentOffset:CGPointMake(LO_CFWidth * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}
-(void)setBitmapImage:(UIImage *)bitmapImage {
    _bitmapImage = bitmapImage;
    //设置占位图
    _leftImageView.image = bitmapImage;
    _centerImageView.image = bitmapImage;
    _rightImageView.image = bitmapImage;
}
//SD的设置数组
#warning ~~~~~~~~~~~~~~~~~~~~~~~~
///*
- (void)setSd_URLArray:(NSArray *)sd_URLArray{
    CGFloat height = 0;
    if (_isADecoder) {
        height = 20;
        [self frameAction];
    }
    _isSDWebImage = YES;
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = sd_URLArray.count;
    _pageControl.frame = CGRectMake(LO_CFWidth - 20 * _pageControl.numberOfPages, LO_CFHeight + LO_CFY - 20 + height, 20 * _pageControl.numberOfPages, 20);
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
    NSString *URLString = sd_URLArray.lastObject;
    NSMutableArray *array = [NSMutableArray arrayWithArray:sd_URLArray];
    if (array.count == 1) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:sd_URLArray.firstObject] placeholderImage:_bitmapImage];
        self.contentSize = CGSizeMake(LO_CFWidth, LO_CFHeight);
        [_timer invalidate];
        _timer = nil;
        return;
    }
    if (array.count == 2){
        NSString *URLStrings = array.firstObject;
        [array addObject:URLStrings];
        [array addObject:URLString];
        _isTwoImage = YES;
    }
    [array removeObjectAtIndex:array.count -1];
    [array insertObject:URLString atIndex:0];
    _imageArray = [NSArray arrayWithArray:array];
    [_leftImageView sd_setImageWithURL:_imageArray[0] placeholderImage:_bitmapImage];
    [_centerImageView sd_setImageWithURL:_imageArray[1] placeholderImage:_bitmapImage];
    [_rightImageView sd_setImageWithURL:_imageArray[2] placeholderImage:_bitmapImage];
}
//*/
//非SD从写Set方法
- (void)setImageArray:(NSArray *)imageArray{
    CGFloat height = 0;
    if (_isADecoder) {
        height = 20;
        [self frameAction];
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = imageArray.count;
    _pageControl.frame = CGRectMake(LO_CFWidth - 20 * _pageControl.numberOfPages, LO_CFHeight + LO_CFY - 20 + height, 20 * _pageControl.numberOfPages, 20);
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
    UIImage *image = imageArray.lastObject;
    NSMutableArray *array = [NSMutableArray arrayWithArray:imageArray];
    if (array.count == 1) {
        _leftImageView.image = array.firstObject;
        self.contentSize = CGSizeMake(LO_CFWidth, LO_CFHeight);
        [_timer invalidate];
        _timer = nil;
        return;
    }
    if (array.count == 2){
        UIImage *images = array.firstObject;
        [array addObject:images];
        [array addObject:image];
        _isTwoImage = YES;
    }
    [array removeObjectAtIndex:array.count -1];
    [array insertObject:image atIndex:0];
    _imageArray = [NSArray arrayWithArray:array];
    _leftImageView.image = _imageArray[0];
    _centerImageView.image = _imageArray[1];
    _rightImageView.image = _imageArray[2];
}
- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger leftIndex = 0;
    NSInteger rightindex = 0;
    //向右滑动
    if (self.contentOffset.x == 0)
    {
        _imageArrayIndex--;
        //判断计算
        if (_imageArrayIndex < 0) {
            _imageArrayIndex = _imageArray.count - 1;
            leftIndex = _imageArrayIndex - 1;
            rightindex = 0;
        }else if (_imageArrayIndex == 0) {
            leftIndex = _imageArray.count - 1;
            rightindex = _imageArrayIndex + 1;
        }else{
            leftIndex = _imageArrayIndex - 1;
            rightindex = _imageArrayIndex + 1;
        }
    }
    //向左滑动
    else if(self.contentOffset.x == LO_CFWidth * 2)
    {
        _imageArrayIndex++;
        //判断计算
        if (_imageArrayIndex > _imageArray.count - 1) {
            _imageArrayIndex = 0;
            leftIndex = _imageArray.count - 1;
            rightindex = _imageArrayIndex + 1;
        }else if (_imageArrayIndex == _imageArray.count - 1) {
            leftIndex = _imageArrayIndex - 1;
            rightindex = 0;
        }else{
            leftIndex = _imageArrayIndex - 1;
            rightindex = _imageArrayIndex + 1;
        }
    }
    else
    {
        return;
    }
    //两张图片情况的pageControl
    if (_isTwoImage) {
        if (_imageArrayIndex % 2 == 0) {
            _pageControl.currentPage = 1;
        }else{
            _pageControl.currentPage = 0;
        }
    }else{
        //多张图片的pageControl
        _pageControl.currentPage = leftIndex;
    }
    
    //是否使用SDWebImage
    if (_isSDWebImage) {
#warning ~~~~~~~~~~~~~~~~~~~~~~~~
       // /*
        [_leftImageView sd_setImageWithURL:_imageArray[leftIndex] placeholderImage:_bitmapImage];
        [_centerImageView sd_setImageWithURL:_imageArray[_imageArrayIndex] placeholderImage:_bitmapImage];
        [_rightImageView sd_setImageWithURL:_imageArray[rightindex] placeholderImage:_bitmapImage];
        // */
    }else{
        _leftImageView.image = _imageArray[leftIndex];
        _centerImageView.image = _imageArray[_imageArrayIndex];
        _rightImageView.image = _imageArray[rightindex];
    }
    //偏移到中间
    self.contentOffset = CGPointMake(LO_CFWidth, 0);
    //时间
    if (!_isTimeUp) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_carouselTime]];
    }
    _isTimeUp = NO;
}
- (void)addTouchImageActionBlock:(void (^)(NSInteger ))block{
    __block LO_CarouselFigure *men = self;
    self.block = ^(){
        if (block) {
            //多张情况
            NSInteger index = men.imageArrayIndex - 1 < 0 ? _imageArray.count - 1 : _imageArrayIndex - 1;
            NSInteger ind = index;
            //两种图片的情况
            if (men.isTwoImage) {
                if (index % 2 == 0) {
                    ind = 0;
                }else{
                    ind = 1;
                }
            }
            block(ind);
        }
    };
}
//添加点击方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.block) {
        self.block();
    }
}
@end
