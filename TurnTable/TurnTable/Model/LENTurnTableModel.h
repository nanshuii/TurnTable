//
//  LENTurnTableModel.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENTurnTableModel : NSObject

@property (nonatomic, copy) NSString *t_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) NSArray *rates;

@property (nonatomic, copy) NSArray *colors;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSMutableArray *historys; // 记录的历史

@end

NS_ASSUME_NONNULL_END
