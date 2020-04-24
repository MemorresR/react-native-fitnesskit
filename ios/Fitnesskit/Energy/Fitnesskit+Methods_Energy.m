

#import "Fitnesskit+Methods_Energy.h"
#import "Fitnesskit+Queries.h"
#import "Fitnesskit+Utils.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import "Fitnesskit+Errors.h"
@implementation Fitnesskit (Methods_Energy)

- (void)fitnessGetEnergy:(NSDictionary *)input resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    
    NSDate *startDate = [Fitnesskit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [Fitnesskit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    HKUnit *cal = [HKUnit kilocalorieUnit];
    NSString *type = [Fitnesskit stringFromOptions:input key:@"type" withDefault:@"ActiveEnergy"];
    HKQuantityType *energyType = [Fitnesskit HKEnergyTypeFromString:type];
    if(startDate == nil || endDate == nil) {
     NSError * error = [Fitnesskit createErrorWithCode:ErrorDateNotCorrect andDescription:RCT_ERROR_DATE_NOT_CORRECT];
              [Fitnesskit handleRejectBlock:reject error:error];
        return;
    }
    NSPredicate * predicate = [Fitnesskit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchEnergy:energyType
                                unit:cal
                           predicate:predicate
                           ascending:false
                               limit:HKObjectQueryNoLimit
                          completion:^(NSArray *results, NSError *error) {
                              if(results){
                                  resolve(results);
                                  return;
                              } else {
                                 [Fitnesskit handleRejectBlock:reject error: error];
                                  return;
                              }
                          }];
}



@end
