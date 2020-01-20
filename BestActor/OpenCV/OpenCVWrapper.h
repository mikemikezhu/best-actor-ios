//
//  OpenCVWrapper.h
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)versionNumber;
+ (nullable UIImage *)detectFace:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
