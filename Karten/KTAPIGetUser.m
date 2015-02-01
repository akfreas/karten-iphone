#import "KTAPIGetUser.h"
#import "KTUser.h"

@implementation KTAPIGetUser

- (NSString *)path
{
    return @"users/me/";
}

- (Class)classToParse
{
    return [KTUser class];
}

- (NSString *)HTTPMethod
{
    return @"GET";
}

@end
