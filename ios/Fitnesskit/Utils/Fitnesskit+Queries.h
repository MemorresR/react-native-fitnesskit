
#import "Fitnesskit.h"

@interface Fitnesskit (Queries)

- (void)fetchMostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(HKQuantity *mostRecentQuantity, NSDate *startDate, NSDate *endDate, NSError *error))completion;


- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double, NSError *))completionHandler;


- (void)fetchSumOfSamplesOnDayForType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                            startDate:(NSDate *)startDate
                              endDate:(NSDate *)endDate
                           completion:(void (^)(NSArray *, NSError *))completionHandler;

- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                    completion:(void (^)(NSArray *, NSError *))completionHandler;


- (void)fetchStepsCount:(HKQuantityType *)quantityType
                   unit:(HKUnit *)unit
              startDate:(NSDate *)startDate
                endDate:(NSDate *)endDate
             completion:(void (^)(NSDictionary *, NSError *))completionHandler;
- (void)fetchEnergy:(HKQuantityType *)quantityType
                              unit:(HKUnit *)unit
                         predicate:(NSPredicate *)predicate
                         ascending:(BOOL)asc
                             limit:(NSUInteger)lim
                        completion:(void (^)(NSArray *, NSError *))completion;

- (void)fetchDistance:(HKSampleType *)quantityType
                 unit:(HKUnit *)unit
            predicate:(NSPredicate *)predicate
            ascending:(BOOL)asc
                limit:(NSUInteger)lim
           completion:(void (^)(NSArray *, NSError *))completion;
- (void)setObserverForType:(HKSampleType *)quantityType
                      unit:(HKUnit *)unit;


- (void)fetchHeartRateQuantity:(HKQuantityType *)quantityType
                          unit:(HKUnit *)unit
                     predicate:(NSPredicate *)predicate
                     ascending:(BOOL)asc
                         limit:(NSUInteger)lim
                    completion:(void (^)(NSArray *, NSError *))completion;


- (void)fetchCategorySamplesOfType:(HKCategoryType *)categoryType
                              unit:(HKUnit *)unit
                         predicate:(NSPredicate *)predicate
                         ascending:(BOOL)asc
                             limit:(NSUInteger)lim
                        completion:(void (^)(NSArray *, NSError *))completion;


- (void)fetchCorrelationSamplesOfType:(HKQuantityType *)quantityType
                                 unit:(HKUnit *)unit
                            predicate:(NSPredicate *)predicate
                            ascending:(BOOL)asc
                                limit:(NSUInteger)lim
                           completion:(void (^)(NSArray *, NSError *))completion;


- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                     ascending:(BOOL)asc
                                         limit:(NSUInteger)lim
                                    completion:(void (^)(NSArray *, NSError *))completionHandler;


- (void)fetchCumulativeSumStatisticsCollection:(HKQuantityType *)quantityType
                                          unit:(HKUnit *)unit
                                        period:(NSUInteger)period
                                     startDate:(NSDate *)startDate
                                       endDate:(NSDate *)endDate
                                     ascending:(BOOL)asc
                                         limit:(NSUInteger)lim
                          includeManuallyAdded:(BOOL)includeManuallyAdded
                                    completion:(void (^)(NSArray *, NSError *))completionHandler;


- (void)fetchSleepCategorySamplesForPredicate:(NSPredicate *)predicate
                                        limit:(NSUInteger)lim
                                   completion:(void (^)(NSArray *, NSError *))completion;

- (void)fetchSleep:(HKSampleType *)quantityType
                         predicate:(NSPredicate *)predicate
                         ascending:(BOOL)asc
                             limit:(NSUInteger)lim
                        completion:(void (^)(NSArray *, NSError *))completion;

@end
