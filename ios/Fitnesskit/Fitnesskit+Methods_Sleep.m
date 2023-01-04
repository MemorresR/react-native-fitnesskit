#import "Fitnesskit+Methods_Sleep.h"
#import "Fitnesskit+Queries.h"
#import "Fitnesskit+Utils.h"
#import "Fitnesskit+Errors.h"
@implementation Fitnesskit (Methods_Sleep)


- (void)fitnessGetSleepData:(NSDictionary *)input resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    @try{
    if (@available(iOS 11.0, *)) {
        HKSampleType *sampleType = [HKSampleType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
        NSString *startDate = [input valueForKey:@"startDate"];
        NSString *endDate = [input valueForKey:@"endDate"];
        double startUnix = [startDate doubleValue];
        double endUnix = [endDate doubleValue];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];

        NSDate *now = [NSDate date];

        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];

        NSDate *startDates = [calendar dateFromComponents:components];

        NSDate *endDates = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDates options:0];

    
        if(startDate == nil){
          NSError * error = [Fitnesskit createErrorWithCode:ErrorDateNotCorrect andDescription:RCT_ERROR_DATE_NOT_CORRECT];
                  [Fitnesskit handleRejectBlock:reject error:error];
            return;
        }
        
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDates endDate:endDates options:HKQueryOptionNone];

            NSUInteger limits = [Fitnesskit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
            BOOL ascendings = [Fitnesskit boolFromOptions:input key:@"ascending" withDefault:false];
        
        [self fetchSleep:sampleType
                           predicate:predicate
                           ascending:ascendings
                               limit:limits
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
