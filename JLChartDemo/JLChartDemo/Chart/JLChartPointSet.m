//
//  JLChartPointSet.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLChartPointSet.h"

@implementation JLChartPointSet
- (instancetype)init{
    if (self = [super init]) {
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues{
    _items = @[].mutableCopy;
    _type = LineChartPointSetTypeNone;
    _buyPointColor = [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:1.0f];
    _relocatePointColor = [UIColor colorWithRed:155.0f/255.0f green:48.0f/225.0f blue:1.0f alpha:1.0f];
    _pointRadius = 2.0f;
}
@end
