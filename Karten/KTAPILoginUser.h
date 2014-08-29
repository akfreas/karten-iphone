#import "KartenAPICall.h"

@interface KTAPILoginUser : NSObject <KartenAPICall>
- (id)initWithUsername:(NSString *)username password:(NSString *)password;
@end
