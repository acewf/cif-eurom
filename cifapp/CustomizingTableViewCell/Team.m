//
//  Movie.m
//  CustomizingTableViewCell
//
//  Created by Arthur Knopper on 1/2/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import "Team.h"

@implementation Team

@synthesize goals = _goals;  //Must do this


//Setter method
- (void) setGoals:(int)n {
    /*
    if (n<0) {
        n=0;
    }
    */
    _goals = n;
}
//Getter method
- (NSInteger) goals {
    return _goals;
}
@end
