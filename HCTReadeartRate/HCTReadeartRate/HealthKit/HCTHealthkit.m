//
//  HCTHealthkit.m
//  HCTReadeartRate
//
//  Created by Ha Cong Thuan on 5/11/15.
//  Copyright (c) 2015 Ha Cong Thuan. All rights reserved.
//

#import "HCTHealthkit.h"

@implementation HCTHealthkit{
    
}
HKHealthStore *healthStore;


+ (void) setupHealthKit
{
    /* You should always run this function first */
    
    if ([HKHealthStore isHealthDataAvailable])
    {
        
        healthStore = [[HKHealthStore alloc] init];
        
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        
        /* Opening healtstore permission window and askind permissions for write and read data types */
        [healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error)
         {
             if (!success)
             {
                 //You didn't allow HealthKit to access these read/write data types. The error was: %@"error". If you're using a simulator, try it on a device.
                 
             }
             else //success
             {
                 //Healtkit ready
                 
             }
             
         }];
    }
    else
    {
        //Healthkit is not available for this device
    }
}

// Returns the types of data that Fit wishes to write to HealthKit.
+ (NSSet *)dataTypesToWrite{
    HKQuantityType *heartRate = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    return [NSSet setWithObjects:  heartRate, nil];
}


// Returns the types of data that Fit wishes to read from HealthKit.
+ (NSSet *)dataTypesToRead {
    HKQuantityType *heartRate = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    return [NSSet setWithObjects: heartRate, nil];
}
+ (void)fetchDataOfQuantityType:(HKQuantityType *)quantityType startDate:(NSDate *)startDate endDate:(NSDate *)endDate withCompletion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion {
    
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    // Your interval: sum by hour
    NSDateComponents *intervalComponents = [[NSDateComponents alloc] init];
    intervalComponents.hour = 1;
    // Example predicate
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:predicate limit:2 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        if (completion) {
            // If quantity isn't in the database, return nil in the completion block.
            HKQuantitySample *quantitySample = results.firstObject;
            HKQuantity *quantity = quantitySample.quantity;
            completion(quantity, error);
        }
    }];
    
    [healthStore executeQuery:query];
}

+ (void)readHeartBeatFromHKWithCompletion:(void (^)(int heartRate ,NSError *error)) completion{
    NSCalendar *calenDar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    HKUnit *bpmUnit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
    NSDate *startDate = [calenDar startOfDayForDate:now];
    NSDate *endDate = [calenDar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    HKQuantityType *heartCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    if ([HKHealthStore isHealthDataAvailable])
    {
        [self fetchDataOfQuantityType:heartCountType startDate:startDate endDate:endDate withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
            if (!mostRecentQuantity){  //Either an error
                
            }else{//HeartBeat
                if (completion) {
                    double temCout=[mostRecentQuantity doubleValueForUnit:bpmUnit];
                    NSLog(@"Heart Beat %d:",(int)temCout);
                    completion(temCout ,error);
                }
            }
        }];
    }
}
@end




