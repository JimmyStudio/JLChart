//
//  JLSingleLineChart.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLSingleLineChart.h"
#import "JLBubble.h"

@interface JLSingleLineChart()

@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat scaleX;

@property (nonatomic, strong) CAShapeLayer *lineLayer;//线图层
@property (nonatomic, strong) CAShapeLayer *fillLayer;//填充图层
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *yAxisLayers;//y轴图层数组

@property (nonatomic, strong) JLBubble *bubble;


@end

@implementation JLSingleLineChart

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (JLBubble *)bubble{
    if (!_bubble) {
        _bubble = [[JLBubble alloc]init];
        [self addSubview:_bubble];
    }
    return _bubble;
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat vMargin = (rect.size.height - self.chartMarginTop - self.chartMarginBottom) / self.stepCount;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, self.axisWidth);
    CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);
    for (NSInteger i = 0 ; i < self.stepCount +1; i ++) {
        //draw solid outside & inner x axis
        CGContextMoveToPoint(ctx, self.chartMarginLeft, self.chartMarginTop + i * vMargin);
        CGContextAddLineToPoint(ctx, rect.size.width - self.chartMarginRight, self.chartMarginTop + i * vMargin);
        CGContextStrokePath(ctx);
    }
    [super drawRect:rect];
}


- (void)setChartData:(JLLineChartData *)chartData{
    if (_chartData != chartData) {
        _chartData = chartData;
        [self computeMaxYandMinY];
        [self drawXLabelsAndYLabels];
        [self initLayers];
    }
}

- (void)strokeChart{
    CGFloat height = self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    for (JLChartPointSet *set in _chartData.sets) {
        if (set.type == LineChartPointSetTypeNone) {
            CGPoint zero = CGPointMake(self.chartMarginLeft, self.bounds.size.height - self.chartMarginBottom);
            [fillPath moveToPoint:zero];
            for (int i = 0; i < set.items.count; i ++) {
                JLChartPointItem *item = set.items[i];
                item.x = self.chartMarginLeft + i * _scaleX;
                item.y = _minY == _maxY ? height/2.0f + self.chartMarginTop : (_maxY - [item.rawY floatValue])*(height / (_maxY - _minY)) + self.chartMarginTop;
                CGPoint point = CGPointMake(item.x, item.y);
                if (i == 0) {
                    [linePath moveToPoint:point];
                    [fillPath addLineToPoint:point];
                }else if(i == set.items.count -1){
                    [self.bubble showWithPoint:point Content:item.rawY];
                    [self bringSubviewToFront:_bubble];
                    
                    [linePath addLineToPoint:point];
                    [fillPath addLineToPoint:point];
                    [fillPath addLineToPoint:CGPointMake(item.x, self.bounds.size.height - self.chartMarginBottom)];
                    [fillPath closePath];
                }else{
                    [linePath addLineToPoint:point];
                    [fillPath addLineToPoint:point];
                }
            }
        }
    }
    _lineLayer.path = linePath.CGPath;
    _fillLayer.path = fillPath.CGPath;
}

- (void)computeMaxYandMinY{
    _maxY = - MAXFLOAT;
    _minY = MAXFLOAT;
    for (JLChartPointSet *set in _chartData.sets) {
        if (set.type == LineChartPointSetTypeNone) {
            _scaleX = (self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight)/(set.items.count - 1.000f);
            for (JLChartPointItem *item in set.items) {
                if ([item.rawY floatValue] >= _maxY) {
                    _maxY = [item.rawY floatValue];
                }
                if ([item.rawY floatValue] <= _minY) {
                    _minY = [item.rawY floatValue];
                }
            }
        }
    }
    CGFloat extra = (_maxY -_minY)/(self.stepCount *2.000f);//expan y axis
    _maxY += extra;
    _minY -= extra;
}

- (void)drawXLabelsAndYLabels{
    //clear labels
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    [self drawXLabels];
    [self drawYLabels];
}

