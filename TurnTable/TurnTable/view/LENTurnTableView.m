//
//  LENTurnTableView.m
//  LedonDemo
//
//  Created by 林南水 on 2019/7/5.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnTableView.h"

@interface LENTurnTableView()<CAAnimationDelegate>

@property (nonatomic, assign) CGFloat width;

//@property (nonatomic, strong) UIView *bigCycleView;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *rates;

@property (nonatomic, strong) NSMutableArray *angles;

@property (nonatomic, strong) NSMutableArray *colors;

@property (nonatomic, assign) BOOL isCycle; // 是否正在旋转

@property (nonatomic, assign) BOOL animation; // 是否开启动画

@property (nonatomic, strong) CAShapeLayer *bgLayer;

@property (nonatomic, assign) float rateAll; // 所有角度值的总和

@property (nonatomic, assign) int randomAngle; // 随机选中的角度值

@end

@implementation LENTurnTableView

# pragma mark -- 初始化
/**
 初始化 比率相同 并且颜色随机
 
 @param frame frame description
 @param titles titles description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self == [super initWithFrame:frame]) {
        [self initWithTitles:titles rates:nil colors:nil];
    }
    return self;
}


/**
 初始化 自定义比率 颜色随机
 
 @param frame frame description
 @param titles titles description
 @param rates rates description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles rates:(NSArray *)rates{
    if (self == [super initWithFrame:frame]) {
        [self initWithTitles:titles rates:rates colors:nil];
    }
    return self;
}

/**
 初始化 比率随机 自定义颜色
 
 @param frame frame description
 @param titles titles description
 @param colors colors description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles colors:(NSArray *)colors{
    if (self == [super initWithFrame:frame]) {
        [self initWithTitles:titles rates:nil colors:colors];
    }
    return self;
}

/**
 初始化 自定义比率 自定义颜色
 
 @param frame frame description
 @param titles titles description
 @param rates rates description
 @param colors colors description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles rates:(NSArray *)rates colors:(NSArray *)colors{
    if (self == [super initWithFrame:frame]) {
        [self initWithTitles:titles rates:rates colors:colors];
    }
    return self;
}

// 初始化
- (void)initWithTitles:(NSArray *)titles rates:(NSArray *)rates colors:(NSArray *)colors{
    self.titles = [NSMutableArray arrayWithArray:titles];
    NSInteger count = self.titles.count;
    if (rates) {
        self.rates = [NSMutableArray arrayWithArray:rates];
    } else {
        self.rates = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            NSNumber *number = [NSNumber numberWithInt:1];
            [self.rates addObject:number];
        }
    }
    if (colors) {
        self.colors = [NSMutableArray arrayWithArray:colors];
        [self randomColors];
    } else {
        [self randomColorWithCount:count];
    }
    [self setUpUI];
}

# pragma mark -- 随机颜色生成
// 完全随机生成
- (void)randomColorWithCount:(NSInteger)count{
    self.colors = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *lastColors = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            lastColors = [LENHandle randomColor];
            [self.colors addObject:lastColors];
        } else {
            lastColors = [LENHandle randomColorWithLastColor:lastColors];
            [self.colors addObject:lastColors];
        }
    }
}

// 根据前后来生成
- (void)randomColors{
    NSMutableArray *lastColors = [NSMutableArray array];
    NSMutableArray *nextColors = [NSMutableArray array];
    NSInteger count = self.colors.count;
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            if (count >= 1) {
                nextColors = self.colors[i+1];
            }
            NSMutableArray *colors = [LENHandle randomColorWithLastColor:lastColors nextColors:nextColors];
            [self.colors replaceObjectAtIndex:i withObject:colors];
        } else {
            NSMutableArray *colors = self.colors[i];
            if (colors.count == 0) {
                lastColors = self.colors[i-1];
                if (i == count - 1) {
                    nextColors = [NSMutableArray array];
                }
                colors = [LENHandle randomColorWithLastColor:lastColors nextColors:nextColors];
                [self.colors replaceObjectAtIndex:i withObject:colors];
            }
        }
    }
}



# pragma mark -- setUpUI
- (void)setUpUI{
    NSLog(@"setUpUI");
    
    self.width = self.frame.size.width;
    CGPoint layerCenter = CGPointMake(self.width/2, self.width/2);
    self.bgLayer = [CAShapeLayer layer];
    self.bgLayer.frame = self.bounds;
    self.bgLayer.lineWidth = 2.0;
    self.bgLayer.strokeColor = [UIColor redColor].CGColor;
    self.bgLayer.fillColor = [UIColor whiteColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:layerCenter radius:self.width / 2 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    self.bgLayer.path = path.CGPath;
    [self.layer addSublayer:self.bgLayer];
    
    [self createCircles];
}

- (void)createCircles{
    // 获取角度数组
    self.rateAll = 0.0;
    for (NSNumber *num in self.rates) {
        float rate = [num floatValue];
        self.rateAll += rate;
    }
    float rateUsed = 0.0;
    for (int i = 0; i < self.rates.count; i++) {
        NSNumber *num = self.rates[i];
        float angle = 0.0;
        if (i == self.rates.count - 1) {
            angle = 2 * M_PI - rateUsed;
            [self createViewWithStartAngle:rateUsed endAngle:2 * M_PI title:self.titles[i] colors:self.colors[i]];
        } else {
            float rate = [num floatValue];
            angle = rate / self.rateAll;
            angle = angle * 2 * M_PI;
            [self createViewWithStartAngle:rateUsed endAngle:angle + rateUsed title:self.titles[i] colors:self.colors[i]];
            rateUsed += angle;
        }
    }
    [self createArrow];
}

// 开始角度 结束角度 标题
- (void)createViewWithStartAngle:(float)startAngle endAngle:(float)endAngle title:(NSString *)title colors:(NSMutableArray *)colors{
    int color_i = [LENHandle getColorHexFormColors:colors];
    UIColor *color = UIColorFromHex(color_i);
    int labelColor_i = 16777215 - color_i;
    UIColor *labelColor = UIColorFromHex(labelColor_i);
    
    float angle = endAngle - startAngle;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    layer.fillColor = color.CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.width/2, self.width/2)];
    [path addArcWithCenter:CGPointMake(self.width/2, self.width/2) radius:self.width / 2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    layer.path = path.CGPath;
    [self.bgLayer addSublayer:layer];
    
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = labelColor;
    CGFloat labelWidth = [self getLabelWidth:label];
    label.frame = CGRectMake(0, 0, labelWidth, self.width / 2 + labelWidth / 2);
    label.layer.anchorPoint = CGPointMake(0.5, 1.0);
    label.center = CGPointMake(self.width / 2, self.width / 2);
    label.transform = CGAffineTransformMakeRotation(M_PI_2 + angle/2 + startAngle);
    [self addSubview:label];
    [self.bgLayer addSublayer:label.layer];
}

# pragma mark -- label 长度计算
- (CGFloat)getLabelWidth:(UILabel *)label{
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    return size.width;
}

# pragma mark -- 转头制作
- (void)createArrow{
    CGPoint center = CGPointMake(self.width / 2, self.width / 2);
    
    CAShapeLayer *arrowLayer = [CAShapeLayer layer];
    arrowLayer.frame = self.bounds;
    arrowLayer.lineWidth = 2.0;
    arrowLayer.strokeColor = [UIColor whiteColor].CGColor;
    arrowLayer.fillColor = [UIColor whiteColor].CGColor;
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(self.width / 2 - 6, self.width / 2)];
    [arrowPath addLineToPoint:CGPointMake(self.width / 2 + 6, self.width / 2)];
    [arrowPath addLineToPoint:CGPointMake(self.width / 2 + 6, self.width / 2 - 30)];
    [arrowPath addLineToPoint:CGPointMake(self.width / 2, self.width / 2 - 40)];
    [arrowPath addLineToPoint:CGPointMake(self.width / 2 - 6, self.width / 2 - 30)];
    [arrowPath addLineToPoint:CGPointMake(self.width / 2 - 6, self.width / 2)];
    arrowLayer.path = arrowPath.CGPath;
    [self.layer addSublayer:arrowLayer];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.lineWidth = 2.0;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:10 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}

# pragma mark -- 转圈
- (void)startCycle{
    if (self.isCycle) {
        return;
    }
    if (self.animation) {
        [self.bgLayer removeAllAnimations];
    }
    self.isCycle = YES;
    
    self.randomAngle = arc4random() % 360;
//    self.randomAngle += 180;
//    self.randomAngle = self.randomAngle % 360;
    
    CGFloat perAngle = M_PI / 180;
    int randomP = arc4random() % 5;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:self.randomAngle * perAngle + 360 * perAngle * (8 + randomP)];
    rotationAnimation.duration = 3.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    
    //
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [self.bgLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    self.animation = YES;
}

# pragma mark -- 转圈结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"转圈结束 random angle = %i", self.randomAngle);
    self.isCycle = NO;
    [self calculationCyclePosition];
}

# pragma mark -- 计算落点位置
- (void)calculationCyclePosition{
    int rateUsed = self.randomAngle;
    for (int i = 0; i < self.rates.count; i++) {
        // 查询270度在哪个位置
        NSNumber *number = self.rates[i];
        float rate = [number floatValue];
        rate = rate / self.rateAll * 360;
        rate = rate + rateUsed;
        int startAngle = rateUsed;
        int endAngle = rate;
        if (endAngle > 360 && startAngle > 360) {
            endAngle -= 360;
        }
        if (startAngle <= 270 && endAngle >= 270) {
            if (_foodBlock) {
                _foodBlock(self.titles[i], i);
            }
            break;
        }
        rateUsed = endAngle;
    }
}





@end
