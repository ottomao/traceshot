//
//  CaptureResultViewController.m
//  webCapture
//
//  Created by Otto on 7/9/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "CaptureResultViewController.h"
#import "ViewToImage.h"

@interface CaptureResultViewController ()
@property (nonatomic,strong) UIScrollView *imageScrollView;
@end

@implementation CaptureResultViewController

- (UIScrollView *)imageScrollView{
    if(!_imageScrollView){
        _imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    
    return _imageScrollView;
}

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

    self.view.backgroundColor = [UIColor whiteColor];
    UIView *resultSummaryView = [self.shotMgr resultSummaryView];
    resultSummaryView.frame = CGRectMake(0, 0 , resultSummaryView.frame.size.width, resultSummaryView.frame.size.height);
    
    [self.imageScrollView addSubview:resultSummaryView];
    [self.imageScrollView setContentSize:CGSizeMake(resultSummaryView.frame.size.width, resultSummaryView.frame.size.height)];
    [self.view addSubview:self.imageScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveResultImage:(UIBarButtonItem *)sender {
    UIImage *imageResult = self.shotMgr.imageSummary;
    UIImageWriteToSavedPhotosAlbum(imageResult, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo{
    
    UIAlertView *alertView;
    NSString *tipString;
    
    if(error){
        tipString = @"failed to save , please check the permission";
    }else{
        tipString = @"image saved to your photo gallery";
    }
    
    alertView = [[UIAlertView alloc] initWithTitle:nil
                                           message:tipString
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
    
    [alertView show];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
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
