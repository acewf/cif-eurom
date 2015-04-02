//
//  GamesResultControlerViewController.m
//  Cif
//
//  Created by Rodrigo Amado on 30/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "GamesResultTaca.h"
#import "Team.h"
#import "Game.h"
#import "GameCell.h"
#import "AppListOfGames.h"
#import "JorneyItem.h"


@interface GamesResultTaca ()

@property(strong,nonatomic)NSArray * menuOptions;

@end


@implementation GamesResultTaca
@synthesize menuOptions;
AppListOfGames * me;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.weekDays = [[NSMutableArray alloc] init];
    [self.weekDays addObject:@"null"];
    [self.weekDays addObject:@"domingo"];
    [self.weekDays addObject:@"segunda-feira"];
    [self.weekDays addObject:@"terça-feira"];
    [self.weekDays addObject:@"quarta-feira"];
    [self.weekDays addObject:@"quinta-feira"];
    [self.weekDays addObject:@"sexta-feira"];
    [self.weekDays addObject:@"sábado"];
    
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"taça"];
    self.navigationbaritem.title = TitlePage;    
    
    //[self.UINavigationItem pushNavigationItem:self.navigationItem animated:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    me = [AppListOfGames sharedInstance];
    
    if ([self.listCupGames count]==0) {
        self.daysList = me.listOfCupGames;
    }
    
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"gamesCupResult" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         self.daysList = me.listOfCupGames;
         
         [self.tableGames reloadData];
         // ...
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.daysList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray * item = [self.daysList objectAtIndex:section];
    return [item count];
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSMutableArray * item = [self.daysList objectAtIndex:section];
    Game * game = [item objectAtIndex:0];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:game.day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d-MMM-yyyy"];
    
    NSString * sectionTitle = [NSString stringWithFormat:@"%@ %@", [self.weekDays objectAtIndex:[components weekday]], [formatter stringFromDate:game.day]];
    
    return sectionTitle;
}
*/

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    
    NSMutableArray * item = [self.daysList objectAtIndex:section];
    Game * game = [item objectAtIndex:0];
    NSString * sectionTitle = [NSString stringWithFormat:@"%@", game.eliminatoria];
    
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.frame = CGRectMake(0,0,view.frame.size.width,40);
    //[label sizeToFit];
    NSString *string =sectionTitle;
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.95]]; //your background color...
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameCell";
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSMutableArray * item = [self.daysList objectAtIndex:indexPath.section];
    
    
    Game *game = item[indexPath.row];
    Team * team1 = game.team1Info;
    Team * team2 = game.team2Info;
    
    NSString * valueGoals = [NSString stringWithFormat:@"%ld", (long)team1.goals];
    if (team1.goals<0) {
        valueGoals = [NSString stringWithFormat:@"-"];
    }
    
    cell.team1.text = team1.teamName;
    cell.goalsteam1.text = valueGoals;
    cell.imgteam1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team1.img]]];
    
    valueGoals = [NSString stringWithFormat:@"%ld", (long)team2.goals];
    if (team2.goals<0) {
        valueGoals = [NSString stringWithFormat:@"-"];
    }
    
    cell.team2.text = team2.teamName;
    cell.goalsteam2.text = valueGoals;
    cell.imgteam2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team2.img]]];
    
    cell.schedule.text = game.time;
    
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