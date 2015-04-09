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

-(void)initWebServices{
    [self getfixtures:@"21"];
    [self getPlayersRanking];
    [self getRanking];
    [self getCupfixtures];
}

-(void)initWithoutWebServices{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataFixtures = [userDefaults objectForKey:@"data_fixtures"];
    NSData *data_cup_fixtures = [userDefaults objectForKey:@"data_cup_fixtures"];
    NSData *data_player_ranking = [userDefaults objectForKey:@"data_player_ranking"];
    NSData *data_ranking = [userDefaults objectForKey:@"data_ranking"];
    
    self.jornada = 22;
    self.jornadaStr = @"22";
    if (dataFixtures!=Nil) {
        [self processFixtures:dataFixtures];
    }
    if (data_cup_fixtures!=Nil) {
        [self processCupFixtures:data_cup_fixtures];
    }
    if (data_player_ranking!=Nil) {
        [self processPlayersRanking:data_player_ranking];
    }
    if (data_ranking!=Nil) {
        [self processRanking:data_ranking];
    } else {
        [self alertme:@"NO DATA CACHED"];
    }
}

-(void)alertme:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:message delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)initReachability{
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a Reachability object for www.google.com
    ///
    self.googleReach = [Reachability reachabilityWithHostname:@"www.google.com"];
    AppListOfGames * pointer = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [pointer initWithoutWebServices];
    
    self.googleReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE A1_R1 Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        // to update UI components from a block callback
        // you need to dipatch this to the main thread
        // this uses NSOperationQueue mainQueue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            ///// DO SOMETHING
            NSString * temp = [NSString stringWithFormat:@"InternetConnection A1_R2 operationBlock reachable(%@)", reachability.currentReachabilityString];
            NSLog(@"%@", temp);
            [pointer initWebServices];
        }];
    };
    
    self.googleReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE A2_R1 Block Says Unreachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            NSString * temp = [NSString stringWithFormat:@"InternetConnection A2_R2 operationBlock unreachable(%@)", reachability.currentReachabilityString];
            NSLog(@"%@", temp);
            //[pointer alertme:temp];
        });
    };
    
    [self.googleReach startNotifier];
    
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a reachability for the local WiFi
    
    self.localWiFiReach = [Reachability reachabilityForLocalWiFi];
    
    // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable connectivity
    self.localWiFiReach.reachableOnWWAN = NO;
    
    self.localWiFiReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"LocalWIFI A3_R1 Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            NSString * temp = [NSString stringWithFormat:@"LocalWIFI A3_R2 operationBlock reachable(%@)", reachability.currentReachabilityString];
            NSLog(@"%@", temp);
            
            [pointer initWebServices];
        });
    };
    
    self.localWiFiReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"LocalWIFI A4_R1 Block Says Unreachable(%@)", reachability.currentReachabilityString];
        
        NSLog(@"%@", temp);
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            NSString * temp = [NSString stringWithFormat:@"LocalWIFI A4_R2 operationBlock unreachable(%@)", reachability.currentReachabilityString];
            [pointer alertme:temp];
        });
    };
    
    [self.localWiFiReach startNotifier];
    
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a Reachability object for the internet
    
    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    
    self.internetConnectionReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@" InternetConnection  A5_R1 Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            NSString * temp = [NSString stringWithFormat:@"LocalWIFI A5_R2 operationBlock reachable(%@)", reachability.currentReachabilityString];
            NSLog(@"%@", temp);
            
            //[pointer initWebServices];
        });
    };
    
    self.internetConnectionReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"InternetConnection  A6_R1 Block Says Unreachable(%@)", reachability.currentReachabilityString];
        
        NSLog(@"%@", temp);
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            NSString * temp = [NSString stringWithFormat:@"InternetConnection A6_R2 operationBlock unreachable(%@)", reachability.currentReachabilityString];
            [pointer alertme:temp];
        });
    };
    
    [self.internetConnectionReach startNotifier];
}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    if(reach == self.googleReach)
    {
        if([reach isReachable])
        {
            NSString * temp = [NSString stringWithFormat:@"GOOGLE Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
            
        }
        else
        {
            NSString * temp = [NSString stringWithFormat:@"GOOGLE Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
            
        }
    }
    else if (reach == self.localWiFiReach)
    {
        if([reach isReachable])
        {
            NSString * temp = [NSString stringWithFormat:@"LocalWIFI Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        }
        else
        {
            NSString * temp = [NSString stringWithFormat:@"LocalWIFI Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        }
    }
    else if (reach == self.internetConnectionReach)
    {
        if([reach isReachable])
        {
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        }
        else
        {
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        }
    }
    
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
    
    
    NSLog(@" url %@",urlpath);
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             [self processFixtures:data];
         }else{
             NSLog(@"error callServiceFixtures");
         };
     }];
}
-(void)processFixtures:(NSData*)data{
    NSDate *currDate = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:currDate];
    NSDate * datetime;
    NSDateComponents *daycompo;
    NSMutableArray * sectionGames = [[NSMutableArray alloc] init];
    self.lisOfDays = [[NSMutableArray alloc] init];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:@"data_fixtures"];
    
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
    NSLog(@"GAMES RESULT OBSERVER CALLED");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gamesResult" object:self.lisOfDays];
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
             [self processCupFixtures:data];
         }else{
             NSLog(@"error callServiceCupFixtures");
         };
     }];
}
-(void)processCupFixtures:(NSData*)data{
    NSDate * datetime;
    NSDateComponents *daycompo;
    NSMutableArray * sectionGames = [[NSMutableArray alloc] init];
    self.listOfCupGames = [[NSMutableArray alloc] init];
    
    NSArray *returneddata = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSInteger * compareRound = 0;
    NSDate * Comparedatetime;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:@"data_cup_fixtures"];
    
    
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
        game.firstOfDay = 0;
        
        [dateFormatter setDateFormat:@"y-MM-dd"];
        
        
        if (!([[dateFormatter stringFromDate:datetime] isEqualToString:[dateFormatter stringFromDate:Comparedatetime]])) {
            game.firstOfDay = 1;
        }        
        
        if (compareRound!=game.round) {
            compareRound = game.round;
            
            sectionGames = [[NSMutableArray alloc] init];
            [sectionGames addObject:game];
            [self.listOfCupGames addObject:sectionGames];
        } else {
            [sectionGames addObject:game];
        }
        
        Comparedatetime =datetime;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gamesCupResult" object:self.listOfCupGames];
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
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:data forKey:@"data_player_ranking"];
             
             [self processPlayersRanking:data];
         }else{
             NSLog(@"error callServiceRanking");
         };
     }];
}

-(void)processPlayersRanking:(NSData*)data{
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
         if (data.length > 0 && connectionError == nil)
         {
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:data forKey:@"data_ranking"];
             [self processRanking:data];
         }else{
             NSLog(@"error callServiceRanking");
         };
     }];
}
-(void)processRanking:(NSData*)data{
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
