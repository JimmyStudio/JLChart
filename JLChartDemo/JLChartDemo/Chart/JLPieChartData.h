//
//  JLPieChartData.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/12/19.
//  Copyright © 2016年 jimmystudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLChartPointItem.h"

@interface JLPieChartData : NSObject

@property (nonatomic, strong) NSMutableArray <JLChartPointItem *> *items;
@property (nonatomic, strong) NSMutableArray <UIColor *> *fillColors;

@end
