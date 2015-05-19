//
//  InterfaceController.m
//  Test WatchKit Extension
//
//  Created by Ha Cong Thuan on 5/19/15.
//  Copyright (c) 2015 Ha Cong Thuan. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *mainGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lblValue;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [WKInterfaceController openParentApplication:@{@"WatchSay":@"getBMI"} reply:^(NSDictionary *replyInfo, NSError *error) {
        [_lblValue setText:[NSString stringWithFormat:@"%@ BMI",[replyInfo objectForKey:@"BMI"]]];
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



