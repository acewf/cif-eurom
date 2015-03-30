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
#import <Parse/Parse.h>


static AppListOfGames *sharedInstance = nil;

@implementation AppListOfGames

// Get the shared instance and create it if necessary.
+ (AppListOfGames *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.listOfGames = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)callService:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    //service

    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSArray *returneddata = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             for (NSDictionary* key in returneddata) {
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"y-MM-dd HH:mm:ss "];
                 [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                 
                 
                 Team *teamHome = [[Team alloc] init];
                 teamHome.teamId = [key valueForKeyPath:@"TeamHomeId"];
                 teamHome.teamName = [key valueForKeyPath:@"TeamHomeName"];
                 teamHome.goals = [[key valueForKeyPath:@"TeamHomeScore"] intValue];
                 teamHome.img = [key valueForKeyPath:@"TeamHomeImage"];
                 
                 Team *teamAway = [[Team alloc] init];
                 teamAway.teamId = [key valueForKeyPath:@"TeamAwayId"];
                 teamAway.teamName = [key valueForKeyPath:@"TeamAwayName"];
                 teamAway.goals = [[key valueForKeyPath:@"TeamAwayScore"] intValue];
                 teamAway.img = [key valueForKeyPath:@"TeamAwayImage"];
                 
                 Game *game = [[Game alloc] init];
                 NSDate * datetime = [dateFormatter dateFromString:[key valueForKeyPath:@"GameStartAt"]];
                 
                 [dateFormatter setDateFormat:@"HH:mm"];
                 game.team1Info = teamHome;
                 game.team2Info = teamAway;
                 game.time = [dateFormatter stringFromDate:datetime];
                 game.jornada = [key valueForKeyPath:@"GameJourney"];
                 game.id = [key valueForKeyPath:@"GameId"];
                 
                 [self.listOfGames addObject:game];
                 // do stuff
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:self.listOfGames];
         }else{
             NSLog(@"error");
         };
     }];
}

- (NSMutableArray*)getTeams
{
    self.listOfTeams = [[NSMutableArray alloc] init];
    
    return self.listOfGames;
}
-(NSMutableArray*)getfixtures:(NSString*)jornada{
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-fixtures"];
    
    NSLog(@" %@ ",jornada);
    if (jornada) {
        NSString * urlpath = [NSString stringWithFormat:@"%@%@%@", @"&filter=", jornada, @""];
        urlpath = [serv stringByAppendingString:urlpath];
        serv = [NSMutableString stringWithFormat:@"%@", urlpath];
    }
    
    NSLog(@" aiiii %@ ",serv);
    
    [self callService:serv];
    
    return self.listOfGames;
}

@end
