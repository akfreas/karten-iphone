#import "KTAPIGetUserFriends.h"
#import "KTUser.h"

@interface KTAPIGetUserFriends ()
@property (nonatomic) KTUser *user;
@end

@implementation KTAPIGetUserFriends

- (instancetype)initWithUser:(KTUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (NSString *)path
{
    return [NSString stringWithFormat:@"user/%@/friends/", self.user.serverID];
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
