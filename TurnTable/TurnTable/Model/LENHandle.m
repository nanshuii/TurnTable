//
//  LENHandle.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENHandle.h"
#import "LENTurnTableView.h"

@implementation LENHandle

# pragma mark -- 获取罗盘列表
+ (NSArray *)getTurnTables{
    NSArray *array = [self getTurnTablesArray];
    return [LENTurnTableModel mj_objectArrayWithKeyValuesArray:array];
}

# pragma mark -- 保存一个罗盘
+ (void)saveTurnTable:(LENTurnTableModel *)model{
    NSDictionary *dict = [model mj_keyValues];
    NSArray *array = [self getTurnTablesArray];
    if (array && array.count > 0) {
        NSMutableArray *models = [NSMutableArray arrayWithArray:array];
        [models insertObject:dict atIndex:0];
        [self saveTurnTablesArray:models];
    } else {
        NSArray *models = @[dict];
        [self saveTurnTablesArray:models];
    }
}

# pragma mark -- 更新一个罗盘
+ (void)updateTurnTable:(LENTurnTableModel *)model{
    NSDictionary *dict = [model mj_keyValues];
    NSArray *array = [self getTurnTablesArray];
    if (array && array.count > 0) {
        NSMutableArray *models = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < models.count; i++) {
            NSDictionary *m_dict = models[i];
            NSString *m_id = [m_dict valueForKey:@"t_id"];
            if ([model.t_id isEqualToString:m_id]) {
                [models replaceObjectAtIndex:i withObject:dict];
                [self saveTurnTablesArray:models];
                break;
            }
        }
    }
}

# pragma mark -- 更新罗盘的名字
+ (void)updateTurnTableName:(NSString *)name tid:(NSString *)t_id{
    NSArray *array = [self getTurnTablesArray];
    if (array && array.count > 0) {
        NSMutableArray *models = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < models.count; i++) {
            NSDictionary *m_dict = models[i];
            NSString *m_id = [m_dict valueForKey:@"t_id"];
            if ([t_id isEqualToString:m_id]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:m_dict];
                [dict setValue:name forKey:@"name"];
                [models replaceObjectAtIndex:i withObject:dict];
                [self saveTurnTablesArray:models];
                break;
            }
        }
    }
}

# pragma mark -- 更新罗盘的配色
+ (void)updateTurnTableColors:(NSMutableArray *)colors tid:(NSString *)t_id{
    NSArray *array = [self getTurnTablesArray];
    if (array && array.count > 0) {
        NSMutableArray *models = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < models.count; i++) {
            NSDictionary *m_dict = models[i];
            NSString *m_id = [m_dict valueForKey:@"t_id"];
            if ([t_id isEqualToString:m_id]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:m_dict];
                [dict setValue:colors forKey:@"colors"];
                [models replaceObjectAtIndex:i withObject:dict];
                [self saveTurnTablesArray:models];
                break;
            }
        }
    }
}

# pragma mark -- 插入一个罗盘的记录
+ (void)insertHistoryInTrunTableWithTid:(NSString *)t_id title:(NSString *)title date:(NSString *)date{
    NSArray *array = [self getTurnTablesArray];
    if (array && array.count > 0) {
        NSMutableArray *models = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < models.count; i++) {
            NSDictionary *m_dict = models[i];
            NSString *m_id = [m_dict valueForKey:@"t_id"];
            if ([t_id isEqualToString:m_id]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:m_dict];
                NSArray *historys = [dict valueForKey:@"historys"];
                if (historys && historys.count > 0) {
                    NSMutableArray *historys_n = [NSMutableArray arrayWithArray:historys];
                    NSDictionary *history = @{
                                              @"title": title,
                                              @"date": date
                                              };
                    [historys_n insertObject:history atIndex:0];
                    [dict setValue:historys_n forKey:@"historys"];
                    [models replaceObjectAtIndex:i withObject:dict];
                    [self saveTurnTablesArray:models];
                    break;
                } else {
                    NSDictionary *history = @{
                                              @"title": title,
                                              @"date": date
                                              };
                    NSArray *array = @[history];
                    [dict setValue:array forKey:@"historys"];
                    [models replaceObjectAtIndex:i withObject:dict];
                    [self saveTurnTablesArray:models];
                    break;
                }
            }
        }
    }
}

