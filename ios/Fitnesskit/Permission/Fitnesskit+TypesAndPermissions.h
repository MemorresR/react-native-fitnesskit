
#import "Fitnesskit.h"

@interface Fitnesskit (TypesAndPermissions)

- (NSDictionary *)readPermsDict;
- (NSDictionary *)writePermsDict;
- (NSSet *)getReadPermsFromOptions:(NSArray *)options;
- (NSSet *)getWritePermsFromOptions:(NSArray *)options;
- (HKObjectType *)getWritePermFromString:(NSString *)string;
- (NSString *)getAuthorizationStatusString:(HKAuthorizationStatus)status;

@end
