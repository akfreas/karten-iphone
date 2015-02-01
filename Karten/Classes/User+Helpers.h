#import "KTUser.h"
#import "JSONParsable.h"
#import "JSONSerializable.h"
#import "NSManagedObject+JSONSerializable.h"

@interface KTUser (Helpers) <JSONParsable, JSONSerializable>

+ (KTUser *)getOrCreateUserWithJSONDict:(NSDictionary *)JSON;
+ (KTUser *)mainUser;

- (NSString *)fullName;

@end
