//
//  LENAddTrunTableModel.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENAddTrunTableModel : NSObject

@property (nonatomic, copy) NSMutableArray *colors; // F F F F F F

@property (nonatomic, copy, nullable) NSString *message;

@property (nonatomic, assign) int rate;

/**
 初始化一个新的Model

 @return return value description
 */
- (instancetype)initNewModel;

/**
 初始化一个旧的model

 @return return value description
 */
- (instancetype)initOldModelWithColor:(NSMutableArray *)colors message:(NSString *)message rate:(int)rate;

@end

NS_ASSUME_NONNULL_END
