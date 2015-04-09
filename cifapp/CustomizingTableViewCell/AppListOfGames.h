//
//  AppListOfGames.h
//  Cif
//
//  Created by Pedro Martins on 26/03/15.
//  Copyright (c) 2015 pixelkiller.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface AppListOfGames : NSObject

@property(strong) Reachability * googleReach;
@property(strong) Reachability * localWiFiReach;
@property(strong) Reachability * internetConnectionReach;



@property (nonatomic,strong) NSMutableArray *lisOfDays;
@property (nonatomic,strong) NSMutableArray *listOfGames;
@property (nonatomic,strong) NSMutableArray *listOfCupGames;
@property (nonatomic,strong) NSMutableArray *listOfRankingTeams;
@property (nonatomic,strong) NSMutableArray *listOfRankingPlayers;
@property (nonatomic,strong) NSMutableArray *listOfTeams;
@property (nonatomic,strong) NSMutableArray *listOfTeamsDiscipline;
@property (nonatomic, copy) NSString *output;
@property (nonatomic, copy) NSString *jornadaStr;
@property (atomic) NSInteger *jornada;

+ (AppListOfGames *)sharedInstance;

- (void)callServicePlayersRanking:(NSMutableString*) service;
- (void)callServiceRanking:(NSMutableString*) service;
- (void)callServiceFixtures:(NSMutableString*) service;
- (void)callServiceCupFixtures:(NSMutableString*) service;
-(void)initReachability;

-(NSMutableArray*)callServiceDisciplina;
-(NSMutableArray*)getPlayersRanking;
-(NSMutableArray*)getRanking;
-(NSMutableArray*)getfixtures:(NSString*)jornada;
-(NSMutableArray*)getCupfixtures;

@end
