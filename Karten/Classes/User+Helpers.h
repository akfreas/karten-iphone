#import "User.h"
#import "JSONParsable.h"
#import "JSONSerializable.h"
#import "NSManagedObject+JSONSerializable.h"

@interface User (Helpers) <JSONParsable, JSONSerializable>

+ (User *)getOrCreateUserWithJSONDict:(NSDictionary *)JSON;
+ (User *)mainUser;

@end
