//
//  ViewController.m
//  无限轮播图
//
//  Created by ZhouWei on 16/1/8.
//  Copyright © 2016年 周围. All rights reserved.
//

#import "ViewController.h"
#import "LO_CarouselFigure.h"
#define LO_ScreenBoundsWidth [UIScreen mainScreen].bounds.size.width
#define CCCUIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
@interface ViewController ()
@property (weak, nonatomic) IBOutlet LO_CarouselFigure *lo_CFTwo;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *string = @"http://img2.a0bi.com/upload/ttq/20140722/1405995619576_middle.jpg";
    NSString *string1 = @"http://ww2.sinaimg.cn/mw600/c6c1d258jw1e5r59ttpkcj20gu0gsmyh.jpg";
    NSString *string2 = @"http://ww1.sinaimg.cn/mw600/bce7ca57gw1e4rg0coeqqj20dw099myu.jpg";
    NSString *string3 = @"http://imgsrc.baidu.com/forum/w%3D580/sign=7fc5b239b9a1cd1105b672288912c8b0/51b0f603738da977be0bd022b351f8198618e3b7.jpg";
    //有SD使用方法
    //创建只能用此方法
    LO_CarouselFigure *cf = [[LO_CarouselFigure alloc]initWithFrame:CGRectMake(10, 30, LO_ScreenBoundsWidth - 20, (LO_ScreenBoundsWidth - 20) / 3.0 * 2.0)];
    //添加点击时方法
    [cf addTouchImageActionBlock:^(NSInteger index) {
        NSLog(@"cf == %ld",index);
    }];
    //设置轮播时间
    cf.carouselTime = 0.5;
    //设置占位图
    cf.bitmapImage = [UIImage imageNamed:@"image0"];
    //给URLstring数组
    cf.sd_URLArray = @[string,string1,string2,string3];
    //添加到view上
//    [self.view addSubview:cf];
//************************************************************************************
    //没有SD的使用方法
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        NSString *str = [NSString stringWithFormat:@"image%d",i];
        UIImage *image = [UIImage imageNamed:str];
        [imageArray addObject:image];
    }
    //创建只能用此方法
    LO_CarouselFigure *cfOne = [[LO_CarouselFigure alloc]initWithFrame:CGRectMake(10, cf.frame.origin.y + cf.frame.size.height + 30,LO_ScreenBoundsWidth - 20, (LO_ScreenBoundsWidth - 20) / 3.0 * 2.0)];
    //设置轮播时间
    cfOne.carouselTime = 0.5;
    self.view.backgroundColor = CCCUIColorFromHex(0xd96e5d);
    //添加点击时方法
    [cfOne addTouchImageActionBlock:^(NSInteger index) {
        NSLog(@"cfOne == %ld",index);
    }];
    //给image数组
    cfOne.imageArray = imageArray;
    //添加到view上
//    [self.view addSubview:cfOne];
    _lo_CFTwo.carouselTime = 2.0;
    _lo_CFTwo.bitmapImage = [UIImage imageNamed:@"image2"];
    _lo_CFTwo.sd_URLArray = @[string,string1,string2,string3];
    [_lo_CFTwo addTouchImageActionBlock:^(NSInteger index) {
        NSLog(@"lo_CFTwo%ld",index);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
