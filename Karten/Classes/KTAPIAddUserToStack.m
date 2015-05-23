#import "KTAPIAddUserToStack.h"
#import "KTStack.h"
@interface KTAPIAddUserToStack ()
@property (nonatomic) KTStack *stack;
@property (nonatomic) NSString *userID;
@end

@implementation KTAPIAddUserToStack

- (id)initWithStack:(KTStack *)stack linkToUserID:(NSString *)userID
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
    return [KTStack class];
}

@end
