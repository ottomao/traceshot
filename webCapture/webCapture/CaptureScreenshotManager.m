//
//  CaptureScreenshotManager.m
//  webCapture
//
//  Created by Otto on 7/9/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CaptureScreenshotManager.h"
#import "ViewToImage.h"
@interface CaptureScreenshotManager()
@property (nonatomic,strong) NSTimer *captureTimer;
@property (nonatomic,strong) UIImage *imageSummary;
@property (nonatomic,strong) NSMutableURLRequest *lastReq;
@end


@implementation CaptureScreenshotManager

- (CaptureScreenshotManager *)initWithUrl:(NSString *)url captureInterval:(double)interval testDuration:(double)duration viewRect:(CGRect)mainWebViewFrame delegate:(id<CaptureScreenshotManagerDelegate>)delegate{
    if (self = [super init]){
        self.url = url;
        self.shotInterval = interval;
        self.testDuration = duration;
        self.mainWebViewFrame = mainWebViewFrame;
        self.delegate = delegate;
        return self;
    }else{
        return nil;
    }
}

- (NSMutableArray *)screenshots{
    if(!_screenshots){
        _screenshots = [[NSMutableArray alloc] init];
    }
    
    return _screenshots;
}

- (void)startTest{
    //reset timer
    if([self.captureTimer isValid]){
        [self.captureTimer invalidate];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        self.mainWebView = nil;
        self.mainWebView = [[UIWebView alloc] initWithFrame:self.mainWebViewFrame]; //exclude the status bar & navigation bar
        self.mainWebView.delegate = self;
        self.mainWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        if(self.url){
            [self startLoading];
            //capture timer
            self.captureTimer = [NSTimer scheduledTimerWithTimeInterval:self.shotInterval
                                                                 target:self
                                                               selector:@selector(captureNow:)
                                                               userInfo:@{ @"startDate" : [NSDate date] }
                                                                repeats:YES];
        }
        
        //timer to stop the test
        [self performSelector:@selector(stopTestingWithFinishStatus:) withObject:[NSNumber numberWithBool:YES] afterDelay:self.testDuration];
        
        if([self.delegate respondsToSelector:@selector(UIWebViewInited:)]){
            [self.delegate performSelector:@selector(UIWebViewInited:) withObject:self.mainWebView];
        }
    });
}

- (void)captureNow:(NSTimer *)timer{
    NSTimeInterval interval = [[timer fireDate] timeIntervalSinceDate:[timer userInfo][@"startDate"]];
    [self shotView:self.mainWebView atTimeDelta:[NSNumber numberWithDouble:interval]];
}

- (void)stopTesting{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
    
    [self stopTestingWithFinishStatus:[NSNumber numberWithBool:NO]];
}

- (void)stopTestingWithFinishStatus:(NSNumber *)ifFinished{

    //reset timer
    if([self.captureTimer isValid]){
        [self.captureTimer invalidate];
    }
    
    [self.mainWebView stopLoading];
    self.mainWebView = nil;
    
    if([self.delegate respondsToSelector:@selector(testTaskEndedWithFinishStatus:)]){
        [self.delegate performSelector:@selector(testTaskEndedWithFinishStatus:) withObject:ifFinished];
    }
}

- (void)dealloc{
    //TODO
    [self.mainWebView removeFromSuperview];
    self.mainWebView = nil;
}

- (void)startLoading{

    self.startDate = [[NSDate alloc] init];
    NSDate *dateNow = [[NSDate alloc] init];
    NSString *urlWithRandomParam = [NSString stringWithFormat:@"%@?t=%f",self.url,[dateNow timeIntervalSince1970]];
    NSURL *url = [[NSURL alloc] initWithString:urlWithRandomParam];

    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url
                                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                        timeoutInterval:10000
                                ];
    [req setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [self.mainWebView loadRequest:req];
}

- (void)shotView:(UIView *)targetView atTimeDelta:(NSNumber *)time{
    UIImage *captured = [ViewToImage captureScreen:targetView];
    NSDictionary *resultInfo = @{@"time": time , @"image":captured};
    [self.screenshots addObject:resultInfo];
    
    if([self.delegate respondsToSelector:@selector(screenshotUpdated:)]){
        [self.delegate performSelector:@selector(screenshotUpdated:) withObject:[self.screenshots copy]];
    }
}

- (UIView *)resultSummaryView{
    NSArray *shots = [self.screenshots copy];
    NSUInteger shotCount = [shots count];
    NSInteger finalW = shotCount * 260 ; //20 - 200 - 20 - 200 -20
    
    UIView *imageBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, finalW, 500)];
    imageBoardView.backgroundColor = [UIColor whiteColor];
    
    //get the height of a screenshot
    NSInteger viewHeight = 200 * (self.mainWebView.frame.size.height / self.mainWebView.frame.size.width);
    
    //print test info
    NSDictionary *fontAttribute = @{NSFontAttributeName: [UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody] size:12.0]};
    for(NSUInteger i = 0 ; i <= 3 ; i++){
        NSString *mainText = @"";
        
        if( i == 0 ){ //start time
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            
            mainText = [NSString stringWithFormat:@"start : %@",[dateFormatter stringFromDate:self.startDate] ];
        }else if(i == 1 ){ //url
            mainText = [NSString stringWithFormat:@"url : %@",self.url];
        }else if(i == 2){ //interval
            mainText = [NSString stringWithFormat:@"capture interval : %1.2fs",self.shotInterval];
        }else if(i == 3){
            //TODO :custom text
//            mainText = [NSString stringWithFormat:@"network : %@",self.networkType];
        }
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + i * 15, 500, 20)];
        NSAttributedString *richTip = [[NSAttributedString alloc] initWithString:mainText
                                                                      attributes:fontAttribute];
        
        [infoLabel setAttributedText:richTip];
        [imageBoardView addSubview:infoLabel];
    }
    
    //print screen shots and label
    for(NSUInteger i = 0 ; i < shotCount ; i++){
        NSDictionary *shotObj = [shots objectAtIndex:i];
        UIImage *tmpImage  = shotObj[@"image"];
        NSString *imageTip = [NSString stringWithFormat:@"Time : %0.2f s", [shotObj[@"time"] doubleValue] ];
        NSAttributedString *richTip = [[NSAttributedString alloc] initWithString:imageTip
                                                                      attributes:@{
                                                                                   NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]}];
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*260 + 20, 100, 200, 20)];
        [tmpLabel setAttributedText:richTip];
        
        UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:tmpImage];
        tmpImageView.frame = CGRectMake( i * 260 + 20 , 120 , 200, viewHeight);
        tmpImageView.layer.borderColor = [UIColor grayColor].CGColor;
        tmpImageView.layer.borderWidth = 2.0f;
        
        [imageBoardView addSubview:tmpImageView];
        [imageBoardView addSubview:tmpLabel];
    }
    
    return imageBoardView;
}

- (UIImage *)imageSummary{
    UIImage *resultImage = [ViewToImage captureScreen:[self resultSummaryView]];
    return resultImage;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *webpageTitle = [self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if([self.delegate respondsToSelector:@selector(titleUpdated:)]){
        [self.delegate performSelector:@selector(titleUpdated:) withObject:webpageTitle ];
    }
}

@end
