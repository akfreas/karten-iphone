#import "KTAPIRemoveStack.h"
#import "KTStack.h"
#import "User+Helpers.h"
@interface KTAPIRemoveStack ()
@property (nonatomic) KTStack *stack;
@end

@implementation KTAPIRemoveStack

- (id)initWithStack:(KTStack *)stack
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
