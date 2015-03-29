//
//  ResultsListData.m
//  Cif
//
//  Created by Pedro Martins on 27/03/15.
//  Copyright (c) 2015 pixekkiller.net . All rights reserved.
//

#import "ResultsListData.h"
#import "TeamData.h"

@implementation ResultsListData

-(NSMutableArray*)getResults
{
    self.listOfResults = [[NSMutableArray alloc] init];
    
    TeamData * teamInfo = [[TeamData alloc] init];
    teamInfo.position = 1;
    teamInfo.wins = 10;
    teamInfo.loses = 2;
    teamInfo.draws = 2;
    teamInfo.points = 32;
    teamInfo.GoalsFor = 0;
    
    return self.listOfResults;
}

@end
