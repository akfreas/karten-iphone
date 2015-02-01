#import "KTAPIShareStack.h"
#import "Stack.h"
#import "KTUser.h"

@interface KTAPIShareStack ()
@property (nonatomic) Stack *stack;
@property (nonatomic) NSArray *shareUsers;
@end

@implementation KTAPIShareStack

- (instancetype)initWithStack:(Stack *)stack shareUsers:(NSArray *)users
{
    self = [super init];
    if (self) {
        self.stack = stack;
        self.shareUsers = users;
    }
    return self;
}

- (void)setShareUsers:(NSArray *)shareUsers
{
    NSMutableArray *shareUserIDs = [NSMutableArray arrayWithArray:[self.stack.allowedUserServerIDs allObjects]];
    for (KTUser *user in shareUsers) {
        [shareUserIDs addObject:user.serverID];
    }
    _shareUsers = shareUserIDs;
}

- (NSString *)path
{
    return [NSString stringWithFormat:@"/stacks/%@/share/", self.stack.serverID];
}

- (NSDictionary *)params
{
    return @{@"allowed_users" : self.shareUsers};
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
