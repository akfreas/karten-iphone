#import "KartenUserManager.h"
#import "User.h"
#import "User+Helpers.h"
#import "KartenNetworkClient.h"

#import "KTAPILoginUser.h"
#import "KTAPIGetUser.h"

#import "Karten-Swift.h"
#import "NotificationKeys.h"
#import "Stack+Helpers.h"

@implementation KartenUserManager

+ (void)logUserInWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(User *))completionBlock failure:(void(^)(NSError *))failureBlock
{
    KTAPILoginUser *loginUserAPI = [[KTAPILoginUser alloc] initWithUsername:username password:password];
    [KartenNetworkClient makeRequest:loginUserAPI
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [self unmarkMainUser];
                              [KartenSessionManager setToken:responseObject[@"token"]];
                              [self getCurrentAuthenticatedUserWithCompletion:completionBlock failure:failureBlock];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              failureBlock(error);
                          }];
}

+ (void)getCurrentAuthenticatedUserWithCompletion:(void(^)(User *))completion failure:(void(^)(NSError *))failure
{
    KTAPIGetUser *getUserCall = [KTAPIGetUser new];
    [KartenNetworkClient makeRequest:getUserCall
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, User *authedUser) {
                              authedUser.mainUser = @(YES);
                              [authedUser.managedObjectContext MR_saveToPersistentStoreAndWait];
                              completion(authedUser);
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              failure(error);
                          }];
}

+ (void)logoutCurrentUser
{
    [KartenSessionManager invalidateSession];
    [Stack removeAllStacksForUser:[User mainUser]];
    [self unmarkMainUser];
    [[NSNotificationCenter defaultCenter] postNotificationName:kKartenUserDidLogoutNotification object:nil];
}

+ (void)unmarkMainUser
{
    NSArray *mainUsers = [User MR_findByAttribute:@"mainUser" withValue:@(YES) inContext:[self ourContext]];
    [mainUsers enumerateObjectsUsingBlock:^(User *user, NSUInteger idx, BOOL *stop) {
        user.mainUser = @(NO);
    }];
    [[self ourContext] MR_saveToPersistentStoreAndWait];
}

+ (NSManagedObjectContext *)ourContext
{
    return [NSManagedObjectContext MR_contextForCurrentThread];
}

@end
