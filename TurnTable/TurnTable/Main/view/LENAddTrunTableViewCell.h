//
//  LENAddTrunTableViewCell.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MessageChangeBlock)(NSString  * _Nonnull message);
typedef void(^RateChangeBlock)(NSString * _Nonnull rate);
typedef void(^ColorButtonBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface LENAddTrunTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@property (weak, nonatomic) IBOutlet UITextField *rateTextField;

@property (weak, nonatomic) IBOutlet UIButton *colorButton;

@property (nonatomic, copy) MessageChangeBlock messageChangeBlock;

@property (nonatomic, copy) RateChangeBlock rateChangeBlock;

@property (nonatomic, copy) ColorButtonBlock colorButtonBlock;

- (void)configWithModel:(LENAddTrunTableModel *)model;

- (void)removeNotifications;

@end

NS_ASSUME_NONNULL_END
