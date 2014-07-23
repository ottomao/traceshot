//
//  CaptureViewController.h
//  webCapture
//
//  Created by Otto on 7/9/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureResultViewController.h"
#import "CaptureScreenshotManager.h"
#import "CaptureWelcomeViewController.h"

@interface CaptureViewController : UIViewController <CaptureScreenshotManagerDelegate>
@property (strong, nonatomic) UIWebView *mainWebView;
@property (strong, nonatomic) NSString *testUrl;
@property (nonatomic) float shotInterval;
@property (nonatomic) float testDuration;
- (void)screenshotUpdated:(NSArray *)screenshots;
@end