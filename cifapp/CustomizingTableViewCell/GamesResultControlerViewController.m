//
//  GamesResultControlerViewController.m
//  Cif
//
//  Created by Rodrigo Amado on 30/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GamesResultControlerViewController.h"
#import "Team.h"
#import "Game.h"
#import "GameCell.h"
#import "AppListOfGames.h"
#import "JorneyItem.h"
#import "PreloadedImgs.h"



@interface GamesResultControlerViewController ()

@property(strong,nonatomic)NSArray * menuOptions;

@end


@implementation GamesResultControlerViewController
UICollectionViewCell *Markedcell;
NSInteger *  indexCell;
NSInteger *  MarkedIndexCell;
@synthesize menuOptions;
AppListOfGames * me;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@" games result view loaded ");
    
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1]];
    
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
    
    MarkedIndexCell = -1;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PTSans-Regular" size:20],NSFontAttributeName,[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1],NSForegroundColorAttributeName, nil]];
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"Jornada"];
    self.navigationbaritem.title = TitlePage;
    
    me = [AppListOfGames sharedInstance];
    indexCell = me.jornada;
        
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"gamesResult" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         [self renderTableList];
     }];
    
    [self renderTableList];
    
    self.jornyePickerOpen = false;
    
    self.jorneySelector.delegate = self;
    self.jorneySelector.dataSource = self;
    
    self.listaData = [[NSMutableArray alloc] init];
    
    [self.listaData addObject:@"1"];
    [self.listaData addObject:@"2"];
    [self.listaData addObject:@"3"];
    [self.listaData addObject:@"4"];
    [self.listaData addObject:@"5"];
    [self.listaData addObject:@"6"];
    [self.listaData addObject:@"7"];
    [self.listaData addObject:@"8"];
    [self.listaData addObject:@"9"];
    [self.listaData addObject:@"10"];
    [self.listaData addObject:@"11"];
    [self.listaData addObject:@"12"];
    [self.listaData addObject:@"13"];
    [self.listaData addObject:@"14"];
    [self.listaData addObject:@"15"];
    [self.listaData addObject:@"16"];
    [self.listaData addObject:@"17"];
    [self.listaData addObject:@"18"];
    [self.listaData addObject:@"19"];
    [self.listaData addObject:@"20"];
    [self.listaData addObject:@"21"];
    [self.listaData addObject:@"22"];
    [self.listaData addObject:@"23"];
    [self.listaData addObject:@"24"];
    [self.listaData addObject:@"25"];
    [self.listaData addObject:@"26"];
    [self.listaData addObject:@"27"];
    [self.listaData addObject:@"28"];
    [self.listaData addObject:@"29"];
    [self.listaData addObject:@"30"];
    
}

-(void)renderTableList{
    self.listGames = me.listOfGames;
    self.daysList = me.lisOfDays;
    
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
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@ %@", @"Jornada", me.jornadaStr];
    self.navigationbaritem.title = TitlePage;
    [self.tableGames reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 00, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    NSMutableArray * item = [self.daysList objectAtIndex:section];
    Game * game = [item objectAtIndex:0];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:game.day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM yyyy"];
    
    NSString * sectionTitle = [NSString stringWithFormat:@"%@ %@", [self.weekDays objectAtIndex:[components weekday]], [formatter stringFromDate:game.day]];
    
    label.frame = CGRectMake(0,17,view.frame.size.width,40);
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    NSString *string =sectionTitle;
    /* Section header is in 0th index... */
    
    UIColor *color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [label setTextColor:color];
    label.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.95]]; //your background color...
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameCell";
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray * item = [self.daysList objectAtIndex:indexPath.section];
    NSMutableArray * imgBase = [self.imgsData objectAtIndex:indexPath.section];
    
    PreloadedImgs * baseInfo = imgBase[indexPath.row];
    
    Game *game = item[indexPath.row];
    Team * team1 = game.team1Info;
    Team * team2 = game.team2Info;
    
    cell.team1.text = team1.teamName;
    
    NSString * valueGoals = [NSString stringWithFormat:@"%ld", (long)team1.goals];
    if (team1.goals<0) {
        valueGoals = [NSString stringWithFormat:@"-"];
    }
    cell.goalsteam1.text = valueGoals;
    cell.imgteam1.image = baseInfo.team1;
    cell.team2.text = team2.teamName;
    valueGoals = [NSString stringWithFormat:@"%ld", (long)team2.goals];
    if (team2.goals<0) {
        valueGoals = [NSString stringWithFormat:@"-"];
    }
    cell.goalsteam2.text = valueGoals;
    cell.imgteam2.image = baseInfo.team2;
    cell.schedule.text = game.time;
    
    return cell;
}


