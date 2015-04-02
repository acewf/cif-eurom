//
//  AppListOfGames.m
//  Cif
//
//  Created by Pedro Martins on 26/03/15.
//  Copyright (c) 2015 pixekkiller.net. All rights reserved.
//

#import "AppListOfGames.h"
#import "Team.h"
#import "TeamData.h"
#import "Game.h"
#import "PlayerData.h"


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
/////////////////////////////////////////////////
 ////////////// FIXTURES RETURN /////////////////
/////////////////////////////////////////////////
-(NSMutableArray*)getfixtures:(NSString*)jornada{
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-fixtures"];
    
    if (jornada) {
        self.jornadaStr = jornada;
        self.jornada = [jornada intValue];
        NSString * urlpath = [NSString stringWithFormat:@"%@%@%@", @"&filter=", jornada, @""];
        urlpath = [serv stringByAppendingString:urlpath];
        serv = [NSMutableString stringWithFormat:@"%@", urlpath];
    }
    [self callServiceFixtures:serv];
    
    
    return self.listOfGames;
}
- (void)callServiceFixtures:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDate *currDate = [NSDate date];
             NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:currDate];
             NSDate * datetime;
             NSDateComponents *daycompo;
             NSMutableArray * sectionGames = [[NSMutableArray alloc] init];
             self.lisOfDays = [[NSMutableArray alloc] init];
             
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
                 datetime = [dateFormatter dateFromString:[key valueForKeyPath:@"GameStartAt"]];
                 daycompo = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:datetime];
                 
                 [dateFormatter setDateFormat:@"HH:mm"];
                 game.team1Info = teamHome;
                 game.team2Info = teamAway;
                 game.time = [dateFormatter stringFromDate:datetime];
                 game.day = datetime;
                 game.jornada = [key valueForKeyPath:@"GameJourney"];
                 game.id = [key valueForKeyPath:@"GameId"];
                 
                 if (([components day]!=[daycompo day]) || ([components month]!=[daycompo month])) {
                     components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:datetime];
                     sectionGames = [[NSMutableArray alloc] init];
                     [sectionGames addObject:game];
                     [self.lisOfDays addObject:sectionGames];
                 } else {
                     [sectionGames addObject:game];
                 }
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gamesResult" object:self.listOfGames];
         }else{
             NSLog(@"error");
         };
     }];
}


/////////////////////////////////////////////////
////////////// listOfCupGames RETURN ////////////
/////////////////////////////////////////////////
-(NSMutableArray*)getCupfixtures{
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-fixtures-cup"];
    [self callServiceCupFixtures:serv];
    
    
    return self.listOfCupGames;
}
- (void)callServiceCupFixtures:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDate * datetime;
             NSDateComponents *daycompo;
             NSMutableArray * sectionGames = [[NSMutableArray alloc] init];
             self.listOfCupGames = [[NSMutableArray alloc] init];
             
             NSArray *returneddata = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSInteger * compareRound = 0;
             
             
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
                 datetime = [dateFormatter dateFromString:[key valueForKeyPath:@"GameStartAt"]];
                 daycompo = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:datetime];
                 
                 [dateFormatter setDateFormat:@"HH:mm"];
                 game.team1Info = teamHome;
                 game.team2Info = teamAway;
                 game.time = [dateFormatter stringFromDate:datetime];
                 game.day = datetime;
                 game.jornada = [key valueForKeyPath:@"GameJourney"];
                 game.id = [key valueForKeyPath:@"GameId"];
                 game.eliminatoria = [key valueForKeyPath:@"CupRoundTitle"];
                 game.round = [[key valueForKeyPath:@"CupRoundId"] intValue];
                 
                 if (compareRound!=game.round) {
                     compareRound = game.round;
                     sectionGames = [[NSMutableArray alloc] init];
                     [sectionGames addObject:game];
                     [self.listOfCupGames addObject:sectionGames];
                 } else {
                     [sectionGames addObject:game];
                 }
             }
             //NSSortDescriptor* sortByRound = [NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES];
             //[self.listOfCupGames  sortUsingDescriptors:[NSArray arrayWithObject:sortByRound]];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gamesCupResult" object:self.listOfCupGames];
         }else{
             NSLog(@"error");
         };
     }];
}



