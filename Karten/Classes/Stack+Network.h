#import "KTStack.h"
#import "KartenNetworkClient.h"
@class KTUser;

@interface KTStack (Network)
+ (void)syncStacksForUser:(KTUser *)user completion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure;
- (void)createStackOnServerWithCompletion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure;
- (void)removeMyStackOnServerWithCompletion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure;
@end
