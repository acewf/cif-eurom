//
//  RenderClassificacaoTableViewController.m
//  Cif
//
//  Created by Pedro Martins on 27/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import "RenderClassificacaoTableViewController.h"
#import "AppListOfGames.h"
#import "ResultBoard.h"
#import "TeamData.h"

@interface RenderClassificacaoTableViewController ()

@end

@implementation RenderClassificacaoTableViewController
AppListOfGames * me;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@" view did load Largura view: %f",self.view.frame.size.width);
    
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PTSans-Regular" size:20],NSFontAttributeName,[UIColor colorWithRed:57/255.0 green:189/255.0 blue:232/255.0 alpha:1],NSForegroundColorAttributeName, nil]];
    
    
    
    NSString * TitlePage = [NSString stringWithFormat:@"%@", @"Classificação"];
    self.navigationbaritem.title = TitlePage;
    
    
    me = [AppListOfGames sharedInstance];
    
    if ([self.listResults count]==0) {
        self.listResults = me.listOfRankingTeams;
    }
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ResultBoard" object:nil queue:mainQueue
                                                  usingBlock:^(NSNotification *notification)
     {
         [self renderTableList];
     }];
    [self renderTableList];
}

-(void)renderTableList{
    self.listResults = me.listOfRankingTeams;
    [self.tableResultBoard reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.listResults count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TeamData *team = self.listResults[[self.listResults count]-1];
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
    
    //NSLog(@"section %d",section);
    /*
     if(){
     }
     */
    //return the view for the footer
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ResultCell";
    ResultBoard *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TeamData *team = self.listResults[indexPath.row];
    if (cell == nil) {
        cell = [[ResultBoard alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.lastupdate.alpha = 0;
    cell.teamName.text =  team.teamName;
    cell.teamTotalGames.text =  [NSString stringWithFormat:@"%ld", (long)team.played];
    cell.teamPoints.text = [NSString stringWithFormat:@"%ld", (long)team.points];
    cell.teamWins.text = [NSString stringWithFormat:@"%ld", (long)team.wins];
    cell.teamPosition.text = [NSString stringWithFormat:@"%ld", (long)team.position];
    cell.teamDraws.text = [NSString stringWithFormat:@"%ld", (long)team.draws];
    cell.teamLoses.text = [NSString stringWithFormat:@"%ld", (long)team.loses];
    
    return cell;
}
@end
