//
//  LENTurnTableTableViewCell.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENTurnTableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *image;

- (void)configWithModel:(LENTurnTableModel *)model;

@end

NS_ASSUME_NONNULL_END
