
#import "Fitnesskit.h"

extern NSString * _Nonnull const RCT_ERROR_HK_NOT_AVAILABLE;
extern NSString * _Nonnull const RCT_ERROR_METHOD_NOT_AVAILABLE;
extern NSString * _Nonnull const RCT_ERROR_DATE_NOT_CORRECT;
extern NSString * _Nonnull const RCT_ERROR_NO_EVENTS;
extern NSString * _Nonnull const RCT_ERROR_EMPTY_PERMISSIONS;
extern NSString * _Nonnull const RCT_ERROR_NOINIT_PERMISSIONS;

typedef NS_ENUM(NSInteger, FitnesskitError)
{
    ErrorHKNotAvailable   = -100,
    ErrorMethodNotAvailable,
    ErrorDateNotCorrect,
    ErrorNoEvents,
    ErrorEmptyPermissions,
    ErrorNoInitPermissions,
};

NS_ASSUME_NONNULL_BEGIN

@interface Fitnesskit(Errors)
+(NSError*)createErrorWithCode:(NSInteger)code andDescription:(NSString*)description;
+(void)handleRejectBlock:(RCTPromiseRejectBlock)reject error:(NSError*)error;
@end

NS_ASSUME_NONNULL_END

