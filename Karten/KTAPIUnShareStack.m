#import "KTAPIUnShareStack.h"
#import "KTUser.h"
#import "Stack.h"

@interface KTAPIUnShareStack ()
@property (nonatomic) Stack *stack;
@property (nonatomic) NSArray *unShareUsers;
@end

@implementation KTAPIUnShareStack

- (instancetype)initWithStack:(Stack *)stack unShareUsers:(NSArray *)users
{
    self = [super init];
    if (self) {
        self.stack = stack;
        self.unShareUsers = users;
    }
    return self;
}

- (void)setUnShareUsers:(NSArray *)shareUsers
{
    NSMutableArray *shareUserIDs = [NSMutableArray arrayWithArray:[self.stack.allowedUserServerIDs allObjects]];
    for (KTUser *user in shareUsers) {
        [shareUserIDs removeObject:user.serverID];
    }
    _unShareUsers = shareUserIDs;
}

- (NSString *)path
{
    return [NSString stringWithFormat:@"/stacks/%@/share", self.stack.serverID];
}

- (NSDictionary *)params
{
    return @{@"allowed_users" : self.unShareUsers};
}

- (Class)classToParse
{
    return [KTUser class];
}

- (NSString *)HTTPMethod
{
    return @"POST";
}
@end
