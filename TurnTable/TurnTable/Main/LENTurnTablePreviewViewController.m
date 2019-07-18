//
//  LENTurnTablePreviewViewController.m
//  TurnTable
//
//  Created by 林南水 on 2019/7/18.
//  Copyright © 2019 ledon. All rights reserved.
//

#import "LENTurnTablePreviewViewController.h"
#import "LENTurnTableView.h"

@interface LENTurnTablePreviewViewController ()

@property (nonatomic, strong) LENTurnTableView *turnTableView;

@end

@implementation LENTurnTablePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
}

- (void)setUpUI{
    self.title = self.model.name;
    NSMutableArray *colors = [LENHandle getColorsFormTurnTableModel:self.model];
    self.turnTableView = [[LENTurnTableView alloc] initWithFrame:CGRectMake(10, 0, kFullScreenWidth - 20, kFullScreenWidth - 20) titles:self.model.titles rates:self.model.rates colors:colors];
    [self.contentView addSubview:self.turnTableView];
}


- (IBAction)outPreview:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
