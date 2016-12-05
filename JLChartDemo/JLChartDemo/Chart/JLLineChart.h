//
//  JLLineChart.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBaseChart.h"
#import "JLChartDelegate.h"
#import "JLLineChartData.h"


@interface JLLineChart : JLBaseChart

@property (nonatomic, strong) NSMutableArray <JLLineChartData *> *chartDatas;

- (void)strokeChart;

- (void)updateChartWithChartData:(NSMutableArray <JLLineChartData *> *)chartData;

@end
