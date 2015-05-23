#import "KartenUserManager.h"
#import "KTUser.h"
#import "User+Helpers.h"
#import "KartenNetworkClient.h"

#import "KTAPILoginUser.h"
#import "KTAPIGetUser.h"

#import "Karten-Swift.h"
#import "NotificationKeys.h"
#import "Stack+Helpers.h"

@implementation KartenUserManager

+ (void)logUserInWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(KTUser *))completionBlock failure:(void(^)(NSError *))failureBlock
{
    KTAPILoginUser *loginUserAPI = [[KTAPILoginUser alloc] initWithUsername:username password:password];
    [KartenNetworkClient makeRequest:loginUserAPI
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [self unmarkMainUser];
                              [KartenSessionManager setToken:responseObject[@"token"]];
                              [self getCurrentAuthenticatedUserWithCompletion:completionBlock failure:failureBlock];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
                              failureBlock(error);
                          }];
}

+ (void)getCurrentAuthenticatedUserWithCompletion:(void(^)(KTUser *))completion failure:(void(^)(NSError *))failure
{
    KTAPIGetUser *getUserCall = [KTAPIGetUser new];
    [KartenNetworkClient makeRequest:getUserCall
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, KTUser *authedUser) {
                              authedUser.mainUser = @(YES);
                              [authedUser.managedObjectContext MR_saveToPersistentStoreAndWait];
                              completion(authedUser);
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
                              failure(error);
                          }];
}

+ (void)logoutCurrentUser
{
    [KartenSessionManager invalidateSession];
    [KTStack removeAllStacksForUser:[KTUser mainUser]];
    [self unmarkMainUser];
    [[NSNotificationCenter defaultCenter] postNotificationName:kKartenUserDidLogoutNotification object:nil];
}

+ (void)unmarkMainUser
{
    NSArray *mainUsers = [KTUser MR_findByAttribute:@"mainUser" withValue:@(YES) inContext:[self ourContext]];
    [mainUsers enumerateObjectsUsingBlock:^(KTUser *user, NSUInteger idx, BOOL *stop) {
        user.mainUser = @(NO);
    }];
    [[self ourContext] MR_saveToPersistentStoreAndWait];
}

+ (NSManagedObjectContext *)ourContext
{
    return [NSManagedObjectContext MR_contextForCurrentThread];
}

@end
