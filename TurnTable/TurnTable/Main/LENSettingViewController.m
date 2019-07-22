//
//  LENSettingViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/22.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENSettingViewController.h"

@interface LENSettingViewController ()

@end

@implementation LENSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
}

- (void)setUpUI{
    self.title = @"设置";
    BOOL recordOpen = [LENHandle getTurnTableRecord];
    [self.recordSwitch setOn:recordOpen];
}

# pragma mark -- 记录功能
- (IBAction)recordSwitchValueChanged:(UISwitch *)sender {
    [LENHandle setTurnTableRecord:sender.on];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
