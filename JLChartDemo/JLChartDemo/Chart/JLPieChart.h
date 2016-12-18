//
//  JLPieChart.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/12/19.
//  Copyright © 2016年 jimmystudio. All rights reserved.
//

#import "JLBaseChart.h"
#import "JLPieChartData.h"

@interface JLPieChart : JLBaseChart

@property (nonatomic, assign, getter=isShowLegend) BOOL showLegend; //showLegend default YES
@property (nonatomic, strong) UIFont *legendLabelFont;
@property (nonatomic, strong) UIColor *legendLabelColor;

@property (nonatomic, assign) float legendInnerMargin; //default is 10.0f;
@property (nonatomic, assign) float legendMarginLeft; //default is 40.0f;
@property (nonatomic, assign) float legendMarginRight; //default is 10.0f;
@property (nonatomic, assign) float legendLabelDivisionRatio; //default is 0.6f;
@property (nonatomic, assign) float legendRadius; //default is 2.0f;

@property (nonatomic, assign) float percentOfInnerHoleRadius; //default is 0.6
@property (nonatomic, assign) float startAngle; //default is M_PI*1.5f;


@property (nonatomic, strong) JLPieChartData *data;
- (void)strokeChart;

@end
