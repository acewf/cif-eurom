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
#import "PreloadedImgs.h"


@interface GamesResultTaca ()

@property(strong,nonatomic)NSArray * menuOptions;

@end


@implementation GamesResultTaca
@synthesize menuOptions;
AppListOfGames * me;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PTSans-Regular" size:20],NSFontAttributeName,[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1],NSForegroundColorAttributeName, nil]];
    
    
    self.weekDays = [[NSMutableArray alloc] init];
    [self.weekDays addObject:@"null"];
    [self.weekDays addObject:@"domingo"];
    [self.weekDays addObject:@"segunda-feira"];
    [self.weekDays addObject:@"terça-feira"];
    [self.weekDays addObject:@"quarta-feira"];
    [self.weekDays addObject:@"quinta-feira"];
    [self.weekDays addObject:@"sexta-feira"];
    [self.weekDays addObject:@"sábado"];
    
    
    self.MonthNames = [[NSMutableArray alloc] init];
    [self.MonthNames addObject:@"null"];
    [self.MonthNames addObject:@"Janeiro"];
    [self.MonthNames addObject:@"Fevereiro"];
    [self.MonthNames addObject:@"Março"];
    [self.MonthNames addObject:@"Abril"];
    [self.MonthNames addObject:@"Maio"];
    [self.MonthNames addObject:@"Junho"];
    [self.MonthNames addObject:@"Julho"];
    [self.MonthNames addObject:@"Agosto"];
    [self.MonthNames addObject:@"Setembro"];
    [self.MonthNames addObject:@"Outbro"];
    [self.MonthNames addObject:@"Novembro"];
    [self.MonthNames addObject:@"Dezembro"];
    
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"Taça"];
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
         [self renderTableList];
     }];
    
    
    [self renderTableList];
    
}

