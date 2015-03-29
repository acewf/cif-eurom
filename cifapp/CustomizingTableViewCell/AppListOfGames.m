//
//  AppListOfGames.m
//  Cif
//
//  Created by Pedro Martins on 26/03/15.
//  Copyright (c) 2015 pixekkiller.net. All rights reserved.
//

#import "AppListOfGames.h"
#import "Team.h"
#import "Game.h"
#import "CifService.h"
#import "Supporting Tasks/EDURLConnectionLoader.h"
#import "json/CJSONDeserializer.h"
#import <Parse/Parse.h>

@implementation AppListOfGames

- (NSMutableArray*)getGames
{
    self.listOfGames = [[NSMutableArray alloc] init];
    
    ///////// GAME 1 ////////
    Team *teamInfo1 = [[Team alloc] init];
    teamInfo1.teamName = @"Purrianos";
    teamInfo1.goals = 1;
    teamInfo1.img = @"http://www.cif.org.pt/Assets/img/decor/logos/256/purrianos.png";
    
    Team *teamInfo2 = [[Team alloc] init];
    teamInfo2.teamName = @"Pé Leve";
    teamInfo2.goals = 2;
    teamInfo2.img = @"http://www.cif.org.pt/Assets/img/decor/logos/256/peleve.png";
    NSString*dateGame = @"10h45";
    /////////////////////////////////////////
    Game *game = [[Game alloc] init];
    game.team1Info = teamInfo1;
    game.team2Info = teamInfo2;
    game.time = dateGame;
    //////////// END ////////////
    [self.listOfGames addObject:game];
    
    ///////// GAME 2 ////////
    teamInfo1 = [[Team alloc] init];
    teamInfo1.teamName = @"Canarinhos";
    teamInfo1.goals = 1;
    teamInfo1.img = @"http://www.cif.org.pt/Assets/img/decor/logos/256/canarinhos.png";
    
    teamInfo2 = [[Team alloc] init];
    teamInfo2.teamName = @"Pé Leve";
    teamInfo2.goals = 2;
    teamInfo2.img = @"http://www.cif.org.pt/Assets/img/decor/logos/256/peleve.png";
    dateGame = @"11h45";
    /////////////////////////////////////////
    game = [[Game alloc] init];
    game.team1Info = teamInfo1;
    game.team2Info = teamInfo2;
    game.time = dateGame;
    //////////// END ////////////
    [self.listOfGames addObject:game];
    
    
    ///////// GAME 3 ////////
    teamInfo1 = [[Team alloc] init];
    teamInfo1.teamName = @"SD 76";
    teamInfo1.goals = 1;
    teamInfo1.img = @"http://www.cif.org.pt/Assets/img/decor/logos/256/sd76.png";
    
    teamInfo2 = [[Team alloc] init];
    teamInfo2.teamName = @"Briosa";
    teamInfo2.goals = 0;
    teamInfo2.img = @"http://www.cif.org.pt/Assets/img/decor/logos/256/briosa.png";
    dateGame = @"11h45";
    /////////////////////////////////////////
    game = [[Game alloc] init];
    game.team1Info = teamInfo1;
    game.team2Info = teamInfo2;
    game.time = dateGame;
    //////////// END ////////////
    [self.listOfGames addObject:game];
    
    CifService *pedido = [[CifService alloc] init];
    EDURLConnectionLoader *loader = [[EDURLConnectionLoader alloc] initWithRequest:[pedido RequestTeams]];
    loader.progressBlock = 0;
    loader.completionBlock = ^(NSError *error, NSData * responseData){
        //CLLocationCoordinate2D coord;
        NSError *jsonParseError = NULL;
        NSDictionary *json = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:&jsonParseError];
        if (!jsonParseError) {
            
        }
        //[self.activityIndicator stopAnimating];
    };

    
    return self.listOfGames;
}


@end
