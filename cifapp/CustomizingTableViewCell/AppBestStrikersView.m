//
//  GamesResultControlerViewController.m
//  Cif
//
//  Created by Rodrigo Amado on 30/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "AppBestStrikersView.h"
#import "AppListOfGames.h"
#import "StrikerCell.h"
#import "PlayerData.h"
#import "Team.h"


@interface AppBestStrikers ()

@property(strong,nonatomic)NSArray * menuOptions;

@end

@implementation AppBestStrikers
@synthesize menuOptions;
AppListOfGames * me;
NSMutableDictionary * equipas;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"Melhores Marcadores"];
    self.navigationbaritem.title = TitlePage;
    
    
    //[self.UINavigationItem pushNavigationItem:self.navigationItem animated:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    me = [AppListOfGames sharedInstance];
    
    if ([self.listStrikers count]==0) {
        self.listStrikers = me.listOfRankingPlayers;
    }
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"RankingPlayersBoard" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         self.listStrikers = me.listOfRankingPlayers;
         [self.tableStrikers reloadData];
         // ...
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    equipas = [[NSMutableDictionary alloc] init];
    for (Team*key in me.listOfRankingTeams) {
         NSString * keyValue = [NSString stringWithFormat:@"%ld", (long)key.id];
      [equipas setValue:key.teamName forKey:keyValue];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listStrikers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StrikerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StrikerCell" forIndexPath:indexPath];
    
    PlayerData *player = self.listStrikers[indexPath.row];
    NSString * keyValue = [NSString stringWithFormat:@"%ld", (long)player.teamID];
    cell.playerName.text =  player.playerName;
    cell.playerGoals.text =  [NSString stringWithFormat:@"%ld", (long)player.goals];
    cell.teamName.text =[NSString stringWithFormat:@"%@", [equipas objectForKey:keyValue]];
    cell.playerPosition.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuOptions objectAtIndex:indexPath.row]];
    //UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    NSLog(@" TABLE VIEW DID SELECT INDEX ");
}
@end