//
//  Game.h
//  Cif
//
//  Created by Pedro Martins on 26/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Game : NSObject

@property (strong,nonatomic) Team *team1Info;
@property (strong,nonatomic) Team *team2Info;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *jornada;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSDate * day;
@end
