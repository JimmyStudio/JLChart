//
//  JLLineChart.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLLineChart.h"
#import "JLChartPointItem.h"
#import "JLChartPointSet.h"

@interface JLLineChart ()
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat scaleX;
//layer
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *lineLayerArray;//线图层
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *fillLayerArray;//填充图层
//@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *nomarlPointLayerArray;//普通点图层 //暂无
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *buyPointLayerArray;//买点图层
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *relocatePointLayerArray;//调仓点图层

//path
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *linePathArray;//线数组
//@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *normalPointPathArray;//普通点 //暂无
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *buyPointPathArray;//买点
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *relocatePointPathArray;//调仓点

//indicate Line
@property (nonatomic, strong) UIView *horizonLine;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *curveValueLabel;
@property (nonatomic, strong) UIView *indicatePoint;


@end

@implementation JLLineChart

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGestureRecognizerHandle:)];
        [longPGR setMinimumPressDuration:0.3f];
        [longPGR setAllowableMovement:frame.size.width - self.chartMarginLeft - self.chartMarginBottom];
        [self addGestureRecognizer:longPGR];
    }
    return self;
}

- (void)setChartDatas:(NSMutableArray<JLLineChartData *> *)chartDatas{
    if (chartDatas != _chartDatas) {
        _chartDatas =chartDatas;
        [self computeMaxYandMinY];
        [self drawXLabelsAndYLabels];
        [self initLayers];
    }
    
}

- (void)strokeChart{
    _linePathArray = @[].mutableCopy;
    _buyPointPathArray = @[].mutableCopy;
    _relocatePointPathArray = @[].mutableCopy;
    [self calculateBezierPathsForChart];
    for (int i = 0; i < _lineLayerArray.count; i ++) {
        _lineLayerArray[i].path = _linePathArray[i].CGPath;
        if (self.displayAnimated) {
           
        }
    }
    for (int i = 0; i < _buyPointLayerArray.count; i ++) {
        _buyPointLayerArray[i].path = _buyPointPathArray[i].CGPath;
        if (self.displayAnimated) {
           
        }
    }
    for (int i = 0; i < _relocatePointLayerArray.count; i ++) {
        _relocatePointLayerArray[i].path = _relocatePointPathArray[i].CGPath;
    }
}

- (void)updateChartWithChartData:(NSMutableArray<JLLineChartData *> *)chartData{
    
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat vMargin = (rect.size.height - self.chartMarginTop - self.chartMarginBottom) / self.stepCount;
    CGFloat hMargin = (rect.size.width - self.chartMarginLeft - self.chartMarginRight)/ (self.stepCount - 1.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, self.axisWidth);
    CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);
    if (self.axisType == (ChartAxisTypeBoth | ChartAxisTypeDash)) {
        //solid x axis
        CGContextMoveToPoint(ctx, self.chartMarginLeft, self.chartMarginTop + self.stepCount * vMargin);
        CGContextAddLineToPoint(ctx, rect.size.width - self.chartMarginRight, self.chartMarginTop + self.stepCount * vMargin);
        CGContextStrokePath(ctx);
        
        CGFloat dash[] = {1.0f,1.0f};
        CGContextSetLineDash(ctx, 1.0f, dash, 2.0f);
        for (NSInteger i = 0 ; i < self.stepCount; i ++) {
            //draw inner dash x axis
            CGContextMoveToPoint(ctx, self.chartMarginLeft, self.chartMarginTop + i * vMargin);
            CGContextAddLineToPoint(ctx, rect.size.width - self.chartMarginRight, self.chartMarginTop + i * vMargin);
            CGContextStrokePath(ctx);
            //draw dash y axis
            CGContextMoveToPoint(ctx, self.chartMarginLeft + i * hMargin, self.chartMarginTop);
            CGContextAddLineToPoint(ctx, self.chartMarginLeft + i * hMargin, rect.size.height - self.chartMarginBottom);
            CGContextStrokePath(ctx);
        }
    }
    [super drawRect:rect];
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
    //only show left and right
    NSString *leftX = [[[_chartDatas firstObject].sets firstObject].items firstObject].rawX;
    CGRect leftRect = [self caculatRectWithString:leftX andFont:self.xLabelFont];
    UILabel *leftXLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chartMarginLeft, self.bounds.size.height - self.chartMarginBottom, leftRect.size.width, leftRect.size.height+5)];
    leftXLabel.textColor = self.xLabelColor;
    leftXLabel.font = self.xLabelFont;
    leftXLabel.text = leftX;
    [self addSubview:leftXLabel];
    
    NSString *rightX = [[[_chartDatas firstObject].sets firstObject].items lastObject].rawX;
    CGRect rightRect = [self caculatRectWithString:rightX andFont:self.xLabelFont];
    UILabel *rightXLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - self.chartMarginRight - rightRect.size.width, self.bounds.size.height - self.chartMarginBottom, rightRect.size.width, rightRect.size.height+5)];
    rightXLabel.textColor = self.xLabelColor;
    rightXLabel.font = self.xLabelFont;
    rightXLabel.text = rightX;
    [self addSubview:rightXLabel];
}

