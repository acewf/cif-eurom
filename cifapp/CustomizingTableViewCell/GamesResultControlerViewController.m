//
//  GamesResultControlerViewController.m
//  Cif
//
//  Created by Rodrigo Amado on 30/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "GamesResultControlerViewController.h"
#import "Team.h"
#import "Game.h"
#import "GameCell.h"
#import "AppListOfGames.h"
#import "JorneyItem.h"


@interface GamesResultControlerViewController ()

@property(strong,nonatomic)NSArray * menuOptions;

@end


@implementation GamesResultControlerViewController
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
    
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"jornada"];
    self.navigationbaritem.title = TitlePage;
    self.openjorney.title = @"open";
    
    
    //[self.UINavigationItem pushNavigationItem:self.navigationItem animated:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    me = [AppListOfGames sharedInstance];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"notificationName" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         self.listGames = me.listOfGames;
         self.daysList = me.lisOfDays;
         
         NSString * TitlePage = [NSString stringWithFormat:@"%@ %@", @"jornada", me.jornadaStr];
         self.navigationbaritem.title = TitlePage;
         self.openjorney.title = @"open";
         
         [self.tableGames reloadData];
         // ...
     }];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSUInteger * counter = [self.listGames count];
    NSLog(@"viewWillAppear %zd",counter);
    NSLog(@" TABLE VIEW DID viewWillAppear");
    
    [self.tableGames reloadData];
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
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:game.day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d-MMM-yyyy"];
    
    NSString * sectionTitle = [NSString stringWithFormat:@"%@ %@", [self.weekDays objectAtIndex:[components weekday]], [formatter stringFromDate:game.day]];
    
    
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string =sectionTitle;
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]]; //your background color...
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
    
    cell.team1.text = team1.teamName;
    cell.goalsteam1.text = [NSString stringWithFormat:@"%ld", team1.goals];
    cell.imgteam1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:team1.img]]];
    
    cell.team2.text = team2.teamName;
    cell.goalsteam2.text = [NSString stringWithFormat:@"%ld", team2.goals];
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


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" COLLECTION VIEW ACTION %@",[self.listaData objectAtIndex:indexPath.row]);
    
    [me getfixtures:[self.listaData objectAtIndex:indexPath.row]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@" %lu",(unsigned long)[self.listaData count]);
    return [self.listaData count];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *identifier = @"JorneyIdentify";
    //JorneyItem *ncell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //NSLog(@" VALOR forItemAtIndexPath: %@",[NSString stringWithFormat:@"%ld", (long)indexPath.row]);
    //ncell.itemBt.titleLabel.text = @"13";// [NSString stringWithFormat:@"%ld", (long)indexPath.row];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"JorneyIdentify";
    JorneyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.numerojornada.text = [NSString stringWithFormat:@" %@ ",[self.listaData objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)jorneyPushed{
    NSLog(@"Jorney Pushed");
}

- (IBAction)tooglejornada:(id)sender {
    CGRect pickerGoBig = CGRectMake(0,0,self.view.frame.size.width,200);
    CGRect goSmall = CGRectMake(0,200,self.view.frame.size.width,self.view.frame.size.height-245);
    
    CGRect pickerGoSmall = CGRectMake(0,0,self.view.frame.size.width,65);
    CGRect goBig = CGRectMake(0,65,self.view.frame.size.width,self.view.frame.size.height-100);
    
    if (self.jornyePickerOpen) {
        [UITableView animateWithDuration:1.0  animations:^{ self.tableGames.frame = goBig; }];
        [UIView animateWithDuration:1.0  animations:^{ self.jorneySelector.frame = pickerGoSmall; }];
        self.jornyePickerOpen=false;
        self.openjorney.title = @"open";
    } else {
        self.jornyePickerOpen=true;
        [UITableView animateWithDuration:1.0  animations:^{ self.tableGames.frame = goSmall; }];
        [UIView animateWithDuration:1.0  animations:^{ self.jorneySelector.frame = pickerGoBig; }];
        self.openjorney.title = @"close";
    }
}
@end