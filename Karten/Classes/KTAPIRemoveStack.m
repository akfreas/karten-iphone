#import "KTAPIRemoveStack.h"
#import "Stack.h"
#import "User+Helpers.h"
@interface KTAPIRemoveStack ()
@property (nonatomic) Stack *stack;
@end

@implementation KTAPIRemoveStack

- (id)initWithStack:(Stack *)stack
{
    self = [super init];
    if (self) {
        self.stack = stack;
    }
    return self;
}

-  (NSString *)path
{
    return [NSString stringWithFormat:@"stacks/%@/", self.stack.serverID];
}

- (NSString *)HTTPMethod
{
    return @"DELETE";
}

@end