# pragma mark -- 删除一个罗盘
+ (void)deleteTurnTableWithTid:(NSString *)t_id{
    NSArray *array = [self getTurnTablesArray];
    if (array && array.count > 0) {
        NSMutableArray *models = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < models.count; i++) {
            NSDictionary *m_dict = models[i];
            NSString *m_id = [m_dict valueForKey:@"t_id"];
            if ([t_id isEqualToString:m_id]) {
                [models removeObjectAtIndex:i];
                [self deleteTurnTableImageWithTid:t_id];
                [self saveTurnTablesArray:models];
                break;
            }
        }
    }
}

# pragma mark -- 获取罗盘列表数组
+ (NSArray *)getTurnTablesArray{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:kTurnTables]) {
        NSArray *array = [defaults valueForKey:kTurnTables];
        return array;
    } else {
        return [NSArray array];
    }
}

# pragma mark -- 存入罗盘列表数组
+ (void)saveTurnTablesArray:(NSArray *)array{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:array forKey:kTurnTables];
    [defaults synchronize];
}

# pragma mark -- 从字符串数组颜色中获取16进制颜色
+ (int)getColorHexFormColors:(NSMutableArray *)colors{
    int value = 0;
    for (int i = 0; i < colors.count; i++) {
        NSString *f = colors[i];
        int ff = [f intValue];
        value = value + ff * (pow(16, 5-i));
    }
    return value;
}

# pragma mark -- 从16进制颜色中获取字符串数组
+ (NSMutableArray *)getColorsFormColorHex:(int)colorHex{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:6];
    
    int hex = colorHex;
    int pow5 = (int)pow(16, 5);
    int color0 = hex / pow5;
    [colors addObject:[NSString stringWithFormat:@"%i", color0]];
    hex -= pow5 * color0;
    
    int pow4 = (int)pow(16, 4);
    int color1 = hex / pow4;
    [colors addObject:[NSString stringWithFormat:@"%i", color1]];
    hex -= pow4 * color1;
    
    int pow3 = (int)pow(16, 3);
    int color2 = hex / pow3;
    [colors addObject:[NSString stringWithFormat:@"%i", color2]];
    hex -= pow3 *color2;
    
    int pow2 = (int)pow(16, 2);
    int color3 = hex / pow2;
    [colors addObject:[NSString stringWithFormat:@"%i", color3]];
    hex -= pow2 * color3;

    int pow1 = (int)pow(16, 1);
    int color4 = hex / pow1;
    [colors addObject:[NSString stringWithFormat:@"%i", color4]];
    hex -= pow1 * color4;
    
    [colors addObject:[NSString stringWithFormat:@"%i", hex]];
    
    return colors;
}

# pragma mark -- 返回当前时间时间戳
+ (NSString *)currentDate{
    NSDate *date = [NSDate new];
    long t_id = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%li", t_id];
}

# pragma mark -- 会自动消失的alert
+ (void)alertWithMessage:(NSString *)message vc:(UIViewController *)vc{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [vc presentViewController:alert animated:YES completion:^{
        [self performSelector:@selector(alertDelayDismiss:) withObject:alert afterDelay:2.0];
    }];
}

+ (void)alertDelayDismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark -- 单个输入框的alert
+ (void)alertWithTextField:(NSString *)message vc:(UIViewController *)vc callback:(AlertTextFieldBlock)callback{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        callback(textField.text);
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [vc presentViewController:alert animated:YES completion:nil];
}

# pragma mark -- 随机生成一个颜色数组
+ (NSMutableArray *)randomColor{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        int random = [self random16];
        NSString *color = [NSString stringWithFormat:@"%i", random];
        [colors addObject:color];
    }
    return colors;
}

+ (int)random16{
    int random = arc4random() % 16;
    return random;
}

