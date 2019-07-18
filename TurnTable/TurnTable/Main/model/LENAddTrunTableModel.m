//
//  LENAddTrunTableModel.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENAddTrunTableModel.h"

@implementation LENAddTrunTableModel

# pragma mark -- 初始化一个新的
- (instancetype)initNewModel{
    self = [super init];
    if (self) {
        self.colors = [NSMutableArray array];
        self.message = nil;
        self.rate = 1;
    }
    return self;
}

# pragma mark -- 初始化一个旧的model
- (instancetype)initOldModelWithColor:(NSMutableArray *)colors message:(NSString *)message rate:(int)rate{
    self = [super init];
    if (self) {
        self.colors = colors;
        self.message = message;
        self.rate = rate;
    }
    return self;
}

@end
