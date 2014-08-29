@class User;
@interface KartenUserManager : NSObject

+ (void)logUserInWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(User *))completionBlock failure:(void(^)(NSError *))failureBlock;
+ (void)getCurrentAuthenticatedUserWithCompletion:(void(^)(User *))completion failure:(void(^)(NSError *))failure;

@end
