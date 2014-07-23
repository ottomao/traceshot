//
//  CaptureServerStatusViewController.h
//  webCapture
//
//  Created by Otto on 7/16/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureServer.h"

@interface CaptureServerStatusViewController : UIViewController <captureServerDelegate>
- (void)appendLog:(NSString *)logText;
@end