- (void)initLayers{
    //clear layers
    for (CALayer *layer in self.lineLayerArray) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.fillLayerArray) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.buyPointLayerArray) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.relocatePointLayerArray) {
        [layer removeFromSuperlayer];
    }
    //init layers
    self.lineLayerArray = [NSMutableArray arrayWithCapacity:_chartDatas.count];
    self.fillLayerArray = [NSMutableArray arrayWithCapacity:_chartDatas.count];
    self.buyPointLayerArray = @[].mutableCopy;
    self.relocatePointLayerArray = @[].mutableCopy;
    
    for (JLLineChartData *data in _chartDatas) {
        //line shapelayer
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.frame = self.bounds;
        lineLayer.lineCap = kCALineCapRound;
        lineLayer.lineJoin = kCALineJoinBevel;
        lineLayer.fillColor = nil;
        lineLayer.strokeColor = [data.lineColor CGColor];
        lineLayer.lineWidth = data.lineWidth;
        [self.layer addSublayer:lineLayer];
        [self.lineLayerArray addObject:lineLayer];
        //fillSharpLayer
        if (data.fillColor) {
            CAShapeLayer *fillLayer = [CAShapeLayer layer];
            fillLayer.frame = self.bounds;
            fillLayer.lineCap = kCALineCapRound;
            fillLayer.lineJoin = kCALineJoinBevel;
            fillLayer.fillColor = [data.fillColor CGColor];
            fillLayer.strokeColor = nil;
            [self.layer addSublayer:lineLayer];
            [self.fillLayerArray addObject:lineLayer];
        }
        for (JLChartPointSet *set in data.sets) {
            if (set.type == LineChartPointSetTypeBuy) {
                CAShapeLayer *fillLayer = [CAShapeLayer layer];
                fillLayer.frame = self.bounds;
                fillLayer.lineCap = kCALineCapRound;
                fillLayer.lineJoin = kCALineJoinBevel;
                fillLayer.fillColor = [set.buyPointColor CGColor];
                fillLayer.strokeColor = nil;
                [self.layer addSublayer:fillLayer];
                [self.buyPointLayerArray addObject:fillLayer];
                
            }else if (set.type == LineChartPointSetTypeRelocate){
                CAShapeLayer *fillLayer = [CAShapeLayer layer];
                fillLayer.frame = self.bounds;
                fillLayer.lineCap = kCALineCapRound;
                fillLayer.lineJoin = kCALineJoinBevel;
                fillLayer.fillColor = [set.relocatePointColor CGColor];
                fillLayer.strokeColor = nil;
                [self.layer addSublayer:fillLayer];
                [self.relocatePointLayerArray addObject:fillLayer];
                
            }
        }
        
    }
}

