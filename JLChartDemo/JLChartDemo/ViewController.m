//
//  ViewController.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/12/6.
//  Copyright © 2016年 jimmystudio. All rights reserved.
//

#import "ViewController.h"
#import "JLChart.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //仿余额宝收益走势
    UILabel *desc1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-10, 40)];
    desc1.text = @"仿余额宝收益走势(%)";
    [self.view addSubview:desc1];
    //使用比较简单,只支持一条线~~
    [self creatJLSingleLineChart];
    
    //基金走势和沪深300对比,包括自己的买入点...
    UILabel *desc2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, SCREEN_WIDTH-10, 40)];
    desc2.text = @"基金走势和沪深300对比,包括自己的买入点...";
    [self.view addSubview:desc2];
    //看着有点复杂...不过按自己项目的数据结构来说还是蛮方便的...
    [self creatJLLineChart];
}

- (void)creatJLSingleLineChart{
    //x坐标轴按数据量显示,建议数据了小一点,7个左右显示效果较佳,未做其他处理.
    JLSingleLineChart *singleChart = [[JLSingleLineChart alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 200)];
    JLLineChartData *data = [[JLLineChartData alloc]init];
    JLChartPointSet *set = [[JLChartPointSet alloc]init];
    for (int i = 0; i< 7; i ++) {
        if (i <3) {
            JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"09-21" andRowY:[NSString stringWithFormat:@"%.3f",i + 1.321]];
            [set.items addObject:point];
        }else if(i <5){
            JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"09-22" andRowY:[NSString stringWithFormat:@"%.3f",i + 2.421]];
            [set.items addObject:point];
        }else{
            JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"09-29" andRowY:[NSString stringWithFormat:@"%.3f",i - 1.021]];
            [set.items addObject:point];
        }
    }
    [data.sets addObject:set];
    data.lineColor = [UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:1.0f];
    data.lineWidth = 2.0f;
    data.fillColor = [UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:0.3f];
    singleChart.chartData = data;
    [self.view addSubview:singleChart];
    [singleChart strokeChart];
}

- (void)creatJLLineChart{
    JLLineChart *lineChart = [[JLLineChart alloc]initWithFrame:CGRectMake(0, 340, SCREEN_WIDTH, 200)];
    
    //data1表示本基金走势 数据随便写的~~
    JLLineChartData *data1 = [[JLLineChartData alloc]init];
    data1.lineColor = [UIColor redColor];//显示成红色~~
    JLChartPointSet *set11 = [[JLChartPointSet alloc]init];
    for (int i = 0; i< 100; i ++) {
        if (i < 10) {
            JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"2012-09-29" andRowY:[NSString stringWithFormat:@"%.2f",i + 4.0+arc4random_uniform(10)]];
            [set11.items addObject:point];
        }else if (i ==40)
        {
            //搞个买入点
            JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"2014-8-29" andRowY:@"20"];
            [set11.items addObject:point];
            
        }else if (i ==70)
        {
            //搞个调仓点
            JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"2015-10-29" andRowY:@"20"];
            [set11.items addObject:point];
            
        }
        else
        {
            JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"2016-09-29" andRowY:[NSString stringWithFormat:@"%.2f",i - 6.0 +arc4random_uniform(10)]];
            [set11.items addObject:point];
        }
    }
    
    //这里包含一个买入点... 按rawX显示在走势图上~~
    JLChartPointSet *set12 = [[JLChartPointSet alloc]init];
    set12.type = LineChartPointSetTypeBuy;
    JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"2014-8-29" andRowY:@"这个点我买入咯"];
    [set12.items addObject:point];
    
    //这里包含一个调仓点... 按rawX显示在走势图上~~
    JLChartPointSet *set13 = [[JLChartPointSet alloc]init];
    set13.type = LineChartPointSetTypeRelocate;
    JLChartPointItem *point2 = [JLChartPointItem pointItemWithRawX:@"2015-10-29" andRowY:@"这个点我调仓啦"];
    [set13.items addObject:point2];
    
    //data1包含以上三组数据~~
    [data1.sets addObject:set11];
    [data1.sets addObject:set12];
    [data1.sets addObject:set13];
    
    //data1 表示沪深300的走势 数据随便写的~~
    JLLineChartData *data2 = [[JLLineChartData alloc]init];
    JLChartPointSet *set2 = [[JLChartPointSet alloc]init];
    for (int i = 0; i< 100; i ++) {
        JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:@"2014-09-29" andRowY:[NSString stringWithFormat:@"%.2f",i * (-1)  + 1.0 +arc4random_uniform(10)]];
        [set2.items addObject:point];
    }
    //data2只有一组数据~~
    [data2.sets addObject:set2];
    
    lineChart.chartDatas = @[data1,data2].mutableCopy;
    [self.view addSubview:lineChart];
    
    [lineChart strokeChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
