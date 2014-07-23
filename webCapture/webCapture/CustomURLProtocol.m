//
//  CustomURLProtocol.m
//  webCapture
//
//  Created by Otto on 7/14/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CustomURLProtocol.h"


#define PROTOCOL_MARK @"ProtocolHandled"
@implementation CustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    if([NSURLProtocol propertyForKey:PROTOCOL_MARK inRequest:request]){
        return NO;
    }

    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{

    NSMutableURLRequest *mutableReq = [request mutableCopy];
    [mutableReq setValue:@"" forHTTPHeaderField:@"If-Modified-Since"];
    [mutableReq setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    [mutableReq setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
//    NSLog(@"canonical req url : %@",mutableReq.URL);
    return [mutableReq copy];
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return NO;
}

- (void) startLoading{
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:PROTOCOL_MARK inRequest:newRequest];
    
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void) stopLoading{
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
    NSMutableDictionary *headers = [[httpRes allHeaderFields] mutableCopy];
    [headers removeObjectForKey:@"Expires"];
    [headers removeObjectForKey:@"Cache-Control"];
    [headers removeObjectForKey:@"Age"];
    [headers removeObjectForKey:@"Last-Modified"];
    NSHTTPURLResponse *newRes = [[NSHTTPURLResponse alloc] initWithURL:[[connection originalRequest] URL]
                                                            statusCode:[httpRes statusCode]
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:[headers copy]
                                 ];
    
    [self.client URLProtocol:self didReceiveResponse:[newRes copy] cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"data : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}


@end