#pragma mark - Table view delegate

-(void)closeCollectionView:(id)sender{
    
    CGRect pickerGoSmall = CGRectMake(0,0,self.view.frame.size.width,0);
    CGRect goBig = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    
    [UITableView animateWithDuration:.5  animations:^{ self.tableGames.frame = goBig; }];
    [UIView animateWithDuration:.5  animations:^{ self.jorneySelector.frame = pickerGoSmall; }];
    self.jornyePickerOpen=false;
    //self.openjorney.title = @"open";
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MarkedIndexCell = indexPath.row;
    static NSString *identifier = @"JorneyIdentify";
    JorneyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.numerojornada.layer setCornerRadius:cell.frame.size.width/2];
    [cell.numerojornada.layer setMasksToBounds:YES];
    [cell.numerojornada.layer setBorderWidth:1.0f];
    [cell.numerojornada.layer setBorderColor:[[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1] CGColor]];
    
    Markedcell = cell;
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(closeCollectionView:) userInfo:nil repeats:NO];
    [me getfixtures:[self.listaData objectAtIndex:indexPath.row]];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"JorneyIdentify";
    JorneyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.numerojornada.textColor = [UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1];
    //cell.backgroundView.frame.size.width = 80f;
    [cell.numerojornada.layer setCornerRadius:0.0f];
    [cell.numerojornada.layer setMasksToBounds:NO];
    [cell.numerojornada.layer setBorderWidth:0.0f];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.listaData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"JorneyIdentify";
    JorneyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.numerojornada.text = [NSString stringWithFormat:@"%@ ",[self.listaData objectAtIndex:indexPath.row]];
    cell.numerojornada.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    cell.numerojornada.textColor = [UIColor blackColor];
    
    [cell.numerojornada.layer setCornerRadius:0.0f];
    [cell.numerojornada.layer setMasksToBounds:YES];
    [cell.numerojornada.layer setBorderWidth:0.0f];

    
    if ((int)indexCell==((int)indexPath.row+1)) {
        cell.numerojornada.textColor = [UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1];
    }
    if ((int)MarkedIndexCell==((int)indexPath.row)) {
        //cell.numerojornada.textColor = [UIColor blackColor];
        [cell.numerojornada.layer setCornerRadius:cell.numerojornada.frame.size.width/2];
        [cell.numerojornada.layer setMasksToBounds:YES];
        [cell.numerojornada.layer setBorderWidth:1.0f];
        [cell.numerojornada.layer setBorderColor:[[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1] CGColor]];
    }
    
    return cell;
}

#pragma mark - UI HANDLER
-(void)jorneyPushed{
    NSLog(@"Jorney Pushed");
}

- (IBAction)tooglejornada:(id)sender {
    CGRect pickerGoBig = CGRectMake(0,0,self.view.frame.size.width,150);
    CGRect goSmall = CGRectMake(0,150,self.view.frame.size.width,self.view.frame.size.height-150);
    
    CGRect goBig = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    
    if (self.jornyePickerOpen) {
        [UITableView animateWithDuration:0.5  animations:^{ self.tableGames.frame = goBig; }];
        self.jornyePickerOpen=false;
    } else {
        self.jornyePickerOpen=true;
        [UITableView animateWithDuration:0.5  animations:^{ self.tableGames.frame = goSmall; }];
        [UIView animateWithDuration:0.5  animations:^{ self.jorneySelector.frame = pickerGoBig; }];
    }
}
@end