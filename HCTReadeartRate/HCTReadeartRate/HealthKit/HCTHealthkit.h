//
//  HCTHealthkit.h
//  HCTReadeartRate
//
//  Created by Ha Cong Thuan on 5/11/15.
//  Copyright (c) 2015 Ha Cong Thuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;
@interface HCTHealthkit : NSObject
+ (void) setupHealthKit;
+ (void)readHeartBeatFromHKWithCompletion:(void (^)(int heartRate ,NSError *error)) completion;
@end
