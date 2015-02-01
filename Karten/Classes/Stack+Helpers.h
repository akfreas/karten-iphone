#import "Stack.h"
#import "JSONParsable.h"
#import "JSONSerializable.h"
@class KTUser;
@interface Stack (Helpers) <JSONParsable, JSONSerializable>

- (NSString *)fullServerURL;
+ (void)removeAllStacksForUser:(KTUser *)user;
@end
