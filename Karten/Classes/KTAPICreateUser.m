#import "KTAPICreateUser.h"
#import "KTUser.h"
#import "User+Helpers.h"

@interface KTAPICreateUser ()
@property (nonatomic) KTUser *user;
@property (nonatomic) NSString *password;
@end

@implementation KTAPICreateUser

- (id)initWithUser:(KTUser *)user password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.password = password;
        self.user = user;
    }
    return self;
}

- (NSString *)path
{
    return @"users/";
}

- (NSDictionary *)params
{
    NSMutableDictionary *ourParams = [[self.user JSONDictionarySerialization] mutableCopy];
    ourParams[@"password"] = self.password;
    return ourParams;
}

- (Class)classToParse
{
    return [KTUser class];
}

- (NSManagedObjectID *)objectID
{
    return self.user.objectID;
}

- (BOOL)updateOriginalObjectOnReturn
{
    return YES;
}

- (NSString *)HTTPMethod
{
    return @"POST";
}

@end
