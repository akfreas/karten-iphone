#import "Stack.h"
#import "JSONParsable.h"
#import "JSONSerializable.h"
@class User;
@interface Stack (Helpers) <JSONParsable, JSONSerializable>

- (NSString *)fullServerURL;
+ (void)removeAllStacksForUser:(User *)user;
@end
