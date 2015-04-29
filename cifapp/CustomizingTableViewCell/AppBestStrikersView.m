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
    
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PTSans-Regular" size:20],NSFontAttributeName,[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1],NSForegroundColorAttributeName, nil]];
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"Melhores Marcadores"];
    self.navigationbaritem.title = TitlePage;
    me = [AppListOfGames sharedInstance];
    
    if ([self.listStrikers count]==0) {
        self.listStrikers = me.listOfRankingPlayers;
    }
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"RankingPlayersBoard" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         [self renderTableList];
     }];
    
    [self renderTableList];
    
}

-(void)renderTableList{
    self.listStrikers = me.listOfRankingPlayers;
    [self.tableStrikers reloadData];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    PlayerData *team = self.listStrikers[[self.listStrikers count]-1];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    [label setTextAlignment:NSTextAlignmentCenter];
    NSString *string =[NSString stringWithFormat:@"%@",team.lastupdated];
    UIColor *color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [label setTextColor:color];
    label.font = [UIFont fontWithName:@"PTSans-Regular" size:12];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.95]]; //your background color...
    
    //NSLog(@"section %ld",(long)section);
    /*
     if(){
     }
     */
    //return the view for the footer
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StrikerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StrikerCell" forIndexPath:indexPath];
    
    cell.lastupdate.alpha = 0;
    PlayerData *player = self.listStrikers[indexPath.row];
    NSString * keyValue = [NSString stringWithFormat:@"%ld", (long)player.teamID];
    cell.playerName.text =  player.playerName;
    cell.playerGoals.text =  [NSString stringWithFormat:@"%ld", (long)player.goals];
    cell.teamName.text =[NSString stringWithFormat:@"%@", [equipas objectForKey:keyValue]];
    cell.playerPosition.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    
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