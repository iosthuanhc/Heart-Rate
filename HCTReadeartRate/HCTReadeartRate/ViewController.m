//
//  ViewController.m
//  HCTReadeartRate
//
//  Created by Ha Cong Thuan on 5/11/15.
//  Copyright (c) 2015 Ha Cong Thuan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    HCTHealthkit *healthKit;
    __weak IBOutlet UILabel *_lblBMI;
    NSTimer *livetime;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [HCTHealthkit setupHealthKit];
    livetime = [NSTimer timerWithTimeInterval:0.1f
                                           target:self
                                         selector:@selector(liveUpdateData:)
                                         userInfo:nil
                                          repeats:YES];
    
}
-(void)liveUpdateData:(NSTimer *)time{
    [HCTHealthkit readHeartBeatFromHKWithCompletion:^(int heartRate, NSError *error) {
        _lblBMI.text = [NSString stringWithFormat:@"%i",heartRate];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
