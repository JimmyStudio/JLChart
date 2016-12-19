//
//  JLPieChart.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/12/19.
//  Copyright © 2016年 jimmystudio. All rights reserved.
//

#import "JLPieChart.h"

@interface JLPieChart()

@property (nonatomic, assign) float pieRadius;
@property (nonatomic, strong) CAShapeLayer *innerHoleLayer;
@property (nonatomic, strong) UIBezierPath *innerHolePath;

@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *pieLayers;
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *piePaths;

@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *legendLayers;
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *legendPaths;
@property (nonatomic, strong) NSMutableArray <UILabel *> *XValueLabels;
@property (nonatomic, strong) NSMutableArray <UILabel *> *YvalueLabels;


@end

@implementation JLPieChart

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit{
    _showLegend = YES;
    _percentOfInnerHoleRadius = 0.6f;
    _startAngle = M_PI *1.5f;
    _legendLabelFont = [UIFont systemFontOfSize:12.0f];
    _legendLabelColor = [UIColor blackColor];
    _legendLabelDivisionRatio = 0.6f;
    _legendRadius = 4.0f;
    _legendMarginLeft = 40.0f;
    _legendMarginRight = 10.0f;
    _legendInnerMargin = 10.0f;
}

- (void)strokeChart{
    if(_innerHoleLayer)_innerHoleLayer.path = _innerHolePath.CGPath;
    for (int i = 0; i < _piePaths.count; i ++){
        _pieLayers[i].path = _piePaths[i].CGPath;
    }
    
    for (int i = 0; i < _legendPaths.count; i ++){
        _legendLayers[i].path = _legendPaths[i].CGPath;
    }
}

- (void)setData:(JLPieChartData *)data{
    if (_data != data) {
        _data = data;
    }
    
    [self clear];
    
    if (_data.items.count) {
        
        _pieRadius = (self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom)/2.0f;
        CGPoint center = _showLegend? CGPointMake(self.chartMarginLeft +_pieRadius, self.chartMarginTop +_pieRadius) : CGPointMake(self.bounds.size.width/2.0f, self.chartMarginTop +_pieRadius);
        [self calculatePiePathWithData:data inCenter:center];
        [self drawHoleInCenter:center];
    }
}

- (void)clear{
    if(_pieLayers.count){
        for (CAShapeLayer *layer in _pieLayers) {
            [layer removeFromSuperlayer];
        }
        [_pieLayers removeAllObjects];
    }
    _pieLayers = @[].mutableCopy;
    
    if (_piePaths.count) {
        [_piePaths removeAllObjects];
    }
    _piePaths = @[].mutableCopy;
    
    if (_legendLayers.count) {
        for (CAShapeLayer *layer in _legendLayers) {
            [layer removeFromSuperlayer];
        }
        [_legendLayers removeAllObjects];
    }
    _legendLayers = @[].mutableCopy;
    
    if (_legendPaths.count) {
        [_legendPaths removeAllObjects];
    }
    _legendPaths = @[].mutableCopy;
    
    for (UILabel *label in _XValueLabels) {
        [label removeFromSuperview];
    }
    _XValueLabels = @[].mutableCopy;
    
    for (UILabel *label in _YvalueLabels) {
        [label removeFromSuperview];
    }
    _YvalueLabels = @[].mutableCopy;
}

