#import "KTAPIGetUser.h"
#import "User.h"

@implementation KTAPIGetUser

- (NSString *)path
{
    return @"users/me/";
}

- (Class)classToParse
{
    return [User class];
}

- (NSString *)HTTPMethod
{
    return @"GET";
}

@end
