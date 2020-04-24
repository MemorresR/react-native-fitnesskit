

#import "Fitnesskit+Methods_Steps.h"
#import "Fitnesskit+Queries.h"
#import "Fitnesskit+Utils.h"
#import "Fitnesskit+Errors.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>

@implementation Fitnesskit (Methods_Fitness)

- (void)fitnessGetStepCount:(NSDictionary *)input resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    @try{
        NSDate *startDate = [Fitnesskit dateFromOptions:input key:@"startDate" withDefault:[NSDate date]];
        NSDate *endDate = [Fitnesskit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
        if(startDate == nil || endDate == nil) {
            NSError * error = [Fitnesskit createErrorWithCode:ErrorDateNotCorrect andDescription:RCT_ERROR_DATE_NOT_CORRECT];
            [Fitnesskit handleRejectBlock:reject error:error];
            return;
        }
        
        HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        HKUnit *stepsUnit = [HKUnit countUnit];
        [self fetchStepsCount:stepCountType
                         unit:stepsUnit
                    startDate:startDate
                      endDate:endDate
                   completion:^(NSDictionary *dict, NSError *err){
            if (err != nil) {
                [Fitnesskit handleRejectBlock:reject error: err];
                return;
            }
            resolve(dict);
        }];
    }@catch (NSError *error) {
        [Fitnesskit handleRejectBlock:reject error: error];
    }
}
@end
