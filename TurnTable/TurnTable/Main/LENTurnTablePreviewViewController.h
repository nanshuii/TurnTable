//
//  LENTurnTablePreviewViewController.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/18.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENTurnTablePreviewViewController : UIViewController

@property (nonatomic, strong) LENTurnTableModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

NS_ASSUME_NONNULL_END
