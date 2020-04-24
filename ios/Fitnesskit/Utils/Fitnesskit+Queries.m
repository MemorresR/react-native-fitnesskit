
#import "Fitnesskit+Queries.h"
#import "Fitnesskit+Utils.h"

#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>

@implementation Fitnesskit (Queries)


- (void)fetchHeartRateQuantity:(HKQuantityType *)quantityType
                              unit:(HKUnit *)unit
                         predicate:(NSPredicate *)predicate
                         ascending:(BOOL)asc
                             limit:(NSUInteger)lim
                        completion:(void (^)(NSArray *, NSError *))completion {
    
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate
                                                                       ascending:asc];
    
        // declare the block
    void (^handlerBlock)(HKSampleQuery *query, NSArray *results, NSError *error);
        // create and assign the block
    handlerBlock = ^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        if (completion) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (HKQuantitySample *sample in results) {
                    HKQuantity *quantity = sample.quantity;
                    double value = [quantity doubleValueForUnit:unit];
                    
                    NSString *startDateString = [Fitnesskit buildISO8601StringFromDate:sample.startDate];
                    NSString *endDateString = [Fitnesskit buildISO8601StringFromDate:sample.endDate];
                    
                    NSDictionary *elem = @{
                        @"heartRate" : @(value),
                        @"date" : startDateString,
                    };
                    
                    [data addObject:elem];
                }
                
                completion(data, error);
            });
        }
    };
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                           predicate:predicate
                                                               limit:lim
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:handlerBlock];
    
    [self.healthStore executeQuery:query];
}



- (void)fetchDistance:(HKSampleType *)type
                      unit:(HKUnit *)unit
                 predicate:(NSPredicate *)predicate
                 ascending:(BOOL)asc
                     limit:(NSUInteger)lim
                completion:(void (^)(NSArray *, NSError *))completion {
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate
                                                                       ascending:asc];
    
        // declare the block
    void (^handlerBlock)(HKSampleQuery *query, NSArray *results, NSError *error);
        // create and assign the block
    handlerBlock = ^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        
        if (completion) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (type == [HKObjectType workoutType]) {
                    for (HKWorkout *sample in results) {
                        double energy =  [[sample totalEnergyBurned] doubleValueForUnit:[HKUnit kilocalorieUnit]];
                        double distance = [[sample totalDistance] doubleValueForUnit:[HKUnit mileUnit]];
                        NSString *type = [Fitnesskit stringForHKWorkoutActivityType:[sample workoutActivityType]];
                        
                        NSString *startDateString = [Fitnesskit buildISO8601StringFromDate:sample.startDate];
                        NSString *endDateString = [Fitnesskit buildISO8601StringFromDate:sample.endDate];
                        
                        bool isTracked = true;
                        if ([[sample metadata][HKMetadataKeyWasUserEntered] intValue] == 1) {
                            isTracked = false;
                        }
                        
                        NSString* device = @"";
                        if (@available(iOS 11.0, *)) {
                            device = [[sample sourceRevision] productType];
                        } else {
                            device = [[sample device] name];
                            if (!device) {
                                device = @"iPhone";
                            }
                        }
                        
                        NSDictionary *elem = @{
                            @"activityId" : [NSNumber numberWithInt:[sample workoutActivityType]],
                            @"activityName" : type,
                            @"calories" : @(energy),
                            @"tracked" : @(isTracked),
                            @"sourceName" : [[[sample sourceRevision] source] name],
                            @"sourceId" : [[[sample sourceRevision] source] bundleIdentifier],
                            @"device": device,
                            @"distance" : @(distance),
                            @"start" : startDateString,
                            @"end" : endDateString
                        };
                        
                        [data addObject:elem];
                    }
                } else {
                    for (HKQuantitySample *sample in results) {
                        HKQuantity *quantity = sample.quantity;
                        double value = [quantity doubleValueForUnit:unit];
                        
                        NSString * valueType = @"quantity";
                        if (unit == [HKUnit meterUnit]) {
                            valueType = @"distance";
                        }
                        
                        NSString *startDateString = [Fitnesskit buildISO8601StringFromDate:sample.startDate];
                        NSString *endDateString = [Fitnesskit buildISO8601StringFromDate:sample.endDate];
                        
                        bool isTracked = true;
                        if ([[sample metadata][HKMetadataKeyWasUserEntered] intValue] == 1) {
                            isTracked = false;
                        }
                        
                        NSString* device = @"";
                        if (@available(iOS 11.0, *)) {
                            device = [[sample sourceRevision] productType];
                        } else {
                            device = [[sample device] name];
                            if (!device) {
                                device = @"iPhone";
                            }
                        }
                        
                        NSDictionary *elem = @{
                            valueType : @(value),
                            @"date" : startDateString,
                        };
                        
                        [data addObject:elem];
                    }
                }
                
                completion(data, error);
            });
        }
    };
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type
                                                           predicate:predicate
                                                               limit:lim
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:handlerBlock];
    
    [self.healthStore executeQuery:query];
}