/////////////////////////////////////////////////
////////////// TEAM RANKING RETURN //////////////
/////////////////////////////////////////////////

- (NSMutableArray*)getPlayersRanking
{
    self.listOfRankingPlayers = [[NSMutableArray alloc] init];
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-players"];
    [self callServicePlayersRanking:serv];
    return self.listOfRankingPlayers;
}

- (void)callServicePlayersRanking:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             self.listOfRankingPlayers = [[NSMutableArray alloc] init];
             
             NSArray *returneddata = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             
             for (NSDictionary* key in returneddata) {
                 PlayerData * player = [[PlayerData alloc] init];
                 
                 player.playerName = [key valueForKeyPath:@"PlayerName"];
                 player.goals = [[key valueForKeyPath:@"Goals"] intValue];
                 player.teamID = [[key valueForKeyPath:@"TeamId"] intValue];
                 player.playerID = [[key valueForKeyPath:@"PlayerId"] intValue];
                 
                 [self.listOfRankingPlayers addObject:player];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"RankingPlayersBoard" object:self.listOfRankingPlayers];
         }else{
             NSLog(@"error");
         };
     }];
}

/////////////////////////////////////////////////
////////////// TEAM RANKING RETURN //////////////
/////////////////////////////////////////////////

- (void)callServiceRanking:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@" valor %lu",(unsigned long)data.length);
         if (data.length > 0 && connectionError == nil)
         {
            self.listOfRankingTeams = [[NSMutableArray alloc] init];
             
            NSArray *returneddata = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             
            for (NSDictionary* key in returneddata) {
                TeamData * equipa = [[TeamData alloc] init];
                
                equipa.teamName = [key valueForKeyPath:@"TeamTitle"];
                equipa.position = [[key valueForKeyPath:@"Position"] intValue];
                equipa.played = [[key valueForKeyPath:@"Played"] intValue];
                equipa.wins = [[key valueForKeyPath:@"Wins"] intValue];
                equipa.draws = [[key valueForKeyPath:@"Draws"] intValue];
                equipa.Loses = [[key valueForKeyPath:@"Loses"] intValue];
                equipa.GoalsFor = [[key valueForKeyPath:@"GoalsFor"] intValue];
                equipa.points = [[key valueForKeyPath:@"Points"] intValue];
                
                /////////////////////////////////////////////////////////
                equipa.id = [[key valueForKeyPath:@"TeamId"] intValue];
                equipa.GoalsDiff = [[key valueForKeyPath:@"GoalsDiff"] intValue];
                equipa.GoalsAgainst = [[key valueForKeyPath:@"GoalsAgainst"] intValue];
                equipa.red = [[key valueForKeyPath:@"DisciplineRed"] intValue];
                equipa.yellow = [[key valueForKeyPath:@"DisciplineYellow"] intValue];
                equipa.DisciplinePosition = [[key valueForKeyPath:@"DisciplinePosition"] intValue];
                equipa.DisciplinePoints = [[key valueForKeyPath:@"DisciplinePoints"] intValue];
                equipa.DisciplinePenaltyPoints = [[key valueForKeyPath:@"DisciplinePenaltyPoints"] intValue];
                equipa.DisciplineSuspensions = [[key valueForKeyPath:@"DisciplineSuspensions"] intValue];
                equipa.DisciplinePenalties = [[key valueForKeyPath:@"DisciplinePenalties"] intValue];
                
                
                [self.listOfRankingTeams addObject:equipa];
            }
             NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
             [self.listOfRankingTeams sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
             
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultBoard" object:self.listOfRankingTeams];
         }else{
             NSLog(@"error");
         };
     }];
}
- (NSMutableArray*)getRanking
{
    self.listOfRankingTeams = [[NSMutableArray alloc] init];
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-teams"];
    [self callServiceRanking:serv];
    return self.listOfRankingTeams;
}
////////////////////////
- (NSMutableArray*)callServiceDisciplina{
    self.listOfTeamsDiscipline = [[NSMutableArray alloc] init];
    
    self.listOfTeamsDiscipline =self.listOfRankingTeams;
    
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"DisciplinePosition" ascending:YES];
    [self.listOfTeamsDiscipline sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    
    
    return self.listOfTeamsDiscipline;
}

@end
