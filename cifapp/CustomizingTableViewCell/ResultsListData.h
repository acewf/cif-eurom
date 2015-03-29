//
//  ResultsListData.h
//  Cif
//
//  Created by Rodrigo Amado on 27/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsListData : NSObject

@property (nonatomic,strong) NSMutableArray *listOfResults;
-(NSMutableArray*)getResults;

@end
