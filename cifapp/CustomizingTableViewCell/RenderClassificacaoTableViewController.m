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
         NSLog(@" RENDER CLASSIFICA %lu",(unsigned long)[me.listOfRankingTeams count]);
         self.listResults = me.listOfRankingTeams;
         
         NSString * TitlePage = [NSString stringWithFormat:@"%@", @"classificação"];
         self.navigationbaritem.title = TitlePage;
         
         [self.tableResultBoard reloadData];
         // ...
     }];
    
    
    
    //////////////////////////////////////////////////
    // APPLISTOFGAMES --> /Model/factory/ResultsBoard //
    /////////////////////////////////////////////////
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{

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
    ResultBoard *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    TeamData *team = self.listResults[indexPath.row];
    
    cell.teamName.text =  team.teamName;
    cell.teamTotalGames.text =  [NSString stringWithFormat:@"%ld", team.played];
    cell.teamPoints.text = [NSString stringWithFormat:@"%ld", team.points];
    cell.teamWins.text = [NSString stringWithFormat:@"%ld", team.wins];
    cell.teamPosition.text = [NSString stringWithFormat:@"%ld", team.position];
    cell.teamDraws.text = [NSString stringWithFormat:@"%ld", team.draws];
    cell.teamLoses.text = [NSString stringWithFormat:@"%ld", team.loses];
    // Configure the cell...
    
    return cell;
}
@end
