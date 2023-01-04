

#import "Fitnesskit+Methods_Distance.h"
#import "Fitnesskit+Queries.h"
#import "Fitnesskit+Utils.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import "Fitnesskit+Errors.h"
@implementation Fitnesskit (Methods_Distance)

- (void)fitnessGetDistance:(NSDictionary *)input resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    
    HKUnit *unit = [Fitnesskit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit meterUnit]];
    NSUInteger limit = [Fitnesskit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [Fitnesskit boolFromOptions:input key:@"ascending" withDefault:false];
    NSString *type = [Fitnesskit stringFromOptions:input key:@"type" withDefault:@"DistanceWalkingRunning"];
    NSDate *startDate = [Fitnesskit dateFromOptions:input key:@"startDate" withDefault:[NSDate date]];
    NSDate *endDate = [Fitnesskit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil || endDate == nil) {
     NSError * error = [Fitnesskit createErrorWithCode:ErrorDateNotCorrect andDescription:RCT_ERROR_DATE_NOT_CORRECT];
              [Fitnesskit handleRejectBlock:reject error:error];
        return;
    }
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKQuantityType *distanceType = [Fitnesskit HKObjectTypeFromString:type];
    if ([type isEqual:@"Running"] || [type isEqual:@"Cycling"]) {
        unit = [HKUnit mileUnit];
    }
   // NSLog(@"error getting samples: %@", [samplesType identifier]);
    [self fetchDistance:distanceType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  resolve(results);
                                  return;
                              } else {
                                  NSLog(@"error getting samples: %@", error);
                                   [Fitnesskit handleRejectBlock:reject error: error];
                                  return;
                              }
                          }];
    
}



@end
