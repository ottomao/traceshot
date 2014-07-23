//
//  CustomURLProtocol.h
//  webCapture
//
//  Created by Otto on 7/14/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomURLProtocol : NSURLProtocol <NSURLConnectionDelegate>
@property (nonatomic,strong) NSURLConnection *connection;

@end