- (void)fetchEnergy:(HKQuantityType *)quantityType
                              unit:(HKUnit *)unit
                         predicate:(NSPredicate *)predicate
                         ascending:(BOOL)asc
                             limit:(NSUInteger)lim
                        completion:(void (^)(NSArray *, NSError *))completion {

    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate
                                                                       ascending:asc];

    // declare the block
    void (^handlerBlock)(HKSampleQuery *query, NSArray *results, NSError *error);
    // create and assign the block
    handlerBlock = ^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }

        if (completion) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];

            dispatch_async(dispatch_get_main_queue(), ^{

                for (HKQuantitySample *sample in results) {
                    HKQuantity *quantity = sample.quantity;
                    double value = [quantity doubleValueForUnit:unit];

                    NSString *startDateString = [Fitnesskit buildISO8601StringFromDate:sample.startDate];
                    NSString *endDateString = [Fitnesskit buildISO8601StringFromDate:sample.endDate];

                    NSDictionary *elem = @{
                            @"energy" : @(value),
                            @"date" : startDateString,
                    };

                    [data addObject:elem];
                }

                completion(data, error);
            });
        }
    };

    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                           predicate:predicate
                                                               limit:lim
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:handlerBlock];

    [self.healthStore executeQuery:query];
}





- (void)fetchStepsCount:(HKQuantityType *)quantityType
                   unit:(HKUnit *)unit
              startDate:(NSDate *)startDate
                endDate:(NSDate *)endDate
             completion:(void (^)(NSDictionary *, NSError *))completionHandler {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:[NSDate date]];
    anchorComponents.hour = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"metadata.%K != YES", HKMetadataKeyWasUserEntered];
        // Create the query
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:predicate
                                                                                           options:HKStatisticsOptionCumulativeSum
                                                                                        anchorDate:anchorDate
                                                                                intervalComponents:interval];
    
        // Set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
                // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",error.localizedDescription);
        }
        
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
        [results enumerateStatisticsFromDate:startDate
                                      toDate:endDate
                                   withBlock:^(HKStatistics *result, BOOL *stop) {
            
            HKQuantity *quantity = result.sumQuantity;
            if (quantity) {
                NSDate *date = result.startDate;
                double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                NSLog(@"%@: %f", date, value);
                NSString *dateString = [Fitnesskit buildISO8601StringFromDate:date];
                NSDictionary *response = @{
                    @"steps" : @(value),
                    @"date" : dateString
                };
                    // NSArray *elem = @[dateString, @(value)];
                [data addObject:response];
            }
        }];
        NSError *err;
        completionHandler(data, err);
    };
    
    [self.healthStore executeQuery:query];
}




- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                    completion:(void (^)(NSArray *, NSError *))completionHandler {
   NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
    endDate:endDate
    options:HKQueryOptionStrictStartDate];
        // Create the query
     HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType: quantityType
                                                              predicate: predicate
                                                                  limit: 0
                                                        sortDescriptors: nil
                                                         resultsHandler:^(HKSampleQuery *query, NSArray* results, NSError *error){
                                                             
                                                             dispatch_sync(dispatch_get_main_queue(), ^{
                                                                 if (error) {
                                                                     
                                                                     NSLog(@"error");
                                                                     completionHandler(nil, nil);
                                                                     
                                                                 } else {
                                                                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                                                                     for(HKQuantitySample *samples in results)
                                                                     {
                                                                      [arr addObject:samples];
                                                                     }
                                                                     
                                                                     completionHandler(arr, nil);
                                                                 }
                                                             });
                                                         }
                               ];
       
       // execute query
       [self.healthStore executeQuery:query];
    };



- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                     ascending:(BOOL)asc
                                         limit:(NSUInteger)lim
                                    completion:(void (^)(NSArray *, NSError *))completionHandler {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:[NSDate date]];
    anchorComponents.hour = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"metadata.%K != YES", HKMetadataKeyWasUserEntered];
        // Create the query
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:predicate
                                                                                           options:HKStatisticsOptionCumulativeSum
                                                                                        anchorDate:anchorDate
                                                                                intervalComponents:interval];
    
        // Set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
                // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***", error.localizedDescription);
        }
        
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
        
        [results enumerateStatisticsFromDate:startDate
                                      toDate:endDate
                                   withBlock:^(HKStatistics *result, BOOL *stop) {
            
            HKQuantity *quantity = result.sumQuantity;
            if (quantity) {
                NSDate *startDate = result.startDate;
                NSDate *endDate = result.endDate;
                double value = [quantity doubleValueForUnit:unit];
                
                NSString *startDateString = [Fitnesskit buildISO8601StringFromDate:startDate];
                NSString *endDateString = [Fitnesskit buildISO8601StringFromDate:endDate];
                
                NSDictionary *elem = @{
                    @"value" : @(value),
                    @"startDate" : startDateString,
                };
                [data addObject:elem];
            }
        }];
            // is ascending by default
        if(asc == false) {
            [Fitnesskit reverseNSMutableArray:data];
        }
        
        if((lim > 0) && ([data count] > lim)) {
            NSArray* slicedArray = [data subarrayWithRange:NSMakeRange(0, lim)];
            NSError *err;
            completionHandler(slicedArray, err);
        } else {
            NSError *err;
            completionHandler(data, err);
        }
    };
    
    [self.healthStore executeQuery:query];
}


@end
