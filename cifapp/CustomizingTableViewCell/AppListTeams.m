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
    NSLog(@"did run view loaded");
    
    AppListOfGames * me = [AppListOfGames sharedInstance];
    
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"notificationName" object:nil queue:mainQueue
     usingBlock:^(NSNotification *notification)
     {
         
         //NSLog(@"Notification received!");
         //NSUInteger * counter = [me.listOfGames count];
         //NSLog(@"DONE LOADING %zd",counter);
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
    cell.goalsteam1.text = [NSString stringWithFormat:@"%ld", team1.goals];
    cell.imgteam1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team1.img]]];
    
    cell.team2.text = team2.teamName;
    cell.goalsteam2.text = [NSString stringWithFormat:@"%ld", team2.goals];
    cell.imgteam2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team2.img]]];
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:118800];
    //NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //NSLog(@"Date for locale %@: %@",[[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
    cell.schedule.text = game.time;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
