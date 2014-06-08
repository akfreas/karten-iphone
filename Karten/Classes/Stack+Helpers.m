#import "Stack+Helpers.h"
#import "StackServer.h"

@implementation Stack (Helpers)

- (NSString *)fullServerURL
{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", self.server.serverURL, self.serverStackName];
    return URLString;
}


@end
