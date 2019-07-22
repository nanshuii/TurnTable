//
//  LENTurnTableTableViewCell.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnTableTableViewCell.h"

@implementation LENTurnTableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(LENTurnTableModel *)model{
    self.titleLabel.text = model.name;
    UIImage *image = [LENHandle getTurnTableImageWithTid:model.t_id];
    self.image.image = image;
}

@end
