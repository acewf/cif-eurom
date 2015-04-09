//
//  GamesResultControlerViewController.m
//  Cif
//
//  Created by Rodrigo Amado on 30/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "AppTeamDisciplina.h"
#import "AppListOfGames.h"
#import "TeamDisciplina.h"
#import "TeamData.h"


@interface appTeamDisciplina ()

@property(strong,nonatomic)NSArray * menuOptions;

@end

@implementation appTeamDisciplina
@synthesize menuOptions;
AppListOfGames * me;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PTSans-Regular" size:20],NSFontAttributeName,[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1],NSForegroundColorAttributeName, nil]];
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"Taça Disciplina"];
    self.navigationbaritem.title = TitlePage;
    
    me = [AppListOfGames sharedInstance];
    self.listDisciplina = [me callServiceDisciplina];
    
    NSLog(@" Lista disciplina %lu",(unsigned long)[self.listDisciplina count]);
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"RankingPlayersBoard" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
        [self renderTableList];
     }];
    
    [self renderTableList];
}

-(void)renderTableList{
    //self.listDisciplina = me.listOfRankingPlayers;
    [self.tableDisciplina reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listDisciplina count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamDisciplina *cell = [tableView dequeueReusableCellWithIdentifier:@"DisciplinaCell" forIndexPath:indexPath];
    
    
    TeamData *team = self.listDisciplina[indexPath.row];
    
    cell.position.text = [NSString stringWithFormat:@"%ld", (long)team.DisciplinePosition];
    cell.teamName.text = [NSString stringWithFormat:@"%@", team.teamName];
    cell.amarelos.text = [NSString stringWithFormat:@"%ld", (long)team.yellow];
    cell.vermelhos.text = [NSString stringWithFormat:@"%ld", (long)team.red];
    cell.amarelos.text = [NSString stringWithFormat:@"%ld", (long)team.yellow];
    cell.points.text = [NSString stringWithFormat:@"%ld", (long)team.DisciplinePoints];
    
    //cell.position
    //cell.amarelos
    //cell.vermelhos
    //cell.points
    
    //cell.position.text =  player.playerName;
    //cell.teamName.text =  [NSString stringWithFormat:@"%ld", player.goals];
    
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