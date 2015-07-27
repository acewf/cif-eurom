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
        [sharedInstance initReachability];
    });
    
    
    return sharedInstance;
}
-(void)updateAllData{
    if([self.googleReach isReachable]){
        [self initWebServices];
    } else{
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Sem Rede"
                                message:@"Para actualizar, verifique a sua ligação a internet"
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil,nil];
        [myAlert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWorkStatus" object:self.googleReach];
    }
}

-(void)initWebServices{
    NSLog(@"-INIT WEB SERVICES-");
    [self getJorney];
    [self getfixtures];//:@"21"
    [self getPlayersRanking];
    [self getRanking];
    [self getCupfixtures];
}

-(void)initWithoutWebServices{
    NSLog(@"Start without net");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataFixtures = [userDefaults objectForKey:@"data_fixtures"];
    NSData *data_cup_fixtures = [userDefaults objectForKey:@"data_cup_fixtures"];
    NSData *data_player_ranking = [userDefaults objectForKey:@"data_player_ranking"];
    NSData *data_ranking = [userDefaults objectForKey:@"data_ranking"];
    
    if (dataFixtures!=Nil) {
        [self processFixturesAll:dataFixtures];
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
        if(![self.googleReach isReachable]){
            [self alertme:@"Verifique a sua ligação"];
        }
    }
}

-(void)alertme:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MESSAGE" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
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
    
    
    self.googleReach.reachableBlock = ^(Reachability * reachability)
    {
        // to update UI components from a block callback
        // you need to dipatch this to the main thread
        // this uses NSOperationQueue mainQueue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            ///// DO SOMETHING
            //NSString * temp = [NSString stringWithFormat:@"InternetConnection A1_R2 operationBlock reachable(%@)", reachability.currentReachabilityString];
            NSLog(@"faz pedido a net, depois de receber informacao que existe net disponivel");
            //[pointer initWebServices];
        }];
    };
    
    self.googleReach.unreachableBlock = ^(Reachability * reachability)
    {
        //[pointer initWithoutWebServices];
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
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
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            //NSString * temp = [NSString stringWithFormat:@"LocalWIFI A3_R2 operationBlock reachable(%@)", reachability.currentReachabilityString];
            //[pointer initWebServices];
        });
    };
    
    self.localWiFiReach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            //NSString * temp = [NSString stringWithFormat:@"LocalWIFI A4_R2 operationBlock unreachable(%@)", reachability.currentReachabilityString];
            //[pointer alertme:temp];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            //[pointer initWebServices];
        });
    };
    
    self.internetConnectionReach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //// DO SOMETHING
            //NSString * temp = [NSString stringWithFormat:@"InternetConnection A6_R2 operationBlock unreachable(%@)", reachability.currentReachabilityString];
            //[pointer alertme:temp];
        });
    };
    
    [self.internetConnectionReach startNotifier];
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    reach.reachableOnWWAN = NO;
    
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(reachabilityChanged:)  name:kReachabilityChangedNotification object:nil];
    
    [reach startNotifier];
    
    [pointer initWithoutWebServices];
    NSLog(@"times to run");
    if([self.googleReach isReachable]){
        NSLog(@" is Reacheble inline");
        [pointer initWebServices];
    } else{
        NSLog(@" is unReacheble inline");
        //[pointer initWithoutWebServices];
    }
}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if(reach == self.googleReach)
    {
        if([reach isReachable])
        {
            //NSString * temp = [NSString stringWithFormat:@"GOOGLE Notification Says Reachable(%@)", reach.currentReachabilityString];
            //NSLog(@"%@", temp);
            
        }
        else
        {
            //NSString * temp = [NSString stringWithFormat:@"GOOGLE Notification Says Unreachable(%@)", reach.currentReachabilityString];
            //NSLog(@"%@", temp);
            
        }
    }
    else if (reach == self.localWiFiReach)
    {
        if([reach isReachable])
        {
            //NSString * temp = [NSString stringWithFormat:@"LocalWIFI Notification Says Reachable(%@)", reach.currentReachabilityString];
            //NSLog(@"%@", temp);
        }
        else
        {
            //NSString * temp = [NSString stringWithFormat:@"LocalWIFI Notification Says Unreachable(%@)", reach.currentReachabilityString];
            //NSLog(@"%@", temp);
        }
    }
    else if (reach == self.internetConnectionReach)
    {
        if([reach isReachable])
        {
            //NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Reachable(%@)", reach.currentReachabilityString];
            //NSLog(@"%@", temp);
        }
        else
        {
            //NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Unreachable(%@)", reach.currentReachabilityString];
            //NSLog(@"%@", temp);
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
-(NSMutableArray*)getJorney{
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-cur-schedule&overwrite=17"];
    
    NSString * urlpath = [NSString stringWithFormat:@"%@", @""];
    urlpath = [serv stringByAppendingString:urlpath];
    serv = [NSMutableString stringWithFormat:@"%@", urlpath];
    
    [self callServiceJornayAll:serv];
    
    return self.listOfGames;
}
- (void)callServiceJornayAll:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    //NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://cif.eurom.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSArray *returneddata = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             int * indexjornye = [[[returneddata objectAtIndex:0] valueForKeyPath:@"schedule"] intValue];
             self.jornada = (NSInteger)indexjornye;
             
             NSLog(@"update ## jornada %zd",self.jornada);
             
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setInteger:self.jornada forKey:@"jornada"];
         }else{
             
         };
     }];
    NSInteger * actualJorney = (int)self.jornada-1;
    NSMutableArray * xxjornada = [self.fixturesgroup objectAtIndex:actualJorney];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gamesResult" object:xxjornada];
}


