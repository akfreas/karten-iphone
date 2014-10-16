#import "FriendsListSearchUpdater.h"
#import "KartenNetworkClient.h"
#import "KTAPIUserSearch.h"

@interface FriendsListSearchUpdater ()
@property (nonatomic) NSMutableArray *userResults;
@end

@implementation FriendsListSearchUpdater

- (void)searchForUsernameWithString:(NSString *)query completionBlock:(void(^)(NSArray *))completion
{
    KTAPIUserSearch *userSearch = [[KTAPIUserSearch alloc] initWithQuery:query];
    [KartenNetworkClient makeRequest:userSearch completion:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userResults = responseObject;
        completion(self.userResults);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
        
    }];
}

@end
