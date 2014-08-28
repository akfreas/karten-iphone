#import "KTAPICreateUser.h"
#import "User.h"
#import "User+Helpers.h"

@interface KTAPICreateUser ()
@property (nonatomic) User *user;
@end

@implementation KTAPICreateUser

- (id)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
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
    return [self.user JSONDictionarySerialization];
}

- (Class)classToParse
{
    return [User class];
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
