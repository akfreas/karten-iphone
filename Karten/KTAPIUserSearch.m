#import "KTAPIUserSearch.h"
#import "User.h"

@interface KTAPIUserSearch ()
@property (nonatomic) NSString *queryString;
@end

@implementation KTAPIUserSearch

- (instancetype)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        self.queryString = query;
    }
    return self;
}

- (NSString *)path
{
    return @"/users/search/";
}

- (NSDictionary *)params
{
    return @{@"q" : self.queryString};
}

- (NSString *)HTTPMethod
{
    return @"GET";
}

- (Class)classToParse
{
    return [User class];
}

@end
