//
//  CifService.m
//  Cif
//
//  Created by Rodrigo Amado on 27/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "CifService.h"

#define kEDApiEndPointUrl @"http://www.cif.org.pt/endpoint.php?action="


@implementation CifService

- (id)init:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)fetchData:(NSData *)data{
    self.dados = [[NSDictionary alloc] init];
    
}
#pragma mark - RequestMethods

#pragma mark RequestTeamMethods
- (NSURLRequest *)RequestTeams {
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[kEDApiEndPointUrl stringByAppendingString:@"get-teams"]]];
    [mutableRequest addValue:@"Algum valor" forHTTPHeaderField:@"FBAccessToken"];
    return (NSURLRequest *)mutableRequest;
}


#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    // self.dados = _responseData;
    [self fetchData:_responseData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
