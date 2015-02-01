#import "KartenAPICall.h"
@class KTUser;
@interface KTAPIGetUserFriends : NSObject <KartenAPICall>
- (instancetype)initWithUser:(KTUser *)user;
@end
