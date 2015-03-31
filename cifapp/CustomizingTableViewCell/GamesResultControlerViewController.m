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


@interface GamesResultControlerViewController ()

@property(strong,nonatomic)NSArray * menuOptions;

@end


@implementation GamesResultControlerViewController
@synthesize menuOptions;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Recipe Book";
    
    self.navigationItem.title = @"A custom title";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@" TABLE VIEW DID LOAD");
    
    CGRect pickerGoSmall = CGRectMake(0,0,self.view.frame.size.width,80);
    CGRect goBig = CGRectMake(0,80,self.view.frame.size.width,392);
    [UITableView animateWithDuration:1.0  animations:^{ self.tableGames.frame = goBig; }];
    [UIView animateWithDuration:1.0  animations:^{ self.pickerview.frame = pickerGoSmall; }];
    
    AppListOfGames * me = [AppListOfGames sharedInstance];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"notificationName" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         self.listGames = me.listOfGames;
         [self.tableGames reloadData];
         // ...
     }];
    
    self.jornyePickerOpen = false;
    
    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [gestureRecognizer setEnabled:YES];
    [gestureRecognizer setCancelsTouchesInView:NO];
    [gestureRecognizer setDelaysTouchesBegan:NO];
    [gestureRecognizer setDelaysTouchesEnded:NO];
    [gestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:gestureRecognizer];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    CGRect pickerGoBig = CGRectMake(0,0,self.view.frame.size.width,160);
    CGRect goSmall = CGRectMake(0,160,self.view.frame.size.width,300);
    
    CGRect pickerGoSmall = CGRectMake(0,0,self.view.frame.size.width,80);
    CGRect goBig = CGRectMake(0,80,self.view.frame.size.width,392);
    
    
    if (self.jornyePickerOpen==false && [touch locationInView:self.view].y<120) {
        self.jornyePickerOpen=true;
        [UITableView animateWithDuration:1.0  animations:^{ self.tableGames.frame = goSmall; }];
        [UIView animateWithDuration:1.0  animations:^{ self.pickerview.frame = pickerGoBig; }];
    } else if (self.jornyePickerOpen==true && [touch locationInView:self.view].y>180) {
        [UITableView animateWithDuration:1.0  animations:^{ self.tableGames.frame = goBig; }];
        [UIView animateWithDuration:1.0  animations:^{ self.pickerview.frame = pickerGoSmall; }];
        self.jornyePickerOpen=false;
    }
    return YES;
}



- (IBAction)tooglejornada:(id)sender {
}
@end