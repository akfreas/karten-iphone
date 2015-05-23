#import "KTStack.h"
#import "JSONParsable.h"
#import "JSONSerializable.h"
@class KTUser;
@interface KTStack (Helpers) <JSONParsable, JSONSerializable>

- (NSString *)fullServerURL;
+ (void)removeAllStacksForUser:(KTUser *)user;
@end
