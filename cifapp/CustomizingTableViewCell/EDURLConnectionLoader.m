//
//  EDURLConnectionLoader.m
//  EDITStub
//
//  Created by Tiago Janela on 27/05/13.
//  Copyright (c) 2013 Bliss Applications. All rights reserved.
//

#import "EDURLConnectionLoader.h"
#import "NSThread+MCSMAdditions.h"
//#import "EDError.h"

@implementation EDURLConnectionLoader

- (id)initWithRequest:(NSURLRequest *)request{
	self = [super init];
	if (self) {
		_request = [request init];
		_receivedData = [[NSMutableData alloc] initWithCapacity:512];
		_shouldCache = NO;
	}
	return self;
}

- (void) load{
	[NSThread MCSM_performBlockInBackground:^{
		[self effectivelyLoad];
	}];
}

- (void) effectivelyLoad{
	_underlyingConnection = [[NSURLConnection alloc] initWithRequest:_request
                                                            delegate:self
                                                    startImmediately:YES];
	
	while(!_exit){
		@autoreleasepool {
			NSDate * dataForLoop = [NSDate dateWithTimeIntervalSinceNow:0.1];
            [[NSRunLoop currentRunLoop] runUntilDate:dataForLoop];
            

		}
	} 
}

- (BOOL) maybeCancel{
	if(_isCancelled){
		[_underlyingConnection cancel];
		if(self.progressBlock){
			self.progressBlock(1);
		}
		if(self.completionBlock){
			//self.completionBlock(EDCreateErrorWithCodeAndMessage(kEDArtworkManager_Error_UserCancelled, @"URL Load Cancelled"),nil);
		}
	}
	return _isCancelled;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	if([self maybeCancel]){
		return;
	}
	_receivedResponseDataLength += data.length;
	[_receivedData appendData:data];
	CGFloat progress =(_receivedResponseDataLength * 1.0f/ _expectedResponseDataLength);
	if(self.progressBlock){
		self.progressBlock(progress);
	}
	
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	if([self maybeCancel]){
		return;
	}
	_expectedResponseDataLength = response.expectedContentLength;
	_receivedResponseDataLength = 0;
	if(self.progressBlock){
		self.progressBlock(0);
	}
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	if([self maybeCancel]){
		_exit = YES;
		return;
	}
	if(self.progressBlock){
		self.progressBlock(1);
	}
	if(self.completionBlock){
		self.completionBlock(nil,_receivedData);
	}
	_exit = YES;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	if([self maybeCancel]){
		
		_exit = YES;
		return;
	}
	if(self.progressBlock){
		self.progressBlock(1);
	}
	if(self.completionBlock){
		self.completionBlock(error,nil);
	}
	_exit = YES;
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	CGFloat progress =(totalBytesWritten * 1.0f/ totalBytesExpectedToWrite);
	if(self.progressBlock){
		self.progressBlock(progress);
	}
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	if(self.shouldCache){
		return cachedResponse;
	}
	return nil;
}
@end
