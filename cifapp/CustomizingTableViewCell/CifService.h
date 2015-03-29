//
//  CifService.h
//  Cif
//
//  Created by Rodrigo Amado on 27/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CifService : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) NSURLConnection *ligacao;
@property (strong, nonatomic) NSDictionary *dados;

-(void)fetchData:(NSData *)data;
- (NSURLRequest *)RequestTeams;

@end
