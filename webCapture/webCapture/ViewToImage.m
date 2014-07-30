//
//  ViewToImage.m
//  webCapture
//
//  Created by Otto on 7/12/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import "ViewToImage.h"

@implementation ViewToImage
+ (UIImage*)captureScreen:(UIView*) viewToCapture
{
    UIImage *viewImage;
    
    UIGraphicsBeginImageContext(viewToCapture.bounds.size);//
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return viewImage;
}

+ (NSString *)imageToBase64:(UIImage *)image{
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    return [NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imgData base64Encoding]];
}

@end