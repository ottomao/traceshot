//
//  CaptureServerModeIntroViewController.m
//  webCapture
//
//  Created by Otto on 7/29/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CaptureServerModeIntroViewController.h"

@interface CaptureServerModeIntroViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *mainWebView;

@end

@implementation CaptureServerModeIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.automaticallyAdjustsScrollViewInsets = false;
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.traceshot.com/#server-mode"]];
    [self.mainWebView loadRequest:req];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
