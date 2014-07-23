//
//  CaptureWelcomeViewController.h
//  webCapture
//
//  Created by Otto on 7/10/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDZQRScanningViewController.h"

@interface CaptureWelcomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *urlInput;
@property (strong, nonatomic) IBOutlet UILabel *shotIntervalTip;
@property (strong, nonatomic) IBOutlet UILabel *testDurationTip;
@property (strong, nonatomic) IBOutlet UISlider *shotIntervalSlide;
@property (strong, nonatomic) IBOutlet UISlider *testDurationSlide;

@end
