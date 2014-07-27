//
//  CaptureServer.m
//  webCapture
//
//  Created by Otto on 7/16/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CaptureServer.h"

@interface CaptureServer()
@property (nonatomic,strong) CaptureScreenshotManager *shotMgr;
@property (nonatomic,strong) NSMutableArray *testResult;
@property (nonatomic) int status;
@property (nonatomic) int currentTaskId;
@end

@implementation CaptureServer

#define SERVER_ACTION_SHOT @"shot"
#define SERVER_ACTION_STATUS @"status"
#define SERVER_ACTION_FETCH @"fetch"
#define SERVER_ACTION_FORCE_STOP @"stop"

#define STATUS_IDLE 0
#define STATUS_BUSY 1

-(NSMutableArray *)testResult{
    if(!_testResult){
        _testResult = [[NSMutableArray alloc] init];
    }
    
    return _testResult;
}


-(void)startServer{
    // Create server
    self.webServer = [[GCDWebServer alloc] init];
    
    __weak CaptureServer *weakSelf = self;
    // Add a handler to respond to GET requests on any URL
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                      //log
                                      [weakSelf outputLog:[NSString stringWithFormat:@"req : %@",[request.URL absoluteString] ] ];
                                      
                                      NSDictionary *query = request.query;
                                      NSMutableDictionary *res = [@{ @"success": @NO} mutableCopy];
                                      
                                      NSString *actionName = query[@"action"];
                                      if([actionName isEqualToString:SERVER_ACTION_SHOT]){
                                          NSString *testUrl = query[@"url"];
                                       
                                          @try{
                                              res[@"success"] = @YES;
                                              res[@"taskId"] = [NSNumber numberWithInt:[weakSelf startShotingWithUrl:testUrl
                                                                                                  captureInterva:[[NSString stringWithFormat:@"%@",query[@"interval"]] doubleValue]
                                                                                                    testDuration:[[NSString stringWithFormat:@"%@",query[@"duration"]] doubleValue]
                                                                                        ]
                                                                ];
                                              [weakSelf outputLog:[NSString stringWithFormat:@"starting task #%@ : %@ ",res[@"taskId"],testUrl]];
                                          }
                                          @catch(NSException *e){
                                              res[@"success"] = @NO;
                                              res[@"reason"]  = [e reason];
                                              [weakSelf outputLog:[NSString stringWithFormat:@"failed to start task : %@",[e reason]]];
                                          }
                                          
                                      }else if([actionName isEqualToString:SERVER_ACTION_STATUS]){
                                          res[@"success"] = @YES;
                                          if(weakSelf.status == STATUS_IDLE){
                                              res[@"isIdle"] = @YES;
                                          }else{
                                              res[@"isIdle"]      = @NO;
                                              res[@"currentTaskId"] = [NSNumber numberWithInt:weakSelf.currentTaskId];
                                       
                                          }
                                      }else if([actionName isEqualToString:SERVER_ACTION_FETCH]){
                                          if([weakSelf.testResult count] > 0){
                                              NSDictionary *result = [weakSelf.testResult lastObject];
                                              if([[result objectForKey:@"success"] boolValue]){
                                                  res[@"success"]   = @YES;
                                                  res[@"taskId"]    = result[@"taskId"];
                                                  res[@"imgBase64"] = result[@"img"];
                                              }else{
                                                  res[@"success"] = @NO;
                                                  res[@"reason"]  = @"failed to fetch the latest result . did you cancel it ?";
                                              }
                                          }else{
                                              res[@"success"] = @NO;
                                              res[@"reason"]  = @"no result generated yet";
                                          }
                                          
                                      }else if([actionName isEqualToString:SERVER_ACTION_FORCE_STOP]){
                                          res[@"success"]     = @YES;
                                          res[@"stoppedTaskId"] = [NSNumber numberWithInt:weakSelf.currentTaskId];
                                          [weakSelf stopTest];
                                      }else{
                                          res[@"success"] = @NO;
                                          res[@"reason"]  = @"no valid action";
                                      }
                                      
                                      return [GCDWebServerDataResponse responseWithJSONObject:[res copy]];
                                  }];
    
    // Start server on port 8080
    [self.webServer startWithPort:8080 bonjourName:nil];
    [self outputLog:[NSString stringWithFormat:@"server started at : %@",self.webServer.serverURL ]];
}

-(void)stopServer{
    [self.webServer stop];
}

-(void)testTaskEndedWithFinishStatus:(NSNumber *)ifFinished{
    BOOL finishStatus = [ifFinished boolValue];
    NSDictionary *resultObj;
    NSNumber *taskId = [NSNumber numberWithInt:self.currentTaskId];
    
    if(finishStatus){
        resultObj = @{
                      @"taskId": taskId,
                      @"success":@YES,
                      @"img": [ViewToImage imageToBase64: [self.shotMgr imageSummary] ]
                      };
        [self outputLog:[NSString stringWithFormat:@"task #%@ finished",taskId]];
    }else{
        resultObj = @{
                      @"taskId": taskId,
                      @"success":@NO,
                      @"img": @""
                      };
        [self outputLog:[NSString stringWithFormat:@"task #%@ stopped",taskId]];
    }
    
    [self.testResult addObject:resultObj];
    
    self.status  = STATUS_IDLE;
    self.shotMgr = nil;
}

-(int)startShotingWithUrl:(NSString *)shotUrl
           captureInterva:(double)interval
             testDuration:(double)duration{
    if(!interval || interval <= 0){
        NSException *e = [NSException exceptionWithName:@"para err" reason:@"please assign a valid interval value for shot" userInfo:nil];
        @throw e;
    }else if(!duration || duration <= 0){
        NSException *e = [NSException exceptionWithName:@"para err" reason:@"please assign a valid duration value for shot" userInfo:nil];
        @throw e;
    }else if(!shotUrl){
        NSException *e = [NSException exceptionWithName:@"para err" reason:@"please assign a valid url" userInfo:nil];
        @throw e;
    }else if(self.status == STATUS_BUSY){
        NSException *e = [NSException exceptionWithName:@"para err" reason:@"another task is on the fly now" userInfo:nil];
        @throw e;
    }

    self.shotMgr = [[CaptureScreenshotManager alloc] initWithUrl:shotUrl
                                                 captureInterval:interval
                                                    testDuration:duration
                                                        viewRect:CGRectMake(0, 0, 640, 1136)
                                                        delegate:self];
    
    self.status = STATUS_BUSY;
    [self.shotMgr startTest];
    ++self.currentTaskId;
    return self.currentTaskId;
}

-(void)stopTest{
    [self.shotMgr stopTesting]; //will trigger testTask... method
}

-(void)outputLog:(NSString *)logText{
    
    if([self.delegate respondsToSelector:@selector(appendLog:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate performSelector:@selector(appendLog:) withObject:logText];
        });
    }
}

//do something after memory warning
-(void)clearMemory{
    NSDictionary *lastestResult = [self.testResult lastObject];
    self.testResult = [[NSMutableArray alloc] initWithObjects:lastestResult, nil];
    
}

@end
