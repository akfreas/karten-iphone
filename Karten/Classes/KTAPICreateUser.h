#import "KartenAPICall.h"
@class User;
@interface KTAPICreateUser : NSObject <KartenAPICall>

- (id)initWithUser:(User *)user;
@end
