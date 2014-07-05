#import "KTAPIAddUserToStack.h"
#import "Stack.h"
@interface KTAPIAddUserToStack ()
@property (nonatomic) Stack *stack;
@property (nonatomic) NSString *userID;
@end

@implementation KTAPIAddUserToStack

- (id)initWithStack:(Stack *)stack linkToUserID:(NSString *)userID
{
    self = [super init];
    if (self) {
        self.stack = stack;
        self.userID = userID;
    }
    return self;
}

- (NSString *)path
{
    return [NSString stringWithFormat:@"stack/%@/user/%@/add", self.stack.serverID, self.userID];
}

- (Class)classToParse
{
    return [Stack class];
}

@end
