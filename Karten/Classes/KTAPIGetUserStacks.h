#import "KartenAPICall.h"
@class User;
@interface KTAPIGetUserStacks : NSObject <KartenAPICall>
- (id)initWithUser:(User *)user;
@end
