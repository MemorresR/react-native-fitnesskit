
#import "Fitnesskit+TypesAndPermissions.h"

@implementation Fitnesskit (TypesAndPermissions)


#pragma mark - HealthKit Permissions

- (NSDictionary *)readPermsDict {
    NSDictionary *readPerms = @{
        @"Steps" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
        @"StepCount" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
        @"HeartRate" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
        @"DistanceWalkingRunning" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
        @"DistanceCycling" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
        @"DistanceSwimming" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming],
        @"ActiveEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
        @"BasalEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned],
        @"DietaryEnergy" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
        @"SleepAnalysis" : [HKObjectType categoryTypeForIdentifier: HKCategoryTypeIdentifierSleepAnalysis],
    };
    return readPerms;
}


- (NSDictionary *)writePermsDict {
    NSDictionary *writePerms = @{
        // Body Measurements
        @"Steps" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
        @"StepCount" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
        @"HeartRate" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
        @"DistanceWalkingRunning" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
        @"DistanceCycling" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
        @"DistanceSwimming" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming],
        @"ActiveEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
        @"BasalEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned],
        @"DietaryEnergy" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
        @"BodyMass" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
            
    };
    return writePerms;
}

// Returns HealthKit read permissions from options array
- (NSSet *)getReadPermsFromOptions:(NSArray *)options {
    NSDictionary *readPermDict = [self readPermsDict];
    NSMutableSet *readPermSet = [NSMutableSet setWithCapacity:1];

    for(int i=0; i<[options count]; i++) {
        NSString *optionKey = options[i];
        HKObjectType *val = [readPermDict objectForKey:optionKey];
        if(val != nil) {
            [readPermSet addObject:val];
        }
    }
    return readPermSet;
}


// Returns HealthKit write permissions from options array
- (NSSet *)getWritePermsFromOptions:(NSArray *)options {
    NSDictionary *writePermDict = [self writePermsDict];
    NSMutableSet *writePermSet = [NSMutableSet setWithCapacity:1];

    for(int i=0; i<[options count]; i++) {
        NSString *optionKey = options[i];
        HKObjectType *val = [writePermDict objectForKey:optionKey];
        if(val != nil) {
            [writePermSet addObject:val];
        }
    }
    return writePermSet;
}

- (HKObjectType *)getWritePermFromString:(NSString *)writePerm {
    return [[self writePermsDict] objectForKey:writePerm];
}
- (NSString *)getAuthorizationStatusString:(HKAuthorizationStatus)status {
    switch (status) {
        case HKAuthorizationStatusNotDetermined:
            return @"NotDetermined";
        case HKAuthorizationStatusSharingDenied:
            return @"SharingDenied";
        case HKAuthorizationStatusSharingAuthorized:
            return @"SharingAuthorized";
    }
}

@end
