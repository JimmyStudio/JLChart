//
//  JLLineChartData.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLLineChartData.h"

#define TextColor [UIColor lightGrayColor]
#define LineColor [UIColor colorWithRed:0.0f green:191.0f/225.0f blue:1.0f alpha:1.0f]
#define FillColor [UIColor colorWithRed:0.0f green:191.0f/225.0f blue:1.0f alpha:0.5f];
#define LabelFont [UIFont systemFontOfSize:12.0f]

@implementation JLLineChartData

- (instancetype)init{
    if (self = [super init]) {
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues{
    _sets = @[].mutableCopy;
    
    _lineColor = LineColor;
    _lineWidth = 1.0f;
    _fillColor = nil;
}

@end
