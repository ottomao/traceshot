//
//  ViewToImage.h
//  webCapture
//
//  Created by Otto on 7/12/14.
//  Copyright (c) 2014 Otto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewToImage : NSObject
+ (UIImage *)captureScreen:(UIView*) viewToCapture;
+ (NSString *)imageToBase64:(UIImage *) image;
@end
