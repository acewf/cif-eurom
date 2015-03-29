//
//  EDURLConnectionLoader.h
//  EDITStub
//
//  Created by Tiago Janela on 27/05/13.
//  Copyright (c) 2013 Bliss Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EDURLConnectionLoaderProgressHandler)(CGFloat progress);
typedef void(^EDURLConnectionLoaderCompletionHandler)(NSError*,NSData*);

@interface EDURLConnectionLoader : NSObject
<NSURLConnectionDataDelegate>
{
	NSURLRequest *_request;
	NSMutableData *_receivedData;
	long long _receivedResponseDataLength;
	long long _expectedResponseDataLength;
	NSURLConnection *_underlyingConnection;
	BOOL _exit;

}

@property (nonatomic) BOOL isCancelled;
@property (nonatomic) BOOL shouldCache;
@property (copy,nonatomic)EDURLConnectionLoaderProgressHandler progressBlock;
@property (copy,nonatomic)EDURLConnectionLoaderCompletionHandler completionBlock;

- (id) initWithRequest:(NSURLRequest*)request;
- (void) load;



@end
