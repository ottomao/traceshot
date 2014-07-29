//
//  CaptureServer.h
//  webCapture
//
//  Created by Otto on 7/16/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaptureScreenshotManager.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "ViewToImage.h"

@protocol captureServerDelegate <NSObject>

@optional
-(void)appendLog:(NSString *)logText;

@end

@interface CaptureServer : NSObject <CaptureScreenshotManagerDelegate>
@property (nonatomic,strong) GCDWebServer* webServer;
@property (nonatomic,weak) id<captureServerDelegate> delegate;
-(void)startServer;
-(void)stopServer;
-(void)clearMemory;
@end
