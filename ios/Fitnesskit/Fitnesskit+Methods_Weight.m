#import "Fitnesskit+Methods_Weight.h"
#import "Fitnesskit+Queries.h"
#import "Fitnesskit+Utils.h"
#import "Fitnesskit+Errors.h"
@implementation Fitnesskit (Methods_Weight)


- (void)fitnessSaveWeightData:(NSDictionary *)input resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    @try{
    if (@available(iOS 11.0, *)) {
        HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
        NSMutableSet *writePermSet = [NSMutableSet setWithCapacity:1];
        [writePermSet addObject:weightType];
        [self.healthStore preferredUnitsForQuantityTypes:writePermSet completion:^(NSDictionary* preferredUnits, NSError *error) {
            HKUnit * type = preferredUnits.allValues[0];
            double weight = [Fitnesskit doubleValueFromOptions:input];
            if(type == [HKUnit poundUnit]){
                weight = weight * 2.20462262185 ;
            }else if(type == [HKUnit stoneUnit]){
                weight = weight * 0.16 ;
            }
            NSDate *sampleDate = [NSDate date];
            HKUnit *unit = [Fitnesskit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit poundUnit]];

            HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:type doubleValue:weight];
           
            HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:sampleDate endDate:sampleDate];
          
            [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
                if (!success) {
                    [Fitnesskit handleRejectBlock:reject error:error];
                    return;
                }
                resolve(@"");
            }];
            
//               if (!type) {
//                   [Fitnesskit handleRejectBlock:reject error:error];
//                   return;
//               }
           }];
    } else {
            // Fallback on earlier versions
    }
    }@catch (NSError *error) {
        [Fitnesskit handleRejectBlock:reject error: error];
    }
}



@end