-(NSMutableArray*)getfixtures{
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-fixtures"];
    
    NSString * urlpath = [NSString stringWithFormat:@"%@", @""];
    urlpath = [serv stringByAppendingString:urlpath];
    serv = [NSMutableString stringWithFormat:@"%@", urlpath];
    [self callServiceFixturesAll:serv];
    
    return self.listOfGames;
}
- (void)callServiceFixturesAll:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    //NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://cif.eurom.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             [self processFixturesAll:data];
         }else{
             
         };
     }];
}
-(void)processFixturesAll:(NSData*)data{
    self.fixturesgroup = [[NSMutableArray alloc] init];
    NSDate *currDate = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:currDate];
    NSDate * datetime;
    NSDateComponents *daycompo;
    NSMutableArray * sectionGames = [[NSMutableArray alloc] init];
    self.lisOfDays = [[NSMutableArray alloc] init];
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    NSMutableArray * gamesByJornada = [[NSMutableArray alloc] init];
    
    NSLog(@" ANTES JORNEY --- %zd",self.jornada);
    
    int jornadaActual = 0;//self.jornada;
    
    NSLog(@" jornadaActual --- %zd",jornadaActual);
    
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
        game.played = false;
        
        if ((teamHome.goals<0)) {
            game.played = false;
            if((self.lastGamePlayed==0)){
                self.lastGamePlayed = [[key valueForKeyPath:@"GameJourney"] intValue]-1;
            }
        } else {
            game.played = true;
        }
        /*
        NSLog(@"JORNADA:>>");
        NSLog(@" jornadaActual --- %zd",jornadaActual);
        NSLog(@" Compare --- %zd",[game.jornada intValue]-1);
        */
        if (jornadaActual!=([game.jornada intValue]-1)) {
            jornadaActual   = [game.jornada intValue]-1;
            [gamesByJornada addObject:tempArray];
            tempArray = [[NSMutableArray alloc] init];
        }
        
        if (([components day]!=[daycompo day]) || ([components month]!=[daycompo month])) {
            components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:datetime];
            sectionGames = [[NSMutableArray alloc] init];
            [sectionGames addObject:game];
            [tempArray addObject:sectionGames];
        } else {
            [sectionGames addObject:game];
        }
    }

    [gamesByJornada addObject:tempArray];
    self.fixturesgroup = gamesByJornada;
    
    if (self.jornada==0) {
        self.jornada = self.lastGamePlayed;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.jornada = (NSInteger)[[userDefaults objectForKey:@"jornada"] intValue];
    }
    self.jornadaStr = [NSString stringWithFormat:@"%ld", (long)self.jornada];
    NSInteger * actualJorney = (int)self.jornada-1;
    if ((int)actualJorney<0) {
        actualJorney = 1;
    }
    NSLog(@" ACTUAL JORNEY --- %zd",actualJorney);
    
    NSMutableArray * xxjornada = [gamesByJornada objectAtIndex:actualJorney];
    self.jornadaInfo = xxjornada;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gamesResult" object:xxjornada];
}


/////////////////////////////////////////////////
 ////////////// FIXTURES RETURN /////////////////
/////////////////////////////////////////////////
-(NSMutableArray*)getfixtures:(NSInteger*)jornada{
    /*
    NSMutableString * serv = [NSMutableString stringWithFormat:@"%@", @"get-fixtures"];
    if (jornada) {
        self.jornadaStr = jornada;
        self.jornada = [jornada intValue];
        NSString * urlpath = [NSString stringWithFormat:@"%@%@%@", @"&filter=", jornada, @""];
        urlpath = [serv stringByAppendingString:urlpath];
        serv = [NSMutableString stringWithFormat:@"%@", urlpath];
    }
    [self callServiceFixtures:serv];
    */
    
    NSMutableArray * xxjornada = [self.fixturesgroup objectAtIndex:jornada];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gamesResult" object:xxjornada];
    
    return xxjornada;
}
- (void)callServiceFixtures:(NSMutableString*) service
{
    NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://www.cif.org.pt/endpoint.php?action="];
    //NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://cif.eurom.pt/endpoint.php?action="];
    NSString * urlpath = [path stringByAppendingString:service];
    
    
    NSURL *url = [NSURL URLWithString:urlpath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             [self processFixtures:data];
         }else{
             
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
    //NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://cif.eurom.pt/endpoint.php?action="];
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
        teamHome.penaltis = [[key valueForKeyPath:@"TeamHomeScorePenalties"] intValue];
        
        Team *teamAway = [[Team alloc] init];
        teamAway.teamId = [key valueForKeyPath:@"TeamAwayId"];
        teamAway.teamName = [key valueForKeyPath:@"TeamAwayName"];
        teamAway.goals = [[key valueForKeyPath:@"TeamAwayScore"] intValue];
        teamAway.img = [key valueForKeyPath:@"TeamAwayImage"];
        
        teamAway.penaltis = [[key valueForKeyPath:@"TeamAwayScorePenalties"] intValue];
        
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
    //NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://cif.eurom.pt/endpoint.php?action="];
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
        player.lastupdated = [key valueForKeyPath:@"LastUpdatedSchedule"];
        
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
    //NSMutableString * path = [NSMutableString stringWithFormat:@"%@", @"http://cif.eurom.pt/endpoint.php?action="];
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
        equipa.loses = [[key valueForKeyPath:@"Loses"] intValue];
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
        equipa.lastupdated = [key valueForKeyPath:@"LastUpdatedSchedule"];
        
        
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
    self.listOfTeamsDiscipline = [[NSMutableArray alloc] initWithArray:self.listOfRankingTeams];
    //self.listOfTeamsDiscipline =self.listOfRankingTeams;
    
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"DisciplinePosition" ascending:YES];
    [self.listOfTeamsDiscipline sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    return self.listOfTeamsDiscipline;
}

@end