-(void)renderTableList{
    self.daysList = me.listOfCupGames;
    
    self.imgsData =[[NSMutableArray alloc] init];
    
    for (int i=0; i<[self.daysList count]; i++) {
        NSMutableArray * item = [self.daysList objectAtIndex:i];
        NSMutableArray * valuesInSection = [[NSMutableArray alloc] init];
        for (int inc=0; inc<[item count]; inc++) {
            Game *game = item[inc];
            Team * team1 = game.team1Info;
            Team * team2 = game.team2Info;
            PreloadedImgs * teams = [[PreloadedImgs alloc] init];
            teams.team1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team1.img]]];
            teams.team2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team2.img]]];
            [valuesInSection addObject:teams];
        }
        [self.imgsData addObject:valuesInSection];
    }
    
    
    [self.tableGames reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    
    NSMutableArray * item = [self.daysList objectAtIndex:section];
    Game * game = [item objectAtIndex:0];
    NSString * sectionTitle = [NSString stringWithFormat:@"%@", game.eliminatoria];
    
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.frame = CGRectMake(0,17,view.frame.size.width,40);
    //[label sizeToFit];
    NSString *string = [sectionTitle capitalizedString];
    /* Section header is in 0th index... */
    UIColor *color = [UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1];
    [label setTextColor:color];
    label.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.95]]; //your background color...
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat altura = 70;
    NSMutableArray * item = [self.daysList objectAtIndex:indexPath.section];
    Game *game = item[indexPath.row];
    if ((int)game.firstOfDay==1) {
        altura=140;
    }
    return altura;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameCell";
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSMutableArray * item = [self.daysList objectAtIndex:indexPath.section];
    
    NSMutableArray * imgBase = [self.imgsData objectAtIndex:indexPath.section];
    PreloadedImgs * baseInfo = imgBase[indexPath.row];
    
    
    Game *game = item[indexPath.row];
    Team * team1 = game.team1Info;
    Team * team2 = game.team2Info;
    CGFloat defaultPos = 13;
    if ((int)game.firstOfDay==1) {
        CGFloat altura = 70;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"y-MM-dd"];
        
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:game.day];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d MMM yyyy"];
        
        NSString * sectionTitle = [NSString stringWithFormat:@"%@ %@", [self.weekDays objectAtIndex:[components weekday]], [formatter stringFromDate:game.day]];

        UIColor *color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [cell.daylabel setTextColor:color];
        [cell.daylabel setText:sectionTitle];
        [cell.daylabel setTextAlignment:NSTextAlignmentCenter];
        cell.daylabel.font = [UIFont fontWithName:@"PTSans-Regular" size:15];
        cell.daylabel.alpha = 1;
        
        cell.team1.frame =  CGRectMake(cell.team1.frame.origin.x, defaultPos+altura, cell.team1.frame.size.width, cell.team1.frame.size.height);
        cell.team2.frame =  CGRectMake(cell.team2.frame.origin.x, defaultPos+altura, cell.team2.frame.size.width, cell.team2.frame.size.height);
        cell.goalsteam1.frame =  CGRectMake(cell.goalsteam1.frame.origin.x, defaultPos+1+altura, cell.goalsteam1.frame.size.width, cell.goalsteam1.frame.size.height);
        cell.goalsteam2.frame =  CGRectMake(cell.goalsteam2.frame.origin.x, defaultPos+1+altura, cell.goalsteam2.frame.size.width, cell.goalsteam2.frame.size.height);
        cell.imgteam1.frame =  CGRectMake(cell.imgteam1.frame.origin.x, defaultPos-6+altura, cell.imgteam1.frame.size.width, cell.imgteam1.frame.size.height);
        cell.imgteam2.frame =  CGRectMake(cell.imgteam2.frame.origin.x, defaultPos-6+altura, cell.imgteam2.frame.size.width, cell.imgteam2.frame.size.height);
        cell.schedule.frame =  CGRectMake(cell.schedule.frame.origin.x, defaultPos+altura, cell.schedule.frame.size.width, cell.schedule.frame.size.height);
        cell.vslabel.frame =  CGRectMake(cell.vslabel.frame.origin.x, defaultPos+altura, cell.vslabel.frame.size.width, cell.vslabel.frame.size.height);
        
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 60+altura);
    } else {
        cell.daylabel.alpha = 0;
        cell.team1.frame =  CGRectMake(cell.team1.frame.origin.x, defaultPos, cell.team1.frame.size.width, cell.team1.frame.size.height);
        cell.team2.frame =  CGRectMake(cell.team2.frame.origin.x, defaultPos, cell.team2.frame.size.width, cell.team2.frame.size.height);
        cell.goalsteam1.frame =  CGRectMake(cell.goalsteam1.frame.origin.x, defaultPos+1, cell.goalsteam1.frame.size.width, cell.goalsteam1.frame.size.height);
        cell.goalsteam2.frame =  CGRectMake(cell.goalsteam2.frame.origin.x, defaultPos+1, cell.goalsteam2.frame.size.width, cell.goalsteam2.frame.size.height);
        cell.imgteam1.frame =  CGRectMake(cell.imgteam1.frame.origin.x, defaultPos-6, cell.imgteam1.frame.size.width, cell.imgteam1.frame.size.height);
        cell.imgteam2.frame =  CGRectMake(cell.imgteam2.frame.origin.x, defaultPos-6, cell.imgteam2.frame.size.width, cell.imgteam2.frame.size.height);
        cell.schedule.frame =  CGRectMake(cell.schedule.frame.origin.x, defaultPos, cell.schedule.frame.size.width, cell.schedule.frame.size.height);
        cell.vslabel.frame =  CGRectMake(cell.vslabel.frame.origin.x, defaultPos, cell.vslabel.frame.size.width, cell.vslabel.frame.size.height);
    }
    
    NSString * valueGoals = [NSString stringWithFormat:@"%ld", (long)team1.goals];
    if (team1.goals<0) {
        valueGoals = [NSString stringWithFormat:@"-"];
    }
    
    cell.team1.text = team1.teamName;
    cell.goalsteam1.text = valueGoals;
    cell.imgteam1.image = baseInfo.team1;
    
    valueGoals = [NSString stringWithFormat:@"%ld", (long)team2.goals];
    if (team2.goals<0) {
        valueGoals = [NSString stringWithFormat:@"-"];
    }
    
    cell.team2.text = team2.teamName;
    cell.goalsteam2.text = valueGoals;
    cell.imgteam2.image = baseInfo.team2;
    
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