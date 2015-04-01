//
//  PlayerData.h
//  Cif
//
//  Created by Rodrigo Amado on 01/04/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerData : NSObject

@property (nonatomic, copy) NSString *playerName;
@property (assign) NSInteger playerID;
@property (assign) NSInteger goals;
@property (assign) NSInteger teamID;
@property (nonatomic, copy) NSString *lastUpdated;

@end
