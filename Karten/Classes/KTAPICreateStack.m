#import "KTAPICreateStack.h"
#import "Stack.h"
#import "Stack+Helpers.h"
#import "NSManagedObject+JSONSerializable.h"

@interface KTAPICreateStack ()
@property (nonatomic) Stack *stack;
@end

@implementation KTAPICreateStack

- (id)initWithStack:(Stack *)stack
{
    self = [super init];
    if (self) {
        _stack = stack;
    }
    return self;
}

- (NSString *)path
{
    return @"stacks/";
}

- (Class)classToParse
{
    return [Stack class];
}

- (NSDictionary *)params
{
    NSDictionary *dict = [self.stack JSONDictionarySerialization];
    return dict;
}

- (BOOL)updateOriginalObjectOnReturn
{
    return YES;
}

- (NSManagedObjectID *)objectID
{
    return self.stack.objectID;
}

- (NSString *)HTTPMethod
{
    return @"POST";
}

@end
