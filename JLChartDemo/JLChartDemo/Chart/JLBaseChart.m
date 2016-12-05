//
//  JLBaseChart.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLBaseChart.h"
#define TextColor [UIColor lightGrayColor]
#define IndicateColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:1.0f]
#define IndicateBackColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:0.4f]
#define LabelFont [UIFont systemFontOfSize:12.0f]

@implementation JLBaseChart
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues{
    
    _xLabelFont = LabelFont;
    _xLabelColor = TextColor;
    _yLabelFont = [UIFont systemFontOfSize:10.0f];
    _yLabelColor = TextColor;
    _yLabelWidthPadding = 5.0f;
    _signedValue = YES;
    //    _yLabelFormat = @"%.2f";
    _yLabelSuffix = @"%";
    _stepCount = 4;
    
    _chartMarginLeft = 10.0f;
    _chartMarginRight = 10.0f;
    _chartMarginTop = 10.0f;
    _chartMarginBottom = 10.0f;
    
    _axisType = ChartAxisTypeBoth | ChartAxisTypeDash;
    _axisWidth = 0.6f;
    _axisColor = TextColor;
    
    _indicateLineType = ChartIndicateLineTypeBoth | ChartIndicateLineTypeDash;
    _indicatePointColor = IndicateColor;
    _indicatePointBackColor = IndicateBackColor;
    _xIndicateLineWidth = 0.6f;
    _xIndicateLineColor = IndicateColor;
    _xIndicateLabelFont = LabelFont;
    _xIndicateLabelTextColor = [UIColor whiteColor];
    _xIndicateLabelBackgroundColor = IndicateColor;
    
    _yIndicateLineWidth = 0.6f;
    _yIndicateLineColor = IndicateColor;
    _yIndicateLabelFont = LabelFont;
    _yIndicateLabelTextColor = [UIColor whiteColor];
    _yIndicateLabelBackgroundColor = IndicateColor;
    
    _displayAnimated = NO;
    _animateDuration = 1.0f;
}

- (void)setAxisType:(ChartAxisType)axisType{
    if (_axisType != axisType) {
        _axisType = axisType;
    }
}

- (void)setAxisWidth:(CGFloat)axisWidth{
    if (_axisWidth != axisWidth) {
        _axisWidth = axisWidth;
    }
}

- (void)setAxisColor:(UIColor *)axisColor{
    if (_axisColor != axisColor) {
        _axisColor = axisColor;
    }
}

@end
