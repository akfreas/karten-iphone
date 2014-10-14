#import "KTAPIShareStack.h"
#import "Stack.h"
#import "User.h"

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
    NSMutableArray *shareUserIDs = [NSMutableArray new];
    for (User *user in shareUsers) {
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
    return @{@"user_ids" : self.shareUsers};
}

- (Class)classToParse
{
    return [User class];
}

- (NSString *)HTTPMethod
{
    return @"POST";
}

@end
