//
//  LENTurnHistoryTableViewCell.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/19.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENTurnHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)configWithTitle:(NSString *)title date:(NSString *)date;

@end

NS_ASSUME_NONNULL_END
