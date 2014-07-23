//
//  CaptureViewController.m
//  webCapture
//
//  Created by Otto on 7/9/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CaptureViewController.h"

@import CoreTelephony;

@interface CaptureViewController () <CaptureScreenshotManagerDelegate>
@property (nonatomic,strong) CaptureScreenshotManager *shotMgr;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabelA;
@property (nonatomic) CGRect webViewRect;
@property (strong, nonatomic) NSTimer *tickTimer;
@end

@implementation CaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.automaticallyAdjustsScrollViewInsets = false; //否则webview会自动留白边
    self.webViewRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    [self updateTipFromTimeInterval:self.testDuration];
    [self startTest];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(updateTick:)
                                                    userInfo:@{ @"startDate" : [NSDate date] }
                                                     repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTesting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshTest:(id)sender {
    [self startTest];
}

- (void)startTest{

    //init , add webview
    [self updateScreenshotCountTip:0];
    self.shotMgr = nil;
    self.shotMgr = [[CaptureScreenshotManager alloc] initWithUrl:self.testUrl
                                                 captureInterval:self.shotInterval
                                                    testDuration:self.testDuration
                                                        viewRect:self.webViewRect
                                                        delegate:self];
    [self.shotMgr startTest];
}

- (void)stopTesting{
    [self.shotMgr stopTesting];
}

- (void)UIWebViewInited:(UIWebView *)webview{
    [self.view insertSubview:webview atIndex:0]; //invoke webview after starting
}

- (void)updateTick:(NSTimer *)timer{
    NSTimeInterval interval = [[timer fireDate] timeIntervalSinceDate:[timer userInfo][@"startDate"]];
    NSTimeInterval remainingTime = self.testDuration - interval;
    remainingTime = remainingTime >= 0 ? remainingTime : 0 ;
    
    [self updateTipFromTimeInterval:remainingTime];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CaptureResultViewController class]]){
        CaptureResultViewController *dest = segue.destinationViewController;
        dest.shotMgr = self.shotMgr;
    }else if([segue.destinationViewController isKindOfClass:[CaptureWelcomeViewController class]]){
        NSLog(@"backing");
        [self stopTesting];
    }
}

- (void)screenshotUpdated:(NSArray *)screenshots{
    [self updateScreenshotCountTip:[screenshots count]];
}

- (void)updateScreenshotCountTip:(unsigned long)count{
    self.tipLabel.text = [NSString stringWithFormat:@"screen shots : %lu",count];
}

//mgr - delegate
- (void)testTaskEndedWithFinishStatus:(NSNumber *)ifFinished{
    BOOL testFinishedStatus = [ifFinished boolValue];
    if(testFinishedStatus && self.view.window){
        [self performSegueWithIdentifier:@"show result" sender:self];
    }else{
        
    }
}

- (void)updateTipFromTimeInterval:(NSTimeInterval)interval {
    self.tipLabelA.text = [NSString stringWithFormat:@"remaining : %@" , [self formatInterval:interval]];
}

-(NSString *)formatInterval:(NSTimeInterval)interval{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    //    NSInteger hours   = (ti / 3600);
    //    [NSString stringWithFormat:@"Start : %02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
}

-(NSString *)networkType {
    
    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
    NSLog(@"Current Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
    [NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification *note)
    {
        NSLog(@"New Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
    }];

    return @"wifi";
}

-(void)titleUpdated:(NSString *)title{
//    self.title = title;
}

@end
