#import "KartenAPICall.h"
@class KTUser;
@interface KTAPIGetUserStacks : NSObject <KartenAPICall>
- (id)initWithUser:(KTUser *)user;
@end
