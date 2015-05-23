#import "KTAPIGetUserStacks.h"
#import "KTUser.h"
#import "KTStack.h"

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
    return [KTStack class];
}

- (NSString *)HTTPMethod
{
    return @"GET";
}

@end
