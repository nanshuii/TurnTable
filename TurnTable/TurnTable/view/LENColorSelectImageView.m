//
//  LENColorSelectImageView.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/12.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENColorSelectImageView.h"

@implementation LENColorSelectImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.image = [UIImage imageNamed:@"palette"];
    self.userInteractionEnabled = YES;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}

# pragma mark -- 坐标
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (pow(point.x - self.bounds.size.width / 2, 2) + pow(point.y - self.bounds.size.width / 2, 2) <= pow(self.bounds.size.width / 2, 2)) {
        int colorHex = [self colorAtPixel:point];
        if (colorHex >= 0) {
            if (_currentColorHex) {
                _currentColorHex(colorHex);
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (pow(point.x - self.bounds.size.width / 2, 2) + pow(point.y - self.bounds.size.width / 2, 2) <= pow(self.bounds.size.width / 2, 2)) {
        int colorHex = [self colorAtPixel:point];
        if (colorHex >= 0) {
            if (_currentColorHex) {
                _currentColorHex(colorHex);
            }
        }
    }
}

# pragma mark -- 计算颜色返回十六进制
- (int)colorAtPixel:(CGPoint)point{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.image.size.width, self.image.size.height), point)) {
        return -1;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.image.CGImage;
    NSUInteger width = self.image.size.width;
    NSUInteger height = self.image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
//    int red   = (CGFloat)pixelData[0] / 255.0;
//    int green = (CGFloat)pixelData[1] / 255.0;
//    int blue  = (CGFloat)pixelData[2] / 255.0;
//    CGFloat alpha = (CGFloat)pixelData[3] / 255.0;
    
    int red = pixelData[0];
    int green = pixelData[1];
    int blue = pixelData[2];
//    NSLog(@"%f***%f***%f***%f",red,green,blue,alpha);
//    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return red << 16 | green << 8 | blue;
}



@end
