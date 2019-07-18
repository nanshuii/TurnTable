//
//  LENColorSelectViewController.h
//  TurnTable
//
//  Created by 林南水 on 2019/7/12.
//  Copyright © 2019 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENColorSelectViewController : UIViewController

@property (nonatomic, copy) NSMutableArray *colors;

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UIView *selectVIew;

@property (nonatomic, assign) NSInteger index;


@end

NS_ASSUME_NONNULL_END
