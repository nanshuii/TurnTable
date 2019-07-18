//
//  LENAddTurnTableViewController.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/10.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENAddTurnTableViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) LENTurnTableModel *model;

@property (nonatomic, assign) BOOL isNew;

@end

NS_ASSUME_NONNULL_END
