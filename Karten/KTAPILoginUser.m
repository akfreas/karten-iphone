#import "KTAPILoginUser.h"

@interface KTAPILoginUser ()

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end

@implementation KTAPILoginUser

- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}

- (NSString *)path
{
    return @"api-token-auth/";
}

- (NSDictionary *)params
{
    return @{@"username" : self.username, @"password" : self.password};
}

- (NSString *)HTTPMethod
{
    return @"POST";
}


@end
