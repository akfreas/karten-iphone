@class KTUser;
@interface KartenUserManager : NSObject

+ (void)logoutCurrentUser;
+ (void)logUserInWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(KTUser *))completionBlock failure:(void(^)(NSError *))failureBlock;
+ (void)getCurrentAuthenticatedUserWithCompletion:(void(^)(KTUser *))completion failure:(void(^)(NSError *))failure;

@end
