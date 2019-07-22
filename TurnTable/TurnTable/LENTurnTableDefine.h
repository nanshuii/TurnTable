//
//  LENTurnTableDefine.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#ifndef LENTurnTableDefine_h
#define LENTurnTableDefine_h






# pragma mark -- 键值
#define kTurnTables @"kTurnTables"
#define KTurnTableRecordOpen @"KTurnTableRecordOpen" // 罗盘记录功能的开启和关闭


# pragma mark -- 通知的键值
#define kAddTurnTableChange @"kAddTurnTableChange"
#define kTurnTableShowChange @"kTurnTableShowChange"

# pragma mark -- 屏幕的宽高
#define kFullScreenWidth           ([UIScreen mainScreen].bounds.size.width)
#define kFullScreenHeight          ([UIScreen mainScreen].bounds.size.height)

# pragma mark -- 颜色转码
//色码转RGB UIColor
#undef UIColorFromHex
#define UIColorFromHex(hexValue) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:1.0])
//附带透明度
#undef UIColorFromHexA
#define UIColorFromHexA(hexValue,a) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:(a)])

# pragma mark -- 自定义打印，在debug时打印，发布时不打印
#ifdef DEBUG
#define LENLog(fmt, ...) NSLog((@"[函数名:%s] " " [行号:%d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define LENLog(fmt, ...)
#endif

# pragma mark -- 定义弱强引用
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define STRONGSELF(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;

#endif /* LENTurnTableDefine_h */
