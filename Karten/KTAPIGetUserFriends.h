#import "KartenAPICall.h"
@class User;
@interface KTAPIGetUserFriends : NSObject <KartenAPICall>
- (instancetype)initWithUser:(User *)user;
@end
