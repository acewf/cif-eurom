//
//  EDRequest.h
//  Apprtist
//
//  Created by Afonso Neto on 6/25/13.
//  Copyright (c) 2013 EDIT_TrabalhoGrupo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPRequest : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) NSURLConnection *ligacao;
@property (strong, nonatomic) NSDictionary *dados;

-(void)fetchData:(NSData *)data;
- (NSURLRequest *)GameFixtures;
- (NSURLRequest *)GetPlayers;
- (NSURLRequest *)GetTeams;
- (NSURLRequest *)GetCupFixtures;

@end
