//
//  AppListOfGames.h
//  Cif
//
//  Created by Pedro Martins on 26/03/15.
//  Copyright (c) 2015 pixelkiller.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppListOfGames : NSObject

@property (nonatomic,strong) NSMutableArray *lisOfDays;
@property (nonatomic,strong) NSMutableArray *listOfGames;
@property (nonatomic,strong) NSMutableArray *listOfRankingTeams;
@property (nonatomic,strong) NSMutableArray *listOfRankingPlayers;
@property (nonatomic,strong) NSMutableArray *listOfTeams;
@property (nonatomic, copy) NSString *output;
@property (nonatomic, copy) NSString *jornadaStr;
@property (atomic) NSInteger *jornada;

+ (AppListOfGames *)sharedInstance;


- (void)callServicePlayersRanking:(NSMutableString*) service;
- (void)callServiceRanking:(NSMutableString*) service;
- (void)callServiceFixtures:(NSMutableString*) service;
-(NSMutableArray*)getPlayersRanking;
-(NSMutableArray*)getRanking;
-(NSMutableArray*)getfixtures:(NSString*)jornada;

@end
