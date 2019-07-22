//
//  LENTurnHistoryTableViewCell.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/19.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnHistoryTableViewCell.h"

@implementation LENTurnHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithTitle:(NSString *)title date:(NSString *)date{
    self.titleLabel.text = title;
    self.dateLabel.text = date;
}

@end
