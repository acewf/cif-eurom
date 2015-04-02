//
//  MoviesViewController.m
//  CustomizingTableViewCell
//
//  Created by Pedro Martins on 1/2/13.
//  Copyright (c) 2013 pixelkiller.net . All rights reserved.
//

#import "AppListTeams.h"
#import "Team.h"
#import "Game.h"
#import "GameCell.h"
#import "AppListOfGames.h"

@interface AppListTeams ()

@end

@implementation AppListTeams


- (void)viewDidLoad
{
    //////////////////////////////////////////////////
    // APPLISTOFGAMES --> /Model/factory/GamesBoard //
    /////////////////////////////////////////////////
    
    AppListOfGames * me = [AppListOfGames sharedInstance];
    
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"notificationName" object:nil queue:mainQueue
     usingBlock:^(NSNotification *notification)
     {
         self.listGames = me.listOfGames;
         //[self.tableView reloadData];
         
         // ...
     }];
    
    NSInteger * total = [me.listOfGames count];
    NSLog(@"APP LIST TEAM View did load %zd",total);
    //self.listGames = [me getfixtures];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@" RUN AppListTeams.m viewWillAppear");
}

-(void)loadData{
    NSLog(@"load data **");
}

// the function specified in the same class where we defined the addObserver
- (void)showMainMenu:(NSNotification *)note {
    NSLog(@"Received Notification - Someone seems to have logged in");
}

- (void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"did run");
    return [self.listGames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameCell";
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Game *game = (self.listGames)[indexPath.row];
    Team * team1 = game.team1Info;
    Team * team2 = game.team2Info;
    
    cell.team1.text = team1.teamName;
    cell.goalsteam1.text = [NSString stringWithFormat:@"%ld", (long)team1.goals];
    cell.imgteam1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team1.img]]];
    
    cell.team2.text = team2.teamName;
    cell.goalsteam2.text = [NSString stringWithFormat:@"%ld", (long)team2.goals];
    cell.imgteam2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team2.img]]];
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:118800];
    //NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //NSLog(@"Date for locale %@: %@",[[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
    cell.schedule.text = game.time;
    
    return cell;
}

@end
