#import "KartenAPICall.h"
@class KTUser;
@interface KTAPICreateUser : NSObject <KartenAPICall>

- (id)initWithUser:(KTUser *)user password:(NSString *)password;
@end
