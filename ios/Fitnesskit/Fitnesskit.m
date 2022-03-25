#import "Fitnesskit.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import "Fitnesskit+TypesAndPermissions.h"
#import "Fitnesskit+Methods_Steps.h"
#import "Fitnesskit+Methods_HeartRate.h"
#import "Fitnesskit+Methods_Distance.h"
#import "Fitnesskit+Methods_Energy.h"
#import "Fitnesskit+Methods_Sleep.h"
#import "Fitnesskit+Errors.h"

@implementation Fitnesskit
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

/* Check HK available*/
/*Initilize HK*/
RCT_REMAP_METHOD(isAuthorized,withInput:(NSDictionary *)input withAvailableResolver:(RCTPromiseResolveBlock)resolve
andAvailableRejecter:(RCTPromiseRejectBlock)reject)
{
    [self isHealthKitAvailable:resolve:resolve reject:reject];
}

/*Initilize HK*/
RCT_REMAP_METHOD(requestPermissions,withInput:(NSDictionary *)input withAuthorizedResolver:(RCTPromiseResolveBlock)resolve
                 andAuthorizedRejecter:(RCTPromiseRejectBlock)reject)
{
    [self initializeHealthKit:input resolve:resolve reject:reject];
}

/*Get step count*/
RCT_REMAP_METHOD(getStepCount,withInput:(NSDictionary *)input withStepResolver:(RCTPromiseResolveBlock)resolve
                 andStepRejecter:(RCTPromiseRejectBlock)reject)
{
    [self fitnessGetStepCount:input resolve:resolve reject:reject];
}

/*Get heart rate*/
RCT_REMAP_METHOD(getHeartRate,withInput:(NSDictionary *)input withHeartResolver:(RCTPromiseResolveBlock)resolve
                 andHeartRejecter:(RCTPromiseRejectBlock)reject)
{
    [self fitnessGetHeartRate:input resolve:resolve reject:reject];
}

/*Get Distance*/
RCT_REMAP_METHOD(getDistance,withInput:(NSDictionary *)input withDistanceResolver:(RCTPromiseResolveBlock)resolve
                 andDistanceRejecter:(RCTPromiseRejectBlock)reject)
{
    [self fitnessGetDistance:input resolve:resolve reject:reject];
}


/*Get energy*/
RCT_REMAP_METHOD(getEnergyCount,withInput:(NSDictionary *)input withEnergyResolver:(RCTPromiseResolveBlock)resolve
                 andEnergyRejecter:(RCTPromiseRejectBlock)reject)
{
    [self fitnessGetEnergy:input resolve:resolve reject:reject];
}


/*Get sleep*/
RCT_REMAP_METHOD(getSleepData,withInput:(NSDictionary *)input withSleepResolver:(RCTPromiseResolveBlock)resolve
                 andSleepRejecter:(RCTPromiseRejectBlock)reject)
{
    [self fitnessGetSleepData:input resolve:resolve reject:reject];
}


    // check if HealthData is available
-(void)isHealthKitAvailable:resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    BOOL isAvailable = NO;
    if ([HKHealthStore isHealthDataAvailable]) {
        isAvailable = YES;
    }
    NSLog( @"text: %@", @(isAvailable) );
    resolve(@[@(isAvailable)]);
}

- (void)initializeHealthKit:(NSDictionary *)input resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject
{
    @try{
        self.healthStore = [[HKHealthStore alloc] init];
        
        if ([HKHealthStore isHealthDataAvailable]) {
            NSSet *writeDataTypes;
            NSSet *readDataTypes;
            
                // get permissions from input object provided by JS options argument
            NSDictionary* permissions =[input objectForKey:@"permissions"];
            if(permissions != nil){
                NSArray* readPermsArray = [permissions objectForKey:@"read"];
                NSArray* writePermsArray = [permissions objectForKey:@"write"];
                NSSet* readPerms = [self getReadPermsFromOptions:readPermsArray];
                NSSet* writePerms = [self getWritePermsFromOptions:writePermsArray];
                
                if(readPerms != nil) {
                    readDataTypes = readPerms;
                }
                if(writePerms != nil) {
                    writeDataTypes = writePerms;
                }
            } else {
                NSError * error = [Fitnesskit createErrorWithCode:ErrorNoInitPermissions andDescription:RCT_ERROR_NOINIT_PERMISSIONS];
                [Fitnesskit handleRejectBlock:reject error:error];
                return;
            }
            
                // make sure at least 1 read or write permission is provided
            if(!writeDataTypes && !readDataTypes){
                NSError * error = [Fitnesskit createErrorWithCode:ErrorEmptyPermissions andDescription:RCT_ERROR_EMPTY_PERMISSIONS];
                [Fitnesskit handleRejectBlock:reject error:error];
                return;
            }
            
            [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                if (!success) {
                    NSError * error = [Fitnesskit createErrorWithCode:ErrorNoEvents andDescription:RCT_ERROR_EMPTY_PERMISSIONS];
                    [Fitnesskit handleRejectBlock:reject error:error];
                    return;
                } else {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        resolve(@true);
                    });
                }
            }];
        } else {
            NSError * error = [Fitnesskit createErrorWithCode:ErrorHKNotAvailable andDescription:RCT_ERROR_HK_NOT_AVAILABLE];
            [Fitnesskit handleRejectBlock:reject error:error];
        }
    }@catch (NSError *error) {
        [Fitnesskit handleRejectBlock:reject error: error];
    }
    
}
@end

