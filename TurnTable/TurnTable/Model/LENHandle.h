//
//  LENHandle.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AlertTextFieldBlock)(NSString *text);
@interface LENHandle : NSObject

/**
 获取罗盘列表
 
 @return return value description
 */
+ (NSArray *)getTurnTables;


/**
 保存一个罗盘

 @param model model description
 */
+ (void)saveTurnTable:(LENTurnTableModel *)model;

/**
 更新一个罗盘

 @param model model description
 */
+ (void)updateTurnTable:(LENTurnTableModel *)model;


/**
 从字符串数组颜色中获取16进制颜色

 @param colors colors description
 @return return value description
 */
+ (int)getColorHexFormColors:(NSMutableArray *)colors;

/**
 从16进制颜色中获取字符串数组

 @param colorHex colorHex description
 @return return value description
 */
+ (NSMutableArray  *)getColorsFormColorHex:(int)colorHex;

/**
 返回当前时间时间戳

 @return return value description
 */
+ (NSString *)currentDate;

/**
 自动消失的警告框

 @param message message description
 @param vc vc description
 */
+ (void)alertWithMessage:(NSString *)message vc:(UIViewController *)vc;

/**
 单个输入框的alert

 @param message message description
 @param vc vc description
 @param callback callback description
 */
+ (void)alertWithTextField:(NSString *)message vc:(UIViewController *)vc callback:(AlertTextFieldBlock)callback;

/**
 随机生成一个颜色数组

 @return 例如[@"15", @"15", @"15", @"15", @"15", @"15"];
 */
+ (NSMutableArray *)randomColor;

/**
 根据上个颜色生成一个颜色数组

 @param lastColors lastColors description
 @return return value description
 */
+ (NSMutableArray *)randomColorWithLastColor:(NSMutableArray *)lastColors;

/**
 根据上个颜色和下个颜色生成一个颜色数组

 @param lastColors lastColors description
 @param nextColors nextColors description
 @return return value description
 */
+ (NSMutableArray *)randomColorWithLastColor:(NSMutableArray *)lastColors nextColors:(NSMutableArray *)nextColors;

/**
 LENTurnTableModel返回colors数组

 @param model model description
 @return return value description
 */
+ (NSMutableArray *)getColorsFormTurnTableModel:(LENTurnTableModel *)model;
@end

NS_ASSUME_NONNULL_END
