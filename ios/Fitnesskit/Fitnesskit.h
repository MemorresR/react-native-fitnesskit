#import <React/RCTBridgeModule.h>
#import <HealthKit/HealthKit.h>
#import <React/RCTUtils.h>
#import <React/RCTLog.h>
@interface Fitnesskit : NSObject <RCTBridgeModule>
@property (nonatomic) HKHealthStore *healthStore;
@property BOOL isSync;




- (void)isHealthKitAvailable:resolve:(RCTPromiseResolveBlock)resolveMethod reject:(RCTPromiseRejectBlock)reject;


@end