- (void)calculateBezierPathsForChart{
    CGFloat height = self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom;
    for (JLLineChartData *data in _chartDatas) {
        for (JLChartPointSet *set in data.sets) {
            if (set.type == LineChartPointSetTypeNone) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                for (int i = 0; i < set.items.count; i ++) {
                    JLChartPointItem *item = set.items[i];
                    item.x = self.chartMarginLeft + i * _scaleX;
                    item.y = _minY == _maxY ? height/2.0f + self.chartMarginTop : (_maxY - [item.rawY floatValue])*(height / (_maxY - _minY)) + self.chartMarginTop;
                    CGPoint point = CGPointMake(item.x, item.y);
                    if (i == 0) {
                        [path moveToPoint:point];
                    }else{
                        [path addLineToPoint:point];
                    }
                    for (JLChartPointSet *buySet in data.sets) {
                        if (buySet.type == LineChartPointSetTypeBuy) {
                            for (JLChartPointItem *buyItem in buySet.items) {
                                if ([buyItem.rawX isEqualToString:item.rawX]) {
                                    buyItem.x = point.x;
                                    buyItem.y = point.y;
                                    UIBezierPath *buyPath = [UIBezierPath bezierPath];
                                    [buyPath addArcWithCenter:point radius:set.pointRadius startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
                                    [_buyPointPathArray addObject:buyPath];
                                }
                            }
                        }else if (buySet.type == LineChartPointSetTypeRelocate){
                            for (JLChartPointItem *relocateItem in buySet.items) {
                                if ([relocateItem.rawX isEqualToString:item.rawX]) {
                                    relocateItem.x = point.x;
                                    relocateItem.y = point.y;
                                    UIBezierPath *relocatePath = [UIBezierPath bezierPath];
                                    [relocatePath addArcWithCenter:point radius:set.pointRadius startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
                                    [_relocatePointPathArray addObject:relocatePath];
                                }
                            }
                        }
                    }
                }
                [_linePathArray addObject:path];
            }
        }
    }
}

- (void)drawNormalPathWithItems:(NSMutableArray *)items WithScale:(CGFloat)scale{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < items.count; i ++) {
        JLChartPointItem *item = items[i];
        if (i == 0) {
            [path moveToPoint:CGPointMake(self.chartMarginLeft, (_maxY - [item.rawY floatValue])*scale)];
        }else{
            [path addLineToPoint:CGPointMake(self.chartMarginLeft + i * _scaleX, (_maxY - [item.rawY floatValue])*scale)];
        }
    }
    [_linePathArray addObject:path];
}


- (void)computeMaxYandMinY{
    _maxY = - MAXFLOAT;
    _minY = MAXFLOAT;
    for(JLLineChartData *data in _chartDatas){
        for (JLChartPointSet *set in data.sets) {
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
    }
    CGFloat extra = (_maxY -_minY)/(self.stepCount *2.000f);//expan y axis
    _maxY += extra;
    _minY -= extra;
}

- (void)longGestureRecognizerHandle:(UILongPressGestureRecognizer*)longResture{
    if (longResture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [longResture locationInView:self];
        [self drawIndicatesWith:point];
    }else if (longResture.state == UIGestureRecognizerStateEnded){
        [_horizonLine removeFromSuperview];
        [_verticalLine removeFromSuperview];
        [_indicatePoint removeFromSuperview];
        [_dateLabel removeFromSuperview];
        [_curveValueLabel removeFromSuperview];
        _horizonLine = nil;
        _verticalLine = nil;
        _indicatePoint = nil;
        _dateLabel = nil;
        _curveValueLabel = nil;
    }
}

- (void)drawIndicatesWith:(CGPoint )point{
    JLLineChartData *data = _chartDatas[0];
    for (JLChartPointSet *set in data.sets) {
        if (set.type == LineChartPointSetTypeNone) {
            for (JLChartPointItem *item in set.items) {
                if (item.x >= point.x - _scaleX/2.0f && item.x <= point.x + _scaleX/2.0f) {
                    self.horizonLine.frame = CGRectMake(self.chartMarginLeft, item.y - 2.0f, self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight, 4);
                    self.verticalLine.frame = CGRectMake(item.x - 2.0f, self.chartMarginTop, 4.0f, self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom);
                    self.indicatePoint.frame = CGRectMake(item.x - 3.0f, item.y - 3.0f, 6.0f, 6.0f);
                    
                    if (item.x <= self.chartMarginLeft + 35.0f) {
                        self.dateLabel.frame = CGRectMake(self.chartMarginLeft, self.chartMarginTop - 15.0f, 70.0f, 15.0f);
                    }
                    else if (item.x >= self.bounds.size.width - 35.0f - self.chartMarginRight)
                    {
                        self.dateLabel.frame = CGRectMake(self.bounds.size.width - self.chartMarginRight - 70.0f, self.chartMarginTop - 15.0f, 70.0f, 15.0f);
                    }else{
                        self.dateLabel.frame = CGRectMake(item.x - 35.0f, self.chartMarginTop - 15.0f, 70.0f, 15.0f);
                    }
                    _dateLabel.text = item.rawX;
                    if (item.x <= self.bounds.size.width/2.0f) {
                        self.curveValueLabel.frame = CGRectMake(self.bounds.size.width - self.chartMarginRight - 60.0f , item.y - 7.5f, 60.0f, 15.0f);
                    }else{
                        self.curveValueLabel.frame = CGRectMake(self.chartMarginLeft , item.y - 7.5f, 60.0f, 15.0f);
                    }
                    _curveValueLabel.text = [self formatYLabelWith:[item.rawY floatValue]];
                    
                    _horizonLine.hidden = NO;
                    _verticalLine.hidden = NO;
                    _indicatePoint.hidden = NO;
                    _dateLabel.hidden = NO;
                    _curveValueLabel.hidden = NO;
                    
                    break;
                }
            }
        }
    }
}


- (UIView *)horizonLine{
    if(!_horizonLine){
        _horizonLine = [[UIView alloc]initWithFrame:CGRectMake(self.chartMarginLeft, self.bounds.size.height/2.0f - 2.0f, self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight, 4.0f)];
        _horizonLine.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0.0f,0.0f, self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight, 4.0f);
        layer.strokeColor = self.xIndicateLineColor.CGColor;
        layer.lineWidth = self.xIndicateLineWidth;
        layer.lineDashPattern = @[@2.0f, @2.0f];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0f, 2.0f)];
        [path addLineToPoint:CGPointMake(_horizonLine.bounds.size.width, 2.0f)];
        layer.path = path.CGPath;
        [_horizonLine.layer addSublayer:layer];
        _horizonLine.hidden = YES;
        [self addSubview: _horizonLine];
    }
    return _horizonLine;
}

- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2.0f - 2.0f, self.chartMarginTop, 4.0f, self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom)];
        _verticalLine.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0.0f, 0.0f, 4.0f, self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom);
        layer.strokeColor = self.yIndicateLineColor.CGColor;
        layer.lineWidth = self.yIndicateLineWidth;
        layer.lineDashPattern = @[@2.0f, @2.0f];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(2.0f, 0.0f)];
        [path addLineToPoint:CGPointMake(2.0f, _verticalLine.bounds.size.height)];
        layer.path = path.CGPath;
        [_verticalLine.layer addSublayer:layer];
        _verticalLine.hidden = YES;
        [self addSubview:_verticalLine];
    }
    return _verticalLine;
}

- (UIView *)indicatePoint{
    if (!_indicatePoint) {
        _indicatePoint = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2.0f - 3.0f, self.bounds.size.height/2.0f - 3.0f, 6.0f, 6.0f)];
        _indicatePoint.backgroundColor = [UIColor clearColor];
        CAShapeLayer *indicatePointBackLayer = [CAShapeLayer layer];
        indicatePointBackLayer.frame = CGRectMake(0.0f, 0.0f, 6.0f, 6.0f);
        indicatePointBackLayer.fillColor= self.indicatePointBackColor.CGColor;
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(3.0f, 3.0f) radius:3.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
        indicatePointBackLayer.path = path1.CGPath;
        [_indicatePoint.layer addSublayer:indicatePointBackLayer];
        
        CAShapeLayer *indicatePointLayer = [CAShapeLayer layer];
        indicatePointLayer.frame = CGRectMake(0.0f, 0.0f, 6.0f, 6.0f);
        indicatePointLayer.fillColor= self.indicatePointColor.CGColor;
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(3.0f, 3.0f) radius:2.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
        indicatePointLayer.path = path2.CGPath;
        [_indicatePoint.layer addSublayer:indicatePointLayer];
        
        _indicatePoint.hidden = YES;
        [self addSubview:_indicatePoint];
        
    }
    return _indicatePoint;
}


- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];\
        _dateLabel.font = self.xIndicateLabelFont;
        _dateLabel.textColor = self.xIndicateLabelTextColor;
        _dateLabel.backgroundColor = self.xIndicateLabelBackgroundColor;
        _dateLabel.textAlignment =NSTextAlignmentCenter;
        _dateLabel.hidden = YES;
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (UILabel *)curveValueLabel{
    if (!_curveValueLabel) {
        _curveValueLabel = [[UILabel alloc]init];
        _curveValueLabel.font = self.yIndicateLabelFont;
        _curveValueLabel.textColor = self.yIndicateLabelTextColor;
        _curveValueLabel.backgroundColor = self.yIndicateLabelBackgroundColor;
        _curveValueLabel.textAlignment =NSTextAlignmentCenter;
        _curveValueLabel.hidden = YES;
        [self addSubview:_curveValueLabel];
    }
    return _curveValueLabel;
}

#pragma mark tools
- (CGRect )caculatRectWithString:(NSString *)string andFont:(UIFont *)font{
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]
                                context:nil];
}

- (NSString *)formatYLabelWith:(CGFloat)value{
    if (self.signedValue) {
        if (value > 0) {
            return [NSString stringWithFormat:@"+%.2f%@",value,self.yLabelSuffix];
            
        }else
        {
            return [NSString stringWithFormat:@"%.2f%@",value,self.yLabelSuffix];
        }
        
    }else
    {
        return [NSString stringWithFormat:@"%.2f%@",value,self.yLabelSuffix];
    }
}

@end
