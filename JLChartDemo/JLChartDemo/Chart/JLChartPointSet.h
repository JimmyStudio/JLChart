//
//  JLChartPointSet.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLChartPointItem.h"

typedef NS_ENUM(NSUInteger, ChartPointSetType) {
    LineChartPointSetTypeNone            = 0,
    LineChartPointSetTypeBuy             = 1 << 0,
    LineChartPointSetTypeRelocate        = 1 << 1,
};

@interface JLChartPointSet : NSObject

@property (nonatomic, assign) ChartPointSetType type;
@property (nonatomic, strong) NSMutableArray <JLChartPointItem *> *items;
@property (nonatomic, strong) UIColor *buyPointColor;
@property (nonatomic, strong) UIColor *relocatePointColor;
@property (nonatomic, assign) CGFloat pointRadius;


@end
