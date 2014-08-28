#import "Stack.h"
#import "KartenNetworkClient.h"
@class User;

@interface Stack (Network)
+ (void)syncStacksForUser:(User *)user completion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure;
- (void)createStackOnServerWithCompletion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure;
- (void)removeMyStackOnServerWithCompletion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure;
@end