# pragma mark -- 根据上个颜色生成一个颜色数组
+ (NSMutableArray *)randomColorWithLastColor:(NSMutableArray *)lastColors{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:6];
    for (NSString *color in lastColors) {
        int color_i = [color intValue];
        int color_r = [self randomWithNumber:color_i+16];
        if (color_r - 16 >= 0) {
            color_r -= 16;
        }
        [colors addObject:[NSString stringWithFormat:@"%i", color_r]];
    }
    return colors;
}

+ (int)randomWithNumber:(int)number{
    int random = arc4random() % number;
    return random;
}

# pragma mark -- 根据上个颜色和下个颜色生成一个颜色数组
+ (NSMutableArray *)randomColorWithLastColor:(NSMutableArray *)lastColors nextColors:(NSMutableArray *)nextColors{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:6];
    if (lastColors.count == 0 && nextColors.count == 0) {
        colors = [self randomColor];
    } else if (lastColors.count == 0 && nextColors.count != 0) {
        colors = [self randomColorWithLastColor:nextColors];
    } else if (lastColors.count != 0 && nextColors.count == 0) {
        colors = [self randomColorWithLastColor:lastColors];
    } else {
        for (int i = 0; i < 6; i++) {
            int last = [lastColors[i] intValue];
            int next = [nextColors[i] intValue];
            int color = [self randomWithLast:last next:next];
            [colors addObject:[NSString stringWithFormat:@"%i", color]];
        }
    }
    return colors;
}

+ (int)randomWithLast:(int)last next:(int)next{
    int random = 0;
    while (1) {
        random = arc4random() % 16;
        if (random != last && random != next) {
            break;
        }
    }
    return random;
}

# pragma mark -- 返回colors数组
+ (NSMutableArray *)getColorsFormTurnTableModel:(LENTurnTableModel *)model{
    NSMutableArray *colors = nil;
    BOOL random = YES;
    for (NSMutableArray *colors_a in model.colors) {
        if (colors_a.count != 0) {
            random = NO;
            break;
        }
    }
    if (random == NO) {
        colors = [NSMutableArray arrayWithArray:model.colors];
    }
    return colors;
}

# pragma mark -- 获取罗盘记录是否开启 默认开启
+ (BOOL)getTurnTableRecord{
    BOOL record = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:KTurnTableRecordOpen]) {
        record = [[defaults valueForKey:KTurnTableRecordOpen] boolValue];
    }
    return record;
}

# pragma mark -- 设置罗盘记录是否开启
+ (void)setTurnTableRecord:(BOOL)record{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:record] forKey:KTurnTableRecordOpen];
    [defaults synchronize];
}

# pragma mark -- 生成一张缩略图
+ (void)turnTableImageCreateWithModel:(LENTurnTableModel *)model{
    NSMutableArray *colors = [LENHandle getColorsFormTurnTableModel:model];
    LENTurnTableView *turnTableView = [[LENTurnTableView alloc] initWithFrame:CGRectMake(10, 0, kFullScreenWidth - 20, kFullScreenWidth - 20) titles:model.titles rates:model.rates colors:colors];
    turnTableView.backgroundColor = [UIColor whiteColor];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kFullScreenWidth - 20, kFullScreenWidth - 20), YES, [UIScreen mainScreen].scale);
    [turnTableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (image) {
        NSData *imageData = UIImagePNGRepresentation(image);
        if (imageData) {
            NSString *filename = [NSString stringWithFormat:@"turnTableImage-%@.png", model.t_id];
            NSString *path = [PATHS stringByAppendingPathComponent:filename];
            [imageData writeToFile:path atomically:YES];
        }
    }
}

# pragma mark -- 获取缩略图
+ (UIImage *)getTurnTableImageWithTid:(NSString *)t_id {
    UIImage *image = nil;
    NSString *filename = [NSString stringWithFormat:@"turnTableImage-%@.png", t_id];
    NSString *path = [PATHS stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path];
    if (exist) {
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

# pragma mark -- 删除缩略图
+ (void)deleteTurnTableImageWithTid:(NSString *)t_id{
    NSString *filename = [NSString stringWithFormat:@"turnTableImage-%@.png", t_id];
    NSString *path = [PATHS stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path];
    if (exist) {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            LENLog(@"error = %@", error.description);
        }
    }
}

@end
