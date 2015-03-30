//
//  AppListOfGames.h
//  Cif
//
//  Created by Pedro Martins on 26/03/15.
//  Copyright (c) 2015 pixelkiller.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppListOfGames : NSObject

@property (nonatomic,strong) NSMutableArray *listOfGames;
@property (nonatomic,strong) NSMutableArray *listOfTeams;
@property (nonatomic, copy) NSString *output;

+ (AppListOfGames *)sharedInstance;
- (void)callService:(NSMutableString*) service;
-(NSMutableArray*)getTeams;
-(NSMutableArray*)getfixtures:(NSString*)jornada;

@end
