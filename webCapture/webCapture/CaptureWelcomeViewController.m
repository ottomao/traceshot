//
//  CaptureWelcomeViewController.m
//  webCapture
//
//  Created by Otto on 7/10/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CaptureWelcomeViewController.h"
#import "CaptureViewController.h"
@interface CaptureWelcomeViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIButton *startServerBtn;
@property (strong, nonatomic) IBOutlet UIButton *questionBtn;

@end

@implementation CaptureWelcomeViewController

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
    
    self.startBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.startBtn.layer.borderWidth = 2.0;
    self.startBtn.layer.cornerRadius = 10.0;
    
    self.startServerBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.startServerBtn.layer.borderWidth = 2.0;
    self.startServerBtn.layer.cornerRadius = 10.0;
    
    float preference_shotInterval = [[NSUserDefaults standardUserDefaults] floatForKey:@"shotInterval"];
    float preference_testDuration = [[NSUserDefaults standardUserDefaults] floatForKey:@"testDuration"];
    NSString *customUrl           = [[NSUserDefaults standardUserDefaults] stringForKey:@"customUrl"];
    if(preference_shotInterval){
        [self.shotIntervalSlide setValue:preference_shotInterval animated:NO];
    }
    if(preference_testDuration){
        [self.testDurationSlide setValue:preference_testDuration animated:NO];
    }
    if(customUrl){
        self.urlInput.text = customUrl;
    }
    
    [self updateSlideTip:nil];
    
    self.urlInput.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder]; //hide the keyborad
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//hide the keyboard when touch other views
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([self.urlInput isFirstResponder]) {
        [self.urlInput resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)startScanner{
    // create the scanning view controller and a navigation controller in which to present it:
    CDZQRScanningViewController *scanningVC = [CDZQRScanningViewController new];
    UINavigationController *scanningNavVC = [[UINavigationController alloc] initWithRootViewController:scanningVC];
    
    __weak CaptureWelcomeViewController *weakSelf = self;
    
    // configure the scanning view controller:
    scanningVC.resultBlock = ^(NSString *result) {
        weakSelf.urlInput.text = result;
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    scanningVC.cancelBlock = ^() {
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    scanningVC.errorBlock = ^(NSError *error) {
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    // present the view controller full-screen on iPhone; in a form sheet on iPad:
    scanningNavVC.modalPresentationStyle = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? UIModalPresentationFullScreen : UIModalPresentationFormSheet;
    [self presentViewController:scanningNavVC animated:YES completion:nil];
}

- (IBAction)scanQR:(id)sender {
    [self startScanner];
}

- (IBAction)updateSlideTip:(id)sender{
    NSString *tipA = [NSString stringWithFormat:@"%1.1fs",[self.shotIntervalSlide value]];
    
    NSString *tipBTpl = [self.testDurationSlide value] < 10 ? @"%1.1fs":@"%1.0fs";
    NSString *tipB = [NSString stringWithFormat:tipBTpl,[self.testDurationSlide value]];
    
    self.shotIntervalTip.text = tipA;
    self.testDurationTip.text = tipB;

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //save preference
    [[NSUserDefaults standardUserDefaults] setFloat:[self.shotIntervalSlide value] forKey:@"shotInterval"];
    [[NSUserDefaults standardUserDefaults] setFloat:[self.testDurationSlide value] forKey:@"testDuration"];
    [[NSUserDefaults standardUserDefaults] setObject:self.urlInput.text forKey:@"customUrl"];
    
    if([segue.identifier isEqualToString:@"start testing"]){
        CaptureViewController *captureVC = segue.destinationViewController;
        captureVC.testUrl = self.urlInput.text;
        
        NSString *intervalStr = [NSString stringWithFormat:@"%1.1f",[self.shotIntervalSlide value]];
        NSString *durationStr = [NSString stringWithFormat:@"%1f",[self.testDurationSlide value]];
        
        captureVC.shotInterval = [intervalStr floatValue];
        captureVC.testDuration = [durationStr floatValue];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
