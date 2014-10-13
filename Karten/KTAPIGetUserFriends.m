#import "KTAPIGetUserFriends.h"
#import "User.h"

@interface KTAPIGetUserFriends ()
@property (nonatomic) User *user;
@end

@implementation KTAPIGetUserFriends

- (instancetype)initWithUser:(User *)user
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
    return [User class];
}

- (NSString *)HTTPMethod
{
    return @"GET";
}

@end
