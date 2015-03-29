//
//  AppListOfGames.h
//  Cif
//
//  Created by Rodrigo Amado on 26/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppListOfGames : NSObject

@property (nonatomic,strong) NSMutableArray *listOfGames;

-(NSMutableArray*)getGames;

@end
