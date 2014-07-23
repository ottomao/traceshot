//
//  CaptureScreenshotManager.h
//  webCapture
//
//  Created by Otto on 7/9/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CaptureScreenshotManagerDelegate <NSObject>
@optional
-(void)screenshotUpdated:(NSArray *)screenshots;
-(void)titleUpdated:(NSString *)title;
-(void)testTaskEndedWithFinishStatus:(NSNumber *)ifFinished;
-(void)UIWebViewInited:(UIWebView *)webview;
@end

@interface CaptureScreenshotManager : NSObject <UIWebViewDelegate>

@property (nonatomic,strong) NSMutableArray *screenshots;
@property (nonatomic) double screenshotInterval;
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSString *url;
@property (strong, nonatomic) UIWebView *mainWebView;
@property (nonatomic) CGRect mainWebViewFrame;
@property (nonatomic) double shotInterval;
@property (nonatomic) double testDuration;
@property (nonatomic,strong,readonly) UIImage *imageSummary;
@property (strong, nonatomic) id<CaptureScreenshotManagerDelegate> delegate;

- (CaptureScreenshotManager *)initWithUrl:(NSString *)url
                          captureInterval:(double)interval
                             testDuration:(double)duration
                                 viewRect:(CGRect)mainWebViewFrame
                                 delegate:(id<CaptureScreenshotManagerDelegate>)delegate;

- (UIView *)resultSummaryView;
- (UIImage *)imageSummary;
- (void)startTest;
- (void)stopTesting;
@end


