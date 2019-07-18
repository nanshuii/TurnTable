//
//  LENTurnTableShowViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/16.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnTableShowViewController.h"
#import "LENTurnTableView.h"
#import "LENAddTurnTableViewController.h"

@interface LENTurnTableShowViewController ()

@property (nonatomic, strong) LENTurnTableView *turnTableView;

@end

@implementation LENTurnTableShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reopen:) name:kTurnTableShowChange object:nil];
}

- (void)setUpUI{
    WEAKSELF(weakSelf);
    self.title = self.model.name;
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"edit" style:(UIBarButtonItemStyleDone) target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItem:editItem];
    NSMutableArray *colors = [LENHandle getColorsFormTurnTableModel:self.model];
    self.turnTableView = [[LENTurnTableView alloc] initWithFrame:CGRectMake(10, 0, kFullScreenWidth - 20, kFullScreenWidth - 20) titles:self.model.titles rates:self.model.rates colors:colors];
    [self.turnTableView setFoodBlock:^(NSString * _Nonnull title, int index) {
        LENLog(@"title = %@ index = %i", title, index);
    }];
    [self.contentView addSubview:self.turnTableView];
}

# pragma mark -- 转动
- (IBAction)run:(id)sender {
    [self.turnTableView startCycle];
}

# pragma mark -- 编辑
- (void)edit{
    LENAddTurnTableViewController *vc = [LENAddTurnTableViewController new];
    vc.isNew = NO;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark -- reopen
- (void)reopen:(NSNotification *)notification{
    self.model = (LENTurnTableModel *)notification.object;
    [self.turnTableView removeFromSuperview];
    self.turnTableView = nil;
    NSMutableArray *colors = [LENHandle getColorsFormTurnTableModel:self.model];
    self.turnTableView = [[LENTurnTableView alloc] initWithFrame:CGRectMake(10, 0, kFullScreenWidth - 20, kFullScreenWidth) titles:self.model.titles rates:self.model.rates colors:colors];
    [self.turnTableView setFoodBlock:^(NSString * _Nonnull title, int index) {
        LENLog(@"title = %@ index = %i", title, index);
    }];
    [self.contentView addSubview:self.turnTableView];
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
