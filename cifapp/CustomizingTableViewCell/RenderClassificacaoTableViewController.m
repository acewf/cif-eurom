//
//  RenderClassificacaoTableViewController.m
//  Cif
//
//  Created by Pedro Martins on 27/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import "RenderClassificacaoTableViewController.h"
#import "AppListOfGames.h"
#import "ResultBoard.h"
#import "TeamData.h"

@interface RenderClassificacaoTableViewController ()

@end

@implementation RenderClassificacaoTableViewController
AppListOfGames * me;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@" view did load Largura view: %f",self.view.frame.size.width);
    
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PTSans-Regular" size:20],NSFontAttributeName,[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1],NSForegroundColorAttributeName, nil]];
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"Classificação"];
    self.navigationbaritem.title = TitlePage;
    
    
    me = [AppListOfGames sharedInstance];
    
    if ([self.listResults count]==0) {
        self.listResults = me.listOfRankingTeams;
    }
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ResultBoard" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         [self renderTableList];
     }];
    [self renderTableList];
}

-(void)renderTableList{
    self.listResults = me.listOfRankingTeams;
    [self.tableResultBoard reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.listResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ResultCell";
    ResultBoard *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TeamData *team = self.listResults[indexPath.row];
    if (cell == nil) {
        cell = [[ResultBoard alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.teamName.text =  team.teamName;
    cell.teamTotalGames.text =  [NSString stringWithFormat:@"%ld", (long)team.played];
    cell.teamPoints.text = [NSString stringWithFormat:@"%ld", (long)team.points];
    cell.teamWins.text = [NSString stringWithFormat:@"%ld", (long)team.wins];
    cell.teamPosition.text = [NSString stringWithFormat:@"%ld", (long)team.position];
    cell.teamDraws.text = [NSString stringWithFormat:@"%ld", (long)team.draws];
    cell.teamLoses.text = [NSString stringWithFormat:@"%ld", (long)team.loses];
    
    return cell;
}
@end
