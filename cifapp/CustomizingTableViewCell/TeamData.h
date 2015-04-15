//
//  TeamData.h
//  Cif
//
//  Created by Rodrigo Amado on 27/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamData : NSObject

@property (assign) NSInteger id;
@property (assign) NSInteger played;
@property (assign) NSInteger position;
@property (assign) NSInteger wins;
@property (assign) NSInteger loses;
@property (assign) NSInteger draws;
@property (assign) NSInteger points;
@property (assign) NSInteger GoalsFor;
@property (assign) NSInteger GoalsDiff;
@property (assign) NSInteger GoalsAgainst;
@property (assign) NSInteger red;
@property (assign) NSInteger yellow;
@property (assign) NSInteger DisciplinePosition;
@property (assign) NSInteger DisciplinePoints;
@property (assign) NSInteger DisciplinePenaltyPoints;
@property (assign) NSInteger DisciplineSuspensions;
@property (assign) NSInteger DisciplinePenalties;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *lastupdated;

@end
