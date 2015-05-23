#import "Stack+Helpers.h"
#import "StackServer.h"
#import "KTUser.h"
#import "User+Helpers.h"
#import "Karten-Swift.h"

@implementation KTStack (Helpers)

- (NSString *)fullServerURL
{
    NSString *URLString = [NSString stringWithFormat:@"%@://%@:%@@%@:%@/%@/", self.server.protocol, [KTUser mainUser].username, [KartenSessionManager getToken], self.server.host, self.server.port, self.serverStackName];
    return URLString;
}

+ (void)removeAllStacksForUser:(KTUser *)user
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ownerServerID == %@", user.serverID];
    [KTStack MR_deleteAllMatchingPredicate:pred];
}


@end
