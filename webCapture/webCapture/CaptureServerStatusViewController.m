//
//  CaptureServerStatusViewController.m
//  webCapture
//
//  Created by Otto on 7/16/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CaptureServerStatusViewController.h"


@interface CaptureServerStatusViewController ()
@property (strong, nonatomic) IBOutlet UITextView *mainUIText;
@property (strong, nonatomic) IBOutlet UILabel *serverStatus;
@property (strong, nonatomic) CaptureServer *server;
@end

@implementation CaptureServerStatusViewController

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
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //prevent the app from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self appendLog:@"system idle timer has been disabled successfully. your phone will not go to sleep in server mode"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.server = [[CaptureServer alloc] init];
    self.server.delegate = self;
    [self.server startServer];
    
    self.serverStatus.text = [NSString stringWithFormat:@"%@",self.server.webServer.serverURL];
}

//TODO remove the VC from memory
- (void)viewDidUnload{
    NSLog(@"unload");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.server stopServer];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.server clearMemory];
    // Dispose of any resources that can be recreated.
}

- (void)appendLog:(NSString *)logText{
    //new log text
    NSMutableAttributedString *newLog = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",logText]];

    //datetime text
    NSDate *dateNow = [[NSDate alloc] init];
    NSString *dateStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    dateStr = [NSString stringWithFormat:@"%@\n",[dateFormatter stringFromDate:dateNow] ];
    
    NSAttributedString *dateAttributedString = [[NSAttributedString alloc] initWithString:dateStr
                                                                     attributes:@{
                                                                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:12]
                                                                                                     }
                                      ];
    
    //merge new log
    [newLog insertAttributedString:dateAttributedString atIndex:0];
    
    //prepend new log
    NSMutableAttributedString *previousLog = [self.mainUIText.attributedText mutableCopy];
    [previousLog insertAttributedString:newLog atIndex:0];
    
    self.mainUIText.attributedText = [previousLog copy];
    
    
    
//    self.mainUIText.text = [NSString stringWithFormat:@"%@\n%@\n\n%@",dateStr,logText,previousText];
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
