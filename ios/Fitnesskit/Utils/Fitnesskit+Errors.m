

#import "Fitnesskit+Errors.h"

NSString * const RCT_ERROR_HK_NOT_AVAILABLE     = @"Health Kit not available";
NSString * const RCT_ERROR_METHOD_NOT_AVAILABLE = @"Method not available";
NSString * const RCT_ERROR_DATE_NOT_CORRECT     = @"Date not correct";
NSString * const RCT_ERROR_NO_EVENTS            = @"No events found";
NSString * const RCT_ERROR_EMPTY_PERMISSIONS    = @"At least one permission must be request";
NSString * const RCT_ERROR_NOINIT_PERMISSIONS    = @"permissions must be provided in the initialization options";

 NSString *const RCTErrorDomain = @"com.HealthBeacon";

@implementation Fitnesskit(Errors)

+(NSError*)createErrorWithCode:(NSInteger)code andDescription:(NSString*)description
{
    NSString *safeDescription = (description == nil) ? @"" : description;
    return [NSError errorWithDomain:RCTErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: safeDescription}];
}

+(void)handleRejectBlock:(RCTPromiseRejectBlock)reject error:(NSError*)error
{
    reject([NSString stringWithFormat: @"%ld", (long)error.code], error.localizedDescription, error);
}

@end