- (void)calculatePiePathWithData:(JLPieChartData *)data inCenter:(CGPoint)center{
    CGFloat startAngle = _startAngle;
    //for legend
    CGFloat labelHeigth = [data.items[0].rawY boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:_legendLabelFont,NSFontAttributeName, nil]
                                                           context:nil].size.height + 5.0f;
    CGFloat margin = (self.bounds.size.height- labelHeigth * data.items.count)/(data.items.count + 1.0f);
    CGFloat legendLabeltotalWith = self.bounds.size.width - self.bounds.size.height - _legendRadius *2.0f - _legendMarginLeft - _legendMarginRight - self.chartMarginRight;
    
    
    for (int i = 0; i <data.items.count; i ++) {
        JLChartPointItem *item = data.items[i];
        CGFloat endAngle = startAngle + [item.rawY floatValue] *M_PI *2.0f;
        //&& endAngle != _startAngle + M_PI *2.0f 当只有一个数据 占比100%时需特殊处理
        if (endAngle >= M_PI *2.0f && endAngle != _startAngle + M_PI *2.0f) {
            endAngle = endAngle - M_PI *2.0f;
        }
        
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:_pieRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [path closePath];
        [_piePaths addObject:path];
        
        startAngle = endAngle;

        CAShapeLayer *pieLayer = [CAShapeLayer layer];
        pieLayer.frame = self.bounds;
        pieLayer.fillColor = data.fillColors[i].CGColor;
        [self.layer addSublayer:pieLayer];
        [_pieLayers addObject:pieLayer];
        
        if (_showLegend) {
            CAShapeLayer *legendLayer = [CAShapeLayer layer];
            legendLayer.frame = self.bounds;
            legendLayer.fillColor = data.fillColors[i].CGColor;
            [self.layer addSublayer:legendLayer];
            [_legendLayers addObject:legendLayer];
            
            CGPoint legendCenter = CGPointMake(self.bounds.size.height + _legendMarginLeft +_legendRadius, margin + 0.5f*labelHeigth +(margin +labelHeigth)*i);
            UIBezierPath *legendPath = [UIBezierPath bezierPathWithArcCenter:legendCenter radius:_legendRadius startAngle:0 endAngle:M_PI *2.0f clockwise:YES];
            [_legendPaths addObject:legendPath];
            
            UILabel *xValuesLabel = [[UILabel alloc]init];
            xValuesLabel.frame = CGRectMake(self.bounds.size.height + _legendRadius *2.0f + _legendInnerMargin + _legendMarginLeft, margin +(margin +labelHeigth)*i, legendLabeltotalWith * _legendLabelDivisionRatio, labelHeigth);
            xValuesLabel.font = _legendLabelFont;
            xValuesLabel.textColor = _legendLabelColor;
            xValuesLabel.text = item.rawX;
            [self addSubview:xValuesLabel];
            [_XValueLabels addObject:xValuesLabel];
            
            UILabel *yValuesLabel = [[UILabel alloc]init];
            yValuesLabel.frame = CGRectMake(self.bounds.size.height + _legendRadius *2.0f + _legendInnerMargin + _legendMarginLeft + legendLabeltotalWith *_legendLabelDivisionRatio, margin +(margin +labelHeigth)*i, legendLabeltotalWith * (1- _legendLabelDivisionRatio), labelHeigth);
            yValuesLabel.font = _legendLabelFont;
            yValuesLabel.textColor = _legendLabelColor;
            yValuesLabel.textAlignment = NSTextAlignmentRight;
            yValuesLabel.text = [NSString stringWithFormat:@"%.2f%%",[item.rawY floatValue]*100];
            [self addSubview:yValuesLabel];
            [_YvalueLabels addObject:yValuesLabel];
            
        }
    }
}

- (void)drawHoleInCenter:(CGPoint)center{
    _innerHoleLayer = [CAShapeLayer layer];
    _innerHoleLayer.frame = self.bounds;
    _innerHoleLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:_innerHoleLayer];
    
    _innerHolePath = [UIBezierPath bezierPathWithArcCenter:center radius:_pieRadius*_percentOfInnerHoleRadius startAngle:0 endAngle:M_PI *2.0f clockwise:YES];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (!_data.items.count) {
        
        NSString *emptyDesc = @"暂无数据";
        
        CGRect descRect = [emptyDesc boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]
                                              context:nil];
    
        [emptyDesc drawAtPoint:CGPointMake(rect.size.width/2.0f - descRect.size.width/2.0f, rect.size.height/2.0f -descRect.size.height/2.0f) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    }
}



@end
