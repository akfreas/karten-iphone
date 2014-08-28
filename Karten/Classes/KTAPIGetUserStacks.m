#import "KTAPIGetUserStacks.h"
#import "User.h"
#import "Stack.h"

@interface KTAPIGetUserStacks ()
@property (nonatomic) User *user;
@end

@implementation KTAPIGetUserStacks

- (id)initWithUser:(User *)user
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
