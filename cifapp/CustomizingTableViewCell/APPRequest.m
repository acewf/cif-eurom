//
//  EDRequest.m
//  Apprtist
//
//  Created by Afonso Neto on 6/25/13.
//  Copyright (c) 2013 EDIT_TrabalhoGrupo. All rights reserved.
//

#import "APPRequest.h"

#define kEDApiEndPointUrl @"http://www.cif.org.pt/endpoint.php?action="
#define	kEDContentType_MultipartFormDataKey @"Content-Type"
#define kEDMultipartFormDataBoundary @"WebKitFormBoundaryEG0qL3iLd2XGGv3J"
#define kEDContentType_MultipartFormDataValue @"multipart/form-data; boundary=WebKitFormBoundaryEG0qL3iLd2XGGv3J"

#define kEDWorkPostFixturesKey @"get-fixtures"
#define kEDWorkPostPlayersKey @"get-players"
#define kEDWorkPostTeamsKey @"get-teams"
#define kEDWorkPostCupKey @"get-fixtures-cup"


@implementation APPRequest

- (id)init:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - RequestMethods

#pragma mark RequestAuthorsMethods
- (NSURLRequest *)GameFixtures {
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[kEDApiEndPointUrl stringByAppendingString:kEDWorkPostFixturesKey]]];
    //[mutableRequest addValue:tokenData.accessToken forHTTPHeaderField:@"FBAccessToken"];
    
    return (NSURLRequest *)mutableRequest;
}

- (NSURLRequest *)GetPlayers {
    // NSLog(@"Accesstoken %@", tokenData.accessToken);
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[kEDApiEndPointUrl stringByAppendingString:kEDWorkPostPlayersKey]]];
    //[mutableRequest addValue:tokenData.accessToken forHTTPHeaderField:@"FBAccessToken"];
    //[mutableRequest addValue:authorId forHTTPHeaderField:@"AuthorId"];
    return (NSURLRequest *)mutableRequest;
}
- (NSURLRequest *)GetTeams{
    // NSLog(@"Accesstoken %@", tokenData.accessToken);
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[kEDApiEndPointUrl stringByAppendingString:kEDWorkPostTeamsKey]]];
    //[mutableRequest addValue:tokenData.accessToken forHTTPHeaderField:@"FBAccessToken"];
    //[mutableRequest addValue:authorId forHTTPHeaderField:@"AuthorId"];
    return (NSURLRequest *)mutableRequest;
}

- (NSURLRequest *)GetCupFixtures {
    // NSLog(@"Accesstoken %@", tokenData.accessToken);
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[kEDApiEndPointUrl stringByAppendingString:kEDWorkPostCupKey]]];
    //[mutableRequest addValue:tokenData.accessToken forHTTPHeaderField:@"FBAccessToken"];
    //[mutableRequest addValue:authorId forHTTPHeaderField:@"AuthorId"];
    return (NSURLRequest *)mutableRequest;
}


#pragma mark -


-(void)fetchData:(NSData *)data{
    self.dados = [[NSDictionary alloc] init];
    NSError *JsonParseError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    //NSDictionary *json = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&JsonParseError];
    //NSLog(@"%@",json);
    if (JsonParseError) {
        NSLog(@"%@",JsonParseError);
    } else {
        self.dados = json;
    }
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
