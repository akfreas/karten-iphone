#import "KTAPIGetUserStacks.h"
#import "KTUser.h"
#import "Stack.h"

@interface KTAPIGetUserStacks ()
@property (nonatomic) KTUser *user;
@end

@implementation KTAPIGetUserStacks

- (id)initWithUser:(KTUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (NSString *)path
{
    return [NSString stringWithFormat:@"stacks/"];
}

- (Class)classToParse
{
    return [Stack class];
}

- (NSString *)HTTPMethod
{
    return @"GET";
}

@end
