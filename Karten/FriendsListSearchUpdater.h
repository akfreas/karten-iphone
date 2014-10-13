#import <Foundation/Foundation.h>

@interface FriendsListSearchUpdater : NSObject
- (void)searchForUsernameWithString:(NSString *)query completionBlock:(void(^)(NSArray *))completion;
@end
