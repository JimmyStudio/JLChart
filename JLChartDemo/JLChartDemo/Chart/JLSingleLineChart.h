//
//  JLSingleLineChart.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLBaseChart.h"
#import "JLLineChartData.h"

@interface JLSingleLineChart : JLBaseChart

@property (nonatomic, strong) JLLineChartData *chartData;
- (void)strokeChart;

@end
