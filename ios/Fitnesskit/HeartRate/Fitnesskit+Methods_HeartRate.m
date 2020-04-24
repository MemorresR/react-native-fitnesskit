#import "Fitnesskit+Methods_HeartRate.h"
#import "Fitnesskit+Queries.h"
#import "Fitnesskit+Utils.h"
#import "Fitnesskit+Errors.h"
@implementation Fitnesskit (Methods_HeartRate)


- (void)fitnessGetHeartRate:(NSDictionary *)input resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    @try{
    if (@available(iOS 11.0, *)) {
        HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
        
        HKUnit *count = [HKUnit countUnit];
        HKUnit *minute = [HKUnit minuteUnit];
        
        HKUnit *unit = [Fitnesskit hkUnitFromOptions:input key:@"unit" withDefault:[count unitDividedByUnit:minute]];
        NSUInteger limit = [Fitnesskit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
        BOOL ascending = [Fitnesskit boolFromOptions:input key:@"ascending" withDefault:false];
        NSDate *startDate = [Fitnesskit dateFromOptions:input key:@"startDate" withDefault:nil];
        NSDate *endDate = [Fitnesskit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
        if(startDate == nil){
          NSError * error = [Fitnesskit createErrorWithCode:ErrorDateNotCorrect andDescription:RCT_ERROR_DATE_NOT_CORRECT];
                  [Fitnesskit handleRejectBlock:reject error:error];
            return;
        }
        NSPredicate * predicate = [Fitnesskit predicateForSamplesBetweenDates:startDate endDate:endDate];
        
        [self fetchHeartRateQuantity:heartRateType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
            if(results){
                resolve(results);
                return;
            } else {
                  [Fitnesskit handleRejectBlock:reject error: error];
                return;
            }
        }];
    } else {
            // Fallback on earlier versions
    }
    }@catch (NSError *error) {
        [Fitnesskit handleRejectBlock:reject error: error];
    }
}



@end