- (void)drawYLabels{
    CGFloat vMargin = (self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom) / self.stepCount;
    if (_maxY == _minY) {
        CGFloat step = (_maxY * 2.0f)/self.stepCount;
        for (int i = 0; i < self.stepCount + 1; i ++) {
            NSString *leftY = [self formatYLabelWith:_maxY * 2.0f - i * step];
            CGRect leftRect = [self caculatRectWithString:leftY andFont:self.yLabelFont];
            UILabel *leftYLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chartMarginLeft, self.chartMarginTop + i * vMargin - leftRect.size.height , leftRect.size.width +self.yLabelWidthPadding, leftRect.size.height)];
            leftYLabel.text = leftY;
            leftYLabel.textAlignment = NSTextAlignmentCenter;
            leftYLabel.font = self.yLabelFont;
            leftYLabel.textColor = self.yLabelColor;
            [self addSubview:leftYLabel];
            
        }
    }else
    {
        CGFloat step = (_maxY - _minY)/self.stepCount;
        for (int i = 0; i < self.stepCount + 1; i ++) {
            NSString *leftY = [self formatYLabelWith:_maxY - i * step];
            CGRect leftRect = [self caculatRectWithString:leftY andFont:self.yLabelFont];
            UILabel *leftYLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chartMarginLeft, self.chartMarginTop + i * vMargin - leftRect.size.height , leftRect.size.width + self.yLabelWidthPadding, leftRect.size.height)];
            leftYLabel.text = leftY;
            leftYLabel.textAlignment = NSTextAlignmentCenter;
            leftYLabel.font = self.yLabelFont;
            leftYLabel.textColor = self.yLabelColor;
            [self addSubview:leftYLabel];
        }
    }
}

- (void)drawXLabels{
    for (CAShapeLayer *layer in _yAxisLayers) {
        [layer removeFromSuperlayer];
    }
    _yAxisLayers = @[].mutableCopy;
    for (int i = 0; i < [_chartData.sets firstObject].items.count; i ++) {
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.frame = self.bounds;
        lineLayer.lineCap = kCALineCapRound;
        lineLayer.lineJoin = kCALineJoinBevel;
        lineLayer.fillColor = nil;
        lineLayer.strokeColor = [self.axisColor CGColor];
        lineLayer.lineWidth = self.axisWidth;
        [self.layer addSublayer:lineLayer];
        [_yAxisLayers addObject:lineLayer];
        
        UIBezierPath *yAxis = [UIBezierPath bezierPath];
        [yAxis moveToPoint:CGPointMake(self.chartMarginLeft + i *_scaleX, self.chartMarginTop)];
        [yAxis addLineToPoint:CGPointMake(self.chartMarginLeft + i *_scaleX, self.bounds.size.height - self.chartMarginBottom)];
        
        lineLayer.path = yAxis.CGPath;
        
        NSString *x = [[_chartData.sets firstObject].items objectAtIndex:i].rawX;
        CGRect rect = [self caculatRectWithString:x andFont:self.xLabelFont];
        UILabel *label = [[UILabel alloc]init];
        if (i == 0) {
            label.frame = CGRectMake(self.chartMarginLeft, self.bounds.size.height - self.chartMarginBottom, rect.size.width, rect.size.height+5.0f);
        }else if (i == [_chartData.sets firstObject].items.count -1){
            label.frame = CGRectMake(self.bounds.size.width - self.chartMarginRight - rect.size.width, self.bounds.size.height - self.chartMarginBottom, rect.size.width, rect.size.height+5.0f);
        }else{
            label.frame = CGRectMake(self.chartMarginLeft + i*_scaleX - rect.size.width /2.0f, self.bounds.size.height - self.chartMarginBottom, rect.size.width, rect.size.height+5);
        }
        label.textColor = self.xLabelColor;
        label.font = self.xLabelFont;
        label.text = x;
        [self addSubview:label];
    }
}

- (void)initLayers{
    [_lineLayer removeFromSuperlayer];
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.frame = self.bounds;
    _lineLayer.lineCap = kCALineCapButt;
    _lineLayer.lineJoin = kCALineJoinBevel;
    _lineLayer.fillColor = nil;
    _lineLayer.strokeColor = [_chartData.lineColor CGColor];
    _lineLayer.lineWidth = _chartData.lineWidth;
    [self.layer addSublayer:_lineLayer];
    
    if (_chartData.fillColor) {
        [_fillLayer removeFromSuperlayer];
        _fillLayer = [CAShapeLayer layer];
        _fillLayer.frame = self.bounds;
        _fillLayer.lineCap = kCALineCapRound;
        _fillLayer.lineJoin = kCALineJoinBevel;
        _fillLayer.fillColor = [_chartData.fillColor CGColor];
        _fillLayer.strokeColor = nil;
        [self.layer addSublayer:_fillLayer];
    }
}

#pragma mark tools
- (CGRect )caculatRectWithString:(NSString *)string andFont:(UIFont *)font{
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]
                                context:nil];
}

- (NSString *)formatYLabelWith:(CGFloat)value{
    return [NSString stringWithFormat:@"%.3f",value];
}


@end
